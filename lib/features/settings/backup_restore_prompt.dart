import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Restoring a WHOLE-DATABASE backup, shared by the two screens that offer it.
///
/// It lives on its own because the saves screen now reaches it too. Import
/// there used to accept only a single career, and a manager who had just
/// pressed "back up all saves" on the very same screen got told his backup was
/// not a career. Two buttons, one above the other, speaking different formats.
/// So import reads what it was actually handed, and a whole-database file ends
/// up here rather than being refused.
///
/// The confirmation is not optional and cannot be skipped by either caller:
/// this replaces every save on the phone, not just the one you were looking at.
abstract final class BackupRestorePrompt {
  /// Asks, then restores [path]. Returns the reason it was refused, or null
  /// when the restore ran (on success the app is torn down and rebuilt, so
  /// there may be nobody left to tell).
  ///
  /// Returns null WITHOUT restoring if the manager says no; callers that need
  /// to tell those apart should check [confirm] themselves.
  static Future<BackupRejection?> confirmAndRestore(
    BuildContext context,
    WidgetRef ref,
    String path,
  ) async {
    if (!await confirm(context)) return null;
    if (!context.mounted) return null;
    return ref.read(saveBackupServiceProvider).restore(path);
  }

  /// The "this replaces everything" question, worded as what it actually does.
  static Future<bool> confirm(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(l.backupRestoreWarnTitle),
        content: Text(l.backupRestoreWarnBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.backupCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.backupRestoreConfirm),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// What to tell the manager about a refusal.
  static String reason(AppLocalizations l, BackupRejection refusal) =>
      switch (refusal) {
        BackupRejection.unreadable => l.backupRejectedUnreadable,
        BackupRejection.notAFnmSave => l.backupRejectedNotFnm,
        BackupRejection.fromANewerBuild => l.backupRejectedNewer,
        BackupRejection.tooOldToMigrate => l.backupRejectedTooOld,
      };
}
