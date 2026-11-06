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
class StadiumLooks {
  StadiumLooks._(this.day, this.dusk, this.night, this.size);

  final ui.Image day, dusk, night;

  /// The logical size the images were baked for.
  final Size size;

  static Future<StadiumLooks> bake(
    StadiumSpec spec,
    PitchProjection projection,
    Size size, {
    ui.Image? flag,
    MatchDressing dressing = MatchDressing.none,
    double pixelRatio = 1,
  }) async {
    Future<ui.Image> one(PitchLight light) => StadiumPainter(
      spec,
      projection,
      flag: flag,
      light: light,
      dressing: dressing,
    ).bake(size, pixelRatio: pixelRatio);
    return StadiumLooks._(
      await one(PitchLight.day),
      await one(PitchLight.dusk),
      await one(PitchLight.night),
      size,
    );
  }

  ui.Image _of(SceneLook l) => identical(l, SceneLook.day)
      ? day
      : identical(l, SceneLook.dusk)
      ? dusk
      : night;

  /// Paints the ground into [dst] as it looks in [light].
  void paint(Canvas canvas, Rect dst, PitchLight light) {
    final (a, b, t) = SceneLook.weights(light);
    final paint = Paint()..filterQuality = FilterQuality.medium;
    _draw(canvas, _of(a), dst, paint);
    if (t > 0) {
      _draw(
        canvas,
        _of(b),
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
    day.dispose();
    dusk.dispose();
    night.dispose();
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
