import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/shootout_stage.dart';

import '../helpers/pitch_view_fixture.dart';
import '../helpers/pump_app.dart';

/// A penalty shootout on the pitch, drawn by the real view over the real
/// baked ground: the run-up to a kick, a save and a goal.
void main() {
  late PitchMatchFixture m;
  setUpAll(() => m = pitchMatch(seed: 11));

  /// A shootout whose takers are the match's own men.
  KnockoutOutcome shootout() {
    final home = [
      for (final a in m.script.actorList)
        if (a.teamNationId == m.script.homeNationId && !a.keeper) a.playerId,
    ].take(5).toList();
    final away = [
      for (final a in m.script.actorList)
        if (a.teamNationId != m.script.homeNationId && !a.keeper) a.playerId,
    ].take(5).toList();
    return WorldCupFinals.decideShootout(
      1,
      1,
      SeededRng(8),
      homeTakerIds: home,
      awayTakerIds: away,
      homeTakerSkill: const [80, 78, 76, 74, 72],
      awayTakerSkill: const [79, 77, 75, 73, 71],
    );
  }

  for (final (name, result, seconds) in [
    ('kick', null, 2.85),
    ('save', KickResult.saved, 3.55),
    ('goal', KickResult.scored, 3.4),
  ]) {
    testWidgets('shootout frame: $name', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(780, 560);
      addTearDown(tester.view.reset);
      final clock = PitchClock(
        vsync: const TestVSync(),
        pacer: m.script.pacer,
      )..seek(m.script.pacer.total);
      addTearDown(clock.dispose);
      final kicks = ShootoutStaging.order(shootout());
      final i = kicks.indexWhere(
        (k) => result == null ? k.scored : k.kick.result == result,
      );
      expect(i, isNot(-1), reason: 'a kick of that kind to show');
      final stage = ShootoutStageController(
        vsync: const TestVSync(),
        kicks: kicks,
        cast: ShootoutCast.of(m.script),
        onResult: (_) {},
      );
      addTearDown(stage.dispose);
      await tester.pumpApp(
        RepaintBoundary(
          key: const ValueKey('shootout'),
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
                      shootout: stage,
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
      stage.debugShow(i, seconds);
      // Let the camera finish moving in.
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await expectLater(
        find.byKey(const ValueKey('shootout')),
        matchesGoldenFile('goldens/pitch_shootout_$name.png'),
      );
    });
  }
}
