import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';

import '../../generated_migrations/schema.dart';
import '../../generated_migrations/schema_v38.dart' as v38;

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

  /// Every from → to pair that must carry data across. Extend as versions are
  /// added: {38: 39}, then {38: 40, 39: 40}, and so on.
  const upgrades = <int, int>{39: 40, 38: 40};

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


  test('v39 clears references to generated players, and keeps the rest',
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
    expect(remaining, [seeded],
        reason: 'the generated player should be gone, the seeded one kept');

    final captain = await db
        .customSelect('SELECT captain_player_id FROM careers')
        .map((r) => r.readNullable<int>('captain_player_id'))
        .getSingle();
    expect(captain, isNull, reason: 'an armband on a vanished player');
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
}
