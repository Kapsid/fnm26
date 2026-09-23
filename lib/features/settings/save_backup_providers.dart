import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/save_backup.dart';
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
  ///  1. check the candidate — before this point nothing is touched, so a bad
  ///     file costs the player nothing;
  ///  2. close the database, or the handle still open would write its WAL back
  ///     over the file that has just been put in place;
  ///  3. swap the files, keeping the outgoing one to go back to;
  ///  4. rebuild the app, which opens whatever is now on disk.
  Future<BackupRejection?> restore(String path) async {
    final refusal = SaveBackup.inspect(path).rejection;
    if (refusal != null) return refusal;

    await _ref.read(appDatabaseProvider).close();
    final failed = await SaveBackup.replaceLive(path);
    if (failed != null) {
      // Nothing was replaced, but the database is shut. Rebuild so the app is
      // usable again rather than left holding a closed handle.
      FnmRoot.restart();
      return failed;
    }
    FnmRoot.restart();
    return null;
  }
}

final Provider<SaveBackupService> saveBackupServiceProvider =
    Provider<SaveBackupService>(SaveBackupService.new);
