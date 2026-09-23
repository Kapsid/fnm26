import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The brutal, career-long challenges — win multiple World Cups, conquer every
/// confederation, manage for centuries. Distinct from the match achievements.
class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(challengesViewProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          // Back to the careers menu, not to achievements: challenges are a
          // line of that menu in their own right now, and achievements are a
          // sibling rather than the way in.
          onPressed: () => context.go('${Routes.careers}?careerId=$careerId'),
        ),
        title: Text(
          l.achievementsChallengesHeading,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final done = views.where((v) => v.complete).length;
          // This save's procedural challenges get their own section; the rest
          // form the fixed difficulty ladder.
          final procedural = views.where((v) => v.def.procedural).toList();
          final byTier = <ChallengeTier, List<ChallengeView>>{};
          for (final v in views.where((v) => !v.def.procedural)) {
            (byTier[v.def.tier] ??= []).add(v);
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: AppRadii.baseAll,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          l.achievementsConqueredCount(done, views.length),
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.achievementsHardestTests,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (procedural.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l.achievementsThisSave,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${procedural.where((v) => v.complete).length}/'
                        '${procedural.length}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                for (final v in procedural) _ChallengeTile(view: v),
                const SizedBox(height: AppSpacing.sm),
              ],
              for (final tier in ChallengeTier.values)
                if (byTier[tier] case final list?) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 18,
                          color: _tierColor(tier),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          challengeTierLabel(l, tier).toUpperCase(),
                          style: AppTypography.labelMedium.copyWith(
                            color: _tierColor(tier),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${list.where((v) => v.complete).length}/'
                          '${list.length}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final v in list) _ChallengeTile(view: v),
                ],
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// The medal colour for a challenge tier.
Color _tierColor(ChallengeTier tier) => switch (tier) {
  ChallengeTier.bronze => AppColors.medalBronze,
  ChallengeTier.silver => AppColors.medalSilver,
  ChallengeTier.gold => AppColors.medalGold,
  ChallengeTier.legendary => AppColors.primary,
};

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({required this.view});

  final ChallengeView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = challengeText(l, view.def, view.target);
    final complete = view.complete;
    final brutal = view.def.brutal;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  complete
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: complete
                      ? AppColors.positive
                      : AppColors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    text.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: complete ? AppColors.positive : null,
                    ),
                  ),
                ),
                if (brutal)
                  TacticalChip(l.achievementsBrutalBadge, emphasized: true),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              text.description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.smAll,
                    child: LinearProgressIndicator(
                      value: view.target == 0 ? 1 : view.current / view.target,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation(
                        complete ? AppColors.positive : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${view.current}/${view.target}',
                  style: AppTypography.labelMedium.copyWith(
                    color: complete
                        ? AppColors.positive
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
