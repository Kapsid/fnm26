import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// The advance path's two hot writes were turned from a statement per player
/// into a statement per team sheet, and the player-of-the-year read was
/// narrowed to its year in SQL instead of in Dart. All three are meant to
/// write and return exactly what they wrote and returned before — this is the
/// test that says so, because a faster path that quietly counts differently is
/// a records bug, not an optimisation.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late CompetitionRepository comp;
  late int careerId;
  late int nationId;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    nationId = nations.firstWhere((n) => n.code == 'CZE').id;
    final career =
        (await container.read(careerServiceProvider).create(
              nationId: nationId,
              managerName: 'M',
              rngSeed: 4242,
            ))
            .valueOrNull!;
    careerId = career.id;
    comp = container.read(competitionRepositoryProvider);
  });

  test('a cap is logged once per man per match, and repeats still count', () async {
    // An ordinary team sheet: every man named once.
    await comp.recordAppearances(careerId, nationId, [11, 12, 13]);
    await comp.recordAppearances(careerId, nationId, [12, 13]);
    // A list that names the same man twice must still count him twice — the
    // per-row loop this replaced did, and one statement cannot touch a row
    // twice, so the repeat is split across statements rather than dropped.
    await comp.recordAppearances(careerId, nationId, [13, 13]);

    final caps = {
      for (final r in await comp.nationTopAppearances(careerId, nationId))
        r.playerId: r.games,
    };
    expect(caps[11], 1);
    expect(caps[12], 2);
    expect(caps[13], 4);
  });

  test('an empty team sheet writes nothing', () async {
    await comp.recordAppearances(careerId, nationId, const []);
    expect(await comp.nationTopAppearances(careerId, nationId), isEmpty);
  });

  test('tournament starts and appearances accumulate per competition', () async {
    final fixture = (await comp.allFixtures(careerId)).first;
    final competitionId = fixture.competitionId;
    await comp.recordTournamentAppearances(careerId, competitionId, [
      (playerId: 21, nationId: nationId, started: true),
      (playerId: 22, nationId: nationId, started: false),
    ]);
    await comp.recordTournamentAppearances(careerId, competitionId, [
      (playerId: 21, nationId: nationId, started: true),
      // Named twice in one call: two appearances, one of them a start.
      (playerId: 22, nationId: nationId, started: true),
      (playerId: 22, nationId: nationId, started: false),
    ]);

    // `careerStartsByPlayer` only banks FINISHED competitions, so this asserts
    // through the raw ledger instead: three appearances for 22, one a start.
    final rows = await db.customSelect(
      'SELECT player_id, starts, apps FROM tournament_appearances '
      'WHERE career_id = ? ORDER BY player_id',
      variables: [Variable.withInt(careerId)],
    ).get();
    expect(rows.length, 2);
    expect(rows[0].read<int>('starts'), 2);
    expect(rows[0].read<int>('apps'), 2);
    expect(rows[1].read<int>('starts'), 1);
    expect(rows[1].read<int>('apps'), 3);
  });

  test('the award year counts that year and no other', () async {
    // Three fixtures in three different calendar years, each with one rated
    // man. The middle year is the one asked for.
    final byYear = <int, int>{};
    for (final f in await comp.allFixtures(careerId)) {
      byYear.putIfAbsent(f.date.year, () => f.id);
    }
    final years = byYear.keys.toList()..sort();
    expect(
      years.length,
      greaterThanOrEqualTo(2),
      reason: 'a cycle schedule must span more than one calendar year',
    );

    for (final year in years) {
      await comp.recordPlayerMatchStats(careerId, byYear[year]!, [
        (
          playerId: 900 + (year - years.first),
          nationId: nationId,
          rating: 7.5,
          goals: 1,
          assists: 0,
          cleanSheet: false,
          motm: true,
          yellows: 0,
          reds: 0,
        ),
      ]);
    }

    for (final year in years) {
      final lines = await comp.awardLinesForYear(careerId, year);
      expect(
        lines.map((l) => l.playerId).toList(),
        [900 + (year - years.first)],
        reason: 'the award for $year counts only the ratings of $year',
      );
      expect(lines.single.apps, 1);
      expect(lines.single.goals, 1);
      expect(lines.single.motms, 1);
      expect(lines.single.meanRating, 7.5);
    }

    // A year the save never played returns nothing at all.
    expect(await comp.awardLinesForYear(careerId, years.first - 5), isEmpty);
  });
}
