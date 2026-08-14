import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The per-save achievements screen: an unlocked count and every achievement
/// grouped by category, with progress for tally-based ones.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(achievementsViewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.careers}?careerId=$careerId'),
        ),
        title: Text(
          l.achievementsScreenTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: l.achievementsChallengesTooltip,
            icon: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.primary,
            ),
            onPressed: () =>
                context.go('${Routes.challenges}?careerId=$careerId'),
          ),
        ],
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final earned = views.where((v) => v.earned).length;
          final grouped = <AchievementCategory, List<AchievementView>>{};
          for (final v in views) {
            (grouped[v.def.category] ??= []).add(v);
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                onTap: () =>
                    context.go('${Routes.challenges}?careerId=$careerId'),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.achievementsChallengesHeading,
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            l.achievementsBrutalTests,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l.achievementsUnlockedCount(earned, views.length),
                    style: AppTypography.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final cat in AchievementCategory.values)
                if (grouped[cat] case final rows?) ...[
                  Text(
                    achievementCategoryLabel(l, cat).toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  for (final v in rows) _AchievementTile(view: v),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          );
        },
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.view});

  final AchievementView view;

  @override
  Widget build(BuildContext context) {
    final text = achievementText(AppLocalizations.of(context), view.def);
    final earned = view.earned;
    final showProgress = !earned && view.current != null && view.target != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              earned ? Icons.emoji_events : Icons.lock_outline,
              color: earned ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          text.title,
                          style: AppTypography.titleMedium.copyWith(
                            color: earned
                                ? AppColors.onSurface
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _TierBadge(view.def.tier, dimmed: !earned),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text.description,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (showProgress) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _ProgressBar(current: view.current!, target: view.target!),
                  ],
                ],
              ),
            ),
            if (earned)
              const Padding(
                padding: EdgeInsets.only(left: AppSpacing.sm),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.positive,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A small rarity pill (Bronze / Silver / Gold / Platinum), coloured by tier
/// and greyed while the achievement is still locked.
class _TierBadge extends StatelessWidget {
  const _TierBadge(this.tier, {required this.dimmed});

  final AchievementTier tier;
  final bool dimmed;

  static const _colors = {
    AchievementTier.bronze: AppColors.medalBronze,
    AchievementTier.silver: AppColors.medalSilver,
    AchievementTier.gold: AppColors.medalGold,
    AchievementTier.platinum: AppColors.medalPlatinum,
  };

  @override
  Widget build(BuildContext context) {
    final base = _colors[tier]!;
    final color = dimmed ? AppColors.onSurfaceVariant : base;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        achievementTierLabel(AppLocalizations.of(context), tier).toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.current, required this.target});

  final int current;
  final int target;

  @override
  Widget build(BuildContext context) {
    final capped = current > target ? target : current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: AppRadii.smAll,
          child: LinearProgressIndicator(
            value: target == 0 ? 0 : (capped / target).clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$capped / $target',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
