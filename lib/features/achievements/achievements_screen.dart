import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The per-save achievements screen: a board-satisfaction gauge, an unlocked
/// count, and every achievement grouped by category with progress for tallies.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(achievementsViewProvider(careerId));
    final satisfaction = ref.watch(satisfactionProvider(careerId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.careers}?careerId=$careerId'),
        ),
        title: Text(
          'ACHIEVEMENTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Challenges',
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
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (views) {
          final earned = views.where((v) => v.earned).length;
          final grouped = <AchievementCategory, List<AchievementView>>{};
          for (final v in views) {
            (grouped[v.def.category] ??= []).add(v);
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _SatisfactionCard(percent: satisfaction),
              const SizedBox(height: AppSpacing.md),
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
                          const Text(
                            'CHALLENGES',
                            style: AppTypography.titleMedium,
                          ),
                          Text(
                            'Brutal career-long tests',
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
                    '$earned / ${views.length} unlocked',
                    style: AppTypography.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final cat in AchievementCategory.values)
                if (grouped[cat] case final rows?) ...[
                  Text(
                    cat.label.toUpperCase(),
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

class _SatisfactionCard extends StatelessWidget {
  const _SatisfactionCard({required this.percent});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final p = percent ?? 0;
    final color = p >= 80
        ? AppColors.positive
        : p >= 50
            ? AppColors.primary
            : AppColors.error;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BOARD SATISFACTION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                percent == null ? '—' : '$p%',
                style: AppTypography.titleMedium.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: LinearProgressIndicator(
              value: (p / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.view});

  final AchievementView view;

  @override
  Widget build(BuildContext context) {
    final earned = view.earned;
    final showProgress =
        !earned && view.current != null && view.target != null;
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
                  Text(
                    view.def.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: earned
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    view.def.description,
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
