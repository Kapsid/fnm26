import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';

/// The gauge used to reset to neutral every four years, so the manager who had
/// just won the World Cup opened his next cycle on exactly the figure of the
/// one who had nearly been sacked. A reputation is worth something — and not
/// very much, which is the other half of the point.
void main() {
  group('what last cycle is worth', () {
    test('a first cycle opens neutral, exactly as every cycle used to', () {
      expect(BoardSatisfaction.openingFrom(null), BoardSatisfaction.neutral);
    });

    test('a triumphant cycle is very largely still standing', () {
      final opening = BoardSatisfaction.openingFrom(100);
      expect(opening, greaterThan(BoardSatisfaction.neutral));
      // The board does not forget four good years at a rollover: a manager who
      // finished on a hundred opens the next cycle in the nineties, not the
      // sixties.
      expect(opening, greaterThanOrEqualTo(90));
    });

    test('and a good one loses only a few points to the turn of the cycle', () {
      // The complaint this constant answers: satisfaction fell off a cliff
      // between cycles when nothing about the job had changed. A manager who
      // finished on ninety must open the next one within a handful of points
      // of it, not thirty below.
      expect(90 - BoardSatisfaction.openingFrom(90), lessThanOrEqualTo(8));
    });

    test('a disastrous one is remembered too, and by the same amount', () {
      final good = BoardSatisfaction.openingFrom(90) - BoardSatisfaction.neutral;
      final bad = BoardSatisfaction.neutral - BoardSatisfaction.openingFrom(10);
      expect(bad, good);
    });

    test('but it drifts toward neutral rather than being banked forever', () {
      // Two cycles of coasting on one triumph brings the gauge back down: the
      // carry is a decay, not a permanent credit.
      final once = BoardSatisfaction.openingFrom(100);
      final twice = BoardSatisfaction.openingFrom(once);
      expect(twice, lessThan(once));
    });

    test('a cycle that finished neutral changes nothing', () {
      expect(
        BoardSatisfaction.openingFrom(BoardSatisfaction.neutral),
        BoardSatisfaction.neutral,
      );
    });

    test('it never leaves the scale', () {
      for (var previous = 0; previous <= 100; previous++) {
        expect(BoardSatisfaction.openingFrom(previous), inInclusiveRange(0, 100));
      }
    });
  });

  group('rope, not a free pass', () {
    const missedTheBrief = <ObjectiveResult>[
      (tier: TournamentTier.world, target: 5, actual: 2),
    ];

    test('carrying a perfect cycle cannot save a failed one', () {
      final satisfaction = BoardSatisfaction.compute(
        recent: List.filled(10, MatchOutcome.loss),
        honours: const [],
        worldRank: null,
        objectives: missedTheBrief,
        previousCycle: 100,
      );
      // The sacking bar sits at 15 — see nationOffers. A manager who misses a
      // World Cup brief and loses everything is gone whatever he did last time.
      expect(satisfaction, lessThan(15));
    });

    test('but it is worth something over an identical cycle', () {
      int withPrevious(int? previous) => BoardSatisfaction.compute(
        recent: const [MatchOutcome.win, MatchOutcome.draw],
        honours: const [],
        worldRank: 20,
        previousCycle: previous,
      );
      expect(withPrevious(100), greaterThan(withPrevious(null)));
      expect(withPrevious(0), lessThan(withPrevious(null)));
    });

    test('a save that never recorded one behaves exactly as before', () {
      expect(
        BoardSatisfaction.compute(
          recent: const [MatchOutcome.win],
          honours: const [],
          worldRank: 10,
        ),
        BoardSatisfaction.compute(
          recent: const [MatchOutcome.win],
          honours: const [],
          worldRank: 10,
          previousCycle: null,
        ),
      );
    });
  });
}
