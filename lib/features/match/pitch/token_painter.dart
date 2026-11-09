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
    bool chevron = true,
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
      _watchFonts();
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
    if (chevron) _chevron(canvas, c, r, facing);
  }

  static const double _numberRef = 24;
  static final Map<int, TextPainter> _numbers = {};

  static bool _watching = false;

  /// Cached text is laid out in the fonts loaded at the time: when the
  /// system's fonts change, it is thrown away and laid out again.
  static void _watchFonts() {
    if (_watching) return;
    _watching = true;
    PaintingBinding.instance.systemFonts.addListener(clearTextCache);
  }

  /// Disposes every cached number and name.
  static void clearTextCache() {
    for (final tp in _numbers.values) {
      tp.dispose();
    }
    _numbers.clear();
    for (final tp in _names.values) {
      tp.dispose();
    }
    _names.clear();
  }

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
  static TextPainter namePainter(String name, double fontSize) {
    _watchFonts();
    final key = (name, fontSize);
    final had = _names[key];
    if (had != null) return had;
    if (_names.length > 256) {
      for (final tp in _names.values) {
        tp.dispose();
      }
      _names.clear();
    }
    return _names[key] = TextPainter(
      text: TextSpan(text: name, style: _nameStyle(fontSize)),
      textDirection: TextDirection.ltr,
    )..layout();
  }

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
  /// The label always sits against its own token: under it, else above it,
  /// else either of those a short step to the side, clear of every other
  /// token ([others], centre and half-width, each at its full [box]; or
  /// their exact boxes as [avoid]). In a crowd with no clear place it goes
  /// straight above the token, over whoever is there, with a short leader
  /// tick down to the shirt, so it never reads as somebody else's. Returns
  /// where the label went.
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
    List<Rect> labels = const [],
    List<Rect> hard = const [],
    int? prefer,
    void Function(int choice)? chose,
  }) {
    final tp = namePainter(name, fontSize);
    final size = Size(tp.width, tp.height + 2.4);
    final place = labelPlace(
      c,
      r,
      size,
      avoid ??
          [
            for (final (oc, orr) in others)
              if ((oc - c).distance >= 0.01) box(oc, orr),
          ],
      own: own,
      bounds: bounds,
      labels: labels,
      hard: hard,
      prefer: prefer,
    );
    chose?.call(place.choice);
    final box_ = place.rect;
    if (place.crowded) {
      // The leader tick: from the label down to the top of his shirt.
      final me = own ?? box(c, r, math.pi / 2 * 3);
      canvas.drawLine(
        Offset(c.dx, box_.bottom - 0.6),
        Offset(c.dx, math.max(me.top, box_.bottom + 1.5)),
        Paint()
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..color = accent ?? AppColors.onSurface,
      );
    }
    tp.paint(canvas, box_.topLeft);
    if (accent != null && !place.crowded) {
      // A hairline in the kit colour under the name.
      final y = box_.top + tp.height + 1.2;
      canvas.drawLine(
        Offset(box_.center.dx - tp.width * 0.22, y),
        Offset(box_.center.dx + tp.width * 0.22, y),
        Paint()
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round
          ..color = accent,
      );
    }
    return box_;
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

  /// The places tried for a label of [size] for the token at [c] (whose
  /// own box is [own]), best first: under it, above it, then each a short
  /// step to either side. All of them touch his token's box, within one
  /// token's height of it.
  static List<Rect> labelCandidates(
    Offset c,
    double r,
    Size size, {
    Rect? own,
  }) {
    final me = own ?? box(c, r, math.pi / 2 * 3);
    final below = me.bottom + 1.5;
    final above = me.top - 1.5 - size.height;
    // Sideways never further than keeps the label over his shirt.
    final step = math.min(0.35 * size.width, size.width / 2 + r * 0.2);
    return [
      for (final dx in [0.0, step, -step])
        for (final top in [below, above])
          Rect.fromLTWH(
            c.dx - size.width / 2 + dx,
            top,
            size.width,
            size.height,
          ),
    ];
  }

  /// The label's place among [avoid]: the first of [labelCandidates] clear
  /// of all of them (and of the [labels] already drawn), else straight
  /// above the token, [crowded], over whoever is there but never over a
  /// keeper, the ball or another name in [hard] or [labels]: it rises
  /// above the stack instead, a leader tick down to his shirt. With
  /// [bounds] (the frame), a place is slid to lie inside it.
  ///
  /// [prefer] is the place it took last frame ([choice] of the result, -1
  /// for crowded): it is kept while it stays clear, and any other must
  /// clear by a margin to take over, so a label does not hop between two
  /// places from frame to frame.
  static ({Rect rect, bool crowded, int choice}) labelPlace(
    Offset c,
    double r,
    Size size,
    List<Rect> avoid, {
    Rect? own,
    Rect? bounds,
    List<Rect> labels = const [],
    List<Rect> hard = const [],
    int? prefer,
  }) {
    Rect inside(Rect p) {
      if (bounds == null) return p;
      var dx = 0.0;
      if (p.left < bounds.left + 2) dx = bounds.left + 2 - p.left;
      if (p.right > bounds.right - 2) dx = bounds.right - 2 - p.right;
      var dy = 0.0;
      if (p.top < bounds.top) dy = bounds.top - p.top;
      if (p.bottom > bounds.bottom) dy = bounds.bottom - p.bottom;
      return p.translate(dx, dy);
    }

    final places = [
      for (final p in labelCandidates(c, r, size, own: own)) inside(p),
    ];
    bool clear(Rect place, double margin) {
      final grown = place.inflate(margin);
      return avoid.every((b) => !b.overlaps(grown)) &&
          labels.every((b) => !b.overlaps(grown)) &&
          hard.every((b) => !b.overlaps(grown));
    }

    if (prefer != null && prefer >= 0 && prefer < places.length) {
      if (clear(places[prefer], 0)) {
        return (rect: places[prefer], crowded: false, choice: prefer);
      }
    }
    // A new place has to be clear with room to spare when the label had
    // one already (or was crowded), so it does not flick back and forth.
    final margin = prefer == null ? 0.0 : 2.0;
    for (var i = 0; i < places.length; i++) {
      if (clear(places[i], margin)) {
        return (rect: places[i], crowded: false, choice: i);
      }
    }
    final me = own ?? box(c, r, math.pi / 2 * 3);
    var over = inside(
      Rect.fromLTWH(
        c.dx - size.width / 2,
        me.top - 3 - size.height,
        size.width,
        size.height,
      ),
    );
    // Over a keeper, the ball or another name: up above the stack.
    bool blocked(Rect p) =>
        labels.any((b) => b.overlaps(p)) || hard.any((b) => b.overlaps(p));
    for (var k = 0; k < 4 && blocked(over); k++) {
      over = inside(over.translate(0, -(size.height + 1)));
    }
    return (rect: over, crowded: true, choice: -1);
  }

  /// [labelPlace]'s rectangle.
  static Rect labelRectAvoiding(
    Offset c,
    double r,
    Size size,
    List<Rect> avoid, {
    Rect? own,
    Rect? bounds,
  }) => labelPlace(c, r, size, avoid, own: own, bounds: bounds).rect;
}
