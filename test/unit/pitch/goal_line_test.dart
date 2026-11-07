import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

import '../../helpers/pitch_view_fixture.dart';

/// The owner: "the goal is not on the goal line!" Both goals stand on
/// their goal lines, posts at 34 ± 3.66 m and the bar at 2.44 m, and the
/// painted goal line runs through the posts' feet.
void main() {
  const half = PitchDims.goalHalfWidth;
  const mid = PitchDims.width / 2;

  final projections = <String, PitchProjection>{
    'phone live': PitchMatchView.projectionFor(const Size(390, 280)),
    'tablet live': PitchMatchView.projectionFor(const Size(1024, 680)),
    'phone mock': const PitchProjection(
      Size(390, 280),
      (centreX: 52.5, zoom: 0.9),
    ),
  };

  test('the posts stand on the goal-line points', () {
    projections.forEach((name, p) {
      for (final left in [true, false]) {
        final x = left ? 0.0 : PitchDims.length;
        final m = StadiumPainter.goalMouth(p, left: left);
        expect(
          (m[0] - p.toScreen(x, mid - half)).distance,
          lessThan(0.5),
          reason: '$name far post',
        );
        expect(
          (m[3] - p.toScreen(x, mid + half)).distance,
          lessThan(0.5),
          reason: '$name near post',
        );
        // The bar right above the posts, 2.44 m up.
        expect(
          (m[1] - p.toScreen(x, mid - half, PitchDims.crossbarHeight)).distance,
          lessThan(0.5),
        );
        expect(
          (m[2] - p.toScreen(x, mid + half, PitchDims.crossbarHeight)).distance,
          lessThan(0.5),
        );
      }
    });
  });

  test('in every goal style and ground, the painted goal line meets the '
      'posts', () async {
    final m = pitchMatch();
    const size = Size(390, 280);
    const ratio = 2.0;
    final p = PitchMatchView.projectionFor(size);
    for (final capacity in [8000, 30000, 80000]) {
      for (final style in GoalStyle.values) {
        final spec = pitchStadiumFor(
          m,
          capacity: capacity,
        ).spec.withLook(goalStyle: style);
        final image = await StadiumPainter(
          spec,
          p,
          light: PitchLight.day,
        ).bake(size, pixelRatio: ratio);
        final bytes = (await image.toByteData())!;
        double lum(Offset o) {
          final x = (o.dx * ratio).round(), y = (o.dy * ratio).round();
          final i = (y * image.width + x) * 4;
          final r = bytes.getUint8(i), g = bytes.getUint8(i + 1);
          final b = bytes.getUint8(i + 2);
          return (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255;
        }

        for (final left in [true, false]) {
          final x = left ? 0.0 : PitchDims.length;
          // On the painted line: at each post's foot and in the middle of
          // the mouth, white paint (the grass is a dark green).
          for (final y in [mid - half, mid, mid + half]) {
            final at = p.toScreen(x, y);
            expect(
              lum(at),
              greaterThan(0.45),
              reason: '$capacity $style ${left ? 'left' : 'right'} y $y',
            );
          }
          // And a metre in front of the line, grass.
          final grass = p.toScreen(left ? 1.2 : PitchDims.length - 1.2, mid);
          expect(lum(grass), lessThan(0.4));
        }
        image.dispose();
      }
    }
  });

  test('a ball in the net is behind the painted line', () {
    // The staging puts a goal past the line by the same numbers.
    final p = PitchMatchView.projectionFor(const Size(390, 280));
    final line = p.toScreen(0, mid);
    final inNet = p.toScreenOpen(-0.8, mid);
    expect(inNet.dx, lessThan(line.dx));
    final lineR = p.toScreen(PitchDims.length, mid);
    final inNetR = p.toScreenOpen(PitchDims.length + 0.8, mid);
    expect(inNetR.dx, greaterThan(lineR.dx));
  });
}
