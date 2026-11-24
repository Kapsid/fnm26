/// A penalty in the match that stays live (followed up or cleared) shows
/// its parry, or the ball off the post, in the close-up: the keeper gets
/// to it, the ball goes out to where the pitch picks it up, and the close-up
/// hands over with the ball where the pitch has it, before the man who gets
/// there has it. The rebound itself is played on the pitch after it.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

void main() {
  test('the close-up shows the parry before the rebound, and hands the '
      'ball to the pitch where the pitch has it', () {
    var live = 0;
    var parried = 0;
    final fails = <String>[];
    for (var seed = 0; seed < 600 && live < 16; seed++) {
      final m = labMatch(seed);
      final any = m.result.moments.whereType<ShotMoment>().any(
        (x) =>
            x.origin == ShotOrigin.penaltyRebound ||
            x.reboundClearedById != null,
      );
      if (!any) continue;
      final s = labScript(
        m,
        PitchSpeed.values[seed % PitchSpeed.values.length],
        seed: seed,
      );
      final shown = InMatchPenalty.of(s);
      for (final w in s.windows) {
        if (w.moments.isEmpty) continue;
        final k = w.moments.first;
        if (k is! ShotMoment || k.origin != ShotOrigin.penalty) continue;
        final follow = w.moments
            .skip(1)
            .whereType<ShotMoment>()
            .where((x) => x.origin == ShotOrigin.penaltyRebound)
            .firstOrNull;
        if (follow == null && k.reboundClearedById == null) continue;
        final p = shown
            .where((x) => x.strike >= w.start - 1e-6 && x.strike <= w.end)
            .firstOrNull;
        if (p == null) continue;
        live++;
        final where = 'seed $seed ${s.minuteLabel(p.strike)}';
        final spill = p.spill;
        if (spill == null) {
          fails.add('$where: no spill in the close-up');
          continue;
        }
        final kick = p.kick;
        // At the result, the ball is with the keeper (a save) or at the post.
        final atResult = ShootoutStaging.frameAt(
          kick,
          ShootoutStaging.resultAt,
          spill: spill,
        );
        final arrive = ShootoutStaging.arrivalOf(kick.kick);
        if (atResult.ball.distanceTo(arrive.at) > 0.05) {
          fails.add('$where: not at the gloves or the post at the result');
        }
        if (kick.kick.result == KickResult.saved) {
          parried++;
          if (atResult.keeper.distanceTo(atResult.ball) > 0.5) {
            fails.add('$where: the keeper is not at the ball he parries');
          }
        }
        // Then out, away from the goal, toward where the pitch has it.
        final mid = ShootoutStaging.frameAt(
          kick,
          (spill.t0 + spill.t1) / 2,
          spill: spill,
        );
        if (mid.ball.x >= atResult.ball.x - 0.3) {
          fails.add('$where: the ball does not come out of the goal');
        }
        // The close-up stays up for the parry and hands over mid-spill.
        final handover = p.secondsAt(p.to);
        if (handover <= ShootoutStaging.resultAt + 0.3 ||
            handover >= spill.t1) {
          fails.add('$where: hands over at $handover (spill to ${spill.t1})');
        }
        final dir = attackDir(
          home: k.teamNationId == s.homeNationId,
          minute: s.pacer
              .matchAt(Duration(microseconds: (p.strike * 1e6).round()))
              .minute,
        );
        final (ball, _) = s.ballAt(p.to - 1e-3);
        final onPitch = Offset2(
          xToDepth(ball.x, dir),
          ShootoutStaging.goalY + (ball.y - PitchDims.width / 2) * dir,
        );
        final last = ShootoutStaging.frameAt(
          kick,
          p.secondsAt(p.to - 1e-3),
          spill: spill,
        );
        if (last.ball.distanceTo(onPitch) > 1.5) {
          fails.add(
            '$where: the close-up leaves the ball at ${last.ball}, the pitch '
            'has it at $onPitch',
          );
        }
        // The follow-up (or the clearance) is the pitch's, after it.
        final second = w.cues
            .where(
              (c) =>
                  c.kind == PitchCueKind.followUp ||
                  c.kind == PitchCueKind.clearance,
            )
            .firstOrNull;
        if (second != null && second.t < p.to) {
          fails.add('$where: the rebound is struck inside the close-up');
        }
      }
    }
    expect(live, greaterThan(5));
    expect(parried, greaterThan(0));
    expect(fails, isEmpty, reason: fails.take(10).join('\n'));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
