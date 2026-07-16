/// The per-save achievement system: a static catalogue of achievements and a
/// pure [AchievementStats] snapshot they are evaluated against. Gathering the
/// snapshot from the repositories lives in the feature layer
/// (`achievement_providers.dart`); this file stays pure and unit-testable.
library;

/// The sections achievements are grouped under on the achievements screen.
enum AchievementCategory {
  wins('Wins'),
  matches('Matches'),
  qualifications('Qualifications'),
  titles('Titles'),
  misc('Misc'),
  mega('Mega');

  const AchievementCategory(this.label);

  /// The section heading shown in the UI.
  final String label;
}

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
    this.progressOf,
  });

  /// Stable id persisted once unlocked — never change these.
  final String id;
  final AchievementCategory category;
  final String title;
  final String description;

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
        progressOf: (s) => (s.wins, t),
      ),
    // ---- Matches ----
    for (final t in matchTiers)
      AchievementDef(
        id: 'matches_$t',
        category: AchievementCategory.matches,
        title: '$t Matches',
        description: 'Play ${_count(t, 'match', 'matches')}.',
        isEarned: (s) => s.matchesPlayed >= t,
        progressOf: (s) => (s.matchesPlayed, t),
      ),
    // ---- Qualifications ----
    AchievementDef(
      id: 'qual_wc',
      category: AchievementCategory.qualifications,
      title: 'World Cup Qualifier',
      description: 'Reach the World Cup finals.',
      isEarned: (s) => s.reachedWorldCup,
    ),
    AchievementDef(
      id: 'qual_cont',
      category: AchievementCategory.qualifications,
      title: 'Continental Qualifier',
      description: 'Reach your continental championship finals.',
      isEarned: (s) => s.reachedContinental,
    ),
    // ---- Titles (one per competition) ----
    AchievementDef(
      id: 'title_wc',
      category: AchievementCategory.titles,
      title: 'World Champions',
      description: 'Win the World Cup.',
      isEarned: (s) => s.titlesWon.contains(worldCupHonourName),
    ),
    for (final c in _continentalTitles)
      AchievementDef(
        id: c.$1,
        category: AchievementCategory.titles,
        title: c.$3,
        description: c.$4,
        isEarned: (s) => s.titlesWon.contains(c.$2),
      ),
    AchievementDef(
      id: 'title_nations_league',
      category: AchievementCategory.titles,
      title: 'Nations Cup Winners',
      description: 'Win the Nations Cup.',
      isEarned: (s) => s.titlesWon.contains('Nations Cup'),
    ),
    AchievementDef(
      id: 'title_finalissima',
      category: AchievementCategory.titles,
      title: 'Continental Clash Winners',
      description: 'Win the Continental Clash.',
      isEarned: (s) => s.titlesWon.contains('Continental Clash'),
    ),
    // ---- Misc ----
    AchievementDef(
      id: 'wc_marksman',
      category: AchievementCategory.misc,
      title: 'World Cup Marksman',
      description: 'Have a squad player score 6+ World Cup finals goals.',
      isEarned: (s) => s.wcMarksmanGoals > 5,
    ),
    // ---- Mega ----
    AchievementDef(
      id: 'mega_sweep',
      category: AchievementCategory.mega,
      title: 'Clean Sweep',
      description:
          'Hold the World Cup and your continental title in one career.',
      isEarned: (s) => s.wonWorldCupAndContinental,
    ),
    AchievementDef(
      id: 'mega_allstar',
      category: AchievementCategory.mega,
      title: 'Tournament All-Star',
      description: 'Have a player named in a World Cup Team of the Tournament.',
      isEarned: (s) => s.playerInAllStars,
    ),
    AchievementDef(
      id: 'mega_goldenboot',
      category: AchievementCategory.mega,
      title: 'Golden Boot',
      description: 'Have your nation finish as a championship top scorer.',
      isEarned: (s) => s.hasChampionshipGoldenBoot,
    ),
    AchievementDef(
      id: 'mega_demolition',
      category: AchievementCategory.mega,
      title: 'Demolition',
      description: 'Win a match by 5 goals or more.',
      isEarned: (s) => s.biggestWinMargin >= 5,
    ),
    AchievementDef(
      id: 'mega_harmony',
      category: AchievementCategory.mega,
      title: 'Total Satisfaction',
      description: 'Reach 100% board satisfaction.',
      isEarned: (s) => s.satisfaction >= 100,
    ),
  ];

  /// Ids of every achievement unlocked for [stats].
  static Set<String> earnedIds(AchievementStats stats) =>
      {for (final a in all) if (a.isEarned(stats)) a.id};

  static String _count(int n, String one, String many) =>
      '$n ${n == 1 ? one : many}';
}
