import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';

/// The sky and the land behind the far stand: the ground's [terrain], its
/// city's [landmark] standing on it, in the [look] of the moment.
///
/// Drawn first; the stands are drawn over its lower part. Everything is a
/// seeded function of [seed], so a ground's skyline never changes.
class BackdropPainter {
  BackdropPainter({
    required this.terrain,
    required this.landmark,
    required this.look,
    required this.seed,
  });

  final Terrain terrain;
  final LandmarkKind landmark;
  final SceneLook look;
  final String seed;

  /// The warm light of a lit window.
  static const Color _window = Color(0xFFF1C877);

  /// Paints the backdrop over [size], the land standing on [horizon] (a y
  /// in pixels) and filled down to the bottom, for the stands to cover.
  void paint(Canvas canvas, Size size, double horizon) {
    final room = horizon.clamp(1.0, size.height);
    _sky(canvas, size, horizon);
    _celestial(canvas, size, horizon);
    switch (terrain) {
      case Terrain.mountains:
        _mountains(canvas, size, horizon, room);
      case Terrain.sea:
        _sea(canvas, size, horizon, room);
      case Terrain.desert:
        _dunes(canvas, size, horizon, room);
      case Terrain.hills:
        _hills(canvas, size, horizon, room);
      case Terrain.city:
        _city(
          canvas,
          size,
          horizon,
          room,
          landmarkGap: landmark != LandmarkKind.none,
        );
    }
    if (landmark != LandmarkKind.none) _landmark(canvas, size, horizon, room);
  }

  math.Random _rng(String salt) => math.Random(varietySeed('$seed:$salt'));

  void _sky(Canvas canvas, Size size, double horizon) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, math.max(horizon, 1)),
          [look.skyTop, look.skyMid, look.skyHorizon],
          const [0, 0.55, 1],
        ),
    );
  }

  void _celestial(Canvas canvas, Size size, double horizon) {
    if (look.stars > 0.05) {
      final r = _rng('stars');
      final p = Paint();
      for (var i = 0; i < 70; i++) {
        final o = Offset(
          r.nextDouble() * size.width,
          r.nextDouble() * horizon * 0.85,
        );
        p.color = Colors.white.withValues(
          alpha: (0.25 + r.nextDouble() * 0.45) * look.stars,
        );
        canvas.drawCircle(o, 0.35 + r.nextDouble() * 0.45, p);
      }
      // A quiet moon, high on the left.
      final moon = Offset(size.width * 0.14, horizon * 0.3);
      final mr = math.max(2.5, horizon * 0.06);
      canvas
        ..drawCircle(
          moon,
          mr * 3,
          Paint()
            ..color = const Color(
              0xFFCAD3DC,
            ).withValues(alpha: 0.08 * look.stars)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, mr * 1.5),
        )
        ..drawCircle(
          moon,
          mr,
          Paint()
            ..color = const Color(
              0xFFD9DEE3,
            ).withValues(alpha: 0.85 * look.stars),
        );
    }
    if (look.sunGlow > 0.05) {
      // A low sun, sinking on the right, its glow along the horizon.
      final sun = Offset(size.width * 0.8, horizon * 0.96);
      final sr = math.max(4.0, horizon * 0.12);
      canvas
        ..drawCircle(
          sun,
          sr * 5,
          Paint()
            ..color = const Color(
              0xFFF0A060,
            ).withValues(alpha: 0.22 * look.sunGlow)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, sr * 3),
        )
        ..drawCircle(
          sun,
          sr,
          Paint()
            ..color = const Color(
              0xFFF6C08A,
            ).withValues(alpha: 0.9 * look.sunGlow),
        );
    }
  }

  /// A ridge line from seeded noise: [n] points across the width, heights
  /// between [lo] and [hi] (fractions of [room]) above [horizon].
  Path _ridge(
    Size size,
    double horizon,
    double room, {
    required String salt,
    required int n,
    required double lo,
    required double hi,
    bool smooth = false,
  }) {
    final r = _rng(salt);
    final pts = [
      for (var i = 0; i <= n; i++)
        Offset(
          size.width * (i / n) +
              (i == 0 || i == n
                  ? 0
                  : (r.nextDouble() - 0.5) * size.width / n * 0.6),
          horizon - room * (lo + (hi - lo) * r.nextDouble()),
        ),
    ];
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      if (smooth) {
        final a = pts[i - 1], b = pts[i];
        final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
        path.quadraticBezierTo(a.dx, a.dy, mid.dx, mid.dy);
        if (i == pts.length - 1) path.lineTo(b.dx, b.dy);
      } else {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
    }
    return path
      ..lineTo(size.width, size.height)
      ..close();
  }

  void _layer(Canvas canvas, Path p, Color c, double horizon, double room) {
    canvas.drawPath(
      p,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, horizon - room),
          Offset(0, horizon),
          [c, Color.lerp(c, look.skyHorizon, 0.18)!],
        ),
    );
  }

  void _mountains(Canvas canvas, Size size, double horizon, double room) {
    final r = _rng('peaks');
    // The far range: tall, sharp, snow on the tops.
    final peaks = <Offset>[];
    const n = 9;
    final far = Path()..moveTo(0, size.height);
    for (var i = 0; i <= n * 2; i++) {
      final x = size.width * i / (n * 2);
      final top = i.isOdd;
      final h = top ? 0.55 + r.nextDouble() * 0.4 : 0.25 + r.nextDouble() * 0.2;
      final o = Offset(
        x + (r.nextDouble() - 0.5) * size.width / n * 0.4,
        horizon - room * h,
      );
      if (top) peaks.add(o);
      far.lineTo(o.dx, o.dy);
    }
    far
      ..lineTo(size.width, size.height)
      ..close();
    _layer(canvas, far, look.far, horizon, room);
    // Snow: a small cap under each high peak.
    final snow = Paint()..color = look.snow.withValues(alpha: 0.75);
    for (final p in peaks) {
      final h = horizon - p.dy;
      if (h < room * 0.68) continue;
      final cap = h * 0.16;
      canvas.drawPath(
        Path()
          ..moveTo(p.dx, p.dy)
          ..lineTo(p.dx - cap * 0.75, p.dy + cap)
          ..lineTo(p.dx - cap * 0.25, p.dy + cap * 0.75)
          ..lineTo(p.dx + cap * 0.1, p.dy + cap * 1.05)
          ..lineTo(p.dx + cap * 0.8, p.dy + cap)
          ..close(),
        snow,
      );
    }
    _layer(
      canvas,
      _ridge(size, horizon, room, salt: 'foothills', n: 7, lo: 0.12, hi: 0.32),
      look.near,
      horizon,
      room,
    );
  }

  void _sea(Canvas canvas, Size size, double horizon, double room) {
    final sea = horizon - room * 0.12;
    // A headland on the left, then open water to the right.
    final head = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, sea - room * 0.38)
      ..quadraticBezierTo(
        size.width * 0.12,
        sea - room * 0.48,
        size.width * 0.22,
        sea - room * 0.22,
      )
      ..quadraticBezierTo(
        size.width * 0.3,
        sea - room * 0.05,
        size.width * 0.36,
        sea,
      )
      ..lineTo(size.width * 0.36, size.height)
      ..close();
    canvas.drawRect(
      Rect.fromLTRB(0, sea, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, sea),
          Offset(0, horizon + room * 0.2),
          [Color.lerp(look.water, look.skyHorizon, 0.35)!, look.water],
        ),
    );
    // Light on the water: short strokes, warm at dusk.
    final r = _rng('waves');
    final glint = Paint()
      ..strokeWidth = 0.6
      ..color = Color.lerp(
        look.skyHorizon,
        Colors.white,
        0.3,
      )!.withValues(alpha: 0.35);
    for (var i = 0; i < 40; i++) {
      final y = sea + 1.5 + r.nextDouble() * (horizon - sea + room * 0.1);
      final x = size.width * (0.3 + r.nextDouble() * 0.7);
      final w = 2 + r.nextDouble() * size.width * 0.03;
      canvas.drawLine(Offset(x, y), Offset(x + w, y), glint);
    }
    _layer(canvas, head, look.near, horizon, room);
    // A lighthouse on the headland, lit at night.
    final lx = size.width * 0.17, ly = sea - room * 0.4;
    final lh = room * 0.22;
    canvas.drawRect(
      Rect.fromLTWH(lx - lh * 0.08, ly - lh, lh * 0.16, lh),
      Paint()..color = look.landmark,
    );
    if (look.flood > 0.2) {
      canvas.drawCircle(
        Offset(lx, ly - lh),
        lh * 0.5,
        Paint()
          ..color = _window.withValues(alpha: 0.35 * look.flood)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, lh * 0.3),
      );
    }
  }

  void _dunes(Canvas canvas, Size size, double horizon, double room) {
    _layer(
      canvas,
      _ridge(
        size,
        horizon,
        room,
        salt: 'dunes-far',
        n: 5,
        lo: 0.2,
        hi: 0.42,
        smooth: true,
      ),
      Color.lerp(look.sand, look.skyHorizon, 0.3)!,
      horizon,
      room,
    );
    _layer(
      canvas,
      _ridge(
        size,
        horizon,
        room,
        salt: 'dunes',
        n: 4,
        lo: 0.08,
        hi: 0.24,
        smooth: true,
      ),
      look.sand,
      horizon,
      room,
    );
  }

  void _hills(Canvas canvas, Size size, double horizon, double room) {
    _layer(
      canvas,
      _ridge(
        size,
        horizon,
        room,
        salt: 'hills-far',
        n: 5,
        lo: 0.25,
        hi: 0.5,
        smooth: true,
      ),
      look.far,
      horizon,
      room,
    );
    final near = _ridge(
      size,
      horizon,
      room,
      salt: 'hills',
      n: 6,
      lo: 0.1,
      hi: 0.26,
      smooth: true,
    );
    _layer(canvas, near, look.near, horizon, room);
    // A few trees and roofs along the near ridge, lit windows at night.
    final r = _rng('trees');
    final p = Paint()..color = look.near;
    for (var i = 0; i < 26; i++) {
      final x = r.nextDouble() * size.width;
      final y = horizon - room * (0.08 + r.nextDouble() * 0.1);
      final s = room * (0.03 + r.nextDouble() * 0.04);
      canvas.drawCircle(Offset(x, y), s, p);
      if (look.flood > 0.3 && r.nextDouble() < 0.25) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y + s * 0.4),
            width: 1.2,
            height: 1.2,
          ),
          Paint()..color = _window.withValues(alpha: 0.7 * look.flood),
        );
      }
    }
  }

  void _city(
    Canvas canvas,
    Size size,
    double horizon,
    double room, {
    bool landmarkGap = false,
  }) {
    final r = _rng('city');
    // The far blocks, pale with distance, then a nearer row.
    // Kept low under a landmark, so the landmark stands clear of it.
    final k = landmarkGap ? 0.55 : 1.0;
    for (final (layer, colour, lo, hi) in [
      (0, Color.lerp(look.far, look.skyHorizon, 0.25)!, 0.18 * k, 0.5 * k),
      (1, look.near, 0.08 * k, 0.32 * k),
    ]) {
      var x = -r.nextDouble() * 10;
      while (x < size.width) {
        final w = size.width * (0.025 + r.nextDouble() * 0.04);
        final h = room * (lo + (hi - lo) * math.pow(r.nextDouble(), 1.6));
        final rect = Rect.fromLTRB(x, horizon - h, x + w - 0.6, size.height);
        canvas.drawRect(rect, Paint()..color = colour);
        if (layer == 1) _windows(canvas, rect, horizon, r);
        x += w + (r.nextDouble() < 0.2 ? w * 0.6 : 0);
      }
    }
    if (look.flood > 0.2) {
      // The city's glow on the haze above it.
      canvas.drawRect(
        Rect.fromLTRB(0, horizon - room * 0.6, size.width, horizon),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, horizon - room * 0.6),
            Offset(0, horizon),
            [
              _window.withValues(alpha: 0),
              _window.withValues(alpha: 0.07 * look.flood),
            ],
          ),
      );
    }
  }

  void _windows(Canvas canvas, Rect rect, double horizon, math.Random r) {
    if (look.flood < 0.2) return;
    final p = Paint();
    final step = math.max(2.2, rect.width / 4);
    for (var y = rect.top + 2; y < horizon - 1; y += step) {
      for (var x = rect.left + 1.2; x < rect.right - 1.2; x += step) {
        if (r.nextDouble() > 0.35) continue;
        p.color = _window.withValues(
          alpha: (0.4 + r.nextDouble() * 0.5) * look.flood,
        );
        canvas.drawRect(Rect.fromLTWH(x, y, 0.9, 0.9), p);
      }
    }
  }

  void _landmark(Canvas canvas, Size size, double horizon, double room) {
    final path = LandmarkPaths.of(landmark);
    final b = path.getBounds();
    if (b.isEmpty) return;
    // As tall as the room allows, never wider than two fifths of the frame.
    var h = room * 0.9;
    if (b.width * h > size.width * 0.4) h = size.width * 0.4 / b.width;
    final r = _rng('landmark-x');
    // Centred between the roof's middle flag poles, nudged per city.
    final cx = size.width * (0.47 + r.nextDouble() * 0.06);
    final shape = path.transform(
      Float64List.fromList([
        h, 0, 0, 0, //
        0, h, 0, 0,
        0, 0, 1, 0,
        cx, horizon + room * 0.04, 0, 1,
      ]),
    );
    // A soft rim of sky light behind it so it reads against the land.
    canvas.drawPath(
      shape,
      Paint()
        ..color = look.skyHorizon.withValues(alpha: 0.25)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, math.max(1, h * 0.02)),
    );
    canvas
      ..drawPath(shape, Paint()..color = look.landmark)
      // Its edge catches the sky.
      ..drawPath(
        shape,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = Color.lerp(
            look.skyHorizon,
            Colors.white,
            0.15,
          )!.withValues(alpha: 0.55),
      );
    if (look.flood > 0.2) {
      if (LandmarkPaths.hasWindows(landmark)) {
        canvas
          ..save()
          ..clipPath(shape);
        _windows(canvas, shape.getBounds(), horizon, _rng('lm-windows'));
        canvas.restore();
      } else {
        // Floodlit from below: a warm wash up the silhouette.
        final sb = shape.getBounds();
        canvas.drawPath(
          shape,
          Paint()
            ..shader = ui.Gradient.linear(
              sb.bottomCenter,
              sb.topCenter,
              [
                _window.withValues(alpha: 0.45 * look.flood),
                _window.withValues(alpha: 0.1 * look.flood),
              ],
            ),
        );
      }
    }
  }
}
