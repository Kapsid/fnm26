import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// A nation's overall, year by year — whether the side the manager inherited is
/// getting better or quietly ageing out from under him.
///
/// Follows the world-ranking chart's shape rather than adding a charting
/// dependency: a painted line, its ends labelled.
class TeamOverallHistoryCard extends StatelessWidget {
  const TeamOverallHistoryCard({
    required this.history,
    this.nationName,
    super.key,
  });

  final List<TeamOverallPoint> history;

  /// The side the curve belongs to, named when the screen around it isn't
  /// already about one nation. The manager's career screen spans every job he
  /// has held, so a curve with no name on it would read as "my teams" when it
  /// is only the side he runs now.
  final String? nationName;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // One point is not a curve — a save in its first season has nothing to
    // show yet, and an empty chart says less than no chart at all.
    if (history.length < 2) return const SizedBox.shrink();

    final values = history.map((p) => p.overall);
    final best = values.reduce((a, b) => a > b ? a : b);
    final worst = values.reduce((a, b) => a < b ? a : b);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The heading gives way, never the number: the number is what
              // the manager came to read.
              Flexible(
                child: Text(
                  l.teamOverallOverTime,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${l.teamOverall} ${history.last.overall}',
                style: AppTypography.labelMedium,
              ),
            ],
          ),
          // Its own line, never a third item in the header row: that row is
          // already two long words wide in Czech at 360px.
          if (nationName != null)
            Text(
              nationName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 110,
            child: CustomPaint(
              size: Size.infinite,
              painter: _OverallLinePainter(history, best: best, worst: worst),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${history.first.year}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${history.last.year}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverallLinePainter extends CustomPainter {
  _OverallLinePainter(this.history, {required this.best, required this.worst});

  final List<TeamOverallPoint> history;

  /// The highest and lowest overall in the run — the chart's own scale, so a
  /// three-point rise is visible instead of being flattened against 0–99.
  final int best;
  final int worst;

  @override
  void paint(Canvas canvas, Size size) {
    final span = best == worst ? 1 : best - worst;
    final n = history.length;
    double x(int i) => n == 1 ? size.width / 2 : size.width * i / (n - 1);
    // A higher overall sits higher on the chart — the opposite of a ranking.
    double y(int overall) =>
        size.height * (0.90 - 0.80 * (overall - worst) / span);

    final grid = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    canvas
      ..drawLine(Offset(0, y(best)), Offset(size.width, y(best)), grid)
      ..drawLine(Offset(0, y(worst)), Offset(size.width, y(worst)), grid);

    final path = Path();
    for (var i = 0; i < n; i++) {
      final o = Offset(x(i), y(history[i].overall));
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < n; i++) {
      canvas.drawCircle(
        Offset(x(i), y(history[i].overall)),
        3,
        Paint()..color = AppColors.primary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OverallLinePainter old) =>
      old.history != history || old.best != best || old.worst != worst;
}
