import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
          onPressed: () =>
              context.go('${Routes.tournaments}?careerId=$careerId'),
        ),
        title: Text(
          'WORLD RANKING',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar:
          AppBottomNav(careerId: careerId, current: AppTab.competitions),
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
              _RankHistoryChart(careerId: careerId),
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
                    rank: data.position[filtered[i].id] ?? (i + 1),
                    points: data.points[filtered[i].id] ?? 0,
                    movement: data.movement[filtered[i].id] ?? 0,
                    isPlayer: filtered[i].id == data.playerNationId,
                    onTap: () => context.push(
                      '${Routes.nationVitrine}'
                      '?careerId=$careerId&nationId=${filtered[i].id}',
                    ),
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
  const _RankRow({
    required this.nation,
    required this.rank,
    required this.points,
    required this.movement,
    required this.isPlayer,
    required this.onTap,
  });

  final Nation nation;
  final int rank;
  final int points;

  /// Positions climbed (positive) or dropped (negative) since the season began.
  final int movement;
  final bool isPlayer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The left edge highlights the row: the player's colour always, otherwise a
    // green/red tint when the team has moved since the campaign began.
    final (edgeColor, edgeWidth) = isPlayer
        ? (AppColors.primary, 3.0)
        : movement > 0
        ? (const Color(0xFF3FA34D), 3.0)
        : movement < 0
        ? (const Color(0xFFD64545), 3.0)
        : (AppColors.outlineVariant, 1.0);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isPlayer
              ? AppColors.surfaceContainerHigh
              : AppColors.surfaceContainer,
          borderRadius: AppRadii.baseAll,
          border: Border(
            left: BorderSide(color: edgeColor, width: edgeWidth),
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
                '$rank',
                style: AppTypography.titleMedium.copyWith(
                  color: isPlayer
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(width: 20, child: _Movement(movement)),
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
            Text('$points', style: AppTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}

/// A small up/down/steady arrow showing a nation's movement since kick-off.
class _Movement extends StatelessWidget {
  const _Movement(this.delta);

  final int delta;

  @override
  Widget build(BuildContext context) {
    if (delta == 0) {
      return const Icon(
        Icons.remove,
        size: 12,
        color: AppColors.outlineVariant,
      );
    }
    final up = delta > 0;
    final color = up ? const Color(0xFF3FA34D) : const Color(0xFFD64545);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: 16,
          color: color,
        ),
        Text(
          '${delta.abs()}',
          style: AppTypography.labelSmall.copyWith(color: color, fontSize: 9),
        ),
      ],
    );
  }
}

/// A compact line chart of the manager's nation's world ranking over time
/// (cycle-start snapshots plus the live position). Hidden until there are at
/// least two points to connect.
class _RankHistoryChart extends ConsumerWidget {
  const _RankHistoryChart({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(rankHistoryProvider(careerId)).valueOrNull;
    if (points == null || points.length < 2) return const SizedBox.shrink();
    final ranks = points.map((p) => p.rank).toList();
    final best = ranks.reduce((a, b) => a < b ? a : b);
    final worst = ranks.reduce((a, b) => a > b ? a : b);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.marginMobile,
        AppSpacing.marginMobile,
        AppSpacing.sm,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'YOUR RANKING OVER TIME',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  'now #${points.last.rank}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 96,
              width: double.infinity,
              child: CustomPaint(
                painter: _RankChartPainter(points),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM yy').format(points.first.date),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'best #$best · worst #$worst',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  DateFormat('MMM yy').format(points.last.date),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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

class _RankChartPainter extends CustomPainter {
  _RankChartPainter(this.points);

  final List<RankHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final ranks = points.map((p) => p.rank).toList();
    var best = ranks.reduce((a, b) => a < b ? a : b);
    var worst = ranks.reduce((a, b) => a > b ? a : b);
    if (best == worst) {
      best -= 1;
      worst += 1;
    }
    // Rank 1 (best) sits at the top; a lower rank number maps higher.
    double x(int i) => size.width * i / (points.length - 1);
    double y(int rank) =>
        size.height * (rank - best) / (worst - best);

    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(x(0), y(points.first.rank));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(x(i), y(points[i].rank));
    }
    canvas.drawPath(path, line);

    final dot = Paint()..color = AppColors.primary;
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(Offset(x(i), y(points[i].rank)), 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _RankChartPainter old) =>
      old.points != points;
}
