import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';

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

    test('a stronger world ranking is worth more', () {
      expect(BoardSatisfaction.rankBonus(1),
          greaterThan(BoardSatisfaction.rankBonus(10)));
      expect(BoardSatisfaction.rankBonus(10),
          greaterThan(BoardSatisfaction.rankBonus(20)));
      expect(BoardSatisfaction.rankBonus(200), 0);
      expect(BoardSatisfaction.rankBonus(null), 0);
    });
  });
}
