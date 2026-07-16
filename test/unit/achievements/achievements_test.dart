import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';

AchievementStats stats({
  int matchesPlayed = 0,
  int wins = 0,
  bool reachedWorldCup = false,
  bool reachedContinental = false,
  Set<String> titlesWon = const {},
  int biggestWinMargin = 0,
  int wcMarksmanGoals = 0,
  bool hasChampionshipGoldenBoot = false,
  bool playerInAllStars = false,
  bool wonWorldCupAndContinental = false,
  int satisfaction = 50,
}) =>
    AchievementStats(
      matchesPlayed: matchesPlayed,
      wins: wins,
      reachedWorldCup: reachedWorldCup,
      reachedContinental: reachedContinental,
      titlesWon: titlesWon,
      biggestWinMargin: biggestWinMargin,
      wcMarksmanGoals: wcMarksmanGoals,
      hasChampionshipGoldenBoot: hasChampionshipGoldenBoot,
      playerInAllStars: playerInAllStars,
      wonWorldCupAndContinental: wonWorldCupAndContinental,
      satisfaction: satisfaction,
    );

void main() {
  test('every achievement id is unique and stable', () {
    final ids = AchievementCatalog.all.map((a) => a.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('nothing is earned from a blank save', () {
    expect(AchievementCatalog.earnedIds(stats()), isEmpty);
  });

  test('win tallies unlock cumulatively', () {
    final earned = AchievementCatalog.earnedIds(stats(wins: 250));
    expect(earned, containsAll(['wins_1', 'wins_10', 'wins_100', 'wins_250']));
    expect(earned, isNot(contains('wins_500')));
  });

  test('match tallies unlock cumulatively', () {
    final earned = AchievementCatalog.earnedIds(stats(matchesPlayed: 200));
    expect(earned, containsAll(['matches_10', 'matches_100', 'matches_200']));
    expect(earned, isNot(contains('matches_500')));
  });

  test('titles are matched by exact competition name', () {
    final earned = AchievementCatalog.earnedIds(
      stats(titlesWon: {worldCupHonourName, 'European Championship'}),
    );
    expect(earned, containsAll(['title_wc', 'title_euro']));
    expect(earned, isNot(contains('title_copa')));
  });

  test('qualification, misc and mega flags each unlock their achievement', () {
    final earned = AchievementCatalog.earnedIds(stats(
      reachedWorldCup: true,
      reachedContinental: true,
      biggestWinMargin: 5,
      wcMarksmanGoals: 6,
      hasChampionshipGoldenBoot: true,
      playerInAllStars: true,
      wonWorldCupAndContinental: true,
      satisfaction: 100,
    ));
    expect(
      earned,
      containsAll([
        'qual_wc',
        'qual_cont',
        'mega_demolition',
        'wc_marksman',
        'mega_goldenboot',
        'mega_allstar',
        'mega_sweep',
        'mega_harmony',
      ]),
    );
  });

  test('boundary cases: 5 WC goals and 99% satisfaction stay locked', () {
    final earned = AchievementCatalog.earnedIds(
      stats(wcMarksmanGoals: 5, satisfaction: 99, biggestWinMargin: 4),
    );
    expect(earned, isNot(contains('wc_marksman')));
    expect(earned, isNot(contains('mega_harmony')));
    expect(earned, isNot(contains('mega_demolition')));
  });
}
