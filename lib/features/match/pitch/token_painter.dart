import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/features/match/pitch/stadium_looks.dart';

/// A player on the Pitch view: a shirt in his kit, his number on the chest
/// and a small chevron on the side he faces, his shadow under him and,
/// when he is named, a slim label below.
///
/// [r] is the token's half-width at its depth (the caller scales it with
/// `PitchProjection.scaleAt`).
abstract final class PlayerToken {
  /// Keepers' shirts: a dark slate and a muted olive, apart from any kit.
  static const Color homeKeeper = Color(0xFF3D454E);
  static const Color awayKeeper = Color(0xFF6E8040);

  /// The shirt outline, one unit wide each side of the centre.
  static final Path _shirt = () {
    final p = Path()
      ..moveTo(-0.3, -0.95)
      ..quadraticBezierTo(0, -0.72, 0.3, -0.95)
      ..lineTo(0.62, -0.84)
      ..lineTo(1.0, -0.5)
      ..lineTo(0.8, -0.2)
      ..lineTo(0.6, -0.34)
      ..lineTo(0.6, 0.9)
      ..quadraticBezierTo(0, 0.98, -0.6, 0.9)
      ..lineTo(-0.6, -0.34)
      ..lineTo(-0.8, -0.2)
      ..lineTo(-1.0, -0.5)
      ..lineTo(-0.62, -0.84)
      ..close();
    return p;
  }();

  static Path _scaled(Path p, Offset c, double r) => p.transform(
    Float64List.fromList([
      r, 0, 0, 0, //
      0, r, 0, 0,
      0, 0, 1, 0,
      c.dx, c.dy, 0, 1,
    ]),
  );

  /// The shadows under a token at [c]: the sun's, and one away from each
  /// of [towers] (screen points) as the floodlights come up.
  static void paintShadow(
    Canvas canvas,
    Offset c,
    double r,
    TokenShadows light,
    List<Offset> towers,
  ) {
    final foot = c.translate(0, r * 0.8);
    void cast(Offset dir, double len, double alpha) {
      if (alpha < 0.01) return;
      final tip = foot + dir * (r * len);
      final mid = Offset.lerp(foot, tip, 0.5)!;
      canvas
        ..save()
        ..translate(mid.dx, mid.dy)
        ..rotate(math.atan2(dir.dy, dir.dx))
        ..drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: r * (len + 1.0),
            height: r * 0.85,
          ),
          Paint()
            ..color = Colors.black.withValues(alpha: alpha)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.3),
        )
        ..restore();
    }

    cast(light.sunDirection, light.sunLength, light.sunAlpha);
    for (final t in towers) {
      final d = foot - t;
      if (d.distance < 1) continue;
      cast(d / d.distance, light.towerLength, light.towerAlpha);
    }
  }

  /// The shirt at [c], facing the screen direction [facing] (radians, 0 =
  /// to the right), in [fill] with [trim] at the collar and cuffs.
  static void paintShirt(
    Canvas canvas,
    Offset c,
    double r, {
    required Color fill,
    required Color trim,
    required int number,
    required double facing,
  }) {
    final shirt = _scaled(_shirt, c, r);
    canvas
      ..drawPath(
        shirt,
        Paint()
          ..shader = ui.Gradient.linear(
            c.translate(0, -r),
            c.translate(0, r),
            [KitColors.shade(fill, 0.05), KitColors.shade(fill, -0.12)],
          ),
      )
      // Collar and cuffs in the trim colour.
      ..drawPath(
        _scaled(
          Path()
            ..moveTo(-0.3, -0.95)
            ..quadraticBezierTo(0, -0.72, 0.3, -0.95),
          c,
          r,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, r * 0.16)
          ..color = trim,
      );
    for (final s in [-1.0, 1.0]) {
      canvas.drawLine(
        c.translate(s * r * 1.0, -r * 0.5),
        c.translate(s * r * 0.8, -r * 0.2),
        Paint()
          ..strokeWidth = math.max(1.0, r * 0.16)
          ..color = trim,
      );
    }
    canvas.drawPath(
      shirt,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.7, r * 0.08)
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
    );
    final on = fill.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final tp = TextPainter(
      text: TextSpan(
        text: '$number',
        style: AppTypography.titleMedium.copyWith(
          fontSize: r * 1.0,
          height: 1,
          fontWeight: FontWeight.w800,
          color: on,
          letterSpacing: -0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2 - r * 0.14));
    _chevron(canvas, c, r, facing);
  }

  /// A small chevron just off the shirt on the side the player faces.
  static void _chevron(Canvas canvas, Offset c, double r, double facing) {
    final d = Offset(math.cos(facing), math.sin(facing));
    final n = Offset(-d.dy, d.dx);
    final tip = c + d * (r * 1.5);
    final back = c + d * (r * 1.24);
    final path = Path()
      ..moveTo(back.dx + n.dx * r * 0.26, back.dy + n.dy * r * 0.26)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(back.dx - n.dx * r * 0.26, back.dy - n.dy * r * 0.26);
    canvas
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.6, r * 0.24)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.surfaceContainerLowest.withValues(alpha: 0.55),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, r * 0.13)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.primaryFixed,
      );
  }

  /// The player's name in a slim label under the token: no plate, a soft
  /// dark halo so it reads on lit and unlit grass alike.
  static void paintName(
    Canvas canvas,
    Offset c,
    double r,
    String name, {
    required double fontSize,
    Color? accent,
  }) {
    final style = AppTypography.labelSmall.copyWith(
      fontSize: fontSize,
      height: 1,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
      shadows: [
        Shadow(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
          blurRadius: 2.5,
        ),
        Shadow(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
          offset: const Offset(0, 0.8),
          blurRadius: 0.8,
        ),
      ],
    );
    final tp = TextPainter(
      text: TextSpan(text: name, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final top = c.dy + r * 1.05 + 2;
    tp.paint(canvas, Offset(c.dx - tp.width / 2, top));
    if (accent != null) {
      // A hairline in the kit colour under the name.
      final y = top + tp.height + 1.2;
      canvas.drawLine(
        Offset(c.dx - tp.width * 0.22, y),
        Offset(c.dx + tp.width * 0.22, y),
        Paint()
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..color = accent,
      );
    }
  }
}
