import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';

import '../../helpers/test_database.dart';

/// A tester moved to Morocco and was handed "African Champions" and "Shootout
/// Specialist" on the spot, without a single shootout of his own. The
/// achievements read the CURRENT nation's whole record, so a new job brought
/// its AI-played history with it. Every achievement now counts only the
/// matches and titles the manager had charge of, with the nation he had then.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const france = 18;
  const spain = 50;
  const morocco = 135;
  const senegal = 142;

  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;
  late int comp0;
  late int comp1;

  setUp(() async {
    db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await container.read(seedLoaderProvider).ensureSeeded();
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(nationId: france, managerName: 'M'))
            .valueOrNull!
            .id;
    Future<int> competition(int cycle) => db
        .into(db.competitions)
        .insert(
          CompetitionsCompanion.insert(
            careerId: careerId,
            name: 'Test cup $cycle',
            kind: const Value(CompetitionKind.continentalFinals),
            confederation: Confederation.europe,
            cycle: Value(cycle),
          ),
        );
    comp0 = await competition(0);
    comp1 = await competition(1);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<int> play(
    DateTime date,
    int home,
    int away,
    int hs,
    int as, {
    String? round,
    int? homePens,
    int? awayPens,
  }) => db
      .into(db.fixtures)
      .insert(
        FixturesCompanion.insert(
          careerId: careerId,
          competitionId: date.isBefore(DateTime(2030, 9)) ? comp0 : comp1,
          matchday: 1,
          date: date,
          homeNationId: home,
          awayNationId: away,
          homeScore: Value(hs),
          awayScore: Value(as),
          played: const Value(true),
          round: Value(round),
          homePenalties: Value(homePens),
          awayPenalties: Value(awayPens),
        ),
      );

  Future<void> hatTrick(int fixtureId, int nationId) => db
      .into(db.playerRatings)
      .insert(
        PlayerRatingsCompanion.insert(
          careerId: careerId,
          fixtureId: fixtureId,
          playerId: 999001,
          nationId: Value(nationId),
          rating: 9.8,
          goals: const Value(3),
          motm: const Value(true),
        ),
      );

  Future<void> honour(int year, String name, int champion, int runnerUp) =>
      container
          .read(competitionRepositoryProvider)
          .recordHonour(
            careerId: careerId,
            year: year,
            competition: name,
            championId: champion,
            runnerUpId: runnerUp,
          );

  /// Cycle 0 with France: a few wins (one on penalties), a European title.
  /// Meanwhile Morocco, under the AI: five shootouts won, a 9-0 with a
  /// hat-trick, the African title and a World Championship group game.
  Future<void> firstCycle() async {
    await play(DateTime(2027, 3, 25), france, spain, 3, 0);
    await play(
      DateTime(2027, 6, 10),
      france,
      spain,
      2,
      1,
      round: 'CQF',
      homePens: 5,
      awayPens: 4,
    );
    await play(DateTime(2028, 6, 20), france, spain, 1, 0, round: 'CGROUP');
    await play(DateTime(2028, 7, 10), france, spain, 2, 0, round: 'CFINAL');
    await honour(2028, 'European Championship', france, spain);

    for (var i = 0; i < 5; i++) {
      await play(
        DateTime(2027 + i ~/ 2, 3 + i, 12),
        morocco,
        senegal,
        2,
        1,
        round: 'CR16',
        homePens: 4,
        awayPens: 2,
      );
    }
    final rout = await play(DateTime(2029, 3, 20), morocco, senegal, 9, 0);
    await hatTrick(rout, morocco);
    await play(DateTime(2028, 2, 10), morocco, senegal, 2, 1, round: 'CFINAL');
    await honour(2028, 'African Championship', morocco, senegal);
    await play(DateTime(2030, 6, 15), morocco, spain, 1, 0, round: 'GROUP');
  }

  /// The rollover's move: Morocco from cycle 1 (see `season_rollover`).
  Future<void> moveToMorocco() async {
    final careers = container.read(careerRepositoryProvider);
    await careers.switchNation(careerId, morocco);
    await careers.advanceCycle(careerId, 1, DateTime(2030, 9));
    await careers.recordStint(careerId, 1, morocco);
  }

  /// The service, reading the world as it now stands: the app's season step
  /// refreshes the cached career stats after every match the same way.
  AchievementService service() {
    container
      ..invalidate(careerStatsProvider)
      ..invalidate(satisfactionProvider);
    return container.read(achievementServiceProvider);
  }

  Future<Set<String>> stored() => container
      .read(competitionRepositoryProvider)
      .earnedAchievements(careerId);

  test('a move to Morocco brings none of its history with it', () async {
    await firstCycle();
    final beforeMove = (await service().checkAndRecord(
      careerId,
    )).map((a) => a.id).toSet();
    expect(beforeMove, containsAll(['title_euro', 'qual_cont']));

    await moveToMorocco();
    // France, after he left: not his.
    final gone = await play(DateTime(2031, 3, 25), france, spain, 10, 0);
    await hatTrick(gone, france);

    final stats = (await service().computeStats(careerId))!;
    expect(stats.shootoutsWon, 1, reason: 'his one shootout, with France');
    expect(stats.wins, 4);
    expect(stats.matchesPlayed, 4);
    expect(stats.titlesWon, {'European Championship'});
    expect(stats.biggestWinMargin, 3);
    expect(stats.hatTricks, 0);
    expect(stats.reachedWorldCup, isFalse);

    final fresh = (await service().checkAndRecord(
      careerId,
    )).map((a) => a.id).toSet();
    expect(fresh, isEmpty, reason: 'nothing unearned on arrival');
    final earned = await stored();
    for (final unearned in [
      'title_afcon',
      'feat_shootout',
      'feat_massacre',
      'feat_annihilation',
      'mega_demolition',
      'feat_hattrick',
      'feat_perfect',
      'qual_wc',
    ]) {
      expect(earned, isNot(contains(unearned)), reason: unearned);
    }
    // What he won with France stays his.
    expect(earned, containsAll(['title_euro', 'qual_cont', 'wins_1']));

    // The stats screen reads the same, scoped record.
    container.invalidate(careerStatsProvider);
    final cs = await container.read(careerStatsProvider(careerId).future);
    expect(cs.shootoutsWon, 1);
    expect(cs.hatTricks, 0);
    expect(cs.biggestWinMargin, 3);
  });

  test('what he wins with Morocco after the move does count', () async {
    await firstCycle();
    await moveToMorocco();
    await service().checkAndRecord(careerId);

    await play(DateTime(2031, 3, 25), morocco, senegal, 6, 0);
    for (var i = 0; i < 4; i++) {
      await play(
        DateTime(2031, 6 + i, 10),
        morocco,
        spain,
        2,
        1,
        round: 'NQF',
        homePens: 5,
        awayPens: 3,
      );
    }
    await play(DateTime(2032, 2, 10), morocco, senegal, 1, 0, round: 'CFINAL');
    await honour(2032, 'African Championship', morocco, senegal);

    final fresh = (await service().checkAndRecord(
      careerId,
    )).map((a) => a.id).toSet();
    expect(fresh, containsAll(['title_afcon', 'mega_demolition']));
    // Four in Morocco plus the one with France.
    expect(fresh, contains('feat_shootout'));
    expect(fresh, isNot(contains('feat_massacre')));
    expect(await stored(), contains('title_euro'));
  });

  test(
    'a career that never moved counts its nation exactly as before',
    () async {
      await firstCycle();
      // Morocco's AI games are somebody else's; France's are all his.
      for (var i = 0; i < 5; i++) {
        await play(
          DateTime(2029, 1 + i, 5),
          france,
          spain,
          1,
          2,
          round: 'CR16',
          homePens: 3,
          awayPens: 4,
        );
      }
      final comp = container.read(competitionRepositoryProvider);
      final all = [
        for (final f in await comp.fixturesForNation(careerId, france))
          if (f.hasResult) f,
      ];
      final stats = (await service().computeStats(careerId))!;
      expect(stats.matchesPlayed, all.length);
      expect(
        stats.wins,
        all.where((f) {
          final home = f.homeNationId == france;
          return home
              ? f.homeScore! > f.awayScore!
              : f.awayScore! > f.homeScore!;
        }).length,
      );
      expect(stats.titlesWon, {'European Championship'});
      expect(stats.shootoutsWon, 1);
      expect(stats.reachedContinental, isTrue);
      expect(stats.reachedWorldCup, isFalse, reason: "Morocco's, not his");
    },
  );

  group('the one-time repair of an older save', () {
    Future<void> anOldSaveWithWrongUnlocks() async {
      await firstCycle();
      await moveToMorocco();
      final comp = container.read(competitionRepositoryProvider);
      // What the old rule handed out on arrival, beside what he earned.
      for (final id in [
        'title_afcon',
        'feat_shootout',
        'feat_massacre',
        'feat_hattrick',
        'title_euro',
        'wins_1',
        'mega_allstar',
      ]) {
        await comp.recordAchievement(careerId, id, 2030);
      }
      // A save from before the fix carries no mark.
      await comp.unmarkDrawWatched(careerId, 0, achievementTenureKind);
    }

    test('takes back only what he never earned, once', () async {
      await anOldSaveWithWrongUnlocks();
      final revoked = await service().repairTenureUnlocks(careerId);
      expect(revoked, {
        'title_afcon',
        'feat_shootout',
        'feat_massacre',
        'feat_hattrick',
      });
      final earned = await stored();
      expect(earned, containsAll(['title_euro', 'wins_1']));
      // A finals-only award cannot be re-derived for a cycle gone by.
      expect(earned, contains('mega_allstar'));

      // Done once: a later unlock is never touched by it again.
      final comp = container.read(competitionRepositoryProvider);
      await comp.recordAchievement(careerId, 'feat_massacre', 2031);
      expect(await service().repairTenureUnlocks(careerId), isEmpty);
      expect(await stored(), contains('feat_massacre'));
    });

    test('is not run on evaluation: an older save keeps its unlocks', () async {
      await anOldSaveWithWrongUnlocks();
      await service().checkAndRecord(careerId);
      expect(await stored(), contains('title_afcon'));
    });

    test('leaves a save alone whose stints cannot tell', () async {
      await anOldSaveWithWrongUnlocks();
      await db.delete(db.careerStints).go();
      await container
          .read(careerRepositoryProvider)
          .recordStint(careerId, 1, morocco);
      expect(await service().repairTenureUnlocks(careerId), isEmpty);
      expect(await stored(), contains('title_afcon'));
    });

    test('and a career that never moved', () async {
      await firstCycle();
      final comp = container.read(competitionRepositoryProvider);
      await comp.recordAchievement(careerId, 'title_wc', 2030);
      await comp.unmarkDrawWatched(careerId, 0, achievementTenureKind);
      expect(await service().repairTenureUnlocks(careerId), isEmpty);
      expect(await stored(), contains('title_wc'));
    });
  });
}
