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
  int cleanSheets = 0,
  int totalGoals = 0,
  int longestWinStreak = 0,
  int longestUnbeatenRun = 0,
  int hatTricks = 0,
  int playerMotms = 0,
  int shootoutsWon = 0,
  double bestPlayerRating = 0,
}) => AchievementStats(
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
  cleanSheets: cleanSheets,
  totalGoals: totalGoals,
  longestWinStreak: longestWinStreak,
  longestUnbeatenRun: longestUnbeatenRun,
  hatTricks: hatTricks,
  playerMotms: playerMotms,
  shootoutsWon: shootoutsWon,
  bestPlayerRating: bestPlayerRating,
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

  test('goal and clean-sheet tallies unlock cumulatively', () {
    final earned = AchievementCatalog.earnedIds(
      stats(totalGoals: 300, cleanSheets: 60),
    );
    expect(earned, containsAll(['goals_50', 'goals_250']));
    expect(earned, isNot(contains('goals_1000')));
    expect(earned, containsAll(['cleansheets_10', 'cleansheets_50']));
    expect(earned, isNot(contains('cleansheets_200')));
  });

  test('streak achievements unlock at their thresholds', () {
    final earned = AchievementCatalog.earnedIds(
      stats(longestWinStreak: 12, longestUnbeatenRun: 16),
    );
    expect(earned, containsAll(['streak_win_5', 'streak_win_10']));
    expect(earned, isNot(contains('streak_win_20')));
    expect(earned, contains('streak_unbeaten_15'));
    expect(earned, isNot(contains('streak_unbeaten_30')));
  });

  test('player feats unlock from the snapshot fields', () {
    final earned = AchievementCatalog.earnedIds(
      stats(
        hatTricks: 1,
        playerMotms: 10,
        bestPlayerRating: 9.6,
        shootoutsWon: 5,
        biggestWinMargin: 7,
      ),
    );
    expect(
      earned,
      containsAll([
        'feat_hattrick',
        'feat_motm_10',
        'feat_perfect',
        'feat_shootout',
        'feat_massacre',
      ]),
    );
    expect(earned, isNot(contains('feat_motm_50')));
    expect(earned, isNot(contains('feat_annihilation')));
  });

  test('every achievement has localizable text (id maps or falls back)', () {
    // Guards against a new catalogue entry whose id the resolver forgot: the
    // English title/description are never blank.
    for (final a in AchievementCatalog.all) {
      expect(a.title, isNotEmpty);
      expect(a.description, isNotEmpty);
    }
  });

  test('titles are matched by exact competition name', () {
    final earned = AchievementCatalog.earnedIds(
      stats(titlesWon: {worldCupHonourName, 'European Championship'}),
    );
    expect(earned, containsAll(['title_wc', 'title_euro']));
    expect(earned, isNot(contains('title_copa')));
  });

  test('qualification, misc and mega flags each unlock their achievement', () {
    final earned = AchievementCatalog.earnedIds(
      stats(
        reachedWorldCup: true,
        reachedContinental: true,
        biggestWinMargin: 5,
        wcMarksmanGoals: 6,
        hasChampionshipGoldenBoot: true,
        playerInAllStars: true,
        wonWorldCupAndContinental: true,
        satisfaction: 100,
      ),
    );
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
