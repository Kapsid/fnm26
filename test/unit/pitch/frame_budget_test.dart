import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../../helpers/pitch_view_fixture.dart';

/// The Pitch view repaints only its actors each frame: the stadium is a
/// cached image. Sampling the script and recording the actors' picture must
/// fit 4 ms on the desktop test machine, a proxy for 60 fps on a Galaxy A56.
void main() {
  test('frame budget ≤ 4 ms averaged over 600 frames', () {
    final m = pitchMatch(seed: 5, speed: PitchSpeed.slow);
    final stadium = pitchStadiumFor(m, capacity: 80000);
    for (final size in const [Size(390, 280), Size(1024, 680)]) {
      final clock = ValueNotifier<Duration>(Duration.zero);
      final painter = ActorsPainter(
        script: m.script,
        clock: clock,
        projection: PitchMatchView.projectionFor(size),
        kits: stadium.kits,
        names: m.names,
        lightAt: stadium.lightAt,
      );
      final total = m.script.totalSeconds;
      double run(int frames, {required int offset}) {
        final sw = Stopwatch();
        for (var i = 0; i < frames; i++) {
          // Spread over the whole match, moments and cuts included.
          final t = ((i + offset) * 0.37) % total;
          clock.value = Duration(microseconds: (t * 1e6).round());
          sw.start();
          final recorder = ui.PictureRecorder();
          painter.paint(Canvas(recorder), size);
          final picture = recorder.endRecording();
          sw.stop();
          picture.dispose();
        }
        return sw.elapsedMicroseconds / frames / 1000;
      }

      run(120, offset: 9000); // warm the JIT and the text caches
      final ms = run(600, offset: 0);
      debugPrint(
        'frame budget ${size.width.toInt()}x${size.height.toInt()}: '
        '${ms.toStringAsFixed(3)} ms per frame over 600 frames',
      );
      expect(ms, lessThanOrEqualTo(4));
      clock.dispose();
    }
  });

  test('bake cost per look, big ground', () async {
    final m = pitchMatch(seed: 5);
    const size = Size(390, 280);
    for (final capacity in [8000, 30000, 80000]) {
      final stadium = pitchStadiumFor(m, capacity: capacity);
      final baker = PitchStadiumBaker();
      final projection = PitchMatchView.projectionFor(size);
      // Once to warm up, then measured.
      await baker.look(stadium, projection, size, PitchLight.day);
      for (final light in [PitchLight.day, PitchLight.dusk, PitchLight.night]) {
        final sw = Stopwatch()..start();
        final img = await baker.look(
          stadium,
          projection,
          size,
          light,
          pixelRatio: 2.6,
        );
        sw.stop();
        debugPrint(
          'bake $capacity ${light.mode.name}: '
          'record ${baker.lastRecordMs.toStringAsFixed(1)} ms (UI thread), '
          'total ${sw.elapsedMilliseconds} ms',
        );
        // The UI-thread part of one look stays well under a few frames.
        expect(baker.lastRecordMs, lessThan(250));
        img.dispose();
      }
    }
  });
}
