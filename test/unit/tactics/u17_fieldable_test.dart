import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// The call-up list reaches down to the U-17 band (the youth-pyramid design:
/// "U-17, 15-16, in senior call-up list: yes, tagged"), so a boy the manager
/// names must be a boy he can field. Every pool the XI is built from used to
/// stop at seventeen, so a called-up fifteen- or sixteen-year-old sat in the
/// squad and could never play.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  test('the call-up floor is the U-17 band, the senior floor U-19', () {
    expect(PlayerLifecycle.callUpMinAge, YouthLevel.u17.minAge);
    expect(PlayerLifecycle.seniorMinAge, YouthLevel.u19.minAge);
  });

  test('a squad nobody named never sweeps in an uncalled boy', () {
    final pool = [
      for (var age = 15; age <= 20; age++)
        player(
          id: age,
          nationId: 1,
          name: 'P$age',
          position: PlayerPosition.cm,
          age: age,
          attributes: flatAttributes(70),
        ),
    ];
    // Nobody named, or a stale set naming nobody: the seniors, as before.
    expect(availableSquad(pool, const {}).map((p) => p.age), [17, 18, 19, 20]);
    expect(availableSquad(pool, const {99}).map((p) => p.age), [
      17,
      18,
      19,
      20,
    ]);
    // A boy he named is in.
    expect(availableSquad(pool, const {16, 18}).map((p) => p.age), [16, 18]);
  });

  group('a called-up U-17', () {
    late AppDatabase db;
    late List<Nation> nations;
    late List<Player> players;

    ProviderContainer open() {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: players),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    setUp(() {
      db = createTestDatabase();
      addTearDown(db.close);
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

    /// A save whose squad names a U-17 and whose XI starts him. Returns the
    /// career id and the boy's id.
    Future<(int, int)> withBoyInTheXi(ProviderContainer c) async {
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      final squad = (await c.read(squadDataProvider(career.id).future))!;
      final boy = squad.pool.firstWhere(
        (p) => p.age < PlayerLifecycle.seniorMinAge,
        orElse: () => fail('the call-up pool must offer a U-17 to name'),
      );
      final seniors = squad.pool
          .where((p) => p.age >= PlayerLifecycle.seniorMinAge)
          .take(kMaxSquadSize - 1)
          .map((p) => p.id);
      expect(
        await c.read(squadServiceProvider).setCallUps(career.id, {
          ...seniors,
          boy.id,
        }),
        isTrue,
      );
      final tactics = c.read(tacticsRepositoryProvider);
      final tactic = (await tactics.tacticForCareer(career.id))!;
      final lineup = [...tactic.lineup];
      lineup[lineup.length - 1] = boy.id;
      await tactics.saveTactic(career.id, tactic.copyWith(lineup: lineup));
      c
        ..invalidate(squadDataProvider)
        ..invalidate(tacticDataProvider)
        ..invalidate(matchPreviewProvider);
      return (career.id, boy.id);
    }

    test('is in the tactics pool and starts the match he was picked for', () async {
      final c = open();
      final (careerId, boy) = await withBoyInTheXi(c);

      final data = (await c.read(tacticDataProvider(careerId).future))!;
      expect(data.byId.keys, contains(boy), reason: 'tactics screen pool');
      // byId is the FULL pool, so it would hold an uncalled boy too: the
      // options the manager picks from are `pool`, and only a named boy is in.
      expect(
        data.pool.map((p) => p.id),
        contains(boy),
        reason: 'selectable in the tactics options',
      );
      final squad = (await c.read(squadDataProvider(careerId).future))!;
      final uncalled = squad.pool.firstWhere(
        (p) => p.age < PlayerLifecycle.seniorMinAge && p.id != boy,
        orElse: () => fail('the pool must offer a second U-17 to leave out'),
      );
      expect(
        data.pool.map((p) => p.id),
        isNot(contains(uncalled.id)),
        reason: 'a boy nobody named is not an option',
      );
      expect(data.tactic.lineup, contains(boy), reason: 'stays in the XI');

      final preview = (await c.read(matchPreviewProvider(careerId).future))!;
      final mine = preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
      expect(mine.xi.map((p) => p.id), contains(boy), reason: 'match XI');
    });

    test('plays in a match of his the world simulates', () async {
      final c = open();
      final (careerId, boy) = await withBoyInTheXi(c);
      final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
      final comp = c.read(competitionRepositoryProvider);
      final mineNext = await comp.nextFixtureForNation(
        careerId,
        career.nationId,
      );
      expect(mineNext, isNotNull);

      // A fresh session skips the match rather than playing it out.
      final fresh = open();
      for (var i = 0; i < 40; i++) {
        final rated = (await db.select(db.playerRatings).get()).where(
          (r) => r.fixtureId == mineNext!.id,
        );
        if (rated.isNotEmpty) break;
        await fresh.read(seasonServiceProvider).advance(careerId);
      }
      final rated = (await db.select(db.playerRatings).get())
          .where((r) => r.fixtureId == mineNext!.id)
          .map((r) => r.playerId)
          .toList();
      expect(rated, isNotEmpty, reason: 'the fixture must have been simulated');
      expect(rated, contains(boy), reason: 'he was in the XI the manager set');
    });
  });
}
