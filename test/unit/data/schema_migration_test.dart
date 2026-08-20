import 'package:drift/drift.dart' show DriftSqlType, Table, TableInfo;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';

import '../../generated_migrations/schema.dart';
import '../../generated_migrations/schema_v38.dart' as v38;
import '../../generated_migrations/schema_v40.dart' as v40;
import '../../generated_migrations/schema_v41.dart' as v41;

/// Guards the promise that a save survives a schema bump.
///
/// Every version from [AppDatabase.firstManagedVersion] on has a recorded
/// shape in `drift_schemas/`, and the migration between them is a generated
/// step rather than a wipe. These tests run those steps against real databases
/// built at the OLD shape, which is the only way to find out that a step is
/// wrong before a player does.
///
/// When you add version N+1: dump the schema, regenerate the helpers (see the
/// recipe on [AppDatabase.migration]), then add an entry to [_upgrades] below.
/// The loop does the rest.
void main() {
  final verifier = SchemaVerifier(GeneratedHelper());

  /// Every from → to pair that must carry data across, DERIVED rather than
  /// listed: every managed version up to the one this build expects.
  ///
  /// It used to be a hand-written map, which made "add an entry here" a step
  /// somebody had to remember on exactly the bump where forgetting it costs a
  /// player their save. Now a new version is covered the moment
  /// [AppDatabase.currentSchemaVersion] moves, and the run fails until its
  /// schema has been dumped — because [SchemaVerifier] has nothing to validate
  /// the result against otherwise.
  final upgrades = <int, int>{
    for (
      var from = AppDatabase.firstManagedVersion;
      from < AppDatabase.currentSchemaVersion;
      from++
    )
      from: AppDatabase.currentSchemaVersion,
  };

  test('the live schema still matches the recorded snapshot', () async {
    // Catches the mistake that breaks saves: changing a table without dumping
    // a new schema and adding a step for it.
    //
    // It has to be validateDatabaseSchema, not migrateAndValidate: opening a
    // v38 database while schemaVersion is still 38 runs NO migration, so
    // migrateAndValidate would only compare the recorded v38 against itself
    // and pass no matter what the Dart tables say. This instead asserts that
    // the database a real device is holding matches what today's code expects.
    final connection = await verifier.startAt(AppDatabase.firstManagedVersion);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await db.validateDatabaseSchema();
  });

  test('a save opened at the current version keeps its data', () async {
    final connection = await verifier.startAt(AppDatabase.firstManagedVersion);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'Survivor',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );

    final saved = await db.select(db.careers).getSingle();
    expect(saved.managerName, 'Survivor');
  });

  test(
    'v39 clears references to generated players, and keeps the rest',
    () async {
      // 38 → 39 changed no table. It changed what a newgen id MEANS — intake
      // moved to seven eleven-year-olds a year, so the id now encodes an intake
      // year where it encoded a cycle. Rows naming one point at a player who no
      // longer exists, and the step deletes exactly those.
      //
      // `schemaAt` rather than `startAt`: its connections share one underlying
      // database, so data written at v38 is still there when the migration runs.
      const newgen = 1000000123; // above the generated-id base
      const seeded = 4711; // an ordinary seeded player

      final schema = await verifier.schemaAt(38);

      final old = v38.DatabaseAtV38(schema.newConnection());
      await old.customStatement(
        'INSERT INTO careers (id, nation_id, manager_name, created_at, '
        'in_game_date, rng_seed, cycle_pointer, budget, captain_player_id) '
        'VALUES (1, 1, ?, 0, 0, 7, 0, 0, ?)',
        ['Keeper', newgen],
      );
      for (final id in const [newgen, seeded]) {
        await old.customStatement(
          'INSERT INTO call_ups (career_id, player_id) VALUES (1, ?)',
          [id],
        );
      }
      await old.close();

      final db = AppDatabase.forTesting(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, 39);

      final remaining = await db
          .customSelect('SELECT player_id FROM call_ups ORDER BY player_id')
          .map((r) => r.read<int>('player_id'))
          .get();
      expect(
        remaining,
        [seeded],
        reason: 'the generated player should be gone, the seeded one kept',
      );

      final captain = await db
          .customSelect('SELECT captain_player_id FROM careers')
          .map((r) => r.readNullable<int>('captain_player_id'))
          .getSingle();
      expect(captain, isNull, reason: 'an armband on a vanished player');
    },
  );

  test('v41 keeps a career and starts it with an unread feed', () async {
    // 40 → 41 adds the Y read watermark. Additive: the career survives, and a
    // save that has never opened the feed reads as never having opened it.
    final schema = await verifier.schemaAt(40);
    final old = v40.DatabaseAtV40(schema.newConnection());
    await old.customStatement(
      'INSERT INTO careers (id, nation_id, manager_name, created_at, '
      'in_game_date, rng_seed, cycle_pointer, budget) '
      'VALUES (1, 1, ?, 0, 0, 7, 0, 0)',
      ['Reader'],
    );
    await old.close();

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 41);

    final row = await db
        .customSelect('SELECT manager_name, y_read_at FROM careers')
        .getSingle();
    expect(row.read<String>('manager_name'), 'Reader');
    expect(row.readNullable<DateTime>('y_read_at'), isNull);
  });

  test('v42 keeps a career and starts its play clock at zero', () async {
    // 41 → 42 adds the played-time counter. A save that predates it has never
    // been measured, so it starts at nothing rather than at a guess.
    final schema = await verifier.schemaAt(41);
    final old = v41.DatabaseAtV41(schema.newConnection());
    await old.customStatement(
      'INSERT INTO careers (id, nation_id, manager_name, created_at, '
      'in_game_date, rng_seed, cycle_pointer, budget) '
      'VALUES (1, 1, ?, 0, 0, 7, 0, 0)',
      ['Timekeeper'],
    );
    await old.close();

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 42);

    final row = await db
        .customSelect('SELECT manager_name, played_seconds FROM careers')
        .getSingle();
    expect(row.read<String>('manager_name'), 'Timekeeper');
    expect(row.read<int>('played_seconds'), 0);
  });

  for (final MapEntry(key: from, value: to) in upgrades.entries) {
    test('a save migrates from v$from to v$to with its data intact', () async {
      final connection = await verifier.startAt(from);
      final db = AppDatabase.forTesting(connection);
      addTearDown(db.close);

      // Validates the post-migration schema against the recorded snapshot for
      // [to] — a step that forgets a column fails here.
      await verifier.migrateAndValidate(db, to);
    });
  }

  test('a POPULATED save survives the whole migration path', () async {
    // The loop above migrates EMPTY databases: it proves the schema arrives
    // intact, and says nothing about whether the rows did. A step that
    // recreates a table instead of altering it passes every test above and
    // silently empties a twenty-year career.
    //
    // Generic on purpose. It fills every table the oldest managed schema
    // defines by reading each table's own column metadata, so a table added
    // years from now is covered the day it appears rather than the day
    // somebody remembers to add it here.
    final schema = await verifier.schemaAt(AppDatabase.firstManagedVersion);
    final old = v38.DatabaseAtV38(schema.newConnection());
    final populated = <String>[];
    for (final table in old.allTables) {
      await old.customStatement(_insertOneRow(table));
      populated.add(table.actualTableName);
    }
    await old.close();
    expect(
      populated,
      hasLength(greaterThan(20)),
      reason: 'the oldest schema should have real tables to fill',
    );

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    for (final name in populated) {
      final count = await db
          .customSelect('SELECT COUNT(*) AS n FROM $name')
          .map((r) => r.read<int>('n'))
          .getSingle();
      expect(
        count,
        1,
        reason:
            'the migration emptied "$name" — a save loses this table on '
            'upgrade',
      );
    }
  });
}

/// An INSERT that puts one row into [table], built from the table's own
/// columns.
///
/// Only the columns that MUST be given a value are listed: anything nullable,
/// defaulted or auto-incrementing is left to the database, which keeps this
/// working as tables change shape.
String _insertOneRow(TableInfo<Table, Object?> table) {
  final names = <String>[];
  final values = <String>[];
  for (final column in table.$columns) {
    if (column.$nullable ||
        column.hasAutoIncrement ||
        column.defaultValue != null ||
        column.clientDefault != null) {
      continue;
    }
    names.add(column.$name);
    values.add(_sampleFor(column.type));
  }
  if (names.isEmpty)
    return 'INSERT INTO ${table.actualTableName} DEFAULT VALUES';
  return 'INSERT INTO ${table.actualTableName} '
      '(${names.join(', ')}) VALUES (${values.join(', ')})';
}

/// A literal of the right shape for a column of [type]. The values are
/// meaningless — what is under test is whether the ROW survives, not what is
/// in it.
String _sampleFor(Object type) {
  if (type == DriftSqlType.string) return "'x'";
  if (type == DriftSqlType.bool) return '0';
  if (type == DriftSqlType.double) return '1.0';
  if (type == DriftSqlType.blob) return "x''";
  // Drift stores a DateTime as unix seconds unless configured otherwise, and
  // an int literal is right for both that and a plain integer column.
  return '1';
}
