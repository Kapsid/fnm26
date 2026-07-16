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
  CompetitionKind kind,
  int groupCount,
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

/// The results of the stage the player just played. For a group-stage round
/// this is every group of the competition with that matchday's scores; for a
/// knockout round it is `knockoutFixtures` (all ties of that round) with a
/// human `stage` label and empty `groups`.
typedef RoundResults = ({
  String competition,
  CompetitionKind kind,
  int groupCount,
  int matchday,
  List<RoundResultGroup> groups,
  String? stage,
  List<Fixture> knockoutFixtures,
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

/// One row of a player's match-by-match history: the fixture and the player's
/// full stat line for it.
typedef PlayerMatchStat = ({
  int fixtureId,
  DateTime date,
  int homeNationId,
  int awayNationId,
  int? homeScore,
  int? awayScore,
  String? round,
  double rating,
  int goals,
  int assists,
  bool cleanSheet,
  bool motm,
});

/// A player's full stat line for one match, as written after a game.
typedef PlayerMatchLine = ({
  int playerId,
  int nationId,
  double rating,
  int goals,
  int assists,
  bool cleanSheet,
  bool motm,
  int yellows,
  int reds,
});

/// A player's aggregated career record (across every cycle in the save).
typedef PlayerCareerStats = ({
  int caps,
  int goals,
  int assists,
  int cleanSheets,
  int motm,
  int yellows,
  int reds,
  double avgRating,
  double bestRating,
  double formRating,
});

/// One inbox message.
typedef MessageItem = ({
  int id,
  String category,
  String title,
  String body,
  int year,
  bool read,
});

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
  /// Runs [action] inside a single database transaction, so many writes commit
  /// once instead of per-statement — keeps bulk world simulation fast even when
  /// every Nations Cup league is played out.
  Future<void> transact(Future<void> Function() action);

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

  /// All unplayed fixtures in the save due on or before [date]. When
  /// [excludeNationId] is given, fixtures involving that nation are left out —
  /// used so background simulation never plays the human manager's own matches.
  Future<List<Fixture>> unplayedDueBy(
    int careerId,
    DateTime date, {
    int? excludeNationId,
  });

  /// The nation's earliest unplayed fixture (regardless of the current in-game
  /// date, so a fixture the world clock has already passed is still surfaced
  /// for the player to play rather than being silently skipped).
  Future<Fixture?> nextFixtureForNation(int careerId, int nationId);

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

  /// Whether a continental-finals tournament is under way this cycle — it
  /// exists and still has an unplayed fixture. Lets the hub surface the
  /// continental championship even when the player's nation didn't qualify.
  Future<bool> hasLiveContinentalFinals(int careerId);

  /// Whether the Nations Cup Finals Four (its knockout stage — semis or final)
  /// is under way this cycle with an unplayed fixture. Lets the hub surface the
  /// Finals Four as a watchable step even when the player's nation isn't in it.
  Future<bool> hasLiveNationsCupFinals(int careerId);

  /// Whether the manager has already watched a given draw ([kind] is
  /// 'worldCupFinals' or a confederation name) for [cycle] — draws play once.
  Future<bool> hasWatchedDraw(int careerId, int cycle, String kind);

  /// Records that a draw ceremony has been watched (idempotent).
  Future<void> markDrawWatched(int careerId, int cycle, String kind);

  /// The earliest unplayed fixture date on or after [onOrAfter], or null.
  Future<DateTime?> earliestUnplayedDate(int careerId, DateTime onOrAfter);

  /// The earliest unplayed fixture date among the live finals tournaments (the
  /// World Cup + continental finals), or null when none is under way — so the
  /// hub can step a tournament the player isn't in, day by day.
  Future<DateTime?> earliestUnplayedFinalsDate(int careerId);

  /// The earliest unplayed Nations Cup Finals Four (NSF/NFINAL) fixture date, or
  /// null when none is pending — so the hub can step the Finals Four day by day
  /// even when the player's nation isn't in it.
  Future<DateTime?> earliestUnplayedNationsCupFinalsDate(int careerId);

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

  /// Adds one appearance to each of [playerIds] for [nationId] (the manager's
  /// own team). Called once per played match.
  Future<void> recordAppearances(
    int careerId,
    int nationId,
    Iterable<int> playerIds,
  );

  /// A nation's players by appearances (most games first), for team records.
  Future<List<({int playerId, int games})>> nationTopAppearances(
    int careerId,
    int nationId, {
    int limit,
  });

  /// Persists a match's per-player stat lines (both teams). Called once per
  /// played match; re-recording the same fixture overwrites its lines.
  Future<void> recordPlayerMatchStats(
    int careerId,
    int fixtureId,
    Iterable<PlayerMatchLine> lines,
  );

  /// Persists a match's team box-score (shots, possession) for the fixture.
  Future<void> recordTeamStats(
    int careerId,
    int fixtureId, {
    required int homeShots,
    required int awayShots,
    required int homePossession,
  });

  /// A player's match-by-match history (full stat line per fixture), newest
  /// first, for the player detail screen.
  Future<List<PlayerMatchStat>> playerMatchHistory(
    int careerId,
    int playerId, {
    int limit,
  });

  /// A player's aggregated career record, or null if they've never featured.
  Future<PlayerCareerStats?> playerCareerStats(int careerId, int playerId);

  /// Recent match ratings (with their dates) for every player of [nationId],
  /// newest first and capped per player — the raw input for form and fatigue.
  Future<Map<int, List<({DateTime date, double rating})>>>
      recentRatingsByNation(
    int careerId,
    int nationId, {
    int perPlayer,
  });

  /// A nation's players by assists (most first), all-time across cycles.
  Future<List<({int playerId, int assists})>> nationTopAssists(
    int careerId,
    int nationId, {
    int limit,
  });

  /// The dedup keys of every message already recorded (so sync adds each once).
  Future<Set<String>> messageKeys(int careerId);

  /// Appends a message to the inbox (ignored if [dedupKey] already exists).
  Future<void> addMessage({
    required int careerId,
    required String dedupKey,
    required String category,
    required String title,
    required String body,
    required int year,
  });

  /// The inbox, newest first.
  Future<List<MessageItem>> messages(int careerId);

  /// How many messages are unread.
  Future<int> unreadMessageCount(int careerId);

  /// Marks messages read: every unread one, or just [ids] when given (the hub
  /// pops a bounded run of messages and must only mark the ones it showed).
  Future<void> markMessagesRead(int careerId, {List<int>? ids});

  /// The ids of every achievement unlocked in this save.
  Future<Set<String>> earnedAchievements(int careerId);

  /// Marks [achievementId] earned in [year] (no-op if already recorded).
  Future<void> recordAchievement(int careerId, String achievementId, int year);
}
