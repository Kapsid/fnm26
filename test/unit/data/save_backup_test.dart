import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../helpers/save_fixtures.dart';

/// Exporting and restoring a whole save file.
///
/// The rule the whole feature rests on: NOTHING is replaced until the
/// replacement has been read and accepted. A backup that can destroy the save
/// it was meant to protect is worse than no backup.
void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fnm_backup');
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  /// A real database file with one career in it.
  Future<String> aSaveWith(String managerName) async {
    final path = '${dir.path}/live_$managerName.sqlite';
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: managerName,
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );
    await db.close();
    return path;
  }

  group('taking a snapshot', () {
    test('captures data still sitting in the write-ahead log', () async {
      // The bug this pins: the database runs in WAL mode, so a freshly written
      // row can live in fnm.sqlite-wal rather than fnm.sqlite. Copying the
      // file would produce a backup that opens fine and is missing the last
      // thing the player did.
      final path = '${dir.path}/live.sqlite';
      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      await db
          .into(db.careers)
          .insert(
            CareersCompanion.insert(
              nationId: 1,
              managerName: 'Unflushed',
              createdAt: DateTime.utc(2030),
              inGameDate: DateTime.utc(2030, 6, 1),
              rngSeed: 7,
            ),
          );

      final snapshot = await SaveBackup.writeSnapshot(
        db,
        '${dir.path}/out.fnmsave',
      );

      expect(snapshot.existsSync(), isTrue);
      final read = sqlite3.open(snapshot.path, mode: OpenMode.readOnly);
      addTearDown(read.dispose);
      expect(
        read.select('SELECT manager_name FROM careers').single['manager_name'],
        'Unflushed',
        reason: 'the snapshot must include everything committed so far',
      );
    });

    test('has no sidecar files of its own', () async {
      // A backup is one file. A -wal left next to it is how a restore later
      // turns into corruption.
      final path = '${dir.path}/live.sqlite';
      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      await db.customStatement('SELECT 1');

      final snapshot = await SaveBackup.writeSnapshot(
        db,
        '${dir.path}/out.fnmsave',
      );

      expect(File('${snapshot.path}-wal').existsSync(), isFalse);
      expect(File('${snapshot.path}-shm').existsSync(), isFalse);
    });

    test('overwrites an earlier snapshot at the same path', () async {
      // VACUUM INTO refuses to write over a file, so exporting twice in a row
      // used to fail on the second go.
      final path = '${dir.path}/live.sqlite';
      final db = AppDatabase.forTesting(NativeDatabase(File(path)));
      addTearDown(db.close);
      await db.customStatement('SELECT 1');

      await SaveBackup.writeSnapshot(db, '${dir.path}/out.fnmsave');
      await SaveBackup.writeSnapshot(db, '${dir.path}/out.fnmsave');
    });
  });

  group('deciding whether a file can be restored', () {
    test('accepts a save this build wrote', () async {
      final path = await aSaveWith('Good');
      final inspection = SaveBackup.inspect(path);
      expect(inspection.rejection, isNull);
      expect(inspection.schemaVersion, AppDatabase.currentSchemaVersion);
    });

    test('rejects something that is not a database', () async {
      final path = '${dir.path}/holiday.jpg';
      await File(path).writeAsString('not a database');
      expect(
        SaveBackup.inspect(path).rejection,
        BackupRejection.unreadable,
      );
    });

    test('rejects a database that is not one of ours', () async {
      final path = '${dir.path}/other.sqlite';
      final other = sqlite3.open(path);
      other
        ..execute('CREATE TABLE recipes (id INTEGER PRIMARY KEY)')
        ..execute('PRAGMA user_version = ${AppDatabase.currentSchemaVersion}')
        ..dispose();
      expect(
        SaveBackup.inspect(path).rejection,
        BackupRejection.notAFnmSave,
      );
    });

    test('rejects a save from a later build', () async {
      // Migrations only run forward. Restoring a newer save would leave this
      // build holding a shape it has no code for.
      final path = await aSaveWith('FromTheFuture');
      final raw = sqlite3.open(path);
      raw
        ..execute(
          'PRAGMA user_version = ${AppDatabase.currentSchemaVersion + 1}',
        )
        ..dispose();
      expect(
        SaveBackup.inspect(path).rejection,
        BackupRejection.fromANewerBuild,
      );
    });

    test('a 1.1.0 build (schema 53) reads this build\'s backup as newer', () {
      // The gate is the schema version alone. Editor 2 packs break 1.1.0, so
      // this build must stamp a version 1.1.0 does not know.
      const schemaOf110 = 53;
      expect(AppDatabase.currentSchemaVersion, greaterThan(schemaOf110));
    });

    test('rejects a save too old for the migration path', () async {
      // Below firstManagedVersion the app's own upgrade WIPES rather than
      // migrates, so accepting this would delete the career it restored.
      final path = await aSaveWith('Ancient');
      final raw = sqlite3.open(path);
      raw
        ..execute(
          'PRAGMA user_version = ${AppDatabase.firstManagedVersion - 1}',
        )
        ..dispose();
      expect(
        SaveBackup.inspect(path).rejection,
        BackupRejection.tooOldToMigrate,
      );
    });
  });

  test('a rejected file never reaches the live database', () async {
    // replaceLive re-checks rather than trusting the caller: the check and the
    // swap must not be separable, or some later screen calls the swap alone.
    final junk = '${dir.path}/junk.fnmsave';
    await File(junk).writeAsString('nonsense');
    expect(
      await SaveBackup.replaceLive(junk),
      BackupRejection.unreadable,
    );
  });

  group('the copy taken before an upgrade', () {
    test(
      'a v54 file gets a pre-upgrade copy that opens at v54 with its careers',
      () async {
        // A real save written by the build before schema 55. If the upgrade
        // that follows goes wrong, this copy is how the player gets it back.
        final live = await unpackFixture('pre55', 'mid_cycle');
        addTearDown(() => live.parent.delete(recursive: true));
        expect(fileSchemaVersion(live.path), 54);
        final careersBefore = sqlite3.open(live.path, mode: OpenMode.readOnly);
        final names = [
          for (final r in careersBefore.select(
            'SELECT manager_name FROM careers ORDER BY id',
          ))
            r['manager_name'],
        ];
        careersBefore.close();
        expect(names, isNotEmpty);

        final copy = await SaveBackup.writePreUpgradeCopy(
          live,
          fromVersion: AppDatabase.firstManagedVersion,
          into: dir,
        );

        expect(copy, isNotNull);
        expect(p.dirname(copy!.path), dir.path);
        expect(p.basename(copy.path), startsWith('before-update-v54-'));
        expect(copy.path, endsWith('.${SaveBackup.extension}'));
        expect(SaveBackup.safetyCopiesIn(dir), [
          isA<File>().having((f) => f.path, 'path', copy.path),
        ], reason: 'the Settings restore list must offer it');
        expect(SaveBackup.inspect(copy.path).rejection, isNull);
        final read = sqlite3.open(copy.path, mode: OpenMode.readOnly);
        addTearDown(read.close);
        expect(read.select('PRAGMA user_version').first.values.first, 54);
        expect([
          for (final r in read.select(
            'SELECT manager_name FROM careers ORDER BY id',
          ))
            r['manager_name'],
        ], names);
        expect(
          fileSchemaVersion(live.path),
          54,
          reason: 'taking the copy must not touch the save itself',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('a current file gets none', () async {
      final path = await aSaveWith('Current');
      final copy = await SaveBackup.writePreUpgradeCopy(
        File(path),
        fromVersion: AppDatabase.firstManagedVersion,
        into: dir,
      );
      expect(copy, isNull);
      expect(SaveBackup.safetyCopiesIn(dir), isEmpty);
    });

    test('a missing file gets none', () async {
      final copy = await SaveBackup.writePreUpgradeCopy(
        File('${dir.path}/nothing.sqlite'),
        fromVersion: AppDatabase.firstManagedVersion,
        into: dir,
      );
      expect(copy, isNull);
      expect(File('${dir.path}/nothing.sqlite').existsSync(), isFalse);
    });
  });
}
