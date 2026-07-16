import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';

/// Shows a celebratory dialog listing achievements the player just unlocked.
/// Returns once dismissed. A no-op when [defs] is empty.
Future<void> showAchievementsUnlocked(
  BuildContext context,
  List<AchievementDef> defs,
) async {
  if (defs.isEmpty) return;
  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.emoji_events,
              color: AppColors.primary,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              defs.length == 1
                  ? 'ACHIEVEMENT UNLOCKED'
                  : '${defs.length} ACHIEVEMENTS UNLOCKED',
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final d in defs)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.title, style: AppTypography.titleMedium),
                    Text(
                      d.description,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nice!'),
            ),
          ],
        ),
      ),
    ),
  );
}
