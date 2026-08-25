import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/qualifying_draw_providers.dart';

import '../../helpers/test_database.dart';

/// A seed-ranking repository that has forgotten every draw's own snapshot —
/// which is what a save made before those snapshots existed looks like.
class _NoDrawSnapshots implements SeedRankingRepository {
  _NoDrawSnapshots(this._inner);

  final SeedRankingRepository _inner;

  @override
  Future<Map<int, int>> forCycle(int careerId, int cycle) async =>
      // Draw snapshots are stored under synthetic cycles (see drawSeedCycle).
      cycle >= 900000 ? const {} : _inner.forCycle(careerId, cycle);

  @override
  Future<void> snapshot(int careerId, int cycle, Map<int, int> rankById) =>
      _inner.snapshot(careerId, cycle, rankById);
}

/// A draw ceremony must show the tournament that is actually played.
///
/// Every ceremony used to RE-RUN its draw to animate it. That reproduces the
/// real groups only while every input still agrees, and one of them — the
/// ranking the pots were seeded from — is a snapshot taken at the moment of the
/// draw. A save without it seeded off the static ranking instead, and the
/// manager watched a ceremony in which not one group matched the cup he then
/// played. The ceremonies read the stored draw now, so this holds either way.
void main() {
  for (final conf in [Confederation.asia, Confederation.europe]) {
    test('the ${conf.name} ceremonies show the groups that are played', () async {
      final db = createTestDatabase();
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
      final seed = InMemorySeedSource(
        nationList: nations,
        playerList: const [],
      );
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(seed),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);
      await container.read(seedLoaderProvider).ensureSeeded();

      final player = nations
          .where((n) => n.confederation == conf)
          .reduce((a, b) => a.ranking <= b.ranking ? a : b);
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: player.id, managerName: 'A'))
              .valueOrNull!;
      final comp = container.read(competitionRepositoryProvider);
      final season = container.read(seasonServiceProvider);

      // Run the cycle out so both continental draws have been made.
      var lastDate = DateTime(1900);
      for (var i = 0; i < 600; i++) {
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null || hub.championNationId != null) break;
        if (!hub.career.inGameDate.isAfter(lastDate)) break;
        lastDate = hub.career.inGameDate;
      }

      // Viewed through a save that never wrote a draw's ranking snapshot: the
      // hardest case, and the one that was broken.
      final legacy = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(seed),
          seedRankingRepositoryProvider.overrideWith(
            (ref) => _NoDrawSnapshots(
              container.read(seedRankingRepositoryProvider),
            ),
          ),
        ],
      );
      addTearDown(legacy.dispose);
      await legacy.read(seedLoaderProvider).ensureSeeded();

      Map<String, Set<int>> byName(List<FinalsGroupTable> tables) => {
        for (final t in tables)
          t.name: {for (final s in t.standings) s.nationId},
      };

      final finals = await legacy.read(
        continentalDrawProvider((
          careerId: career.id,
          confederation: conf,
        )).future,
      );
      expect(finals, isNotNull);
      expect(
        {
          for (final g in finals!.draw.groups) g.name: g.nationIds.toSet(),
        },
        byName(
          await comp.tournamentGroupTables(
            career.id,
            CompetitionKind.continentalFinals,
            confederation: conf,
          ),
        ),
        reason: 'the continental finals ceremony must show the played groups',
      );

      final qual = await legacy.read(
        qualifyingDrawProvider((careerId: career.id, worldCup: false)).future,
      );
      expect(qual, isNotNull);
      expect(
        {for (final g in qual!.groups) g.name: g.nationIds.toSet()},
        byName(
          await comp.tournamentGroupTables(
            career.id,
            CompetitionKind.continentalQualifying,
            confederation: conf,
          ),
        ),
        reason: 'the continental qualifying ceremony must show its own groups',
      );

      // Every nation on the ball board comes out of exactly one pot, and no
      // pot is bigger than there are groups.
      final pots = <int, int>{};
      for (final e in qual.potByNation.entries) {
        pots[e.value] = (pots[e.value] ?? 0) + 1;
      }
      for (final count in pots.values) {
        expect(count, lessThanOrEqualTo(qual.groups.length));
      }
    }, timeout: const Timeout(Duration(minutes: 6)));
  }
}
