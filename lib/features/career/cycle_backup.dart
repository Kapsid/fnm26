import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The career's copy in the app's `FNM` folder, taken as each cycle opens.
///
/// A player asked whether his career would follow him to a new phone. The
/// save lives on the phone; this keeps a copy of it per cycle without asking,
/// and says where it went and what it does not cover (an uninstall), so the
/// Back up button on the saves list is the one he reaches for to keep a copy
/// elsewhere.
abstract final class CycleBackup {
  /// Writes [careerId] to its app-folder file and says so. Never throws: the
  /// caller is mid-way through the end of a cycle, and a failed copy must not
  /// stop the next one starting.
  static Future<void> run(
    ScaffoldMessengerState messenger,
    AppLocalizations l,
    WidgetRef ref,
    int careerId,
  ) async {
    try {
      await ref.read(careerTransferServiceProvider).backupToAppFolder(careerId);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.cycleBackupDone),
          duration: const Duration(seconds: 6),
        ),
      );
    } on Object catch (e, stack) {
      AppLog.error('cycle-backup', e, stack);
      messenger.showSnackBar(SnackBar(content: Text(l.cycleBackupFailed)));
    }
  }
}
