import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/match/match_flow.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// A goal on the xG chart: its minute and whose it was.
typedef FlowGoal = ({int minute, bool home});

/// The stats tab's two charts over the match, drawn as of the clock: both
/// sides' xG adding up (a step line each, a dot where a goal went in) and
/// who was on top (a bar a minute, up for the hosts, down for the visitors;
/// see [MatchFlow.momentum]).
///
/// Live, each chart is drawn up to [minute] on a ninety-minute axis (a
/// hundred and twenty once extra time is under way), so it never shows a
/// minute the match has not reached; at full time the whole match.
class MatchFlowCharts extends StatelessWidget {
  const MatchFlowCharts({
    required this.homeXg,
    required this.awayXg,
    required this.minute,
    required this.homeColor,
    required this.awayColor,
    this.goals = const [],
    super.key,
  });

  /// Cumulative xG a minute, index 0 the kick-off (`MatchResult`'s series).
  final List<double> homeXg;
  final List<double> awayXg;

  /// The last minute to draw (clamped to the series).
  final int minute;

  /// The two sides' colours, already told apart (see `KitClash`).
  final Color homeColor;
  final Color awayColor;

  /// The goals the clock has reached.
  final List<FlowGoal> goals;

  /// The chart heights.
  static const double xgHeight = 96;
  static const double momentumHeight = 56;

  int get _upTo => math.min(minute, math.min(homeXg.length, awayXg.length) - 1);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final upTo = math.max(0, _upTo);
    final span = upTo > 90 || homeXg.length > 91 ? 120 : 90;
    final home = MatchFlow.xgAt(homeXg, upTo);
    final away = MatchFlow.xgAt(awayXg, upTo);
    final momentum = MatchFlow.momentum(homeXg, awayXg, upTo: upTo);
    final caption = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: caption),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading(l.matchChartXg),
        Semantics(
          label:
              '${l.matchChartXg}: ${home.toStringAsFixed(1)}, '
              '${away.toStringAsFixed(1)}',
          child: ExcludeSemantics(
            child: SizedBox(
              height: xgHeight,
              child: CustomPaint(
                key: const Key('match.xgChart'),
                painter: XgRacePainter(
                  homeXg: homeXg,
                  awayXg: awayXg,
                  upTo: upTo,
                  span: span,
                  homeColor: homeColor,
                  awayColor: awayColor,
                  goals: goals,
                ),
              ),
            ),
          ),
        ),
        _Axis(span: span, style: caption),
        const SizedBox(height: AppSpacing.md),
        heading(l.matchChartMomentum),
        ExcludeSemantics(
          child: SizedBox(
            height: momentumHeight,
            child: CustomPaint(
              key: const Key('match.momentumChart'),
              painter: MomentumPainter(
                momentum: momentum,
                span: span,
                homeColor: homeColor,
                awayColor: awayColor,
              ),
            ),
          ),
        ),
        _Axis(span: span, style: caption),
      ],
    );
  }
}

/// The minute marks under a chart: the kick-off, half time, ninety and,
/// with extra time, a hundred and twenty.
class _Axis extends StatelessWidget {
  const _Axis({required this.span, required this.style});

  final int span;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 16,
    child: LayoutBuilder(
      builder: (context, c) {
        final marks = [0, 45, 90, if (span > 90) 120];
        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (final m in marks)
              Positioned(
                top: 2,
                left: m == 0 ? 0 : null,
                right: m == span ? 0 : null,
                child: m == 0 || m == span
                    ? Text("$m'", style: style)
                    : const SizedBox.shrink(),
              ),
            for (final m in marks)
              if (m != 0 && m != span)
                Positioned(
                  top: 2,
                  left: c.maxWidth * m / span - 12,
                  width: 24,
                  child: Text(
                    "$m'",
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
          ],
        );
      },
    ),
  );
}

/// Both sides' cumulative xG as step lines, with a dot on the line where
/// each goal went in, faint guides at half time and ninety, and each side's
/// figure at the end of its line.
class XgRacePainter extends CustomPainter {
  XgRacePainter({
    required this.homeXg,
    required this.awayXg,
    required this.upTo,
    required this.span,
    required this.homeColor,
    required this.awayColor,
    this.goals = const [],
  });

  final List<double> homeXg;
  final List<double> awayXg;
  final int upTo;
  final int span;
  final Color homeColor;
  final Color awayColor;
  final List<FlowGoal> goals;

  @override
  void paint(Canvas canvas, Size size) {
    final top = math.max<double>(
      1,
      math.max(MatchFlow.xgAt(homeXg, upTo), MatchFlow.xgAt(awayXg, upTo)),
    );
    // Room above the higher line for its dots.
    final yMax = top * 1.15;
    double x(int m) => size.width * m / span;
    double y(double v) => size.height - size.height * v / yMax;

    final guide = Paint()
      ..color = AppColors.outlineVariant
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      guide,
    );
    for (final m in [45, 90]) {
      if (m >= span) continue;
      canvas.drawLine(Offset(x(m), 0), Offset(x(m), size.height), guide);
    }

    void line(List<double> series, Color color) {
      if (series.isEmpty) return;
      final path = Path()..moveTo(0, y(0));
      var last = 0.0;
      for (var m = 1; m <= upTo && m < series.length; m++) {
        final v = series[m];
        if (v != last) {
          path
            ..lineTo(x(m), y(last))
            ..lineTo(x(m), y(v));
          last = v;
        }
      }
      path.lineTo(x(upTo), y(last));
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round,
      );
    }

    line(awayXg, awayColor);
    line(homeXg, homeColor);

    for (final g in goals) {
      if (g.minute > upTo) continue;
      final series = g.home ? homeXg : awayXg;
      final c = Offset(x(g.minute), y(MatchFlow.xgAt(series, g.minute)));
      canvas
        ..drawCircle(c, 4.5, Paint()..color = AppColors.surfaceContainerLow)
        ..drawCircle(c, 3.5, Paint()..color = g.home ? homeColor : awayColor);
    }
  }

  @override
  bool shouldRepaint(XgRacePainter old) =>
      old.upTo != upTo ||
      old.span != span ||
      old.homeColor != homeColor ||
      old.awayColor != awayColor ||
      old.goals.length != goals.length ||
      !identical(old.homeXg, homeXg) ||
      !identical(old.awayXg, awayXg);
}

/// Who was on top: a bar a minute from the centre line, up in the home
/// side's colour, down in the visitors', as tall as the lean
/// ([MatchFlow.momentum]); a faint guide at half time.
class MomentumPainter extends CustomPainter {
  MomentumPainter({
    required this.momentum,
    required this.span,
    required this.homeColor,
    required this.awayColor,
  });

  /// Minute 1 first.
  final List<double> momentum;
  final int span;
  final Color homeColor;
  final Color awayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.height / 2;
    final step = size.width / span;
    final bar = math.max<double>(1, step - 1);
    final guide = Paint()
      ..color = AppColors.outlineVariant
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, mid), Offset(size.width, mid), guide);
    for (final m in [45, 90]) {
      if (m >= span) continue;
      canvas.drawLine(
        Offset(step * m, 0),
        Offset(step * m, size.height),
        guide,
      );
    }
    final home = Paint()..color = homeColor;
    final away = Paint()..color = awayColor;
    for (var i = 0; i < momentum.length; i++) {
      final v = momentum[i];
      if (v == 0) continue;
      final h = v.abs() * (mid - 1);
      final left = step * i;
      canvas.drawRect(
        v > 0
            ? Rect.fromLTWH(left, mid - h, bar, h)
            : Rect.fromLTWH(left, mid, bar, h),
        v > 0 ? home : away,
      );
    }
  }

  @override
  bool shouldRepaint(MomentumPainter old) =>
      !listEquals(old.momentum, momentum) ||
      old.span != span ||
      old.homeColor != homeColor ||
      old.awayColor != awayColor;
}
