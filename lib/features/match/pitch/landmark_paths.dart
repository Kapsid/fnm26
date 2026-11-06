import 'dart:math' as math;
import 'dart:ui';

import 'package:fnm/domain/services/match/stadium/landmarks.dart';

/// The thirty city silhouettes, drawn in code: each a path one unit tall,
/// standing on y = 0 (up is negative y) and centred on x = 0, about as wide
/// as it is in life relative to its height.
///
/// They are outlines, not pictures: one flat tone each, read against the sky
/// the way a skyline is read at a distance.
abstract final class LandmarkPaths {
  static Path of(LandmarkKind kind) => switch (kind) {
    LandmarkKind.none => Path(),
    LandmarkKind.eiffel => _eiffel(),
    LandmarkKind.colosseum => _colosseum(),
    LandmarkKind.bigBen => _bigBen(),
    LandmarkKind.christRedeemer => _christ(),
    LandmarkKind.stBasil => _stBasil(),
    LandmarkKind.sagradaFamilia => _sagrada(),
    LandmarkKind.operaHouse => _opera(),
    LandmarkKind.pyramids => _pyramids(),
    LandmarkKind.mosqueDomes => _mosque(),
    LandmarkKind.tokyoTower => _tokyo(),
    LandmarkKind.newYorkSkyline => _newYork(),
    LandmarkKind.tvTower => _tvTower(),
    LandmarkKind.acropolis => _acropolis(),
    LandmarkKind.pragueCastle => _prague(),
    LandmarkKind.gabledHouses => _gables(),
    LandmarkKind.obelisco => _obelisco(),
    LandmarkKind.angel => _angel(),
    LandmarkKind.burj => _burj(),
    LandmarkKind.templeOfHeaven => _temple(),
    LandmarkKind.gateway => _gateway(),
    LandmarkKind.seoulTower => _seoul(),
    LandmarkKind.cnTower => _cnTower(),
    LandmarkKind.belemTower => _belem(),
    LandmarkKind.alcala => _alcala(),
    LandmarkKind.twinTowers => _twinTowers(),
    LandmarkKind.sailHotel => _sailHotel(),
    LandmarkKind.tableMountain => _tableMountain(),
    LandmarkKind.hallgrims => _hallgrims(),
    LandmarkKind.spires => _spires(),
    LandmarkKind.parliament => _parliament(),
  };

  /// Whether a landmark is a building with windows that light up at night
  /// (a tower of girders or a mountain has none).
  static bool hasWindows(LandmarkKind k) => switch (k) {
    LandmarkKind.eiffel ||
    LandmarkKind.tokyoTower ||
    LandmarkKind.christRedeemer ||
    LandmarkKind.pyramids ||
    LandmarkKind.tableMountain ||
    LandmarkKind.obelisco ||
    LandmarkKind.angel ||
    LandmarkKind.none => false,
    _ => true,
  };

  // --- Helpers -----------------------------------------------------------------

  static Path _poly(List<(double, double)> pts) {
    final p = Path()..moveTo(pts.first.$1, pts.first.$2);
    for (final (x, y) in pts.skip(1)) {
      p.lineTo(x, y);
    }
    return p..close();
  }

  static Rect _r(double l, double top, double r, double bottom) =>
      Rect.fromLTRB(l, top, r, bottom);

  static Path _rect(double l, double top, double r, [double bottom = 0]) =>
      Path()..addRect(_r(l, top, r, bottom));

  /// A dome sitting on [base], [w] wide and [h] tall.
  static Path _dome(double cx, double base, double w, double h) => Path()
    ..addArc(_r(cx - w / 2, base - h, cx + w / 2, base + h), math.pi, math.pi);

  /// A spire: a thin triangle from [base] up to [top].
  static Path _spire(double cx, double base, double w, double top) =>
      _poly([(cx - w / 2, base), (cx, top), (cx + w / 2, base)]);

  /// An onion dome on a drum.
  static Path _onion(double cx, double base, double w, double h) {
    final p = Path()
      ..moveTo(cx - w * 0.32, base)
      ..cubicTo(
        cx - w * 0.75,
        base - h * 0.35,
        cx - w * 0.35,
        base - h * 0.7,
        cx,
        base - h,
      )
      ..cubicTo(
        cx + w * 0.35,
        base - h * 0.7,
        cx + w * 0.75,
        base - h * 0.35,
        cx + w * 0.32,
        base,
      )
      ..close();
    return p;
  }

  static Path _union(Iterable<Path> parts) {
    var out = Path();
    for (final p in parts) {
      out = Path.combine(PathOperation.union, out, p);
    }
    return out;
  }

  static Path _minus(Path a, Path b) =>
      Path.combine(PathOperation.difference, a, b);

  // --- The landmarks -------------------------------------------------------------

  static Path _eiffel() {
    final body = _poly([
      (-0.36, 0),
      (-0.2, -0.28),
      (-0.11, -0.52),
      (-0.05, -0.8),
      (-0.018, -0.95),
      (0, -1),
      (0.018, -0.95),
      (0.05, -0.8),
      (0.11, -0.52),
      (0.2, -0.28),
      (0.36, 0),
    ]);
    final arch = Path()..addOval(_r(-0.2, -0.17, 0.2, 0.17));
    final window = _poly([(-0.055, -0.36), (0, -0.62), (0.055, -0.36)]);
    final decks = _union([
      _rect(-0.25, -0.3, 0.25, -0.26),
      _rect(-0.14, -0.55, 0.14, -0.52),
    ]);
    return _union([_minus(_minus(body, arch), window), decks]);
  }

  static Path _colosseum() {
    final wall = _poly([
      (-1, 0),
      (-1, -0.42),
      (-0.6, -0.5),
      (0.1, -0.5),
      (0.35, -0.46),
      (0.55, -0.34),
      (0.7, -0.3),
      (0.82, -0.18),
      (1, -0.16),
      (1, 0),
    ]);
    var holes = Path();
    for (var row = 0; row < 3; row++) {
      final y0 = -0.1 - row * 0.13;
      for (var i = 0; i < 12; i++) {
        final x = -0.92 + i * 0.155;
        if (row == 2 && x > 0.3) continue;
        if (row == 1 && x > 0.7) continue;
        holes = Path.combine(
          PathOperation.union,
          holes,
          Path()..addRRect(
            RRect.fromRectAndCorners(
              _r(x, y0 - 0.08, x + 0.07, y0),
              topLeft: const Radius.circular(0.035),
              topRight: const Radius.circular(0.035),
            ),
          ),
        );
      }
    }
    return _minus(wall, holes);
  }

  static Path _bigBen() {
    final tower = _union([
      _rect(-0.07, -0.66, 0.07),
      _rect(-0.09, -0.8, 0.09, -0.64),
      _poly([(-0.09, -0.8), (0, -1), (0.09, -0.8)]),
      _rect(0.07, -0.26, 0.95),
      for (var i = 0; i < 6; i++) _spire(0.2 + i * 0.14, -0.26, 0.04, -0.36),
    ]);
    final face = Path()
      ..addOval(Rect.fromCircle(center: const Offset(0, -0.72), radius: 0.045));
    return _minus(tower, face);
  }

  static Path _christ() => _union([
    _poly([
      (-1, 0),
      (-0.6, -0.22),
      (-0.25, -0.5),
      (-0.06, -0.6),
      (0.08, -0.6),
      (0.35, -0.42),
      (0.7, -0.2),
      (1, 0),
    ]),
    _rect(-0.025, -0.9, 0.025, -0.58),
    _rect(-0.16, -0.86, 0.16, -0.83),
    Path()
      ..addOval(Rect.fromCircle(center: const Offset(0, -0.93), radius: 0.03)),
  ]);

  static Path _stBasil() => _union([
    _rect(-0.7, -0.28, 0.7),
    _rect(-0.05, -0.7, 0.05, -0.2),
    _spire(0, -0.68, 0.14, -1),
    for (final (x, h) in [
      (-0.5, 0.42),
      (-0.25, 0.55),
      (0.25, 0.55),
      (0.5, 0.42),
    ]) ...[
      _rect(x - 0.06, -h, x + 0.06, -0.2),
      _onion(x, -h, 0.2, 0.2),
    ],
  ]);

  static Path _sagrada() => _union([
    _rect(-0.55, -0.3, 0.55),
    for (final (x, h) in [
      (-0.42, 0.72),
      (-0.28, 0.85),
      (-0.14, 0.8),
      (0.0, 1.0),
      (0.14, 0.8),
      (0.28, 0.85),
      (0.42, 0.72),
    ])
      _poly([
        (x - 0.055, -0.2),
        (x - 0.035, -h * 0.85),
        (x, -h),
        (x + 0.035, -h * 0.85),
        (x + 0.055, -0.2),
      ]),
  ]);

  static Path _opera() {
    Path shell(double x0, double x1, double h) => Path()
      ..moveTo(x0, -0.12)
      ..quadraticBezierTo(x0 + (x1 - x0) * 0.15, -h, x1, -h * 0.95)
      ..quadraticBezierTo(x1 - (x1 - x0) * 0.1, -h * 0.3, x1 + 0.05, -0.12)
      ..close();
    return _union([
      _rect(-1, -0.14, 1),
      shell(-0.85, -0.5, 0.75),
      shell(-0.55, -0.15, 0.95),
      shell(-0.2, 0.2, 0.8),
      shell(0.25, 0.55, 0.62),
      shell(0.55, 0.8, 0.45),
    ]);
  }

  static Path _pyramids() => _union([
    _poly([(-1, 0), (-0.45, -0.75), (0.1, 0)]),
    _poly([(-0.1, 0), (0.35, -1), (0.85, 0)]),
    _poly([(0.6, 0), (0.85, -0.4), (1.1, 0)]),
  ]);

  static Path _mosque() => _union([
    _rect(-0.6, -0.3, 0.6),
    _dome(0, -0.3, 0.7, 0.32),
    _rect(-0.02, -0.7, 0.02, -0.55),
    _dome(-0.42, -0.3, 0.3, 0.14),
    _dome(0.42, -0.3, 0.3, 0.14),
    for (final x in [-0.85, -0.7, 0.7, 0.85]) ...[
      _rect(x - 0.025, -0.85, x + 0.025),
      _spire(x, -0.85, 0.05, -1),
    ],
  ]);

  static Path _tokyo() {
    final body = _poly([
      (-0.3, 0),
      (-0.13, -0.35),
      (-0.06, -0.62),
      (-0.02, -0.85),
      (0, -1),
      (0.02, -0.85),
      (0.06, -0.62),
      (0.13, -0.35),
      (0.3, 0),
    ]);
    final arch = Path()..addOval(_r(-0.16, -0.14, 0.16, 0.14));
    return _union([
      _minus(body, arch),
      _rect(-0.15, -0.4, 0.15, -0.34),
      _rect(-0.08, -0.66, 0.08, -0.62),
    ]);
  }

  static Path _newYork() => _union([
    _rect(-1, -0.35, -0.8),
    _rect(-0.82, -0.5, -0.66),
    _rect(-0.66, -0.42, -0.5),
    // The stepped one with the mast.
    _rect(-0.5, -0.55, -0.26),
    _rect(-0.46, -0.68, -0.3),
    _rect(-0.42, -0.78, -0.34),
    _rect(-0.395, -1, -0.375),
    _rect(-0.26, -0.45, -0.1),
    _rect(-0.1, -0.6, 0.08),
    _rect(0.08, -0.38, 0.25),
    // A spired one.
    _rect(0.25, -0.62, 0.42),
    _poly([(0.27, -0.62), (0.335, -0.86), (0.4, -0.62)]),
    _rect(0.42, -0.48, 0.62),
    _rect(0.62, -0.7, 0.75),
    _rect(0.75, -0.4, 1),
  ]);

  static Path _tvTower() => _union([
    _rect(-0.035, -0.62, 0.035),
    Path()
      ..addOval(Rect.fromCircle(center: const Offset(0, -0.66), radius: 0.09)),
    _rect(-0.03, -0.78, 0.03, -0.6),
    _rect(-0.012, -1, 0.012, -0.76),
    _rect(-0.35, -0.08, 0.35),
  ]);

  static Path _acropolis() {
    final hill = _poly([
      (-1, 0),
      (-0.8, -0.2),
      (-0.5, -0.4),
      (0.5, -0.42),
      (0.75, -0.25),
      (1, 0),
    ]);
    final temple = _union([
      _rect(-0.42, -0.5, 0.42, -0.38),
      _rect(-0.42, -0.76, 0.42, -0.7),
      _poly([(-0.44, -0.76), (0, -0.92), (0.44, -0.76)]),
      for (var i = 0; i < 8; i++)
        _rect(-0.4 + i * 0.112, -0.7, -0.36 + i * 0.112, -0.5),
    ]);
    return _union([hill, temple]);
  }

  static Path _prague() => _union([
    _poly([(-1, 0), (-1, -0.2), (1, -0.24), (1, 0)]),
    _rect(-0.9, -0.36, 0.2, -0.2),
    _rect(0.15, -0.55, 0.55, -0.2),
    _poly([(0.15, -0.55), (0.35, -0.68), (0.55, -0.55)]),
    _rect(0.22, -0.82, 0.3, -0.5),
    _spire(0.26, -0.82, 0.1, -1),
    _rect(0.4, -0.78, 0.48, -0.5),
    _spire(0.44, -0.78, 0.1, -0.96),
    _rect(0.58, -0.62, 0.68, -0.2),
    _dome(0.63, -0.62, 0.1, 0.08),
  ]);

  static Path _gables() {
    final parts = <Path>[];
    var x = -1.0;
    final widths = [0.24, 0.2, 0.26, 0.22, 0.2, 0.25, 0.22, 0.21];
    final heights = [0.7, 0.85, 0.75, 0.95, 0.8, 0.72, 0.9, 0.78];
    for (var i = 0; i < widths.length; i++) {
      final w = widths[i], h = heights[i];
      final cx = x + w / 2;
      final body = _rect(x + 0.005, -h * 0.75, x + w - 0.005);
      final gable = i.isEven
          ? _poly([
              (x + 0.005, -h * 0.75),
              (x + w * 0.2, -h * 0.75),
              (x + w * 0.2, -h * 0.85),
              (x + w * 0.35, -h * 0.85),
              (cx - w * 0.08, -h),
              (cx + w * 0.08, -h),
              (x + w * 0.65, -h * 0.85),
              (x + w * 0.8, -h * 0.85),
              (x + w * 0.8, -h * 0.75),
              (x + w - 0.005, -h * 0.75),
            ])
          : (Path()
              ..moveTo(x + 0.005, -h * 0.75)
              ..quadraticBezierTo(x + w * 0.1, -h * 0.9, cx, -h)
              ..quadraticBezierTo(
                x + w * 0.9,
                -h * 0.9,
                x + w - 0.005,
                -h * 0.75,
              )
              ..close());
      parts.add(Path.combine(PathOperation.union, body, gable));
      x += w;
    }
    return _union(parts);
  }

  static Path _obelisco() => _union([
    _poly([(-0.07, 0), (-0.05, -0.9), (0, -1), (0.05, -0.9), (0.07, 0)]),
    _rect(-0.3, -0.04, 0.3),
  ]);

  static Path _angel() => _union([
    _rect(-0.35, -0.12, 0.35),
    _rect(-0.18, -0.22, 0.18, -0.1),
    _rect(-0.045, -0.82, 0.045, -0.2),
    _rect(-0.07, -0.86, 0.07, -0.8),
    _poly([(-0.02, -0.86), (-0.12, -0.95), (-0.02, -0.92)]),
    _poly([(0.02, -0.86), (0.12, -0.95), (0.02, -0.92)]),
    _rect(-0.015, -1, 0.015, -0.86),
  ]);

  static Path _burj() => _union([
    _rect(-0.22, -0.18, 0.22),
    _rect(-0.16, -0.38, 0.16, -0.16),
    _rect(-0.11, -0.58, 0.11, -0.36),
    _rect(-0.07, -0.74, 0.07, -0.56),
    _rect(-0.04, -0.86, 0.04, -0.72),
    _poly([(-0.02, -0.86), (0, -1), (0.02, -0.86)]),
  ]);

  static Path _temple() => _union([
    _rect(-0.7, -0.08, 0.7),
    _rect(-0.55, -0.16, 0.55, -0.06),
    _rect(-0.38, -0.34, 0.38, -0.14),
    _poly([(-0.55, -0.32), (0, -0.46), (0.55, -0.32)]),
    _rect(-0.3, -0.54, 0.3, -0.42),
    _poly([(-0.45, -0.52), (0, -0.64), (0.45, -0.52)]),
    _rect(-0.22, -0.72, 0.22, -0.6),
    _poly([(-0.34, -0.7), (0, -0.88), (0.34, -0.7)]),
    _spire(0, -0.86, 0.06, -1),
  ]);

  static Path _gateway() {
    final body = _rect(-0.6, -0.62, 0.6);
    final arch = Path()
      ..moveTo(-0.2, 0)
      ..lineTo(-0.2, -0.32)
      ..arcToPoint(const Offset(0.2, -0.32), radius: const Radius.circular(0.2))
      ..lineTo(0.2, 0)
      ..close();
    return _union([
      _minus(body, arch),
      for (final x in [-0.55, -0.3, 0.3, 0.55]) ...[
        _rect(x - 0.06, -0.8, x + 0.06, -0.6),
        _dome(x, -0.8, 0.12, 0.08),
      ],
      _dome(0, -0.62, 0.3, 0.12),
    ]);
  }

  static Path _seoul() => _union([
    _poly([
      (-1, 0),
      (-0.5, -0.2),
      (-0.1, -0.32),
      (0.3, -0.3),
      (0.7, -0.15),
      (1, 0),
    ]),
    _rect(-0.03, -0.7, 0.03, -0.3),
    _rect(-0.1, -0.76, 0.1, -0.68),
    _rect(-0.07, -0.8, 0.07, -0.76),
    _rect(-0.01, -1, 0.01, -0.8),
  ]);

  static Path _cnTower() => _union([
    _poly([(-0.08, 0), (-0.03, -0.62), (0.03, -0.62), (0.08, 0)]),
    _rect(-0.1, -0.68, 0.1, -0.6),
    Path()..addOval(_r(-0.08, -0.72, 0.08, -0.6)),
    _rect(-0.025, -0.78, 0.025, -0.66),
    _rect(-0.01, -1, 0.01, -0.76),
  ]);

  static Path _belem() {
    final battlement = <Path>[
      for (var i = 0; i < 5; i++)
        _rect(-0.22 + i * 0.1, -0.86, -0.17 + i * 0.1, -0.8),
    ];
    return _union([
      _rect(-0.5, -0.36, 0.5),
      _rect(-0.22, -0.8, 0.22, -0.3),
      ...battlement,
      for (final x in [-0.22, 0.22]) _dome(x, -0.8, 0.08, 0.08),
      for (final x in [-0.5, 0.5]) _dome(x, -0.36, 0.08, 0.07),
    ]);
  }

  static Path _alcala() {
    final body = _union([
      _rect(-1, -0.6, 1),
      _rect(-0.25, -0.82, 0.25, -0.58),
    ]);
    var holes = Path();
    for (final (x, arched) in [
      (-0.7, false),
      (-0.35, true),
      (0.0, true),
      (0.35, true),
      (0.7, false),
    ]) {
      final h = arched
          ? (Path()
              ..moveTo(x - 0.11, 0)
              ..lineTo(x - 0.11, -0.3)
              ..arcToPoint(
                Offset(x + 0.11, -0.3),
                radius: const Radius.circular(0.11),
              )
              ..lineTo(x + 0.11, 0)
              ..close())
          : _rect(x - 0.08, -0.3, x + 0.08);
      holes = Path.combine(PathOperation.union, holes, h);
    }
    return _minus(body, holes);
  }

  static Path _twinTowers() {
    Path tower(double cx) => _union([
      _rect(cx - 0.11, -0.55, cx + 0.11),
      _rect(cx - 0.09, -0.7, cx + 0.09, -0.53),
      _rect(cx - 0.065, -0.8, cx + 0.065, -0.68),
      _poly([(cx - 0.04, -0.8), (cx, -0.9), (cx + 0.04, -0.8)]),
      _rect(cx - 0.006, -1, cx + 0.006, -0.88),
    ]);
    return _union([
      tower(-0.25),
      tower(0.25),
      _rect(-0.15, -0.45, 0.15, -0.42),
    ]);
  }

  static Path _sailHotel() => _union([
    for (final x in [-0.5, 0.0, 0.5]) _rect(x - 0.13, -0.75, x + 0.13),
    Path()
      ..moveTo(-0.72, -0.76)
      ..quadraticBezierTo(0, -0.7, 0.72, -0.82)
      ..lineTo(0.66, -0.86)
      ..quadraticBezierTo(0, -0.8, -0.72, -0.82)
      ..close(),
    _rect(-0.68, -0.8, -0.62, -0.74),
  ]);

  static Path _tableMountain() => _poly([
    (-1, 0),
    (-0.75, -0.35),
    (-0.6, -0.78),
    (-0.5, -0.82),
    (0.45, -0.84),
    (0.55, -0.78),
    (0.7, -0.45),
    (0.82, -0.5),
    (0.92, -0.3),
    (1, 0),
  ]);

  static Path _hallgrims() {
    final parts = <Path>[_rect(-0.55, -0.12, 0.55)];
    for (var i = 0; i < 6; i++) {
      final w = 0.5 - i * 0.07;
      parts.add(_rect(-w, -0.18 - i * 0.07, -w + 0.06, 0));
      parts.add(_rect(w - 0.06, -0.18 - i * 0.07, w, 0));
    }
    parts
      ..add(_rect(-0.07, -0.85, 0.07))
      ..add(_spire(0, -0.85, 0.14, -1));
    return _union(parts);
  }

  static Path _spires() => _union([
    _rect(-1, -0.25, 1),
    for (final (x, h) in [
      (-0.7, 0.75),
      (-0.2, 1.0),
      (0.3, 0.65),
      (0.75, 0.85),
    ]) ...[
      _rect(x - 0.05, -h * 0.5, x + 0.05, -0.2),
      _spire(x, -h * 0.5, 0.1, -h),
    ],
  ]);

  static Path _parliament() => _union([
    _rect(-1, -0.32, 1),
    _rect(-0.15, -0.5, 0.15, -0.3),
    _dome(0, -0.5, 0.3, 0.22),
    _spire(0, -0.7, 0.05, -0.88),
    for (var i = 0; i < 9; i++)
      if (i != 4) _spire(-0.88 + i * 0.22, -0.32, 0.05, -0.48),
    _spire(-1, -0.32, 0.06, -0.55),
    _spire(1, -0.32, 0.06, -0.55),
  ]);
}
