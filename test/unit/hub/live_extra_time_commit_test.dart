import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// A live knockout stores exactly the extra time the manager watched: the
/// engine's after-extra-time score, its goals recorded once with their real
/// scorers, the shown shootout. Only a result without engine extra time (an
/// older caller) is still settled by `decideKnockout`.
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

  /// Commits a level-after-ninety knockout and returns what was stored.
  Future<({Fixture stored, List<GoalEventRow> goals, Fixture fixture})> commit({
    required List<(bool home, int minute)> goalList,
    required ({int homeScore, int awayScore})? extraTime,
    required KnockoutOutcome? knockout,
  }) async {
    final c = open();
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    final next = (await comp.nextFixtureForNation(career.id, career.nationId))!;
    final fixture = next.copyWith(round: 'FINAL');
    final playerRepo = c.read(playerRepositoryProvider);
    final homePool = await playerRepo.byNation(
      fixture.homeNationId,
      saveSeed: career.rngSeed,
      careerId: career.id,
    );
    final awayPool = await playerRepo.byNation(
      fixture.awayNationId,
      saveSeed: career.rngSeed,
      careerId: career.id,
    );
    MatchEvent goal(bool home, int minute) {
      final p = home ? homePool.first : awayPool.first;
      return MatchEvent(
        minute: minute,
        type: MatchEventType.goal,
        teamNationId: home ? fixture.homeNationId : fixture.awayNationId,
        playerId: p.id,
        playerName: p.name,
      );
    }

    final result = MatchResult(
      homeScore: 1,
      awayScore: 1,
      extraTime: extraTime,
      events: [for (final g in goalList) goal(g.$1, g.$2)],
      homeShots: 8,
      awayShots: 7,
      homePossession: 50,
      ratings: const [],
    );
    await c
        .read(seasonServiceProvider)
        .playPlayerMatch(career.id, fixture, result, knockout: knockout);
    final stored = (await comp.allFixtures(
      career.id,
    )).firstWhere((x) => x.id == fixture.id);
    final goals = (await db.select(db.goalEvents).get())
        .where((g) => g.fixtureId == fixture.id)
        .toList();
    return (stored: stored, goals: goals, fixture: fixture);
  }

  KnockoutOutcome outcome(
    int h,
    int a, {
    List<bool> homeKicks = const [],
    List<bool> awayKicks = const [],
  }) => KnockoutOutcome(
    homeScore: h,
    awayScore: a,
    afterExtraTime: true,
    homeKicks: homeKicks,
    awayKicks: awayKicks,
  );

  test("the stored score is the engine's after-extra-time score", () async {
    final r = await commit(
      goalList: [(true, 20), (false, 70), (true, 104)],
      extraTime: (homeScore: 2, awayScore: 1),
      knockout: outcome(2, 1),
    );
    expect(r.stored.homeScore, 2);
    expect(r.stored.awayScore, 1);
    expect(r.stored.afterExtraTime, isTrue);
    expect(r.stored.homePenalties, isNull);
    expect(r.stored.awayPenalties, isNull);
  });

  test('extra-time goals are recorded once, with their real scorers', () async {
    final r = await commit(
      goalList: [(true, 20), (false, 70), (true, 104), (false, 118)],
      extraTime: (homeScore: 2, awayScore: 2),
      knockout: outcome(
        2,
        2,
        homeKicks: [true, true, true, true, true],
        awayKicks: [true, true, true, true, false],
      ),
    );
    expect(r.goals.map((g) => g.minute).toList()..sort(), [20, 70, 104, 118]);
  });

  test('a shootout stores the winner one clear', () async {
    final r = await commit(
      goalList: [(true, 20), (false, 70)],
      extraTime: (homeScore: 1, awayScore: 1),
      knockout: outcome(
        1,
        1,
        homeKicks: [true, true, true, false, true],
        awayKicks: [true, false, true, true, false],
      ),
    );
    expect(r.stored.homeScore, 2);
    expect(r.stored.awayScore, 1);
    expect(r.stored.homePenalties, 4);
    expect(r.stored.awayPenalties, 3);
    expect(r.goals, hasLength(2));
  });

  test('a knockout without engine extra time keeps the old path', () async {
    final r = await commit(
      goalList: [(true, 20), (false, 70)],
      extraTime: null,
      knockout: null,
    );
    expect(r.stored.afterExtraTime, isTrue);
    // decideKnockout settled it: never a level, un-shot-out score.
    final level = r.stored.homeScore == r.stored.awayScore;
    expect(level, isFalse);
  });
}
