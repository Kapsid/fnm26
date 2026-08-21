import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/data/db/save_backup.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// App settings: the sound-and-haptics toggle for match cues and the UI
/// language selector.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final soundHaptics = ref.watch(soundHapticsEnabledProvider);
    // 'system' when there is no override, otherwise the forced language code.
    final current = ref.watch(localeProvider)?.languageCode ?? 'system';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          // Settings is opened with go() (which replaces the route), so pop
          // back if we can, else return to the home screen.
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
        ),
        title: Text(
          l.settingsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              value: soundHaptics,
              onChanged: (v) => setSoundHaptics(ref, v),
              activeColor: AppColors.primary,
              title: Text(
                l.settingsSoundHapticsTitle,
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                l.settingsSoundHapticsBlurb,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              secondary: const Icon(
                Icons.vibration_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.settingsLanguageTitle,
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            l.settingsLanguageBlurb,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: 'system',
                      label: Text(l.settingsLanguageSystem),
                    ),
                    ButtonSegment(
                      value: 'en',
                      label: Text(l.settingsLanguageEnglish),
                    ),
                    ButtonSegment(
                      value: 'cs',
                      label: Text(l.settingsLanguageCzech),
                    ),
                  ],
                  selected: {current},
                  onSelectionChanged: (sel) => setLocale(
                    ref,
                    sel.first == 'system' ? null : Locale(sel.first),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // The way back into the walk through. It is offered once ever, so
          // without this a manager who said "no thanks" on his first day would
          // have no way of ever changing his mind.
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              onTap: () => startTour(ref),
              leading: const Icon(
                Icons.school_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                l.settingsTourTitle,
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                l.settingsTourBlurb,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              onTap: () => context.push(Routes.diagnostics),
              leading: const Icon(
                Icons.bug_report_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                l.settingsDiagnosticsTitle,
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                l.settingsDiagnosticsBlurb,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _BackupCard(),
        ],
      ),
    );
  }
}

/// Exporting every save to a file, and putting one back.
///
/// Lives in Settings rather than on the saves list because the unit is the
/// whole database: this is the "do not lose twenty years to a dead phone"
/// control, not a per-career one.
class _BackupCard extends ConsumerStatefulWidget {
  const _BackupCard();

  @override
  ConsumerState<_BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends ConsumerState<_BackupCard> {
  bool _busy = false;

  Future<void> _export() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await ref.read(saveBackupServiceProvider).export();
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: l.backupExportSubject,
        ),
      );
      if (mounted) _say(l.backupExported);
    } on Object catch (e, stack) {
      AppLog.error('backup-export', e, stack);
      if (mounted) _say(l.backupFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final picked = await FilePicker.pickFiles();
    final path = picked?.files.single.path;
    if (path == null || !mounted) return;

    // Asked BEFORE anything is touched, and worded as what it actually does:
    // this replaces every save on the phone, not just the one you were on.
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
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final refusal = await ref.read(saveBackupServiceProvider).restore(path);
    // On success the app has been torn down and rebuilt, so this State is
    // gone; only a refusal has anyone left to tell.
    if (refusal != null && mounted) {
      setState(() => _busy = false);
      _say(switch (refusal) {
        BackupRejection.unreadable => l.backupRejectedUnreadable,
        BackupRejection.notAFnmSave => l.backupRejectedNotFnm,
        BackupRejection.fromANewerBuild => l.backupRejectedNewer,
        BackupRejection.tooOldToMigrate => l.backupRejectedTooOld,
      });
    }
  }

  void _say(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
          Text(
            l.backupBlurb,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l.backupExport,
            icon: Icons.ios_share_rounded,
            onPressed: _busy ? null : _export,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _busy ? null : _restore,
            icon: const Icon(Icons.settings_backup_restore_rounded, size: 18),
            label: Text(l.backupRestore),
          ),
        ],
      ),
    );
  }
}
