import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// App settings. Small for now: the sound-and-haptics toggle for match cues.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundHaptics = ref.watch(soundHapticsEnabledProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
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
              title: Text('Sound & haptics', style: AppTypography.bodyMedium),
              subtitle: Text(
                'Vibration and a short tone on goals, kick-off and full time.',
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
        ],
      ),
    );
  }
}
