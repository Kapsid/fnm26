import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

import '../../helpers/pitch_glitches.dart';
import '../../helpers/pitch_match_lab.dart';

/// The owner's 2026-11 "sometimes odd actions", hunted over 60 lab matches
/// (see `PitchGlitches` for what each kind is). Measured before the fixes:
/// 15,345 half-second sprints with a man's back to where he ran, 88 ground
/// balls through a man's feet, 5 shots struck from over 40 m for a long
/// shot recorded nearer, 39 men frozen 3 s and more in open play (a
/// shooter parked on his spot, a taker stood by a dead ball long before
/// it). The ceilings sit just over what is left.
void main() {
  test('the glitch hunt over 60 lab matches', () {
    final all = <PitchGlitches>[];
    for (var seed = 0; seed < 60; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      all.add(
        PitchGlitches(labScript(m, speed, seed: seed), 'match $seed ($speed)')
          ..run(),
      );
    }
    // ignore: avoid_print
    print(glitchReport(all));
    int sum(String kind) => all.fold(0, (a, g) => a + (g.counts[kind] ?? 0));
    expect(sum('shot from nowhere'), 0);
    // A keeper meeting a back pass a few metres outside his area.
    expect(sum('keeper off his area'), lessThanOrEqualTo(2));
    expect(sum('ball off the pitch'), lessThanOrEqualTo(1));
    // A man within 3.5 m of the ball (a blocker closing a shot) keeps his
    // eyes on it: the rest of the 15,345.
    expect(sum('sprinting backwards'), lessThanOrEqualTo(100));
    expect(sum('pass to nobody'), 0);
    expect(
      sum('ball through a man') + sum('ball through a man (turnover)'),
      lessThanOrEqualTo(40),
    );
    expect(sum('frozen in open play'), lessThanOrEqualTo(30));
  });
}
