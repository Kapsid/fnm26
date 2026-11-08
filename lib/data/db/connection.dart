import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the on-device SQLite database file lazily.
///
/// The file lives in the app's documents directory so it persists across
/// launches and is the artifact uploaded by the premium cloud-backup feature.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'fnm.sqlite'));
    // A restore cut short (the app killed mid-swap) is put right before the
    // database is opened, or drift would create an empty one in its place.
    try {
      await SaveBackup.recoverAt(file);
    } on Object catch (e, stack) {
      AppLog.error('restore-recovery', e, stack);
    }
    // A save this build is about to migrate is copied first, so an upgrade
    // that goes wrong never costs the player his careers. A copy that cannot
    // be written is logged and the save opened anyway: refusing to open it
    // would lock him out of saves that will most likely upgrade fine.
    try {
      final copy = await SaveBackup.writePreUpgradeCopy(
        file,
        fromVersion: AppDatabase.firstManagedVersion,
      );
      if (copy != null) {
        AppLog.info('pre-upgrade-copy', p.basename(copy.path));
      }
    } on Object catch (e, stack) {
      AppLog.error('pre-upgrade-copy', e, stack);
    }
    return NativeDatabase.createInBackground(file);
  });
}
