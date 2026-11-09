import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/shootout_stage.dart';

import '../helpers/pitch_view_fixture.dart';
import '../helpers/pump_app.dart';

/// A penalty given in the match plays in the shootout's close-up (taker
/// against keeper, the outcome the match decided), then the pitch comes
/// back. Drawn by the real view over the real baked ground.
void main() {
  late PitchMatchFixture m;
  late InMatchPenalty pen;
  setUpAll(() {
    for (var seed = 0; seed < 200; seed++) {
      final f = pitchMatch(seed: seed);
      final all = InMatchPenalty.of(f.script);
      if (all.isNotEmpty) {
        m = f;
        pen = all.first;
        return;
      }
    }
    fail('no match with a penalty');
  });

  Future<PitchMatchViewState> pump(
    WidgetTester tester,
    PitchClock clock,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(780, 560);
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      RepaintBoundary(
        key: const ValueKey('penalty'),
        child: SizedBox(
          width: 780,
          height: 560,
          child: FittedBox(
            child: SizedBox(
              width: 390,
              height: 280,
              child: Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(devicePixelRatio: 2),
                  child: PitchMatchView(
                    script: m.script,
                    stadium: pitchStadiumFor(m),
                    clock: clock,
                    names: m.names,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final state = tester.state<PitchMatchViewState>(
      find.byType(PitchMatchView),
    );
    for (var k = 0; k < 400 && !state.debugLooksComplete; k++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    expect(state.debugLooksComplete, isTrue);
    return state;
  }

  Duration at(double t) => Duration(microseconds: (t * 1e6).round());

  bool closeUp(WidgetTester tester) => find
      .byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is ShootoutPainter,
      )
      .evaluate()
      .isNotEmpty;

  bool pitch(WidgetTester tester) => find
      .byWidgetPredicate((w) => w is CustomPaint && w.painter is ActorsPainter)
      .evaluate()
      .isNotEmpty;

  testWidgets('the close-up takes over for the kick, then the pitch is back', (
    tester,
  ) async {
    final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer)
      ..seek(at(pen.from - 0.5));
    addTearDown(clock.dispose);
    final state = await pump(tester, clock);
    await tester.pump();
    expect((closeUp(tester), pitch(tester)), (false, true));
    clock.seek(at(pen.strike));
    await tester.pump();
    expect((closeUp(tester), pitch(tester)), (true, false));
    final p = state.debugPenalty!;
    expect(p.kick!.kick.takerId, pen.kick.kick.takerId);
    expect(p.seconds, closeTo(ShootoutStaging.strikeAt, 1e-6));
    clock.seek(at(pen.to + 0.1));
    await tester.pump();
    expect((closeUp(tester), pitch(tester)), (false, true));
  });

  for (final (name, seconds) in [
    ('run_up', 2.4),
    ('strike', 2.85),
    ('result', 3.5),
  ]) {
    testWidgets('in-match penalty frame: $name', (tester) async {
      final clock = PitchClock(vsync: const TestVSync(), pacer: m.script.pacer)
        ..seek(at(pen.strike - ShootoutStaging.strikeAt + seconds));
      addTearDown(clock.dispose);
      await pump(tester, clock);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(closeUp(tester), isTrue);
      await expectLater(
        find.byKey(const ValueKey('penalty')),
        matchesGoldenFile('goldens/pitch_penalty_$name.png'),
      );
    });
  }
}
