import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// How often the world throws up a surprise winner.
///
/// A MEASUREMENT first. The report was that passive simulation produces
/// improbable champions who then dominate, but the balance either side of that
/// is good and has very little slack — so this prints the number before
/// anything is tuned, and guards it afterwards. The dial itself lives in
/// [RatingMatchSimulator] (`exp(k * diff)`) and is calibrated together with
/// MatchEngine; see the match_balance_test that pins the other half.
void main() {
  const sim = RatingMatchSimulator();

  /// A field of 32, seeded like a real tournament: a handful of contenders, a
  /// middle, and some makeweights, on the same ~40–92 strength scale the
  /// background simulator uses.
  List<int> field() => [
    for (var i = 0; i < 32; i++) (88 - i * 1.4).round().clamp(45, 92),
  ];

  /// Plays one knockout bracket and returns the winner's seed index.
  int playBracket(List<int> strengths, SeededRng rng) {
    var alive = [for (var i = 0; i < strengths.length; i++) i];
    while (alive.length > 1) {
      final next = <int>[];
      for (var i = 0; i < alive.length; i += 2) {
        final a = alive[i];
        final b = alive[i + 1];
        final result = sim.simulate(
          homeStrength: strengths[a],
          awayStrength: strengths[b],
          rng: rng,
          homeAdvantage: false,
        );
        // A knockout has to produce somebody. A draw goes to a shootout, which
        // is close enough to a coin toss that treating it as one is honest.
        next.add(
          switch (result.homeScore.compareTo(result.awayScore)) {
            > 0 => a,
            < 0 => b,
            _ => rng.nextInt(2) == 0 ? a : b,
          },
        );
      }
      alive = next;
    }
    return alive.first;
  }

  test('a top-eight seed wins the great majority of tournaments', () {
    const editions = 400;
    var fromTopEight = 0;
    var fromTopSixteen = 0;
    final strengths = field();
    for (var edition = 0; edition < editions; edition++) {
      final winner = playBracket(strengths, SeededRng(9000 + edition));
      if (winner < 8) fromTopEight++;
      if (winner < 16) fromTopSixteen++;
    }
    final topEightShare = fromTopEight / editions * 100;
    final topSixteenShare = fromTopSixteen / editions * 100;

    // Printed so the number is on the record, not just asserted.
    // ignore: avoid_print
    print(
      'winners from the top 8 seeds: ${topEightShare.toStringAsFixed(1)}%, '
      'from the top 16: ${topSixteenShare.toStringAsFixed(1)}%',
    );

    // Deliberately WIDE. Real tournaments are won by outsiders often enough
    // that a narrow band here would be pinning noise, and the balance this
    // guards is good — the job is to catch a collapse into randomness, not to
    // hold a number.
    expect(
      topEightShare,
      greaterThan(45),
      reason: 'the best sides should win most of the time',
    );
    expect(
      topSixteenShare,
      greaterThan(70),
      reason: 'a bottom-half seed winning should be a story, not a habit',
    );
    expect(
      topEightShare,
      lessThan(95),
      reason: 'and an upset must still be possible',
    );
  });
}
