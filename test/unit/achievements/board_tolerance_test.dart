import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/hub/objective_providers.dart';

/// Two asks that pull in opposite directions on purpose: a weak nation must not
/// be handed a target it cannot reach, and a genuinely bad run must cost the
/// job whatever the badge on the blazer says.
void main() {
  group('what the board asks for', () {
    int world(
      int worldRank,
      int confRank, [
      Confederation c = Confederation.europe,
    ]) => worldObjectiveTarget(
      worldRank: worldRank,
      confederationRank: confRank,
      confederation: c,
      confederationSize: c == Confederation.asia ? 46 : 53,
    );

    test('a weak nation is not asked to win the tournament', () {
      // 2 is "qualify"; 1 is "come out of the qualifying group off the bottom".
      expect(world(120, 45), lessThanOrEqualTo(2));
      expect(
        continentalObjectiveTarget(40, cupSize: 24, confederationSize: 53),
        lessThanOrEqualTo(2),
      );
    });

    test('a strong nation is still asked for a trophy', () {
      expect(world(3, 2), greaterThanOrEqualTo(6));
      expect(
        continentalObjectiveTarget(2, cupSize: 24, confederationSize: 53),
        greaterThanOrEqualTo(6),
      );
    });

    test('the demand only ever eases as a nation gets weaker', () {
      var last = 8;
      for (var rank = 1; rank <= 150; rank++) {
        final target = world(rank, (rank / 3).ceil());
        expect(target, lessThanOrEqualTo(last), reason: 'at rank $rank');
        last = target;
      }
      expect(last, greaterThanOrEqualTo(0));
    });

    // Some goals were not realistic for low and mid sides.
    test('qualifying is asked only inside the confederation\'s places', () {
      // Europe's 20th best, around the world's top 45, has sixteen European
      // places to chase: the qualifying campaign is its brief.
      expect(world(45, 20), 1);
      // Asia's 7th, with eight places, is expected to go.
      expect(world(55, 7, Confederation.asia), 2);
      // Europe's 15th still is.
      expect(world(34, 15), 2);
    });

    test('a side with no realistic brief is given none', () {
      // Europe's 50th, drawn from the bottom pots: no group's top half.
      expect(world(176, 50), 0);
      expect(
        continentalObjectiveTarget(50, cupSize: 24, confederationSize: 53),
        0,
      );
      // Europe's 30th still has one.
      expect(world(70, 30), 1);
    });

    test('a small championship does not ask its second side to win it', () {
      // Oceania: eight at the finals.
      expect(
        continentalObjectiveTarget(1, cupSize: 8, confederationSize: 11),
        7,
      );
      expect(
        continentalObjectiveTarget(2, cupSize: 8, confederationSize: 11),
        lessThan(7),
      );
      // The Gold Cup's 5th of sixteen is not told to reach the semi-finals.
      expect(
        continentalObjectiveTarget(5, cupSize: 16, confederationSize: 35),
        lessThan(5),
      );
      // A 24-team championship asks what it always did.
      expect(
        [
          for (final r in [2, 4, 7, 11, 16, 24, 25])
            continentalObjectiveTarget(r, cupSize: 24, confederationSize: 53),
        ],
        [7, 6, 5, 4, 3, 2, 1],
      );
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
