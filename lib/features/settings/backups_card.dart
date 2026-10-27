import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/share_origin.dart';
import 'package:fnm/data/cloud/drive_backup_target.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_store.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:fnm/features/cloud/cloud_backup_providers.dart';
import 'package:fnm/features/settings/backup_restore_prompt.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Settings' Backups section: the whole-database backup to a file (shared to
/// Drive, iCloud Drive or Files), restoring from one, the reminder switch, and
/// on iPhone or Android the automatic cloud backup and restoring from it.
///
/// The unit throughout is the whole database, every save at once: this is the
/// "do not lose twenty years to a dead phone" control, not a per-career one.
class BackupsCard extends ConsumerStatefulWidget {
  const BackupsCard({super.key});

  static const Key lastBackupKey = Key('backups.last');
  static const Key remindersKey = Key('backups.reminders');
  static const Key autoKey = Key('backups.auto');
  static const Key statusKey = Key('backups.status');
  static const Key restoreCloudKey = Key('backups.restoreCloud');
  static const Key signOutKey = Key('backups.signOut');
  static const Key helpKey = Key('backups.help');
  static const Key safetyKey = Key('backups.safety');

  @override
  ConsumerState<BackupsCard> createState() => _BackupsCardState();
}

class _BackupsCardState extends ConsumerState<BackupsCard> {
  bool _busy = false;

  /// True while the file picker or the restore question is up. The buttons
  /// only grey out once the restore runs, so until then a second tap reaches
  /// the handler, and it is refused here rather than opening a second picker.
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(backupSettingsProvider.notifier).ensureLoaded());
  }

  /// [origin] is the button's on-screen rect, taken at the tap while it is
  /// laid out: an iPad's share sheet must point at something.
  Future<void> _export(Rect? origin) async {
    // A second tap before the button rebuilds disabled still calls this.
    if (_busy || _asking) return;
    final l = AppLocalizations.of(context);
    final settings = ref.read(backupSettingsProvider.notifier);
    setState(() => _busy = true);
    try {
      final file = await ref.read(saveBackupServiceProvider).export();
      if (!mounted) return;
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l.backupExportSubject,
          sharePositionOrigin: origin,
        ),
      );
      // Dismissed means it went nowhere. Anything else (saved, or a platform
      // that cannot say) counts as a backup made.
      if (result.status != ShareResultStatus.dismissed) {
        await settings.recordBackup(DateTime.now());
      }
      if (mounted) _say(l.backupExported);
    } on Object catch (e, stack) {
      AppLog.error('backup-export', e, stack);
      if (mounted) _say(l.backupFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreFromFile() async {
    if (_busy || _asking) return;
    final l = AppLocalizations.of(context);
    // Read before the first await: `ref` is not to be touched after one.
    final backup = ref.read(saveBackupServiceProvider);
    _asking = true;
    final String? path;
    try {
      path = await _pickAndConfirm();
    } finally {
      _asking = false;
    }
    if (path == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final refusal = await backup.restore(path);
      // On success the app has been torn down and rebuilt, so this State is
      // gone; only a refusal has anyone left to tell.
      if (refusal != null && mounted) {
        _say(BackupRestorePrompt.reason(l, refusal));
      }
    } finally {
      // A refusal, or a restore that threw, gives the buttons back.
      if (mounted) setState(() => _busy = false);
    }
  }

  /// The backup file to restore, or null if none was picked or the manager
  /// said no.
  Future<String?> _pickAndConfirm() async {
    final picked = await FilePicker.pickFiles();
    final path = picked?.files.single.path;
    if (path == null || !mounted) return null;
    // Asked BEFORE anything is touched, and worded as what it actually does.
    if (!await BackupRestorePrompt.confirm(context) || !mounted) return null;
    return path;
  }

  /// Puts back a copy a restore left behind. It goes through the same
  /// restore (and takes its own safety copy first), so this is reversible too.
  Future<void> _restoreSafetyCopy(File copy) async {
    if (_busy || _asking) return;
    final l = AppLocalizations.of(context);
    final backup = ref.read(saveBackupServiceProvider);
    _asking = true;
    final bool yes;
    try {
      yes = await BackupRestorePrompt.confirm(context);
    } finally {
      _asking = false;
    }
    if (!yes || !mounted) return;
    setState(() => _busy = true);
    try {
      final refusal = await backup.restore(copy.path);
      if (refusal != null && mounted) {
        _say(BackupRestorePrompt.reason(l, refusal));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Hands a safety copy to the share sheet, to keep it somewhere else.
  Future<void> _shareSafetyCopy(File copy, Rect? origin) async {
    if (_busy || _asking) return;
    final l = AppLocalizations.of(context);
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(copy.path)],
          subject: l.backupExportSubject,
          sharePositionOrigin: origin,
        ),
      );
    } on Object catch (e, stack) {
      AppLog.error('safety-copy-share', e, stack);
      if (mounted) _say(l.backupFailed);
    }
  }

  Future<void> _restoreFromCloud(CloudProvider kind) async {
    if (_busy || _asking) return;
    _asking = true;
    try {
      await showCloudRestoreSheet(context, kind);
    } finally {
      _asking = false;
    }
  }

  Future<void> _setAuto(CloudProvider kind, bool on) async {
    final l = AppLocalizations.of(context);
    final settings = ref.read(backupSettingsProvider.notifier);
    final service = ref.read(cloudBackupServiceProvider);
    if (!on) {
      await settings.setAutoEnabled(false);
      return;
    }
    if (kind == CloudProvider.googleDrive &&
        ref.read(backupSettingsProvider).driveEmail == null) {
      if (_busy) return;
      setState(() => _busy = true);
      try {
        await service.signInToDrive();
      } on CloudSetupException {
        ref.read(cloudStatusProvider.notifier).state =
            CloudStatus.notConfigured;
      } on Object catch (e, stack) {
        AppLog.error('drive-sign-in', e, stack);
        if (mounted) _say(l.backupDriveSignInFailed);
      } finally {
        if (mounted) setState(() => _busy = false);
      }
      return;
    }
    await settings.setAutoEnabled(true);
    // A first backup straight away rather than at the next match.
    unawaited(service.trigger(BackupTrigger.committed));
  }

  Future<void> _signOut() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(cloudBackupServiceProvider).signOutOfDrive();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _say(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    final kind = ref.watch(cloudProviderKindProvider);
    final sub = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    final last = settings.lastBackupAt;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.backupTitle,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // No automatic backup on this device (Android): the intro must not
          // point at a switch below that isn't there.
          Text(kind == null ? l.backupBlurbNoAuto : l.backupBlurb, style: sub),
          const SizedBox(height: AppSpacing.sm),
          Text(
            last == null
                ? l.backupNever
                : l.backupLastAt(AppDate.dayMonthYearTime(context, last)),
            key: BackupsCard.lastBackupKey,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Builder(
            builder: (button) => PrimaryButton(
              label: l.backupExport,
              icon: Icons.cloud_upload_outlined,
              onPressed: _busy ? null : () => _export(shareOriginOf(button)),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l.backupShareHint, style: sub),
          const SizedBox(height: AppSpacing.sm),
          _OutlinedRow(
            label: l.backupRestore,
            icon: Icons.settings_backup_restore_rounded,
            onPressed: _busy ? null : _restoreFromFile,
          ),
          _SafetyCopies(
            busy: _busy,
            onRestore: _restoreSafetyCopy,
            onShare: _shareSafetyCopy,
          ),
          if (kind != null) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            _AutoBackupTile(
              kind: kind,
              enabled: settings.autoEnabled,
              busy: _busy,
              onChanged: (on) => _setAuto(kind, on),
            ),
            _CloudStatusLine(kind: kind, settings: settings),
            if (kind == CloudProvider.googleDrive &&
                settings.driveEmail != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  key: BackupsCard.signOutKey,
                  onPressed: _busy ? null : _signOut,
                  child: Text(l.backupDriveSignOut),
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            _OutlinedRow(
              key: BackupsCard.restoreCloudKey,
              label: kind == CloudProvider.icloud
                  ? l.backupRestoreICloud
                  : l.backupRestoreDrive,
              icon: Icons.cloud_download_outlined,
              onPressed: _busy ? null : () => _restoreFromCloud(kind),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          SwitchListTile(
            key: BackupsCard.remindersKey,
            contentPadding: EdgeInsets.zero,
            value: settings.remindersOn,
            onChanged: (v) =>
                ref.read(backupSettingsProvider.notifier).setReminders(v),
            activeThumbColor: AppColors.primary,
            title: Text(
              l.backupRemindersTitle,
              style: AppTypography.bodyMedium,
            ),
            subtitle: Text(l.backupRemindersBlurb, style: sub),
          ),
          Text(
            l.backupCrossPlatformHelp,
            key: BackupsCard.helpKey,
            style: sub,
          ),
        ],
      ),
    );
  }
}

/// The copies a restore left behind, each one restorable or shareable. Shown
/// only when there are some.
class _SafetyCopies extends ConsumerWidget {
  const _SafetyCopies({
    required this.busy,
    required this.onRestore,
    required this.onShare,
  });

  final bool busy;
  final void Function(File copy) onRestore;
  final void Function(File copy, Rect? origin) onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copies = ref.watch(safetyCopiesProvider).valueOrNull ?? const [];
    if (copies.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final sub = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Padding(
      key: BackupsCard.safetyKey,
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.backupSafetyTitle, style: AppTypography.bodyMedium),
          Text(l.backupSafetyBlurb, style: sub),
          for (final copy in copies)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  Text(
                    AppDate.dayMonthYearTime(
                      context,
                      copy.lastModifiedSync(),
                    ),
                    style: AppTypography.labelMedium,
                  ),
                  TextButton(
                    onPressed: busy ? null : () => onRestore(copy),
                    child: Text(l.backupSafetyRestore),
                  ),
                  Builder(
                    builder: (button) => TextButton(
                      onPressed: busy
                          ? null
                          : () => onShare(copy, shareOriginOf(button)),
                      child: Text(l.backupSafetyShare),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A full-width outlined button, the card's secondary actions.
class _OutlinedRow extends StatelessWidget {
  const _OutlinedRow({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    label: Text(label, textAlign: TextAlign.center),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.outlineVariant),
      minimumSize: const Size.fromHeight(48),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
  );
}

class _AutoBackupTile extends StatelessWidget {
  const _AutoBackupTile({
    required this.kind,
    required this.enabled,
    required this.busy,
    required this.onChanged,
  });

  final CloudProvider kind;
  final bool enabled;
  final bool busy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SwitchListTile(
      key: BackupsCard.autoKey,
      contentPadding: EdgeInsets.zero,
      value: enabled,
      onChanged: busy ? null : onChanged,
      activeThumbColor: AppColors.primary,
      title: Text(
        kind == CloudProvider.icloud
            ? l.backupAutoICloudTitle
            : l.backupAutoDriveTitle,
        style: AppTypography.bodyMedium,
      ),
      subtitle: Text(
        l.backupAutoBlurb,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// One calm line under the automatic-backup switch: what it last did, or why
/// it cannot run. Never an error dialog.
class _CloudStatusLine extends ConsumerWidget {
  const _CloudStatusLine({required this.kind, required this.settings});

  final CloudProvider kind;
  final BackupSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final status = ref.watch(cloudStatusProvider);
    final availability = ref.watch(cloudAvailabilityProvider).valueOrNull;
    final drive = kind == CloudProvider.googleDrive;

    // What the last attempt said wins; otherwise what the check on opening
    // said; otherwise the account (Drive) or nothing.
    var shown = status;
    if (shown == CloudStatus.idle && availability != null) {
      shown = statusFor(availability);
    }
    final text = switch (shown) {
      CloudStatus.uploading => l.backupStatusUploading,
      CloudStatus.uploaded => l.backupStatusUploaded,
      CloudStatus.signedOut =>
        drive ? l.backupStatusDriveSignedOut : l.backupStatusICloudSignedOut,
      CloudStatus.notConfigured => l.backupStatusNotConfigured,
      CloudStatus.unavailable => l.backupStatusUnavailable,
      CloudStatus.failed => l.backupStatusFailed,
      CloudStatus.idle => null,
    };
    final email = settings.driveEmail;
    final lines = [
      if (drive && email != null) l.backupDriveSignedInAs(email),
      ?text,
    ];
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        lines.join('\n'),
        key: BackupsCard.statusKey,
        style: AppTypography.labelSmall.copyWith(
          color: shown == CloudStatus.failed
              ? AppColors.warning
              : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// The list of cloud backups on the account, newest first, each restorable
/// after a confirmation. Opened from the Backups card.
Future<void> showCloudRestoreSheet(
  BuildContext context,
  CloudProvider kind,
) => showAdaptiveSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (ctx) => _CloudRestoreSheet(kind: kind),
);

class _CloudRestoreSheet extends ConsumerStatefulWidget {
  const _CloudRestoreSheet({required this.kind});

  final CloudProvider kind;

  @override
  ConsumerState<_CloudRestoreSheet> createState() => _CloudRestoreSheetState();
}

class _CloudRestoreSheetState extends ConsumerState<_CloudRestoreSheet> {
  late Future<List<CloudBackupEntry>> _entries;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _entries = ref.read(cloudBackupServiceProvider).listBackups();
  }

  Future<void> _restore(CloudBackupEntry entry) async {
    if (_restoring) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(cloudBackupServiceProvider);
    if (!await BackupRestorePrompt.confirm(context) || !mounted) return;
    setState(() => _restoring = true);
    try {
      final refusal = await service.restore(entry);
      if (refusal != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(BackupRestorePrompt.reason(l, refusal))),
        );
      }
    } on Object catch (e, stack) {
      AppLog.error('cloud-restore', e, stack);
      messenger.showSnackBar(
        SnackBar(content: Text(l.backupCloudListFailed)),
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final deviceId = ref.watch(backupSettingsProvider).deviceId;
    final sub = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.kind == CloudProvider.icloud
                    ? l.backupRestoreICloud
                    : l.backupRestoreDrive,
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l.backupCloudListBlurb, style: sub),
              const SizedBox(height: AppSpacing.md),
              if (_restoring) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.backupCloudDownloading,
                  style: sub,
                  textAlign: TextAlign.center,
                ),
              ] else
                Flexible(
                  child: FutureBuilder<List<CloudBackupEntry>>(
                    future: _entries,
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snap.hasError) {
                        return Text(l.backupCloudListFailed, style: sub);
                      }
                      final entries = snap.data ?? const [];
                      if (entries.isEmpty) {
                        return Text(l.backupCloudListEmpty, style: sub);
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) => _EntryTile(
                          entry: entries[i],
                          thisDevice: entries[i].deviceId == deviceId,
                          onTap: () => _restore(entries[i]),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.thisDevice,
    required this.onTap,
  });

  final CloudBackupEntry entry;
  final bool thisDevice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final meta = entry.meta;
    final device = thisDevice
        ? l.backupCloudThisDevice
        : (meta?.deviceName.isNotEmpty ?? false)
        ? meta!.deviceName
        : null;
    final careers = meta?.careers ?? const [];
    final newer =
        meta != null && meta.schemaVersion > AppDatabase.currentSchemaVersion;
    final lines = [
      ?device,
      if (meta == null) l.backupCloudNoDetails,
      for (final c in careers.take(3))
        [
          c.managerName,
          ?c.nationName,
          if (c.year > 0) '${c.year}',
        ].where((s) => s.isNotEmpty).join(', '),
      if (careers.length > 3) l.backupCloudMore(careers.length - 3),
      if (newer) l.backupCloudNewer,
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: newer ? null : onTap,
      leading: const Icon(Icons.history_rounded, color: AppColors.primary),
      title: Text(
        AppDate.dayMonthYearTime(context, entry.at),
        style: AppTypography.bodyMedium,
      ),
      subtitle: lines.isEmpty
          ? null
          : Text(
              lines.join('\n'),
              style: AppTypography.labelSmall.copyWith(
                color: newer ? AppColors.warning : AppColors.onSurfaceVariant,
              ),
            ),
    );
  }
}
