import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'careers_tablet_layout.dart';

/// The "Careers" hub: a menu grouping the manager's career record, the national
/// team's all-time records, and the played-match history.
class CareersScreen extends StatelessWidget {
  const CareersScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('careers.tabletLayout');

  final int careerId;

  @override
  Widget build(BuildContext context) {
    if (TabletShellScope.isActive(context)) {
      return _CareersTabletLayout(careerId: careerId);
    }
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
          for (final (i, e) in _careerMenu(l, careerId).indexed) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _MenuTile(
              key: e.key,
              icon: e.icon,
              title: e.title,
              subtitle: e.subtitle,
              onTap: () => context.go(e.location),
            ),
          ],
        ],
      ),
    );
  }
}

/// One destination of the Career menu.
typedef _CareerEntry = ({
  Key? key,
  IconData icon,
  String title,
  String subtitle,
  String location,
});

/// The Career menu, top to bottom: the same destinations on both layouts.
List<_CareerEntry> _careerMenu(AppLocalizations l, int careerId) => [
  (
    // The onboarding tour's Career step points here, on both layouts.
    key: TourKeys.careerHistory,
    icon: Icons.timeline,
    title: l.careerManagerCareer,
    subtitle: l.careerManagerCareerSubtitle,
    location: '${Routes.managerHistory}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.workspace_premium,
    title: l.careerSummaryTitle,
    subtitle: l.careerSummarySubtitle,
    location: '${Routes.careerSummary}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.emoji_events,
    title: l.careerAchievements,
    subtitle: l.careerAchievementsSubtitle,
    location: '${Routes.achievements}?careerId=$careerId',
  ),
  // Beside achievements, not buried inside them: the challenges used to be
  // reachable only from a button in the achievements app bar, so a manager
  // who never went looking never knew they were there.
  (
    key: null,
    icon: Icons.local_fire_department_rounded,
    title: l.careerChallenges,
    subtitle: l.careerChallengesSubtitle,
    location: '${Routes.challenges}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.leaderboard,
    title: l.careerTeamRecords,
    subtitle: l.careerTeamRecordsSubtitle,
    location: '${Routes.teamStats}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.sports_soccer,
    title: l.careerMyMatches,
    subtitle: l.careerMyMatchesSubtitle,
    location: '${Routes.results}?careerId=$careerId',
  ),
];

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
