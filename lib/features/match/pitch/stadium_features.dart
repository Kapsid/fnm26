part of 'stadium_painter.dart';

/// A ground's own features ([StadiumSignature]), its fans' show in the
/// stands ([CrowdShow]) and what the weather does to it ([WeatherKind]).
///
/// Everything here is generic: shapes, patterns and colours only. Nothing
/// draws text, a name, a logo or an emblem; a tifo is an abstract pattern
/// in the side's colours.
extension _StadiumFeatures on StadiumPainter {
  StadiumSignature get _sig => spec.signature;

  // --- The bowl --------------------------------------------------------------

  /// How much further back a running track pushes the stands, metres.
  double get _trackGap => _sig.runningTrack ? 7.5 : 0;

  /// The home end built up into one steep wall of fans.
  bool _isWall(_Seg s) =>
      _sig.bowl == BowlShape.endWall && s == _Seg.left && spec.tiers > 1;

  /// The wall's tiers: short in plan and steep, so the end rises like a
  /// cliff of fans rather than running out of the frame.
  static const double _wallDepth = 3.6;

  /// The wall's tiers: short in plan and steep, so the end rises like a
  /// cliff of fans rather than running out of the frame.
  static const double _wallOverhang = 0.4;
  static const double _wallRake = 2;
  static const double _wallFascia = 0.6;

  /// A wall tier's depth along its slope, for how many rows it seats.
  static double get _wallSlope =>
      _wallDepth * math.sqrt(1 + _wallRake * _wallRake);

  int get _wallTiers => math.min(5, spec.tiers + 2);

  ({double o0, double z0, double o1, double z1}) _wallTier(int k) {
    final o0 = k * (_wallDepth - _wallOverhang);
    final z0 =
        StadiumPainter._frontWall + k * (_wallDepth * _wallRake + _wallFascia);
    return (
      o0: o0,
      z0: z0,
      o1: o0 + _wallDepth,
      z1: z0 + _wallDepth * _wallRake,
    );
  }

  /// The two colours the seats are patterned in: the ground nation's,
  /// muted so an empty seat still never passes for a fan.
  (Color, Color)? get _seatColours {
    final g = spec.groundColours;
    if (g == null || _sig.seats == SeatPattern.plain) return null;
    Color mute(Color c) {
      final h = HSLColor.fromColor(c);
      return h
          .withLightness(h.lightness.clamp(0.22, 0.46))
          .withSaturation((h.saturation * 0.7).clamp(0.0, 0.6))
          .toColor();
    }

    return (mute(g.$1), mute(g.$2));
  }

  /// Which of the two seat colours sits at [u] along [s] on tier [k].
  bool _seatFirst(_Seg s, int k, double u) => switch (_sig.seats) {
    SeatPattern.plain => true,
    SeatPattern.bands => k.isEven,
    SeatPattern.halves => switch (s) {
      _Seg.left || _Seg.cornerLeft => true,
      _Seg.right || _Seg.cornerRight => false,
      _Seg.far => u < 0.5,
    },
    SeatPattern.mosaic => ((u * _segLength(s) / 9).floor() + k).isEven,
  };

  /// The fascia under tier [k] of [s] in the seats' colours, where the
  /// seats are patterned (null keeps the plain fascia).
  Color? _fasciaTone(_Seg s, int k) {
    final c = _seatColours;
    if (c == null || k == 0) return null;
    return _seatFirst(s, k, 0.5) ? c.$1 : c.$2;
  }

  /// The seats' pattern over a tier's plain seats, where it shows between
  /// the fans.
  void _seatPattern(
    Canvas canvas,
    _Seg s,
    ({double o0, double z0, double o1, double z1}) t,
    int k,
    Color seats,
  ) {
    final c = _seatColours;
    if (c == null) return;
    final n =
        _sig.seats == SeatPattern.mosaic || _sig.seats == SeatPattern.halves
        ? math.max(2, (_segLength(s) / 3).round())
        : 1;
    for (var i = 0; i < n; i++) {
      final a = i / n;
      final b = (i + 1) / n;
      final colour = _seatFirst(s, k, (a + b) / 2) ? c.$1 : c.$2;
      canvas.drawPath(
        _StadiumFeatures._quad(
          (u) => _standPoint(s, u, t.o0, t.z0),
          (u) => _standPoint(s, u, t.o1, t.z1),
          a,
          b,
        ),
        Paint()
          ..isAntiAlias = false
          ..color = Color.lerp(seats, colour, 0.55)!,
      );
    }
  }

  /// The strip between [a] and [b] along a band from edge [f] to edge [g].
  static Path _quad(
    Offset Function(double u) f,
    Offset Function(double u) g,
    double a,
    double b, {
    int steps = 2,
  }) => StadiumPainter._poly([
    for (var i = 0; i <= steps; i++) f(a + (b - a) * i / steps),
    for (var i = steps; i >= 0; i--) g(a + (b - a) * i / steps),
  ]);

  /// A running track round the pitch, between the boards and the stands,
  /// its lanes marked.
  void _track(Canvas canvas) {
    if (!_sig.runningTrack) return;
    const l = PitchDims.length;
    const w = PitchDims.width;
    const inset = 0.6;
    final x0 = -_endFront + inset;
    final x1 = l + _endFront - inset;
    final y0 = -_farFront + inset;
    const yn = w + 40;
    final ring = _metres([(x0, y0), (x1, y0), (x1, yn), (x0, yn)])
      ..addPath(
        _metres([
          (StadiumPainter._gx0 - 0.8, StadiumPainter._gy0 - 0.8),
          (StadiumPainter._gx1 + 0.8, StadiumPainter._gy0 - 0.8),
          (StadiumPainter._gx1 + 0.8, yn + 1),
          (StadiumPainter._gx0 - 0.8, yn + 1),
        ]),
        Offset.zero,
      )
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(ring, Paint()..color = const Color(0xFF6E3D32));
    final lane = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.32);
    for (var i = 1; i < 6; i++) {
      final d = _trackGap * i / 6;
      final gx0 = StadiumPainter._gx0 - 0.8 - d * 0.9;
      final gx1 = StadiumPainter._gx1 + 0.8 + d * 0.9;
      final gy0 = StadiumPainter._gy0 - 0.8 - d;
      canvas.drawPath(
        StadiumPainter._poly([
          for (var j = 0; j <= 12; j++) _p(gx0, yn - (yn - gy0) * j / 12),
          for (var j = 0; j <= 24; j++) _p(gx0 + (gx1 - gx0) * j / 24, gy0),
          for (var j = 0; j <= 12; j++) _p(gx1, gy0 + (yn - gy0) * j / 12),
        ], close: false),
        lane,
      );
    }
  }

  /// Snow lying round the pitch: on the concourse and the track, the pitch
  /// itself swept clear.
  void _snowGround(Canvas canvas) {
    if (spec.weather != WeatherKind.snow) return;
    const l = PitchDims.length;
    const w = PitchDims.width;
    const yn = w + 40;
    final ring =
        _metres([
            (-_endFront, -_farFront),
            (l + _endFront, -_farFront),
            (l + _endFront, yn),
            (-_endFront, yn),
          ])
          ..addPath(
            _metres([
              (StadiumPainter._gx0 - 0.3, StadiumPainter._gy0 - 0.3),
              (StadiumPainter._gx1 + 0.3, StadiumPainter._gy0 - 0.3),
              (StadiumPainter._gx1 + 0.3, yn + 1),
              (StadiumPainter._gx0 - 0.3, yn + 1),
            ]),
            Offset.zero,
          )
          ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      ring,
      Paint()..color = const Color(0xFFB9C2CA).withValues(alpha: 0.82),
    );
  }

  /// The city blocks behind a soccer-specific ground's open end: each its
  /// span along the end (0 to 1), height in metres and tone.
  List<({double u0, double u1, double h, int tone})> get _openEndBlocks {
    if (_sig.bowl != BowlShape.openEnd) return const [];
    final r = math.Random(varietySeed('open-end:${spec.flagCode}'));
    final out = <({double u0, double u1, double h, int tone})>[];
    var u = 0.0;
    while (u < 1) {
      final du = (5 + r.nextDouble() * 8) / _segLength(_Seg.left);
      final b = math.min(1.0, u + du);
      out.add((u0: u, u1: b, h: 10 + r.nextDouble() * 34, tone: r.nextInt(3)));
      u = b + 0.004;
    }
    return out;
  }

  static const double _openEndBack = StadiumPainter._terraceDepth + 9;

  /// Behind a soccer-specific ground's open end: the city's blocks, close,
  /// their windows in rows.
  void _openEndSkyline(Canvas canvas) {
    _snowGround(canvas);
    const tones = [Color(0xFF3A4452), Color(0xFF323B47), Color(0xFF434C59)];
    final window = Paint()
      ..color = const Color(0xFF8C98A6).withValues(alpha: 0.45);
    for (final b in _openEndBlocks) {
      canvas.drawPath(
        _StadiumFeatures._quad(
          (x) => _standPoint(_Seg.left, x, _openEndBack, 0),
          (x) => _standPoint(_Seg.left, x, _openEndBack, b.h),
          b.u0,
          b.u1,
        ),
        Paint()..color = tones[b.tone],
      );
      _windows(canvas, b, window);
    }
  }

  /// The rows of windows on one block behind the open end.
  void _windows(
    Canvas canvas,
    ({double u0, double u1, double h, int tone}) b,
    Paint paint, {
    bool lit = false,
  }) {
    final r = math.Random(varietySeed('windows:${b.u0}:${b.h}'));
    for (var z = 3.0; z < b.h - 2; z += 3.2) {
      for (var i = 0; i < 4; i++) {
        if (lit && r.nextDouble() < 0.45) continue;
        final u = b.u0 + (b.u1 - b.u0) * (i + 0.5) / 4;
        final c = _standPoint(_Seg.left, u, _openEndBack, z);
        final ppm = _ppm(_segY(_Seg.left, u, _openEndBack));
        canvas.drawRect(
          Rect.fromCenter(
            center: c,
            width: math.max(0.8, ppm * 0.9),
            height: math.max(0.8, ppm * 1.2),
          ),
          paint,
        );
      }
    }
  }

  // --- Roofs -----------------------------------------------------------------

  /// An open bowl's rim: a thin parapet along the back of the top tier.
  void _openRim(Canvas canvas, _Seg s, double o, double z) {
    canvas
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o, z),
          (t) => _standPoint(s, t, o, z + 0.9),
        ),
        Paint()..color = AppColors.surfaceContainerHigh,
      )
      ..drawPath(
        StadiumPainter._line((t) => _standPoint(s, t, o, z + 0.9)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = _accent.withValues(alpha: 0.45),
      );
  }

  /// One roof all the way round: a deep inner edge, no gap at the corners.
  void _ringRoof(Canvas canvas, _Seg s, double o, double z) {
    const deep = StadiumPainter._canopy * 2.6;
    final zr = z + StadiumPainter._roofWall;
    canvas
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o, z),
          (t) => _standPoint(s, t, o, zr),
        ),
        Paint()..color = AppColors.surfaceContainerLow,
      )
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o - deep, zr),
          (t) => _standPoint(s, t, o, zr + 1.4),
        ),
        Paint()..color = AppColors.surfaceContainerHighest,
      )
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o - deep, zr - 0.9),
          (t) => _standPoint(s, t, o - deep, zr),
        ),
        Paint()..color = const Color(0xFF8E979F),
      )
      ..drawPath(
        StadiumPainter._line((t) => _standPoint(s, t, o - deep, zr)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = _accent.withValues(alpha: 0.55),
      );
  }

  /// A light, translucent canopy on ribs.
  void _canopyRoof(Canvas canvas, _Seg s, double o, double z) {
    const reach = StadiumPainter._canopy * 1.6;
    final zr = z + StadiumPainter._roofWall;
    final glass = Color.lerp(
      AppColors.surfaceContainerHighest,
      const Color(0xFFDCE6EE),
      0.35,
    )!;
    canvas
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o, z),
          (t) => _standPoint(s, t, o, zr),
        ),
        Paint()..color = AppColors.surfaceContainerLow,
      )
      ..drawPath(
        StadiumPainter._band(
          (t) => _standPoint(s, t, o - reach, zr),
          (t) => _standPoint(s, t, o, zr + 1.6),
        ),
        Paint()..color = glass.withValues(alpha: 0.42),
      );
    final ribs = math.max(3, (_segLength(s) / 6).round());
    final rib = Paint()
      ..strokeWidth = 0.6
      ..color = AppColors.outline.withValues(alpha: 0.7);
    for (var i = 0; i <= ribs; i++) {
      final t = i / ribs;
      canvas.drawLine(
        _standPoint(s, t, o, zr + 1.6),
        _standPoint(s, t, o - reach, zr),
        rib,
      );
    }
    canvas.drawPath(
      StadiumPainter._line((t) => _standPoint(s, t, o - reach, zr)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = _accent.withValues(alpha: 0.55),
    );
  }

  Color get _accent =>
      dressing.isFinal ? AppColors.medalGold : AppColors.primary;

  /// The height of the far stand's roof line, metres.
  double get _farRoofTop {
    final top = _tier(spec.tiers - 1);
    return top.z1 +
        (_sig.roof == RoofStyle.open ? 0.9 : StadiumPainter._roofWall + 1.4);
  }

  /// An arch over the far stand, or a crown of fins along its rim.
  void _roofCrown(Canvas canvas) {
    final top = _tier(spec.tiers - 1);
    final o = top.o1 - 1;
    final z = _farRoofTop;
    switch (_sig.crownFeature) {
      case RoofCrown.none:
        return;
      case RoofCrown.arch:
        const l = PitchDims.length;
        const rise = 26.0;
        Offset at(double t) {
          final x = -10 + (l + 20) * t;
          final h = z + rise * (1 - (2 * t - 1) * (2 * t - 1));
          return _p(
            x,
            -_farFront - o * StadiumPainter._farDepthScale,
            h * StadiumPainter._standRise,
          );
        }

        final cable = Paint()
          ..strokeWidth = 0.5
          ..color = AppColors.outline.withValues(alpha: 0.6);
        for (var i = 1; i < 14; i++) {
          final t = i / 14;
          final a = at(t);
          canvas.drawLine(
            a,
            _standPoint(_Seg.far, (t * (l + 20) - 10) / l, o, z),
            cable,
          );
        }
        final arch = StadiumPainter._line(at, n: 48);
        canvas
          ..drawPath(
            arch,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = math.max(2, _ppm(-_farFront) * 0.9)
              ..color = const Color(0xFFC9CED3),
          )
          ..drawPath(
            arch,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = math.max(0.8, _ppm(-_farFront) * 0.3)
              ..color = Colors.white.withValues(alpha: 0.6),
          );
      case RoofCrown.crown:
        final fin = Paint()..color = const Color(0xFFB4BBC2);
        for (final s in _order) {
          if (_isTerraceEnd(s)) continue;
          final t = _topOf(s);
          final zs =
              t.z1 +
              (_sig.roof == RoofStyle.open ? 0.9 : StadiumPainter._roofWall);
          final n = math.max(2, (_segLength(s) / 4.5).round());
          for (var i = 0; i < n; i++) {
            final u = (i + 0.5) / n;
            final du = 0.35 / n;
            canvas.drawPath(
              StadiumPainter._poly([
                _standPoint(s, u - du, t.o1, zs),
                _standPoint(s, u + du, t.o1, zs),
                _standPoint(s, u, t.o1 + 1.5, zs + 6.5),
              ]),
              fin,
            );
          }
        }
    }
  }

  // --- Screens ---------------------------------------------------------------

  /// Where the big screens stand: one over the far left corner, or a giant
  /// one over each end of an American-football bowl. Each is (bottom left,
  /// bottom right, top right, top left) on screen.
  List<List<Offset>> get _screenQuads {
    if (!_sig.bigScreen) return const [];
    final top = _tier(spec.tiers - 1);
    final y = -_farFront - top.o1 * StadiumPainter._farDepthScale - 1;
    final z0 = _farRoofTop * StadiumPainter._standRise + 1.5;
    List<Offset> quad(double x0, double x1, double h) => [
      _p(x0, y, z0),
      _p(x1, y, z0),
      _p(x1, y, z0 + h),
      _p(x0, y, z0 + h),
    ];
    const l = PitchDims.length;
    if (_sig.kind == GroundKind.gridironBowl) {
      return [quad(-12, 12, 10), quad(l - 12, l + 12, 10)];
    }
    return [quad(-4, 12, 7)];
  }

  /// The screens' frames and their pictures: abstract blocks of the ground
  /// nation's colours, never a word or an emblem.
  void _screens(Canvas canvas) {
    final quads = _screenQuads;
    if (quads.isEmpty) return;
    final g =
        spec.groundColours ?? (spec.homeColour, AppColors.surfaceContainerHigh);
    for (final q in quads) {
      final frame = StadiumPainter._poly(q);
      canvas.drawPath(frame, Paint()..color = const Color(0xFF14171B));
      // The legs.
      final leg = Paint()
        ..strokeWidth = 1.0
        ..color = AppColors.outlineVariant;
      for (final f in [0.2, 0.8]) {
        final b = Offset.lerp(q[0], q[1], f)!;
        canvas.drawLine(b, b.translate(0, (q[0].dy - q[3].dy) * 0.5), leg);
      }
      Offset at(double u, double v) => Offset.lerp(
        Offset.lerp(q[0], q[1], u),
        Offset.lerp(q[3], q[2], u),
        v,
      )!;
      const m = 0.07;
      final display = StadiumPainter._poly([
        at(m, m),
        at(1 - m, m),
        at(1 - m, 1 - m),
        at(m, 1 - m),
      ]);
      canvas
        ..save()
        ..clipPath(display)
        ..drawPath(
          display,
          Paint()
            ..shader = ui.Gradient.linear(at(0, 0.5), at(1, 0.5), [
              Color.lerp(g.$1, Colors.black, 0.35)!,
              Color.lerp(g.$2, Colors.black, 0.45)!,
            ]),
        );
      for (final (v0, v1) in [(0.62, 0.7), (0.3, 0.36)]) {
        canvas.drawPath(
          StadiumPainter._poly([
            at(0.12, v0),
            at(0.88, v0),
            at(0.88, v1),
            at(0.12, v1),
          ]),
          Paint()..color = Colors.white.withValues(alpha: 0.16),
        );
      }
      canvas.restore();
    }
  }

  /// The screens, and the windows behind an open end, light up at night.
  void _screenGlow(Canvas canvas) {
    final f = look.flood;
    if (f < 0.05) return;
    final lit = Paint()
      ..color = const Color(0xFFF2D08A).withValues(alpha: 0.75 * f);
    for (final b in _openEndBlocks) {
      _windows(canvas, b, lit, lit: true);
    }
    for (final q in _screenQuads) {
      final r = Rect.fromPoints(q[0], q[2]);
      canvas.drawRect(
        r.inflate(r.height * 0.3),
        Paint()
          ..color = const Color(0xFFBFD3E8).withValues(alpha: 0.13 * f)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r.height * 0.4),
      );
    }
  }

  // --- Turf ------------------------------------------------------------------

  /// An American-football bowl's faint gridiron lines left on the turf.
  void _gridironLines(Canvas canvas) {
    if (_sig.kind != GroundKind.gridironBowl) return;
    const yard = 0.9144;
    const c = PitchDims.length / 2;
    const w = PitchDims.width;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.2);
    canvas
      ..save()
      ..clipPath(_field);
    // The end zones, faintly tinted.
    final tint = Paint()..color = Colors.white.withValues(alpha: 0.035);
    for (final (a, b) in [
      (c - 60 * yard, c - 50 * yard),
      (c + 50 * yard, c + 60 * yard),
    ]) {
      canvas.drawPath(
        _metres([(a, -2), (b, -2), (b, w + 2), (a, w + 2)], steps: 4),
        tint,
      );
    }
    for (var k = -5; k <= 5; k++) {
      final x = c + k * 10 * yard;
      canvas.drawPath(
        StadiumPainter._line((t) => _p(x, -1 + (w + 2) * t), n: 8),
        line,
      );
    }
    // Hash marks, every five yards.
    for (var k = -10; k <= 10; k++) {
      final x = c + k * 5 * yard;
      for (final y in [w / 2 - 3, w / 2 + 3]) {
        canvas.drawLine(_p(x, y - 0.6), _p(x, y + 0.6), line);
      }
    }
    canvas.restore();
  }

  /// Rain on the grass: darker, with a wet sheen.
  void _wetGrass(Canvas canvas) {
    if (spec.weather != WeatherKind.rain) return;
    final field = _field;
    final b = field.getBounds();
    canvas
      ..drawPath(
        field,
        Paint()..color = const Color(0xFF0C1A12).withValues(alpha: 0.16),
      )
      ..drawPath(
        field,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = ui.Gradient.linear(
            b.topLeft,
            b.bottomRight,
            [
              Colors.white.withValues(alpha: 0),
              const Color(0xFFB8C8D6).withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0),
            ],
            const [0.2, 0.5, 0.8],
          ),
      );
  }

  /// Snow on every roof.
  void _snowOnRoofs(Canvas canvas) {
    if (spec.weather != WeatherKind.snow) return;
    final snow = Paint()
      ..color = const Color(0xFFDDE3E8).withValues(alpha: 0.8);
    for (final s in _order) {
      if (_isTerraceEnd(s)) continue;
      final t = _topOf(s);
      final open = _sig.roof == RoofStyle.open;
      final zr = t.z1 + (open ? 0.9 : StadiumPainter._roofWall);
      final o0 = open ? t.o1 - 0.4 : t.o1 - StadiumPainter._canopy;
      canvas.drawPath(
        StadiumPainter._band(
          (u) => _standPoint(s, u, o0, zr),
          (u) => _standPoint(s, u, t.o1, zr + 0.7),
        ),
        snow,
      );
    }
  }

  // --- Weather in the sky ----------------------------------------------------

  /// The sky under the day's weather: grey cloud for rain or snow, a pale
  /// warm haze in the Gulf heat.
  void _weatherSky(Canvas canvas, Size size, double horizon) {
    final rect = Rect.fromLTRB(0, 0, size.width, horizon + 2);
    switch (spec.weather) {
      case WeatherKind.clear:
        return;
      case WeatherKind.rain:
      case WeatherKind.snow:
        final cloud = spec.weather == WeatherKind.rain
            ? Color.lerp(look.skyMid, const Color(0xFF6E767E), 0.55)!
            : Color.lerp(look.skyHorizon, const Color(0xFFB4BCC4), 0.5)!;
        canvas.drawRect(
          rect,
          Paint()
            ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
              cloud.withValues(alpha: 0.72),
              cloud.withValues(alpha: 0.42),
            ]),
        );
      case WeatherKind.haze:
        final warm = Color.lerp(
          const Color(0xFFE6CC9C),
          look.skyHorizon,
          0.4 + 0.5 * look.flood,
        )!;
        canvas.drawRect(
          rect,
          Paint()
            ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
              warm.withValues(alpha: 0.25),
              warm.withValues(alpha: 0.78),
            ]),
        );
    }
  }

  /// Heat haze over the ground: a warm shimmer, thickest at the far stand.
  void _heatHaze(Canvas canvas, Size size, double horizon) {
    if (spec.weather != WeatherKind.haze) return;
    final a = 1 - 0.6 * look.flood;
    const warm = Color(0xFFE8D2A6);
    canvas.drawRect(
      Rect.fromLTRB(0, horizon - 20, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, horizon - 20),
          Offset(0, size.height),
          [
            warm.withValues(alpha: 0.3 * a),
            warm.withValues(alpha: 0.1 * a),
            warm.withValues(alpha: 0),
          ],
          const [0, 0.35, 1],
        ),
    );
  }

  // --- The fans' show --------------------------------------------------------

  CrowdShow get _homeShow =>
      CrowdShow.of(spec.homeCulture, isFinal: dressing.isFinal);
  CrowdShow get _awayShow =>
      CrowdShow.of(spec.awayCulture, isFinal: dressing.isFinal);

  /// The colours a side's fans show: its kit colour and white (the ground
  /// nation's two colours for the home side at its own ground).
  (Color, Color) _showColours(bool away) {
    if (away) return (spec.awayColour, const Color(0xFFF2F2EE));
    final g = spec.groundColours;
    if (!spec.neutral && g != null) {
      return (g.$1, KitColors.tooClose(g.$1, g.$2) ? Colors.white : g.$2);
    }
    return (spec.homeColour, const Color(0xFFF2F2EE));
  }

  void _paintShows(Canvas canvas) {
    final grade = Color.lerp(
      const Color(0xFFFFFFFF),
      look.grade,
      1 - 0.5 * look.flood,
    )!;
    final graded = grade != const Color(0xFFFFFFFF);
    if (graded) {
      canvas.saveLayer(
        null,
        Paint()..colorFilter = ColorFilter.mode(grade, BlendMode.modulate),
      );
    }
    final flares = <(Offset, double)>[];
    for (final s in _order) {
      final tiers = _tiersOf(s);
      for (var k = 0; k < tiers; k++) {
        final t = _isTerraceEnd(s) ? _terrace : _tierOf(s, k);
        final visible = k == tiers - 1 || _isTerraceEnd(s) ? 1.0 : 0.7;
        _blockShow(canvas, s, t, k, visible, flares);
      }
    }
    if (graded) canvas.restore();
    // The flares give off their own light.
    for (final (c, r) in flares) {
      canvas
        ..drawCircle(
          c,
          r * 3.2,
          Paint()
            ..blendMode = BlendMode.screen
            ..color = const Color(0xFFFF6A2C).withValues(alpha: 0.55)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.6),
        )
        ..drawCircle(
          c,
          r * 1.1,
          Paint()..color = const Color(0xFFFF8A3A).withValues(alpha: 0.95),
        )
        ..drawCircle(c, r * 0.5, Paint()..color = const Color(0xFFFFF1C9));
    }
  }

  /// One tier's block of [s]: each side's fans their own show, where they
  /// sit.
  void _blockShow(
    Canvas canvas,
    _Seg s,
    ({double o0, double z0, double o1, double z1}) t,
    int k,
    double visible,
    List<(Offset, double)> flares,
  ) {
    final len = _segLength(s);
    final rnd = math.Random(
      varietySeed('show:${spec.flagCode}:${s.name}:$k:${spec.tiers}'),
    );
    Offset seat(double u, double v, double up) => _standPoint(
      s,
      u,
      t.o0 + (t.o1 - t.o0) * v,
      t.z0 + (t.z1 - t.z0) * v + up,
    );
    double ppmAt(double u) => _ppm(_segY(s, u, (t.o0 + t.o1) / 2));

    // A tifo covers the far stand (and the away end), whole tiers at once.
    if (_homeShow == CrowdShow.tifo || _awayShow == CrowdShow.tifo) {
      _tifo(canvas, s, t, k, visible, seat);
      return;
    }

    // Scarves: one in every seat taken, held up over the head.
    final scarfStep = 1.1 / len;
    final rows = math.max(2, ((t.o1 - t.o0) * visible / 1.4).round());
    for (var r = 0; r < rows; r++) {
      final v = (r + 0.5) / rows * visible;
      for (var u = scarfStep * rnd.nextDouble(); u < 1; u += scarfStep) {
        final away = _awayChance(s, u) > rnd.nextDouble();
        if ((away ? _awayShow : _homeShow) != CrowdShow.scarves) continue;
        if (rnd.nextDouble() > spec.fill * 0.9) continue;
        final (c1, c2) = _showColours(away);
        final ppm = ppmAt(u);
        final c = seat(u, v, 2);
        final w = ppm * 1.7;
        final h = math.max(1.2, ppm * 0.45);
        // Held taut between two hands: five bars, the colours in turn.
        for (var b = 0; b < 5; b++) {
          canvas.drawRect(
            Rect.fromLTWH(c.dx - w / 2 + b * w / 5, c.dy - h / 2, w / 5, h),
            Paint()..color = b.isEven ? CrowdPainter.shirtTone(c1) : c2,
          );
        }
      }
    }

    // Flares, and the smoke drifting off them.
    final flareStep = 9 / len;
    for (var u = flareStep * rnd.nextDouble(); u < 1; u += flareStep) {
      final away = _awayChance(s, u) > 0.5;
      if ((away ? _awayShow : _homeShow) != CrowdShow.flares) continue;
      if (rnd.nextDouble() > 0.75) continue;
      final v = rnd.nextDouble() * visible * 0.8;
      final ppm = ppmAt(u);
      final c = seat(u, v, 1.9);
      for (var i = 0; i < 5; i++) {
        final up = 2.5 + i * 2.6;
        final drift = Offset(ppm * (0.8 + i * 1.3), 0);
        canvas.drawCircle(
          seat(u, v, 1.9 + up) + drift,
          ppm * (1.1 + i * 0.7),
          Paint()
            ..color = const Color(
              0xFFB9B4B0,
            ).withValues(alpha: 0.34 - i * 0.05)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, ppm * (0.8 + i)),
        );
      }
      flares.add((c, math.max(1, ppm * 0.42)));
    }

    // Drums and dancing in the front rows.
    if (k == 0) {
      final drumStep = 7 / len;
      for (var u = drumStep * rnd.nextDouble(); u < 1; u += drumStep) {
        final away = _awayChance(s, u) > 0.5;
        if ((away ? _awayShow : _homeShow) != CrowdShow.drums) continue;
        final (c1, _) = _showColours(away);
        final ppm = ppmAt(u);
        final arm = Paint()
          ..strokeWidth = math.max(0.6, ppm * 0.16)
          ..strokeCap = StrokeCap.round
          ..color = CrowdPainter.shirtTone(c1);
        for (var d = 0; d < 4; d++) {
          final du = (d - 1.5) * 0.7 / len;
          final head = seat(u + du, 0.25 + 0.15 * (d % 2), 1.55);
          final lean = (rnd.nextDouble() - 0.5) * ppm * 0.5;
          canvas
            ..drawLine(
              head,
              head.translate(-ppm * 0.35 + lean, -ppm * 0.75),
              arm,
            )
            ..drawLine(
              head,
              head.translate(ppm * 0.35 + lean, -ppm * 0.75),
              arm,
            );
        }
        final drum = seat(u, 0.08, 0.9);
        final r = math.max(1.2, ppm * 0.45);
        canvas
          ..drawOval(
            Rect.fromCenter(center: drum, width: r * 2, height: r * 2.2),
            Paint()..color = const Color(0xFF6B4528),
          )
          ..drawOval(
            Rect.fromCenter(
              center: drum.translate(0, -r * 0.9),
              width: r * 2,
              height: r * 0.8,
            ),
            Paint()..color = const Color(0xFFE6DCC6),
          );
      }
    }
  }

  /// A tifo: an abstract pattern in the side's colours over the whole
  /// stand, picked by the ground. No words, no emblems.
  void _tifo(
    Canvas canvas,
    _Seg s,
    ({double o0, double z0, double o1, double z1}) t,
    int k,
    double visible,
    Offset Function(double u, double v, double up) seat,
  ) {
    final tiers = _tiersOf(s);
    final nu = math.max(6, (_segLength(s) / 1.2).round());
    const nv = 8;
    final pattern = varietySeed('tifo:${spec.flagCode}:${spec.tiers}') % 5;
    for (var i = 0; i < nu; i++) {
      final u0 = i / nu;
      final u1 = (i + 1) / nu;
      final um = (u0 + u1) / 2;
      // Whose stand: at a neutral final each side holds up its half.
      final away = spec.neutral
          ? (s == _Seg.far ? um >= 0.5 : _awayChance(s, um) >= 0.5)
          : _awayChance(s, um) >= 0.5;
      if ((away ? _awayShow : _homeShow) != CrowdShow.tifo) continue;
      final (c1, c2) = _showColours(away);
      // The pattern is laid out over the side's own share of the stand.
      final x = s == _Seg.far && spec.neutral
          ? (away ? (um - 0.5) * 2 : um * 2)
          : um;
      for (var j = 0; j < nv; j++) {
        final v0 = j / nv * visible;
        final v1 = (j + 1) / nv * visible;
        // Up the stand, over all its tiers: 0 at the front, 1 at the back.
        final y = (k + (j + 0.5) / nv) / tiers;
        final first = switch (pattern) {
          0 => (x * 7 + y * 2.5).floor().isEven,
          1 => ((x - 0.5).abs() * 9 - y * 3).floor().isEven,
          2 => (math.atan2(x - 0.5, y + 0.25) / math.pi * 12).floor().isEven,
          3 => ((x * 8).floor() + (y * 3).floor()).isEven,
          _ => (y * 3 + math.sin(x * math.pi * 4) * 0.45).floor().isEven,
        };
        canvas.drawPath(
          StadiumPainter._poly([
            seat(u0, v0, 1.3),
            seat(u1, v0, 1.3),
            seat(u1, v1, 1.3),
            seat(u0, v1, 1.3),
          ]),
          Paint()
            ..isAntiAlias = false
            ..color = CrowdPainter.shirtTone(first ? c1 : c2),
        );
      }
    }
  }
}
