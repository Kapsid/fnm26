import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The "Careers" hub: a menu grouping the manager's career record, the national
/// team's all-time records, and the played-match history.
class CareersScreen extends StatelessWidget {
  const CareersScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.careersTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: AppBottomNav(
        careerId: careerId,
        current: AppTab.careers,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          _MenuTile(
            key: TourKeys.careerHistory,
            icon: Icons.timeline,
            title: l.careerManagerCareer,
            subtitle: l.careerManagerCareerSubtitle,
            onTap: () =>
                context.go('${Routes.managerHistory}?careerId=$careerId'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MenuTile(
            icon: Icons.workspace_premium,
            title: l.careerSummaryTitle,
            subtitle: l.careerSummarySubtitle,
            onTap: () =>
                context.go('${Routes.careerSummary}?careerId=$careerId'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MenuTile(
            icon: Icons.emoji_events,
            title: l.careerAchievements,
            subtitle: l.careerAchievementsSubtitle,
            onTap: () =>
                context.go('${Routes.achievements}?careerId=$careerId'),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Beside achievements, not buried inside them: the challenges used
          // to be reachable only from a button in the achievements app bar,
          // so a manager who never went looking never knew they were there.
          _MenuTile(
            icon: Icons.local_fire_department_rounded,
            title: l.careerChallenges,
            subtitle: l.careerChallengesSubtitle,
            onTap: () => context.go('${Routes.challenges}?careerId=$careerId'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MenuTile(
            icon: Icons.leaderboard,
            title: l.careerTeamRecords,
            subtitle: l.careerTeamRecordsSubtitle,
            onTap: () => context.go('${Routes.teamStats}?careerId=$careerId'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MenuTile(
            icon: Icons.sports_soccer,
            title: l.careerMyMatches,
            subtitle: l.careerMyMatchesSubtitle,
            onTap: () => context.go('${Routes.results}?careerId=$careerId'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
            size: 20,
          ),
        ],
      ),
    );
  }
}
