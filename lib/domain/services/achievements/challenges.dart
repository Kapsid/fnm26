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
}

/// One challenge: its identity, how it reads, and how it is judged.
class ChallengeDef {
  const ChallengeDef({
    required this.id,
    required this.title,
    required this.description,
    required this.progressOf,
    this.brutal = false,
  });

  /// Stable id — never change once shipped.
  final String id;
  final String title;
  final String description;

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
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_wc_allconf',
      title: 'World Conqueror',
      description:
          'Win the World Cup with a nation from every confederation (6).',
      progressOf: _wcAllConf,
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
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_years_1000',
      title: 'Eternal',
      description: 'Manage for 1000 years.',
      progressOf: _years1000,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_grandmaster',
      title: 'Grandmaster',
      description: 'Win 3 World Cups AND 5 continental championships.',
      progressOf: _grandmaster,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_undefeated',
      title: 'Untouchable',
      description: 'Win a World Cup without losing a single match.',
      progressOf: _undefeated,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_perfect_qual',
      title: 'Flawless Passage',
      description: 'Win every match of a World Cup qualifying campaign.',
      progressOf: _perfectQual,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_minnow',
      title: 'Minnow Miracle',
      description:
          'Win the World Cup with a nation ranked outside the world top 32.',
      progressOf: _minnow,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_grand_tour',
      title: 'Home & Away',
      description: 'Win a World Cup as hosts and win one away from home.',
      progressOf: _grandTour,
      brutal: true,
    ),
    ChallengeDef(
      id: 'ch_unbeaten_25',
      title: 'The Wall',
      description: 'Go 25 competitive matches unbeaten.',
      progressOf: _unbeaten25,
      brutal: true,
    ),
  ];

  // Top-level functions (const tear-offs can't close over locals).
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

  static (int, int) _unbeaten25(ChallengeStats s) =>
      (s.longestUnbeatenRun, 25);
}
