import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// Shows the achievements the season unlocked while stepping the world (see
/// [pendingAchievementUnlocksProvider]), then clears the queue.
///
/// Called with the hub's news, so an achievement arrives with the event that
/// earned it (the finals draw's "World Championship Qualifier" alongside the
/// qualification news) rather than after the next watched match.
Future<void> showPendingAchievementUnlocks(
  BuildContext context,
  WidgetRef ref,
  int careerId,
) async {
  final pending = ref.read(pendingAchievementUnlocksProvider(careerId));
  if (pending.isEmpty) return;
  // Cleared before showing, so a hub rebuild meanwhile cannot show them twice.
  ref.read(pendingAchievementUnlocksProvider(careerId).notifier).state =
      const [];
  final compact =
      ref.read(formFactorProvider) == FormFactor.tablet &&
      context.isWideTabletWindow;
  await showAchievementsUnlocked(context, pending, compact: compact);
}

/// Shows a celebratory dialog listing achievements the player just unlocked.
/// Returns once dismissed. A no-op when [defs] is empty.
///
/// [compact] is the tablet's: a small card in the tablet kit's style, low on
/// the right, instead of a dialog across the screen. Same content, and
/// dismissed the same ways (its button, or a tap outside it).
Future<void> showAchievementsUnlocked(
  BuildContext context,
  List<AchievementDef> defs, {
  bool compact = false,
}) async {
  if (defs.isEmpty) return;
  final l = AppLocalizations.of(context);
  if (compact) {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => _CompactUnlocked(defs: defs),
    );
    return;
  }
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
              l.achievementsUnlockedBanner(defs.length),
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final d in defs)
              Builder(
                builder: (context) {
                  final text = achievementText(l, d);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text.title, style: AppTypography.titleMedium),
                        Text(
                          text.description,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.achievementsNice),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The tablet's unlocked card: a trophy and the count on one line, each
/// achievement as a title over its description, and the button.
class _CompactUnlocked extends StatelessWidget {
  const _CompactUnlocked({required this.defs});

  final List<AchievementDef> defs;

  static const double width = 380;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Dialog(
      alignment: Alignment.bottomRight,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.baseAll,
        side: BorderSide(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.surfaceContainer,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l.achievementsUnlockedBanner(defs.length),
                      style: TabletText.panelTitle.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final d in defs)
                      Builder(
                        builder: (context) {
                          final text = achievementText(l, d);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(text.title, style: TabletText.barStrong),
                                Text(
                                  text.description,
                                  style: TabletText.barMeta,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.achievementsNice),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
