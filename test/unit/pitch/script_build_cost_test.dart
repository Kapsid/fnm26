import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/pitch/pitch_mode_controller.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import '../../helpers/pitch_match_lab.dart';

/// What a rebuild of the picture costs (a sub, a talk, a speed tap): the
/// match screen builds it off the UI thread when this is too much for a
/// frame. Prints the figures; checks an isolate build is the same script.
void main() {
  test('script build cost, and an isolate builds the same script', () async {
    final full = <int>[];
    final resumed = <int>[];
    for (var seed = 0; seed < 12; seed++) {
      final m = labMatch(seed);
      final pacer = PitchPacer(m.result, PitchSpeed.values[seed % 3]);
      var sw = Stopwatch()..start();
      final s = StoryLayer.build(
        result: m.result,
        lineups: m.lineups,
        pacer: pacer,
        seed: seed,
      );
      full.add(sw.elapsedMilliseconds);
      final at = Duration(microseconds: (s.totalSeconds * 0.5 * 1e6).round());
      final state = s.stateAt(at);
      sw = Stopwatch()..start();
      StoryLayer.build(
        result: m.result,
        lineups: m.lineups,
        pacer: pacer,
        seed: seed,
        resumeFrom: state,
      );
      resumed.add(sw.elapsedMilliseconds);
    }
    full.sort();
    resumed.sort();
    debugPrint(
      'script build (ms), 12 matches: full median ${full[6]} max '
      '${full.last}; resumed at half-way median ${resumed[6]} max '
      '${resumed.last}',
    );

    // Off the UI thread, as the app builds it: the same script comes back.
    final m = labMatch(5);
    final here = StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, pitchSpeedForStep(1)),
      seed: 5,
    );
    final sw = Stopwatch()..start();
    final build = PitchBuild(
      result: m.result,
      lineups: m.lineups,
      speedStep: 1,
      seed: 5,
      isFinal: false,
    );
    final there = (await Isolate.run(build.run)).script;
    debugPrint('isolate round trip: ${sw.elapsedMilliseconds} ms');
    expect(there.keyframes.length, here.keyframes.length);
    for (final t in [1.0, 30.0, here.totalSeconds / 2, here.totalSeconds - 1]) {
      final d = Duration(microseconds: (t * 1e6).round());
      expect(there.sample(d).players, here.sample(d).players);
      expect(there.sample(d).ball, here.sample(d).ball);
    }
    expect(there.pacer.total, here.pacer.total);
    expect(
      there.pacer.momentLength(there.result.moments.first),
      here.pacer.momentLength(here.result.moments.first),
    );
    expect(there.windows.length, here.windows.length);
  });
}
