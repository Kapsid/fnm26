import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The manager's whole journey: every cycle they've managed (nation, balance,
/// tournament finishes) plus the career totals across all of them.
class ManagerHistoryScreen extends ConsumerWidget {
  const ManagerHistoryScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(managerHistoryProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.careers}?careerId=$careerId'),
        ),
        title: Text(
          'MANAGER CAREER',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (h) {
          if (h == null) return const Center(child: Text('No career.'));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _OverallCard(history: h),
              const SizedBox(height: AppSpacing.md),
              Text(
                'CYCLE BY CYCLE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final c in h.cycles) _CycleCard(cycle: c),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.history});

  final ManagerHistory history;

  @override
  Widget build(BuildContext context) {
    final h = history;
    final gd = h.goalDifference;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(h.managerName, style: AppTypography.headlineMedium),
          Text(
            '${h.cycles.length} cycle${h.cycles.length == 1 ? '' : 's'} · '
            '${h.nationsLed} nation${h.nationsLed == 1 ? '' : 's'} led',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(label: 'Titles', value: '${h.titles}', highlight: true),
              _Stat(label: 'Played', value: '${h.played}'),
              _Stat(label: 'Won', value: '${h.won}'),
              _Stat(label: 'Drawn', value: '${h.drawn}'),
              _Stat(label: 'Lost', value: '${h.lost}'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Goals ${h.goalsFor}–${h.goalsAgainst}  '
            '(${gd >= 0 ? '+' : ''}$gd)  ·  '
            'Win rate ${h.played == 0 ? 0 : (h.won * 100 / h.played).round()}%',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({required this.cycle});

  final ManagerCycle cycle;

  @override
  Widget build(BuildContext context) {
    final c = cycle;
    final gd = c.goalDifference;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FlagDisc(c.nation?.code ?? '??', size: 26),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    c.nation?.name ?? 'Unknown',
                    style: AppTypography.titleMedium,
                  ),
                ),
                Text(
                  '${c.year}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${c.won}W ${c.drawn}D ${c.lost}L  ·  '
              'GF ${c.goalsFor} GA ${c.goalsAgainst} '
              '(${gd >= 0 ? '+' : ''}$gd)',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _Finish(label: 'World Cup', placement: c.worldCup),
                ),
                Expanded(
                  child: _Finish(
                    label: 'Continental',
                    placement: c.continental,
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

class _Finish extends StatelessWidget {
  const _Finish({required this.label, required this.placement});

  final String label;
  final String placement;

  @override
  Widget build(BuildContext context) {
    final gold = placement == 'Champions';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Row(
          children: [
            if (gold)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.emoji_events,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            Flexible(
              child: Text(
                placement,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: gold ? AppColors.primary : AppColors.onSurface,
                  fontWeight: gold ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: highlight ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
