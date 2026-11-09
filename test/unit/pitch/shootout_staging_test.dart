import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

import '../../helpers/pitch_match_lab.dart';

/// A real drawn shootout for [seed], with named takers on both sides.
KnockoutOutcome _shootout(int seed) => WorldCupFinals.decideShootout(
  1,
  1,
  SeededRng(seed),
  homeTakerSkill: const [80, 78, 76, 74, 72],
  awayTakerSkill: const [79, 77, 75, 73, 71],
  homeTakerIds: const [101, 102, 103, 104, 105],
  awayTakerIds: const [201, 202, 203, 204, 205],
);

void main() {
  test("each kick's taker and result match the outcome", () {
    for (var seed = 1; seed <= 40; seed++) {
      final o = _shootout(seed);
      final kicks = ShootoutStaging.order(o);
      expect(kicks, hasLength(o.homeKicks.length + o.awayKicks.length));
      for (final k in kicks) {
        final list = k.home ? o.homeKicks : o.awayKicks;
        final detail = k.home ? o.homeDetail : o.awayDetail;
        expect(k.home, k.index.isEven, reason: 'alternates, home first');
        expect(k.sideIndex, k.index ~/ 2);
        expect(k.scored, list[k.sideIndex], reason: 'seed $seed #${k.index}');
        expect(identical(k.kick, detail[k.sideIndex]), isTrue);
        expect(k.kick.takerId, isNonZero);
      }
    }
  });

  test('a save has the keeper in the ball\'s lane', () {
    var saves = 0;
    for (var seed = 1; seed <= 60; seed++) {
      for (final k in ShootoutStaging.order(_shootout(seed))) {
        if (k.kick.result != KickResult.saved) continue;
        saves++;
        expect(k.kick.diveLane, k.kick.lane);
        // The keeper's hands are on the ball as it arrives, in its lane.
        final at = ShootoutStaging.frameAt(k, ShootoutStaging.resultAt);
        expect((at.keeper.y - at.ball.y).abs(), lessThan(1e-6));
        expect((at.keeper.x - at.ball.x).abs(), lessThan(1e-6));
        expect((at.keeperHeight - at.ballHeight).abs(), lessThan(1e-6));
        expect(at.ball.y, closeTo(ShootoutStaging.laneY(k.kick.lane), 1e-6));
        // And he parries it: it ends away from him, out of the goal.
        final f = ShootoutStaging.frameAt(k, ShootoutStaging.kickSeconds);
        expect(f.ball.x, lessThan(105 - 2));
        expect(f.ball.distanceTo(f.keeper), greaterThan(2));
      }
    }
    expect(saves, greaterThan(10));
  });

  test(
    'a goal ends in the net, a miss outside it, whatever the keeper does',
    () {
      for (var seed = 1; seed <= 40; seed++) {
        for (final k in ShootoutStaging.order(_shootout(seed))) {
          final f = ShootoutStaging.frameAt(k, ShootoutStaging.kickSeconds);
          final half = 3.66;
          final inGoalMouth = (f.ball.y - 34).abs() < half;
          switch (k.kick.result) {
            case KickResult.scored:
              expect(f.ball.x, greaterThan(105));
              expect(inGoalMouth, isTrue);
            case KickResult.wide:
              expect((f.ball.y - 34).abs(), greaterThan(half));
            case KickResult.post:
              expect(f.ball.x, lessThan(105));
            case KickResult.saved:
              expect(f.ball.x, lessThan(105));
          }
        }
      }
    },
  );

  test('the ball stays on the mark until it is struck, then the taker is '
      'behind it', () {
    final k = ShootoutStaging.order(_shootout(3)).first;
    final before = ShootoutStaging.frameAt(k, ShootoutStaging.strikeAt - 0.01);
    expect(before.struck, isFalse);
    expect(before.ball.x, ShootoutStaging.spotX);
    expect(before.taker.x, lessThan(ShootoutStaging.spotX));
    final start = ShootoutStaging.frameAt(k, 0);
    expect(start.taker.x, closeTo(52.5 + 9.15, 1e-6));
    final after = ShootoutStaging.frameAt(k, ShootoutStaging.strikeAt + 0.1);
    expect(after.struck, isTrue);
    expect(after.ball.x, greaterThan(ShootoutStaging.spotX));
  });

  test('the tally matches the strip', () {
    for (var seed = 1; seed <= 40; seed++) {
      final o = _shootout(seed);
      final kicks = ShootoutStaging.order(o);
      for (var revealed = 0; revealed <= kicks.length; revealed++) {
        // The strip's own count (match_panels _ShootoutStrip).
        final homeShown = ((revealed + 1) ~/ 2).clamp(0, o.homeKicks.length);
        final awayShown = (revealed ~/ 2).clamp(0, o.awayKicks.length);
        final strip = (
          o.homeKicks.take(homeShown).where((s) => s).length,
          o.awayKicks.take(awayShown).where((s) => s).length,
        );
        expect(ShootoutStaging.tally(kicks, revealed), strip);
      }
      final end = ShootoutStaging.tally(kicks, kicks.length);
      expect(end, (o.homePens, o.awayPens));
    }
  });

  test('a penalty in the match plays in the close-up as the match had it', () {
    var seen = 0;
    final kinds = <KickResult>{};
    for (var seed = 0; seed < 80; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      final pens = [
        for (final w in s.windows)
          for (final m in w.moments)
            if (m is ShotMoment && m.origin == ShotOrigin.penalty) m,
      ];
      final shown = InMatchPenalty.of(s);
      expect(shown.length, pens.length, reason: 'match $seed');
      for (var k = 0; k < pens.length; k++) {
        final m = pens[k];
        final p = shown[k];
        seen++;
        final kick = p.kick.kick;
        kinds.add(kick.result);
        expect(kick.takerId, m.shooterId);
        expect(p.kick.home, m.teamNationId == s.homeNationId);
        expect(kick.result, switch (m.outcome) {
          ShotOutcome.goal => KickResult.scored,
          ShotOutcome.saved || ShotOutcome.blocked => KickResult.saved,
          ShotOutcome.wide => KickResult.wide,
          ShotOutcome.woodwork => KickResult.post,
        });
        // A save is in the keeper's lane; a goal never is; a miss is wide
        // of a post.
        if (kick.result == KickResult.saved) {
          expect(kick.diveLane, kick.lane);
        } else {
          expect(kick.diveLane, isNot(kick.lane));
        }
        if (kick.result == KickResult.wide || kick.result == KickResult.post) {
          expect(kick.lane % 3, isNot(1));
        }
        // The keeper is the one the taker faces.
        final keeper = p.cast.keeperFacing(home: p.kick.home);
        if (m.keeperId != null) expect(keeper, m.keeperId);
        // The close-up strikes when the script does, inside the moment.
        expect(p.secondsAt(p.strike), closeTo(ShootoutStaging.strikeAt, 1e-9));
        expect(p.from, lessThan(p.strike));
        expect(p.to, greaterThan(p.strike + ShootoutStaging.flight));
      }
    }
    expect(seen, greaterThan(5));
    expect(kinds, contains(KickResult.scored));
  });
}
