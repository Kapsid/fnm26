import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
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
                    const Icon(Icons.translate_rounded,
                        color: AppColors.primary),
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
        ],
      ),
    );
  }
}
