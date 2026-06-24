import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// A qualifying group's table for display.
typedef GroupTable = ({
  int groupId,
  String name,
  List<GroupStanding> standings,
});

/// A group table tagged with the confederation it belongs to.
typedef ConfederationGroupTable = ({
  Confederation confederation,
  String groupName,
  List<GroupStanding> standings,
});

/// A World Cup finals group table.
typedef FinalsGroupTable = ({String name, List<GroupStanding> standings});

/// One attributed goal, ready to persist.
typedef GoalRecord = ({
  int careerId,
  int competitionId,
  int fixtureId,
  int nationId,
  int playerId,
  int minute,
});

/// A top-scorer tally.
typedef ScorerTally = ({int playerId, int nationId, int goals});

/// A roll-of-honour entry.
typedef Honour = ({
  int year,
  String competition,
  int championId,
  int runnerUpId,
  int? thirdId,
  int? hostId,
  int? finalHomeScore,
  int? finalAwayScore,
  String? topScorerName,
  int? topScorerGoals,
});

/// Persists and queries the competition schedule for a save.
abstract interface class CompetitionRepository {
  /// Whether a schedule has already been generated for this save.
  Future<bool> hasSchedule(int careerId);

  /// Persists a generated qualifying competition for [careerId] in [cycle].
  Future<void> saveSchedule({
    required int careerId,
    required GeneratedSchedule schedule,
    int cycle = 0,
  });

  /// A nation's fixtures, ordered by date.
  Future<List<Fixture>> fixturesForNation(int careerId, int nationId);

  /// Every fixture in the save, ordered by matchday then date.
  Future<List<Fixture>> allFixtures(int careerId);

  /// All unplayed fixtures in the save due on or before [date].
  Future<List<Fixture>> unplayedDueBy(int careerId, DateTime date);

  /// The nation's next unplayed fixture on or after [onOrAfter].
  Future<Fixture?> nextFixtureForNation(
    int careerId,
    int nationId,
    DateTime onOrAfter,
  );

  /// Records a fixture result.
  Future<void> recordResult({
    required int fixtureId,
    required int homeScore,
    required int awayScore,
  });

  /// The group table containing [nationId] for this save, or null.
  Future<GroupTable?> groupTableForNation(int careerId, int nationId);

  /// All group tables for the save's competition, ordered by group name.
  Future<List<GroupTable>> allGroupTables(int careerId);

  /// Every group table across all confederations (for browsing all draws).
  Future<List<ConfederationGroupTable>> allGroupTablesByConfederation(
    int careerId,
  );

  /// Fixtures for one confederation's competition, by matchday then date.
  Future<List<Fixture>> fixturesForConfederation(
    int careerId,
    Confederation confederation,
  );

  // --- World Cup finals -----------------------------------------------------

  /// Whether every confederation's qualifying is fully played.
  Future<bool> allQualifyingPlayed(int careerId);

  /// Whether the finals competition has been created for this save.
  Future<bool> hasFinals(int careerId);

  /// The earliest unplayed fixture date on or after [onOrAfter], or null.
  Future<DateTime?> earliestUnplayedDate(int careerId, DateTime onOrAfter);

  /// Persists the finals group-stage [draw], scheduling matchdays from
  /// [groupStart].
  Future<void> saveFinals({
    required int careerId,
    required FinalsDraw draw,
    required DateTime groupStart,
    int cycle = 0,
  });

  /// Finals group tables (groups A…H, ordered).
  Future<List<FinalsGroupTable>> finalsGroupTables(int careerId);

  /// Finals fixtures for a knockout [round] (`R16`/`QF`/`SF`/`3RD`/`FINAL`).
  Future<List<Fixture>> fixturesByRound(int careerId, String round);

  /// All finals knockout fixtures (round ≠ `GROUP`), by date then id.
  Future<List<Fixture>> finalsKnockoutFixtures(int careerId);

  /// Adds knockout fixtures for [round] on [date].
  Future<void> addKnockoutFixtures({
    required int careerId,
    required String round,
    required List<(int home, int away)> pairings,
    required DateTime date,
  });

  /// The World Cup winner (FINAL fixture winner) once played, else null.
  Future<int?> worldChampion(int careerId);

  // --- Goals & honours ------------------------------------------------------

  /// Persists attributed goals.
  Future<void> recordGoals(List<GoalRecord> goals);

  /// Top scorers across the save, optionally restricted to a competition
  /// [kind] (qualifying vs finals), best first.
  Future<List<ScorerTally>> topScorers(
    int careerId, {
    CompetitionKind? kind,
    int limit,
  });

  /// Records a tournament's roll-of-honour entry.
  Future<void> recordHonour({
    required int careerId,
    required int year,
    required String competition,
    required int championId,
    required int runnerUpId,
    int? thirdId,
    int? hostId,
    int? finalHomeScore,
    int? finalAwayScore,
    String? topScorerName,
    int? topScorerGoals,
  });

  /// Whether a [competition]/[year] honour is already recorded.
  Future<bool> hasHonour(int careerId, String competition, int year);

  /// The roll of honour for the save, newest first.
  Future<List<Honour>> honours(int careerId);
}
