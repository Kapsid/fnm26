import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';

/// Career-defining "challenges" — the brutal, long-haul goals a manager chases
/// across a whole save (many nations, many cycles), distinct from the
/// match-to-match achievements. Pure and unit-testable: the snapshot is
/// gathered in the feature layer (`challenge_providers.dart`).

/// A snapshot of the manager's whole career, across every nation and cycle.
class ChallengeStats {
  const ChallengeStats({
    required this.worldCupTitles,
    required this.distinctWorldCupNations,
    required this.worldCupConfederations,
    required this.mostWorldCupsInARow,
    required this.continentalTitles,
    required this.continentalCupsWon,
    required this.nationsCupTitles,
    required this.clashTitles,
    required this.yearsManaged,
    required this.nationsManaged,
    this.wonWorldCupUndefeated = false,
    this.perfectQualifying = false,
    this.wonWorldCupAsHost = false,
    this.wonWorldCupAsVisitor = false,
    this.wonWorldCupAsMinnow = false,
    this.longestUnbeatenRun = 0,
    this.longestWinStreak = 0,
    this.careerGoals = 0,
    this.careerCleanSheets = 0,
    this.careerHatTricks = 0,
  });

  /// World Cups won by the manager (whichever nation they led that cycle).
  final int worldCupTitles;

  /// How many DIFFERENT nations the manager has won the World Cup with.
  final int distinctWorldCupNations;

  /// The confederations of the nations the manager has won the World Cup with.
  final Set<Confederation> worldCupConfederations;

  /// The longest run of consecutive World Cups (4 years apart) the manager won.
  final int mostWorldCupsInARow;

  /// Continental championships won by the manager, in total.
  final int continentalTitles;

  /// The distinct continental-cup names the manager has won (for the "win every
  /// continental championship" challenge — one per confederation).
  final Set<String> continentalCupsWon;

  /// Nations Cup titles won.
  final int nationsCupTitles;

  /// Continental Clash titles won.
  final int clashTitles;

  /// In-game years elapsed since the career began.
  final int yearsManaged;

  /// Distinct nations the manager has led.
  final int nationsManaged;

  /// Won a World Cup without losing a single match in that finals tournament.
  final bool wonWorldCupUndefeated;

  /// Won every match of a World Cup qualifying campaign (min. six games).
  final bool perfectQualifying;

  /// Won a World Cup as the host nation.
  final bool wonWorldCupAsHost;

  /// Won a World Cup away from home (a nation that wasn't the host).
  final bool wonWorldCupAsVisitor;

  /// Won a World Cup with a nation ranked outside the world's top 32.
  final bool wonWorldCupAsMinnow;

  /// The manager's longest unbeaten run of competitive matches, any nation.
  final int longestUnbeatenRun;

  /// The manager's longest run of consecutive wins, any nation.
  final int longestWinStreak;

  /// Lifetime goals scored, clean sheets kept, and hat-tricks by the manager's
  /// players — the running career totals behind the collector challenges.
  final int careerGoals, careerCleanSheets, careerHatTricks;
}

/// A challenge's difficulty tier — a ladder from a first taste of success to
/// the truly legendary, so the list reads as a climb and the badge cabinet can
/// group by prestige.
enum ChallengeTier { bronze, silver, gold, legendary }

extension ChallengeTierX on ChallengeTier {
  String get label => switch (this) {
    ChallengeTier.bronze => 'Bronze',
    ChallengeTier.silver => 'Silver',
    ChallengeTier.gold => 'Gold',
    ChallengeTier.legendary => 'Legendary',
  };

  /// Sort/rank order (bronze first).
  int get rank => index;
}

/// One challenge: its identity, how it reads, and how it is judged.
class ChallengeDef {
  const ChallengeDef({
    required this.id,
    required this.title,
    required this.description,
    required this.progressOf,
    this.tier = ChallengeTier.gold,
    this.brutal = false,
    this.procedural = false,
  });

  /// Whether this challenge was generated for THIS save (a seeded target),
  /// rather than a fixed catalogue entry — shown in its own section.
  final bool procedural;

  /// Stable id — never change once shipped.
  final String id;
  final String title;
  final String description;

  /// The difficulty tier, for grouping and the badge cabinet.
  final ChallengeTier tier;

  /// A `(current, target)` pair; complete when `current >= target`.
  final (int, int) Function(ChallengeStats) progressOf;

  /// The truly punishing ones, flagged so the UI can mark them.
  final bool brutal;

  bool isComplete(ChallengeStats s) {
    final (cur, target) = progressOf(s);
    return cur >= target;
  }
}

/// The catalogue of challenges, hardest-earned roughly last.
abstract final class ChallengeCatalog {
  static const List<ChallengeDef> all = [
    // --- Bronze: a first taste of success -----------------------------------
    ChallengeDef(
      id: 'ch_first_steps',
      title: 'In the Dugout',
      description: 'Manage for 5 years.',
      progressOf: _years5,
      tier: ChallengeTier.bronze,
    ),
    ChallengeDef(
      id: 'ch_unbeaten_10',
      title: 'On a Roll',
      description: 'Go 10 competitive matches unbeaten.',
      progressOf: _unbeaten10,
      tier: ChallengeTier.bronze,
    ),
    ChallengeDef(
      id: 'ch_two_nations',
      title: 'Fresh Challenge',
      description: 'Manage 2 different nations.',
      progressOf: _nations2,
      tier: ChallengeTier.bronze,
    ),
    // --- Silver: first silverware -------------------------------------------
    ChallengeDef(
      id: 'ch_cont_1',
      title: 'Continental Champion',
      description: 'Win a continental championship.',
      progressOf: _cont1,
      tier: ChallengeTier.silver,
    ),
    ChallengeDef(
      id: 'ch_nc_1',
      title: 'Nations Cup Winner',
      description: 'Win the Nations Cup.',
      progressOf: _nc1,
      tier: ChallengeTier.silver,
    ),
    ChallengeDef(
      id: 'ch_wc_1',
      title: 'World Champion',
      description: 'Win the World Cup.',
      progressOf: _wc1,
      tier: ChallengeTier.silver,
    ),
    ChallengeDef(
      id: 'ch_years_25',
      title: 'Establishment',
      description: 'Manage for 25 years.',
      progressOf: _years25,
      tier: ChallengeTier.silver,
    ),
    // --- Gold and Legendary -------------------------------------------------
    ChallengeDef(
      id: 'ch_wc_3',
      title: 'Serial Winner',
      description: 'Win 3 World Cups.',
      progressOf: _wc3,
    ),
    ChallengeDef(
      id: 'ch_wc_5',
      title: 'Dynasty',
      description: 'Win 5 World Cups.',
      progressOf: _wc5,
    ),
    ChallengeDef(
      id: 'ch_wc_10',
      title: 'Immortal',
      description: 'Win 10 World Cups.',
      progressOf: _wc10,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_wc_2teams',
      title: 'Have Boots, Will Travel',
      description: 'Win the World Cup with 2 different nations.',
      progressOf: _wc2Teams,
    ),
    ChallengeDef(
      id: 'ch_wc_3teams',
      title: 'Globetrotter',
      description: 'Win the World Cup with 3 different nations.',
      progressOf: _wc3Teams,
    ),
    ChallengeDef(
      id: 'ch_wc_streak3',
      title: 'Three-Peat',
      description: 'Win 3 World Cups in a row.',
      progressOf: _wcStreak3,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_wc_allconf',
      title: 'World Conqueror',
      description:
          'Win the World Cup with a nation from every confederation (6).',
      progressOf: _wcAllConf,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_cont_5',
      title: 'Continental King',
      description: 'Win 5 continental championships.',
      progressOf: _cont5,
    ),
    ChallengeDef(
      id: 'ch_cont_all',
      title: 'Six-Continent Slam',
      description: 'Win every confederation’s continental championship (6).',
      progressOf: _contAll,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_treble',
      title: 'Clean Sweep',
      description:
          'Win the World Cup, a continental title and the Nations Cup in one '
          'career.',
      progressOf: _cleanSweep,
    ),
    ChallengeDef(
      id: 'ch_nations_10',
      title: 'Nomad',
      description: 'Manage 10 different nations.',
      progressOf: _nations10,
    ),
    ChallengeDef(
      id: 'ch_years_100',
      title: 'Century',
      description: 'Manage for 100 years.',
      progressOf: _years100,
    ),
    ChallengeDef(
      id: 'ch_years_500',
      title: 'Half a Millennium',
      description: 'Manage for 500 years.',
      progressOf: _years500,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_years_1000',
      title: 'Eternal',
      description: 'Manage for 1000 years.',
      progressOf: _years1000,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_grandmaster',
      title: 'Grandmaster',
      description: 'Win 3 World Cups AND 5 continental championships.',
      progressOf: _grandmaster,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_undefeated',
      title: 'Untouchable',
      description: 'Win a World Cup without losing a single match.',
      progressOf: _undefeated,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_perfect_qual',
      title: 'Flawless Passage',
      description: 'Win every match of a World Cup qualifying campaign.',
      progressOf: _perfectQual,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_minnow',
      title: 'Minnow Miracle',
      description:
          'Win the World Cup with a nation ranked outside the world top 32.',
      progressOf: _minnow,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_grand_tour',
      title: 'Home & Away',
      description: 'Win a World Cup as hosts and win one away from home.',
      progressOf: _grandTour,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_unbeaten_25',
      title: 'The Wall',
      description: 'Go 25 competitive matches unbeaten.',
      progressOf: _unbeaten25,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    // --- Career collectors (lifetime totals across every nation) -------------
    ChallengeDef(
      id: 'ch_goals_10k',
      title: 'Goal Machine',
      description: 'Score 10,000 career goals.',
      progressOf: _goals10k,
    ),
    ChallengeDef(
      id: 'ch_cleansheets_500',
      title: 'Fortress',
      description: 'Keep 500 career clean sheets.',
      progressOf: _cleanSheets500,
    ),
    ChallengeDef(
      id: 'ch_hattricks_25',
      title: 'Hat-trick Habit',
      description: 'Have your players score 25 hat-tricks.',
      progressOf: _hatTricks25,
    ),
    ChallengeDef(
      id: 'ch_winstreak_25',
      title: 'Relentless',
      description: 'Win 25 matches in a row.',
      progressOf: _winStreak25,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_cont_10',
      title: 'Continental Dynasty',
      description: 'Win 10 continental championships.',
      progressOf: _cont10,
      tier: ChallengeTier.legendary,
      brutal: true,
    ),
  ];

  // Top-level functions (const tear-offs can't close over locals).
  static (int, int) _years5(ChallengeStats s) => (s.yearsManaged, 5);
  static (int, int) _years25(ChallengeStats s) => (s.yearsManaged, 25);
  static (int, int) _unbeaten10(ChallengeStats s) => (s.longestUnbeatenRun, 10);
  static (int, int) _nations2(ChallengeStats s) => (s.nationsManaged, 2);
  static (int, int) _cont1(ChallengeStats s) => (s.continentalTitles, 1);
  static (int, int) _nc1(ChallengeStats s) => (s.nationsCupTitles, 1);
  static (int, int) _wc1(ChallengeStats s) => (s.worldCupTitles, 1);
  static (int, int) _wc3(ChallengeStats s) => (s.worldCupTitles, 3);
  static (int, int) _wc5(ChallengeStats s) => (s.worldCupTitles, 5);
  static (int, int) _wc10(ChallengeStats s) => (s.worldCupTitles, 10);
  static (int, int) _wc2Teams(ChallengeStats s) =>
      (s.distinctWorldCupNations, 2);
  static (int, int) _wc3Teams(ChallengeStats s) =>
      (s.distinctWorldCupNations, 3);
  static (int, int) _wcStreak3(ChallengeStats s) => (s.mostWorldCupsInARow, 3);
  static (int, int) _wcAllConf(ChallengeStats s) =>
      (s.worldCupConfederations.length, 6);
  static (int, int) _cont5(ChallengeStats s) => (s.continentalTitles, 5);
  static (int, int) _contAll(ChallengeStats s) =>
      (s.continentalCupsWon.length, 6);
  static (int, int) _cleanSweep(ChallengeStats s) {
    // The Continental Clash is deliberately excluded — a true clean sweep is
    // the World Cup, a continental title and the Nations Cup.
    var done = 0;
    if (s.worldCupTitles > 0) done++;
    if (s.continentalTitles > 0) done++;
    if (s.nationsCupTitles > 0) done++;
    return (done, 3);
  }

  static (int, int) _nations10(ChallengeStats s) => (s.nationsManaged, 10);
  static (int, int) _years100(ChallengeStats s) => (s.yearsManaged, 100);
  static (int, int) _years500(ChallengeStats s) => (s.yearsManaged, 500);
  static (int, int) _years1000(ChallengeStats s) => (s.yearsManaged, 1000);
  static (int, int) _grandmaster(ChallengeStats s) {
    // Two sub-goals; progress is how many are met, target 2.
    var done = 0;
    if (s.worldCupTitles >= 3) done++;
    if (s.continentalTitles >= 5) done++;
    return (done, 2);
  }

  static (int, int) _undefeated(ChallengeStats s) =>
      (s.wonWorldCupUndefeated ? 1 : 0, 1);
  static (int, int) _perfectQual(ChallengeStats s) =>
      (s.perfectQualifying ? 1 : 0, 1);
  static (int, int) _minnow(ChallengeStats s) =>
      (s.wonWorldCupAsMinnow ? 1 : 0, 1);
  static (int, int) _grandTour(ChallengeStats s) {
    var done = 0;
    if (s.wonWorldCupAsHost) done++;
    if (s.wonWorldCupAsVisitor) done++;
    return (done, 2);
  }

  static (int, int) _unbeaten25(ChallengeStats s) => (s.longestUnbeatenRun, 25);
  static (int, int) _goals10k(ChallengeStats s) => (s.careerGoals, 10000);
  static (int, int) _cleanSheets500(ChallengeStats s) =>
      (s.careerCleanSheets, 500);
  static (int, int) _hatTricks25(ChallengeStats s) => (s.careerHatTricks, 25);
  static (int, int) _winStreak25(ChallengeStats s) => (s.longestWinStreak, 25);
  static (int, int) _cont10(ChallengeStats s) => (s.continentalTitles, 10);
}

/// Per-save procedural challenges: the same kinds of goal as the catalogue, but
/// with targets rolled from the save seed, so every career chases a slightly
/// different set. Judged against the same [ChallengeStats]. Ids are stable per
/// save (the seed fixes the targets), so progress reads consistently.
abstract final class ProceduralChallenges {
  static List<ChallengeDef> forSeed(int seed) {
    final rng = SeededRng(seed ^ 0x0C4A11E9);
    final wc = 2 + rng.nextInt(4); // 2..5
    final nations = 3 + rng.nextInt(8); // 3..10
    final unbeaten = 15 + rng.nextInt(21); // 15..35
    final majors = 3 + rng.nextInt(6); // 3..8
    final years = 40 + rng.nextInt(160); // 40..199
    return [
      ChallengeDef(
        id: 'pc_wc',
        title: 'Serial Champion',
        description: 'Win $wc World Cups this save.',
        progressOf: (s) => (s.worldCupTitles, wc),
        procedural: true,
      ),
      ChallengeDef(
        id: 'pc_majors',
        title: 'Silverware Collector',
        description:
            'Win $majors major trophies (World Cup, continental or Nations Cup).',
        progressOf: (s) => (
          s.worldCupTitles + s.continentalTitles + s.nationsCupTitles,
          majors,
        ),
        procedural: true,
      ),
      ChallengeDef(
        id: 'pc_unbeaten',
        title: 'Iron Wall',
        description: 'Go $unbeaten competitive matches unbeaten.',
        progressOf: (s) => (s.longestUnbeatenRun, unbeaten),
        procedural: true,
      ),
      ChallengeDef(
        id: 'pc_nations',
        title: 'Journeyman',
        description: 'Manage $nations different nations.',
        progressOf: (s) => (s.nationsManaged, nations),
        tier: ChallengeTier.silver,
        procedural: true,
      ),
      ChallengeDef(
        id: 'pc_years',
        title: 'The Long Haul',
        description: 'Manage for $years years.',
        progressOf: (s) => (s.yearsManaged, years),
        tier: ChallengeTier.silver,
        procedural: true,
      ),
    ];
  }
}
