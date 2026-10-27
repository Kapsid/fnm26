import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:sqlite3/sqlite3.dart';

/// A restore swaps the database file under the app. Killed at any point of
/// that swap, the next launch must find the saves, never an empty game; and
/// safety copies are kept to the newest three.
void main() {
  late Directory dir;
  late File live;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fnm_recover');
    live = File('${dir.path}/fnm.sqlite');
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  Future<String> aSave(String path, String manager) async {
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    await db
        .into(db.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: manager,
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
          ),
        );
    await db.close();
    return path;
  }

  String managerIn(File f) {
    final db = sqlite3.open(f.path, mode: OpenMode.readOnly);
    try {
      return db
              .select('SELECT manager_name FROM careers')
              .single['manager_name']
          as String;
    } finally {
      db.close();
    }
  }

  File sibling(String suffix) => File('${live.path}$suffix');

  test('a complete restore swaps the files and leaves no marker', () async {
    await aSave(live.path, 'Before');
    final backup = await aSave('${dir.path}/backup.fnmsave', 'Restored');
    expect(await SaveBackup.replaceLiveAt(backup, live), isNull);
    expect(managerIn(live), 'Restored');
    expect(managerIn(sibling(SaveBackup.previousSuffix)), 'Before');
    expect(sibling(SaveBackup.restoringSuffix).existsSync(), isFalse);
    expect(sibling(SaveBackup.incomingSuffix).existsSync(), isFalse);
    expect(await SaveBackup.recoverAt(live), isFalse);
    expect(managerIn(live), 'Restored');
    // Proven at that launch: the copy from before goes.
    expect(sibling(SaveBackup.previousSuffix).existsSync(), isFalse);
  });

  test(
    'killed after the live file was moved aside: the saves come back',
    () async {
      // The state the swap leaves between step 4 and step 5.
      await aSave(sibling(SaveBackup.previousSuffix).path, 'Before');
      await aSave(sibling(SaveBackup.incomingSuffix).path, 'Restored');
      sibling(SaveBackup.restoringSuffix).writeAsStringSync('x');
      expect(live.existsSync(), isFalse);

      expect(await SaveBackup.recoverAt(live), isTrue);
      expect(managerIn(live), 'Before');
      expect(sibling(SaveBackup.restoringSuffix).existsSync(), isFalse);
      expect(sibling(SaveBackup.incomingSuffix).existsSync(), isFalse);
    },
  );

  test(
    'killed while an older build copied onto the live path: the '
    'truncated file is set aside, not deleted, and the saves come back',
    () async {
      await aSave(sibling(SaveBackup.previousSuffix).path, 'Before');
      live.writeAsBytesSync(List<int>.filled(100, 7)); // half a file
      expect(await SaveBackup.recoverAt(live), isTrue);
      expect(managerIn(live), 'Before');
      final aside = dir.listSync().whereType<File>().where(
        (f) => f.path.contains('.broken-'),
      );
      expect(aside, hasLength(1));
    },
  );

  test('killed after the old .previous was parked: it is put back', () async {
    await aSave(live.path, 'Current');
    await aSave(sibling(SaveBackup.olderSuffix).path, 'Older');
    await aSave(sibling(SaveBackup.incomingSuffix).path, 'Restored');
    sibling(SaveBackup.restoringSuffix).writeAsStringSync('x');
    await SaveBackup.recoverAt(live);
    expect(managerIn(live), 'Current');
    expect(managerIn(sibling(SaveBackup.previousSuffix)), 'Older');
    expect(sibling(SaveBackup.olderSuffix).existsSync(), isFalse);
  });

  test('killed after the rename: the restored saves stay', () async {
    await aSave(live.path, 'Restored');
    await aSave(sibling(SaveBackup.previousSuffix).path, 'Before');
    sibling(SaveBackup.restoringSuffix).writeAsStringSync('x');
    await SaveBackup.recoverAt(live);
    expect(managerIn(live), 'Restored');
    expect(sibling(SaveBackup.restoringSuffix).existsSync(), isFalse);
  });

  test('a healthy launch with an old .previous keeps the saves and drops '
      'the old copy, so later launches skip the check', () async {
    await aSave(live.path, 'Current');
    await aSave(sibling(SaveBackup.previousSuffix).path, 'Before');
    expect(await SaveBackup.recoverAt(live), isFalse);
    expect(managerIn(live), 'Current');
    expect(sibling(SaveBackup.previousSuffix).existsSync(), isFalse);
  });

  test('a fresh install has nothing to recover', () async {
    expect(await SaveBackup.recoverAt(live), isFalse);
    expect(live.existsSync(), isFalse);
  });

  test(
    'a backup that will not open is refused before anything moves',
    () async {
      await aSave(live.path, 'Current');
      final junk = File('${dir.path}/junk.fnmsave')..writeAsStringSync('nope');
      expect(
        await SaveBackup.replaceLiveAt(junk.path, live),
        BackupRejection.unreadable,
      );
      expect(managerIn(live), 'Current');
      expect(sibling(SaveBackup.restoringSuffix).existsSync(), isFalse);
    },
  );

  test(
    'safety copies are kept to the newest three, never the one in use',
    () async {
      final safety = Directory('${dir.path}/safety')..createSync();
      final files = <File>[];
      for (var i = 0; i < 5; i++) {
        final f = File('${safety.path}/before-restore-$i.fnmsave')
          ..writeAsStringSync('$i')
          ..setLastModifiedSync(DateTime(2026, 10, 1 + i));
        files.add(f);
      }
      await SaveBackup.pruneSafetyCopies(safety, protect: files.first.path);
      final left = SaveBackup.safetyCopiesIn(
        safety,
      ).map((f) => f.path).toList();
      expect(left, [
        files[4].path,
        files[3].path,
        files[2].path,
        files[0].path,
      ]);
      await SaveBackup.pruneSafetyCopies(safety);
      expect(SaveBackup.safetyCopiesIn(safety), hasLength(3));
    },
  );
}
