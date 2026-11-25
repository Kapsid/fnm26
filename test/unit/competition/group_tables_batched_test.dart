import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// The group-table reads fetch every group's members and fixtures in two
/// queries instead of two per group. Their output must match the old
/// per-group reads exactly: same groups, same order, same standings
/// (tie-breaks included, which hang on input order).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('batched group tables equal the per-group reads', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final (:careerId, :nationId) = await _aCareer(db);

    // A fresh career draws World Championship qualifying lazily, so lay two
    // confederations' worth down by hand: groups saved out of name order,
    // members out of id order, so both orderings are exercised.
    final cycle = (await (db.select(
      db.careers,
    )..where((t) => t.id.equals(careerId))).getSingle()).cyclePointer;
    final pool = [
      for (final n in await db.select(db.nations).get())
        if (n.id != nationId) n.id,
    ]..shuffle(Random(3));
    GeneratedGroup group(String name, List<int> ids) => GeneratedGroup(
      name: name,
      nationIds: ids,
      fixtures: [
        for (var i = 0; i < ids.length; i++)
          for (var j = 0; j < ids.length; j++)
            if (i != j)
              GeneratedFixture(
                matchday: 1 + (i + j) % 3,
                date: DateTime(2031, 3, 1 + i * 4 + j),
                homeNationId: ids[i],
                awayNationId: ids[j],
              ),
      ],
    );
    await repo.saveSchedule(
      careerId: careerId,
      cycle: cycle,
      schedule: GeneratedSchedule(
        confederation: Confederation.europe,
        name: 'Euro WCQ',
        groups: [
          group('C', pool.sublist(0, 4)),
          group('A', pool.sublist(4, 9)),
          group('B', pool.sublist(9, 13)),
        ],
      ),
    );
    await repo.saveSchedule(
      careerId: careerId,
      cycle: cycle,
      schedule: GeneratedSchedule(
        confederation: Confederation.asia,
        name: 'Asia WCQ',
        groups: [
          group('B', pool.sublist(13, 17)),
          group('A', pool.sublist(17, 21)),
        ],
      ),
    );

    // Results for the first matchdays, low scores so ties are common.
    final rng = Random(11);
    final grouped = await (db.select(
      db.fixtures,
    )..where((t) => t.careerId.equals(careerId) & t.groupId.isNotNull())).get();
    expect(grouped, isNotEmpty);
    for (final f in grouped) {
      if (f.matchday > 2) continue;
      await (db.update(db.fixtures)..where((t) => t.id.equals(f.id))).write(
        FixturesCompanion(
          played: const Value(true),
          homeScore: Value(rng.nextInt(3)),
          awayScore: Value(rng.nextInt(3)),
        ),
      );
    }

    // --- The old reads, group by group. ---
    Future<List<GroupStanding>> oldTable(int groupId) async {
      final members = await (db.select(
        db.groupMembers,
      )..where((t) => t.groupId.equals(groupId))).get();
      final fixtures = await (db.select(
        db.fixtures,
      )..where((t) => t.groupId.equals(groupId))).get();
      return GroupStanding.table(
        members.map((m) => m.nationId).toList(),
        fixtures.map((r) => r.toDomain()).toList(),
      );
    }

    Future<List<QualifyingGroupRow>> groupsOf(int compId) =>
        (db.select(db.qualifyingGroups)
              ..where((t) => t.competitionId.equals(compId))
              ..orderBy([(t) => OrderingTerm(expression: t.name)]))
            .get();

    final career = await (db.select(
      db.careers,
    )..where((t) => t.id.equals(careerId))).getSingle();
    final wcComps =
        await (db.select(db.competitions)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(career.cyclePointer) &
                    t.kind.equalsValue(CompetitionKind.worldCupQualifying),
              )
              ..orderBy([(t) => OrderingTerm(expression: t.id)]))
            .get();
    expect(wcComps.length, greaterThan(1));
    final oldByConf = <String>[];
    for (final c in wcComps) {
      for (final g in await groupsOf(c.id)) {
        oldByConf.add(
          '${c.confederation.name}|${g.name}|${_show(await oldTable(g.id))}',
        );
      }
    }

    // allGroupTablesByConfederation, unfiltered and per confederation.
    final byConf = await repo.allGroupTablesByConfederation(careerId);
    expect([
      for (final t in byConf)
        '${t.confederation.name}|${t.groupName}|${_show(t.standings)}',
    ], oldByConf);
    for (final conf in Confederation.values) {
      final one = await repo.allGroupTablesByConfederation(
        careerId,
        confederation: conf,
      );
      expect(
        [
          for (final t in one)
            '${t.confederation.name}|${t.groupName}|${_show(t.standings)}',
        ],
        [
          for (final o in oldByConf)
            if (o.startsWith('${conf.name}|')) o,
        ],
      );
    }

    // allGroupTables: the save's first competition.
    final first =
        await (db.select(db.competitions)
              ..where((t) => t.careerId.equals(careerId))
              ..limit(1))
            .getSingle();
    final firstGroups = await groupsOf(first.id);
    expect(
      [
        for (final t in await repo.allGroupTables(careerId))
          '${t.groupId}|${t.name}|${t.groupCount}|${_show(t.standings)}',
      ],
      [
        for (final g in firstGroups)
          '${g.id}|${g.name}|${firstGroups.length}|'
              '${_show(await oldTable(g.id))}',
      ],
    );

    // _groupTables, through siblingGroupTables, for every competition.
    for (final c in wcComps) {
      final groups = await groupsOf(c.id);
      if (groups.isEmpty) continue;
      expect(
        [
          for (final t in await repo.siblingGroupTables(groups.first.id))
            '${t.name}|${_show(t.standings)}',
        ],
        [for (final g in groups) '${g.name}|${_show(await oldTable(g.id))}'],
      );
    }

    // lastRoundResults: every group of the manager's competition, with that
    // matchday's results.
    final rr = await repo.lastRoundResults(careerId, nationId);
    expect(rr, isNotNull);
    final played =
        await (db.select(db.fixtures)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.played.equals(true) &
                    (t.homeNationId.equals(nationId) |
                        t.awayNationId.equals(nationId)),
              )
              ..orderBy([
                (t) =>
                    OrderingTerm(expression: t.date, mode: OrderingMode.desc),
              ])
              ..limit(1))
            .getSingle();
    expect(played.groupId, isNotNull);
    final rrComp = played.competitionId;
    final rrGroups = await groupsOf(rrComp);
    final ownGroup = rrGroups.firstWhere((g) => g.id == played.groupId);
    final expected = <String, String>{};
    for (final g in rrGroups) {
      final fixtures = await (db.select(
        db.fixtures,
      )..where((t) => t.groupId.equals(g.id))).get();
      final round =
          fixtures
              .where((f) => f.matchday == rr!.matchday && f.played)
              .map((f) => f.id)
              .toList()
            ..sort();
      expected[g.name] = '${_show(await oldTable(g.id))}|$round';
    }
    final names = expected.keys.toList()
      ..sort((a, b) {
        if (a == ownGroup.name) return -1;
        if (b == ownGroup.name) return 1;
        return a.compareTo(b);
      });
    expect(
      [
        for (final g in rr!.groups)
          '${g.name}|${_show(g.standings)}|'
              '${g.fixtures.map((f) => f.id).toList()}',
      ],
      [for (final n in names) '$n|${expected[n]}'],
    );
  });
}

String _show(List<GroupStanding> rows) => [
  for (final r in rows)
    '${r.nationId}:${r.played}/${r.won}/${r.drawn}/${r.lost}/'
        '${r.goalsFor}-${r.goalsAgainst}',
].join(',');

Future<({int careerId, int nationId})> _aCareer(AppDatabase db) async {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  addTearDown(container.dispose);
  await container.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await container
              .read(careerServiceProvider)
              .create(nationId: nations.first.id, managerName: 'M'))
          .valueOrNull!;
  return (careerId: career.id, nationId: career.nationId);
}
