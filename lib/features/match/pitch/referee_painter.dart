import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/referee_card.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';

/// The referee of a sending-off ([RefereeCardShow]), drawn over the players
/// on the 2D TV: a dark token with a lime collar, running in, the card held
/// up over his head, and away again. Nothing else of the match is his: he
/// is on the pitch only for a red card.
///
/// Repaints on every tick of [clock], like the players; a frame with no
/// sending-off on show draws nothing.
class RefereePainter extends CustomPainter {
  RefereePainter({
    required this.script,
    required this.clock,
    required this.projection,
  }) : shows = RefereeCardShow.of(script),
       r0 = ActorsPainter.tokenRadiusFor(projection.viewport),
       super(repaint: clock);

  final PitchScript script;
  final ValueListenable<Duration> clock;
  final PitchProjection projection;

  /// The script's sending-offs, in time order.
  final List<RefereeCardShow> shows;

  /// The players' token size at the near touchline: he is drawn a little
  /// smaller than them.
  final double r0;

  /// The referee's shirt, its collar and the cards.
  static const Color shirt = Color(0xFF15171A);
  static const Color collar = Color(0xFFD7E84A);
  static const Color red = Color(0xFFE0262B);
  static const Color yellow = Color(0xFFF7CF1D);

  /// The referee on show at screen second [t], if any.
  RefereeFrame? frameAt(double t) {
    for (final s in shows) {
      if (t < s.start) break;
      final f = s.frameAt(t);
      if (f != null) return f;
    }
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (shows.isEmpty) return;
    final f = frameAt(clock.value.inMicroseconds / 1e6);
    if (f == null || f.alpha <= 0.002) return;
    paintReferee(canvas, projection, r0, f);
  }

  /// [f] drawn with [projection], tokens [r0] across at the near touchline.
  static void paintReferee(
    Canvas canvas,
    PitchProjection projection,
    double r0,
    RefereeFrame f,
  ) {
    final c = projection.toScreenOpen(f.at.x, f.at.y);
    final r = r0 * 0.9 * projection.scaleAt(f.at.y);
    final a = f.alpha.clamp(0.0, 1.0);
    // His shadow, then him.
    canvas.drawOval(
      Rect.fromCenter(
        center: c.translate(r * 0.35, r * 0.95),
        width: r * 2.1,
        height: r * 0.8,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3 * a)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.3),
    );
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: r * 1.5, height: r * 1.8),
      Radius.circular(r * 0.55),
    );
    canvas
      ..drawRRect(body, Paint()..color = shirt.withValues(alpha: a))
      ..drawRRect(
        body,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.8, r * 0.1)
          ..color = Colors.white.withValues(alpha: 0.75 * a),
      )
      // The collar.
      ..drawArc(
        Rect.fromCenter(
          center: c.translate(0, -r * 0.72),
          width: r * 0.8,
          height: r * 0.5,
        ),
        0,
        math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, r * 0.2)
          ..color = collar.withValues(alpha: a),
      );
    final card = f.card;
    if (card == null) return;
    // His arm up, the card at the top of it: [raise] of the way.
    final u = Curves.easeOutBack.transform(f.raise.clamp(0.0, 1.0));
    final shoulder = c.translate(r * 0.6, -r * 0.45);
    final hand = shoulder.translate(r * 0.25, -r * (0.5 + 1.9 * u));
    canvas.drawLine(
      shoulder,
      hand,
      Paint()
        ..strokeWidth = math.max(1.2, r * 0.26)
        ..strokeCap = StrokeCap.round
        ..color = shirt.withValues(alpha: a),
    );
    final w = r * 1.05;
    final h = r * 1.45;
    final rect = Rect.fromCenter(
      center: hand.translate(0, -h * 0.45),
      width: w,
      height: h,
    );
    canvas
      ..save()
      ..translate(rect.center.dx, rect.center.dy)
      ..rotate(0.12)
      ..translate(-rect.center.dx, -rect.center.dy)
      ..drawRRect(
        RRect.fromRectAndRadius(
          rect.shift(Offset(r * 0.12, r * 0.14)),
          Radius.circular(r * 0.1),
        ),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35 * a)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.12),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(r * 0.1)),
        Paint()
          ..color = (card == RefereeCard.red ? red : yellow).withValues(
            alpha: a,
          ),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(r * 0.1)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.7, r * 0.07)
          ..color = Colors.white.withValues(alpha: 0.85 * a),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant RefereePainter old) =>
      !identical(old.script, script) ||
      !identical(old.clock, clock) ||
      old.projection.viewport != projection.viewport;
}
