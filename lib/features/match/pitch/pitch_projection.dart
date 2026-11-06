import 'dart:ui' show Offset, Size;

import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

/// Maps pitch metres (x along the length, y across, y = 0 the far touchline)
/// to screen pixels as a tilted pitch: the far touchline is drawn narrower
/// than the near one. [tilt] is how strongly it narrows (0 = flat).
class PitchProjection {
  const PitchProjection(this.viewport, this.cam, {this.tilt = 0.55});

  final Size viewport;
  final PitchCamera cam;
  final double tilt;

  /// Fraction of the viewport height the pitch occupies, top and bottom.
  static const double _top = 0.12, _bottom = 0.92;

  double get _farScale => 1 - 0.5 * tilt;

  /// Width scale at pitch [y]: [_farScale] at the far touchline, 1 at the
  /// near one.
  double scaleAt(double y) {
    final v = (y / PitchDims.width).clamp(0.0, 1.0);
    return _farScale + (1 - _farScale) * v;
  }

  Offset toScreen(double x, double y, [double z = 0]) {
    final s = scaleAt(y);
    final visibleW = PitchDims.length / cam.zoom;
    final u = (x - cam.centreX) / visibleW;
    final sx = viewport.width * (0.5 + u * s);
    final v = (y / PitchDims.width).clamp(0.0, 1.0);
    final frac = v * s;
    final sy = viewport.height * (_top + (_bottom - _top) * frac);
    final pxPerMetre = viewport.width / visibleW * s;
    return Offset(sx, sy - z * pxPerMetre * tilt);
  }
}
