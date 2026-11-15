import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

/// "A goal went in but the move that led to it was skipped": a goal reached
/// by a phase cut (the picture jumping to the attack) moments before the
/// shot. An open-play goal is given time for its build-up, so this stays
/// rare. Before that, a third of the lab's goals came straight after one.
void main() {
  test('few goals come straight after a cut to the attack', () {
    var goals = 0;
    var skipped = 0;
    for (var seed = 1; seed <= 200; seed++) {
      final m = labMatch(seed);
      final s = labScript(m, PitchSpeed.slow);
      for (final w in s.windows) {
        for (final c in w.cues) {
          if (c.kind != PitchCueKind.goal) continue;
          goals++;
          double? last;
          for (final t in s.cuts) {
            if (t <= c.t && (last == null || t > last)) last = t;
          }
          if (last != null &&
              c.t - last <= 3.5 &&
              s.cutKinds[last] == PitchCutKind.phase) {
            skipped++;
          }
        }
      }
    }
    expect(goals, greaterThan(400));
    expect(
      skipped / goals,
      lessThan(0.13),
      reason: '$skipped of $goals goals came straight after a phase cut',
    );
  });
}
