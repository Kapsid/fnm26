import 'dart:ui' show Offset, Size;

import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/pitch_view_geometry.dart';

/// Maps pitch metres (x along the length, y across, y = 0 the far touchline)
/// to screen pixels as a tilted pitch: the far touchline is drawn narrower
/// than the near one. [tilt] is how strongly it narrows (0 = flat).
class PitchProjection {
  const PitchProjection(
    this.viewport,
    this.cam, {
    this.tilt = PitchViewGeometry.tilt,
    this.top = PitchViewGeometry.top,
    this.bottom = PitchViewGeometry.bottom,
  });

  final Size viewport;
  final PitchCamera cam;
  final double tilt;

  /// Where the far and the near touchline sit, as fractions of the viewport
  /// height. What is above [top] is the far stand's and the skyline's: three
  /// tenths of the height lets a three-tier stand, its roof flags and a
  /// city's landmark above them all read at phone size (the sign-off mock,
  /// Task 11).
  final double top, bottom;

  double get _farScale => 1 - 0.5 * tilt;

  /// Width scale at pitch [y]: [_farScale] at the far touchline, 1 at the
  /// near one.
  double scaleAt(double y) {
    final v = (y / PitchDims.width).clamp(0.0, 1.0);
    return _farScale + (1 - _farScale) * v;
  }

  Offset toScreen(double x, double y, [double z = 0]) =>
      _project(x, y, z, open: false);

  /// [toScreen] for points off the playing surface: the run-off, the ad
  /// boards and the stands. [y] may run past either touchline (negative
  /// behind the far one), and the tilt carries on past it instead of
  /// stopping at the line, so the stadium recedes with the pitch.
  Offset toScreenOpen(double x, double y, [double z = 0]) =>
      _project(x, y, z, open: true);

  /// Pixels per metre along the pitch at depth [y] (the same at any [x]).
  double pxPerMetreAt(double y) =>
      viewport.width / (PitchDims.length / cam.zoom) * _scale(y, open: true);

  double _scale(double y, {required bool open}) {
    final v = y / PitchDims.width;
    return _farScale + (1 - _farScale) * (open ? v : v.clamp(0.0, 1.0));
  }

  Offset _project(double x, double y, double z, {required bool open}) {
    final s = _scale(y, open: open);
    final visibleW = PitchDims.length / cam.zoom;
    final u = (x - cam.centreX) / visibleW;
    final sx = viewport.width * (0.5 + u * s);
    final v = open
        ? y / PitchDims.width
        : (y / PitchDims.width).clamp(0.0, 1.0);
    final frac = v * s;
    final sy = viewport.height * (top + (bottom - top) * frac);
    final pxPerMetre = viewport.width / visibleW * s;
    return Offset(sx, sy - z * pxPerMetre * tilt);
  }
}
