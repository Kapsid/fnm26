import 'package:drift/drift.dart';
import 'package:fnm/domain/entities/enums.dart';

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
