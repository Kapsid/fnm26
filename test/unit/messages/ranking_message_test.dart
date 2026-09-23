import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

import '../../helpers/test_database.dart';

/// The inbox message that says what a World Championship did to the nation's
/// world place: where it went in, where it came out.
///
/// The three changes before this one made that move real — placings now pay
/// ranking points and the table was widened so a place means something — and
/// then hid it again: the cycle baseline the ranking screen measures against
/// is re-frozen at the rollover that follows the final, from the standings the
/// final produced, so every arrow on the screen reads zero by the time the
/// manager gets there. This message is the record that survives.
///
/// The third test is the one that matters. The message is filed by the sync
/// that runs in the same step that settled the final, and the live ranking is
/// read through a derived provider that does not notice a simulation step. A
/// cached read there does not fail loudly: it files a message that states,
/// permanently, the place the nation held BEFORE the tournament it is
/// reporting on. So that test warms the cache with the pre-tournament table
/// first, exactly as a real session does, and then reads the number.
void main() {
  late List<Nation> nations;
  late List<Player> players;

  /// One container per case: `sync` writes messages, and a key filed by one
  /// case must never silence another.
  Future<
    ({
      ProviderContainer container,
      int careerId,
      int nationId,
      List<int> otherIds,
    })
  >
  open() async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    final nationId = nations.first.id;
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M'))
            .valueOrNull!;
    return (
      container: container,
      careerId: career.id,
      nationId: nationId,
      otherIds: nations.skip(1).map((n) => n.id).toList(),
    );
  }

  /// Freezes a world table for the [cycle] World Championship finals draw with
  /// the manager's nation [rank]th, filling every other place with the rest of
  /// the world. This is "where it went in".
  Future<void> freezeDraw(
    ProviderContainer container, {
    required int careerId,
    required int cycle,
    required int nationId,
    required List<int> otherIds,
    required int rank,
  }) async {
    final order = [...otherIds]..insert(rank - 1, nationId);
    await container
        .read(seedRankingRepositoryProvider)
        .snapshot(careerId, drawSeedCycle(cycle, drawSlotWorldCupFinals), {
          for (var i = 0; i < order.length; i++) order[i]: i + 1,
        });
  }

  /// Puts the manager's nation [rank]th in the LIVE table by giving every
  /// nation points straight down from the top. This is "where it came out".
  Future<void> setLiveRank(
    ProviderContainer container, {
    required int careerId,
    required int nationId,
    required List<int> otherIds,
    required int rank,
  }) async {
    final order = [...otherIds]..insert(rank - 1, nationId);
    await container.read(rankingRepositoryProvider).save(careerId, {
      for (var i = 0; i < order.length; i++) order[i]: 2100 - i,
    });
  }

  Future<void> recordChampionship(
    ProviderContainer container, {
    required int careerId,
    required int cycle,
    required int championId,
    required int runnerUpId,
  }) => container
      .read(competitionRepositoryProvider)
      .recordHonour(
        careerId: careerId,
        year: CareerService.worldCupYear(cycle),
        competition: worldCupHonourName,
        championId: championId,
        runnerUpId: runnerUpId,
      );

  /// The bodies of every message filed under the tournament-jump key.
  Future<List<String>> jumpBodies(
    ProviderContainer container,
    int careerId,
  ) async {
    await container.read(messageServiceProvider).sync(careerId);
    final keys = await container
        .read(competitionRepositoryProvider)
        .messageKeys(careerId);
    if (!keys.any((k) => k.startsWith('rankjump:'))) return const [];
    final all = await container
        .read(competitionRepositoryProvider)
        .messages(careerId);
    // The jump message is the only one that names both a "from" and a "to",
    // and its title is the climb/slide headline, so match on that.
    return [
      for (final m in all)
        if (m.title.contains('climb to') || m.title.contains('slide to'))
          m.body,
    ];
  }

  setUpAll(() {
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
  });

  group('the championship swing is filed', () {
    test('a big climb says where it came from and where it is now', () async {
      final s = await open();
      await freezeDraw(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 25,
      );
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 4,
      );
      await recordChampionship(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        championId: s.nationId,
        runnerUpId: s.otherIds.first,
      );

      final bodies = await jumpBodies(s.container, s.careerId);
      expect(bodies, hasLength(1), reason: 'the climb was never reported');
      expect(bodies.single, contains('#25'));
      expect(bodies.single, contains('#4'));
      expect(bodies.single, contains('21 places'));
    }, timeout: const Timeout(Duration(minutes: 3)));

    test('a one-place move files nothing', () async {
      final s = await open();
      await freezeDraw(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 12,
      );
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 11,
      );
      await recordChampionship(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        championId: s.otherIds.first,
        runnerUpId: s.otherIds[1],
      );

      expect(
        await jumpBodies(s.container, s.careerId),
        isEmpty,
        reason: 'a single place is drift, not news',
      );
    }, timeout: const Timeout(Duration(minutes: 3)));

    test('the position reported is the one AFTER the tournament', () async {
      // The hazard, reproduced. A real session has the ranking on screen —
      // and therefore in the provider cache — while the final is simulated.
      final s = await open();
      await freezeDraw(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 25,
      );
      // Where the nation stood going in, and a live listener holding that
      // table in the cache, exactly as the ranking screen does.
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 25,
      );
      final sub = s.container.listen(
        worldRankingProvider(s.careerId),
        (prev, next) {},
        fireImmediately: true,
      );
      addTearDown(sub.close);
      final warm = await s.container.read(
        worldRankingProvider(s.careerId).future,
      );
      expect(
        warm!.position[s.nationId],
        25,
        reason: 'the cache was not warmed with the pre-tournament table',
      );

      // Now the tournament is played: the simulator moves the points and the
      // honour is filed, all in the step that then calls `sync`.
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 4,
      );
      await recordChampionship(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        championId: s.nationId,
        runnerUpId: s.otherIds.first,
      );

      final bodies = await jumpBodies(s.container, s.careerId);
      expect(bodies, hasLength(1));
      expect(
        bodies.single,
        contains('#4'),
        reason: 'the message graded against the table from before the finals',
      );
      expect(
        bodies.single.contains('came out #25'),
        isFalse,
        reason: 'the nation was reported as finishing where it started',
      );
    }, timeout: const Timeout(Duration(minutes: 3)));

    test('re-syncing does not file it twice', () async {
      final s = await open();
      await freezeDraw(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 30,
      );
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 6,
      );
      await recordChampionship(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        championId: s.nationId,
        runnerUpId: s.otherIds.first,
      );

      expect(await jumpBodies(s.container, s.careerId), hasLength(1));
      expect(await jumpBodies(s.container, s.careerId), hasLength(1));
    }, timeout: const Timeout(Duration(minutes: 3)));
  });

  group('the screen measures from the championship draw', () {
    test('the arrows survive the rollover that follows the final', () async {
      // The whole reason the baseline changed. The rollover freezes the NEW
      // cycle's seeding table from the standings the final produced, so a
      // screen that measured against that one showed a flat zero for every
      // nation in the world the day after the World Championship.
      final s = await open();
      await freezeDraw(
        s.container,
        careerId: s.careerId,
        cycle: 0,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 25,
      );
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 4,
      );
      // The rollover's own snapshot: taken after the final, so it agrees with
      // the live table to the place.
      final order = [...s.otherIds]..insert(3, s.nationId);
      await s.container
          .read(seedRankingRepositoryProvider)
          .snapshot(s.careerId, 1, {
            for (var i = 0; i < order.length; i++) order[i]: i + 1,
          });
      await s.container.read(careerRepositoryProvider).advanceCycle(
        s.careerId,
        1,
        DateTime(CareerService.worldCupYear(0), 9),
      );

      final data = await s.container.read(
        worldRankingProvider(s.careerId).future,
      );
      expect(
        data!.baseline,
        RankBaseline.worldChampionshipDraw,
        reason: 'the screen fell back to the post-final cycle snapshot',
      );
      expect(data.movement[s.nationId], 21);
    }, timeout: const Timeout(Duration(minutes: 3)));

    test('a career with no championship draw yet reads the cycle start', () async {
      final s = await open();
      await setLiveRank(
        s.container,
        careerId: s.careerId,
        nationId: s.nationId,
        otherIds: s.otherIds,
        rank: 4,
      );
      final data = await s.container.read(
        worldRankingProvider(s.careerId).future,
      );
      expect(data!.baseline, RankBaseline.cycleStart);
      // Nothing is frozen at cycle 0, so the static seed ranking stands in and
      // the arrows still point somewhere real.
      expect(
        data.movement[s.nationId],
        nations.first.ranking - 4,
        reason: 'the seed fallback stopped working',
      );
    }, timeout: const Timeout(Duration(minutes: 3)));
  });

  test('a place is worth enough points that five of them is not noise', () {
    // The threshold's justification, asserted rather than asserted-in-prose:
    // five places in the middle of the widened table is a swing no run of
    // friendlies produces, and one tournament clears it easily.
    final twentieth = Elo.seedFromRanking(20);
    final twentyFifth = Elo.seedFromRanking(25);
    expect(
      (twentieth - twentyFifth) / kRankJumpPlaces,
      greaterThan(2.5),
      reason: 'a place got cheap; the threshold needs re-deriving',
    );
    expect(kRankJumpPlaces, greaterThan(1));
  });
}
