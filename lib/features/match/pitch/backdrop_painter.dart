import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/features/match/pitch/backdrop_tone.dart';
import 'package:fnm/features/match/pitch/city_features.dart';
import 'package:fnm/features/match/pitch/city_skyline.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';

/// The sky and the land behind the far stand, in layers: the [horizon] far
/// off (the country's nature), the [city] round the ground in its region's
/// style in front of it, and the city's [landmark] standing tall among the
/// buildings, all in the [look] of the moment and the [season] of the day.
///
/// Drawn first; the stands are drawn over its lower part, so everything is
/// carried down below the roof line and the sky above the stands is never
/// bare. Everything is a seeded function of [seed], so a ground's skyline
/// never changes.
class BackdropPainter {
  BackdropPainter({
    required this.horizon,
    required this.city,
    required this.landmark,
    required this.look,
    required this.seed,
    this.season = BackdropSeason.green,
    this.features = const {},
  }) : _t = BackdropTone(look: look, season: season, seed: seed);

  final Horizon horizon;
  final CityStyle city;
  final LandmarkKind landmark;
  final SceneLook look;
  final BackdropSeason season;

  /// What is round the city: its harbour, river, industry, old town or
  /// park, drawn among the buildings ([CityFeatures]).
  final Set<CityFeature> features;
  final String seed;
  final BackdropTone _t;

  static const Color _window = BackdropTone.window;

  /// The flat grey a winter sky goes under cloud.
  static const Color _overcast = Color(0xFF8C969E);
  static const double _hazeFar = BackdropTone.hazeFar;
  static const double _hazeMid = BackdropTone.hazeMid;
  static const double _hazeNear = BackdropTone.hazeNear;

  double get _night => _t.night;
  double get _day => _t.day;
  bool get _snowy => season == BackdropSeason.snow;

  /// Paints the backdrop over [size], the land standing on [roofLine] (a y
  /// in pixels) and carried down to the bottom of the frame for the stands
  /// to cover.
  void paint(Canvas canvas, Size size, double roofLine) {
    final room = math.max(roofLine, 8.0);
    _sky(canvas, size, roofLine);
    _celestial(canvas, size, room);
    switch (horizon) {
      case Horizon.andes:
      case Horizon.alps:
      case Horizon.atlas:
        _range(canvas, size, roofLine, room);
      case Horizon.sea:
        _sea(canvas, size, roofLine, room);
      case Horizon.forestHills:
        _hills(canvas, size, roofLine, room);
      case Horizon.volcanoes:
        _volcanoes(canvas, size, roofLine, room);
      case Horizon.desert:
        _desert(canvas, size, roofLine, room);
      case Horizon.plains:
        _plains(canvas, size, roofLine, room);
      case Horizon.fjords:
        _fjords(canvas, size, roofLine, room);
    }
    final skyline = CitySkyline(
      style: city,
      tone: _t,
      lowered: landmark != LandmarkKind.none,
    )..paintBack(canvas, size, roofLine, room);
    if (landmark != LandmarkKind.none) _landmark(canvas, size, roofLine, room);
    final near = CityFeatures(features: features, style: city, tone: _t)
      ..paintBehind(canvas, size, roofLine, room);
    skyline.paintFront(canvas, size, roofLine, room);
    near.paintFront(canvas, size, roofLine, room);
    _cityGlow(canvas, size, roofLine, room);
    // Below the roof line is the town round the stadium, seen from above:
    // what shows of it past the end stands is roofs and streets, never sky.
    skyline.paintOutskirts(canvas, size, roofLine, room);
  }

  math.Random _rng(String salt) => _t.rng(salt);

  Color _hazed(Color c, double haze) => _t.hazed(c, haze);

  void _windows(Canvas canvas, Rect rect, double strength, math.Random r) =>
      _t.windows(canvas, rect, strength, r);

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

  /// [natural] as the land wears it in this light: muted toward the far
  /// layer's tone by day, and gone to it at night.
  Color _land(Color natural, [double k = 0.5]) =>
      Color.lerp(look.far, natural, k * _t.lit)!;

  // --- Sky ---------------------------------------------------------------------

  void _sky(Canvas canvas, Size size, double horizon) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, math.max(horizon, 1)),
          [
            for (final c in [look.skyTop, look.skyMid, look.skyHorizon])
              _snowy ? Color.lerp(c, _overcast, 0.3 * _day)! : c,
          ],
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

  // --- Mountain ranges: the Andes, the Alps, the Atlas -------------------------

  void _range(Canvas canvas, Size size, double horizon, double room) {
    final (rock, foot, snowline, snowAlpha, footSnow) = switch (this.horizon) {
      Horizon.andes => (
        const Color(0xFF6E6052),
        const Color(0xFF6A5A48),
        0.7,
        0.9,
        0.5,
      ),
      Horizon.alps => (
        const Color(0xFF66666A),
        _t.land,
        0.6,
        0.92,
        0.0,
      ),
      _ => (
        const Color(0xFF8A6A4A),
        const Color(0xFF7A5E44),
        0.78,
        0.45,
        0.0,
      ),
    };
    final winter = _snowy ? 0.16 : 0.0;
    final rockTone = _land(rock, 0.55);
    // The far range: high, its peaks capped, pale with distance.
    final far = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'range-far',
      base: this.horizon == Horizon.atlas ? 0.36 : 0.42,
      peak: this.horizon == Horizon.atlas ? 0.78 : 0.92,
      rough: this.horizon == Horizon.alps ? 0.6 : 0.55,
      depth: 5,
      anchors: 9,
    );
    final farPath = _fillBelow(far, size);
    _layer(canvas, farPath, rockTone, 0.4, horizon - room, horizon);
    _snow(
      canvas,
      farPath,
      far,
      horizon,
      room,
      snowline: snowline - winter,
      alpha: math.min(0.92, snowAlpha + winter * 2),
    );
    _faces(canvas, far, horizon, 0.1);
    // The foothills: forest under the Alps, bare brown under the Andes and
    // the Atlas.
    final mid = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'range-mid',
      base: 0.26,
      peak: 0.58,
      rough: 0.5,
      depth: 5,
      anchors: 7,
    );
    final midPath = _fillBelow(mid, size);
    _layer(
      canvas,
      midPath,
      _land(foot, 0.55),
      _hazeMid,
      horizon - room * 0.6,
      horizon,
    );
    if (footSnow > 0 || _snowy) {
      _snow(
        canvas,
        midPath,
        mid,
        horizon,
        room,
        snowline: 0.5 - winter,
        alpha: _snowy ? 0.8 : footSnow,
      );
    }
    _faces(canvas, mid, horizon, 0.1);
    if (this.horizon == Horizon.alps) {
      _treeLine(canvas, mid, horizon, _hazeMid, 'range-mid');
    }
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

  /// Small trees along a ridge, in the season's colours, capped with snow
  /// in winter.
  void _treeLine(
    Canvas canvas,
    List<Offset> line,
    double horizon,
    double haze,
    String salt, {
    double chance = 0.45,
  }) {
    final r = _rng('trees-$salt');
    for (var i = 0; i < line.length; i++) {
      if (r.nextDouble() > chance) continue;
      final o = line[i];
      final s = 1.2 + r.nextDouble() * 2.2 * (1 - haze);
      final c = _hazed(_land(_t.tree(r), 0.6), haze);
      canvas.drawCircle(o.translate(0, s * 0.3), s, Paint()..color = c);
      if (_snowy) {
        canvas.drawCircle(
          o.translate(0, s * 0.05),
          s * 0.55,
          Paint()..color = _t.snow(haze).withValues(alpha: 0.7),
        );
      }
    }
  }

  // --- Sea ------------------------------------------------------------------------

  void _sea(Canvas canvas, Size size, double horizon, double room) {
    final sea = horizon - room * 0.42;
    // A far coast, faint, along the horizon.
    final coast = _ridgeLine(
      size,
      sea,
      room,
      salt: 'coast',
      base: 0.04,
      peak: 0.16,
      rough: 0.5,
      depth: 5,
    );
    _layer(
      canvas,
      _smooth(coast, size),
      _land(_t.land, 0.3),
      _hazeFar,
      sea - room * 0.16,
      sea,
    );
    // Open water down to the city, lighter toward the horizon.
    canvas.drawRect(
      Rect.fromLTRB(0, sea, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(Offset(0, sea), Offset(0, horizon + 4), [
          _hazed(look.water, 0.45),
          look.water,
        ]),
    );
    _waterLight(canvas, size, sea, horizon, room);
    // A headland on the left with its lighthouse.
    final head = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, sea - room * 0.3)
      ..quadraticBezierTo(
        size.width * 0.06,
        sea - room * 0.34,
        size.width * 0.12,
        sea - room * 0.16,
      )
      ..quadraticBezierTo(
        size.width * 0.17,
        sea - room * 0.02,
        size.width * 0.24,
        sea + room * 0.04,
      )
      ..lineTo(size.width * 0.24, size.height)
      ..close();
    _layer(
      canvas,
      head,
      _land(_t.land, 0.5),
      _hazeMid,
      sea - room * 0.34,
      horizon,
    );
    final lx = size.width * 0.07, ly = sea - room * 0.31;
    final lh = room * 0.2;
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
  }

  /// The sun's or the moon's path on open water from [top] down to
  /// [bottom], small glints, and ships' lights at night.
  void _waterLight(
    Canvas canvas,
    Size size,
    double top,
    double bottom,
    double room,
  ) {
    final path = Offset(size.width * (look.sunGlow > 0.3 ? 0.82 : 0.12), top);
    canvas.drawRect(
      Rect.fromLTRB(path.dx - room * 0.25, top, path.dx + room * 0.25, bottom),
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
      final y = top + 1 + r.nextDouble() * (bottom - top);
      final x = r.nextDouble() * size.width;
      final w = 1.5 + r.nextDouble() * size.width * 0.025;
      canvas.drawLine(Offset(x, y), Offset(x + w, y), glint);
    }
    if (_night > 0.2) {
      for (var i = 0; i < 5; i++) {
        canvas.drawCircle(
          Offset(
            size.width * (0.35 + r.nextDouble() * 0.55),
            top + 2 + r.nextDouble() * room * 0.08,
          ),
          0.7,
          Paint()..color = _window.withValues(alpha: 0.8 * _night),
        );
      }
    }
  }

  // --- Forested hills ------------------------------------------------------------

  void _hills(Canvas canvas, Size size, double horizon, double room) {
    final tone = _snowy ? look.snow : _land(_t.land);
    for (final (salt, base, peak, haze) in [
      ('hills-far', 0.42, 0.72, _hazeFar),
      ('hills-mid', 0.26, 0.5, _hazeMid),
      ('hills-near', 0.12, 0.32, _hazeNear),
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
      final hill = _smooth(line, size);
      _layer(canvas, hill, tone, haze, horizon - room * peak, horizon);
      canvas
        ..save()
        ..clipPath(hill);
      _forest(canvas, line, horizon, room, haze, salt);
      canvas.restore();
      _treeLine(canvas, line, horizon, haze, salt, chance: 0.7);
    }
  }

  /// The woods on a hill: patches of trees in the season's colours over the
  /// slope below [line].
  void _forest(
    Canvas canvas,
    List<Offset> line,
    double horizon,
    double room,
    double haze,
    String salt,
  ) {
    final r = _rng('forest-$salt');
    final s = math.max(1.2, room * 0.025);
    for (var i = 0; i < line.length * 3; i++) {
      final k = r.nextInt(line.length);
      final o = line[k];
      final depth = r.nextDouble() * (horizon - o.dy) * 0.7;
      if (r.nextDouble() < 0.35) continue;
      final c = _hazed(_land(_t.tree(r), 0.55), haze + depth / room * 0.1);
      canvas.drawCircle(
        Offset(o.dx + (r.nextDouble() - 0.5) * s * 4, o.dy + s + depth),
        s * (0.7 + r.nextDouble() * 0.6),
        Paint()..color = c,
      );
    }
  }

  // --- Volcanoes -------------------------------------------------------------------

  void _volcanoes(Canvas canvas, Size size, double horizon, double room) {
    final r = _rng('volcano');
    // A low ridge far off.
    final ridge = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'volc-ridge',
      base: 0.28,
      peak: 0.42,
      rough: 0.45,
      depth: 5,
    );
    _layer(
      canvas,
      _smooth(ridge, size),
      _land(_t.land, 0.4),
      _hazeFar,
      horizon - room * 0.42,
      horizon,
    );
    // Two cones, the great one to one side of the middle a landmark keeps.
    final left = r.nextBool();
    final capped = r.nextDouble() < 0.7 || _snowy;
    for (final (cx, peak, haze) in [
      (size.width * (left ? 0.7 : 0.28), 0.62, _hazeFar),
      (size.width * (left ? 0.24 : 0.74), 0.94, 0.36),
    ]) {
      final h = room * peak;
      final half = h * 1.7;
      final crater = h * 0.07;
      final top = horizon - h;
      final cone = Path()
        ..moveTo(cx - half, horizon + room)
        ..lineTo(cx - half, horizon)
        ..quadraticBezierTo(
          cx - half * 0.35,
          horizon - h * 0.55,
          cx - crater,
          top,
        )
        ..lineTo(cx + crater, top)
        ..quadraticBezierTo(
          cx + half * 0.35,
          horizon - h * 0.55,
          cx + half,
          horizon,
        )
        ..lineTo(cx + half, horizon + room)
        ..close();
      _layer(
        canvas,
        cone,
        _land(const Color(0xFF5E5650), 0.55),
        haze,
        top,
        horizon,
      );
      // The shaded flank away from the light.
      canvas
        ..save()
        ..clipPath(cone)
        ..drawRect(
          Rect.fromLTRB(cx, top, cx + half, horizon),
          Paint()
            ..color = Colors.black.withValues(alpha: 0.12 * (0.4 + 0.6 * _day)),
        );
      if (capped) {
        final cap = Path()..moveTo(cx - half, top + h * (_snowy ? 0.5 : 0.28));
        for (var i = 0; i <= 10; i++) {
          final x = cx - half + half * 2 * i / 10;
          cap.lineTo(
            x,
            top + h * (_snowy ? 0.5 : 0.28) + (r.nextDouble() - 0.5) * h * 0.08,
          );
        }
        cap
          ..lineTo(cx + half, top - 2)
          ..lineTo(cx - half, top - 2)
          ..close();
        canvas.drawPath(
          cap,
          Paint()..color = _t.snow(haze).withValues(alpha: 0.88),
        );
      }
      canvas.restore();
      // A thin plume from the great one.
      if (peak > 0.9 && r.nextDouble() < 0.5) {
        canvas.drawPath(
          Path()
            ..moveTo(cx - crater, top)
            ..quadraticBezierTo(
              cx + h * 0.2,
              top - h * 0.3,
              cx + h * 0.8,
              top - h * 0.36,
            )
            ..quadraticBezierTo(cx + h * 0.25, top - h * 0.12, cx + crater, top)
            ..close(),
          Paint()
            ..color = _hazed(look.skyHorizon, 0.2).withValues(alpha: 0.4)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, h * 0.03),
        );
      }
    }
    // Green foothills in front of the cones.
    final hills = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'volc-hills',
      base: 0.1,
      peak: 0.28,
      rough: 0.45,
      depth: 5,
    );
    _layer(
      canvas,
      _smooth(hills, size),
      _land(_t.land),
      _hazeMid,
      horizon - room * 0.28,
      horizon,
    );
    _treeLine(canvas, hills, horizon, _hazeMid, 'volc-hills', chance: 0.6);
  }

  // --- Desert ---------------------------------------------------------------------

  void _desert(Canvas canvas, Size size, double horizon, double room) {
    final sand = look.sand;
    for (final (salt, base, peak, haze) in [
      ('dunes-far', 0.32, 0.54, _hazeFar),
      ('dunes-mid', 0.2, 0.4, _hazeMid),
      ('dunes-near', 0.08, 0.24, _hazeNear),
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
  }

  // --- Plains -------------------------------------------------------------------------

  void _plains(Canvas canvas, Size size, double horizon, double room) {
    final r = _rng('plains');
    final line = horizon - room * 0.22;
    // The far land: a faint low rise on the horizon.
    final far = _ridgeLine(
      size,
      line,
      room,
      salt: 'plains-far',
      base: 0.0,
      peak: 0.06,
      rough: 0.5,
      depth: 5,
    );
    _layer(
      canvas,
      _smooth(far, size),
      _land(_t.land, 0.35),
      _hazeFar,
      line - room * 0.06,
      line,
    );
    // Fields down to the city, in strips of the season's land.
    final fields = Rect.fromLTRB(0, line, size.width, size.height);
    canvas.drawRect(
      fields,
      Paint()
        ..color = _snowy ? _t.snow(_hazeMid) : _hazed(_land(_t.land), _hazeMid),
    );
    var y = line + 0.5;
    var h = 0.8;
    while (y < horizon) {
      var x = -r.nextDouble() * size.width * 0.1;
      while (x < size.width) {
        final w = size.width * (0.06 + r.nextDouble() * 0.14);
        final shade = r.nextDouble();
        final c = _snowy
            ? _t.snow(_hazeMid)
            : Color.lerp(
                _t.land,
                shade < 0.3 ? const Color(0xFF8A7A4E) : const Color(0xFF3E5236),
                0.35 * shade,
              )!;
        canvas.drawRect(
          Rect.fromLTWH(x, y, w - 0.6, h),
          Paint()
            ..color = _hazed(
              _snowy ? c : _land(c),
              _hazeMid + (horizon - y) / room,
            ),
        );
        x += w;
      }
      y += h + 0.5;
      h *= 1.35;
    }
    // Tree lines and copses across the fields.
    for (var i = 0; i < 6; i++) {
      final yy = line + (horizon - line) * (0.1 + 0.8 * r.nextDouble());
      final x0 = size.width * r.nextDouble();
      final n = 4 + r.nextInt(10);
      final s = 0.8 + (yy - line) / room * 6;
      for (var k = 0; k < n; k++) {
        canvas.drawCircle(
          Offset(x0 + k * s * 1.5, yy),
          s * (0.8 + r.nextDouble() * 0.4),
          Paint()..color = _hazed(_land(_t.tree(r), 0.55), _hazeMid),
        );
      }
    }
    // A few wind turbines far off, by day.
    if (_day > 0.3) {
      final pole = Paint()
        ..color = _hazed(const Color(0xFFD6DCE0), _hazeFar).withValues(
          alpha: 0.7 * _day,
        )
        ..strokeWidth = 0.6;
      for (var i = 0; i < 3; i++) {
        final x = size.width * (0.62 + r.nextDouble() * 0.34);
        final h = room * (0.14 + r.nextDouble() * 0.06);
        final hub = Offset(x, line - h);
        canvas.drawLine(Offset(x, line), hub, pole);
        final a0 = r.nextDouble() * math.pi;
        for (var b = 0; b < 3; b++) {
          final a = a0 + b * math.pi * 2 / 3;
          canvas.drawLine(
            hub,
            hub + Offset(math.cos(a), math.sin(a)) * h * 0.45,
            pole,
          );
        }
      }
    }
  }

  // --- Fjords ---------------------------------------------------------------------------

  void _fjords(Canvas canvas, Size size, double horizon, double room) {
    final water = horizon - room * 0.3;
    // The far walls, snow on their tops.
    final far = _ridgeLine(
      size,
      horizon,
      room,
      salt: 'fjord-far',
      base: 0.5,
      peak: 0.82,
      rough: 0.4,
      depth: 5,
      anchors: 5,
    );
    final farPath = _smooth(far, size);
    _layer(
      canvas,
      farPath,
      _land(const Color(0xFF4E5650), 0.5),
      _hazeFar,
      horizon - room * 0.82,
      water,
    );
    _snow(
      canvas,
      farPath,
      far,
      horizon,
      room,
      snowline: _snowy ? 0.5 : 0.72,
      alpha: 0.85,
    );
    // The water between the walls.
    canvas.drawRect(
      Rect.fromLTRB(0, water, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, water),
          Offset(0, horizon + 4),
          [_hazed(look.water, 0.4), look.water],
        ),
    );
    _waterLight(canvas, size, water, horizon, room);
    // The near walls: steep on either side, dropping into the water.
    for (final left in [true, false]) {
      final x0 = left ? 0.0 : size.width;
      final dir = left ? 1.0 : -1.0;
      final reach = size.width * 0.36;
      final top = horizon - room * 0.86;
      final wall = Path()
        ..moveTo(x0, size.height)
        ..lineTo(x0, top)
        ..cubicTo(
          x0 + dir * reach * 0.35,
          top - room * 0.04,
          x0 + dir * reach * 0.6,
          horizon - room * 0.55,
          x0 + dir * reach,
          water + room * 0.02,
        )
        ..lineTo(x0 + dir * reach, size.height)
        ..close();
      final rock = _land(_t.land, 0.4);
      _layer(canvas, wall, rock, _hazeMid, top, horizon);
      canvas
        ..save()
        ..clipPath(wall)
        ..drawPath(
          Path()
            ..moveTo(x0, top - 4)
            ..lineTo(x0 + dir * reach * 0.5, top - 4)
            ..lineTo(
              x0 + dir * reach * 0.42,
              top + room * (_snowy ? 0.3 : 0.12),
            )
            ..lineTo(x0, top + room * (_snowy ? 0.36 : 0.16))
            ..close(),
          Paint()..color = _t.snow(_hazeMid).withValues(alpha: 0.8),
        )
        ..restore();
      _forestBand(canvas, wall, x0, dir, reach, horizon, room);
    }
  }

  /// Dark pines over the lower half of a fjord's wall.
  void _forestBand(
    Canvas canvas,
    Path wall,
    double x0,
    double dir,
    double reach,
    double horizon,
    double room,
  ) {
    final r = _rng('fjord-pines-$dir');
    canvas
      ..save()
      ..clipPath(wall);
    final s = math.max(1.0, room * 0.02);
    for (var i = 0; i < 140; i++) {
      final x = x0 + dir * reach * r.nextDouble();
      final y = horizon - room * (0.05 + r.nextDouble() * 0.4);
      canvas.drawPath(
        Path()
          ..moveTo(x - s, y)
          ..lineTo(x, y - s * 2.6)
          ..lineTo(x + s, y)
          ..close(),
        Paint()
          ..color = _hazed(
            _land(const Color(0xFF2A3A2E), 0.5),
            _hazeMid * 0.6,
          ),
      );
    }
    canvas.restore();
  }

  /// At night a lit city warms the haze over it.
  void _cityGlow(Canvas canvas, Size size, double horizon, double room) {
    if (_night < 0.15) return;
    final k = switch (city) {
      CityStyle.smallTown => 0.35,
      CityStyle.glassTowers => 1.2,
      _ => 0.9,
    };
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
    // Snow on a mountain's top.
    final cap = LandmarkPaths.capOf(landmark);
    if (cap != null) {
      canvas.drawPath(
        cap.transform(
          Float64List.fromList([
            h, 0, 0, 0, //
            0, h, 0, 0,
            0, 0, 1, 0,
            cx, horizon + hidden, 0, 1,
          ]),
        ),
        Paint()..color = _t.snow(_hazeMid),
      );
    }
    if (_night > 0.15) {
      if (LandmarkPaths.hasWindows(landmark)) {
        canvas
          ..save()
          ..clipPath(shape);
        _windows(canvas, sb, 1, _rng('lm-windows'));
        canvas.restore();
      }
      // Floodlit from below, except where the lighting is itself
      // protected: the Eiffel Tower stays a dark silhouette at night.
      if (!LandmarkPaths.floodlitAtNight(landmark)) return;
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
