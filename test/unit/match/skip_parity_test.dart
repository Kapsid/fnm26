import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

import '../../helpers/tactics_lab.dart';

/// Skipping a match is a choice about WATCHING, not about how the side plays.
///
/// The manager's matches he does not watch go through `RatingMatchSimulator`,
/// which knows one number per side. `MatchEngine.planEffect` turns his plan,
/// the opponent's (countered) plan and how open the two make the game into
/// that number plus an openness multiplier, and these tests hold the skipped
/// result to the played one.
void main() {
  test('the world is untouched', () {
    // Every background fixture passes no openness: the default must be the
    // old simulator, score for score.
    const sim = RatingMatchSimulator();
    for (var seed = 0; seed < 500; seed++) {
      final h = 50 + seed % 40;
      final a = 90 - seed % 37;
      final plain = sim.simulate(
        homeStrength: h,
        awayStrength: a,
        rng: SeededRng(seed),
      );
      final explicit = sim.simulate(
        homeStrength: h,
        awayStrength: a,
        rng: SeededRng(seed),
        openness: 1,
      );
      expect(
        (explicit.homeScore, explicit.awayScore),
        (plain.homeScore, plain.awayScore),
        reason: 'seed $seed',
      );
    }
  });

  // Equal squads, an AI opponent that counters what it has scouted at
  // predictability 0.5. 4000 seeds both ways round is 8000 matches a cell:
  // a difference of two win-rate effects is then good to about a point.
  //
  // Two levels (2026-10-16): the skip path converts engine points on a curve
  // read at one squad level (`MatchEngine.kSkipHeadroom`), so parity is
  // checked at a good side and a modest one. At the tuned headroom every gap
  // measured within about 2.5pp at 2000 seeds.
  for (final rating in const [75.0, 65.0]) {
    group('skip and play agree on what a plan is worth at $rating', () {
      const seeds = 4000;
      const predictability = 0.5;
      LabStats played(LabPlan p) => runCell(
        manager: p,
        managerRating: rating,
        opponentRating: rating,
        aiCounters: true,
        seeds: seeds,
        predictability: predictability,
      );
      LabStats skipped(LabPlan p) => runSkipCell(
        manager: p,
        managerRating: rating,
        opponentRating: rating,
        aiCounters: true,
        seeds: seeds,
        predictability: predictability,
      );
      final neutral = labPlans.firstWhere((p) => p.name == 'neutral');
      late final playedNeutral = played(neutral);
      late final skippedNeutral = skipped(neutral);

      for (final name in const [
        'allOutAttack',
        'parkTheBus',
        'highPress',
        'possession',
        'counter',
        'wide',
      ]) {
        test(name, () {
          final plan = labPlans.firstWhere((p) => p.name == name);
          final play = played(plan);
          final skip = skipped(plan);
          final playEffect = play.win - playedNeutral.win;
          final skipEffect = skip.win - skippedNeutral.win;
          final playGoals = play.total / playedNeutral.total;
          final skipGoals = skip.total / skippedNeutral.total;
          final report =
              '$name at $rating: win effect played ${_pp(playEffect)} '
              'skipped ${_pp(skipEffect)}; goals ratio played '
              '${playGoals.toStringAsFixed(3)} skipped '
              '${skipGoals.toStringAsFixed(3)}';
          // The measured gap is the point of this test; keep it in the log.
          // ignore: avoid_print
          print(report);
          expect(
            (playEffect - skipEffect).abs(),
            lessThanOrEqualTo(0.03),
            reason: report,
          );
          expect(skipGoals / playGoals, closeTo(1, 0.15), reason: report);
        }, timeout: const Timeout(Duration(minutes: 10)));
      }
    });
  }
}

String _pp(double v) => '${(v * 100).toStringAsFixed(1)}pp';
