import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

/// One ground baked in its three key looks (day, dusk and night) once, and
/// cross-faded between the two nearest for the light of any moment.
///
/// Nothing is re-baked while a match plays: the sun going down across a
/// match is a fade between images already made.
///
/// The looks may arrive one at a time (the live view bakes the one the
/// kick-off needs first and the others after it, so no single bake holds
/// up a frame for long). Until all three are in, a missing look is stood in
/// for by the nearest one that is.
class StadiumLooks {
  StadiumLooks(this.size);

  /// The logical size the images were baked for.
  final Size size;
  final Map<LightMode, ui.Image> _images = {};

  static Future<StadiumLooks> bake(
    StadiumSpec spec,
    PitchProjection projection,
    Size size, {
    ui.Image? flag,
    MatchDressing dressing = MatchDressing.none,
    double pixelRatio = 1,
  }) async {
    final looks = StadiumLooks(size);
    for (final mode in LightMode.values) {
      looks.add(
        mode,
        await StadiumPainter(
          spec,
          projection,
          flag: flag,
          light: keyLight(mode),
          dressing: dressing,
        ).bake(size, pixelRatio: pixelRatio),
      );
    }
    return looks;
  }

  /// The light each key look is baked in.
  static PitchLight keyLight(LightMode mode) => switch (mode) {
    LightMode.day => PitchLight.day,
    LightMode.dusk => PitchLight.dusk,
    LightMode.night => PitchLight.night,
  };

  static LightMode _modeOf(SceneLook l) => identical(l, SceneLook.day)
      ? LightMode.day
      : identical(l, SceneLook.dusk)
      ? LightMode.dusk
      : LightMode.night;

  /// Adds the baked image for [mode] (replacing and disposing any before).
  void add(LightMode mode, ui.Image image) {
    _images.remove(mode)?.dispose();
    _images[mode] = image;
  }

  bool get isEmpty => _images.isEmpty;

  /// All three looks are in.
  bool get complete => _images.length == LightMode.values.length;

  ui.Image? _of(LightMode m) =>
      _images[m] ??
      switch (m) {
        LightMode.day => _images[LightMode.dusk] ?? _images[LightMode.night],
        LightMode.dusk => _images[LightMode.day] ?? _images[LightMode.night],
        LightMode.night => _images[LightMode.dusk] ?? _images[LightMode.day],
      };

  /// Paints the ground into [dst] as it looks in [light].
  void paint(Canvas canvas, Rect dst, PitchLight light) {
    final (a, b, t) = SceneLook.weights(light);
    final first = _of(_modeOf(a));
    if (first == null) return;
    final second = _of(_modeOf(b));
    final paint = Paint()..filterQuality = FilterQuality.medium;
    _draw(canvas, first, dst, paint);
    if (t > 0 && second != null && !identical(second, first)) {
      _draw(
        canvas,
        second,
        dst,
        paint..color = const Color(0xFFFFFFFF).withValues(alpha: t),
      );
    }
  }

  static void _draw(Canvas canvas, ui.Image img, Rect dst, Paint paint) =>
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        dst,
        paint,
      );

  void dispose() {
    for (final img in _images.values) {
      img.dispose();
    }
    _images.clear();
  }
}

/// How the players' shadows fall in one moment's light: one shadow from the
/// sun (long as it gets low, gone at night) and a soft one away from each
/// floodlight tower (coming up through dusk). Continuous in the light, so
/// the shadows turn and stretch as the sun sets rather than jump.
class TokenShadows {
  const TokenShadows._({
    required this.sunDirection,
    required this.sunLength,
    required this.sunAlpha,
    required this.towerAlpha,
    required this.towerLength,
  });

  factory TokenShadows.of(PitchLight light) {
    final f = light.flood;
    final e = math.max(light.elevation, 1.5) * math.pi / 180;
    // The sun stands behind the far stand, to the left: shadows fall toward
    // the camera and a little right, swinging further right as it sets.
    final swing = (1 - (light.elevation.clamp(0.0, 35.0) / 35)) * 0.35;
    final dir = Offset(0.55 + swing, 0.6);
    return TokenShadows._(
      sunDirection: dir / dir.distance,
      sunLength: (0.55 / math.tan(e)).clamp(0.45, 3.2),
      sunAlpha: 0.42 * (1 - f),
      towerAlpha: 0.17 * f,
      towerLength: 1.3,
    );
  }

  /// Unit screen direction of the sun shadow.
  final Offset sunDirection;

  /// Sun shadow length, in token radii.
  final double sunLength;
  final double sunAlpha;

  /// Each tower's shadow strength, and its length in token radii.
  final double towerAlpha;
  final double towerLength;
}
