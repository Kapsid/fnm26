import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';

import '../../helpers/pitch_match_lab.dart';

/// What the 2D TV's crowd reacts to: every staged shot's move as it starts,
/// then the shot as it is struck; never a goal going in (the screen sounds
/// that with its flash); each cue once, however the clock is sliced.
void main() {
  PitchPlayback playback(int seed) => PitchPlayback(
    labScript(labMatch(seed), PitchSpeed.values[seed % 3], seed: seed),
  );

  test('a shot builds before it is struck; a goal going in is no cue', () {
    var shots = 0;
    for (var seed = 0; seed < 20; seed++) {
      final pb = playback(seed);
      final all = pb.crowdCuesBetween(
        const Duration(milliseconds: -10),
        pb.pacer.total,
      );
      for (final c in all) {
        final m = c.moment;
        if (m is ShotMoment && m.outcome == ShotOutcome.goal) {
          expect(c.build, isTrue, reason: 'match $seed: a goal only builds');
        }
      }
      final builds = [
        for (final c in all)
          if (c.build) c.moment,
      ];
      for (final c in all.where((c) => !c.build)) {
        final m = c.moment;
        if (m is! ShotMoment) continue;
        shots++;
        final b = builds.indexWhere((x) => identical(x, m));
        expect(b, isNonNegative, reason: 'match $seed: struck, never built');
      }
    }
    expect(shots, greaterThan(20), reason: 'the lab matches have shots');
  });

  test('sliced into frames, every cue comes exactly once', () {
    for (var seed = 0; seed < 8; seed++) {
      final pb = playback(seed);
      final whole = pb.crowdCuesBetween(
        const Duration(milliseconds: -10),
        pb.pacer.total,
      );
      final sliced = <({MatchMoment moment, bool build})>[];
      var from = const Duration(milliseconds: -10);
      const frame = Duration(milliseconds: 16);
      while (from < pb.pacer.total) {
        final to = from + frame;
        sliced.addAll(pb.crowdCuesBetween(from, to));
        from = to;
      }
      expect(sliced.length, whole.length, reason: 'match $seed');
    }
  });
}
