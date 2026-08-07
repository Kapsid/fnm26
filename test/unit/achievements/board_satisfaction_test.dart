import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/press/public_mood.dart';

void main() {
  List<MatchOutcome> repeat(MatchOutcome o, int n) => List.filled(n, o);

  int mood({
    List<MatchOutcome> recent = const [],
    List<({TournamentTier tier, Placing placing})> honours = const [],
    int? rank,
  }) =>
      BoardSatisfaction.compute(
        recent: recent,
        honours: honours,
        worldRank: rank,
      );

  group('BoardSatisfaction', () {
    test('a board with nothing to judge sits at neutral', () {
      expect(mood(), BoardSatisfaction.neutral);
    });

    test('a single result moves the gauge only slightly', () {
      final afterWin = mood(recent: [MatchOutcome.win]);
      final afterLoss = mood(recent: [MatchOutcome.loss]);
      expect(afterWin - BoardSatisfaction.neutral, lessThanOrEqualTo(5));
      expect(BoardSatisfaction.neutral - afterLoss, lessThanOrEqualTo(5));
    });

    test('the widest one match can swing the board is win minus loss', () {
      // Replacing the oldest loss with a win is the biggest match-to-match
      // move possible — this is the "jumping too much" guard.
      final nine = repeat(MatchOutcome.draw, 9);
      final withLoss = mood(recent: [MatchOutcome.loss, ...nine]);
      final withWin = mood(recent: [MatchOutcome.win, ...nine]);
      expect(withWin - withLoss, BoardSatisfaction.win - BoardSatisfaction.loss);
      expect(withWin - withLoss, lessThanOrEqualTo(8));
    });

    test('a major trophy outweighs a flawless run of form', () {
      // The point of the whole model: the competitions that define a cycle are
      // the biggest jump. The Nations Cup and the Clash are lesser prizes and
      // deliberately don't clear this bar — ten straight wins is a real run.
      final perfectRun = mood(recent: repeat(MatchOutcome.win, 10));
      for (final tier in [TournamentTier.world, TournamentTier.continental]) {
        expect(
          mood(honours: [(tier: tier, placing: Placing.champion)]),
          greaterThan(perfectRun),
          reason: 'winning the $tier must beat ten straight wins',
        );
      }
    });

    test('a run of draws leaves the board where it started', () {
      expect(mood(recent: repeat(MatchOutcome.draw, 10)),
          BoardSatisfaction.neutral);
    });

    test('prestige orders the trophies', () {
      int champion(TournamentTier tier) =>
          BoardSatisfaction.trophyBonus(tier, Placing.champion);
      expect(champion(TournamentTier.world),
          greaterThan(champion(TournamentTier.continental)));
      expect(champion(TournamentTier.continental),
          greaterThan(champion(TournamentTier.nationsCup)));
      expect(champion(TournamentTier.nationsCup),
          greaterThan(champion(TournamentTier.clash)));
    });

    test('finishing higher is worth more', () {
      for (final tier in TournamentTier.values) {
        expect(
          BoardSatisfaction.trophyBonus(tier, Placing.champion),
          greaterThan(BoardSatisfaction.trophyBonus(tier, Placing.runnerUp)),
          reason: '$tier: winning beats losing the final',
        );
        expect(
          BoardSatisfaction.trophyBonus(tier, Placing.runnerUp),
          greaterThanOrEqualTo(
            BoardSatisfaction.trophyBonus(tier, Placing.third),
          ),
          reason: '$tier: the final beats the play-off',
        );
      }
    });

    test('only the best trophy counts, not the sum', () {
      final both = mood(
        honours: [
          (tier: TournamentTier.nationsCup, placing: Placing.champion),
          (tier: TournamentTier.world, placing: Placing.champion),
        ],
      );
      final worldOnly = mood(
        honours: [(tier: TournamentTier.world, placing: Placing.champion)],
      );
      expect(both, worldOnly);
    });

    test('only the last ten matches count', () {
      final ten = repeat(MatchOutcome.win, 10);
      final twenty = repeat(MatchOutcome.win, 20);
      expect(mood(recent: twenty), mood(recent: ten));
    });

    test('a champion in perfect form and top of the world pegs at 100', () {
      expect(
        mood(
          recent: repeat(MatchOutcome.win, 10),
          honours: [(tier: TournamentTier.world, placing: Placing.champion)],
          rank: 1,
        ),
        100,
        reason: 'the satisfaction achievement must stay reachable',
      );
    });

    test('losing every match sinks the board under the sacking bar', () {
      // nationOffers sacks the manager below 25. A full window of defeats has
      // to get there even for a top-ranked side, or the ranking bonus alone
      // would keep a failing manager in post.
      const sackedBelow = 25;
      expect(
        mood(recent: repeat(MatchOutcome.loss, 10), rank: 1),
        lessThan(sackedBelow),
        reason: 'even the best-ranked nation is sackable after ten defeats',
      );
      expect(mood(recent: repeat(MatchOutcome.loss, 10), rank: 200),
          lessThan(sackedBelow));
    });

    test('a mediocre cycle keeps the manager in post', () {
      final mixed = [
        ...repeat(MatchOutcome.win, 5),
        ...repeat(MatchOutcome.loss, 5),
      ];
      expect(mood(recent: mixed), greaterThanOrEqualTo(25));
    });

    group('objectives', () {
      ObjectiveResult o(TournamentTier tier, int target, int actual) =>
          (tier: tier, target: target, actual: actual);

      test('meeting the brief lifts the board, missing it sinks them', () {
        expect(
          BoardSatisfaction.objectiveSwing(o(TournamentTier.world, 5, 5)),
          greaterThan(0),
        );
        expect(
          BoardSatisfaction.objectiveSwing(o(TournamentTier.world, 5, 2)),
          lessThan(0),
        );
      });

      test('the further short, the worse it is', () {
        final near = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 5, 4),
        );
        final far = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 5, 0),
        );
        expect(far, lessThan(near));
      });

      test('a bigger nation is judged harder on the same shortfall', () {
        // Told to win it and beaten in the semis, against told to qualify and
        // going out in the group: the same one-round shortfall, but the board
        // of the side that was supposed to lift the trophy takes it far worse.
        final giant = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 7, 5),
        );
        final minnow = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 3, 2),
        );
        expect(giant, lessThan(minnow));
      });

      test('beating the brief is a clear surge over merely meeting it', () {
        // Told to reach the quarter-finals (5) and carried to the final (6)
        // must read as a different cycle from doing exactly as asked — it used
        // to be worth one step, so the two were nearly indistinguishable.
        final met = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 5, 5),
        );
        final beaten = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 5, 6),
        );
        final smashed = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 5, 7),
        );
        expect(beaten, greaterThan(met));
        expect(smashed, greaterThan(beaten));
        // The jump from meeting to beating is bigger than one more round on
        // top of it — that's the surge.
        expect(beaten - met, greaterThan(smashed - beaten));
      });

      test('meeting the brief exactly earns no overachievement surge', () {
        expect(BoardSatisfaction.overachievementBonus(TournamentTier.world, 0),
            0);
        expect(
          BoardSatisfaction.overachievementBonus(TournamentTier.world, -2),
          0,
        );
        expect(
          BoardSatisfaction.overachievementBonus(TournamentTier.world, 1),
          greaterThan(0),
        );
      });

      test('the World Cup outweighs the continental cup', () {
        expect(
          BoardSatisfaction.objectiveSwing(o(TournamentTier.world, 5, 5)),
          greaterThan(
            BoardSatisfaction.objectiveSwing(
              o(TournamentTier.continental, 5, 5),
            ),
          ),
        );
      });

      test('the brief outweighs a full window of form', () {
        // The point of the term: a manager cannot miss what the board asked for
        // and be saved by good results, nor meet it and be sunk by bad ones.
        final formSwing =
            BoardSatisfaction.formPoints(repeat(MatchOutcome.win, 10)) -
            BoardSatisfaction.formPoints(repeat(MatchOutcome.loss, 10));
        final missedBadly = BoardSatisfaction.objectiveSwing(
          o(TournamentTier.world, 7, 2),
        );
        expect(missedBadly.abs(), greaterThan(formSwing));
      });

      test('missing both briefs puts a big nation out of a job', () {
        const sackedBelow = 25;
        final mood = BoardSatisfaction.compute(
          recent: repeat(MatchOutcome.win, 6),
          honours: const [],
          worldRank: 2,
          objectives: [
            o(TournamentTier.continental, 7, 3),
            o(TournamentTier.world, 7, 3),
          ],
        );
        expect(mood, lessThan(sackedBelow));
      });
    });

    test('a stronger world ranking is worth more', () {
      expect(BoardSatisfaction.rankBonus(1),
          greaterThan(BoardSatisfaction.rankBonus(10)));
      expect(BoardSatisfaction.rankBonus(10),
          greaterThan(BoardSatisfaction.rankBonus(20)));
      expect(BoardSatisfaction.rankBonus(200), 0);
      expect(BoardSatisfaction.rankBonus(null), 0);
    });
  });

  group('the board reads the room', () {
    test('a neutral public changes nothing at all', () {
      // THE GUARD: with no public opinion the gauge must be exactly what it
      // was before Y existed.
      final without = BoardSatisfaction.compute(
        recent: const [MatchOutcome.win, MatchOutcome.draw],
        honours: const [],
        worldRank: 20,
      );
      final neutral = BoardSatisfaction.compute(
        recent: const [MatchOutcome.win, MatchOutcome.draw],
        honours: const [],
        worldRank: 20,
        publicMood: PublicMood.neutral,
      );
      expect(neutral, without);
    });

    test('a delighted public lifts the board, a furious one sinks it', () {
      int at(int mood) => BoardSatisfaction.compute(
            recent: const [MatchOutcome.win, MatchOutcome.draw],
            honours: const [],
            worldRank: 20,
            publicMood: mood,
          );
      expect(at(100), greaterThan(at(50)));
      expect(at(0), lessThan(at(50)));
      expect(at(100) - at(50), lessThanOrEqualTo(5));
      expect(at(50) - at(0), lessThanOrEqualTo(5));
    });
  });
}
