import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/painting.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';

/// The weather moving over the Pitch view: rain streaks, snowflakes, fog
/// banks and dust drifting past, and a thunderstorm's lightning. (Heat
/// haze, the grey of a fog, the ochre of a dust storm and a frosty night's
/// rime do not move: they are baked into the ground's looks.)
///
/// The weather is drawn once into a tile the size of the view and kept;
/// each frame only blits that tile, scrolled by the time, so the weather
/// costs a few image draws a frame and nothing is redrawn. Lightning is one
/// rectangle, washed in now and then: soft, never a strobe.
///
/// Cosmetic only: nothing here reads or changes the match.
class WeatherOverlay {
  /// [cold] turns a gale's rain into driven snow.
  WeatherOverlay(this.kind, {this.seed = 0, this.cold = false});

  final WeatherKind kind;
  final int seed;
  final bool cold;

  ui.Image? _tile;
  (Size, double)? _tileKey;
  final Paint _blit = Paint()..filterQuality = FilterQuality.low;
  final Paint _flash = Paint();
  final Paint _bolt = Paint()
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  final List<Path> _bolts = [];
  Size? _flashSize;

  /// The cached tile (for tests).
  @visibleForTesting
  ui.Image? get debugTile => _tile;

  /// Whether rain or snow falls in this weather.
  bool get falls => switch (kind) {
    WeatherKind.rain ||
    WeatherKind.heavyRain ||
    WeatherKind.thunderstorm ||
    WeatherKind.windy ||
    WeatherKind.snow => true,
    _ => false,
  };

  /// Whether anything moves in this weather: falling, drifting or flashing.
  bool get animates =>
      falls || kind == WeatherKind.fog || kind == WeatherKind.dustStorm;

  /// How far the weather falls a second, and drifts sideways, in pixels per
  /// logical pixel of view height.
  Offset get _velocity => switch (kind) {
    WeatherKind.rain => const Offset(-0.32, 1.9),
    WeatherKind.heavyRain ||
    WeatherKind.thunderstorm => const Offset(-0.42, 2.5),
    WeatherKind.windy =>
      cold ? const Offset(1.1, 0.42) : const Offset(1.9, 2.1),
    WeatherKind.snow => const Offset(0.05, 0.12),
    WeatherKind.fog => const Offset(0.025, 0),
    WeatherKind.dustStorm => const Offset(0.55, 0.05),
    _ => Offset.zero,
  };

  /// Paints the weather over [size] at [seconds] of screen time. The tile
  /// is made at [pixelRatio] (the device's), so the drops stay sharp.
  void paint(
    Canvas canvas,
    Size size,
    double seconds, {
    double pixelRatio = 1,
  }) {
    if (!animates || size.isEmpty) return;
    final tile = _tileFor(size, pixelRatio);
    final v = _velocity * size.height * seconds;
    final dx = v.dx % size.width;
    final dy = v.dy % size.height;
    final src = Rect.fromLTWH(
      0,
      0,
      tile.width.toDouble(),
      tile.height.toDouble(),
    );
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..drawImageRect(
        tile,
        src,
        Rect.fromLTWH(
          dx - size.width,
          dy - size.height,
          size.width,
          size.height,
        ),
        _blit,
      )
      ..drawImageRect(
        tile,
        src,
        Rect.fromLTWH(dx, dy - size.height, size.width, size.height),
        _blit,
      )
      ..drawImageRect(
        tile,
        src,
        Rect.fromLTWH(dx - size.width, dy, size.width, size.height),
        _blit,
      )
      ..drawImageRect(
        tile,
        src,
        Rect.fromLTWH(dx, dy, size.width, size.height),
        _blit,
      );
    if (kind == WeatherKind.thunderstorm) {
      final a = flashAt(seconds);
      if (a > 0.004) {
        if (_flashSize != size) {
          _flashSize = size;
          _flash.shader = ui.Gradient.linear(
            Offset.zero,
            Offset(0, size.height),
            const [Color(0xFFE8EEFF), Color(0x99E8EEFF), Color(0x00E8EEFF)],
            const [0, 0.32, 0.72],
          );
          _bolts
            ..clear()
            ..addAll([for (var i = 0; i < 3; i++) _boltPath(size, i)]);
        }
        _flash.color = Color.fromRGBO(255, 255, 255, a * _flashPeak);
        canvas.drawRect(Offset.zero & size, _flash);
        // At the flash's height, the bolt itself, far off over the stand.
        if (a > 0.5) {
          final bolt = _bolts[(seconds / _flashWindow).floor() % _bolts.length];
          _bolt
            ..strokeWidth = 1.2
            ..color = Color.fromRGBO(240, 244, 255, (a - 0.5) * 1.6);
          canvas.drawPath(bolt, _bolt);
        }
      }
    }
    canvas.restore();
  }

  /// How strong a lightning flash gets at its brightest: a wash over the
  /// sky and the stands, never a white-out.
  static const double _flashPeak = 0.3;

  /// One flash per window of this many seconds at most, two in three
  /// windows: under three a minute.
  static const double _flashWindow = 24;

  /// How bright the lightning is at [seconds], 0 to 1: a quick flash, a
  /// weaker second one just after, each eased in and out.
  @visibleForTesting
  double flashAt(double seconds) {
    if (kind != WeatherKind.thunderstorm || seconds < 0) return 0;
    final k = (seconds / _flashWindow).floor();
    final h = _hash(seed * 31 + k);
    if (h % 3 == 0) return 0;
    final t0 = 2 + (h >> 4) % 1000 / 1000 * (_flashWindow - 5);
    final t = seconds - k * _flashWindow - t0;
    if (t < -0.3 || t > 1.2) return 0;
    double pulse(double at, double width) {
      final x = (t - at) / width;
      return math.exp(-x * x);
    }

    return math.min(1, pulse(0, 0.09) + 0.55 * pulse(0.32, 0.14));
  }

  /// A forked bolt of lightning in the sky over the far stand, one of a
  /// few, [i], made once per view size.
  Path _boltPath(Size size, int i) {
    final r = math.Random(seed * 101 + i);
    var x = size.width * (0.15 + 0.7 * r.nextDouble());
    var y = 0.0;
    final end = size.height * (0.1 + 0.05 * r.nextDouble());
    final path = Path()..moveTo(x, y);
    var fork = true;
    while (y < end) {
      x += (r.nextDouble() - 0.5) * size.height * 0.05;
      y += size.height * (0.015 + 0.015 * r.nextDouble());
      path.lineTo(x, y);
      if (fork && y > end * 0.4) {
        fork = false;
        path
          ..moveTo(x, y)
          ..lineTo(x + size.height * 0.03, y + size.height * 0.03)
          ..moveTo(x, y);
      }
    }
    return path;
  }

  static int _hash(int x) {
    var h = x * 0x9E3779B1 & 0x7FFFFFFF;
    h ^= h >> 15;
    h = h * 0x85EBCA77 & 0x7FFFFFFF;
    return h ^ (h >> 13);
  }

  ui.Image _tileFor(Size size, double pixelRatio) {
    final had = _tile;
    if (had != null && _tileKey == (size, pixelRatio)) return had;
    had?.dispose();
    final recorder = ui.PictureRecorder();
    paintTile(Canvas(recorder)..scale(pixelRatio), size);
    final picture = recorder.endRecording();
    final img = picture.toImageSync(
      (size.width * pixelRatio).ceil(),
      (size.height * pixelRatio).ceil(),
    );
    picture.dispose();
    _tileKey = (size, pixelRatio);
    return _tile = img;
  }

  /// One tile's weather, seamless when tiled.
  void paintTile(Canvas canvas, Size size) {
    final r = math.Random(seed * 7919 + kind.index);
    final area = size.width * size.height;
    void streaks(
      double per,
      double len0,
      double len1,
      Offset slant,
      double a0,
      double a1, {
      Color colour = const Color(0xFFD6E0EA),
    }) {
      final n = (area / per).round();
      for (var i = 0; i < n; i++) {
        final p = Offset(
          r.nextDouble() * size.width,
          r.nextDouble() * size.height,
        );
        final d = slant * (len0 + r.nextDouble() * (len1 - len0));
        final paint = Paint()
          ..strokeWidth = 0.8 + r.nextDouble() * 0.5
          ..strokeCap = StrokeCap.round
          ..color = colour.withValues(alpha: a0 + r.nextDouble() * (a1 - a0));
        _wrapped(size, p, (o) => canvas.drawLine(o, o + d, paint));
      }
    }

    void flakes(double per, double alpha0) {
      final n = (area / per).round();
      for (var i = 0; i < n; i++) {
        final p = Offset(
          r.nextDouble() * size.width,
          r.nextDouble() * size.height,
        );
        final rad = 0.8 + r.nextDouble() * 1.5;
        final paint = Paint()
          ..color = const Color(
            0xFFF4F7FA,
          ).withValues(alpha: alpha0 + r.nextDouble() * 0.4);
        _wrapped(size, p, (o) => canvas.drawCircle(o, rad, paint));
      }
    }

    switch (kind) {
      case WeatherKind.rain:
        streaks(900, 7, 16, const Offset(-0.17, 1), 0.16, 0.36);
      case WeatherKind.heavyRain:
      case WeatherKind.thunderstorm:
        streaks(380, 11, 22, const Offset(-0.17, 1), 0.2, 0.42);
      case WeatherKind.windy:
        if (cold) {
          // Driven snow: short white streaks along the wind.
          streaks(
            1000,
            3,
            6,
            const Offset(1, 0.38),
            0.5,
            0.9,
            colour: const Color(0xFFF4F7FA),
          );
        } else {
          streaks(520, 12, 22, const Offset(0.9, 1), 0.18, 0.4);
        }
      case WeatherKind.snow:
        flakes(1400, 0.55);
      case WeatherKind.fog:
        // Banks of fog: big soft blobs, thickest up the frame where the far
        // stand is, thinning towards the near touchline.
        final n = math.max(6, (size.width / 38).round());
        for (var i = 0; i < n; i++) {
          final y = size.height * math.pow(r.nextDouble(), 1.6) * 0.85;
          final p = Offset(r.nextDouble() * size.width, y);
          final w = size.width * (0.18 + r.nextDouble() * 0.22);
          final hh = w * (0.22 + r.nextDouble() * 0.12);
          final paint = Paint()
            ..color = const Color(0xFFC9CFD4).withValues(
              alpha: (0.1 + r.nextDouble() * 0.1) * (1 - y / size.height),
            )
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, hh * 0.45);
          _wrapped(
            size,
            p,
            (o) => canvas.drawOval(
              Rect.fromCenter(center: o, width: w, height: hh),
              paint,
            ),
            margin: w,
          );
        }
      case WeatherKind.dustStorm:
        // Long wisps of dust and fine grit, blown across the frame.
        final wisps = math.max(5, (size.width / 50).round());
        for (var i = 0; i < wisps; i++) {
          final p = Offset(
            r.nextDouble() * size.width,
            r.nextDouble() * size.height,
          );
          final w = size.width * (0.25 + r.nextDouble() * 0.3);
          final hh = 6 + r.nextDouble() * 14;
          final paint = Paint()
            ..color = const Color(
              0xFFC89A5C,
            ).withValues(alpha: 0.1 + r.nextDouble() * 0.1)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, hh * 0.6);
          _wrapped(
            size,
            p,
            (o) => canvas.drawOval(
              Rect.fromCenter(center: o, width: w, height: hh),
              paint,
            ),
            margin: w,
          );
        }
        final grit = (area / 700).round();
        for (var i = 0; i < grit; i++) {
          final p = Offset(
            r.nextDouble() * size.width,
            r.nextDouble() * size.height,
          );
          final len = 2 + r.nextDouble() * 5;
          final paint = Paint()
            ..strokeWidth = 0.7 + r.nextDouble() * 0.6
            ..strokeCap = StrokeCap.round
            ..color = const Color(
              0xFFE2BC82,
            ).withValues(alpha: 0.25 + r.nextDouble() * 0.3);
          _wrapped(
            size,
            p,
            (o) => canvas.drawLine(o, o.translate(len, len * 0.1), paint),
          );
        }
      case WeatherKind.clear:
      case WeatherKind.haze:
      case WeatherKind.frostyNight:
        return;
    }
  }

  /// Draws at [p] and, near an edge, again across it, so the tile repeats
  /// without a seam.
  static void _wrapped(
    Size size,
    Offset p,
    void Function(Offset) draw, {
    double margin = 20,
  }) {
    for (final ox in [-size.width, 0.0, size.width]) {
      for (final oy in [-size.height, 0.0, size.height]) {
        final q = p.translate(ox, oy);
        if (q.dx < -margin || q.dx > size.width + margin) continue;
        if (q.dy < -margin || q.dy > size.height + margin) continue;
        draw(q);
      }
    }
  }

  // --- Breath on a frosty night ------------------------------------------------

  static final Paint _breath = Paint();

  /// A player's breath on a frosty night: a small puff that forms in front
  /// of his face and fades as it drifts up, every few seconds, each man on
  /// his own rhythm ([index]). [c] and [r] are his token's centre and
  /// radius, [facing] the way he looks on screen.
  static void paintBreath(
    Canvas canvas,
    Offset c,
    double r,
    double facing,
    double seconds,
    int index,
  ) {
    const period = 2.6;
    final phase = (seconds + index * 0.73) % period / period;
    if (phase > 0.5) return;
    final p = phase / 0.5;
    final out = r * (1.05 + p * 0.7);
    final centre = Offset(
      c.dx + math.cos(facing) * out,
      c.dy + math.sin(facing) * out - r * (0.35 + p * 0.5),
    );
    _breath.color = Color.fromRGBO(236, 242, 248, 0.6 * (1 - p) * (0.4 + p));
    canvas.drawCircle(centre, r * (0.26 + p * 0.36), _breath);
  }

  void dispose() {
    _tile?.dispose();
    _tile = null;
  }
}
