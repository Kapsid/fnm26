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
}
