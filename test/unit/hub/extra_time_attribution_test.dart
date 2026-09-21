import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// A man left at home cannot score the extra-time winner.
///
/// The manager's own match is committed from the match screen with the extra
/// time he watched. Its goals used to be attributed with no XI at all, so they
/// fell back to the nation's best available 4-3-3 — the eleven the game would
/// have picked, not the eleven he picked. A player he never called up could
/// win a final in the 113th minute.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

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

  test('extra-time goals go to the men who were on the pitch', () async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    final next = (await comp.nextFixtureForNation(career.id, career.nationId))!;
    // A knockout tie, so a level ninety minutes goes to extra time.
    final fixture = next.copyWith(round: 'FINAL');
    final mineAtHome = fixture.homeNationId == career.nationId;

    final playerRepo = c.read(playerRepositoryProvider);
    Future<List<Player>> poolOf(int nationId) async =>
        (await playerRepo.byNation(nationId, saveSeed: career.rngSeed))
          ..sort((a, b) {
            final byOverall = b.overall.compareTo(a.overall);
            return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
          });

    final myPool = await poolOf(career.nationId);
    final oppNation = mineAtHome ? fixture.awayNationId : fixture.homeNationId;
    final oppPool = await poolOf(oppNation);

    // He fields his eleven LEAST-rated men. Nobody the game would have picked
    // for him is on the pitch, so any goal credited to a first-choice name is
    // a goal credited to a man who was not in the stadium.
    final myXi = myPool.reversed.take(11).toList();
    final oppXi = oppPool.take(11).toList();
    final onThePitch = {
      for (final p in [...myXi, ...oppXi]) p.id,
    };
    expect(
      onThePitch,
      isNot(contains(myPool.first.id)),
      reason: 'the best player must be the one left at home',
    );

    MatchEvent goal(Player p, int nationId, int minute) => MatchEvent(
      minute: minute,
      type: MatchEventType.goal,
      teamNationId: nationId,
      playerId: p.id,
      playerName: p.name,
    );
    final myNation = career.nationId;
    final result = MatchResult(
      homeScore: 1,
      awayScore: 1,
      events: [
        goal(myXi.last, myNation, 23),
        goal(oppXi.last, oppNation, 71),
      ],
      homeShots: 8,
      awayShots: 7,
      homePossession: 50,
      ratings: [
        for (final p in myXi)
          PlayerRating(
            playerId: p.id,
            playerName: p.name,
            teamNationId: myNation,
            rating: 6.5,
          ),
        for (final p in oppXi)
          PlayerRating(
            playerId: p.id,
            playerName: p.name,
            teamNationId: oppNation,
            rating: 6.5,
          ),
      ],
    );
    // Extra time as the match screen played it out: his side wins it 2-1.
    final knockout = KnockoutOutcome(
      homeScore: mineAtHome ? 2 : 1,
      awayScore: mineAtHome ? 1 : 2,
      afterExtraTime: true,
      homeKicks: const [],
      awayKicks: const [],
    );

    await c
        .read(seasonServiceProvider)
        .playPlayerMatch(career.id, fixture, result, knockout: knockout);

    final goals = (await db.select(db.goalEvents).get())
        .where((g) => g.fixtureId == fixture.id)
        .toList();
    // Pin the match down: without this the test would pass the day extra-time
    // goals stop being attributed at all.
    expect(
      goals.where((g) => g.minute > 90),
      hasLength(1),
      reason: 'the extra-time winner must have been attributed',
    );
    expect(
      goals.map((g) => g.playerId).where((id) => !onThePitch.contains(id)),
      isEmpty,
      reason: 'a man who never took the field cannot score',
    );
  });
}
