import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A championship tile's static presentation (name/region/icon/blurb). Its
/// status and whether it's playable come from [tournamentsOverviewProvider].
class _Championship {
  const _Championship({
    required this.name,
    required this.region,
    required this.icon,
    required this.description,
    this.confederation,
  });

  final String name;
  final String region;
  final IconData icon;
  final String description;

  /// The confederation this championship belongs to, or null for the global
  /// World Championship.
  final Confederation? confederation;
}

const _championships = <_Championship>[
  _Championship(
    name: 'World Championship',
    region: 'GLOBAL',
    icon: Icons.emoji_events,
    description: 'The pinnacle of international football.',
  ),
  _Championship(
    name: 'European Championship',
    region: 'EUROPE',
    icon: Icons.workspace_premium,
    description: 'The fight for the European crown.',
    confederation: Confederation.europe,
  ),
  _Championship(
    name: 'South America Cup',
    region: 'S. AMERICA',
    icon: Icons.flare,
    description: 'Passion and technique — the oldest continental tournament.',
    confederation: Confederation.southAmerica,
  ),
  _Championship(
    name: 'African Championship',
    region: 'AFRICA',
    icon: Icons.diamond,
    description: 'A celebration of pace and power across Africa.',
    confederation: Confederation.africa,
  ),
  _Championship(
    name: 'Asian Championship',
    region: 'ASIA',
    icon: Icons.explore,
    description: 'A dynamic stage for the rising stars of Asia.',
    confederation: Confederation.asia,
  ),
  _Championship(
    name: 'North America Cup',
    region: 'N. AMERICA',
    icon: Icons.public,
    description: 'The premier championship of the CONCACAF region.',
    confederation: Confederation.northAmerica,
  ),
];

/// Tournaments overview (the "Trophy" destination). Lists every championship
/// with its live status; the World Championship and each continental cup open
/// their own detail screen.
class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(tournamentsOverviewProvider(careerId));

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
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load tournaments.\n$e')),
        data: (overview) => ListView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            Text(
              'PRESTIGE STAGE',
              style:
                  AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text('Overview', style: AppTypography.headlineLargeMobile),
            const SizedBox(height: AppSpacing.md),
            for (final c in _championships) ...[
              _ChampionshipTile(
                championship: c,
                status: overview?.statuses[c.confederation],
                championName: () {
                  final id = overview?.statuses[c.confederation]?.championId;
                  return id == null ? null : overview?.nations[id]?.name;
                }(),
                isPlayerRegion:
                    c.confederation == overview?.playerConfederation,
                onView: () => _open(context, c),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, _Championship c) {
    if (c.confederation == null) {
      context.go('${Routes.cup}?careerId=$careerId');
    } else {
      final conf = c.confederation!.name;
      context.go('${Routes.continental}?careerId=$careerId&conf=$conf');
    }
  }
}

class _ChampionshipTile extends StatelessWidget {
  const _ChampionshipTile({
    required this.championship,
    required this.status,
    required this.championName,
    required this.isPlayerRegion,
    required this.onView,
  });

  final _Championship championship;
  final TournamentStatus? status;
  final String? championName;
  final bool isPlayerRegion;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final c = championship;
    final available = status?.available ?? false;
    final label = status?.label ?? 'COMING SOON';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                c.icon,
                color: available
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(c.name, style: AppTypography.headlineMedium),
              ),
              if (isPlayerRegion) ...[
                const TacticalChip('YOUR REGION', emphasized: true),
                const SizedBox(width: AppSpacing.xs),
              ],
              TacticalChip(c.region),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            c.description,
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
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: available
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
              if (championName != null) ...[
                const Spacer(),
                const Icon(
                  Icons.emoji_events,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    championName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (available)
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
