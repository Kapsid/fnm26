/// The per-save achievement system: a static catalogue of achievements and a
/// pure [AchievementStats] snapshot they are evaluated against. Gathering the
/// snapshot from the repositories lives in the feature layer
/// (`achievement_providers.dart`); this file stays pure and unit-testable.
library;

/// The sections achievements are grouped under on the achievements screen.
enum AchievementCategory {
  wins('Wins'),
  goals('Goals'),
  matches('Matches'),
  streaks('Streaks'),
  qualifications('Qualifications'),
  titles('Titles'),
  misc('Misc'),
  mega('Mega');

  const AchievementCategory(this.label);

  /// The section heading shown in the UI.
  final String label;
}

/// An achievement's rough rarity — drives the coloured badge on the screen and
/// hints how hard it is to earn. Rises with the milestone in a tiered set.
enum AchievementTier { bronze, silver, gold, platinum }

/// A snapshot of everything the catalogue needs to decide what is unlocked.
class AchievementStats {
  const AchievementStats({
    required this.matchesPlayed,
    required this.wins,
    required this.reachedWorldCup,
    required this.reachedContinental,
    required this.titlesWon,
    required this.biggestWinMargin,
    required this.wcMarksmanGoals,
    required this.hasChampionshipGoldenBoot,
    required this.playerInAllStars,
    required this.wonWorldCupAndContinental,
    required this.satisfaction,
    this.cleanSheets = 0,
    this.totalGoals = 0,
    this.longestWinStreak = 0,
    this.longestUnbeatenRun = 0,
    this.hatTricks = 0,
    this.playerMotms = 0,
    this.shootoutsWon = 0,
    this.bestPlayerRating = 0,
  });

  /// Every match the player's nation has played (friendlies included).
  final int matchesPlayed;

  /// Matches won (friendlies included).
  final int wins;

  /// Whether the player's nation has ever reached the World Cup finals.
  final bool reachedWorldCup;

  /// Whether it has ever reached its continental championship finals.
  final bool reachedContinental;

  /// The exact competition-name strings the player's nation has won
  /// (e.g. 'World Championship', 'European Championship').
  final Set<String> titlesWon;

  /// The largest winning margin in any single match.
  final int biggestWinMargin;

  /// The most World Cup finals goals a single squad player has amassed.
  final int wcMarksmanGoals;

  /// Whether a player of the nation has finished as a championship top scorer.
  final bool hasChampionshipGoldenBoot;

  /// Whether a player was named in a World Cup Team of the Tournament.
  final bool playerInAllStars;

  /// Whether the nation has held the World Cup and its continental title within
  /// the same career.
  final bool wonWorldCupAndContinental;

  /// Board/fan satisfaction, 0–100.
  final int satisfaction;

  /// Career clean sheets, and total goals the manager's sides have scored.
  final int cleanSheets, totalGoals;

  /// Longest lifetime runs of consecutive wins / unbeaten matches.
  final int longestWinStreak, longestUnbeatenRun;

  /// Feats by the manager's players: hat-tricks, man-of-the-match awards, and
  /// the highest single-match rating any of them has earned.
  final int hatTricks, playerMotms, shootoutsWon;
  final double bestPlayerRating;
}

/// The exact honour competition-name string for the World Cup (stored, and
/// checked when deciding the World Cup title achievement).
const worldCupHonourName = 'World Championship';

/// One achievement: its identity, presentation, and how it is evaluated.
class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.isEarned,
    this.tier = AchievementTier.bronze,
    this.progressOf,
  });

  /// Stable id persisted once unlocked — never change these.
  final String id;
  final AchievementCategory category;
  final String title;
  final String description;

  /// Rarity badge — rises with the milestone within a tiered set.
  final AchievementTier tier;

  /// Whether the achievement is unlocked for the given stats.
  final bool Function(AchievementStats) isEarned;

  /// A `(current, target)` pair for tally achievements, else null.
  final (int, int) Function(AchievementStats)? progressOf;
}

/// The full catalogue of achievements, in display order within each category.
abstract final class AchievementCatalog {
  /// Cumulative win milestones.
  static const winTiers = [1, 10, 100, 250, 500, 1000, 5000, 10000, 100000];

  /// Cumulative matches-played milestones.
  static const matchTiers = [
    10, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 50000, 100000,
  ];

  /// Cumulative goals-scored milestones.
  static const goalTiers = [50, 250, 1000, 5000, 25000, 100000];

  /// Cumulative clean-sheet milestones.
  static const cleanSheetTiers = [10, 50, 200, 1000];

  /// The rarity badge for the [index]-th step of an [total]-step tiered set —
  /// later milestones climb bronze → silver → gold → platinum.
  static AchievementTier _tier(int index, int total) {
    final q = total <= 1 ? 1.0 : index / (total - 1);
    if (q >= 0.8) return AchievementTier.platinum;
    if (q >= 0.5) return AchievementTier.gold;
    if (q >= 0.2) return AchievementTier.silver;
    return AchievementTier.bronze;
  }

  /// Continental title achievements: (id, honour competition name, trophy
  /// title, description). A nation can only win its own confederation's cup, so
  /// most stay locked in any single save — they are collectible across nations.
  static const _continentalTitles = <(String, String, String, String)>[
    (
      'title_euro',
      'European Championship',
      'European Champions',
      'Win the European Championship.',
    ),
    (
      'title_copa',
      'South America Cup',
      'South America Champions',
      'Win the South America Cup.',
    ),
    (
      'title_afcon',
      'African Championship',
      'African Champions',
      'Win the African Championship.',
    ),
    (
      'title_asia',
      'Asian Championship',
      'Asian Champions',
      'Win the Asian Championship.',
    ),
    (
      'title_concacaf',
      'North America Cup',
      'North America Champions',
      'Win the North America Cup.',
    ),
    (
      'title_ofc',
      'Oceania Cup',
      'Oceania Champions',
      'Win the Oceania Cup.',
    ),
  ];

  static final List<AchievementDef> all = [
    // ---- Wins ----
    for (final t in winTiers)
      AchievementDef(
        id: 'wins_$t',
        category: AchievementCategory.wins,
        title: '$t ${t == 1 ? 'Win' : 'Wins'}',
        description: 'Win ${_count(t, 'match', 'matches')}.',
        isEarned: (s) => s.wins >= t,
        tier: _tier(winTiers.indexOf(t), winTiers.length),
        progressOf: (s) => (s.wins, t),
      ),
    // ---- Goals ----
    for (final t in goalTiers)
      AchievementDef(
        id: 'goals_$t',
        category: AchievementCategory.goals,
        title: '$t Goals',
        description: 'Score ${_count(t, 'goal', 'goals')}.',
        isEarned: (s) => s.totalGoals >= t,
        tier: _tier(goalTiers.indexOf(t), goalTiers.length),
        progressOf: (s) => (s.totalGoals, t),
      ),
    // ---- Matches ----
    for (final t in matchTiers)
      AchievementDef(
        id: 'matches_$t',
        category: AchievementCategory.matches,
        title: '$t Matches',
        description: 'Play ${_count(t, 'match', 'matches')}.',
        isEarned: (s) => s.matchesPlayed >= t,
        tier: _tier(matchTiers.indexOf(t), matchTiers.length),
        progressOf: (s) => (s.matchesPlayed, t),
      ),
    // ---- Streaks ----
    AchievementDef(
      id: 'streak_win_5',
      category: AchievementCategory.streaks,
      title: 'Winning Habit',
      description: 'Win five matches in a row.',
      isEarned: (s) => s.longestWinStreak >= 5,
      tier: AchievementTier.silver,
      progressOf: (s) => (s.longestWinStreak, 5),
    ),
    AchievementDef(
      id: 'streak_win_10',
      category: AchievementCategory.streaks,
      title: 'On a Roll',
      description: 'Win ten matches in a row.',
      isEarned: (s) => s.longestWinStreak >= 10,
      tier: AchievementTier.gold,
      progressOf: (s) => (s.longestWinStreak, 10),
    ),
    AchievementDef(
      id: 'streak_win_20',
      category: AchievementCategory.streaks,
      title: 'Juggernaut',
      description: 'Win twenty matches in a row.',
      isEarned: (s) => s.longestWinStreak >= 20,
      tier: AchievementTier.platinum,
      progressOf: (s) => (s.longestWinStreak, 20),
    ),
    AchievementDef(
      id: 'streak_unbeaten_15',
      category: AchievementCategory.streaks,
      title: 'Hard to Beat',
      description: 'Go fifteen matches unbeaten.',
      isEarned: (s) => s.longestUnbeatenRun >= 15,
      tier: AchievementTier.silver,
      progressOf: (s) => (s.longestUnbeatenRun, 15),
    ),
    AchievementDef(
      id: 'streak_unbeaten_30',
      category: AchievementCategory.streaks,
      title: 'Untouchable',
      description: 'Go thirty matches unbeaten.',
      isEarned: (s) => s.longestUnbeatenRun >= 30,
      tier: AchievementTier.platinum,
      progressOf: (s) => (s.longestUnbeatenRun, 30),
    ),
    // ---- Qualifications ----
    AchievementDef(
      id: 'qual_wc',
      category: AchievementCategory.qualifications,
      title: 'World Cup Qualifier',
      description: 'Reach the World Cup finals.',
      isEarned: (s) => s.reachedWorldCup,
      tier: AchievementTier.silver,
    ),
    AchievementDef(
      id: 'qual_cont',
      category: AchievementCategory.qualifications,
      title: 'Continental Qualifier',
      description: 'Reach your continental championship finals.',
      isEarned: (s) => s.reachedContinental,
      tier: AchievementTier.silver,
    ),
    // ---- Titles (one per competition) ----
    AchievementDef(
      id: 'title_wc',
      category: AchievementCategory.titles,
      title: 'World Champions',
      description: 'Win the World Cup.',
      isEarned: (s) => s.titlesWon.contains(worldCupHonourName),
      tier: AchievementTier.platinum,
    ),
    for (final c in _continentalTitles)
      AchievementDef(
        id: c.$1,
        category: AchievementCategory.titles,
        title: c.$3,
        description: c.$4,
        isEarned: (s) => s.titlesWon.contains(c.$2),
        tier: AchievementTier.gold,
      ),
    AchievementDef(
      id: 'title_nations_league',
      category: AchievementCategory.titles,
      title: 'Nations Cup Winners',
      description: 'Win the Nations Cup.',
      isEarned: (s) => s.titlesWon.contains('Nations Cup'),
      tier: AchievementTier.gold,
    ),
    AchievementDef(
      id: 'title_finalissima',
      category: AchievementCategory.titles,
      title: 'Continental Clash Winners',
      description: 'Win the Continental Clash.',
      isEarned: (s) => s.titlesWon.contains('Continental Clash'),
      tier: AchievementTier.gold,
    ),
    // ---- Misc ----
    AchievementDef(
      id: 'wc_marksman',
      category: AchievementCategory.misc,
      title: 'World Cup Marksman',
      description: 'Have a squad player score 6+ World Cup finals goals.',
      isEarned: (s) => s.wcMarksmanGoals > 5,
      tier: AchievementTier.gold,
    ),
    for (final t in cleanSheetTiers)
      AchievementDef(
        id: 'cleansheets_$t',
        category: AchievementCategory.misc,
        title: '$t Clean Sheets',
        description: 'Keep ${_count(t, 'clean sheet', 'clean sheets')}.',
        isEarned: (s) => s.cleanSheets >= t,
        tier: _tier(cleanSheetTiers.indexOf(t), cleanSheetTiers.length),
        progressOf: (s) => (s.cleanSheets, t),
      ),
    AchievementDef(
      id: 'feat_hattrick',
      category: AchievementCategory.misc,
      title: 'Hat-trick Hero',
      description: 'Have a player score a hat-trick.',
      isEarned: (s) => s.hatTricks >= 1,
      tier: AchievementTier.silver,
    ),
    AchievementDef(
      id: 'feat_motm_10',
      category: AchievementCategory.misc,
      title: 'Standout',
      description: 'Collect 10 man-of-the-match awards.',
      isEarned: (s) => s.playerMotms >= 10,
      tier: AchievementTier.silver,
      progressOf: (s) => (s.playerMotms, 10),
    ),
    AchievementDef(
      id: 'feat_motm_50',
      category: AchievementCategory.misc,
      title: 'Talisman',
      description: 'Collect 50 man-of-the-match awards.',
      isEarned: (s) => s.playerMotms >= 50,
      tier: AchievementTier.gold,
      progressOf: (s) => (s.playerMotms, 50),
    ),
    AchievementDef(
      id: 'feat_perfect',
      category: AchievementCategory.misc,
      title: 'Perfect Ten',
      description: 'Have a player earn a 9.5+ match rating.',
      isEarned: (s) => s.bestPlayerRating >= 9.5,
      tier: AchievementTier.gold,
    ),
    AchievementDef(
      id: 'feat_shootout',
      category: AchievementCategory.misc,
      title: 'Ice in the Veins',
      description: 'Win five penalty shootouts.',
      isEarned: (s) => s.shootoutsWon >= 5,
      tier: AchievementTier.gold,
      progressOf: (s) => (s.shootoutsWon, 5),
    ),
    AchievementDef(
      id: 'feat_massacre',
      category: AchievementCategory.misc,
      title: 'Massacre',
      description: 'Win a match by 7 goals or more.',
      isEarned: (s) => s.biggestWinMargin >= 7,
      tier: AchievementTier.gold,
    ),
    AchievementDef(
      id: 'feat_annihilation',
      category: AchievementCategory.misc,
      title: 'Annihilation',
      description: 'Win a match by 10 goals or more.',
      isEarned: (s) => s.biggestWinMargin >= 10,
      tier: AchievementTier.platinum,
    ),
    // ---- Mega ----
    AchievementDef(
      id: 'mega_sweep',
      category: AchievementCategory.mega,
      title: 'Clean Sweep',
      description:
          'Hold the World Cup and your continental title in one career.',
      isEarned: (s) => s.wonWorldCupAndContinental,
      tier: AchievementTier.platinum,
    ),
    AchievementDef(
      id: 'mega_allstar',
      category: AchievementCategory.mega,
      title: 'Tournament All-Star',
      description: 'Have a player named in a World Cup Team of the Tournament.',
      isEarned: (s) => s.playerInAllStars,
      tier: AchievementTier.gold,
    ),
    AchievementDef(
      id: 'mega_goldenboot',
      category: AchievementCategory.mega,
      title: 'Golden Boot',
      description: 'Have your nation finish as a championship top scorer.',
      isEarned: (s) => s.hasChampionshipGoldenBoot,
      tier: AchievementTier.gold,
    ),
    AchievementDef(
      id: 'mega_demolition',
      category: AchievementCategory.mega,
      title: 'Demolition',
      description: 'Win a match by 5 goals or more.',
      isEarned: (s) => s.biggestWinMargin >= 5,
      tier: AchievementTier.silver,
    ),
  ];

  /// Ids of every achievement unlocked for [stats].
  static Set<String> earnedIds(AchievementStats stats) =>
      {for (final a in all) if (a.isEarned(stats)) a.id};

  static String _count(int n, String one, String many) =>
      '$n ${n == 1 ? one : many}';
}
