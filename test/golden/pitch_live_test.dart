import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/features/match/pitch/actors_painter.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';

import '../helpers/pitch_view_fixture.dart';
import '../helpers/pump_app.dart';

/// Live frames of the Pitch view mid-match, drawn by the real view over the
/// real baked ground: an open-play attack, a corner and a goal.
void main() {
  late PitchMatchFixture m;
  setUpAll(() => m = pitchMatch(seed: 11));

  double at(Duration d) => d.inMicroseconds / 1e6;
  Duration dur(double t) => Duration(microseconds: (t * 1e6).round());

  bool nearCut(PitchScript s, double t) => [
    ...s.cuts,
    ...s.resets,
  ].any((c) => (c - t).abs() < 0.6);

  /// Open play with the ball carried into the final third.
  double openPlay(PitchScript s) {
    for (var t = 30.0; t < s.totalSeconds; t += 0.1) {
      if (s.windowAt(t) != null || nearCut(s, t)) continue;
      final f = s.sample(dur(t));
      final carrier = f.ballCarrierId;
      if (carrier == null) continue;
      final home =
          s.actorList[s.actorIndexOf(carrier)!].teamNationId == s.homeNationId;
      final m = s.pacer.matchAt(dur(t));
      final dir = attackDir(home: home, minute: m.minute);
      final depth = dir > 0 ? f.ball.x : PitchDims.length - f.ball.x;
      if (depth > 72 && f.ball.y > 12 && f.ball.y < 56) return t;
    }
    throw StateError('no attack');
  }

  /// A corner just as it is struck: the ball just off the arc.
  double corner(PitchScript s) {
    for (final w in s.windows) {
      if (!w.moments.any(
        (x) => x is SetPieceMoment && x.kind == SetPieceKind.corner,
      )) {
        continue;
      }
      for (var t = w.start; t < w.end; t += 0.05) {
        final f = s.sample(dur(t));
        final b = f.ball;
        final atFlag =
            (b.x < 1.5 || b.x > PitchDims.length - 1.5) &&
            (b.y < 1.5 || b.y > PitchDims.width - 1.5);
        if (atFlag && !nearCut(s, t)) {
          // On its way in: just after it leaves the arc.
          for (var u = t; u < w.end; u += 0.05) {
            final b = s.sample(dur(u)).ball;
            final away =
                (b.x - (b.x < 50 ? 0 : PitchDims.length)).abs() +
                (b.y - (b.y < 34 ? 0 : PitchDims.width)).abs();
            if (away > 6) return u;
          }
        }
      }
    }
    throw StateError('no corner');
  }

  /// A goal: the ball just over the line, in the net.
  double goal(PitchScript s) {
    for (final w in s.windows) {
      if (!w.moments.any(
        (x) => x is ShotMoment && x.outcome == ShotOutcome.goal,
      )) {
        continue;
      }
      for (var t = w.start; t < w.end; t += 0.02) {
        final b = s.sample(dur(t)).ball;
        if (b.x < -0.3 || b.x > PitchDims.length + 0.3) return t + 0.1;
      }
    }
    throw StateError('no goal');
  }

  for (final (name, pick) in [
    ('open_play', openPlay),
    ('corner', corner),
    ('goal', goal),
  ]) {
    testWidgets('live frame: $name', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(780, 560);
      addTearDown(tester.view.reset);
      final clock = PitchClock(
        vsync: const TestVSync(),
        pacer: m.script.pacer,
      );
      addTearDown(clock.dispose);
      final t = pick(m.script);
      expect(CutTransition.at(m.script, t), isNull);
      clock.seek(dur(t));
      await tester.pumpApp(
        RepaintBoundary(
          key: const ValueKey('live'),
          // Captured at 2x, like the mock: the view laid out at phone size
          // and baked at a 2x pixel ratio, then scaled up whole.
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
      for (var i = 0; i < 400 && !state.debugLooksComplete; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump();
      }
      expect(state.debugLooksComplete, isTrue);
      await tester.pump();
      debugPrint(
        'live $name at ${at(clock.value).toStringAsFixed(2)} s '
        "(${m.script.minuteLabel(at(clock.value))}')",
      );
      await expectLater(
        find.byKey(const ValueKey('live')),
        matchesGoldenFile('goldens/pitch_live_$name.png'),
      );
    });
  }
}
