import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

/// The match screen's three speed steps (the owner's 2026-11-07 ask): 2x
/// plays as 3x used to (the fast pacing at 1.5x) and 3x a quarter faster
/// again; 1x is unchanged.
void main() {
  // How the steps were before the ask, for the comparisons below.
  const oldThreeX = (speed: PitchSpeed.fast, rate: 1.5);

  test('1x is as it was: the slow pacing at 1.3', () {
    expect(pitchSpeedForStep(0), PitchSpeed.slow);
    expect(pitchRateForStep(0), 1.3);
  });

  test('2x is the old 3x', () {
    expect(pitchSpeedForStep(1), oldThreeX.speed);
    expect(pitchRateForStep(1), oldThreeX.rate);
  });

  test('3x is the old 3x a quarter faster', () {
    // The same pacing, so the same staged picture, played 1.25x as fast.
    expect(pitchSpeedForStep(2), oldThreeX.speed);
    expect(pitchRateForStep(2), closeTo(oldThreeX.rate * 1.25, 1e-9));
  });

  test('a whole match on screen, in real seconds per 90 minutes', () {
    double realSeconds(int step, double bandSeconds) =>
        bandSeconds / pitchRateForStep(step);
    final (lo, hi) = PitchPacer.bandOf(pitchSpeedForStep(2));
    // The old 3x: 40-80 s; the new 3x: 32-64 s.
    expect(realSeconds(1, lo), closeTo(40, 1e-9));
    expect(realSeconds(1, hi), closeTo(80, 1e-9));
    expect(realSeconds(2, lo), closeTo(32, 1e-9));
    expect(realSeconds(2, hi), closeTo(64, 1e-9));
  });

  test('out-of-range steps clamp', () {
    expect(pitchSpeedForStep(-1), PitchSpeed.slow);
    expect(pitchSpeedForStep(9), PitchSpeed.fast);
    expect(pitchRateForStep(9), pitchRateForStep(2));
  });
}
