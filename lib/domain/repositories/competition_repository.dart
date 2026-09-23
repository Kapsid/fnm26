import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/awards.dart';
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

/// The competitions EVERY confederation contests, and so the only fair basis
/// for a world-wide all-time chart.
///
/// This is everything on the calendar except the Nations Cup, which is a
/// European competition. Continental qualifying used to be missing from it too
/// — it was run only for the confederation the manager worked in, and the rest
/// of the world had its finals field seeded straight off the ranking — but
/// every confederation now plays its own campaign, so it counts.
///
/// The exclusion matters because a competition only one continent plays is a
/// whole extra campaign of goals every cycle that nobody else gets: counting it
/// made the "all-time world scorers" a list of whichever confederation you
/// happened to be managing in.
const globallyContestedKinds = <CompetitionKind>{
  CompetitionKind.worldCupQualifying,
  CompetitionKind.worldCupPlayoff,
  CompetitionKind.worldCupFinals,
  CompetitionKind.continentalQualifying,
  CompetitionKind.continentalFinals,
  CompetitionKind.finalissima,
};

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

/// A player's aggregated performance across one competition.
typedef TournamentLine = ({
  int playerId,
  int nationId,
  int apps,
  double meanRating,
  int goals,
  int assists,
  int motms,
  int cleanSheets,
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

/// The head-to-head record between two nations across a save: from nation A's
/// point of view (its wins, the draws, its losses, and both sides' goals).
typedef HeadToHead = ({
  int played,
  int winsA,
  int draws,
  int winsB,
  int goalsA,
  int goalsB,
  int biggestWinMarginA,
  int biggestWinMarginB,
});

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

/// One trophy in a player's cabinet.
///
/// Named for the award rather than the row: drift generates its own
/// `PlayerHonour` data class from the table, and two of them in scope is a
/// clash the analyser is right to object to.
typedef PlayerAward = ({
  int playerId,
  int nationId,
  AwardKind kind,
  String competition,
  int year,
});

/// A roll-of-honour entry.
typedef Honour = ({
  int year,
  String competition,
  int championId,
  int runnerUpId,
  int? thirdId,
  // A second bronze, for a cup with no third-place match (both beaten
  // semi-finalists share bronze). Null for the World Cup.
  int? thirdId2,
  int? hostId,

  /// Every host, primary first. Single-element for an ordinary edition, empty
  /// only for a historical row that never recorded one.
  List<int> hostIds,
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

  /// A nation's fixtures **in the current cycle only**, ordered by date.
  ///
  /// A career is endless, so the all-time list above answers "every game this
  /// nation has ever played" — the wrong question for anything judging THIS
  /// cycle (the board's objectives, how far the side went in the tournament
  /// that just finished). Those read this instead.
  Future<List<Fixture>> cycleFixturesForNation(int careerId, int nationId);

  /// The display name of every competition in the save, keyed by competition
  /// id — so a fixture's `competitionId` can be shown as a readable label.
  Future<Map<int, String>> competitionNames(int careerId);

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

  /// Records a fixture result. For a level knockout, [afterExtraTime] marks an
  /// ET finish and [homePenalties]/[awayPenalties] carry the shootout score.
  Future<void> recordResult({
    required int fixtureId,
    required int homeScore,
    required int awayScore,
    bool afterExtraTime,
    int? homePenalties,
    int? awayPenalties,
  });

  /// Moves an unplayed fixture to a new [date] (e.g. splitting a legacy save's
  /// third-place play-off and final that shared a day).
  Future<void> rescheduleFixture(int fixtureId, DateTime date);

  /// The group table containing [nationId] for this save, or null.
  Future<GroupTable?> groupTableForNation(int careerId, int nationId);

  /// The results of the group-stage round [nationId] most recently played,
  /// grouped by every group in that competition. Null when the last played
  /// match wasn't a group-stage fixture (e.g. a knockout tie or a friendly).
  Future<RoundResults?> lastRoundResults(int careerId, int nationId);

  /// All group tables for the save's competition, ordered by group name.
  Future<List<GroupTable>> allGroupTables(int careerId);

  /// Every group in the save by id, with the letter it is known by ("A", "B").
  ///
  /// Fixtures carry a group id and nothing else, so a screen that wants to
  /// SHOW its results group by group — the round popup a manager steps a
  /// tournament through — has no way to name what it is grouping without
  /// this.
  Future<Map<int, String>> groupNames(int careerId);

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
  /// Whether every fixture of [kind] this cycle has been played. Name a
  /// [confederation] for the continental cups: all six confederations' cups are
  /// competitions of the same kind, so an unqualified call answers for whichever
  /// continents happen to exist.
  Future<bool> allPlayedForKind(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  });

  /// Whether the finals competition has been created for this save.
  Future<bool> hasFinals(int careerId);

  /// Whether a continental-finals tournament is under way this cycle — it
  /// exists and still has an unplayed fixture. Lets the hub surface the
  /// continental championship even when the player's nation didn't qualify.
  Future<bool> hasLiveContinentalFinals(
    int careerId, {
    Confederation? confederation,
  });

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
  ///
  /// [playerConfederation] limits the continental finals considered to the
  /// player's own region — every region's cup exists as fixtures, but only the
  /// player's is stepped day by day (the rest resolve in the background).
  Future<DateTime?> earliestUnplayedFinalsDate(
    int careerId, {
    Confederation? playerConfederation,
  });

  /// The earliest unplayed Nations Cup Finals Four (NSF/NFINAL) fixture date, or
  /// null when none is pending — so the hub can step the Finals Four day by day
  /// even when the player's nation isn't in it.
  Future<DateTime?> earliestUnplayedNationsCupFinalsDate(int careerId);

  /// The earliest unplayed fixture date of the current cycle's tournament of
  /// [kind] (optionally the one for [confederation]), or null when none pends —
  /// so the hub can tell when a tournament's FIRST match is imminent and fire
  /// its opening ceremony right before it, not weeks early behind friendlies.
  Future<DateTime?> earliestUnplayedDateOfKind(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  });

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
    CompetitionKind kind, {
    Confederation? confederation,
  });

  /// Knockout fixtures for a [round] (`R16`/`QF`/`SF`/`3RD`/`FINAL`) of the
  /// current cycle's tournament of [kind].
  Future<List<Fixture>> fixturesByRound(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
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
    Confederation? confederation,
  });

  /// Whether the current cycle has a tournament of [kind].
  Future<bool> hasTournament(
    int careerId,
    CompetitionKind kind, {
    Confederation? confederation,
  });

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

  /// The continental championship winner for this cycle (its CFINAL winner)
  /// once played, else null. Scoped to [confederation] when given, so one
  /// region's cup being over is never confused with another's still running.
  Future<int?> continentalChampion(
    int careerId, {
    Confederation? confederation,
  });

  // --- Goals & honours ------------------------------------------------------

  /// Persists attributed goals.
  Future<void> recordGoals(List<GoalRecord> goals);

  /// Every goal in the save as a minute-ordered timeline per fixture
  /// (`fixtureId` → the goals in the order they were scored).
  ///
  /// This is what makes a scoreline a story rather than a number: it is the
  /// only way to know a side came from behind, since a fixture row records how
  /// a match ENDED and nothing about how it got there.
  Future<Map<int, List<({int nationId, int minute})>>> goalTimeline(
    int careerId,
  );

  /// Who scored, match by match, for one nation: fixture id → that fixture's
  /// scorers with their goals in it.
  ///
  /// [goalTimeline] answers "when", which is what a comeback needs; this
  /// answers "who", which is what anything writing ABOUT a match needs — a
  /// report that cannot name the scorer can only talk about the scoreline.
  Future<Map<int, Map<int, int>>> scorersByFixture(
    int careerId,
    int nationId,
  );

  /// Top scorers across the save, optionally restricted to a competition
  /// [kind] (qualifying vs finals), best first.
  Future<List<ScorerTally>> topScorers(
    int careerId, {
    CompetitionKind? kind,
    Confederation? confederation,
    int limit,
  });

  /// All-time top scorers across every cycle for a competition [kind] — the
  /// save's own record book. Excludes the pre-seeded real-world history (which
  /// stores no goal events), best first. With no [kind], every competition
  /// counts (the global chart). Pass [confederation] to scope a continental
  /// championship to its own region, so each cup has its own all-time chart.
  Future<List<ScorerTally>> allTimeTopScorers(
    int careerId, {
    CompetitionKind? kind,
    Confederation? confederation,

    /// Restrict the tally to these competition kinds. Use for the WORLD chart,
    /// which must only count competitions every confederation actually plays —
    /// see [globallyContestedKinds].
    Set<CompetitionKind>? kinds,
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
  ///
  /// Pass [hostIds] for a co-hosted edition, primary host first; [hostId] alone
  /// is enough for the ordinary single-host case and stays the primary host
  /// either way.
  Future<void> recordHonour({
    required int careerId,
    required int year,
    required String competition,
    required int championId,
    required int runnerUpId,
    int? thirdId,
    int? thirdId2,
    int? hostId,
    List<int> hostIds = const [],
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

  /// All-time most-capped players across EVERY nation (most games first) — the
  /// save's global appearance record, best first.
  Future<List<({int playerId, int nationId, int games})>> allTimeTopAppearances(
    int careerId, {
    int limit,
  });

  /// Logs each player's participation in [competitionId] (one competition
  /// edition), for tournament-scoped records. Every [player] gains one
  /// appearance; those with `started == true` also gain one start. Called once
  /// per played match, for the whole world (both teams).
  Future<void> recordTournamentAppearances(
    int careerId,
    int competitionId,
    Iterable<({int playerId, int nationId, bool started})> players,
  );

  /// Total tournament STARTS per player across the whole save (every nation),
  /// for the career-development bonus — a player who has started many matches
  /// grows a touch. Keyed by player id.
  Future<Map<int, int>> careerStartsByPlayer(int careerId);

  /// All-time most STARTS in competitions of [kind] (e.g. World Cup finals),
  /// across every nation and edition (most starts first) — for the records
  /// screen's tournament leaderboards.
  Future<List<({int playerId, int nationId, int starts})>> mostTournamentStarts(
    int careerId, {
    required CompetitionKind kind,
    int limit,
  });

  /// All-time most distinct tournaments ATTENDED (an appearance in an edition of
  /// any of [kinds]) across every nation, most first — "most cups attended".
  Future<List<({int playerId, int nationId, int tournaments})>>
  mostTournamentsAttended(
    int careerId, {
    required Set<CompetitionKind> kinds,
    int limit,
  });

  /// Per-PLAYER all-time records for a cup: matches PLAYED (appearances) and
  /// distinct finals-tournament editions ATTENDED, across every edition of
  /// [kind] (optionally narrowed to one [confederation], for a continental cup).
  /// Ordered by games played, most first.
  Future<List<({int playerId, int nationId, int games, int finals})>>
  playerCupRecords(
    int careerId, {
    required CompetitionKind kind,
    Confederation? confederation,
  });

  /// The manager nation's Nations Cup finish in every edition it played: the
  /// league it was in (A/B/…), its final group position (1 = top), the group
  /// size, and its Finals Four result if it reached the last four. One entry per
  /// cycle, for the career-history "which league, and how it ended".
  Future<
    List<
      ({
        int cycle,
        String league,
        int position,
        int groupSize,
        String? finals,
      })
    >
  >
  nationsCupFinishes(int careerId, int nationId);

  /// The all-time head-to-head record between [nationA] and [nationB] across
  /// every played fixture in the save (friendlies included).
  Future<HeadToHead> headToHead(int careerId, int nationA, int nationB);

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
    double homeXg,
    double awayXg,
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

  /// Every recorded player-rating line for players who represented one of
  /// [nationIds] — the raw feed for career feats (hat-tricks, MOTMs, cards,
  /// best rating). One entry per (player, match).
  ///
  /// Rating rows now exist for EVERY match in the world (the tactical engine
  /// writes the manager's, `BackgroundMatch` derives the rest), so pass the
  /// nations actually being asked about; passing the manager's own stint
  /// nations gives their career feats as before.
  Future<
    List<
      ({
        int playerId,
        int goals,
        int assists,
        double rating,
        bool motm,
        int yellows,
        int reds,
      })
    >
  >
  careerPlayerLines(int careerId, Set<int> nationIds);

  /// How everyone who appeared in [competitionId] actually played: one entry
  /// per player, aggregated across their appearances in that competition.
  ///
  /// This is what turns a Team of the Tournament from a guess into a verdict.
  /// The awards used to be picked from squad `overall` and goals, because
  /// performance data existed only for the manager's own matches; every match
  /// in the world is rated now, so a tournament can be judged on how it was
  /// played.
  Future<List<TournamentLine>> competitionPlayerLines(
    int careerId,
    int competitionId,
  );

  /// A nation's players by assists (most first), all-time across cycles.
  /// A nation's players by average match rating (best first), across every
  /// match of the save, for players with at least [minApps] appearances.
  ///
  /// Every match in the world is rated now, so this reads a full record rather
  /// than only the games the manager happened to be in charge for.
  Future<List<({int playerId, int apps, double meanRating, int motms})>>
  nationTopRatings(
    int careerId,
    int nationId, {
    int minApps,
    int limit,
  });

  Future<List<({int playerId, int assists})>> nationTopAssists(
    int careerId,
    int nationId, {
    int limit,
  });

  /// One individual trophy a player has won.
  ///
  /// Stored rather than derived — see `PlayerHonours` for why.
  Future<void> recordPlayerHonour({
    required int careerId,
    required int playerId,
    required int nationId,
    required AwardKind kind,
    required int year,
    String competition,
  });

  /// A player's trophy cabinet, newest first.
  Future<List<PlayerAward>> playerHonours(int careerId, int playerId);

  /// Every player's year across the WHOLE WORLD, for the yearly awards. Reads
  /// the per-match ratings the world simulation writes for every game played
  /// anywhere, not only the manager's own.
  Future<List<AwardLine>> awardLinesForYear(int careerId, int year);

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
