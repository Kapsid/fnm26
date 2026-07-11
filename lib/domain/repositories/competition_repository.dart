import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// A qualifying group's table for display.
typedef GroupTable = ({
  int groupId,
  String name,
  String competition,
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

/// One group within a round-results view: its standings plus the fixtures that
/// were played on the round's matchday.
typedef RoundResultGroup = ({
  String name,
  List<GroupStanding> standings,
  List<Fixture> fixtures,
});

/// The results of the group-stage round the player just played, grouped by
/// group (every group in the same competition, with that matchday's scores).
typedef RoundResults = ({
  String competition,
  int matchday,
  List<RoundResultGroup> groups,
});

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

  /// Persists a generated group competition for [careerId] in [cycle]. The
  /// default [kind] is World Cup qualifying; reused for the Nations League.
  Future<void> saveSchedule({
    required int careerId,
    required GeneratedSchedule schedule,
    int cycle = 0,
    CompetitionKind kind = CompetitionKind.worldCupQualifying,
    String? fixtureRound,
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

  /// The results of the group-stage round [nationId] most recently played,
  /// grouped by every group in that competition. Null when the last played
  /// match wasn't a group-stage fixture (e.g. a knockout tie or a friendly).
  Future<RoundResults?> lastRoundResults(int careerId, int nationId);

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

  /// Persists friendlies for [nationId] in [cycle] (round label `FRIENDLY`).
  Future<void> saveFriendlies({
    required int careerId,
    required int nationId,
    required int cycle,
    required List<({DateTime date, int opponentId, bool home})> friendlies,
  });

  // --- World Cup finals -----------------------------------------------------

  /// Whether every confederation's qualifying is fully played.
  Future<bool> allQualifyingPlayed(int careerId);

  /// Whether every fixture of the current cycle's tournament(s) of [kind] is
  /// played. Returns false if no such competition exists.
  Future<bool> allPlayedForKind(int careerId, CompetitionKind kind);

  /// Whether the finals competition has been created for this save.
  Future<bool> hasFinals(int careerId);

  /// Whether the manager has already watched a given draw ([kind] is
  /// 'worldCupFinals' or a confederation name) for [cycle] — draws play once.
  Future<bool> hasWatchedDraw(int careerId, int cycle, String kind);

  /// Records that a draw ceremony has been watched (idempotent).
  Future<void> markDrawWatched(int careerId, int cycle, String kind);

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

  /// Persists a drawn group stage for any tournament [kind] (e.g. a continental
  /// championship), labelling its fixtures [round] and spacing matchdays from
  /// [groupStart]. Creates the competition.
  Future<void> saveTournamentGroups({
    required int careerId,
    required int cycle,
    required Confederation confederation,
    required CompetitionKind kind,
    required String name,
    required FinalsDraw draw,
    required DateTime groupStart,
    String round = 'GROUP',
  });

  /// Group tables for the current cycle's tournament of [kind], ordered by
  /// group name (empty if it has no group stage).
  Future<List<FinalsGroupTable>> tournamentGroupTables(
    int careerId,
    CompetitionKind kind,
  );

  /// Knockout fixtures for a [round] (`R16`/`QF`/`SF`/`3RD`/`FINAL`) of the
  /// current cycle's tournament of [kind].
  Future<List<Fixture>> fixturesByRound(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
  });

  /// All finals knockout fixtures (round ≠ `GROUP`), by date then id.
  Future<List<Fixture>> finalsKnockoutFixtures(int careerId);

  /// Adds knockout fixtures for [round] on [date] to the tournament of [kind].
  Future<void> addKnockoutFixtures({
    required int careerId,
    required String round,
    required List<(int home, int away)> pairings,
    required DateTime date,
    CompetitionKind kind = CompetitionKind.worldCupFinals,
  });

  /// Whether the current cycle has a tournament of [kind].
  Future<bool> hasTournament(int careerId, CompetitionKind kind);

  /// Creates a knockout tournament for the current cycle, seeding [pairings]
  /// as the [firstRound] (e.g. `R16` or `QF`).
  Future<void> createKnockout({
    required int careerId,
    required int cycle,
    required Confederation confederation,
    required CompetitionKind kind,
    required String name,
    required List<(int home, int away)> pairings,
    required DateTime date,
    String firstRound = 'R16',
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

  /// Top scorers for one nation, all-time across every cycle (optionally of a
  /// single competition [kind]), best first — for the team records screen.
  Future<List<ScorerTally>> nationTopScorers(
    int careerId,
    int nationId, {
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
