import 'package:fnm/domain/services/press/public_mood.dart';

/// How a single match went for the manager's nation.
enum MatchOutcome { win, draw, loss }

/// The competitions the board weighs, in descending prestige. A World Cup is
/// the point of the cycle; a Continental Clash is an exhibition.
enum TournamentTier { world, continental, nationsCup, clash }

/// Where the manager's nation finished a tournament.
enum Placing { champion, runnerUp, third }

/// A settled board objective: what was demanded at [tier] and how far the
/// nation actually went, both on the 2 (qualify) … 7 (champions) scale.
typedef ObjectiveResult = ({TournamentTier tier, int target, int actual});

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

  /// What meeting an objective at [tier] is worth, and what each round beyond
  /// (or short of) it adds. The World Cup dominates; the continental cup is
  /// worth roughly two-thirds of it.
  static ({int met, int step}) objectiveWeights(TournamentTier tier) =>
      switch (tier) {
        TournamentTier.world => (met: 18, step: 7),
        TournamentTier.continental => (met: 12, step: 5),
        TournamentTier.nationsCup => (met: 5, step: 2),
        TournamentTier.clash => (met: 2, step: 1),
      };

  /// How much harder a board judges the brief it actually set, by the height of
  /// the demand (2 = "qualify" … 7 = "win it").
  ///
  /// A federation that tells its side to lift the World Cup has staked
  /// everything on it, and lives or dies by whether it happened; one that asks
  /// only to be there has far less riding on the answer. Scaling by the demand
  /// is what makes the gauge move hardest at the biggest nations — which is
  /// where a missed objective should genuinely cost a manager their job.
  static double demandFactor(int target) => 1 + 0.18 * (target.clamp(2, 7) - 2);

  /// The board's swing for one settled objective: strongly positive for hitting
  /// the brief (more so for beating it), strongly negative for falling short,
  /// in proportion to how far short — and to how much was demanded in the first
  /// place (see [demandFactor]).
  ///
  /// This is the term that makes the gauge legible. It used to be absent
  /// entirely — satisfaction was recent form plus the best trophy plus a rank
  /// bonus — so a manager could miss the stated objective and still sit high on
  /// good friendly form, or meet it and sit low. The board now answers for what
  /// it actually asked for, and it is the dominant term: no run of form or
  /// stack of minor honours outweighs the cycle's stated brief.
  static int objectiveSwing(ObjectiveResult o) {
    final w = objectiveWeights(o.tier);
    final gap = (o.actual - o.target).clamp(-5, 3);
    final raw = gap >= 0
        ? w.met + gap * w.step + overachievementBonus(o.tier, gap)
        : -(w.met + (-gap) * w.step);
    return (raw * demandFactor(o.target)).round();
  }

  /// What BEATING the brief is worth, on top of the rounds it was beaten by.
  ///
  /// Meeting an objective and surpassing it used to differ by a single [step],
  /// so a side told to reach the quarter-finals and carried to the final was
  /// scored barely above one that went out in the last eight as instructed.
  /// Exceeding what the board asked for is the thing a manager is remembered
  /// for; it earns a flat surge the moment the brief is beaten at all, and the
  /// per-round steps then stack on top.
  static int overachievementBonus(TournamentTier tier, int gap) =>
      gap <= 0 ? 0 : objectiveWeights(tier).step;

  /// The board's mood.
  ///
  /// [objectives] are the cycle's SETTLED expectations (see `objectiveSwing`) —
  /// the dominant term. [recent] form nudges it match to match, [honours]
  /// covers the side competitions nobody sets an objective for, and
  /// [worldRank] is a small standing bonus.
  ///
  /// Only the best [honours] placing counts rather than the sum: a board judges
  /// the cycle on its finest hour, and stacking every trophy would peg the
  /// gauge at 100 and stop saying anything.
  static int compute({
    required Iterable<MatchOutcome> recent,
    required Iterable<({TournamentTier tier, Placing placing})> honours,
    required int? worldRank,
    Iterable<ObjectiveResult> objectives = const [],

    /// What the country thinks, 0–100. [PublicMood.neutral] means the board has
    /// no public opinion to weigh and behaves exactly as it did before Y.
    int publicMood = PublicMood.neutral,
  }) {
    var best = 0;
    for (final h in honours) {
      final bonus = trophyBonus(h.tier, h.placing);
      if (bonus > best) best = bonus;
    }
    var fromObjectives = 0;
    for (final o in objectives) {
      fromObjectives += objectiveSwing(o);
    }
    return (neutral +
            formPoints(recent) +
            best +
            fromObjectives +
            rankBonus(worldRank) +
            PublicMood.boardShift(publicMood))
        .clamp(0, 100);
  }
}
