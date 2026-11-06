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
    bool cachedNumber = false,
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
    if (cachedNumber) {
      // Laid out once per number and ink at a reference size, then scaled
      // to the token: no text layout in a live frame.
      final tp = _numbers.putIfAbsent(
        number * 2 + (on == Colors.black ? 1 : 0),
        () => _numberPainter(number, on, _numberRef),
      );
      final k = r / _numberRef;
      canvas
        ..save()
        ..translate(c.dx, c.dy + r * 0.14)
        ..scale(k)
        ..translate(-tp.width / 2, -tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      final tp = _numberPainter(number, on, r);
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2 - r * 0.14));
    }
    _chevron(canvas, c, r, facing);
  }

  static const double _numberRef = 24;
  static final Map<int, TextPainter> _numbers = {};

  static TextPainter _numberPainter(int number, Color on, double size) =>
      TextPainter(
        text: TextSpan(
          text: '$number',
          style: AppTypography.titleMedium.copyWith(
            fontSize: size,
            height: 1,
            fontWeight: FontWeight.w800,
            color: on,
            letterSpacing: -0.3 * size / 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

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

  /// The screen box a token at [c] covers: the shirt, its outline and the
  /// chevron on the side it faces ([facing], screen radians). With no
  /// [facing] the chevron may point anywhere, so the box allows for it all
  /// round.
  static Rect box(Offset c, double r, [double? facing]) {
    final shirt = Rect.fromLTRB(
      c.dx - r * 1.04,
      c.dy - r * 0.99,
      c.dx + r * 1.04,
      c.dy + r * 1.02,
    );
    const reach = 1.5 + 0.13;
    if (facing == null) {
      return Rect.fromCenter(
        center: c,
        width: r * reach * 2,
        height: r * reach * 2,
      );
    }
    final d = Offset(math.cos(facing), math.sin(facing));
    final tip = c + d * (r * reach);
    final wing = Offset(-d.dy, d.dx) * (r * 0.4);
    final back = c + d * (r * 1.2);
    return shirt
        .expandToInclude(Rect.fromPoints(tip, tip))
        .expandToInclude(Rect.fromPoints(back + wing, back - wing));
  }

  /// A name label's text painter, cached by name and size.
  static TextPainter namePainter(String name, double fontSize) =>
      _names.putIfAbsent((name, fontSize), () {
        if (_names.length > 256) _names.clear();
        return TextPainter(
          text: TextSpan(text: name, style: _nameStyle(fontSize)),
          textDirection: TextDirection.ltr,
        )..layout();
      });

  static final Map<(String, double), TextPainter> _names = {};

  static TextStyle _nameStyle(double fontSize) =>
      AppTypography.labelSmall.copyWith(
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

  /// The player's name in a slim label under the token: no plate, a soft
  /// dark halo so it reads on lit and unlit grass alike.
  ///
  /// The label never lies on another player: [others] are the other tokens
  /// (centre and half-width), each taken at its full box ([box]) with the
  /// chevron allowed for all round; or pass their exact boxes as [avoid].
  /// Under the token is tried first, then above it, then each a step to
  /// either side; see [labelRect]. Returns where the label went.
  static Rect paintName(
    Canvas canvas,
    Offset c,
    double r,
    String name, {
    required double fontSize,
    Color? accent,
    List<(Offset, double)> others = const [],
    List<Rect>? avoid,
    Rect? own,
    Rect? bounds,
  }) {
    final tp = namePainter(name, fontSize);
    final size = Size(tp.width, tp.height + 2.4);
    final box = avoid != null
        ? labelRectAvoiding(c, r, size, avoid, own: own, bounds: bounds)
        : labelRect(c, r, size, others);
    tp.paint(canvas, box.topLeft);
    if (accent != null) {
      // A hairline in the kit colour under the name.
      final y = box.top + tp.height + 1.2;
      canvas.drawLine(
        Offset(box.center.dx - tp.width * 0.22, y),
        Offset(box.center.dx + tp.width * 0.22, y),
        Paint()
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..color = accent,
      );
    }
    return box;
  }

  /// Where a label of [size] for the token at [c] goes so that it covers
  /// none of [others] (centre and half-width, each at its full [box]).
  static Rect labelRect(
    Offset c,
    double r,
    Size size,
    List<(Offset, double)> others,
  ) => labelRectAvoiding(c, r, size, [
    for (final (oc, orr) in others)
      if ((oc - c).distance >= 0.01) box(oc, orr),
  ]);

  /// The places tried for a label of [size] under the token at [c] (whose
  /// own box is [own]), best first: under it, above it, then a step to
  /// either side of each, then a row further out.
  static List<Rect> labelCandidates(
    Offset c,
    double r,
    Size size, {
    Rect? own,
  }) {
    final me = own ?? box(c, r, math.pi / 2 * 3);
    final below = me.bottom + 1.5;
    final above = me.top - 1.5 - size.height;
    return [
      for (final row in [0.0, 1.0])
        for (final dx in [0.0, 0.35, -0.35, 0.7, -0.7, 1.0, -1.0])
          for (final top in [
            below + row * (size.height + 2),
            above - row * (size.height + 2),
          ])
            Rect.fromLTWH(
              c.dx - size.width / 2 + dx * size.width,
              top,
              size.width,
              size.height,
            ),
    ];
  }

  /// [labelRect] against exact boxes: the first of [labelCandidates] that
  /// touches none of [avoid], or, when every place is taken, the one that
  /// covers least of them. With [bounds] (the frame), a place is slid
  /// sideways to lie inside it, and one that cannot is tried last.
  static Rect labelRectAvoiding(
    Offset c,
    double r,
    Size size,
    List<Rect> avoid, {
    Rect? own,
    Rect? bounds,
  }) {
    var places = labelCandidates(c, r, size, own: own);
    if (bounds != null) {
      Rect inside(Rect p) {
        var dx = 0.0;
        if (p.left < bounds.left + 2) dx = bounds.left + 2 - p.left;
        if (p.right > bounds.right - 2) dx = bounds.right - 2 - p.right;
        return p.translate(dx, 0);
      }

      bool fits(Rect p) => p.top >= bounds.top && p.bottom <= bounds.bottom;
      final slid = places.map(inside).toList();
      places = [...slid.where(fits), ...slid.where((p) => !fits(p))];
    }
    Rect? best;
    var least = double.infinity;
    for (final place in places) {
      var covered = 0.0;
      for (final b in avoid) {
        if (!b.overlaps(place)) continue;
        final i = b.intersect(place);
        covered += math.max(i.width, 0) * math.max(i.height, 0) + 1;
      }
      if (covered == 0) return place;
      if (covered < least) {
        least = covered;
        best = place;
      }
    }
    return best!;
  }
}
