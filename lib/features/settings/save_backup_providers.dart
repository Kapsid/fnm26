import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/domain/services/cloud/auto_backup_runner.dart';
import 'package:fnm/features/cloud/backup_settings.dart';
import 'package:fnm/main.dart' show FnmRoot;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Exporting the whole save file, and putting one back.
///
/// The file mechanics live in [SaveBackup], which knows nothing about the app
/// running around it. This is the part that does: closing the database before
/// its file is replaced, and tearing the app down afterwards so every provider
/// lets go of the handle it was holding.
class SaveBackupService {
  SaveBackupService(this._ref);

  final Ref _ref;

  /// Writes a snapshot of every save to a file ready to be shared.
  ///
  /// It goes to the temporary directory rather than anywhere permanent: the
  /// share sheet copies it wherever the player chooses, and a stale duplicate
  /// of the whole database sitting in app storage is only a way to run out of
  /// space.
  Future<File> export({DateTime? at}) async {
    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      SaveBackup.suggestedFileName(at ?? DateTime.now()),
    );
    return SaveBackup.writeSnapshot(_ref.read(appDatabaseProvider), path);
  }

  /// Replaces every save with the ones in [path], then restarts the app.
  ///
  /// Returns the reason it was refused, or null once the restart is under way.
  /// The order matters and is the whole job:
  ///
  ///  1. check the candidate: before this point nothing is touched, so a bad
  ///     file costs the player nothing;
  ///  2. hold automatic uploads off and wait for one already running (it may
  ///     belong to this scope or to one a previous restore replaced);
  ///  3. write a safety copy of the saves on the phone now, into the app's
  ///     own folder, and refuse outright if that fails: the restore may be
  ///     the wrong backup, and this is the way back (the Backups section
  ///     lists the newest few);
  ///  4. pause automatic uploads until the app has started healthily on the
  ///     result, and pin the newest cloud backup made before it;
  ///  5. close the database, or the handle still open would write its WAL back
  ///     over the file that has just been put in place;
  ///  6. swap the files (see [SaveBackup.replaceLiveAt], which survives being
  ///     killed half-way);
  ///  7. rebuild the app, which opens whatever is now on disk.
  Future<BackupRejection?> restore(String path) async {
    final refusal = SaveBackup.inspect(path).rejection;
    if (refusal != null) return refusal;

    final release = AutoBackupRunner.holdOff();
    try {
      await AutoBackupRunner.whenIdle();
      try {
        await writeSafetyCopy(protect: path);
      } on Object catch (e, stack) {
        AppLog.error('backup-safety-copy', e, stack);
        return BackupRejection.safetyCopyFailed;
      }
      await noteRestoreStarted();

      await closeDatabase();
      final failed = await replaceLive(path);
      // Rebuilt either way: on a refusal nothing was replaced, but the
      // database is shut and the app must not be left holding a closed handle.
      restartApp();
      return failed;
    } finally {
      release();
    }
  }

  /// Step 3 of [restore]: the copy, then the older copies beyond the newest
  /// few, never [protect] (a safety copy can itself be what is restored).
  Future<File> writeSafetyCopy({String? protect}) async {
    final dir = await SaveBackup.safetyDirectory();
    final copy = await SaveBackup.writeSafetyCopy(
      _ref.read(appDatabaseProvider),
      dir,
      DateTime.now(),
    );
    await SaveBackup.pruneSafetyCopies(dir, protect: protect);
    return copy;
  }

  /// Step 4 of [restore].
  Future<void> noteRestoreStarted() =>
      _ref.read(backupSettingsProvider.notifier).noteRestoreStarted();

  /// Step 5 of [restore].
  Future<void> closeDatabase() => _ref.read(appDatabaseProvider).close();

  /// Step 6 of [restore].
  Future<BackupRejection?> replaceLive(String path) =>
      SaveBackup.replaceLive(path);

  /// Step 7 of [restore].
  void restartApp() => FnmRoot.restart();
}

final Provider<SaveBackupService> saveBackupServiceProvider =
    Provider<SaveBackupService>(SaveBackupService.new);
