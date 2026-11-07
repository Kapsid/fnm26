import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/painting.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';

/// The weather falling over the Pitch view: rain streaks or snowflakes.
/// (Heat haze does not fall: it is baked into the ground's looks.)
///
/// The drops are drawn once into a tile the size of the view and kept; each
/// frame only blits that tile, scrolled by the time, so the weather costs a
/// few image draws a frame and nothing is redrawn.
///
/// Cosmetic only: nothing here reads or changes the match.
class WeatherOverlay {
  WeatherOverlay(this.kind, {this.seed = 0});

  final WeatherKind kind;
  final int seed;

  ui.Image? _tile;
  (Size, double)? _tileKey;

  /// The cached tile (for tests).
  @visibleForTesting
  ui.Image? get debugTile => _tile;

  /// Whether anything falls in this weather.
  bool get falls => kind == WeatherKind.rain || kind == WeatherKind.snow;

  /// How far the drops fall a second, and drift sideways, in pixels per
  /// logical pixel of view height.
  Offset get _velocity => switch (kind) {
    WeatherKind.rain => const Offset(-0.32, 1.9),
    WeatherKind.snow => const Offset(0.05, 0.12),
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
    if (!falls || size.isEmpty) return;
    final tile = _tileFor(size, pixelRatio);
    final v = _velocity * size.height * seconds;
    final dx = v.dx % size.width;
    final dy = v.dy % size.height;
    final paint = Paint()..filterQuality = FilterQuality.low;
    canvas
      ..save()
      ..clipRect(Offset.zero & size);
    for (final ox in [dx - size.width, dx]) {
      for (final oy in [dy - size.height, dy]) {
        canvas.drawImageRect(
          tile,
          Rect.fromLTWH(0, 0, tile.width.toDouble(), tile.height.toDouble()),
          Rect.fromLTWH(ox, oy, size.width, size.height),
          paint,
        );
      }
    }
    canvas.restore();
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

  /// One tile's drops, seamless when tiled.
  void paintTile(Canvas canvas, Size size) {
    final r = math.Random(seed * 7919 + kind.index);
    final area = size.width * size.height;
    switch (kind) {
      case WeatherKind.rain:
        final n = (area / 900).round();
        for (var i = 0; i < n; i++) {
          final p = Offset(
            r.nextDouble() * size.width,
            r.nextDouble() * size.height,
          );
          final len = 7 + r.nextDouble() * 9;
          final d = const Offset(-0.17, 1) * len;
          final paint = Paint()
            ..strokeWidth = 0.8 + r.nextDouble() * 0.5
            ..strokeCap = StrokeCap.round
            ..color = const Color(
              0xFFD6E0EA,
            ).withValues(alpha: 0.16 + r.nextDouble() * 0.2);
          _wrapped(size, p, (o) => canvas.drawLine(o, o + d, paint));
        }
      case WeatherKind.snow:
        final n = (area / 1400).round();
        for (var i = 0; i < n; i++) {
          final p = Offset(
            r.nextDouble() * size.width,
            r.nextDouble() * size.height,
          );
          final rad = 0.8 + r.nextDouble() * 1.5;
          final paint = Paint()
            ..color = const Color(
              0xFFF4F7FA,
            ).withValues(alpha: 0.55 + r.nextDouble() * 0.4);
          _wrapped(size, p, (o) => canvas.drawCircle(o, rad, paint));
        }
      case WeatherKind.clear:
      case WeatherKind.haze:
        return;
    }
  }

  /// Draws at [p] and, near an edge, again across it, so the tile repeats
  /// without a seam.
  static void _wrapped(Size size, Offset p, void Function(Offset) draw) {
    for (final ox in [-size.width, 0.0, size.width]) {
      for (final oy in [-size.height, 0.0, size.height]) {
        final q = p.translate(ox, oy);
        if (q.dx < -20 || q.dx > size.width + 20) continue;
        if (q.dy < -20 || q.dy > size.height + 20) continue;
        draw(q);
      }
    }
  }

  void dispose() {
    _tile?.dispose();
    _tile = null;
  }
}
