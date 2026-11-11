import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/raw_sqlite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

  /// The safety copy of the saves already on the phone could not be written,
  /// so nothing was replaced. A restore never runs without one.
  safetyCopyFailed,
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

  /// The copy kept behind after a restore, so a bad one can be undone. It
  /// lasts until the restored file has passed the check at the next launch
  /// (see [recoverAt]).
  static const String previousSuffix = '.previous';

  /// The folder (in the app's documents) where a restore leaves a snapshot of
  /// the saves it is about to replace. The newest [safetyCopiesKept] stay, and
  /// the Backups section lists them to restore or share. Left out of Android
  /// Auto Backup (see backup_rules.xml) so they cannot push the real save over
  /// the 25 MB quota.
  static const String safetyFolder = 'safety';

  /// How many safety copies are kept.
  static const int safetyCopiesKept = 3;

  /// Where a restore stages the incoming file before renaming it into place.
  static const String incomingSuffix = '.incoming';

  /// Present while a restore is swapping files; see [recoverAt].
  static const String restoringSuffix = '.restoring';

  /// The previous [previousSuffix] copy, set aside until a restore completes.
  static const String olderSuffix = '.previous.old';

  /// The safety copies' folder.
  static Future<Directory> safetyDirectory() async => Directory(
    p.join((await getApplicationDocumentsDirectory()).path, safetyFolder),
  );

  /// When the save data was last written: the newer of the database file and
  /// its write-ahead log. Reads touch neither (only `-shm`), so an unchanged
  /// answer means nothing has been saved since. Null when neither exists.
  static Future<DateTime?> lastDataChange() async {
    final live = await liveFile();
    DateTime? newest;
    for (final f in [live, File('${live.path}-wal')]) {
      if (!f.existsSync()) continue;
      final m = f.lastModifiedSync();
      if (newest == null || m.isAfter(newest)) newest = m;
    }
    return newest;
  }

  /// Writes a snapshot of [db] into [dir] as the safety copy taken before a
  /// restore at [at], and returns it. Throws if it cannot be written.
  static Future<File> writeSafetyCopy(
    AppDatabase db,
    Directory dir,
    DateTime at,
  ) async {
    String two(int v) => v.toString().padLeft(2, '0');
    final name =
        'before-restore-${at.year}-${two(at.month)}-${two(at.day)}'
        '-${two(at.hour)}${two(at.minute)}${two(at.second)}.$extension';
    final out = await writeSnapshot(db, p.join(dir.path, name));
    // A copy that does not open is no safety at all.
    if (inspect(out.path).rejection != null) {
      throw FileSystemException('safety copy unreadable', out.path);
    }
    return out;
  }

  /// The file-name start of a copy taken by [writePreUpgradeCopy].
  static const String preUpgradePrefix = 'before-update-';

  /// The file-name start of a live file set aside by [restorePreUpgradeCopy].
  static const String failedUpgradeInfix = '.failed-upgrade-';

  /// The name of the copy taken before a save at schema [version] was first
  /// upgraded. One per version, ever: see [writePreUpgradeCopy].
  static String preUpgradeCopyName(int version) =>
      '${preUpgradePrefix}v$version.$extension';

  /// The schema of the database file [f] as written in it, without migrating
  /// or writing to it; null when it cannot be read.
  ///
  /// Read-only first, so a save that needs nothing is never touched. Only if
  /// that open fails (a WAL left behind with no `-shm` beside it can refuse a
  /// read-only connection) is it read read-write, which never creates a file.
  static int? schemaVersionOf(File f) {
    if (!f.existsSync()) return null;
    for (final mode in const [OpenMode.readOnly, OpenMode.readWrite]) {
      Database? db;
      try {
        db = sqlite3.open(f.path, mode: mode);
        final raw = db.select('PRAGMA user_version').first.values.first;
        return raw is int ? raw : 0;
      } on Object {
        continue;
      } finally {
        db?.close();
      }
    }
    return null;
  }

  /// Copies the save at [live] into the safety folder (or [into]) BEFORE this
  /// build opens it, when opening it will run a migration: its schema is at
  /// least [fromVersion] (the oldest one migrated rather than rebuilt; pass
  /// [AppDatabase.firstManagedVersion]) and below
  /// [AppDatabase.currentSchemaVersion].
  ///
  /// The copy is [preUpgradeCopyName] (`before-update-v<version>.fnmsave`),
  /// so the Backups section lists it with the other safety copies. There is
  /// one per version and it is written ONCE: when it already exists it is
  /// returned untouched. Drift does not run a migration in one transaction,
  /// so an upgrade that fails part way leaves the live file half migrated at
  /// its old version, and the next launch (or a retry) would otherwise copy
  /// that over the only clean copy. Nothing prunes it either (see
  /// [pruneSafetyCopies]).
  ///
  /// Written under a temporary name and renamed into place, so a copy cut
  /// short never passes for a finished one. Returns null when there is
  /// nothing to upgrade, or no readable file. Throws if the copy cannot be
  /// written.
  ///
  /// Raw `sqlite3`, not drift: drift would migrate the file on opening it.
  static Future<File?> writePreUpgradeCopy(
    File live, {
    required int fromVersion,
    Directory? into,
  }) async {
    final version = schemaVersionOf(live);
    if (version == null ||
        version < fromVersion ||
        version >= AppDatabase.currentSchemaVersion) {
      return null;
    }
    final dir = into ?? await safetyDirectory();
    final out = File(p.join(dir.path, preUpgradeCopyName(version)));
    if (out.existsSync()) return out;
    await dir.create(recursive: true);
    final partial = File('${out.path}.partial');
    if (partial.existsSync()) await partial.delete();
    // Read-write, never create: a WAL left by the last session is read
    // rather than refused, as a read-only open can be.
    final db = sqlite3.open(live.path, mode: OpenMode.readWrite);
    try {
      db.execute('VACUUM INTO ?', [partial.path]);
    } finally {
      db.close();
    }
    if (inspect(partial.path).rejection != null) {
      await partial.delete();
      throw FileSystemException('pre-upgrade copy unreadable', out.path);
    }
    await partial.rename(out.path);
    return out;
  }

  /// The copy [writePreUpgradeCopy] took of [live] at the version [live] is
  /// still at, in [dir]: the one to go back to when the upgrade from that
  /// version failed. Null when [live] is unreadable, already current, or has
  /// no readable copy.
  ///
  /// Matched to the live file's own version rather than simply the newest
  /// copy: a save that upgraded fine and failed to open later for another
  /// reason must not be offered a copy from before the play since.
  static File? preUpgradeCopyFor(File live, Directory dir) {
    final version = schemaVersionOf(live);
    if (version == null || version >= AppDatabase.currentSchemaVersion) {
      return null;
    }
    final copy = File(p.join(dir.path, preUpgradeCopyName(version)));
    if (!copy.existsSync() || inspect(copy.path).rejection != null) {
      return null;
    }
    return copy;
  }

  /// Puts [copy] (a [writePreUpgradeCopy] copy) back in place of [live],
  /// setting the file that failed to upgrade aside as
  /// `fnm.sqlite.failed-upgrade-<time>` (never deleted), and returns that.
  ///
  /// Nothing moves until the copy has been staged as `.incoming` and has
  /// passed [inspect] and SQLite's quick check; a copy that fails either
  /// throws with [live] untouched. The swap itself runs under the
  /// `.restoring` marker, so a kill between setting [live] aside and renaming
  /// the staged copy into place is finished by [recoverAt] at the next
  /// launch rather than leaving no save at all.
  ///
  /// The caller must make sure nothing has [live] open. The copy stays where
  /// it is, so it can be restored again if the next upgrade fails too.
  /// [interruptAfterSetAside] lets a test stop the swap where a kill would.
  static Future<File> restorePreUpgradeCopy(
    File live,
    File copy, {
    DateTime? at,
    @visibleForTesting Future<void> Function()? interruptAfterSetAside,
  }) async {
    if (inspect(copy.path).rejection != null) {
      throw FileSystemException('pre-upgrade copy unreadable', copy.path);
    }
    final incoming = File('${live.path}$incomingSuffix');
    if (incoming.existsSync()) await incoming.delete();
    await copy.copy(incoming.path);
    await _flush(incoming);
    if (!_healthy(incoming.path)) {
      await incoming.delete();
      throw FileSystemException('pre-upgrade copy damaged', copy.path);
    }

    final marker = File('${live.path}$restoringSuffix');
    await marker.writeAsString(DateTime.now().toIso8601String(), flush: true);
    final stamp = (at ?? DateTime.now()).millisecondsSinceEpoch;
    final aside = File('${live.path}$failedUpgradeInfix$stamp');
    if (live.existsSync()) await _moveWithWal(live, aside);
    for (final sidecar in _sidecarsOf(live.path)) {
      if (sidecar.existsSync()) await sidecar.delete();
    }
    await interruptAfterSetAside?.call();
    await incoming.rename(live.path);
    await marker.delete();
    return aside;
  }

  /// The safety copies in [dir], newest first.
  static List<File> safetyCopiesIn(Directory dir) {
    if (!dir.existsSync()) return const [];
    final files = [
      for (final f in dir.listSync().whereType<File>())
        if (f.path.endsWith('.$extension')) f,
    ];
    final stamped = [for (final f in files) (f, f.lastModifiedSync())]
      ..sort((a, b) {
        final byTime = b.$2.compareTo(a.$2);
        return byTime != 0 ? byTime : b.$1.path.compareTo(a.$1.path);
      });
    return [for (final s in stamped) s.$1];
  }

  /// Removes the safety copies in [dir] beyond the newest [keep], never
  /// [protect] (the copy being restored from, if it is one of them), and
  /// never a pre-upgrade copy ([preUpgradePrefix]): there is one per version,
  /// and it is the only clean copy of a save an upgrade went wrong on.
  static Future<void> pruneSafetyCopies(
    Directory dir, {
    int keep = safetyCopiesKept,
    String? protect,
  }) async {
    final copies = [
      for (final f in safetyCopiesIn(dir))
        if (!p.basename(f.path).startsWith(preUpgradePrefix)) f,
    ];
    for (final old in copies.skip(keep)) {
      if (protect != null && p.equals(old.path, protect)) continue;
      try {
        await old.delete();
      } on Object {
        // Tried again after the next restore.
      }
    }
  }

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
  /// The caller must have closed the database first and must reopen it after;
  /// see `SaveBackupService.restore`, which owns that dance. Refuses outright
  /// if [inspect] would.
  static Future<BackupRejection?> replaceLive(String from) async {
    // Checked before the live file is even located: a bad file costs nothing.
    final rejection = inspect(from).rejection;
    if (rejection != null) return rejection;
    return replaceLiveAt(from, await liveFile());
  }

  /// Whether the OPEN database [db] passes SQLite's quick check and its
  /// careers can be read: the "restored saves are healthy" test before
  /// automatic uploads resume after a restore.
  static Future<bool> isHealthy(AppDatabase db) async {
    final check = await db.customSelect('PRAGMA quick_check').get();
    if (check.isEmpty || check.first.data.values.first != 'ok') return false;
    await db.customSelect('SELECT COUNT(*) FROM careers').get();
    return true;
  }

  /// [replaceLive] against an explicit [live] file (tests).
  ///
  /// Built so that the app being killed at ANY point leaves something
  /// [recoverAt] can put right at the next launch:
  ///
  ///  1. the backup is copied to `fnm.sqlite.incoming`, flushed and checked;
  ///     until here the live database is untouched;
  ///  2. a `.restoring` marker is written;
  ///  3. an existing `.previous` is set aside (not deleted) as `.previous.old`;
  ///  4. the live file (and its `-wal`, which can hold committed data) becomes
  ///     `.previous`;
  ///  5. `.incoming` is RENAMED onto the live path, which is atomic on one
  ///     volume, so the live path never holds half a file;
  ///  6. the marker and `.previous.old` go.
  static Future<BackupRejection?> replaceLiveAt(String from, File live) async {
    final inspection = inspect(from);
    if (inspection.rejection != null) return inspection.rejection;

    final incoming = File('${live.path}$incomingSuffix');
    if (incoming.existsSync()) await incoming.delete();
    await File(from).copy(incoming.path);
    await _flush(incoming);
    final staged = inspect(incoming.path).rejection;
    if (staged != null) {
      await incoming.delete();
      return staged;
    }

    final marker = File('${live.path}$restoringSuffix');
    await marker.writeAsString(DateTime.now().toIso8601String(), flush: true);

    final previous = File('${live.path}$previousSuffix');
    final older = File('${live.path}$olderSuffix');
    if (previous.existsSync()) {
      await _moveWithWal(previous, older);
    }
    if (live.existsSync()) await _moveWithWal(live, previous);
    for (final sidecar in _sidecarsOf(live.path)) {
      if (sidecar.existsSync()) await sidecar.delete();
    }
    await incoming.rename(live.path);

    await marker.delete();
    await _deleteWithWal(older);
    return null;
  }

  /// Puts things right at launch, BEFORE the database is opened, if a restore
  /// was cut short (the app killed, the battery flat) or left a live file that
  /// does not open. Returns true when it changed anything.
  ///
  ///  * With a `.restoring` marker, the restore never finished: a live file
  ///    that is missing or broken is set aside and `.previous` (the saves from
  ///    before) goes back; an intact live file is kept. Either way the parked
  ///    `.previous.old` returns to `.previous`, and the staging file goes.
  ///  * Without one (an older build's restore, or plain damage), a missing or
  ///    unreadable live file is replaced by a good `.previous`; a live file
  ///    that passes the full check retires `.previous` instead.
  ///  * In both cases, when there is still no live file and the staging file
  ///    `.incoming` passes the full check, it is renamed into place: that is
  ///    a pre-upgrade restore ([restorePreUpgradeCopy]) killed between its
  ///    two renames. A staging file is never deleted while there is no live
  ///    file.
  ///
  /// A broken live file is renamed `fnm.sqlite.broken-<time>`, never deleted.
  static Future<bool> recoverAt(File live) async {
    final marker = File('${live.path}$restoringSuffix');
    final incoming = File('${live.path}$incomingSuffix');
    final previous = File('${live.path}$previousSuffix');
    final older = File('${live.path}$olderSuffix');
    var changed = false;

    bool good(File f) => f.existsSync() && _healthy(f.path);

    // A swap killed after the live file was set aside and before the staged
    // copy was renamed into place (see [restorePreUpgradeCopy]) left no live
    // file at all: the staged copy IS the save now, so it goes into place.
    // With a live file the staging copy is spare and goes. With neither a live
    // file nor a good staging copy, the staging copy is kept, never deleted.
    Future<void> settleIncoming() async {
      if (!incoming.existsSync()) return;
      if (live.existsSync()) {
        await incoming.delete();
      } else if (good(incoming)) {
        await _moveWithWal(incoming, live);
        changed = true;
      }
    }

    if (marker.existsSync()) {
      if (!good(live) && good(previous)) {
        if (live.existsSync()) await _setAside(live);
        await _moveWithWal(previous, live);
        changed = true;
      }
      if (!previous.existsSync() && older.existsSync()) {
        await _moveWithWal(older, previous);
      } else {
        await _deleteWithWal(older);
      }
      await settleIncoming();
      await marker.delete();
      return true;
    }

    await settleIncoming();
    if (!previous.existsSync()) return changed;
    final liveRejection = live.existsSync()
        ? inspect(live.path).rejection
        : null;
    final liveBroken =
        !live.existsSync() ||
        liveRejection == BackupRejection.unreadable ||
        liveRejection == BackupRejection.notAFnmSave ||
        (liveRejection == null && !_healthy(live.path));
    if (liveBroken && good(previous)) {
      if (live.existsSync()) await _setAside(live);
      await _moveWithWal(previous, live);
      changed = true;
    } else if (liveRejection == null && !liveBroken) {
      // The restored saves passed the full check, so the restore is proven:
      // `.previous` goes (the safety copies keep the saves from before it),
      // and later launches skip this check.
      await _deleteWithWal(previous);
    }
    return changed;
  }

  /// [inspect] passes and SQLite's own quick check says "ok".
  static bool _healthy(String path) {
    if (inspect(path).rejection != null) return false;
    Database? db;
    try {
      db = sqlite3.open(path, mode: OpenMode.readOnly);
      final r = db.select('PRAGMA quick_check');
      return r.isNotEmpty && r.first.values.first == 'ok';
    } on Object {
      return false;
    } finally {
      db?.close();
    }
  }

  static Future<void> _flush(File f) async {
    final raf = await f.open(mode: FileMode.append);
    try {
      await raf.flush();
    } finally {
      await raf.close();
    }
  }

  static Future<void> _moveWithWal(File from, File to) async {
    for (final s in _sidecarsOf(to.path)) {
      if (s.existsSync()) await s.delete();
    }
    await from.rename(to.path);
    final wal = File('${from.path}-wal');
    if (wal.existsSync()) await wal.rename('${to.path}-wal');
    for (final s in _sidecarsOf(from.path)) {
      if (s.existsSync()) await s.delete();
    }
  }

  static Future<void> _deleteWithWal(File f) async {
    if (f.existsSync()) await f.delete();
    for (final s in _sidecarsOf(f.path)) {
      if (s.existsSync()) await s.delete();
    }
  }

  static Future<void> _setAside(File live) async {
    final aside = File(
      '${live.path}.broken-${DateTime.now().millisecondsSinceEpoch}',
    );
    await live.rename(aside.path);
    final wal = File('${live.path}-wal');
    if (wal.existsSync()) await wal.rename('${aside.path}-wal');
    for (final s in _sidecarsOf(live.path)) {
      if (s.existsSync()) await s.delete();
    }
  }

  /// A name a player will recognise a year from now, in a Drive or iCloud
  /// folder full of other things: the app, the date and the time.
  static String suggestedFileName(DateTime on) {
    String two(int v) => v.toString().padLeft(2, '0');
    return 'FootballNationsManager-backup-${on.year}-${two(on.month)}'
        '-${two(on.day)}-${two(on.hour)}${two(on.minute)}.$extension';
  }

  static List<File> _sidecarsOf(String path) => [
    File('$path-wal'),
    File('$path-shm'),
    File('$path-journal'),
  ];
}
