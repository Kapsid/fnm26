import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/hub/objective_providers.dart';

/// Two asks that pull in opposite directions on purpose: a weak nation must not
/// be handed a target it cannot reach, and a genuinely bad run must cost the
/// job whatever the badge on the blazer says.
void main() {
  group('what the board asks for', () {
    test('a weak nation is not asked to win the tournament', () {
      // 2 is "qualify"; 1 is "come out of the qualifying group off the bottom".
      expect(worldObjectiveTarget(120), lessThanOrEqualTo(2));
      expect(continentalObjectiveTarget(40), lessThanOrEqualTo(2));
    });

    test('a strong nation is still asked for a trophy', () {
      expect(worldObjectiveTarget(3), greaterThanOrEqualTo(6));
      expect(continentalObjectiveTarget(2), greaterThanOrEqualTo(6));
    });

    test('the demand only ever eases as a nation gets weaker', () {
      var last = 8;
      for (var rank = 1; rank <= 150; rank++) {
        final target = worldObjectiveTarget(rank);
        expect(target, lessThanOrEqualTo(last), reason: 'at rank $rank');
        last = target;
      }
      expect(last, greaterThanOrEqualTo(1), reason: 'always something to ask');
    });
  });

  group('what the board will not forgive', () {
    /// The gauge after a run of results, for a nation of [worldRank].
    int moodAfter(List<MatchOutcome> results, {int? worldRank}) =>
        BoardSatisfaction.compute(
          recent: results,
          honours: const [],
          worldRank: worldRank,
        );

    test('ten straight defeats costs the job whatever the ranking', () {
      // The sacking bar in nationOffers is 15 for an ordinary reputation. A
      // top-five side's standing bonus must not be enough to hold a manager
      // above it after a whole window of defeats.
      final mood = moodAfter(
        List.filled(BoardSatisfaction.formWindow, MatchOutcome.loss),
        worldRank: 1,
      );
      expect(mood, lessThan(15));
    });

    test('an unranked minnow losing ten is no better off', () {
      final mood = moodAfter(
        List.filled(BoardSatisfaction.formWindow, MatchOutcome.loss),
      );
      expect(mood, lessThan(15));
    });

    test('losing still hurts more than winning helps', () {
      expect(BoardSatisfaction.loss.abs(), greaterThan(BoardSatisfaction.win));
    });

    test('a good run is not undone by one defeat', () {
      final mood = moodAfter([
        MatchOutcome.loss,
        for (var i = 0; i < 9; i++) MatchOutcome.win,
      ]);
      expect(mood, greaterThan(BoardSatisfaction.neutral));
    });

    test('a run of draws leaves the board where it started', () {
      expect(
        moodAfter(
          List.filled(BoardSatisfaction.formWindow, MatchOutcome.draw),
        ),
        BoardSatisfaction.neutral,
      );
    });
  });
}
