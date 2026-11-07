import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';

import '../helpers/fixtures.dart';

void main() {
  testWidgets('one tick never plays more than a second of real time', (
    tester,
  ) async {
    final result = const MatchEngine().play(
      home: ratedTeam(1, 70),
      away: ratedTeam(2, 70),
      rng: SeededRng.forFixture(7, 7),
    );
    final clock = PitchClock(
      vsync: tester,
      pacer: PitchPacer(result, PitchSpeed.mid),
      speed: 2,
    );
    addTearDown(clock.dispose);
    clock.play();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final before = clock.value;
    // A gap no frame takes (the app away, a stall): played as a second.
    await tester.pump(const Duration(seconds: 60));
    expect(clock.value - before, PitchClock.maxTickStep * 2);
    // Ordinary frames play in full.
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      clock.value - before,
      PitchClock.maxTickStep * 2 + const Duration(seconds: 1),
    );
    expect(clock.playing, isTrue);
    clock.pause();
  });
}
