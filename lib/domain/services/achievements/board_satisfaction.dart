/// How a single match went for the manager's nation.
enum MatchOutcome { win, draw, loss }

/// The competitions the board weighs, in descending prestige. A World Cup is
/// the point of the cycle; a Continental Clash is an exhibition.
enum TournamentTier { world, continental, nationsCup, clash }

/// Where the manager's nation finished a tournament.
enum Placing { champion, runnerUp, third }

/// The board's mood, 0–100.
///
/// Two things drive it, and their sizes are the whole point:
///
/// * **Recent form** moves it constantly but gently. A board that swings wildly
///   on one friendly reads as noise, so a result is worth a few points, not a
///   dozen.
/// * **A tournament result** is the big move — a cycle is judged on trophies.
///   Winning a World Cup outweighs any run of league form.
///
/// Pure and derived (never stored), so it stays replay-safe.
abstract final class BoardSatisfaction {
  /// Where a board with nothing to judge sits.
  static const int neutral = 50;

  /// How many recent matches count toward form.
  static const int formWindow = 10;

  /// Form weights. Losing hurts more than winning helps — boards are like that
  /// — but both are small enough that no single match lurches the gauge: the
  /// widest a result can move it is [win] − [loss].
  ///
  /// A drawn match is worth nothing rather than a token point, so a run of
  /// draws leaves the board exactly where it started, which is what a run of
  /// draws deserves.
  ///
  /// The loss weight also has to stay heavy enough that a full window of
  /// defeats drops even a well-ranked nation under the sacking bar (see
  /// nationOffers) — a manager who loses ten straight should not be saved by
  /// their world ranking.
  static const int win = 2;
  static const int draw = 0;
  static const int loss = -4;

  /// Trophy bonuses by tier and placing.
  ///
  /// Every champion bonus outweighs a flawless [formWindow] of wins, so
  /// finishing a tournament is unambiguously the biggest move the gauge ever
  /// makes — no run of friendlies can rival a trophy.
  static const Map<TournamentTier, Map<Placing, int>> _trophy = {
    TournamentTier.world: {
      Placing.champion: 32,
      Placing.runnerUp: 20,
      Placing.third: 14,
    },
    TournamentTier.continental: {
      Placing.champion: 22,
      Placing.runnerUp: 12,
      Placing.third: 7,
    },
    TournamentTier.nationsCup: {
      Placing.champion: 12,
      Placing.runnerUp: 5,
      Placing.third: 2,
    },
    TournamentTier.clash: {
      Placing.champion: 6,
      Placing.runnerUp: 2,
      Placing.third: 1,
    },
  };

  /// What a [placing] in [tier] is worth to the board.
  static int trophyBonus(TournamentTier tier, Placing placing) =>
      _trophy[tier]?[placing] ?? 0;

  /// The form contribution of [recent] (most recent first); only the newest
  /// [formWindow] matches count.
  static int formPoints(Iterable<MatchOutcome> recent) {
    var points = 0;
    for (final outcome in recent.take(formWindow)) {
      points += switch (outcome) {
        MatchOutcome.win => win,
        MatchOutcome.draw => draw,
        MatchOutcome.loss => loss,
      };
    }
    return points;
  }

  /// The standing bonus for a [worldRank] (1-based); null when unranked.
  static int rankBonus(int? worldRank) => switch (worldRank) {
        null => 0,
        <= 5 => 12,
        <= 15 => 8,
        <= 30 => 4,
        _ => 0,
      };

  /// The board's mood given [recent] form (most recent first), the tournaments
  /// the nation placed in recently, and its [worldRank].
  ///
  /// Only the best [honours] placing counts rather than the sum: a board judges
  /// the cycle on its finest hour, and stacking every trophy would peg the
  /// gauge at 100 and stop saying anything.
  static int compute({
    required Iterable<MatchOutcome> recent,
    required Iterable<({TournamentTier tier, Placing placing})> honours,
    required int? worldRank,
  }) {
    var best = 0;
    for (final h in honours) {
      final bonus = trophyBonus(h.tier, h.placing);
      if (bonus > best) best = bonus;
    }
    return (neutral + formPoints(recent) + best + rankBonus(worldRank))
        .clamp(0, 100);
  }
}
