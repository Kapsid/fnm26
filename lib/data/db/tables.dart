import 'package:drift/drift.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';

/// Drift table definitions for the local SQLite database.
///
/// Enums are stored by name (`textEnum`) so reordering enum members never
/// corrupts existing data. Reference tables (Nations, Players) are populated
/// from bundled seed assets; Careers are created at runtime.

/// National teams (reference data, seeded).
@DataClassName('NationRow')
class Nations extends Table {
  /// Stable id supplied by the seed data (not auto-incremented).
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get code => text().withLength(min: 2, max: 3)();
  TextColumn get confederation => textEnum<Confederation>()();
  IntColumn get ranking => integer().withDefault(const Constant(0))();
  BoolColumn get isFreeDemo => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Players eligible for national-team call-ups (reference data, seeded).
@DataClassName('PlayerRow')
class Players extends Table {
  /// Stable id supplied by the seed data.
  IntColumn get id => integer()();
  IntColumn get nationId =>
      integer().references(Nations, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get position => textEnum<PlayerPosition>()();

  // Attribute block (1..99 each).
  IntColumn get passing => integer()();
  IntColumn get shooting => integer()();
  IntColumn get dribbling => integer()();
  IntColumn get tackling => integer()();
  IntColumn get positioning => integer()();
  IntColumn get composure => integer()();
  IntColumn get decisions => integer()();
  IntColumn get pace => integer()();
  IntColumn get stamina => integer()();
  IntColumn get strength => integer()();

  /// The player's club side (display/scouting only).
  TextColumn get club => text().withDefault(const Constant('Free agent'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Save games (created at runtime).
@DataClassName('CareerRow')
class Careers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get managerName => text()();
  IntColumn get nationId => integer().references(Nations, #id)();
  IntColumn get rngSeed => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get inGameDate => dateTime()();
  IntColumn get cyclePointer => integer().withDefault(const Constant(0))();

  /// The federation's cash balance in euros (see `Career.budget`).
  IntColumn get budget => integer().withDefault(const Constant(0))();
}

/// A nation's Nations Cup league (0 = League A, 1 = League B, …) within its
/// confederation. Seeded from the world ranking for the very first cup, then
/// carried forward and only changed by promotion/relegation off each cup's
/// results — so the leagues are a stable, persistent ladder.
@DataClassName('NationsCupTierRow')
class NationsCupTiers extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get nationId => integer()();
  IntColumn get tier => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, nationId};
}

/// A cycle's federation investment allocation: how much cash was committed to
/// each department for that 4-year cycle. Immutable per (career, cycle) once
/// the cycle is entered — the youth effect is re-derived from it, so it must
/// never change under a running cycle (that would retroactively reshape the
/// squad). `cycle` is the cycle the spending *benefits*.
@DataClassName('FederationInvestmentRow')
class FederationInvestments extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();

  /// Euros put into the youth academy (better newgen prospects this cycle).
  IntColumn get youth => integer().withDefault(const Constant(0))();

  /// Euros put into commercial/PR (extra income at this cycle's close).
  IntColumn get commercial => integer().withDefault(const Constant(0))();

  /// Euros put into medical/sports science (fewer injuries this cycle).
  IntColumn get medical => integer().withDefault(const Constant(0))();

  /// Euros put into the naturalisation office — reputation and openness that
  /// raise the chance a foreign player asks to switch allegiance this cycle.
  IntColumn get naturalization => integer().withDefault(const Constant(0))();

  /// Euros put into board relations — hospitality, PR and expectation
  /// management that make the board more patient with results this cycle.
  IntColumn get boardRelations => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, cycle};
}

/// A foreign player who has offered to naturalise for the manager's nation.
/// Created as a `pending` offer (surfaced as a timeline event); the manager
/// accepts (the player joins the selectable pool) or declines. The player's
/// attributes and name are resolved live from their original id, so only the
/// link is stored here.
@DataClassName('NaturalizedPlayerRow')
class NaturalizedPlayers extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();

  /// The player's original id (their attributes/name resolve from it).
  IntColumn get playerId => integer()();

  /// The nation the player originally represented.
  IntColumn get sourceNationId => integer()();

  /// The cycle the offer was made in.
  IntColumn get cycle => integer()();

  /// 'pending', 'accepted' or 'declined'.
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {careerId, playerId};
}

/// A competition within a save (e.g. a confederation's WC qualifiers).
@DataClassName('CompetitionRow')
class Competitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  TextColumn get confederation => textEnum<Confederation>()();
  TextColumn get name => text()();
  TextColumn get kind => textEnum<CompetitionKind>().withDefault(
        const Constant('worldCupQualifying'),
      )();

  /// The 4-year cycle this competition belongs to (matches Careers.cyclePointer
  /// at creation time), so each endless cycle is queried independently.
  IntColumn get cycle => integer().withDefault(const Constant(0))();
}

/// A qualifying group within a competition.
@DataClassName('QualifyingGroupRow')
class QualifyingGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get competitionId =>
      integer().references(Competitions, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
}

/// A nation's membership of a qualifying group (standings are computed from
/// played fixtures, not stored).
@DataClassName('GroupMemberRow')
class GroupMembers extends Table {
  IntColumn get groupId => integer().references(
        QualifyingGroups,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get nationId => integer()();

  @override
  Set<Column> get primaryKey => {groupId, nationId};
}

/// The team tactic for a save (one row per career).
@DataClassName('TacticRow')
class Tactics extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  TextColumn get formation => textEnum<Formation>()();
  IntColumn get mentality => integer().withDefault(const Constant(50))();
  IntColumn get pressing => integer().withDefault(const Constant(50))();
  IntColumn get tempo => integer().withDefault(const Constant(50))();
  IntColumn get width => integer().withDefault(const Constant(50))();
  IntColumn get defensiveLine => integer().withDefault(const Constant(50))();
  IntColumn get directness => integer().withDefault(const Constant(50))();

  @override
  Set<Column> get primaryKey => {careerId};
}

/// A starting-XI slot for a save's tactic (slot 0–10).
@DataClassName('LineupSlotRow')
class LineupSlots extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get slot => integer()();
  IntColumn get playerId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {careerId, slot};
}

/// A player called up to a save's national squad. The presence of any rows for
/// a career means the manager has curated the squad; with no rows the whole
/// nation pool is treated as called up (the default for new/legacy saves).
@DataClassName('CallUpRow')
class CallUps extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get playerId => integer()();

  @override
  Set<Column> get primaryKey => {careerId, playerId};
}

/// The world-ranking positions frozen at the start of a cycle, used to seed
/// that cycle's draws. Freezing keeps every draw ceremony's re-derivation in
/// step with the persisted groups no matter when it is viewed. Cycle 0 has no
/// rows and falls back to the static seed ranking.
@DataClassName('SeedRankingRow')
class SeedRankings extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();
  IntColumn get nationId => integer()();

  /// The nation's world position (1 = top) at the cycle's start.
  IntColumn get rank => integer()();

  @override
  Set<Column> get primaryKey => {careerId, cycle, nationId};
}

/// A published world-ranking release: the table as it stood when the ranking
/// was republished after an international window.
///
/// Only what the release message needs is stored — the manager's own position
/// and who topped the table — rather than a full snapshot of every nation, so
/// an endless career doesn't accumulate a couple of hundred rows per window.
/// Consecutive rows give the movement between releases.
@DataClassName('RankingReleaseRow')
class RankingReleases extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();

  /// The in-game date the ranking was published.
  DateTimeColumn get publishedOn => dateTime()();

  /// The cycle this release belongs to, so movement can be measured against the
  /// same cycle-start baseline the ranking screen's arrows use.
  IntColumn get cycle => integer().withDefault(const Constant(0))();

  /// The nation the manager held at publication. A manager can change nations
  /// mid-career, and comparing a new nation's rank against the previous
  /// release's would report the job change as a climb.
  IntColumn get nationId => integer().withDefault(const Constant(0))();

  /// That nation's world position (1 = top) at publication.
  IntColumn get playerRank => integer()();

  /// Who topped the table.
  IntColumn get leaderNationId => integer()();

  @override
  Set<Column> get primaryKey => {careerId, publishedOn};
}

/// A nation's live world-ranking points within a save. Seeded from the static
/// seed ranking on first use, then nudged by every result (see the Elo model).
@DataClassName('RankPointRow')
class RankPoints extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get nationId => integer()();
  IntColumn get points => integer()();

  @override
  Set<Column> get primaryKey => {careerId, nationId};
}

/// A player's disciplinary and fitness standing within a save. Only players
/// with something to track (a pending caution, a ban, or an injury) have a row.
@DataClassName('PlayerAbsenceRow')
class PlayerAbsences extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get playerId => integer()();

  /// Yellow cards accumulated toward the next suspension.
  IntColumn get yellows => integer().withDefault(const Constant(0))();

  /// Matches still to be served on a suspension.
  IntColumn get banMatches => integer().withDefault(const Constant(0))();

  /// Matches the player is still sidelined by injury.
  IntColumn get injuryMatches => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, playerId};
}

/// A draw ceremony the manager has already watched. The presence of a row for
/// a (career, cycle, kind) means the draw has played once and should not be
/// re-animated — the drawn result is shown statically instead.
@DataClassName('DrawWatchedRow')
class DrawsWatched extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();

  /// Which draw: 'worldCupFinals', or a confederation name for a continental.
  TextColumn get kind => text()();

  @override
  Set<Column> get primaryKey => {careerId, cycle, kind};
}

/// Achievements unlocked in a save. Sticky — once written, an achievement stays
/// earned even if the underlying stat later changes (e.g. satisfaction drops).
@DataClassName('AchievementRow')
class Achievements extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();

  /// The stable achievement id (see `AchievementCatalog`).
  TextColumn get achievementId => text()();

  /// The in-game year it was earned, for display.
  IntColumn get earnedYear => integer()();

  @override
  Set<Column> get primaryKey => {careerId, achievementId};
}

/// Per-player match appearances for the manager's nation (caps), so "most games
/// played" can be shown on the team records screen. Accrues from each played
/// match; only the player's own nation is tracked.
@DataClassName('AppearanceRow')
class Appearances extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get nationId => integer()();
  IntColumn get playerId => integer()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, playerId};
}

/// Per-player participation in a single competition edition, tagged by
/// [competitionId] so tournament-scoped records can be computed: "most World
/// Cup starts" (sum of [starts] over World-Cup-finals competitions) and "most
/// tournaments attended" (distinct competitions with an appearance). Logged for
/// the WHOLE world, every nation — both starters and substitutes. [starts]
/// counts only fixtures the player started; [apps] every appearance.
@DataClassName('TournamentAppearanceRow')
class TournamentAppearances extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get competitionId => integer()();
  IntColumn get nationId => integer()();
  IntColumn get playerId => integer()();
  IntColumn get starts => integer().withDefault(const Constant(0))();
  IntColumn get apps => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, competitionId, playerId};
}

/// A player's full stat line for a played fixture, written for every player in
/// a match the manager took part in (both teams). Powers the per-player
/// match-by-match history, career aggregates and all-time records.
@DataClassName('PlayerRatingRow')
class PlayerRatings extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get fixtureId => integer().references(Fixtures, #id)();
  IntColumn get playerId => integer()();

  /// The nation the player represented (so nation records filter correctly).
  IntColumn get nationId => integer().withDefault(const Constant(0))();

  /// The performance mark (3.0–10.0).
  RealColumn get rating => real()();

  /// Goals and assists the player registered in the match.
  IntColumn get goals => integer().withDefault(const Constant(0))();
  IntColumn get assists => integer().withDefault(const Constant(0))();

  /// Whether the player's team kept a clean sheet (all outfield/keeper rows).
  BoolColumn get cleanSheet => boolean().withDefault(const Constant(false))();

  /// Whether the player was the match's best performer.
  BoolColumn get motm => boolean().withDefault(const Constant(false))();

  /// Cards shown to the player in the match.
  IntColumn get yellows => integer().withDefault(const Constant(0))();
  IntColumn get reds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {careerId, fixtureId, playerId};
}

/// Team-level box-score stats for a played fixture (the manager's matches
/// only): shots and possession, for post-match and season aggregates.
@DataClassName('MatchTeamStatRow')
class MatchTeamStats extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get fixtureId => integer().references(Fixtures, #id)();
  IntColumn get homeShots => integer().withDefault(const Constant(0))();
  IntColumn get awayShots => integer().withDefault(const Constant(0))();
  IntColumn get homePossession => integer().withDefault(const Constant(50))();

  @override
  Set<Column> get primaryKey => {careerId, fixtureId};
}

/// The manager's inbox: notifications generated as the save unfolds (draws
/// made, qualifications, champions crowned, board verdicts). [dedupKey] keeps a
/// given event from being added twice.
@DataClassName('MessageRow')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  TextColumn get dedupKey => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();

  /// The in-game year the message belongs to, for ordering.
  IntColumn get year => integer()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {careerId, dedupKey},
      ];
}

/// Which nation the manager was in charge of during each cycle — the record of
/// a career that can span several nations (after job switches).
@DataClassName('CareerStintRow')
class CareerStints extends Table {
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();
  IntColumn get nationId => integer()();

  @override
  Set<Column> get primaryKey => {careerId, cycle};
}

/// A scheduled match. Scores are null until played.
@DataClassName('FixtureRow')
class Fixtures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get competitionId => integer().references(Competitions, #id)();
  IntColumn get groupId =>
      integer().nullable().references(QualifyingGroups, #id)();
  IntColumn get matchday => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get homeNationId => integer()();
  IntColumn get awayNationId => integer()();
  IntColumn get homeScore => integer().nullable()();
  IntColumn get awayScore => integer().nullable()();
  BoolColumn get played => boolean().withDefault(const Constant(false))();

  /// Stage label for finals matches: `GROUP`, `R16`, `QF`, `SF`, `3RD`,
  /// `FINAL`. Null for confederation qualifiers.
  TextColumn get round => text().nullable()();

  /// Whether a level knockout was settled after extra time (shows "AET").
  BoolColumn get afterExtraTime =>
      boolean().withDefault(const Constant(false))();

  /// The shootout score when a knockout went to penalties (null otherwise), so
  /// results can show "(pens 4-3)".
  IntColumn get homePenalties => integer().nullable()();
  IntColumn get awayPenalties => integer().nullable()();
}

/// A goal scored in a fixture, attributed to a player (for top-scorer charts).
@DataClassName('GoalEventRow')
class GoalEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get competitionId => integer().references(Competitions, #id)();
  IntColumn get fixtureId => integer().references(Fixtures, #id)();
  IntColumn get nationId => integer()();
  IntColumn get playerId => integer()();
  IntColumn get minute => integer()();
}

/// A completed tournament's roll of honour (World Cup winners history).
@DataClassName('HonourRow')
class Honours extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();

  /// The tournament year (e.g. finals year).
  IntColumn get year => integer()();
  TextColumn get competition => text()();
  IntColumn get championId => integer()();
  IntColumn get runnerUpId => integer()();
  IntColumn get thirdId => integer().nullable()();

  /// Host nation, final scoreline, and golden-boot winner.
  IntColumn get hostId => integer().nullable()();
  IntColumn get finalHomeScore => integer().nullable()();
  IntColumn get finalAwayScore => integer().nullable()();
  TextColumn get topScorerName => text().nullable()();
  IntColumn get topScorerGoals => integer().nullable()();
}
