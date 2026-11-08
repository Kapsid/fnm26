import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/shared/widgets/save_upgrade_failed_screen.dart';

/// Opens the save database, migrating it if this build is newer than the
/// save. Resolves once it is open; fails if the open (in practice, an
/// upgrade) threw.
final saveOpensProvider = FutureProvider<void>((ref) async {
  try {
    await ref.watch(appDatabaseProvider).customSelect('SELECT 1').get();
  } on Object catch (e, stack) {
    AppLog.error('db-open', e, stack);
    rethrow;
  }
});

/// What a failed open can go back to: the live file, and the copy taken
/// before the upgrade from the version it is still at, if there is one
/// (`SaveBackup.preUpgradeCopyFor`). Read only after an open has failed.
typedef SaveRecovery = ({File live, File? copy});

final saveRecoveryProvider = FutureProvider<SaveRecovery>((ref) async {
  final live = await SaveBackup.liveFile();
  final copy = SaveBackup.preUpgradeCopyFor(
    live,
    await SaveBackup.safetyDirectory(),
  );
  return (live: live, copy: copy);
});

/// The language for the failure screen: the one chosen in Settings (from
/// its provider, or straight from preferences, since the app that would
/// have loaded it is not running), else the device's.
final saveFailureLocaleProvider = FutureProvider<Locale?>(
  (ref) async => ref.watch(localeProvider) ?? await storedLocale(),
);

/// [child], unless the save will not open: then [SaveUpgradeFailedScreen],
/// never a saves list with nothing on it.
///
/// [child] is built while the database opens, exactly as before, so a normal
/// launch looks and times the same; only a failure swaps it out.
class SaveOpenGate extends ConsumerWidget {
  const SaveOpenGate({required this.onRetry, required this.child, super.key});

  /// Tears the app down and opens the database again.
  final VoidCallback onRetry;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(saveOpensProvider).hasError) return child;
    final recovery = ref.watch(saveRecoveryProvider).valueOrNull;
    final copy = recovery?.copy;
    return SaveUpgradeFailedScreen(
      locale: ref.watch(saveFailureLocaleProvider).valueOrNull,
      onRetry: onRetry,
      onRestore: copy == null
          ? null
          : () => _restore(ref, recovery!.live, copy),
    );
  }

  /// Puts the pre-upgrade copy back and opens again. Returns false, with
  /// the live file left as it was, when the copy could not be put back; the
  /// screen then says so and stays.
  ///
  /// The failed database is closed first. Its open failed, but drift keeps
  /// the connection it opened, and a connection left on the moved file would
  /// remove `fnm.sqlite-wal` by NAME when it is finally closed, which by
  /// then belongs to the restored save.
  Future<bool> _restore(WidgetRef ref, File live, File copy) async {
    try {
      await ref
          .read(appDatabaseProvider)
          .close()
          .timeout(const Duration(seconds: 5));
    } on Object {
      // Never opened, or already closed: nothing holds the file.
    }
    try {
      final aside = await SaveBackup.restorePreUpgradeCopy(live, copy);
      AppLog.info('pre-upgrade-restore', 'failed save kept as ${aside.path}');
    } on Object catch (e, stack) {
      AppLog.error('pre-upgrade-restore', e, stack);
      return false;
    }
    onRetry();
    return true;
  }
}
