import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// How often the world throws up a surprise winner.
///
/// The background simulator ([RatingMatchSimulator]) plays every match the
/// manager does not, so it decides who wins the World Championship. Measured
/// on 100 whole careers (real 48-team finals, qualifying included) at the old
/// tuning, a top-eight seed won only 41% of them and a seed ranked 30th or
/// worse 12%. Retuned (gap response, gap ceiling, the elite band in
/// [RatingMatchSimulator.strengthOf] and the knockout weight), the same
/// harness gave 76% top-eight winners over 416 careers, 2% from 21st or
/// worse, and one 30th-or-worse winner (a 40th seed): possible, but rare.
///
/// This is the cheap, deterministic stand-in for that harness: the real
/// start-of-save strengths of the top 32 seeds, one knockout bracket, level
/// ties settled the way the background path settles them.
void main() {
  const sim = RatingMatchSimulator();

  /// The top 32 seeds' background strength at the start of a save (best XI
  /// blended with the ranking anchor, as `SeasonService._squadStrength` does),
  /// in seed order. A compressed field: ten points cover all 32, which is
  /// exactly why the dial has to be loud enough to tell 88 from 85.
  const field = [
    89, 89, 90, 88, 89, 88, 88, 87, 87, 88, 85, 87, 85, 85, 84, 84, //
    84, 84, 83, 83, 83, 83, 83, 83, 82, 82, 82, 81, 80, 82, 80, 81,
  ];

  /// Plays one bracket (strongest seed against weakest) and returns the
  /// winner's seed index.
  int playBracket(SeededRng rng) {
    var alive = [for (var i = 0; i < field.length; i++) i];
    while (alive.length > 1) {
      final next = <int>[];
      final n = alive.length;
      for (var i = 0; i < n ~/ 2; i++) {
        final a = alive[i];
        final b = alive[n - 1 - i];
        final r = sim.simulate(
          homeStrength: field[a],
          awayStrength: field[b],
          rng: rng,
          homeAdvantage: false,
        );
        if (r.homeScore != r.awayScore) {
          next.add(r.homeScore > r.awayScore ? a : b);
          continue;
        }
        // Level after ninety: extra time and penalties, weighted exactly as
        // the background path weights them.
        final ko = WorldCupFinals.decideKnockout(
          r.homeScore,
          r.awayScore,
          rng,
          homeStrength: RatingMatchSimulator.knockoutWeight(field[a]),
          awayStrength: RatingMatchSimulator.knockoutWeight(field[b]),
        );
        next.add(ko.homeWon ? a : b);
      }
      alive = next..sort();
    }
    return alive.first;
  }

  test('a top-eight seed wins the great majority of tournaments', () {
    const editions = 2000;
    var fromTopEight = 0;
    var fromTopSixteen = 0;
    var fromTwentyFirstDown = 0;
    for (var edition = 0; edition < editions; edition++) {
      final winner = playBracket(SeededRng(9000 + edition));
      if (winner < 8) fromTopEight++;
      if (winner < 16) fromTopSixteen++;
      if (winner >= 20) fromTwentyFirstDown++;
    }
    double pct(int n) => n / editions * 100;

    // Printed so the number is on the record, not just asserted.
    // ignore: avoid_print
    print(
      'winners from the top 8 seeds: ${pct(fromTopEight).toStringAsFixed(1)}%, '
      'top 16: ${pct(fromTopSixteen).toStringAsFixed(1)}%, '
      '21st or worse: ${pct(fromTwentyFirstDown).toStringAsFixed(1)}%',
    );

    expect(
      pct(fromTopEight),
      greaterThanOrEqualTo(65),
      reason: 'the best sides should win most of the time',
    );
    expect(
      pct(fromTopEight),
      lessThan(92),
      reason: 'and an upset must still be possible',
    );
    expect(
      pct(fromTopSixteen),
      greaterThan(88),
      reason: 'a bottom-half seed winning should be a story, not a habit',
    );
    expect(
      pct(fromTwentyFirstDown),
      inInclusiveRange(0.05, 8),
      reason: 'an outsider can still rise all the way, but rarely',
    );
  });
}
