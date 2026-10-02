import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// At rollover each ladder confederation (Europe, CONCACAF) promotes and
/// relegates off its OWN tables; Africa's zones don't ladder at all.
void main() {
  Future<
    ({
      ProviderContainer container,
      AppDatabase db,
      List<Nation> nations,
      int careerId,
    })
  >
  setUp() async {
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    await container.read(seedLoaderProvider).ensureSeeded();
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: player.id, managerName: 'M', rngSeed: 12345))
            .valueOrNull!;
    return (
      container: container,
      db: db,
      nations: nations,
      careerId: career.id,
    );
  }

  Future<void> runToChampion(ProviderContainer c, int careerId) async {
    final season = c.read(seasonServiceProvider);
    var last = DateTime(1900);
    for (var i = 0; i < 400; i++) {
      await season.advance(careerId);
      final hub = await c.read(hubDataProvider(careerId).future);
      if (hub!.championNationId != null) return;
      if (!hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }
    fail('the cycle never crowned a champion');
  }

  Future<Map<int, int>> expectedFor(
    ProviderContainer c,
    int careerId,
    Map<int, int> tiers,
    Confederation conf,
  ) async {
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          careerId,
          CompetitionKind.nationsLeague,
          confederation: conf,
        );
    return NationsCup.promoteRelegate(
      tiers: tiers,
      groups: [
        for (final t in tables)
          if (t.standings.length >= 2)
            (
              tier: NationsCup.tierOfGroupName(t.name),
              winner: t.standings.first,
              bottom: t.standings.last,
            ),
      ],
    );
  }

  test(
    'each ladder confederation moves on its own tables; Africa stays put',
    () async {
      final s = await setUp();
      await runToChampion(s.container, s.careerId);
      final careers = s.container.read(careerRepositoryProvider);
      final before = await careers.nationsCupTiers(s.careerId);
      final confOf = {for (final n in s.nations) n.id: n.confederation};

      final europeNext = await expectedFor(
        s.container,
        s.careerId,
        before,
        Confederation.europe,
      );
      final naNext = await expectedFor(
        s.container,
        s.careerId,
        before,
        Confederation.northAmerica,
      );

      await s.container.read(seasonServiceProvider).startNextCycle(s.careerId);
      final after = await careers.nationsCupTiers(s.careerId);

      for (final id in before.keys) {
        final conf = confOf[id];
        final want = switch (conf) {
          Confederation.europe => europeNext[id],
          Confederation.northAmerica => naNext[id],
          _ => before[id],
        };
        expect(after[id], want, reason: 'nation $id ($conf)');
      }
      bool moved(Confederation c) => before.keys.any(
        (id) => confOf[id] == c && after[id] != before[id],
      );
      expect(moved(Confederation.europe), isTrue);
      expect(moved(Confederation.northAmerica), isTrue);
      expect(moved(Confederation.africa), isFalse);
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );

  test(
    "rollover repairs a stored CONCACAF League C the calendar never played",
    () async {
      final s = await setUp();
      final careers = s.container.read(careerRepositoryProvider);
      // A save seeded before the remainder fold: the three weakest CONCACAF
      // nations stored as League C, though the calendar plays them in B.
      final stale = {...await careers.nationsCupTiers(s.careerId)};
      final na =
          s.nations
              .where((n) => n.confederation == Confederation.northAmerica)
              .toList()
            ..sort((a, b) => b.ranking.compareTo(a.ranking));
      for (final n in na.take(3)) {
        stale[n.id] = 2;
      }
      await careers.setNationsCupTiers(s.careerId, stale);

      await runToChampion(s.container, s.careerId);
      await s.container.read(seasonServiceProvider).startNextCycle(s.careerId);
      final after = await careers.nationsCupTiers(s.careerId);
      final confOf = {for (final n in s.nations) n.id: n.confederation};
      expect(
        NationsCup.lowestTier(
          tiers: after,
          confederation: Confederation.northAmerica,
          confederationOf: (id) => confOf[id],
        ),
        1,
      );
      expect([for (final n in na) after[n.id]].where((t) => t == 1).length, 19);
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );

  test(
    'an old save without the CONCACAF and African cups still rolls over',
    () async {
      final s = await setUp();
      // Simulate a save made before those cups existed.
      final old =
          await (s.db.select(s.db.competitions)..where(
                (t) =>
                    t.careerId.equals(s.careerId) &
                    t.kind.equals(CompetitionKind.nationsLeague.name) &
                    t.cycle.equals(0) &
                    t.confederation.isNotValue(Confederation.europe.name),
              ))
              .get();
      expect(old, isNotEmpty);
      final ids = [for (final c in old) c.id];
      await (s.db.delete(
        s.db.fixtures,
      )..where((t) => t.competitionId.isIn(ids))).go();
      final groups = await (s.db.select(
        s.db.qualifyingGroups,
      )..where((t) => t.competitionId.isIn(ids))).get();
      final gids = [for (final g in groups) g.id];
      await (s.db.delete(
        s.db.groupMembers,
      )..where((t) => t.groupId.isIn(gids))).go();
      await (s.db.delete(
        s.db.qualifyingGroups,
      )..where((t) => t.competitionId.isIn(ids))).go();
      await (s.db.delete(s.db.competitions)..where((t) => t.id.isIn(ids))).go();

      await runToChampion(s.container, s.careerId);
      final careers = s.container.read(careerRepositoryProvider);
      final before = await careers.nationsCupTiers(s.careerId);
      final confOf = {for (final n in s.nations) n.id: n.confederation};
      final europeNext = await expectedFor(
        s.container,
        s.careerId,
        before,
        Confederation.europe,
      );

      await s.container.read(seasonServiceProvider).startNextCycle(s.careerId);
      final after = await careers.nationsCupTiers(s.careerId);
      for (final id in before.keys) {
        final want = confOf[id] == Confederation.europe
            ? europeNext[id]
            : before[id];
        expect(after[id], want, reason: 'nation $id');
      }
      expect(
        before.keys.any(
          (id) => confOf[id] == Confederation.europe && after[id] != before[id],
        ),
        isTrue,
        reason: 'Europe still relegates as before',
      );

      final comp = s.container.read(competitionRepositoryProvider);
      for (final c in NationsCups.confederations) {
        expect(
          await comp.hasTournament(
            s.careerId,
            CompetitionKind.nationsLeague,
            confederation: c,
          ),
          isTrue,
          reason: "${c.name} cup is on cycle 1's calendar",
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
