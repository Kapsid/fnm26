import 'dart:io';

import 'package:fnm/data/db/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Why a file offered for restore cannot be used.
enum BackupRejection {
  /// Not a database at all, or damaged past opening.
  unreadable,

  /// A valid SQLite file, but not one of ours.
  notAFnmSave,

  /// Written by a later build than this one. Migrations only run forward, so
  /// restoring it would leave the app holding a shape it does not understand.
  fromANewerBuild,

  /// Older than the first schema with a recorded shape, so the app's own
  /// upgrade path would wipe it rather than migrate it — see
  /// [AppDatabase.firstManagedVersion].
  tooOldToMigrate,
}

/// What was found in a candidate backup: its schema version, and the reason it
/// cannot be restored (null when it can).
typedef BackupInspection = ({int schemaVersion, BackupRejection? rejection});

/// Copying whole saves in and out of the app.
///
/// The unit here is the DATABASE, not a career: every save slot, in one file.
/// That is the point — this exists so that a lost or reinstalled phone does
/// not cost somebody a twenty-year career, and a backup that covers only the
/// save you remembered to export does not do that. Moving a single career
/// between devices is a different job with a different shape; see
/// `career_bundle.dart`.
abstract final class SaveBackup {
  /// The live database's file name, as [openConnection] creates it.
  static const String liveFileName = 'fnm.sqlite';

  /// The extension an exported save carries. It is a plain SQLite file — the
  /// extension exists so the OS file pickers can filter, and so a player can
  /// tell what it is a year later.
  static const String extension = 'fnmsave';

  /// The copy kept behind after a restore, so a bad one can be undone.
  static const String previousSuffix = '.previous';

  /// The database the app is actually running on.
  static Future<File> liveFile() async => File(
    p.join((await getApplicationDocumentsDirectory()).path, liveFileName),
  );

  /// Writes a consistent snapshot of [db] to [toPath].
  ///
  /// `VACUUM INTO` rather than copying the file: the database runs in WAL
  /// mode, so at any moment some committed data lives in `fnm.sqlite-wal` and
  /// not in `fnm.sqlite`. A plain file copy silently leaves it behind, which
  /// is the worst possible failure for a backup — it looks like it worked.
  /// This writes one self-contained, compacted file with no sidecars.
  static Future<File> writeSnapshot(AppDatabase db, String toPath) async {
    final out = File(toPath);
    // VACUUM INTO refuses to write over an existing file.
    if (out.existsSync()) await out.delete();
    await out.parent.create(recursive: true);
    await db.customStatement('VACUUM INTO ?', [toPath]);
    return out;
  }

  /// Looks at [path] and decides whether it can be restored, WITHOUT touching
  /// the live database.
  ///
  /// Everything is checked before anything is replaced. A restore that fails
  /// halfway would destroy the save it was asked to protect.
  static BackupInspection inspect(String path) {
    Database? db;
    try {
      db = sqlite3.open(path, mode: OpenMode.readOnly);
      final hasCareers = db.select(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
        ['careers'],
      ).isNotEmpty;
      final version = db.select('PRAGMA user_version').first.values.first;
      final schemaVersion = version is int ? version : 0;
      if (!hasCareers) {
        return (
          schemaVersion: schemaVersion,
          rejection: BackupRejection.notAFnmSave,
        );
      }
      if (schemaVersion > AppDatabase.currentSchemaVersion) {
        return (
          schemaVersion: schemaVersion,
          rejection: BackupRejection.fromANewerBuild,
        );
      }
      if (schemaVersion < AppDatabase.firstManagedVersion) {
        return (
          schemaVersion: schemaVersion,
          rejection: BackupRejection.tooOldToMigrate,
        );
      }
      return (schemaVersion: schemaVersion, rejection: null);
    } on Object {
      return (schemaVersion: 0, rejection: BackupRejection.unreadable);
    } finally {
      db?.dispose();
    }
  }

  /// Puts [from] in place of the live database, keeping the outgoing one.
  ///
  /// The caller must have closed the database first and must reopen it after —
  /// see `SaveBackupService.restore`, which owns that dance. Refuses outright
  /// if [inspect] would.
  ///
  /// The WAL sidecars are removed rather than left: they belong to the file
  /// being replaced, and a stale `-wal` next to a different database is how a
  /// restore turns into corruption.
  static Future<BackupRejection?> replaceLive(String from) async {
    final inspection = inspect(from);
    if (inspection.rejection != null) return inspection.rejection;

    final live = await liveFile();
    final previous = File('${live.path}$previousSuffix');
    if (previous.existsSync()) await previous.delete();
    if (live.existsSync()) await live.rename(previous.path);
    for (final sidecar in _sidecarsOf(live.path)) {
      if (sidecar.existsSync()) await sidecar.delete();
    }
    await File(from).copy(live.path);
    return null;
  }

  /// Puts back whatever [replaceLive] moved aside. Returns false when there is
  /// nothing to go back to.
  static Future<bool> undoRestore() async {
    final live = await liveFile();
    final previous = File('${live.path}$previousSuffix');
    if (!previous.existsSync()) return false;
    if (live.existsSync()) await live.delete();
    for (final sidecar in _sidecarsOf(live.path)) {
      if (sidecar.existsSync()) await sidecar.delete();
    }
    await previous.rename(live.path);
    return true;
  }

  /// A name a player will recognise a year from now.
  static String suggestedFileName(DateTime on) {
    String two(int v) => v.toString().padLeft(2, '0');
    return 'fnm-${on.year}-${two(on.month)}-${two(on.day)}'
        '-${two(on.hour)}${two(on.minute)}.$extension';
  }

  static List<File> _sidecarsOf(String path) => [
    File('$path-wal'),
    File('$path-shm'),
    File('$path-journal'),
  ];
}
