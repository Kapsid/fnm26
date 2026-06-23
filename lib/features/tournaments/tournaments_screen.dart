import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A tournament tile's static definition.
class _Tournament {
  const _Tournament({
    required this.name,
    required this.region,
    required this.icon,
    required this.description,
    required this.status,
    this.available = false,
  });

  final String name;
  final String region;
  final IconData icon;
  final String description;
  final String status;

  /// Whether it's playable in this build (only the World Cup so far).
  final bool available;
}

const _tournaments = <_Tournament>[
  _Tournament(
    name: 'Global Championship',
    region: 'GLOBAL',
    icon: Icons.emoji_events,
    description: 'The pinnacle of international football — the World Cup.',
    status: 'QUALIFYING',
    available: true,
  ),
  _Tournament(
    name: 'Continental Trophy',
    region: 'EUROPE',
    icon: Icons.workspace_premium,
    description: 'The fight for the European crown.',
    status: 'COMING SOON',
  ),
  _Tournament(
    name: 'League of Nations',
    region: 'LEAGUE',
    icon: Icons.military_tech,
    description: 'A prestige league where every match carries weight.',
    status: 'COMING SOON',
  ),
  _Tournament(
    name: 'Southern Cup',
    region: 'AMERICAS',
    icon: Icons.flare,
    description: 'Passion and technique — the oldest continental tournament.',
    status: 'COMING SOON',
  ),
  _Tournament(
    name: 'Asian Vanguard',
    region: 'ASIA',
    icon: Icons.explore,
    description: 'A dynamic stage for the rising stars of Asia.',
    status: 'COMING SOON',
  ),
  _Tournament(
    name: 'African Majesty',
    region: 'AFRICA',
    icon: Icons.diamond,
    description: 'A celebration of pace and power across Africa.',
    status: 'COMING SOON',
  ),
];

/// Tournaments overview (the "Trophy" destination). Only the World Cup is live;
/// other competitions are shown as upcoming.
class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'TOURNAMENTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text(
            'PRESTIGE STAGE',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Overview', style: AppTypography.headlineLargeMobile),
          const SizedBox(height: AppSpacing.md),
          for (final t in _tournaments) ...[
            _TournamentTile(
              tournament: t,
              onView: t.available
                  ? () => context.go('${Routes.results}?careerId=$careerId')
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _TournamentTile extends StatelessWidget {
  const _TournamentTile({required this.tournament, required this.onView});

  final _Tournament tournament;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final t = tournament;
    final active = t.available;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                t.icon,
                color: active ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(t.name, style: AppTypography.headlineMedium),
              ),
              TacticalChip(t.region),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                'STATUS',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                t.status,
                style: AppTypography.labelMedium.copyWith(
                  color: active
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (active)
            PrimaryButton(
              label: 'View Standings',
              icon: Icons.table_rows_rounded,
              onPressed: onView,
            )
          else
            OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Tournament coming soon')),
                ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                side: const BorderSide(color: AppColors.outlineVariant),
                foregroundColor: AppColors.onSurfaceVariant,
              ),
              child: const Text('Locked'),
            ),
        ],
      ),
    );
  }
}
