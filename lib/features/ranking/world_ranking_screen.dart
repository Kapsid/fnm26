import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// FIFA-style world ranking of every nation, filterable by confederation, with
/// the player's team highlighted.
class WorldRankingScreen extends ConsumerWidget {
  const WorldRankingScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(worldRankingProvider(careerId));
    final region = ref.watch(selectedRankRegionProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'WORLD RANKING',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load ranking.\n$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No ranking.'));
          final filtered = region == null
              ? data.nations
              : data.nations.where((n) => n.confederation == region).toList();

          return Column(
            children: [
              _RegionFilter(
                selected: region,
                onSelect: (r) =>
                    ref.read(selectedRankRegionProvider.notifier).state = r,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _RankRow(
                    nation: filtered[i],
                    isPlayer: filtered[i].id == data.playerNationId,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RegionFilter extends StatelessWidget {
  const _RegionFilter({required this.selected, required this.onSelect});

  final Confederation? selected;
  final ValueChanged<Confederation?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.marginMobile,
        ),
        children: [
          _chip(context, 'ALL', selected == null, () => onSelect(null)),
          for (final c in Confederation.values)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: _chip(
                context,
                c.label.toUpperCase(),
                selected == c,
                () => onSelect(c),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: active
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.xlAll,
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: active
                ? AppColors.onSecondaryContainer
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.nation, required this.isPlayer});

  final Nation nation;
  final bool isPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPlayer
            ? AppColors.surfaceContainerHigh
            : AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border(
          left: BorderSide(
            color: isPlayer ? AppColors.primary : AppColors.outlineVariant,
            width: isPlayer ? 3 : 1,
          ),
          top: const BorderSide(color: AppColors.outlineVariant),
          right: const BorderSide(color: AppColors.outlineVariant),
          bottom: const BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${nation.ranking}',
              style: AppTypography.titleMedium.copyWith(
                color: isPlayer
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FlagDisc(nation.code, size: 36, highlighted: isPlayer),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        nation.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium,
                      ),
                    ),
                    if (isPlayer) ...[
                      const SizedBox(width: AppSpacing.sm),
                      const TacticalChip('YOUR TEAM', emphasized: true),
                    ],
                  ],
                ),
                Text(
                  nation.confederation.label.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${rankingPoints(nation.ranking)}',
            style: AppTypography.labelMedium,
          ),
        ],
      ),
    );
  }
}
