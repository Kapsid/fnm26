import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// FIFA-style world ranking of every nation, filterable by confederation, with
/// the player's team highlighted. Opens focused on the manager's own nation.
class WorldRankingScreen extends ConsumerStatefulWidget {
  const WorldRankingScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<WorldRankingScreen> createState() => _WorldRankingScreenState();
}

/// Height of one rank row, and of the gap under it. Every row is laid out at
/// exactly this size (via `itemExtent`) so "scroll to my nation" is arithmetic
/// rather than an estimate — the old guess drifted a pixel or two per row and
/// pushed the player's team off-screen further down a 200-nation list.
const double _rowHeight = 56;
const double _rowGap = 8;
const double _rowExtent = _rowHeight + _rowGap;

class _WorldRankingScreenState extends ConsumerState<WorldRankingScreen> {
  final _controller = ScrollController();

  /// The (region, index) the list was last centred on, so a filter change (or
  /// a fresh ranking release) re-centres instead of leaving the player's row
  /// wherever the old offset happened to land.
  ({Confederation? region, int index})? _centredOn;

  /// The player's row in the currently filtered list (−1 when filtered out),
  /// so the "centre on me" action can jump back after any scrolling.
  int _playerIndex = -1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Centres the manager's nation in the viewport whenever the row it should
  /// occupy changes.
  void _focusPlayer(Confederation? region, int index) {
    if (index < 0) return;
    if (_centredOn?.region == region && _centredOn?.index == index) return;
    _centredOn = (region: region, index: index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _centre(index));
  }

  void _centre(int index, {bool animate = false}) {
    if (!mounted || !_controller.hasClients || index < 0) return;
    final viewport = _controller.position.viewportDimension;
    // Item `index` starts at listPadding + index * extent; centre its middle.
    final target =
        (AppSpacing.marginMobile +
                index * _rowExtent +
                _rowHeight / 2 -
                viewport / 2)
            .clamp(0.0, _controller.position.maxScrollExtent);
    if (animate) {
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _controller.jumpTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final l = AppLocalizations.of(context);
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
          l.rankingWorldRanking,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: l.rankingCentreOnMe,
            icon: const Icon(
              Icons.my_location_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => _centre(_playerIndex, animate: true),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        careerId: careerId,
        current: AppTab.competitions,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.rankingCouldNotLoad('').trim(),
          onRetry: () => ref.invalidate(worldRankingProvider(careerId)),
        ),
        data: (data) {
          if (data == null) return Center(child: Text(l.rankingNoRanking));
          final filtered = region == null
              ? data.nations
              : data.nations.where((n) => n.confederation == region).toList();
          // Centre the player's row — on open, and again whenever the filter
          // (or the ranking itself) moves them to a different row.
          _playerIndex = filtered.indexWhere(
            (n) => n.id == data.playerNationId,
          );
          _focusPlayer(region, _playerIndex);

          return Column(
            children: [
              _RankHistoryChart(careerId: careerId),
              RankMovementHeader(
                baseline: data.baseline,
                from: data.position[data.playerNationId] == null
                    ? null
                    : (data.position[data.playerNationId]! +
                          (data.movement[data.playerNationId] ?? 0)),
                now: data.position[data.playerNationId],
              ),
              _RegionFilter(
                selected: region,
                onSelect: (r) =>
                    ref.read(selectedRankRegionProvider.notifier).state = r,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  itemCount: filtered.length,
                  // Fixed extent: makes the centring above exact (and keeps a
                  // 200-row list cheap to scroll).
                  itemExtent: _rowExtent,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: _rowGap),
                    child: RankRow(
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
    final l = AppLocalizations.of(context);
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.marginMobile,
        ),
        children: [
          _chip(context, l.rankingAll, selected == null, () => onSelect(null)),
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

/// One nation's line in the world ranking: its place, how far it has moved
/// since the last freeze, its flag, its name and its points.
class RankRow extends StatelessWidget {
  const RankRow({
    required this.nation,
    required this.rank,
    required this.points,
    required this.movement,
    required this.isPlayer,
    required this.onTap,
    super.key,
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
    final l = AppLocalizations.of(context);
    // The left edge highlights the row: the player's colour always, otherwise a
    // green/red tint when the team has moved since the campaign began.
    final (edgeColor, edgeWidth) = isPlayer
        ? (AppColors.primary, 3.0)
        : movement > 0
        ? (AppColors.up, 3.0)
        : movement < 0
        ? (AppColors.down, 3.0)
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
          // The whole outline, not just the left edge. A rounded box can only
          // be painted with a UNIFORM border: the old left-edge-only colour
          // threw "a borderRadius can only be given on borders with uniform
          // colors" on every paint of every row, which a release build
          // swallows and a debug one does not. Outlining the row also makes a
          // climb easier to spot than a 3px stripe did.
          border: Border.all(color: edgeColor, width: edgeWidth),
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
            SizedBox(width: _movementWidth, child: RankMovement(movement)),
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
                        TacticalChip(l.rankingYourTeam, emphasized: true),
                      ],
                    ],
                  ),
                  Text(
                    confederationLabel(l, nation.confederation).toUpperCase(),
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

/// Width of the movement cell in a rank row.
///
/// The old cell was 20px and drew the figure at 9pt, which was enough for a
/// friendly's worth of drift and nothing more: a World Championship can move a
/// nation twenty places and the table runs past two hundred, so the figure is
/// now readable and the cell is measured for three digits of it.
const double _movementWidth = 38;

/// A nation's movement since the last ranking freeze: an arrow for the
/// direction and the number of places beside it, or a dash for no change.
class RankMovement extends StatelessWidget {
  const RankMovement(this.delta, {super.key});

  /// Places climbed (positive) or dropped (negative).
  final int delta;

  @override
  Widget build(BuildContext context) {
    if (delta == 0) {
      return const Icon(
        Icons.remove,
        size: 14,
        color: AppColors.outlineVariant,
      );
    }
    final up = delta > 0;
    final color = up ? AppColors.up : AppColors.down;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: 16,
          color: color,
        ),
        // A plain Text, deliberately: WholeText scales itself down to fit, so
        // a width guard reading didExceedMaxLines can never fail inside one.
        Text(
          '${delta.abs()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

/// The line above the table saying what the arrows are measured from, with the
/// manager's own nation's move spelled out: where it was, where it is now.
///
/// Without this the arrows are a column of unexplained numbers, and the one
/// move the manager actually cares about is somewhere in a list of two hundred.
class RankMovementHeader extends StatelessWidget {
  const RankMovementHeader({
    required this.baseline,
    required this.from,
    required this.now,
    super.key,
  });

  final RankBaseline baseline;

  /// Where the manager's nation stood when the baseline was frozen, and where
  /// it stands now. Null when the nation is not in the baseline at all.
  final int? from;
  final int? now;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final caption = switch (baseline) {
      RankBaseline.worldChampionshipDraw => l.rankingSinceWcDraw,
      RankBaseline.cycleStart => l.rankingSinceCycleStart,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.sm,
        AppSpacing.marginMobile,
        0,
      ),
      // A column, not a row: the caption is a sentence and the figure is a
      // figure, and squeezing them onto one line left the caption 107px to
      // say "Since the World Championship draw" in.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (from != null && now != null)
            Row(
              children: [
                RankMovement(from! - now!),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    l.rankingMovedFromTo(from!, now!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMedium,
                  ),
                ),
              ],
            ),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
    final l = AppLocalizations.of(context);
    final points = ref.watch(rankHistoryProvider(careerId)).valueOrNull;
    if (points == null || points.length < 2) return const SizedBox.shrink();
    // The line shows the recent releases; the best/worst underneath is the
    // career's all-time high and low, which is what "best" and "worst" mean.
    final extremes = ref.watch(rankExtremesProvider(careerId)).valueOrNull;
    final ranks = points.map((p) => p.rank).toList();
    final best = extremes?.best ?? ranks.reduce((a, b) => a < b ? a : b);
    final worst = extremes?.worst ?? ranks.reduce((a, b) => a > b ? a : b);
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
                  l.rankingYourRankingOverTime,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  l.rankingNowRank(points.last.rank),
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
            Center(
              child: Text(
                l.rankingBestWorst(best, worst),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
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
    // Rank 1 (best) sits at the top; a lower rank number maps higher. Reserve
    // headroom at the top for the rank label above each point, and a strip at
    // the bottom for its MM/YY tag.
    const topPad = 18.0;
    const bottomPad = 14.0;
    double x(int i) => size.width * i / (points.length - 1);
    double y(int rank) =>
        topPad +
        (size.height - topPad - bottomPad) * (rank - best) / (worst - best);

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
    final dotCore = Paint()..color = AppColors.surfaceContainer;

    TextPainter label(String text, Color color, double size, FontWeight w) =>
        TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(color: color, fontSize: size, fontWeight: w),
          ),
          textDirection: ui.TextDirection.ltr,
        )..layout();

    // Each point carries its RANK above the dot and its MM/YY below; a tag is
    // skipped when it would collide with the previous one, so a long history
    // stays legible. The first and last points always keep their rank.
    var lastRankRight = double.negativeInfinity;
    var lastDateRight = double.negativeInfinity;
    for (var i = 0; i < points.length; i++) {
      final px = x(i);
      final py = y(points[i].rank);
      // A ringed dot reads as a marked data point rather than a kink in a line.
      canvas.drawCircle(Offset(px, py), 4.5, dot);
      canvas.drawCircle(Offset(px, py), 2.0, dotCore);

      final rank = label(
        '#${points[i].rank}',
        AppColors.primary,
        9,
        FontWeight.w700,
      );
      final rx = (px - rank.width / 2).clamp(0.0, size.width - rank.width);
      final isEnd = i == 0 || i == points.length - 1;
      if (isEnd || rx >= lastRankRight + 4) {
        rank.paint(
          canvas,
          Offset(
            rx,
            (py - rank.height - 6).clamp(0.0, size.height - rank.height),
          ),
        );
        lastRankRight = rx + rank.width;
      }

      final date = label(
        DateFormat('MM/yy').format(points[i].date),
        AppColors.onSurfaceVariant,
        8,
        FontWeight.w600,
      );
      final dx = (px - date.width / 2).clamp(0.0, size.width - date.width);
      if (dx < lastDateRight + 3) continue;
      date.paint(canvas, Offset(dx, size.height - date.height));
      lastDateRight = dx + date.width;
    }
  }

  @override
  bool shouldRepaint(covariant _RankChartPainter old) => old.points != points;
}
