import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The nation's Legends: an all-time XI and a hall of fame ranked across every
/// cycle of the save — the dynasty layer that makes a long career feel earned.
class LegendsScreen extends ConsumerWidget {
  const LegendsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(legendsProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.recordsLegends,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadLegends(e.toString()))),
        data: (view) {
          if (view == null) {
            return Center(child: Text(l.recordsSaveNotFound));
          }
          if (view.hallOfFame.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoLegends(view.nationName),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(l.recordsAllTimeXi,
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.recordsGreatestSide(view.nationName),
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final l in view.allTimeXi)
                      _LegendRow(
                        careerId: careerId,
                        legend: l,
                        showRank: false,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l.recordsHallOfFame,
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < view.hallOfFame.length; i++)
                      _LegendRow(
                        careerId: careerId,
                        legend: view.hallOfFame[i],
                        rank: i + 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.careerId,
    required this.legend,
    this.rank,
    this.showRank = true,
  });

  final int careerId;
  final RankedLegend legend;
  final int? rank;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The headline stat: goals for attackers, else caps.
    final tallies = <String>[
      l.recordsCapsCount(legend.caps),
      if (legend.goals > 0) l.recordsGoalsCount(legend.goals),
      if (legend.assists > 0) l.recordsAssistsCount(legend.assists),
      if (legend.motm > 0) l.recordsMotmCount(legend.motm),
    ];
    return ListTile(
      dense: true,
      onTap: () => context.push(
        '${Routes.player}?careerId=$careerId&playerId=${legend.playerId}',
      ),
      leading: SizedBox(
        width: 44,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showRank && rank != null)
              SizedBox(
                width: 18,
                child: Text(
                  '$rank',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            TacticalChip(legend.position.label),
          ],
        ),
      ),
      title: Text(
        legend.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMedium,
      ),
      subtitle: Text(
        tallies.join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall
            .copyWith(color: AppColors.onSurfaceVariant),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            legend.avgRating.toStringAsFixed(2),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          Text(
            l.recordsAvg,
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.onSurfaceVariant, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
