import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/match/stadium/shore_look.dart';
import 'package:fnm/features/match/pitch/backdrop_tone.dart';

/// What a city's geography adds to the near layer of its ground's backdrop
/// ([CityFeature]): harbour cranes and a lighthouse on the coast, a river
/// and an old stone bridge, factory chimneys in an industrial town, old
/// roofs round a tower in an old town, a park's trees.
///
/// Kept to the two sides of the frame: the middle is the landmark's, and
/// the flags stand on the roof. Which side gets what is seeded per ground,
/// so a ground always looks the same. Sizes follow the room above the roof,
/// as the city's do.
class CityFeatures {
  CityFeatures({
    required this.features,
    required this.style,
    required this.tone,
    this.shore = ShoreLook.none,
    this.clearMiddle = false,
  });

  final Set<CityFeature> features;
  final CityStyle style;
  final BackdropTone tone;

  /// The climate's own look: a beach town has palms along its shore where
  /// a harbour would have its cranes.
  final ShoreLook shore;

  /// A landmark stands in the middle: what is drawn in front of it keeps
  /// to the outer part of each side.
  final bool clearMiddle;

  bool get _snowy => tone.season == BackdropSeason.snow;

  /// Whether the city's own style already is an old town's.
  bool get _alreadyOld =>
      style == CityStyle.oldEuropean ||
      style == CityStyle.northernBrick ||
      style == CityStyle.minarets ||
      style == CityStyle.smallTown;

  Color _c(Color natural, double haze, {double mute = 0.4}) =>
      tone.tone(natural, haze, mute: mute);

  /// The two sides of the frame, as fractions of its width: (left, right)
  /// or mirrored, by the ground.
  ({(double, double) a, (double, double) b}) get _sides {
    final flip = tone.rng('city-features-side').nextBool();
    const l = (0.03, 0.34);
    const r = (0.66, 0.97);
    return flip ? (a: r, b: l) : (a: l, b: r);
  }

  /// Behind the city's front row: chimneys, cranes, a lighthouse.
  void paintBehind(Canvas canvas, Size size, double horizon, double room) {
    if (features.isEmpty) return;
    final unit = math.max(2, room / 14).toDouble();
    final (:a, :b) = _sides;
    double x(double f) => size.width * f;
    final coast = features.contains(CityFeature.coast);
    if (coast) {
      if (!shore.beach) {
        _cranes(canvas, x(a.$1 + 0.02), x(a.$1 + 0.2), horizon, room, unit);
      }
      _lighthouse(canvas, x(b.$2 - 0.04), horizon, room, unit);
    }
    if (features.contains(CityFeature.industrial)) {
      final (lo, hi) = coast ? (b.$1, b.$2 - 0.1) : (b.$1 + 0.04, b.$2);
      _chimneys(canvas, x(lo), x(hi), horizon, room, unit);
    }
  }

  /// In front of the city's front row: an old town's roofs round its
  /// tower, a river with its bridge, a park's trees.
  void paintFront(Canvas canvas, Size size, double horizon, double room) {
    if (features.isEmpty) return;
    final unit = math.max(2, room / 14).toDouble();
    final (:a, :b) = _sides;
    double x(double f) => size.width * f;
    final coast = features.contains(CityFeature.coast);
    if (shore.beach) {
      // Palms along the shore: a grove where the cranes would stand, a few
      // short of the lighthouse on the other side.
      for (final (lo, hi, salt, n) in [
        (a.$1, a.$2 - 0.04, 'a', 6),
        (b.$1 + 0.02, b.$2 - 0.1, 'b', 4),
      ]) {
        final (l, h) = clearMiddle
            ? (lo < 0.5 ? (lo, math.min(hi, 0.2)) : (math.max(lo, 0.8), hi))
            : (lo, hi);
        _palms(canvas, x(l), x(h), horizon, room, unit, salt, n);
      }
    }
    if (features.contains(CityFeature.oldTown) && !_alreadyOld) {
      final side = coast ? b : a;
      _oldTown(
        canvas,
        x(side.$1 + 0.04),
        x(side.$2 - 0.06),
        horizon,
        room,
        unit,
      );
    }
    if (features.contains(CityFeature.forest)) {
      _park(canvas, x(a.$1), x(a.$2), horizon, room, unit);
      _park(canvas, x(b.$1), x(b.$2), horizon, room, unit, salt: 'b');
    }
    if (features.contains(CityFeature.river)) {
      // Opposite the cranes and the old town, which keep side a.
      final side =
          coast || features.contains(CityFeature.oldTown) && !_alreadyOld
          ? b
          : a;
      _river(canvas, x(side.$1), x(side.$2), horizon, room, unit);
    }
  }

  // --- Harbour --------------------------------------------------------------

  /// Two or three container cranes along the waterfront, their booms up.
  void _cranes(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit,
  ) {
    final r = tone.rng('cranes');
    final n = style == CityStyle.smallTown ? 1 : 2 + r.nextInt(2);
    const colours = [Color(0xFFB2503E), Color(0xFF4E7A9A), Color(0xFFB89A3E)];
    final colour = colours[r.nextInt(colours.length)];
    for (var i = 0; i < n; i++) {
      final cx = x0 + (x1 - x0) * (n == 1 ? 0.5 : i / (n - 1));
      final h = room * (0.86 + r.nextDouble() * 0.14);
      final haze = BackdropTone.hazeNear * (1 + i / n);
      final steel = Paint()
        ..color = _c(colour, haze, mute: 0.18)
        ..strokeWidth = math.max(1.1, unit * 0.2)
        ..strokeCap = StrokeCap.square;
      final thin = Paint()
        ..color = steel.color
        ..strokeWidth = math.max(0.6, unit * 0.1);
      final w = unit * 1.7;
      final top = horizon - h;
      final deck = horizon - h * 0.62;
      canvas
        // The two legs of the portal and its cross-beam.
        ..drawLine(
          Offset(cx - w / 2, horizon + room),
          Offset(cx - w / 2, deck),
          steel,
        )
        ..drawLine(
          Offset(cx + w / 2, horizon + room),
          Offset(cx + w / 2, deck),
          steel,
        )
        ..drawLine(Offset(cx - w / 2, deck), Offset(cx + w / 2, deck), steel)
        // The A-frame over it and the boom out over the water, raised.
        ..drawLine(Offset(cx - w / 2, deck), Offset(cx, top), steel)
        ..drawLine(Offset(cx + w / 2, deck), Offset(cx, top), steel)
        ..drawLine(
          Offset(cx - w * 1.1, deck - h * 0.06),
          Offset(cx + w * 1.6, deck - h * 0.3),
          steel,
        )
        ..drawLine(Offset(cx, top), Offset(cx + w * 1.6, deck - h * 0.3), thin)
        ..drawLine(Offset(cx, top), Offset(cx - w * 1.1, deck - h * 0.06), thin)
        // The machinery house on the beam.
        ..drawRect(
          Rect.fromLTWH(cx - w * 0.35, deck - unit * 0.5, w * 0.7, unit * 0.5),
          Paint()..color = _c(const Color(0xFFD8D4CC), haze, mute: 0.35),
        );
      if (tone.night > 0.2) {
        canvas.drawCircle(
          Offset(cx, top - 0.4),
          0.9,
          Paint()
            ..color = const Color(
              0xFFD9544A,
            ).withValues(alpha: 0.9 * tone.night),
        );
      }
    }
  }

  /// A lighthouse at the end of the harbour wall: a white tower in red
  /// bands, its lantern lit at night.
  void _lighthouse(
    Canvas canvas,
    double cx,
    double horizon,
    double room,
    double unit,
  ) {
    const haze = BackdropTone.hazeNear;
    final h = room * 0.82;
    final top = horizon - h;
    final wb = unit * 1.3;
    final wt = unit * 0.8;
    final body = Path()
      ..moveTo(cx - wb / 2, horizon + room)
      ..lineTo(cx - wt / 2, top + unit * 0.9)
      ..lineTo(cx + wt / 2, top + unit * 0.9)
      ..lineTo(cx + wb / 2, horizon + room)
      ..close();
    final white = _c(const Color(0xFFEDEBE6), haze, mute: 0.15);
    final red = _c(const Color(0xFFC0443A), haze, mute: 0.15);
    canvas
      ..drawPath(body, Paint()..color = white)
      ..save()
      ..clipPath(body);
    for (var i = 0; i < 3; i++) {
      final y = top + unit * 0.9 + (h - unit * 0.9) * (0.12 + i * 0.3);
      canvas.drawRect(
        Rect.fromLTRB(cx - wb, y, cx + wb, y + (h - unit) * 0.13),
        Paint()..color = red,
      );
    }
    canvas.restore();
    // The gallery, the lantern and its cap.
    final dark = _c(const Color(0xFF3A3E44), haze, mute: 0.3);
    final lantern = Rect.fromLTRB(
      cx - wt * 0.4,
      top + unit * 0.25,
      cx + wt * 0.4,
      top + unit * 0.9,
    );
    canvas
      ..drawRect(
        Rect.fromLTRB(
          cx - wt * 0.7,
          top + unit * 0.82,
          cx + wt * 0.7,
          top + unit * 1.0,
        ),
        Paint()..color = dark,
      )
      ..drawRect(
        lantern,
        Paint()
          ..color = tone.night > 0.2
              ? Color.lerp(white, BackdropTone.window, tone.night)!
              : _c(const Color(0xFF9AA8B0), haze, mute: 0.3),
      )
      ..drawPath(
        Path()
          ..moveTo(cx - wt * 0.5, top + unit * 0.28)
          ..lineTo(cx, top - unit * 0.1)
          ..lineTo(cx + wt * 0.5, top + unit * 0.28)
          ..close(),
        Paint()..color = _snowy ? tone.snow(haze) : red,
      );
    if (tone.night > 0.2) {
      // The beam, a faint fan out over the sea.
      final c = lantern.center;
      canvas
        ..drawCircle(
          c,
          unit * 1.4,
          Paint()
            ..color = BackdropTone.window.withValues(alpha: 0.35 * tone.night)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, unit * 0.8),
        )
        ..drawPath(
          Path()
            ..moveTo(c.dx, c.dy)
            ..lineTo(c.dx - unit * 9, c.dy - unit * 0.9)
            ..lineTo(c.dx - unit * 9, c.dy + unit * 0.5)
            ..close(),
          Paint()
            ..color = BackdropTone.window.withValues(alpha: 0.12 * tone.night)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, unit * 0.4),
        );
    }
  }

  // --- Beach ----------------------------------------------------------------

  /// [n] coconut palms between [x0] and [x1], on the beach in front of the
  /// town: tall curved trunks leaning off the vertical, a crown of drooping
  /// fronds. Dark against the sky at night.
  void _palms(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit,
    String salt,
    int n,
  ) {
    final r = tone.rng('palms-$salt');
    const haze = BackdropTone.hazeNear;
    final trunk = Paint()
      ..color = _c(const Color(0xFF6E5A44), haze, mute: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final frond = Paint()
      ..color = _c(const Color(0xFF3F6A3A), haze, mute: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final nut = Paint()..color = _c(const Color(0xFF5A4A2E), haze, mute: 0.3);
    for (var i = 0; i < n; i++) {
      final cx = x0 + (x1 - x0) * ((i + 0.2 + r.nextDouble() * 0.6) / n);
      final h = room * (0.26 + r.nextDouble() * 0.24);
      final lean = (r.nextBool() ? 1 : -1) * h * (0.12 + r.nextDouble() * 0.16);
      final foot = Offset(cx, horizon + room * 0.2);
      final top = Offset(cx + lean, horizon - h);
      trunk.strokeWidth = math.max(0.8, unit * (0.16 + r.nextDouble() * 0.06));
      canvas.drawPath(
        Path()
          ..moveTo(foot.dx, foot.dy)
          ..quadraticBezierTo(
            cx + lean * 0.1,
            horizon - h * 0.5,
            top.dx,
            top.dy,
          ),
        trunk,
      );
      final l = unit * (1.3 + r.nextDouble() * 0.5);
      frond.strokeWidth = math.max(0.7, unit * 0.16);
      for (var k = 0; k < 7; k++) {
        // Spread round the crown, drooping more the further out they reach.
        final a = -math.pi + k * math.pi / 6 + (r.nextDouble() - 0.5) * 0.3;
        final dx = math.cos(a) * l;
        final up = math.sin(a) * l * 0.35;
        canvas.drawPath(
          Path()
            ..moveTo(top.dx, top.dy)
            ..quadraticBezierTo(
              top.dx + dx * 0.55,
              top.dy + up - l * 0.32,
              top.dx + dx,
              top.dy + up + l * 0.38 * (dx.abs() / l + 0.3),
            ),
          frond,
        );
      }
      canvas.drawCircle(
        top.translate(0, unit * 0.18),
        math.max(0.6, unit * 0.16),
        nut,
      );
    }
  }

  // --- Industry -------------------------------------------------------------

  /// Factory chimneys over a sawtooth hall, a plume off each.
  void _chimneys(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit,
  ) {
    final r = tone.rng('chimneys');
    const haze = BackdropTone.hazeMid;
    // The hall at their foot, its roof in north lights.
    final hall = Rect.fromLTRB(x0, horizon - room * 0.13, x1, horizon + room);
    final wall = _c(const Color(0xFF7E6E62), haze);
    canvas.drawRect(hall, Paint()..color = wall);
    final teeth = math.max(3, ((x1 - x0) / (unit * 1.2)).round());
    final tw = (x1 - x0) / teeth;
    final saw = Path()..moveTo(x0, hall.top);
    for (var i = 0; i < teeth; i++) {
      saw
        ..lineTo(x0 + tw * i, hall.top - unit * 0.6)
        ..lineTo(x0 + tw * (i + 1), hall.top);
    }
    saw.close();
    canvas.drawPath(
      saw,
      Paint()
        ..color = _snowy
            ? tone.snow(haze)
            : _c(const Color(0xFF5E6064), haze, mute: 0.35),
    );
    tone.windows(canvas, hall, 0.7, r, bottom: horizon, density: 0.3);

    final n = 2 + r.nextInt(2);
    for (var i = 0; i < n; i++) {
      final cx = x0 + (x1 - x0) * (0.2 + 0.6 * (n == 1 ? 0.5 : i / (n - 1)));
      final h = room * (0.78 + r.nextDouble() * 0.2);
      final wb = unit * 0.8;
      final wt = unit * 0.5;
      final top = horizon - h;
      final brick = _c(
        i.isEven ? const Color(0xFF8E4A3A) : const Color(0xFF8A8A84),
        haze,
        mute: 0.35,
      );
      canvas
        ..drawPath(
          Path()
            ..moveTo(cx - wb / 2, horizon + room)
            ..lineTo(cx - wt / 2, top)
            ..lineTo(cx + wt / 2, top)
            ..lineTo(cx + wb / 2, horizon + room)
            ..close(),
          Paint()..color = brick,
        )
        ..drawRect(
          Rect.fromLTRB(cx - wt * 0.62, top, cx + wt * 0.62, top + unit * 0.3),
          Paint()..color = _c(const Color(0xFF4A4A4A), haze),
        );
      // The plume, drifting off downwind and thinning.
      final drift = r.nextBool() ? 1.0 : -1.0;
      for (var k = 0; k < 6; k++) {
        final t = k / 5;
        canvas.drawCircle(
          Offset(
            cx + drift * unit * (0.3 + t * 3.2),
            top - unit * (0.5 + t * 1.6),
          ),
          unit * (0.45 + t * 0.7),
          Paint()
            ..color = Color.lerp(
              const Color(0xFFD6D6D2),
              tone.look.skyHorizon,
              0.35 + 0.4 * tone.night,
            )!.withValues(alpha: 0.42 * (1 - t * 0.75))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, unit * 0.35),
        );
      }
      if (tone.night > 0.2) {
        canvas.drawCircle(
          Offset(cx, top - 0.6),
          0.9,
          Paint()
            ..color = const Color(
              0xFFD9544A,
            ).withValues(alpha: 0.9 * tone.night),
        );
      }
    }
  }

  // --- Old town -----------------------------------------------------------

  /// Old roofs packed round a bell tower: a quarter that kept its old town
  /// among newer blocks.
  void _oldTown(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit,
  ) {
    final r = tone.rng('old-town');
    const haze = BackdropTone.hazeNear;
    const walls = [
      Color(0xFFC8B494),
      Color(0xFFB89A70),
      Color(0xFFD0C0A0),
      Color(0xFFA8907A),
    ];
    const roofs = [Color(0xFF9A4A30), Color(0xFFA85A36), Color(0xFF8A3E2A)];
    // The tower first, so the houses stand in front of its foot.
    final tx = x0 + (x1 - x0) * (0.35 + r.nextDouble() * 0.3);
    final tw = unit * 0.9;
    final th = room * 0.62;
    final tower = Rect.fromLTRB(
      tx - tw / 2,
      horizon - th,
      tx + tw / 2,
      horizon + room,
    );
    canvas.drawRect(tower, Paint()..color = _c(walls[0], haze));
    final cap = Path()
      ..moveTo(tower.left - unit * 0.12, tower.top)
      ..lineTo(tx, tower.top - room * 0.16)
      ..lineTo(tower.right + unit * 0.12, tower.top)
      ..close();
    canvas
      ..drawPath(
        cap,
        Paint()
          ..color = _snowy
              ? tone.snow(haze)
              : _c(const Color(0xFF5E8C7A), haze, mute: 0.34),
      )
      // The belfry's openings.
      ..drawRect(
        Rect.fromCenter(
          center: Offset(tx, tower.top + unit * 0.6),
          width: tw * 0.4,
          height: unit * 0.6,
        ),
        Paint()..color = _c(const Color(0xFF3A3530), haze),
      );
    var x = x0;
    while (x < x1) {
      final w = unit * (0.9 + r.nextDouble() * 0.9);
      final h = room * (0.12 + r.nextDouble() * 0.1);
      final body = Rect.fromLTRB(x, horizon - h, x + w - 0.3, horizon + room);
      canvas.drawRect(
        body,
        Paint()..color = _c(walls[r.nextInt(walls.length)], haze),
      );
      final roof = Path()
        ..moveTo(body.left - 0.3, body.top)
        ..lineTo(body.center.dx, body.top - w * (0.4 + r.nextDouble() * 0.2))
        ..lineTo(body.right + 0.3, body.top)
        ..close();
      canvas.drawPath(
        roof,
        Paint()
          ..color = _snowy
              ? tone.snow(haze)
              : _c(roofs[r.nextInt(roofs.length)], haze, mute: 0.3),
      );
      tone.windows(canvas, body, 0.8, r, bottom: horizon, density: 0.3);
      x += w;
    }
  }

  // --- River --------------------------------------------------------------

  /// The river running behind the ground, and an old stone bridge across
  /// it on its arches.
  void _river(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit,
  ) {
    const haze = BackdropTone.hazeNear;
    final top = horizon - room * 0.1;
    final water = Rect.fromLTRB(x0, top, x1, horizon + 1);
    final deep = _c(const Color(0xFF3E6478), haze, mute: 0.3);
    canvas.drawRect(
      water,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(deep, tone.look.skyHorizon, 0.4)!,
            deep,
          ],
        ).createShader(water),
    );
    // The light on the water.
    final glint = Paint()
      ..color = Color.lerp(
        tone.look.skyHorizon,
        Colors.white,
        0.3,
      )!.withValues(alpha: 0.35 * tone.day + 0.15 * tone.night)
      ..strokeWidth = 0.6;
    final r = tone.rng('river');
    for (var i = 0; i < 10; i++) {
      final y = top + (horizon - top) * (0.2 + r.nextDouble() * 0.7);
      final gx = x0 + (x1 - x0) * r.nextDouble();
      canvas.drawLine(Offset(gx, y), Offset(gx + unit * 0.8, y), glint);
    }
    // The bridge: a deck on stone arches across the span, piers in the
    // water, a parapet along the top.
    final stone = _c(const Color(0xFFA89C88), haze, mute: 0.35);
    final deckY = horizon - room * 0.2;
    final bx0 = x0 + (x1 - x0) * 0.04;
    final bx1 = x1 - (x1 - x0) * 0.04;
    final arches = math.max(3, ((bx1 - bx0) / (unit * 2.4)).round());
    final aw = (bx1 - bx0) / arches;
    var bridge = Path()..addRect(Rect.fromLTRB(bx0, deckY, bx1, horizon + 0.5));
    for (var i = 0; i < arches; i++) {
      final ax = bx0 + aw * i;
      final arch = Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(
              ax + aw * 0.16,
              deckY + (horizon - deckY) * 0.3,
              ax + aw * 0.84,
              horizon + 1,
            ),
            topLeft: Radius.circular(aw * 0.34),
            topRight: Radius.circular(aw * 0.34),
          ),
        );
      bridge = Path.combine(PathOperation.difference, bridge, arch);
    }
    canvas
      ..drawPath(bridge, Paint()..color = stone)
      ..drawLine(
        Offset(bx0, deckY),
        Offset(bx1, deckY),
        Paint()
          ..color = _snowy
              ? tone.snow(haze)
              : Color.lerp(stone, Colors.white, 0.25)!
          ..strokeWidth = math.max(0.8, unit * 0.14),
      );
    if (tone.night > 0.2) {
      // Its lamps along the parapet.
      for (var i = 0; i <= arches * 2; i++) {
        canvas.drawCircle(
          Offset(bx0 + (bx1 - bx0) * i / (arches * 2), deckY - unit * 0.25),
          0.8,
          Paint()
            ..color = BackdropTone.window.withValues(alpha: 0.85 * tone.night),
        );
      }
    }
  }

  // --- Park ---------------------------------------------------------------

  /// A park's trees, a dense clump of crowns low along the roof line.
  void _park(
    Canvas canvas,
    double x0,
    double x1,
    double horizon,
    double room,
    double unit, {
    String salt = 'a',
  }) {
    final r = tone.rng('park-$salt');
    var x = x0 + r.nextDouble() * unit;
    while (x < x1) {
      final h = room * (0.1 + r.nextDouble() * 0.08);
      final rr = math.max(1.2, h * 0.5);
      final col = _c(tone.tree(r), BackdropTone.hazeNear, mute: 0.3);
      canvas.drawCircle(
        Offset(x, horizon - h + rr),
        rr,
        Paint()..color = col,
      );
      if (_snowy) {
        canvas.drawCircle(
          Offset(x, horizon - h + rr * 0.7),
          rr * 0.6,
          Paint()
            ..color = tone
                .snow(BackdropTone.hazeNear)
                .withValues(
                  alpha: 0.8,
                ),
        );
      }
      x += rr * (1.1 + r.nextDouble() * 0.5);
    }
  }
}
