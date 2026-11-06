import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';

/// The sky and the land behind the far stand: the ground's [terrain] in
/// layers that fade into the haze with distance, its city's [landmark]
/// standing tall in front of them, all in the [look] of the moment.
///
/// Drawn first; the stands are drawn over its lower part, so everything is
/// carried down below the roof line and the sky above the stands is never
/// bare. Everything is a seeded function of [seed], so a ground's skyline
/// never changes.
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

  /// The warm light of a lit window, and of a city's glow on the haze.
  static const Color _window = Color(0xFFF1C877);

  /// Distance haze of the far, middle and near layers.
  static const double _hazeFar = 0.55, _hazeMid = 0.3, _hazeNear = 0.1;

  double get _night => look.flood;
  double get _day => 1 - look.flood;

  /// Paints the backdrop over [size], the land standing on [horizon] (a y in
  /// pixels: the roof line) and carried down to the bottom of the frame for
  /// the stands to cover.
  void paint(Canvas canvas, Size size, double horizon) {
    final room = math.max(horizon, 8.0);
    _sky(canvas, size, horizon);
    _celestial(canvas, size, room);
    switch (terrain) {
      case Terrain.mountains:
        _mountains(canvas, size, horizon, room);
      case Terrain.sea:
        _sea(canvas, size, horizon, room);
      case Terrain.desert:
        _desert(canvas, size, horizon, room);
      case Terrain.hills:
        _hills(canvas, size, horizon, room);
      case Terrain.city:
        _city(canvas, size, horizon, room);
    }
    if (landmark != LandmarkKind.none) _landmark(canvas, size, horizon, room);
    if (terrain == Terrain.city || landmark != LandmarkKind.none) {
      _cityNear(canvas, size, horizon, room);
    }
    _cityGlow(canvas, size, horizon, room);
    // Below the roof line is the land round the stadium, seen from above:
    // what shows of it past the end stands is roofs and streets, never sky.
    if (terrain != Terrain.sea) _outskirts(canvas, size, horizon, room);
  }

  /// The town round the ground, looked down on: rows of roofs, smaller and
  /// hazier toward the roof line, street lights at night.
  void _outskirts(Canvas canvas, Size size, double horizon, double room) {
    final top = horizon + room * 0.1;
    canvas.drawRect(
      Rect.fromLTRB(0, top, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(Offset(0, top), Offset(0, size.height), [
          _hazed(look.near, 0.2),
          Color.lerp(look.near, Colors.black, 0.25)!,
        ]),
    );
    final r = _rng('outskirts');
    var y = top + 1.5;
    while (y < size.height) {
      final depth = ((y - top) / room).clamp(0.0, 3.0);
      final s = 1.6 + depth * 2.2;
      final haze = (0.3 - depth * 0.12).clamp(0.0, 0.3);
      var x = -r.nextDouble() * s * 2;
      while (x < size.width) {
        final w = s * (1.0 + r.nextDouble() * 2.2);
        if (r.nextDouble() < 0.82) {
          final shade = r.nextDouble();
          final roof = Color.lerp(
            Color.lerp(look.near, look.far, 0.6 * shade)!,
            const Color(0xFF5A4A40),
            0.25 * _day * r.nextDouble(),
          )!;
          canvas.drawRect(
            Rect.fromLTWH(x, y, w - s * 0.3, s * 0.62),
            Paint()..color = _hazed(roof, haze),
          );
        }
        if (_night > 0.2 && r.nextDouble() < 0.35) {
          canvas.drawCircle(
            Offset(x + w * r.nextDouble(), y + s * 0.75),
            0.45 + depth * 0.2,
            Paint()
              ..color = _window.withValues(
                alpha: (0.45 + r.nextDouble() * 0.45) * _night,
              ),
          );
        }
        x += w;
      }
      y += s * 0.95;
    }
  }

  math.Random _rng(String salt) => math.Random(varietySeed('$seed:$salt'));

  Color _hazed(Color c, double haze) => Color.lerp(c, look.skyHorizon, haze)!;

  /// A layer of land: [path] in [colour] faded by [haze], and fogged a
  /// little more toward its foot.
  void _layer(
    Canvas canvas,
    Path path,
    Color colour,
    double haze,
    double top,
    double foot,
  ) {
    final c = _hazed(colour, haze);
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(Offset(0, top), Offset(0, foot), [
          c,
          _hazed(c, 0.22 + haze * 0.2),
        ]),
    );
  }

  // --- Sky ---------------------------------------------------------------------

  void _sky(Canvas canvas, Size size, double horizon) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, math.max(horizon, 1)),
          [look.skyTop, look.skyMid, look.skyHorizon],
          const [0, 0.5, 1],
        ),
    );
  }

  void _celestial(Canvas canvas, Size size, double room) {
    if (look.stars > 0.05) {
      final r = _rng('stars');
      final p = Paint();
      for (var i = 0; i < 90; i++) {
        final o = Offset(
          r.nextDouble() * size.width,
          r.nextDouble() * room * 0.7,
        );
        p.color = Colors.white.withValues(
          alpha: (0.2 + r.nextDouble() * 0.5) * look.stars,
        );
        canvas.drawCircle(o, 0.3 + r.nextDouble() * 0.45, p);
      }
      final moon = Offset(size.width * 0.12, room * 0.28);
      final mr = math.max(2.5, room * 0.05);
      canvas
        ..drawCircle(
          moon,
          mr * 4,
          Paint()
            ..color = const Color(
              0xFFCAD3DC,
            ).withValues(alpha: 0.07 * look.stars)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, mr * 2),
        )
        ..drawCircle(
          moon,
          mr,
          Paint()
            ..color = const Color(
              0xFFDDE2E7,
            ).withValues(alpha: 0.85 * look.stars),
        );
    }
    if (look.sunGlow > 0.05) {
      final sun = Offset(size.width * 0.82, room * 0.72);
      final sr = math.max(4.0, room * 0.09);
      canvas
        ..drawCircle(
          sun,
          sr * 7,
          Paint()
            ..color = const Color(
              0xFFF0A060,
            ).withValues(alpha: 0.2 * look.sunGlow)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, sr * 4),
        )
        ..drawCircle(
          sun,
          sr,
          Paint()
            ..color = const Color(
              0xFFF7C894,
            ).withValues(alpha: 0.85 * look.sunGlow),
        );
    }
  }

  // --- Ridges --------------------------------------------------------------------

  /// A ridge line across the width by midpoint displacement: [base] and
  /// [peak] are fractions of [room] above [horizon], [rough] how jagged.
  List<Offset> _ridgeLine(
    Size size,
    double horizon,
    double room, {
    required String salt,
    required double base,
    required double peak,
    double rough = 0.55,
    int depth = 6,
    int anchors = 2,
  }) {
    final r = _rng(salt);
    // Anchors alternate high and low, so a range has distinct peaks.
    var hs = [
      for (var i = 0; i < anchors; i++)
        anchors > 2
            ? (i.isOdd
                  ? peak - (peak - base) * 0.25 * r.nextDouble()
                  : base + (peak - base) * 0.35 * r.nextDouble())
            : base + (peak - base) * r.nextDouble(),
    ];
    var amp = (peak - base) * (anchors > 2 ? 0.35 : 0.9);
    for (var d = 0; d < depth; d++) {
      final next = <double>[];
      for (var i = 0; i + 1 < hs.length; i++) {
        next
          ..add(hs[i])
          ..add(
            ((hs[i] + hs[i + 1]) / 2 + (r.nextDouble() - 0.5) * amp).clamp(
              base * 0.6,
              peak,
            ),
          );
      }
      next.add(hs.last);
      hs = next;
      amp *= rough;
    }
    return [
      for (var i = 0; i < hs.length; i++)
        Offset(size.width * i / (hs.length - 1), horizon - room * hs[i]),
    ];
  }

  Path _fillBelow(List<Offset> line, Size size) {
    final p = Path()..moveTo(line.first.dx, size.height);
    for (final o in line) {
      p.lineTo(o.dx, o.dy);
    }
    return p
      ..lineTo(line.last.dx, size.height)
      ..close();
  }

  Path _smooth(List<Offset> pts, Size size) {
    final p = Path()
      ..moveTo(pts.first.dx, size.height)
      ..lineTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final a = pts[i - 1], b = pts[i];
      p.quadraticBezierTo(a.dx, a.dy, (a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    }
    return p
      ..lineTo(pts.last.dx, pts.last.dy)
      ..lineTo(pts.last.dx, size.height)
      ..close();
  }

  // --- Mountains ------------------------------------------------------------------

  void _mountains(Canvas canvas, Size size, double horizon, double room) {
    const rock = Color(0xFF6A6764);
    final rockTone = Color.lerp(look.far, rock, 0.45 * _day)!;
    // The far range: high, snow-capped, pale with distance.
    final far = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'range-far',
      base: 0.42,
      peak: 0.9,
      rough: 0.55,
      depth: 5,
      anchors: 9,
    );
    final farPath = _fillBelow(far, size);
    _layer(canvas, farPath, rockTone, 0.4, horizon - room, horizon);
    _snow(canvas, farPath, far, horizon, room, snowline: 0.74);
    _faces(canvas, far, horizon, 0.1);
    // The middle range: browner, nearer, a little snow on the very tops.
    final mid = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'range-mid',
      base: 0.26,
      peak: 0.6,
      rough: 0.5,
      depth: 5,
      anchors: 7,
    );
    final midPath = _fillBelow(mid, size);
    final brown = Color.lerp(look.near, const Color(0xFF5E5146), 0.5 * _day)!;
    _layer(canvas, midPath, brown, _hazeMid, horizon - room * 0.66, horizon);
    _snow(canvas, midPath, mid, horizon, room, snowline: 0.56, alpha: 0.45);
    _faces(canvas, mid, horizon, 0.1);
    // The near slopes, built up with the city climbing them.
    final near = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'slopes',
      base: 0.12,
      peak: 0.34,
      rough: 0.45,
      depth: 5,
    );
    final nearPath = _fillBelow(near, size);
    _layer(
      canvas,
      nearPath,
      look.near,
      _hazeNear,
      horizon - room * 0.34,
      horizon,
    );
    _sprawl(canvas, near, horizon, size);
  }

  /// Snow on a range: its part above the [snowline] (a fraction of the room
  /// above the horizon), with a ragged lower edge.
  void _snow(
    Canvas canvas,
    Path range,
    List<Offset> line,
    double horizon,
    double room, {
    required double snowline,
    double alpha = 0.85,
  }) {
    final r = _rng('snow$snowline');
    final edge = Path()..moveTo(0, 0);
    for (final o in line) {
      final y = horizon - room * (snowline + (r.nextDouble() - 0.5) * 0.08);
      // Snow reaches further down under a high peak.
      final reach = (horizon - room * snowline - o.dy).clamp(0.0, room * 0.2);
      edge.lineTo(o.dx, y + reach * 0.6);
    }
    edge
      ..lineTo(line.last.dx, 0)
      ..close();
    canvas
      ..save()
      ..clipPath(range)
      ..drawPath(
        edge,
        Paint()
          ..color = _hazed(look.snow, _hazeFar * 0.6).withValues(alpha: alpha),
      )
      ..restore();
  }

  /// Shade on the far side of each peak, so a range has faces, not just an
  /// outline.
  void _faces(Canvas canvas, List<Offset> line, double horizon, double alpha) {
    final p = Paint()
      ..color = Colors.black.withValues(alpha: alpha * (0.4 + 0.6 * _day));
    for (var i = 1; i + 1 < line.length; i++) {
      final a = line[i - 1], b = line[i], c = line[i + 1];
      if (b.dy > a.dy || b.dy > c.dy) continue;
      // A local peak: shade the slope down to the right.
      final foot = Offset(c.dx + (c.dx - b.dx) * 2, horizon);
      canvas.drawPath(
        Path()
          ..moveTo(b.dx, b.dy)
          ..lineTo(c.dx, c.dy)
          ..lineTo(foot.dx, foot.dy)
          ..lineTo(b.dx + (c.dx - b.dx) * 0.4, horizon)
          ..close(),
        p,
      );
    }
  }

  /// Houses scattered up the near slopes, lit at night.
  void _sprawl(Canvas canvas, List<Offset> line, double horizon, Size size) {
    final r = _rng('sprawl');
    final house = Paint()..color = _hazed(look.near, 0.18);
    for (var i = 0; i < 160; i++) {
      final x = r.nextDouble() * size.width;
      final k = (x / size.width * (line.length - 1)).floor().clamp(
        0,
        line.length - 2,
      );
      final top = line[k].dy;
      final y = top + (horizon - top) * (0.1 + r.nextDouble() * 0.9);
      final w = 1.0 + r.nextDouble() * 1.6;
      canvas.drawRect(Rect.fromLTWH(x, y, w, w * 0.7), house);
      if (_night > 0.2 && r.nextDouble() < 0.6) {
        canvas.drawCircle(
          Offset(x + w / 2, y + 0.3),
          0.5,
          Paint()
            ..color = _window.withValues(
              alpha: (0.5 + r.nextDouble() * 0.4) * _night,
            ),
        );
      }
    }
  }

  // --- Sea ------------------------------------------------------------------------

  void _sea(Canvas canvas, Size size, double horizon, double room) {
    final sea = horizon - room * 0.32;
    // A far coast, faint, on the right.
    final coast = _ridgeLine(
      size,
      sea,
      room,
      salt: 'coast',
      base: 0.04,
      peak: 0.14,
      rough: 0.5,
      depth: 5,
    );
    _layer(
      canvas,
      _smooth(coast, size),
      look.far,
      _hazeFar,
      sea - room * 0.14,
      sea,
    );
    // Open water down to the stands, lighter toward the horizon.
    canvas.drawRect(
      Rect.fromLTRB(0, sea, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(Offset(0, sea), Offset(0, horizon + 4), [
          _hazed(look.water, 0.45),
          look.water,
        ]),
    );
    // The sun's or the moon's path on the water, and small glints.
    final path = Offset(size.width * (look.sunGlow > 0.3 ? 0.82 : 0.12), sea);
    canvas.drawRect(
      Rect.fromLTRB(path.dx - room * 0.25, sea, path.dx + room * 0.25, horizon),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(path.dx - room * 0.25, 0),
          Offset(path.dx + room * 0.25, 0),
          [
            Colors.white.withValues(alpha: 0),
            Color.lerp(
              look.skyHorizon,
              Colors.white,
              0.4,
            )!.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0),
          ],
          const [0, 0.5, 1],
        ),
    );
    final r = _rng('waves');
    final glint = Paint()
      ..strokeWidth = 0.6
      ..color = Color.lerp(
        look.skyHorizon,
        Colors.white,
        0.35,
      )!.withValues(alpha: 0.32);
    for (var i = 0; i < 60; i++) {
      final y = sea + 1 + r.nextDouble() * (horizon - sea);
      final x = r.nextDouble() * size.width;
      final w = 1.5 + r.nextDouble() * size.width * 0.025;
      canvas.drawLine(Offset(x, y), Offset(x + w, y), glint);
    }
    // Ships' lights at night.
    if (_night > 0.2) {
      for (var i = 0; i < 5; i++) {
        canvas.drawCircle(
          Offset(
            size.width * (0.35 + r.nextDouble() * 0.55),
            sea + 2 + r.nextDouble() * room * 0.1,
          ),
          0.7,
          Paint()..color = _window.withValues(alpha: 0.8 * _night),
        );
      }
    }
    // The near headland with a town and its lighthouse.
    final head = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, sea - room * 0.42)
      ..quadraticBezierTo(
        size.width * 0.1,
        sea - room * 0.5,
        size.width * 0.2,
        sea - room * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.28,
        sea - room * 0.08,
        size.width * 0.38,
        sea + room * 0.05,
      )
      ..lineTo(size.width * 0.38, size.height)
      ..close();
    final green = Color.lerp(look.near, const Color(0xFF3C5040), 0.5 * _day)!;
    _layer(canvas, head, green, _hazeNear, sea - room * 0.5, horizon);
    final lx = size.width * 0.15, ly = sea - room * 0.46;
    final lh = room * 0.24;
    canvas
      ..drawRect(
        Rect.fromLTWH(lx - lh * 0.07, ly - lh, lh * 0.14, lh),
        Paint()..color = Color.lerp(look.landmark, Colors.white, 0.35 * _day)!,
      )
      ..drawRect(
        Rect.fromLTWH(lx - lh * 0.07, ly - lh * 0.6, lh * 0.14, lh * 0.12),
        Paint()..color = const Color(0xFF8C4A42).withValues(alpha: 0.8),
      );
    if (_night > 0.1) {
      canvas.drawCircle(
        Offset(lx, ly - lh),
        lh * 0.7,
        Paint()
          ..color = _window.withValues(alpha: 0.4 * _night)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, lh * 0.4),
      );
    }
    _town(
      canvas,
      Rect.fromLTRB(0, sea - room * 0.3, size.width * 0.34, horizon),
      'harbour',
    );
  }

  /// Low houses filling [area], lit at night.
  void _town(Canvas canvas, Rect area, String salt) {
    final r = _rng(salt);
    for (var i = 0; i < 50; i++) {
      final w = 2 + r.nextDouble() * 4;
      final h = 1.5 + r.nextDouble() * 3;
      final x = area.left + r.nextDouble() * area.width;
      final y = area.top + area.height * (0.3 + r.nextDouble() * 0.7);
      canvas.drawRect(
        Rect.fromLTWH(x, y - h, w, h),
        Paint()..color = _hazed(look.near, 0.15 + r.nextDouble() * 0.1),
      );
      if (_night > 0.2 && r.nextDouble() < 0.5) {
        canvas.drawRect(
          Rect.fromLTWH(x + w * 0.4, y - h * 0.6, 0.8, 0.8),
          Paint()..color = _window.withValues(alpha: 0.8 * _night),
        );
      }
    }
  }

  // --- Desert ---------------------------------------------------------------------

  void _desert(Canvas canvas, Size size, double horizon, double room) {
    final sand = look.sand;
    for (final (salt, base, peak, haze) in [
      ('dunes-far', 0.38, 0.62, _hazeFar),
      ('dunes-mid', 0.22, 0.44, _hazeMid),
      ('dunes-near', 0.08, 0.26, _hazeNear),
    ]) {
      final line = _ridgeLine(
        size,
        horizon,
        room,
        salt: salt,
        base: base,
        peak: peak,
        rough: 0.35,
        depth: 4,
      );
      final path = _smooth(line, size);
      _layer(
        canvas,
        path,
        Color.lerp(sand, look.far, haze * 0.3)!,
        haze,
        horizon - room * peak,
        horizon,
      );
      // Light on the dunes' crests.
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = Color.lerp(
            sand,
            Colors.white,
            0.35,
          )!.withValues(alpha: 0.25 * _day + 0.05),
      );
    }
    // Far towers on the haze, as a Gulf city reads from its desert.
    final r = _rng('desert-towers');
    for (var i = 0; i < 9; i++) {
      final x = size.width * (0.55 + r.nextDouble() * 0.4);
      final h = room * (0.25 + r.nextDouble() * 0.45);
      final w = 1.5 + r.nextDouble() * 3;
      final rect = Rect.fromLTWH(x, horizon - room * 0.4 - h, w, h);
      canvas.drawRect(rect, Paint()..color = _hazed(look.far, 0.62));
      if (_night > 0.2) _windows(canvas, rect, 0.5, r);
    }
  }

  // --- Hills ------------------------------------------------------------------------

  void _hills(Canvas canvas, Size size, double horizon, double room) {
    const green = Color(0xFF46594A);
    final tone = Color.lerp(look.far, green, 0.45 * _day)!;
    for (final (salt, base, peak, haze) in [
      ('hills-far', 0.42, 0.72, _hazeFar),
      ('hills-mid', 0.26, 0.5, _hazeMid),
      ('hills-near', 0.1, 0.3, _hazeNear),
    ]) {
      final line = _ridgeLine(
        size,
        horizon,
        room,
        salt: salt,
        base: base,
        peak: peak,
        rough: 0.42,
        depth: 5,
      );
      _layer(
        canvas,
        _smooth(line, size),
        tone,
        haze,
        horizon - room * peak,
        horizon,
      );
      _treeLine(canvas, line, horizon, haze, salt);
    }
    _town(
      canvas,
      Rect.fromLTRB(
        size.width * 0.55,
        horizon - room * 0.22,
        size.width,
        horizon,
      ),
      'village',
    );
  }

  /// Small trees along a ridge.
  void _treeLine(
    Canvas canvas,
    List<Offset> line,
    double horizon,
    double haze,
    String salt,
  ) {
    final r = _rng('trees-$salt');
    final p = Paint()
      ..color = _hazed(
        Color.lerp(look.near, const Color(0xFF2E4232), 0.5 * _day)!,
        haze,
      );
    for (var i = 0; i < line.length; i++) {
      if (r.nextDouble() > 0.45) continue;
      final o = line[i];
      final s = 1.2 + r.nextDouble() * 2.2 * (1 - haze);
      canvas.drawCircle(o.translate(0, s * 0.3), s, p);
    }
  }

  // --- City --------------------------------------------------------------------------

  void _city(Canvas canvas, Size size, double horizon, double room) {
    // A landmark city keeps its skyline lower, so the landmark stands clear.
    final k = landmark == LandmarkKind.none ? 1.0 : 0.7;
    _skyline(
      canvas,
      size,
      horizon,
      room,
      salt: 'far',
      haze: _hazeFar,
      lo: 0.35 * k,
      hi: 0.9 * k,
      wMin: 0.012,
      wMax: 0.03,
    );
    _skyline(
      canvas,
      size,
      horizon,
      room,
      salt: 'mid',
      haze: _hazeMid,
      lo: 0.2 * k,
      hi: 0.6 * k,
      wMin: 0.02,
      wMax: 0.045,
    );
  }

  /// The nearest row of buildings, in front of a landmark.
  void _cityNear(Canvas canvas, Size size, double horizon, double room) {
    _skyline(
      canvas,
      size,
      horizon,
      room,
      salt: 'near',
      haze: _hazeNear,
      lo: 0.06,
      hi: 0.26,
      wMin: 0.03,
      wMax: 0.06,
    );
  }

  void _skyline(
    Canvas canvas,
    Size size,
    double horizon,
    double room, {
    required String salt,
    required double haze,
    required double lo,
    required double hi,
    required double wMin,
    required double wMax,
  }) {
    final r = _rng('city-$salt');
    final body = _hazed(look.near, haze);
    final lit = Color.lerp(body, look.skyHorizon, 0.25)!;
    var x = -r.nextDouble() * size.width * wMax;
    while (x < size.width) {
      final w = size.width * (wMin + r.nextDouble() * (wMax - wMin));
      final h = room * (lo + (hi - lo) * math.pow(r.nextDouble(), 1.5));
      final rect = Rect.fromLTRB(x, horizon - h, x + w - 0.5, horizon + room);
      canvas.drawRect(rect, Paint()..color = body);
      // The lit face of the block, by day.
      if (_day > 0.2) {
        canvas.drawRect(
          Rect.fromLTWH(rect.left, rect.top, math.max(0.8, w * 0.22), h),
          Paint()..color = lit.withValues(alpha: 0.5 * _day),
        );
      }
      // Now and then a crown or a mast.
      final roll = r.nextDouble();
      if (roll < 0.12) {
        canvas.drawPath(
          Path()
            ..moveTo(rect.left, rect.top)
            ..lineTo(rect.center.dx, rect.top - w * 0.7)
            ..lineTo(rect.right, rect.top)
            ..close(),
          Paint()..color = body,
        );
      } else if (roll < 0.22) {
        canvas.drawRect(
          Rect.fromLTWH(
            rect.center.dx - 0.4,
            rect.top - h * 0.18,
            0.8,
            h * 0.18,
          ),
          Paint()..color = body,
        );
        if (_night > 0.2) {
          canvas.drawCircle(
            Offset(rect.center.dx, rect.top - h * 0.18),
            0.9,
            Paint()
              ..color = const Color(0xFFD9544A).withValues(alpha: 0.9 * _night),
          );
        }
      }
      if (_night > 0.2) _windows(canvas, rect, 1 - haze, r, bottom: horizon);
      x += w + (r.nextDouble() < 0.15 ? w * 0.4 : 0);
    }
  }

  void _windows(
    Canvas canvas,
    Rect rect,
    double strength,
    math.Random r, {
    double? bottom,
  }) {
    final p = Paint();
    final step = math.max(1.8, math.min(3.2, rect.width / 4));
    final end = math.min(rect.bottom, bottom ?? rect.bottom);
    for (var y = rect.top + 1.5; y < end - 1; y += step) {
      for (var x = rect.left + 1; x < rect.right - 1; x += step) {
        if (r.nextDouble() > 0.42) continue;
        p.color = _window.withValues(
          alpha: (0.35 + r.nextDouble() * 0.55) * _night * strength,
        );
        canvas.drawRect(Rect.fromLTWH(x, y, 0.8, 0.8), p);
      }
    }
  }

  /// At night a lit city warms the haze over it.
  void _cityGlow(Canvas canvas, Size size, double horizon, double room) {
    if (_night < 0.15) return;
    final k = terrain == Terrain.city || landmark != LandmarkKind.none
        ? 1.0
        : 0.45;
    canvas.drawRect(
      Rect.fromLTRB(0, horizon - room * 0.9, size.width, horizon),
      Paint()
        ..blendMode = BlendMode.screen
        ..shader = ui.Gradient.linear(
          Offset(0, horizon - room * 0.9),
          Offset(0, horizon),
          [
            _window.withValues(alpha: 0),
            _window.withValues(alpha: 0.12 * _night * k),
          ],
        ),
    );
  }

  // --- Landmark ------------------------------------------------------------------------

  void _landmark(Canvas canvas, Size size, double horizon, double room) {
    final path = LandmarkPaths.of(landmark);
    final b = path.getBounds();
    if (b.isEmpty) return;
    // Tall enough to fill the sky over the roof, its foot hidden behind it;
    // never wider than half the frame.
    final hidden = room * 0.22;
    var h = room * 0.94 + hidden;
    if (b.width * h > size.width * 0.5) h = size.width * 0.5 / b.width;
    final r = _rng('landmark-x');
    final cx = size.width * (0.47 + r.nextDouble() * 0.06);
    final shape = path.transform(
      Float64List.fromList([
        h, 0, 0, 0, //
        0, h, 0, 0,
        0, 0, 1, 0,
        cx, horizon + hidden, 0, 1,
      ]),
    );
    final sb = shape.getBounds();
    // Halo of haze behind it, so it lifts off the layers.
    canvas
      ..drawPath(
        shape,
        Paint()
          ..color = look.skyHorizon.withValues(alpha: 0.35)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            math.max(1.5, h * 0.03),
          ),
      )
      ..drawPath(
        shape,
        Paint()
          ..shader = ui.Gradient.linear(sb.topCenter, sb.bottomCenter, [
            Color.lerp(look.landmark, look.skyHorizon, 0.12)!,
            look.landmark,
          ]),
      )
      // The edge that catches the light: the sun's by day, the sky's after.
      ..drawPath(
        shape,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = Color.lerp(
            look.skyHorizon,
            Colors.white,
            0.2,
          )!.withValues(alpha: 0.6),
      );
    if (_night > 0.15) {
      if (LandmarkPaths.hasWindows(landmark)) {
        canvas
          ..save()
          ..clipPath(shape);
        _windows(canvas, sb, 1, _rng('lm-windows'));
        canvas.restore();
      }
      // Floodlit from below.
      canvas.drawPath(
        shape,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = ui.Gradient.linear(sb.bottomCenter, sb.topCenter, [
            _window.withValues(alpha: 0.75 * _night),
            _window.withValues(alpha: 0.25 * _night),
          ]),
      );
    }
  }
}
