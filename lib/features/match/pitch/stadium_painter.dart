import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/backdrop_painter.dart';
import 'package:fnm/features/match/pitch/crowd_painter.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';

/// The ground the Pitch view plays in, drawn once per look: the sky and the
/// land behind it, the stands and their crowd, the boards, the grass with
/// its mowing, the markings and the goals, under one moment's [light] and
/// dressed for the occasion ([dressing]).
///
/// Nothing here moves, so the Pitch view bakes it ([bake], or the three key
/// looks at once with `StadiumLooks`) and paints only the players and the
/// ball over it each frame.
///
/// Everything is laid out in pitch metres and put on screen through the same
/// [PitchProjection] the players use, so a token on the touchline sits on
/// the painted touchline. The stands are the one licence taken: their depth
/// away from the pitch is drawn shallower than it is ([_farDepthScale]),
/// or the far stand of a big ground would run straight off a phone.
class StadiumPainter extends CustomPainter {
  StadiumPainter(
    this.spec,
    this.projection, {
    this.flag,
    this.light = PitchLight.day,
    this.dressing = MatchDressing.none,
  }) : look = SceneLook.at(light);

  final StadiumSpec spec;
  final PitchProjection projection;

  /// The ground nation's flag, rasterised by [rasterFlag]. Null draws the
  /// roof poles bare.
  final ui.Image? flag;
  final PitchLight light;
  final MatchDressing dressing;
  final SceneLook look;

  // --- The ground's plan, in metres -----------------------------------------

  /// Grass beyond the touchlines and beyond the goal lines.
  static const double _runOffSide = 3.5, _runOffEnd = 4.5;
  static const double _boardHeight = 0.9;

  /// The concourse between the boards and the front row.
  static const double _apron = 1.8;

  /// One tier in plan, the part of it the next tier up hangs over, how
  /// steeply it climbs and the fascia between two tiers.
  static const double _tierDepth = 8, _overhang = 2.2, _rake = 0.58;
  static const double _fascia = 2.2, _frontWall = 1.1;
  static const double _roofWall = 2.4, _canopy = 3.0;

  /// How much of a stand's real depth is drawn: the far stand shallow (see
  /// the class comment), the ends behind the goals nearer their true depth,
  /// since there is room for them across the frame.
  static const double _farDepthScale = 0.26, _endDepthScale = 0.8;

  /// How much of a stand's real height is drawn.
  static const double _standRise = 0.85;

  /// How far the end stands run on past the near touchline, toward the
  /// camera, so the frame's bottom corners are stands and not ground.
  static const double _nearRun = 14;

  /// A small ground's end terraces: shallow, low and open to the sky.
  static const double _terraceDepth = 5, _terraceRake = 0.42;

  /// The four floodlight towers, just off the pitch's corners.
  static const List<(double, double)> towers = [
    (-13, -11),
    (PitchDims.length + 13, -11),
    (-13, PitchDims.width + 11),
    (PitchDims.length + 13, PitchDims.width + 11),
  ];

  // --- Palette ----------------------------------------------------------------

  /// Mowing: a muted, slightly grey green that sits on the near-black canvas
  /// instead of glowing on it, and a shade darker for the cut the other way.
  static const Color _grassA = Color(0xFF2F5638);
  static const Color _grassB = Color(0xFF284A31);
  static const Color _lines = Color(0xFFDDE3DF);

  /// The verge between the boards and the stands, and the concrete edge in
  /// front of the front row.
  static const Color _verge = Color(0xFF24422C);
  static const Color _concrete = Color(0xFF2B2E31);
  static const Color _lampLight = Color(0xFFF4F0E2);

  // ---------------------------------------------------------------------------

  Offset _p(double x, double y, [double z = 0]) =>
      projection.toScreenOpen(x, y, z);

  double _ppm(double y) => projection.pxPerMetreAt(y);

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size);
    final top = _tier(spec.tiers - 1);
    final horizon = _standPoint(
      _Seg.far,
      0.5,
      top.o1,
      top.z1 + _roofWall * 0.6,
    ).dy;
    BackdropPainter(
      horizon: spec.horizon,
      city: spec.city,
      season: spec.season,
      landmark: spec.landmark,
      look: look,
      seed: '${spec.flagCode}:${spec.landmark.name}:${spec.tiers}',
    ).paint(canvas, size, horizon);

    // The built ground, graded for the light. The tiers and their crowd
    // are graded only part of the way: at night the floodlights light the
    // fans, while the roofs above them and the land outside go dark.
    final graded = look.grade != const Color(0xFFFFFFFF);
    void grade(Color c) {
      if (!graded) return;
      canvas.saveLayer(
        Offset.zero & size,
        Paint()..colorFilter = ColorFilter.mode(c, BlendMode.modulate),
      );
    }

    void ungrade() {
      if (graded) canvas.restore();
    }

    grade(look.grade);
    _apronGround(canvas);
    _towerMasts(canvas);
    ungrade();
    grade(
      Color.lerp(const Color(0xFFFFFFFF), look.grade, 1 - 0.5 * look.flood)!,
    );
    _standTiers(canvas);
    ungrade();
    grade(look.grade);
    _standRoofs(canvas);
    _boards(canvas, near: false);
    _grass(canvas);
    _standShadow(canvas);
    _markings(canvas);
    _dugouts(canvas);
    _photographers(canvas);
    _boards(canvas, near: true);
    ungrade();

    // The goals and the occasion's dressing catch the floodlights: graded
    // only half as far, so a final's gold still reads as gold at night.
    final half = Color.lerp(const Color(0xFFFFFFFF), look.grade, 0.45)!;
    canvas.saveLayer(
      Offset.zero & size,
      Paint()..colorFilter = ColorFilter.mode(half, BlendMode.modulate),
    );
    _edgeStripe(canvas);
    _boardBands(canvas);
    _goal(canvas, left: true);
    _goal(canvas, left: false);
    canvas.restore();

    // What gives off its own light, over the grade.
    _crowdGlow(canvas);
    _pools(canvas);
    _lamps(canvas);
    _flags(canvas);
    _nearShade(canvas, size);
    canvas.restore();
  }

  /// Renders the ground once, for the Pitch view to keep and blit.
  Future<ui.Image> bake(Size size, {double pixelRatio = 1}) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    paint(canvas, size);
    final picture = recorder.endRecording();
    return picture
        .toImage(
          (size.width * pixelRatio).ceil(),
          (size.height * pixelRatio).ceil(),
        )
        .whenComplete(picture.dispose);
  }

  /// A nation's flag from the bundled SVGs (the ones `CountryFlag` shows),
  /// as a small image for the roof poles. Null when the asset is missing.
  static Future<ui.Image?> rasterFlag(
    String code, {
    Size size = const Size(30, 20),
    double pixelRatio = 2,
  }) async {
    final path = 'assets/flags/${code.toLowerCase()}.svg';
    try {
      await rootBundle.load(path);
    } on Object {
      return null;
    }
    final info = await vg.loadPicture(SvgAssetLoader(path), null);
    try {
      final w = (size.width * pixelRatio).round();
      final h = (size.height * pixelRatio).round();
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      // Cover the box, cropped, as `CountryFlag` does.
      final k = math.max(w / info.size.width, h / info.size.height);
      canvas
        ..translate(
          (w - info.size.width * k) / 2,
          (h - info.size.height * k) / 2,
        )
        ..scale(k)
        ..drawPicture(info.picture);
      final pic = recorder.endRecording();
      final img = await pic.toImage(w, h);
      pic.dispose();
      return img;
    } finally {
      info.picture.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant StadiumPainter old) =>
      old.spec != spec ||
      old.flag != flag ||
      old.light != light ||
      old.dressing != dressing ||
      old.projection.viewport != projection.viewport ||
      old.projection.cam != projection.cam ||
      old.projection.tilt != projection.tilt;

  /// The verge from the boards to the stands, and a concrete edge in front
  /// of the front row all round. Beyond the stands (an open corner, the
  /// edges of the frame) the land behind the ground shows through.
  void _apronGround(Canvas canvas) {
    const l = PitchDims.length;
    canvas.drawPath(
      _poly([
        _p(-_endFront - 1, -_farFront - 1),
        _p(l + _endFront + 1, -_farFront - 1),
        _p(l + _endFront + 1, PitchDims.width + 30),
        _p(-_endFront - 1, PitchDims.width + 30),
      ]),
      Paint()..color = _verge,
    );
    for (final s in _segments) {
      canvas.drawPath(
        _band(
          (t) => _standPoint(s, t, -1.0, 0),
          (t) => _standPoint(s, t, 0, 0),
        ),
        Paint()..color = _concrete,
      );
    }
  }

  // --- Stands ---------------------------------------------------------------

  static const double _farFront = _runOffSide + _apron;
  static const double _endFront = _runOffEnd + _apron;

  /// A point [o] metres out from a stand's front row, at [t] (0 to 1) along
  /// [seg], [z] metres up.
  Offset _standPoint(_Seg seg, double t, double o, double z) {
    final df = o * _farDepthScale, de = o * _endDepthScale;
    final h = z * _standRise;
    const l = PitchDims.length, w = PitchDims.width + _nearRun;
    switch (seg) {
      case _Seg.left:
        return _p(-_endFront - de, w * (1 - t), h);
      case _Seg.far:
        return _p(l * t, -_farFront - df, h);
      case _Seg.right:
        return _p(l + _endFront + de, w * t, h);
      case _Seg.cornerLeft:
      case _Seg.cornerRight:
        final a = (seg == _Seg.cornerLeft ? t : 1 - t) * math.pi / 2;
        final rx = _endFront + de, ry = _farFront + df;
        final x = seg == _Seg.cornerLeft
            ? -rx * math.cos(a)
            : l + rx * math.cos(a);
        return _p(x, -ry * math.sin(a), h);
    }
  }

  List<_Seg> get _segments => spec.openCorners
      ? const [_Seg.left, _Seg.far, _Seg.right]
      : const [
          _Seg.left,
          _Seg.cornerLeft,
          _Seg.far,
          _Seg.cornerRight,
          _Seg.right,
        ];

  /// The stands in drawing order: the ends first, the far stand last.
  List<_Seg> get _order => [
    for (final s in _segments)
      if (s != _Seg.far) s,
    _Seg.far,
  ];

  double _segLength(_Seg s) => switch (s) {
    _Seg.left || _Seg.right => PitchDims.width + _nearRun,
    _Seg.far => PitchDims.length,
    _ => 14,
  };

  ({double o0, double z0, double o1, double z1}) _tier(int k) {
    final o0 = k * (_tierDepth - _overhang);
    final z0 = _frontWall + k * (_tierDepth * _rake + _fascia);
    return (o0: o0, z0: z0, o1: o0 + _tierDepth, z1: z0 + _tierDepth * _rake);
  }

  /// Which fans sit at [frac] along [s]. The travelling support has one end
  /// to itself, as at a real ground: the right-hand end from its far corner
  /// toward the camera, and only a big following spills round the corner
  /// into the far stand.
  bool _awayAt(_Seg s, double frac) {
    final total = _segments.fold<double>(0, (a, x) => a + _segLength(x));
    var left = total * spec.awayShare.clamp(0.0, 1.0);
    final end = _segLength(_Seg.right);
    if (s == _Seg.right) return frac * end < left;
    left -= end;
    if (!spec.openCorners) {
      if (s == _Seg.cornerRight) return (1 - frac) * 14 < left;
      left -= 14;
    }
    if (s == _Seg.far) return (1 - frac) * PitchDims.length < left;
    return false;
  }

  bool _isEnd(_Seg s) => s == _Seg.left || s == _Seg.right;

  /// A small ground's end terrace: one shallow, low step of standing fans.
  ({double o0, double z0, double o1, double z1}) get _terrace => (
    o0: 0,
    z0: _frontWall * 0.7,
    o1: _terraceDepth,
    z1: _frontWall * 0.7 + _terraceDepth * _terraceRake,
  );

  /// The tiers and their crowd, and a small ground's grass banks.
  void _standTiers(Canvas canvas) {
    final seats = _seatTone(spec.homeColour);
    final small = spec.tiers == 1;
    if (small) {
      _grassBank(canvas, _Seg.cornerLeft);
      _grassBank(canvas, _Seg.cornerRight);
    }
    final crowd = CrowdPainter(home: spec.homeColour, away: spec.awayColour);
    for (var k = 0; k < spec.tiers; k++) {
      final t = _tier(k);
      for (final s in _order) {
        final terrace = small && _isEnd(s);
        final tier = terrace ? _terrace : t;
        _frontWallOf(canvas, s, tier.o0, tier.z0, k);
        _tierBand(
          canvas,
          s,
          tier,
          k,
          seats: seats,
          crowd: crowd,
          terrace: terrace,
        );
      }
    }
  }

  /// The roofs over the stands, or a small ground's terrace rails.
  void _standRoofs(Canvas canvas) {
    final small = spec.tiers == 1;
    final top = _tier(spec.tiers - 1);
    for (final s in _order) {
      if (small && _isEnd(s)) {
        _terraceRail(canvas, s);
        continue;
      }
      _roof(canvas, s, top.o1, top.z1);
    }
  }

  /// The chance a fan at [frac] along [s] follows the away side. At a home
  /// ground the travelling support has its end ([_awayAt]); at a neutral one
  /// each side leans to one end and the two mix along the sides.
  double _awayChance(_Seg s, double frac) {
    if (!spec.neutral) return _awayAt(s, frac) ? 1 : 0;
    final a = spec.awayShare.clamp(0.0, 1.0);
    return switch (s) {
      _Seg.left => a * 0.2,
      _Seg.right => 1 - (1 - a) * 0.2,
      _ => a,
    };
  }

  /// The plan depth ([PitchProjection] y) of a point [o] metres out from
  /// [seg]'s front row at [t] along it, for the scale there.
  double _segY(_Seg seg, double t, double o) {
    const w = PitchDims.width + _nearRun;
    switch (seg) {
      case _Seg.left:
        return w * (1 - t);
      case _Seg.right:
        return w * t;
      case _Seg.far:
        return -_farFront - o * _farDepthScale;
      case _Seg.cornerLeft:
      case _Seg.cornerRight:
        final a = (seg == _Seg.cornerLeft ? t : 1 - t) * math.pi / 2;
        return -(_farFront + o * _farDepthScale) * math.sin(a);
    }
  }

  /// A grass bank in a small ground's open corner, rising away from the
  /// pitch, where a bigger ground would have its corner stand.
  void _grassBank(Canvas canvas, _Seg corner) {
    canvas.drawPath(
      _band(
        (t) => _standPoint(corner, t, -0.5, 0),
        (t) => _standPoint(corner, t, 9, 3.2),
      ),
      Paint()
        ..shader = ui.Gradient.linear(
          _standPoint(corner, 0.5, 0, 0),
          _standPoint(corner, 0.5, 9, 3.2),
          const [Color(0xFF2C4B33), Color(0xFF203626)],
        ),
    );
  }

  /// The crush barrier along the back of an end terrace.
  void _terraceRail(Canvas canvas, _Seg s) {
    final t = _terrace;
    canvas.drawPath(
      _line((u) => _standPoint(s, u, t.o1, t.z1 + 1.0)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = AppColors.outline.withValues(alpha: 0.7),
    );
  }

  /// A kit colour as a crowd reads from across a ground: the hue kept,
  /// pulled down into the dark canvas so the stands frame the pitch.
  static Color _crowdTone(Color kit) {
    final h = HSLColor.fromColor(kit);
    final l = (h.lightness * 0.5 + 0.1).clamp(0.16, 0.5);
    final s = (h.saturation * 0.62).clamp(0.0, 0.55);
    return h.withLightness(l).withSaturation(s).toColor();
  }

  /// The seats: near-black with a hint of the home side's colour, so an
  /// empty seat never passes for a fan.
  static Color _seatTone(Color kit) => Color.lerp(
    const Color(0xFF1C1F23),
    _crowdTone(kit),
    0.18,
  )!;

  void _frontWallOf(Canvas canvas, _Seg s, double o, double z, int k) {
    final h = k == 0 ? _frontWall : _fascia;
    canvas
      ..drawPath(
        _band(
          (t) => _standPoint(s, t, o, z - h),
          (t) => _standPoint(s, t, o, z),
        ),
        Paint()
          ..color = k == 0
              ? AppColors.surfaceContainer
              : AppColors.surfaceContainerHigh,
      )
      ..drawPath(
        _line((t) => _standPoint(s, t, o, z)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = k == 0 ? 0.6 : 0.9
          ..color = AppColors.primary.withValues(alpha: k == 0 ? 0.22 : 0.40),
      );
  }

  Path _tierPath(_Seg s, ({double o0, double z0, double o1, double z1}) t) =>
      _band(
        (u) => _standPoint(s, u, t.o0, t.z0),
        (u) => _standPoint(s, u, t.o1, t.z1),
      );

  void _tierBand(
    Canvas canvas,
    _Seg s,
    ({double o0, double z0, double o1, double z1}) t,
    int k, {
    required Color seats,
    required CrowdPainter crowd,
    required bool terrace,
  }) {
    final band = _tierPath(s, t);
    canvas.drawPath(band, Paint()..color = seats);
    // Faint seat rows, showing where the crowd is thin.
    const rows = 8;
    final rowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.black.withValues(alpha: 0.22);
    for (var r = 1; r < rows; r++) {
      final f = r / rows;
      canvas.drawPath(
        _line(
          (u) => _standPoint(
            s,
            u,
            t.o0 + (t.o1 - t.o0) * f,
            t.z0 + (t.z1 - t.z0) * f,
          ),
        ),
        rowPaint,
      );
    }
    final top = k == spec.tiers - 1;
    final fans = crowd.build(
      CrowdBlock(
        at: (u, v, up) => _standPoint(
          s,
          u,
          t.o0 + (t.o1 - t.o0) * v,
          t.z0 + (t.z1 - t.z0) * v + up,
        ),
        pxPerMetre: (u) => _ppm(_segY(s, u, (t.o0 + t.o1) / 2)),
        lengthMetres: _segLength(s),
        depthMetres: t.o1 - t.o0,
        // The back rows of a lower tier are under the one above.
        visibleDepth: top || terrace
            ? 1
            : (_tierDepth - _overhang) / _tierDepth,
        fill: spec.fill,
        awayChance: (u) => _awayChance(s, u),
        standing: terrace,
        seed: '${spec.flagCode}:${spec.tiers}:$k:${s.name}',
      ),
    );
    if (fans != null) {
      canvas
        ..save()
        ..clipPath(band)
        ..drawVertices(fans, BlendMode.dst, Paint())
        ..restore();
      fans.dispose();
    }
    // Light falls on the front rows; the back ones sit in the roof's shade.
    canvas.drawPath(
      band,
      Paint()
        ..shader = ui.Gradient.linear(
          _standPoint(s, 0.5, t.o0, t.z0),
          _standPoint(s, 0.5, t.o1, t.z1),
          [
            Colors.white.withValues(alpha: 0.04),
            Colors.black.withValues(alpha: 0.3 + 0.05 * k),
          ],
        ),
    );
  }

  /// At night the stands glow in their fans' colours, brightest on the front
  /// rows the floodlights catch: a wash over the lit crowd.
  void _crowdGlow(Canvas canvas) {
    final f = look.flood;
    if (f < 0.05) return;
    Color lit(Color kit) {
      final h = HSLColor.fromColor(kit);
      return h
          .withLightness(h.lightness.clamp(0.42, 0.62))
          .withSaturation((h.saturation * 0.85).clamp(0.0, 0.8))
          .toColor();
    }

    final home = lit(spec.homeColour), away = lit(spec.awayColour);
    for (var k = 0; k < spec.tiers; k++) {
      final t = _tier(k);
      for (final s in _order) {
        final n = math.max(6, (_segLength(s) / 3).round());
        for (var i = 0; i < n; i++) {
          final a = i / n, b = (i + 1) / n;
          final c = _awayChance(s, (a + b) / 2) >= 0.5 ? away : home;
          final front = _standPoint(s, (a + b) / 2, t.o0, t.z0);
          final back = _standPoint(s, (a + b) / 2, t.o1, t.z1);
          canvas.drawPath(
            _poly([
              _standPoint(s, a, t.o0, t.z0),
              _standPoint(s, b, t.o0, t.z0),
              _standPoint(s, b, t.o1, t.z1),
              _standPoint(s, a, t.o1, t.z1),
            ]),
            Paint()
              ..blendMode = BlendMode.screen
              ..isAntiAlias = false
              ..shader = ui.Gradient.linear(front, back, [
                c.withValues(alpha: 0.2 * f),
                c.withValues(alpha: 0.05 * f),
              ]),
          );
        }
      }
    }
  }

  void _roof(Canvas canvas, _Seg s, double o, double z) {
    canvas
      ..drawPath(
        _band(
          (t) => _standPoint(s, t, o, z),
          (t) => _standPoint(s, t, o, z + _roofWall),
        ),
        Paint()..color = AppColors.surfaceContainerLow,
      )
      ..drawPath(
        _band(
          (t) => _standPoint(s, t, o - _canopy, z + _roofWall),
          (t) => _standPoint(s, t, o - _canopy, z + _roofWall + 0.9),
        ),
        Paint()..color = AppColors.surfaceContainerHighest,
      )
      ..drawPath(
        _line((t) => _standPoint(s, t, o - _canopy, z + _roofWall + 0.9)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..color = (dressing.isFinal ? AppColors.medalGold : AppColors.primary)
              .withValues(alpha: 0.55),
      );
  }

  /// Floodlamps along each canopy and on the towers: grey and unlit by day,
  /// coming up through dusk, bright with a halo at night.
  void _lamps(Canvas canvas) {
    final top = _tier(spec.tiers - 1);
    for (final s in [
      _Seg.far,
      if (spec.tiers > 1) ...[_Seg.left, _Seg.right],
    ]) {
      final lamps = s == _Seg.far ? 9 : 5;
      for (var i = 0; i < lamps; i++) {
        final c = _standPoint(
          s,
          (i + 0.5) / lamps,
          top.o1 - _canopy,
          top.z1 + _roofWall + 0.2,
        );
        _lamp(canvas, c, _ppm(0) * 0.55);
      }
    }
    for (final (x, y) in towers.take(2)) {
      final head = _p(x, y, _towerHeight);
      final ppm = _ppm(y);
      final rect = Rect.fromCenter(
        center: head,
        width: ppm * 4.6,
        height: ppm * 2.0,
      );
      final f = look.flood;
      if (f > 0.05) {
        canvas.drawCircle(
          head,
          ppm * 7,
          Paint()
            ..color = _lampLight.withValues(alpha: 0.16 * f)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, ppm * 4),
        );
      }
      canvas
        ..drawRect(rect, Paint()..color = AppColors.surfaceContainerHighest)
        ..drawRect(
          rect.deflate(ppm * 0.35),
          Paint()
            ..color = Color.lerp(
              AppColors.outline,
              _lampLight,
              0.25 + 0.75 * f,
            )!.withValues(alpha: 0.6 + 0.4 * f),
        );
    }
  }

  void _lamp(Canvas canvas, Offset c, double r) {
    final f = look.flood;
    if (f > 0.05) {
      canvas.drawCircle(
        c,
        r * (2.6 + 2 * f),
        Paint()
          ..color = _lampLight.withValues(alpha: 0.18 * f)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * (1.6 + f)),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: r * 1.6, height: r * 0.8),
        Radius.circular(r * 0.2),
      ),
      Paint()
        ..color = Color.lerp(
          AppColors.outline,
          _lampLight,
          0.3 + 0.7 * f,
        )!.withValues(alpha: 0.55 + 0.4 * f),
    );
  }

  /// How tall the towers stand: a little over the roof.
  double get _towerHeight {
    final top = _tier(spec.tiers - 1);
    return top.z1 + _roofWall + 7;
  }

  /// The two far towers' masts (the near two stand behind the camera).
  void _towerMasts(Canvas canvas) {
    for (final (x, y) in towers.take(2)) {
      final ppm = _ppm(y);
      canvas.drawLine(
        _p(x, y),
        _p(x, y, _towerHeight),
        Paint()
          ..color = AppColors.outlineVariant
          ..strokeWidth = math.max(1.0, ppm * 0.45),
      );
    }
  }

  /// The ground nation's flags on poles along the far stand's roof, lit
  /// from below at night.
  void _flags(Canvas canvas) {
    final top = _tier(spec.tiers - 1);
    final o = top.o1 - 3.0, z = top.z1 + _roofWall + 0.9;
    // Clear of the middle, where a city's landmark rises.
    const poles = [0.08, 0.24, 0.76, 0.92];
    final ppm = _ppm(0);
    final poleH = 4.2 * ppm * projection.tilt * 1.6;
    final w = math.max(9.0, ppm * 3.4);
    final h = w * 2 / 3;
    final polePaint = Paint()
      ..color = AppColors.outline
      ..strokeWidth = math.max(0.8, ppm * 0.22);
    for (final t in poles) {
      final base = _standPoint(_Seg.far, t, o, z);
      final tip = base.translate(0, -poleH);
      canvas.drawLine(base, tip, polePaint);
      final img = flag;
      if (img == null) continue;
      final dst = Rect.fromLTWH(tip.dx, tip.dy, w, h);
      if (look.flood > 0.05) {
        canvas.drawRect(
          dst.inflate(w * 0.3),
          Paint()
            ..color = _lampLight.withValues(alpha: 0.12 * look.flood)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.35),
        );
      }
      // Dimmed with the light, never below what a lit flag shows.
      final shade = Color.lerp(
        Colors.white,
        look.grade,
        0.6 * (1 - look.flood),
      )!;
      canvas
        ..drawRect(
          dst.shift(const Offset(0.6, 0.8)),
          Paint()..color = Colors.black.withValues(alpha: 0.35),
        )
        ..drawImageRect(
          img,
          Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
          dst,
          Paint()
            ..filterQuality = FilterQuality.medium
            ..colorFilter = ColorFilter.mode(shade, BlendMode.modulate),
        );
    }
  }

  // --- Life between the pitch and the stands ---------------------------------

  /// The two dugouts in front of the far boards either side of halfway, the
  /// substitutes on their benches under a clear roof.
  void _dugouts(Canvas canvas) {
    const y0 = -3.3, y1 = -2.2;
    for (final (x0, x1, kit) in [
      (37.0, 46.0, spec.homeColour),
      (59.0, 68.0, spec.awayColour),
    ]) {
      final ppm = _ppm(y0);
      canvas.drawPath(
        _poly([_p(x0, y0), _p(x1, y0), _p(x1, y0, 1.5), _p(x0, y0, 1.5)]),
        Paint()..color = AppColors.surfaceContainerHigh,
      );
      // The bench: a row of seated men in their side's colours.
      final man = Paint()..color = _crowdTone(kit);
      for (var x = x0 + 0.8; x < x1 - 0.4; x += 1.1) {
        canvas.drawCircle(
          _p(x, y0 + 0.4, 0.75),
          math.max(0.9, ppm * 0.38),
          man,
        );
      }
      // The roof and its sides, clear with a steel edge.
      final glass = Paint()..color = Colors.white.withValues(alpha: 0.14);
      canvas
        ..drawPath(
          _poly([
            _p(x0, y0, 1.6),
            _p(x1, y0, 1.6),
            _p(x1, y1, 1.15),
            _p(x0, y1, 1.15),
          ]),
          glass,
        )
        ..drawPath(
          _poly([_p(x0, y0), _p(x0, y0, 1.6), _p(x0, y1, 1.15), _p(x0, y1)]),
          glass,
        )
        ..drawPath(
          _poly([_p(x1, y0), _p(x1, y0, 1.6), _p(x1, y1, 1.15), _p(x1, y1)]),
          glass,
        )
        ..drawLine(
          _p(x0, y1, 1.15),
          _p(x1, y1, 1.15),
          Paint()
            ..strokeWidth = math.max(0.7, ppm * 0.12)
            ..color = AppColors.primary.withValues(alpha: 0.6),
        );
    }
  }

  /// Photographers crouched along each goal line, either side of the goal,
  /// in their bibs.
  void _photographers(Canvas canvas) {
    const ys = [8.5, 11.5, 14.5, 18.0, 21.5, 46.5, 50.0, 53.5, 56.5, 59.5];
    const bib = Color(0xFF8E8A6A);
    for (final left in [true, false]) {
      final x = left ? -3.5 : PitchDims.length + 3.5;
      for (var i = 0; i < ys.length; i++) {
        final y = ys[i] + (i.isEven ? 0.4 : -0.3);
        final ppm = _ppm(y);
        final w = math.max(1.6, ppm * 0.7);
        final h = math.max(2.2, ppm * 1.0);
        final foot = _p(x, y);
        final body = Rect.fromLTWH(foot.dx - w / 2, foot.dy - h, w, h);
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(body, Radius.circular(w * 0.3)),
            Paint()..color = const Color(0xFF202427),
          )
          ..drawRect(
            Rect.fromLTWH(body.left, body.top + h * 0.15, w, h * 0.38),
            Paint()..color = bib,
          )
          ..drawCircle(
            Offset(foot.dx, body.top - w * 0.2),
            w * 0.32,
            Paint()..color = const Color(0xFF3A3532),
          )
          // The camera, a small dark block held to the face.
          ..drawRect(
            Rect.fromCenter(
              center: Offset(
                foot.dx + (left ? w * 0.25 : -w * 0.25),
                body.top - w * 0.12,
              ),
              width: w * 0.42,
              height: w * 0.3,
            ),
            Paint()..color = const Color(0xFF0E1012),
          );
      }
    }
  }

  // --- Ad boards -------------------------------------------------------------

  void _boards(Canvas canvas, {required bool near}) {
    const l = PitchDims.length, w = PitchDims.width;
    const xs0 = -_runOffEnd, xs1 = l + _runOffEnd;
    const ys0 = -_runOffSide, ys1 = w + _runOffSide;
    final runs = near
        ? [((xs0, ys1), (xs1, ys1))]
        : [
            ((xs0, ys1), (xs0, ys0)),
            ((xs1, ys1), (xs1, ys0)),
            ((xs0, ys0), (xs1, ys0)),
          ];
    const panel = 6.0;
    const tones = [
      AppColors.surfaceContainerHigh,
      Color(0xFF2E3237),
      AppColors.surfaceContainer,
    ];
    final accent = dressing.isFinal ? AppColors.medalGold : AppColors.primary;
    final band = dressing.dressed ? _dressTone(dressing.colour) : null;
    var n = 0;
    double lerp(double a, double b, double t) => a + (b - a) * t;
    for (final ((ax, ay), (bx, by)) in runs) {
      final len = math.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay));
      final count = (len / panel).ceil();
      for (var i = 0; i < count; i++, n++) {
        final f0 = i / count, f1 = (i + 1) / count;
        final x0 = lerp(ax, bx, f0), y0 = lerp(ay, by, f0);
        final x1 = lerp(ax, bx, f1), y1 = lerp(ay, by, f1);
        Path face(double z0, double z1) => _poly([
          _p(x0, y0, z0),
          _p(x1, y1, z0),
          _p(x1, y1, z1),
          _p(x0, y0, z1),
        ]);
        canvas.drawPath(
          face(0, _boardHeight),
          Paint()..color = tones[n % tones.length],
        );
        // No brand: a quiet bar where a name would be.
        final zb = band != null ? 0.26 : 0.42, zt = band != null ? 0.4 : 0.58;
        canvas.drawPath(
          _poly([
            _p(lerp(x0, x1, 0.3), lerp(y0, y1, 0.3), _boardHeight * zb),
            _p(lerp(x0, x1, 0.7), lerp(y0, y1, 0.7), _boardHeight * zb),
            _p(lerp(x0, x1, 0.7), lerp(y0, y1, 0.7), _boardHeight * zt),
            _p(lerp(x0, x1, 0.3), lerp(y0, y1, 0.3), _boardHeight * zt),
          ]),
          Paint()..color = accent.withValues(alpha: n.isEven ? 0.30 : 0.18),
        );
      }
      canvas.drawLine(
        _p(ax, ay, _boardHeight),
        _p(bx, by, _boardHeight),
        Paint()
          ..strokeWidth = 0.7
          ..color = accent.withValues(alpha: 0.4),
      );
    }
  }

  /// A finals tournament's band along the top of every board (gold at the
  /// final).
  void _boardBands(Canvas canvas) {
    if (!dressing.dressed) return;
    const l = PitchDims.length, w = PitchDims.width;
    const xs0 = -_runOffEnd, xs1 = l + _runOffEnd;
    const ys0 = -_runOffSide, ys1 = w + _runOffSide;
    final band = Paint()..color = _dressTone(dressing.colour);
    for (final ((ax, ay), (bx, by)) in [
      ((xs0, ys1), (xs0, ys0)),
      ((xs1, ys1), (xs1, ys0)),
      ((xs0, ys0), (xs1, ys0)),
      ((xs0, ys1), (xs1, ys1)),
    ]) {
      canvas.drawPath(
        _poly([
          _p(ax, ay, _boardHeight * 0.62),
          _p(bx, by, _boardHeight * 0.62),
          _p(bx, by, _boardHeight),
          _p(ax, ay, _boardHeight),
        ]),
        band,
      );
    }
  }

  /// A dressing colour as a board band or pitch stripe wears it: its hue,
  /// muted to the palette.
  static Color _dressTone(Color c) {
    final h = HSLColor.fromColor(c);
    return h
        .withLightness(h.lightness.clamp(0.36, 0.58))
        .withSaturation((h.saturation * 0.75).clamp(0.0, 0.7))
        .toColor();
  }

  // --- Grass and lines -------------------------------------------------------

  static const double _gx0 = -_runOffEnd, _gx1 = PitchDims.length + _runOffEnd;
  static const double _gy0 = -_runOffSide, _gy1 = PitchDims.width + _runOffSide;

  Path get _field => _metres([
    (_gx0, _gy0),
    (_gx1, _gy0),
    (_gx1, _gy1),
    (_gx0, _gy1),
  ], steps: 16);

  /// A shape given in pitch metres, its edges sampled so they follow the
  /// projection's curve.
  Path _metres(List<(double, double)> pts, {int steps = 16}) {
    final out = <Offset>[];
    for (var i = 0; i < pts.length; i++) {
      final (ax, ay) = pts[i];
      final (bx, by) = pts[(i + 1) % pts.length];
      for (var k = 0; k < steps; k++) {
        final t = k / steps;
        out.add(_p(ax + (bx - ax) * t, ay + (by - ay) * t));
      }
    }
    return _poly(out);
  }

  void _grass(Canvas canvas) {
    final field = _field;
    canvas
      ..drawPath(field, Paint()..color = _grassA)
      ..save()
      ..clipPath(field);
    final cut = Paint()..color = _grassB;
    const l = PitchDims.length, w = PitchDims.width;
    switch (spec.mowing) {
      case MowingPattern.stripes:
      case MowingPattern.wideBands:
        final n = spec.mowing == MowingPattern.stripes ? 20 : 10;
        final sw = l / n;
        for (var i = (_gx0 / sw).floor(); i < (_gx1 / sw).ceil(); i++) {
          if (i.isEven) continue;
          canvas.drawPath(
            _metres([
              (i * sw, _gy0),
              ((i + 1) * sw, _gy0),
              ((i + 1) * sw, _gy1),
              (i * sw, _gy1),
            ], steps: 2),
            cut,
          );
        }
      case MowingPattern.checkerboard:
        const nx = 14, ny = 9;
        const cw = l / nx, ch = w / ny;
        for (var i = -1; i <= nx; i++) {
          for (var j = -1; j <= ny; j++) {
            if ((i + j).isEven) continue;
            canvas.drawPath(
              _metres([
                (i * cw, j * ch),
                ((i + 1) * cw, j * ch),
                ((i + 1) * cw, (j + 1) * ch),
                (i * cw, (j + 1) * ch),
              ], steps: 2),
              cut,
            );
          }
        }
      case MowingPattern.diagonal:
        const bw = 7.0;
        for (var k = -14; k < 20; k++) {
          if (k.isEven) continue;
          final c0 = k * bw, c1 = (k + 1) * bw;
          // The band where x - y runs from c0 to c1.
          canvas.drawPath(
            _metres([
              (c0 + _gy0, _gy0),
              (c1 + _gy0, _gy0),
              (c1 + _gy1, _gy1),
              (c0 + _gy1, _gy1),
            ]),
            cut,
          );
        }
      case MowingPattern.circles:
        const ring = 6.0;
        for (var k = 1; k < 14; k += 2) {
          final path = _circleM(l / 2, w / 2, (k + 1) * ring)
            ..addPath(_circleM(l / 2, w / 2, k * ring), Offset.zero)
            ..fillType = PathFillType.evenOdd;
          canvas.drawPath(path, cut);
        }
    }
    canvas
      ..restore()
      // Light falls off toward the far side and toward both ends, so the
      // middle of the playing surface reads as the brightest thing there.
      ..drawPath(
        field,
        Paint()
          ..shader = ui.Gradient.linear(
            _p(l / 2, _gy0),
            _p(l / 2, _gy1),
            [
              Colors.black.withValues(alpha: 0.26),
              Colors.black.withValues(alpha: 0.0),
              Colors.white.withValues(alpha: 0.025),
            ],
            const [0, 0.55, 1],
          ),
      )
      ..drawPath(
        field,
        Paint()
          ..shader = ui.Gradient.linear(
            _p(_gx0, w / 2),
            _p(_gx1, w / 2),
            [
              Colors.black.withValues(alpha: 0.20),
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.20),
            ],
            const [0, 0.14, 0.86, 1],
          ),
      );
  }

  Path _circleM(double cx, double cy, double r, {int n = 72}) => _poly([
    for (var i = 0; i < n; i++)
      _p(
        cx + r * math.cos(2 * math.pi * i / n),
        cy + r * math.sin(2 * math.pi * i / n),
      ),
  ]);

  /// The far stand's shadow on the grass: a strip by the far touchline in a
  /// high sun, the whole pitch as the sun goes down.
  void _standShadow(Canvas canvas) {
    final e = light.elevation;
    final alpha = 0.22 * (1 - look.flood);
    if (alpha < 0.01) return;
    final top = _tier(spec.tiers - 1);
    final height = top.z1 + _roofWall;
    final reach = e <= 1
        ? 120.0
        : math.min(120.0, height * 0.5 / math.tan(e * math.pi / 180));
    final skew = reach * 0.3;
    canvas
      ..save()
      ..clipPath(_field)
      ..drawPath(
        _metres([
          (_gx0 - 20, _gy0 - 1),
          (_gx1 + 20, _gy0 - 1),
          (_gx1 + 20 + skew, _gy0 + reach),
          (_gx0 - 20 + skew, _gy0 + reach),
        ]),
        Paint()..color = const Color(0xFF0B1A12).withValues(alpha: alpha),
      )
      ..restore();
  }

  /// A finals tournament's stripe round the pitch, between the lines and the
  /// boards: the competition's colour, or gold at the final.
  void _edgeStripe(Canvas canvas) {
    if (!dressing.dressed) return;
    const a = 1.4, b = 2.3;
    const l = PitchDims.length, w = PitchDims.width;
    final ring = _metres([(-b, -b), (l + b, -b), (l + b, w + b), (-b, w + b)])
      ..addPath(
        _metres([(-a, -a), (l + a, -a), (l + a, w + a), (-a, w + a)]),
        Offset.zero,
      )
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      ring,
      Paint()
        ..color = _dressTone(
          dressing.colour,
        ).withValues(alpha: dressing.isFinal ? 0.8 : 0.6),
    );
  }

  /// The floodlights' pools on the grass, one from each corner tower.
  void _pools(Canvas canvas) {
    final f = look.flood;
    if (f < 0.05) return;
    const c = PitchDims.centre;
    canvas
      ..save()
      ..clipPath(_field);
    for (final (tx, ty) in towers) {
      final px = tx + (c.x - tx) * 0.42, py = ty + (c.y - ty) * 0.42;
      final centre = _p(px, py);
      final radius = (_p(px + 46, py).dx - centre.dx).abs();
      canvas.drawPath(
        _circleM(px, py, 46),
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = ui.Gradient.radial(centre, radius, [
            const Color(0xFFFFF4DC).withValues(alpha: 0.24 * f),
            const Color(0xFFFFF4DC).withValues(alpha: 0.0),
          ]),
      );
    }
    canvas.restore();
  }

  void _markings(Canvas canvas) {
    const l = PitchDims.length, w = PitchDims.width;
    const box = PitchDims.boxDepth, boxH = PitchDims.boxHalfWidth;
    const six = 5.5, sixH = PitchDims.goalHalfWidth + 5.5;
    const spot = 11.0, arcR = 9.15;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..color = _lines.withValues(alpha: 0.78);
    void stroke(Path path, double atY) {
      paint.strokeWidth = math.max(1.0, 0.12 * _ppm(atY));
      canvas.drawPath(path, paint);
    }

    // Every line is sampled along its length: under the tilt a line
    // across the pitch (a goal line, a box's side) is a gentle curve on
    // screen, not the chord between its ends. Drawn as a chord, the goal
    // line missed the goal mouth by a metre or two.
    Path pts(List<(double, double)> ps, {bool close = false}) {
      final all = [...ps, if (close) ps.first];
      final out = <Offset>[];
      for (var i = 0; i + 1 < all.length; i++) {
        final (ax, ay) = all[i];
        final (bx, by) = all[i + 1];
        const steps = 16;
        for (var k = 0; k < steps; k++) {
          final t = k / steps;
          out.add(_p(ax + (bx - ax) * t, ay + (by - ay) * t));
        }
      }
      final (lx, ly) = all.last;
      out.add(_p(lx, ly));
      return _poly(out, close: close);
    }

    Path curve(double cx, double cy, double r, double a0, double a1) {
      final path = Path();
      const n = 48;
      for (var i = 0; i <= n; i++) {
        final a = a0 + (a1 - a0) * i / n;
        final o = _p(cx + r * math.cos(a), cy + r * math.sin(a));
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      return path;
    }

    stroke(pts([(0, 0), (l, 0), (l, w), (0, w)], close: true), w / 2);
    stroke(pts([(l / 2, 0), (l / 2, w)]), w / 2);
    stroke(curve(l / 2, w / 2, arcR, 0, 2 * math.pi), w / 2);
    for (final left in [true, false]) {
      double x(double d) => left ? d : l - d;
      stroke(
        pts([
          (x(0), w / 2 - boxH),
          (x(box), w / 2 - boxH),
          (x(box), w / 2 + boxH),
          (x(0), w / 2 + boxH),
        ]),
        w / 2,
      );
      stroke(
        pts([
          (x(0), w / 2 - sixH),
          (x(six), w / 2 - sixH),
          (x(six), w / 2 + sixH),
          (x(0), w / 2 + sixH),
        ]),
        w / 2,
      );
      final half = math.acos((box - spot) / arcR);
      stroke(
        left
            ? curve(x(spot), w / 2, arcR, -half, half)
            : curve(x(spot), w / 2, arcR, math.pi - half, math.pi + half),
        w / 2,
      );
      _spot(canvas, _p(x(spot), w / 2), w / 2);
      stroke(
        left
            ? curve(0, 0, 1, 0, math.pi / 2)
            : curve(l, 0, 1, math.pi / 2, math.pi),
        0,
      );
      stroke(
        left
            ? curve(0, w, 1, -math.pi / 2, 0)
            : curve(l, w, 1, math.pi, 1.5 * math.pi),
        w,
      );
    }
    _spot(canvas, _p(l / 2, w / 2), w / 2);
  }

  void _spot(Canvas canvas, Offset c, double atY) {
    final r = math.max(1.1, 0.22 * _ppm(atY));
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 2, height: r * 1.5),
      Paint()..color = _lines.withValues(alpha: 0.85),
    );
  }

  // --- Goals -----------------------------------------------------------------

  /// Each style's net in profile, from the crossbar back and down to the
  /// ground: (metres behind the line, metres up). The mouth itself is the
  /// same for all of them.
  static List<(double, double)> profileOf(GoalStyle s) => switch (s) {
    GoalStyle.boxNet => const [
      (0, PitchDims.crossbarHeight),
      (2.6, PitchDims.crossbarHeight),
      (2.6, 0),
    ],
    GoalStyle.sloped => const [
      (0, PitchDims.crossbarHeight),
      (0.9, PitchDims.crossbarHeight - 0.1),
      (2.2, 0),
    ],
    GoalStyle.square => const [
      (0, PitchDims.crossbarHeight),
      (1.5, PitchDims.crossbarHeight - 0.24),
      (1.5, 0),
    ],
    GoalStyle.oldGround => const [(0, PitchDims.crossbarHeight), (1.3, 0)],
  };

  void _goal(Canvas canvas, {required bool left}) {
    const w = PitchDims.width, half = PitchDims.goalHalfWidth;
    const bar = PitchDims.crossbarHeight;
    final style = spec.goalStyle;
    final profile = profileOf(style);
    final dir = left ? -1.0 : 1.0;
    final x0 = left ? 0.0 : PitchDims.length;
    double bx(double d) => x0 + dir * d;
    const yf = w / 2 - half, yn = w / 2 + half;
    final net = Paint()..color = Colors.white.withValues(alpha: 0.07);
    final mesh = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.24);
    // Side panels: the profile closed down to the goal line.
    for (final y in [yf, yn]) {
      canvas.drawPath(
        _poly([
          _p(x0, y),
          for (final (d, z) in profile) _p(bx(d), y, z),
        ]),
        net,
      );
    }
    // The panels across the goal, between profile points.
    for (var i = 0; i + 1 < profile.length; i++) {
      final (da, za) = profile[i];
      final (db, zb) = profile[i + 1];
      canvas.drawPath(
        _poly([
          _p(bx(da), yf, za),
          _p(bx(da), yn, za),
          _p(bx(db), yn, zb),
          _p(bx(db), yf, zb),
        ]),
        net,
      );
    }
    // Mesh: along the profile at intervals across the goal, and across the
    // back at intervals up it.
    const cells = 10;
    for (var i = 0; i <= cells; i++) {
      final y = yf + (yn - yf) * i / cells;
      canvas.drawPath(
        _poly([
          for (final (d, z) in profile) _p(bx(d), y, z),
        ], close: false),
        mesh,
      );
    }
    final (dl, _) = profile.last;
    final (dp, zp) = profile[profile.length - 2];
    for (var j = 1; j < 4; j++) {
      final f = j / 4;
      final d = dl + (dp - dl) * f, z = zp * f;
      canvas.drawLine(_p(bx(d), yf, z), _p(bx(d), yn, z), mesh);
    }
    final ppm = _ppm(w / 2);
    final gold = dressing.isFinal;
    final old = style == GoalStyle.oldGround;
    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(old ? 1.7 : 1.4, (old ? 0.17 : 0.14) * ppm)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = gold
          ? AppColors.medalGold
          : old
          ? const Color(0xFFE6E0CF)
          : const Color(0xFFF2F4F3);
    // Supports behind the mouth: tall stanchions for a box net, a bent bar
    // for a European one, a back post for a square one, a ground frame for
    // an old goal.
    final support = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.9, 0.08 * ppm)
      ..color = (gold ? AppColors.medalGold : AppColors.onSurfaceVariant)
          .withValues(alpha: 0.8);
    for (final y in [yf, yn]) {
      switch (style) {
        case GoalStyle.boxNet:
          canvas
            ..drawLine(_p(bx(2.6), y), _p(bx(2.6), y, bar), support)
            ..drawLine(_p(bx(0), y, bar), _p(bx(2.6), y, bar), support);
        case GoalStyle.sloped:
          canvas.drawPath(
            _poly([
              _p(bx(0), y, bar),
              _p(bx(0.9), y, bar - 0.1),
              _p(bx(2.2), y),
            ], close: false),
            support,
          );
        case GoalStyle.square:
          canvas.drawLine(_p(bx(1.5), y), _p(bx(1.5), y, bar - 0.24), support);
        case GoalStyle.oldGround:
          canvas.drawLine(_p(bx(0), y), _p(bx(1.3), y), support);
      }
    }
    switch (style) {
      case GoalStyle.boxNet:
        canvas.drawLine(_p(bx(2.6), yf, bar), _p(bx(2.6), yn, bar), support);
      case GoalStyle.oldGround:
        canvas.drawLine(_p(bx(1.3), yf), _p(bx(1.3), yn), support);
      case GoalStyle.sloped:
      case GoalStyle.square:
        break;
    }
    canvas.drawPath(
      _poly(goalMouth(projection, left: left), close: false),
      frame,
    );
  }

  /// The goal mouth's frame on screen, on the goal line itself: the far
  /// post's foot and top, the near post's top and foot. Posts at
  /// 34 ± 3.66 m, the bar 2.44 m up ([PitchDims]), the same mouth the
  /// staging judges a ball in the net by. The net runs back from it, off
  /// the pitch.
  static List<Offset> goalMouth(
    PitchProjection projection, {
    required bool left,
  }) {
    const w = PitchDims.width, half = PitchDims.goalHalfWidth;
    const bar = PitchDims.crossbarHeight;
    final x0 = left ? 0.0 : PitchDims.length;
    const yf = w / 2 - half, yn = w / 2 + half;
    return [
      projection.toScreenOpen(x0, yf),
      projection.toScreenOpen(x0, yf, bar),
      projection.toScreenOpen(x0, yn, bar),
      projection.toScreenOpen(x0, yn),
    ];
  }

  void _nearShade(Canvas canvas, Size size) {
    final top = size.height * 0.94;
    canvas.drawRect(
      Rect.fromLTRB(0, top, size.width, size.height),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, top),
          Offset(0, size.height),
          [AppColors.surface.withValues(alpha: 0), AppColors.surface],
        ),
    );
  }

  // --- Path helpers ------------------------------------------------------------

  static Path _poly(List<Offset> pts, {bool close = true}) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final o in pts.skip(1)) {
      path.lineTo(o.dx, o.dy);
    }
    if (close) path.close();
    return path;
  }

  static Path _line(Offset Function(double t) f, {int n = 24}) {
    final path = Path();
    for (var i = 0; i <= n; i++) {
      final o = f(i / n);
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
    }
    return path;
  }

  static Path _band(
    Offset Function(double t) a,
    Offset Function(double t) b, {
    int n = 24,
  }) => _poly([
    for (var i = 0; i <= n; i++) a(i / n),
    for (var i = n; i >= 0; i--) b(i / n),
  ]);
}

enum _Seg { left, cornerLeft, far, cornerRight, right }
