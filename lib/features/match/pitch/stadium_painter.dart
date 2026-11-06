import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';

/// The ground the Pitch view plays in, drawn once: grass and markings, the
/// two goals, the ad boards and the stands with their crowd, in the app's
/// dark palette.
///
/// Nothing here moves, so the Pitch view [bake]s it to an image once and
/// paints only the players and the ball over it each frame.
///
/// Everything is laid out in pitch metres and put on screen through the same
/// [PitchProjection] the players use, so a disc on the touchline sits on the
/// painted touchline. The stands are the one licence taken: their depth away
/// from the pitch is drawn shallower than it is ([_standDepthScale]), or the
/// far stand of a big ground would run straight off the top of a phone.
class StadiumPainter extends CustomPainter {
  StadiumPainter(this.spec, this.projection, {this.flag});

  final StadiumSpec spec;
  final PitchProjection projection;

  /// The ground nation's flag, rasterised by [rasterFlag]. Null draws the
  /// roof poles bare.
  final ui.Image? flag;

  // --- The ground's plan, in metres -----------------------------------------

  /// Grass beyond the touchlines and beyond the goal lines.
  static const double _runOffSide = 3.5, _runOffEnd = 4.5;

  /// The ad boards' height.
  static const double _boardHeight = 0.9;

  /// The concourse between the boards and the front row.
  static const double _apron = 1.8;

  /// One tier in plan, the part of it the next tier up hangs over, how
  /// steeply it climbs and the fascia between two tiers.
  static const double _tierDepth = 8, _overhang = 2.2, _rake = 0.58;
  static const double _fascia = 2.2, _frontWall = 1.1;

  /// How much of a stand's real depth is drawn. See the class comment.
  static const double _standDepthScale = 0.36;

  // --- Palette ----------------------------------------------------------------

  /// Mowing stripes: a muted, slightly grey green that sits on the near-black
  /// canvas instead of glowing on it.
  static const Color _grassA = Color(0xFF2F5638);
  static const Color _grassB = Color(0xFF294C32);
  static const Color _lines = Color(0xFFDDE3DF);
  static const Color _apronColour = Color(0xFF16191B);

  // ---------------------------------------------------------------------------

  Offset _p(double x, double y, [double z = 0]) =>
      projection.toScreenOpen(x, y, z);

  double _ppm(double y) => projection.pxPerMetreAt(y);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    _sky(canvas, size);
    _apronGround(canvas);
    _stands(canvas);
    _boards(canvas, near: false);
    _grass(canvas);
    _markings(canvas);
    _goal(canvas, left: true);
    _goal(canvas, left: false);
    _boards(canvas, near: true);
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
      old.projection.viewport != projection.viewport ||
      old.projection.cam != projection.cam ||
      old.projection.tilt != projection.tilt;

  // --- Backdrop -------------------------------------------------------------

  void _sky(Canvas canvas, Size size) {
    // Down to the concourse's own colour where the concourse starts, so the
    // two meet without a seam.
    final ground = _p(0, -_runOffSide - _apron).dy;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, ground),
          const [Color(0xFF0A0C0E), _apronColour],
        ),
    );
  }

  /// The dark concourse from the boards to the stands, all round.
  void _apronGround(Canvas canvas) {
    const out = 40.0;
    final path = _poly([
      _p(-_runOffEnd - out, -_runOffSide - _apron),
      _p(PitchDims.length + _runOffEnd + out, -_runOffSide - _apron),
      _p(PitchDims.length + _runOffEnd + out, PitchDims.width + 30),
      _p(-_runOffEnd - out, PitchDims.width + 30),
    ]);
    canvas.drawPath(path, Paint()..color = _apronColour);
  }

  // --- Stands ---------------------------------------------------------------

  /// Where the front row of each stand stands, in metres off the pitch.
  static const double _farFront = _runOffSide + _apron;
  static const double _endFront = _runOffEnd + _apron;

  /// A point [o] metres out from a stand's front row, at [t] (0 to 1) along
  /// [seg], [z] metres up.
  Offset _standPoint(_Seg seg, double t, double o, double z) {
    final d = o * _standDepthScale;
    const l = PitchDims.length, w = PitchDims.width;
    switch (seg) {
      case _Seg.left:
        // Runs from the near corner (t 0) to the far one (t 1).
        return _p(-_endFront - d, w * (1 - t), z);
      case _Seg.far:
        return _p(l * t, -_farFront - d, z);
      case _Seg.right:
        return _p(l + _endFront + d, w * t, z);
      case _Seg.cornerLeft:
      case _Seg.cornerRight:
        // A quarter ellipse joining the end stand to the far one.
        final a = (seg == _Seg.cornerLeft ? t : 1 - t) * math.pi / 2;
        final rx = _endFront + d, ry = _farFront + d;
        final x = seg == _Seg.cornerLeft
            ? -rx * math.cos(a)
            : l + rx * math.cos(a);
        return _p(x, -ry * math.sin(a), z);
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

  /// Rough plan length of each segment, to share the slices and the away
  /// end out by distance.
  double _segLength(_Seg s) => switch (s) {
    _Seg.left || _Seg.right => PitchDims.width,
    _Seg.far => PitchDims.length,
    _ => 14,
  };

  /// One tier's front and back: how far out and how high.
  ({double o0, double z0, double o1, double z1}) _tier(int k) {
    final o0 = k * (_tierDepth - _overhang);
    final z0 = _frontWall + k * (_tierDepth * _rake + _fascia);
    return (o0: o0, z0: z0, o1: o0 + _tierDepth, z1: z0 + _tierDepth * _rake);
  }

  void _stands(Canvas canvas) {
    final segs = _segments;
    final total = segs.fold<double>(0, (a, s) => a + _segLength(s));
    // The away end: the last stretch of seats, from the right-hand end
    // stand round the corner and along the far stand as far as it needs.
    final awayFrom = total * (1 - spec.awayShare.clamp(0.0, 1.0));
    final home = _crowdTone(spec.homeColour);
    final away = _crowdTone(spec.awayColour);

    // Draw the ends first and the far stand last, so the far stand's
    // corners sit over the ends where they meet.
    var before = 0.0;
    final starts = <_Seg, double>{};
    for (final s in segs) {
      starts[s] = before;
      before += _segLength(s);
    }
    final order = [
      for (final s in segs)
        if (s != _Seg.far) s,
      _Seg.far,
    ];
    for (var k = 0; k < spec.tiers; k++) {
      final t = _tier(k);
      for (final s in order) {
        _frontWallOf(canvas, s, t.o0, t.z0, k);
        _tierBand(
          canvas,
          s,
          t,
          k,
          colourAt: (frac) {
            final along = starts[s]! + frac * _segLength(s);
            return along >= awayFrom ? away : home;
          },
        );
      }
    }
    final top = _tier(spec.tiers - 1);
    for (final s in order) {
      _roof(canvas, s, top.o1, top.z1);
    }
    if (spec.openCorners) {
      _mast(canvas, left: true);
      _mast(canvas, left: false);
    }
  }

  /// A kit colour as a crowd reads from across a ground: the hue kept,
  /// pulled well down into the dark canvas so the stands frame the pitch
  /// instead of competing with the players' discs.
  static Color _crowdTone(Color kit) {
    final h = HSLColor.fromColor(kit);
    final l = (h.lightness * 0.5 + 0.1).clamp(0.16, 0.5);
    final s = (h.saturation * 0.62).clamp(0.0, 0.55);
    return h.withLightness(l).withSaturation(s).toColor();
  }

  void _frontWallOf(Canvas canvas, _Seg s, double o, double z, int k) {
    // The bottom tier stands on a low wall; an upper one on its fascia.
    final h = k == 0 ? _frontWall : _fascia;
    final band = _band(
      (t) => _standPoint(s, t, o, z - h),
      (t) => _standPoint(s, t, o, z),
    );
    canvas.drawPath(
      band,
      Paint()
        ..color = k == 0
            ? AppColors.surfaceContainer
            : AppColors.surfaceContainerHigh,
    );
    // A brushed-steel edge along the top of every fascia.
    canvas.drawPath(
      _line((t) => _standPoint(s, t, o, z)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = k == 0 ? 0.6 : 0.9
        ..color = AppColors.primary.withValues(alpha: k == 0 ? 0.22 : 0.40),
    );
  }

  void _tierBand(
    Canvas canvas,
    _Seg s,
    ({double o0, double z0, double o1, double z1}) t,
    int k, {
    required Color Function(double frac) colourAt,
  }) {
    // Sliced along the stand, so the away end can start anywhere.
    final n = math.max(6, (_segLength(s) / 1.5).round());
    for (var i = 0; i < n; i++) {
      final a = i / n, b = (i + 1) / n;
      final q = _poly([
        _standPoint(s, a, t.o0, t.z0),
        _standPoint(s, b, t.o0, t.z0),
        _standPoint(s, b, t.o1, t.z1),
        _standPoint(s, a, t.o1, t.z1),
      ]);
      canvas.drawPath(
        q,
        Paint()
          ..color = colourAt((a + b) / 2)
          ..isAntiAlias = false,
      );
    }
    // Rows of seats: faint lines across the tier.
    const rows = 6;
    final rowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.black.withValues(alpha: 0.16);
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
    // Depth: light on the front rows, falling into shade at the back, where
    // the tier above hangs over it (or the roof does).
    final front = _standPoint(s, 0.5, t.o0, t.z0);
    final back = _standPoint(s, 0.5, t.o1, t.z1);
    final whole = _band(
      (u) => _standPoint(s, u, t.o0, t.z0),
      (u) => _standPoint(s, u, t.o1, t.z1),
    );
    canvas.drawPath(
      whole,
      Paint()
        ..shader = ui.Gradient.linear(front, back, [
          Colors.white.withValues(alpha: 0.05),
          Colors.black.withValues(alpha: 0.42 + 0.06 * k),
        ]),
    );
  }

  void _roof(Canvas canvas, _Seg s, double o, double z) {
    const wall = 2.4, canopy = 3.0;
    // The back wall, then the canopy's leading edge reaching forward.
    final backWall = _band(
      (t) => _standPoint(s, t, o, z),
      (t) => _standPoint(s, t, o, z + wall),
    );
    canvas.drawPath(backWall, Paint()..color = AppColors.surfaceContainerLow);
    final lip = _band(
      (t) => _standPoint(s, t, o - canopy, z + wall),
      (t) => _standPoint(s, t, o - canopy, z + wall + 0.9),
    );
    canvas.drawPath(lip, Paint()..color = AppColors.surfaceContainerHighest);
    canvas.drawPath(
      _line((t) => _standPoint(s, t, o - canopy, z + wall + 0.9)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = AppColors.primary.withValues(alpha: 0.55),
    );
    // Floodlights along the canopy: small lamps with a soft halo.
    if (s == _Seg.far || s == _Seg.left || s == _Seg.right) {
      final lamps = s == _Seg.far ? 9 : 5;
      for (var i = 0; i < lamps; i++) {
        final c = _standPoint(s, (i + 0.5) / lamps, o - canopy, z + wall + 0.2);
        _lamp(canvas, c, _ppm(0) * 0.55);
      }
    }
    if (s == _Seg.far) _flags(canvas, o, z + wall + 0.9);
  }

  void _lamp(Canvas canvas, Offset c, double r) {
    canvas
      ..drawCircle(
        c,
        r * 2.6,
        Paint()
          ..color = const Color(0xFFF4F1E6).withValues(alpha: 0.10)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.6),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: r * 1.6, height: r * 0.8),
          Radius.circular(r * 0.2),
        ),
        Paint()..color = const Color(0xFFEDEBE2).withValues(alpha: 0.85),
      );
  }

  /// The ground nation's flags on poles along the far stand's roof.
  void _flags(Canvas canvas, double o, double z) {
    const poles = [0.16, 0.38, 0.62, 0.84];
    final ppm = _ppm(0);
    final poleH = 4.2 * ppm * projection.tilt * 1.6;
    final w = math.max(9.0, ppm * 3.4);
    final h = w * 2 / 3;
    final polePaint = Paint()
      ..color = AppColors.outline
      ..strokeWidth = math.max(0.8, ppm * 0.22);
    for (final t in poles) {
      final base = _standPoint(_Seg.far, t, o - 3.0, z);
      final top = base.translate(0, -poleH);
      canvas.drawLine(base, top, polePaint);
      final img = flag;
      if (img == null) continue;
      final dst = Rect.fromLTWH(top.dx, top.dy, w, h);
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
            ..color = Colors.white.withValues(alpha: 0.92),
        );
    }
  }

  /// A small ground's floodlight mast in each open far corner.
  void _mast(Canvas canvas, {required bool left}) {
    final x = left ? -_endFront - 2.5 : PitchDims.length + _endFront + 2.5;
    final base = _p(x, -_farFront - 2.5);
    final top = _p(x, -_farFront - 2.5, 26);
    final ppm = _ppm(0);
    canvas.drawLine(
      base,
      top,
      Paint()
        ..color = AppColors.outlineVariant
        ..strokeWidth = math.max(1.0, ppm * 0.4),
    );
    final head = Rect.fromCenter(
      center: top,
      width: ppm * 4.2,
      height: ppm * 1.8,
    );
    canvas
      ..drawRect(
        head.inflate(ppm * 1.4),
        Paint()
          ..color = const Color(0xFFF4F1E6).withValues(alpha: 0.10)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, ppm * 1.5),
      )
      ..drawRect(head, Paint()..color = AppColors.surfaceContainerHighest)
      ..drawRect(
        head.deflate(ppm * 0.35),
        Paint()..color = const Color(0xFFEDEBE2).withValues(alpha: 0.85),
      );
  }

  // --- Ad boards -------------------------------------------------------------

  void _boards(Canvas canvas, {required bool near}) {
    const l = PitchDims.length, w = PitchDims.width;
    const xs0 = -_runOffEnd, xs1 = l + _runOffEnd;
    const ys0 = -_runOffSide, ys1 = w + _runOffSide;
    // Runs of boards, each from one end to the other.
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
    var n = 0;
    for (final ((ax, ay), (bx, by)) in runs) {
      final len = math.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay));
      final count = (len / panel).ceil();
      for (var i = 0; i < count; i++, n++) {
        final f0 = i / count, f1 = (i + 1) / count;
        final x0 = ax + (bx - ax) * f0, y0 = ay + (by - ay) * f0;
        final x1 = ax + (bx - ax) * f1, y1 = ay + (by - ay) * f1;
        final face = _poly([
          _p(x0, y0),
          _p(x1, y1),
          _p(x1, y1, _boardHeight),
          _p(x0, y0, _boardHeight),
        ]);
        canvas.drawPath(face, Paint()..color = tones[n % tones.length]);
        // No brand: a quiet silver bar where a name would be.
        double lerp(double a, double b, double t) => a + (b - a) * t;
        final bar = _poly([
          _p(lerp(x0, x1, 0.3), lerp(y0, y1, 0.3), _boardHeight * 0.42),
          _p(lerp(x0, x1, 0.7), lerp(y0, y1, 0.7), _boardHeight * 0.42),
          _p(lerp(x0, x1, 0.7), lerp(y0, y1, 0.7), _boardHeight * 0.58),
          _p(lerp(x0, x1, 0.3), lerp(y0, y1, 0.3), _boardHeight * 0.58),
        ]);
        canvas.drawPath(
          bar,
          Paint()
            ..color = AppColors.primary.withValues(
              alpha: n.isEven ? 0.30 : 0.18,
            ),
        );
      }
      canvas.drawLine(
        _p(ax, ay, _boardHeight),
        _p(bx, by, _boardHeight),
        Paint()
          ..strokeWidth = 0.7
          ..color = AppColors.primary.withValues(alpha: 0.35),
      );
    }
  }

  // --- Grass and lines -------------------------------------------------------

  void _grass(Canvas canvas) {
    const l = PitchDims.length, w = PitchDims.width;
    const x0 = -_runOffEnd, x1 = l + _runOffEnd;
    const y0 = -_runOffSide, y1 = w + _runOffSide;
    // Stripes across the pitch, twenty to the length, carried on through
    // the run-off as a mower would.
    const stripes = 20;
    const sw = l / stripes;
    final first = (x0 / sw).floor(), last = (x1 / sw).ceil();
    for (var i = first; i < last; i++) {
      final a = math.max(x0, i * sw), b = math.min(x1, (i + 1) * sw);
      canvas.drawPath(
        _poly([_p(a, y0), _p(b, y0), _p(b, y1), _p(a, y1)]),
        Paint()
          ..color = i.isEven ? _grassA : _grassB
          ..isAntiAlias = false,
      );
    }
    final field = _poly([_p(x0, y0), _p(x1, y0), _p(x1, y1), _p(x0, y1)]);
    // Light falls off toward the far side, and the run-off is a touch
    // darker, so the playing surface reads as the brightest thing there.
    final far = _p(l / 2, y0), nearPt = _p(l / 2, y1);
    canvas.drawPath(
      field,
      Paint()
        ..shader = ui.Gradient.linear(
          far,
          nearPt,
          [
            Colors.black.withValues(alpha: 0.26),
            Colors.black.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.025),
          ],
          const [0, 0.55, 1],
        ),
    );
    final left = _p(x0, w / 2), right = _p(x1, w / 2);
    canvas.drawPath(
      field,
      Paint()
        ..shader = ui.Gradient.linear(
          left,
          right,
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

    Path pts(List<(double, double)> ps, {bool close = false}) =>
        _poly([for (final (x, y) in ps) _p(x, y)], close: close);
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
      // The D: the part of the 9.15 m circle round the spot outside the box.
      final half = math.acos((box - spot) / arcR);
      stroke(
        left
            ? curve(x(spot), w / 2, arcR, -half, half)
            : curve(x(spot), w / 2, arcR, math.pi - half, math.pi + half),
        w / 2,
      );
      _spot(canvas, _p(x(spot), w / 2), w / 2);
      // Corner arcs.
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

  void _goal(Canvas canvas, {required bool left}) {
    const w = PitchDims.width, half = PitchDims.goalHalfWidth;
    const bar = PitchDims.crossbarHeight, depth = 2.0, backTop = 1.6;
    final x = left ? 0.0 : PitchDims.length;
    final xb = left ? -depth : PitchDims.length + depth;
    const yf = w / 2 - half, yn = w / 2 + half;
    final net = Paint()..color = Colors.white.withValues(alpha: 0.07);
    final mesh = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.26);
    // Back panel, the two side panels and the roof of the net.
    final panels = [
      [(xb, yf, 0.0), (xb, yn, 0.0), (xb, yn, backTop), (xb, yf, backTop)],
      [(x, yf, 0.0), (xb, yf, 0.0), (xb, yf, backTop), (x, yf, bar)],
      [(x, yn, 0.0), (xb, yn, 0.0), (xb, yn, backTop), (x, yn, bar)],
      [(x, yf, bar), (x, yn, bar), (xb, yn, backTop), (xb, yf, backTop)],
    ];
    for (final q in panels) {
      canvas.drawPath(_poly([for (final (a, b, c) in q) _p(a, b, c)]), net);
    }
    // Mesh: lines across the goal's width on the back and the roof, and up
    // the back.
    const cells = 10;
    for (var i = 0; i <= cells; i++) {
      final y = yf + (yn - yf) * i / cells;
      canvas
        ..drawLine(_p(xb, y), _p(xb, y, backTop), mesh)
        ..drawLine(_p(xb, y, backTop), _p(x, y, bar), mesh);
    }
    for (var j = 1; j < 4; j++) {
      final z = backTop * j / 4;
      canvas.drawLine(_p(xb, yf, z), _p(xb, yn, z), mesh);
    }
    // The frame.
    final ppm = _ppm(w / 2);
    final frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.4, 0.14 * ppm)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFF2F4F3);
    canvas.drawPath(
      _poly([_p(x, yf), _p(x, yf, bar), _p(x, yn, bar), _p(x, yn)]),
      frame,
    );
  }

  /// A soft dark fall-off along the bottom edge, so the near boards sit in
  /// the frame instead of being cut by it.
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

  /// A curve sampled from [f] over 0 to 1.
  static Path _line(Offset Function(double t) f, {int n = 24}) {
    final path = Path();
    for (var i = 0; i <= n; i++) {
      final o = f(i / n);
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
    }
    return path;
  }

  /// The strip between two curves sampled over 0 to 1.
  static Path _band(
    Offset Function(double t) a,
    Offset Function(double t) b, {
    int n = 24,
  }) {
    final pts = [
      for (var i = 0; i <= n; i++) a(i / n),
      for (var i = n; i >= 0; i--) b(i / n),
    ];
    return _poly(pts);
  }
}

enum _Seg { left, cornerLeft, far, cornerRight, right }
