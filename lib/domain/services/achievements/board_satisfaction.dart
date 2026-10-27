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

  /// How much of the LAST cycle's standing a manager keeps into the new one.
  ///
  /// The gauge used to reset to [neutral] every four years, so the man who had
  /// just won the World Cup opened his next cycle on exactly the figure of the
  /// man who had nearly been sacked. A reputation is not nothing.
  ///
  /// At a quarter it was very nearly nothing: a manager who finished on ninety
  /// opened the next cycle on sixty, and since a new cycle also has no settled
  /// objective yet — the term that dominates the gauge — the board appeared to
  /// forget four good years overnight and open every cycle unimpressed. Nobody
  /// is sacked at a rollover, and the same job carries on across it, so the
  /// standing should carry on across it too.
  ///
  /// At [carryOver] the same manager opens on eighty-four: the cycle turns and
  /// the board is still onside, but the gauge drifts back toward [neutral]
  /// rather than banking a triumph forever, and a bad cycle still costs him
  /// almost everything he had — the guard below is that no reputation survives
  /// a missed World Cup brief and a window of defeats.
  static const double carryOver = 0.85;

  /// Where the gauge STARTS this cycle, given where it finished the last one.
  ///
  /// [previous] is null for a save's first cycle, or one that predates the
  /// figure being recorded — both of which start neutral, exactly as every
  /// cycle used to.
  ///
  /// [minnow] (see [minnowFactor]) lets a poor standing fade faster at the
  /// very bottom: a bad cycle at San Marino is carried into the next at
  /// [minnowCarryOver] rather than [carryOver]. A good one carries as it does
  /// everywhere, and at 0 nothing changes.
  static int openingFrom(int? previous, {double minnow = 0}) {
    if (previous == null) return neutral;
    final carry = previous < neutral && minnow > 0
        ? carryOver + (minnowCarryOver - carryOver) * minnow.clamp(0, 1)
        : carryOver;
    return (neutral + (previous - neutral) * carry).round().clamp(0, 100);
  }

  /// How much of a BELOW-neutral standing the weakest side of all keeps into
  /// the next cycle (see [openingFrom]).
  static const double minnowCarryOver = 0.3;

  /// How far toward the bottom of the world a side sits, as the board's
  /// patience with it: 0 for every side that is not a minnow, rising smoothly
  /// to 1 for the weakest of all.
  ///
  /// Every minnow used to lose its job. A brief and a run of form sized for a
  /// mid-table side are not ones San Marino or American Samoa can live with:
  /// they lose nearly every match whoever manages them, and a board that
  /// holds each of those defeats against him as it would against Scotland's
  /// manager sacks him every time.
  ///
  /// Two things make a minnow, and both must hold, so the factor is their
  /// product: a world rank beyond [minnowWorldFrom] (full at
  /// [minnowWorldFrom] + [minnowWorldSpan]), and a place in the bottom
  /// [minnowConfederationShare] of its own confederation (full in the last
  /// [minnowConfederationFull]). Oceania's second-best side is ranked in the
  /// 150s and is no minnow there; Malta, near the foot of Europe and 154th in
  /// the world, is two-thirds of one. Anyone ranked [minnowWorldFrom] or
  /// better is exactly 0.
  static double minnowFactor({
    required int worldRank,
    required int confederationRank,
    required int confederationSize,
  }) {
    final world = ((worldRank - minnowWorldFrom) / minnowWorldSpan).clamp(
      0.0,
      1.0,
    );
    if (world <= 0 || confederationSize <= 1) return 0;
    final share = confederationRank / confederationSize;
    final conf =
        ((share - (1 - minnowConfederationShare)) /
                (minnowConfederationShare - minnowConfederationFull))
            .clamp(0.0, 1.0);
    return world * conf;
  }

  /// See [minnowFactor].
  static const int minnowWorldFrom = 120;
  static const int minnowWorldSpan = 50;
  static const double minnowConfederationShare = 0.3;
  static const double minnowConfederationFull = 0.15;

  /// The minnow's form weights at a [minnowFactor] of 1, each slid toward
  /// from the ordinary one as the factor rises.
  ///
  /// A draw is a good day, so it earns a point. A plain defeat costs two, not
  /// five: losing to a side ranked forty places higher is what a minnow does.
  /// A defeat by a clear giant costs nothing at all, however many it was by.
  /// What still costs the full [loss] is a HUMILIATION (see [isHumiliation]):
  /// a heavy defeat by a fellow minnow, which is what a genuinely bad manager
  /// of a minnow keeps producing.
  static const int minnowDraw = 1;
  static const int minnowLoss = -2;
  static const int minnowLossAsUnderdog = 0;

  /// The margin of defeat that is a humiliation (see [isHumiliation]).
  static const int humiliationMargin = 4;

  /// How far above a side a fellow minnow can be ranked (see
  /// [isHumiliation]).
  static const int minnowPeerGap = 30;

  /// Whether a defeat by [margin] goals, for a side ranked [ownRank], against
  /// one ranked [opponentRank], is a humiliation: [humiliationMargin] or more
  /// against a fellow minnow, a side no more than [minnowPeerGap] places
  /// above it (or anywhere below it). Losing 0-5 to Fiji is American Samoa's
  /// lot; losing 0-5 to Tonga is not.
  static bool isHumiliation({
    required int margin,
    required int ownRank,
    required int opponentRank,
  }) => margin >= humiliationMargin && opponentRank >= ownRank - minnowPeerGap;

  /// How much of a missed brief's penalty the weakest side of all still pays
  /// (see [objectiveSwing]). Meeting a brief is worth the same everywhere.
  static const double minnowMissedShare = 0.5;

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
  /// their world ranking. At −4 that promise was not kept: a top-five side's
  /// standing bonus (+12) left the gauge on 22 against a bar of 15, so the
  /// worst run in the game cost a well-regarded manager nothing. At −5 a full
  /// window of defeats lands on 12 however good the badge is. A reputation
  /// still buys rope, which is a different thing and deliberate.
  static const int win = 2;
  static const int draw = 0;
  static const int loss = -5;

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

  /// What a result is worth against a clearly stronger side (see
  /// [isUnderdog]): a board does not hold a defeat by a giant against a
  /// minnow's manager the way it holds one by an equal, and a point taken off
  /// one is a good day. Every minnow used to lose its job on form alone.
  static const int winAsUnderdog = 5;
  static const int drawAsUnderdog = 2;
  static const int lossAsUnderdog = -1;

  /// Whether a side ranked [ownRank] in the world plays [opponentRank] as the
  /// clear underdog: the opponent at least twice as high and ten places up.
  static bool isUnderdog({required int ownRank, required int opponentRank}) =>
      opponentRank * 2 <= ownRank && ownRank - opponentRank >= 10;

  /// The form contribution of [recent] (most recent first); only the newest
  /// [formWindow] matches count. [asUnderdog] runs alongside it, true for a
  /// match played as the clear underdog; missing entries count as level.
  ///
  /// [minnow] (see [minnowFactor]) slides the draw and defeat weights toward
  /// the minnow's ([minnowDraw], [minnowLoss], [minnowLossAsUnderdog]);
  /// [humiliations] runs alongside [recent], true for a defeat that is a
  /// humiliation (see [isHumiliation]), which keeps its full weight. At 0 the
  /// weights are exactly the ordinary ones.
  static int formPoints(
    Iterable<MatchOutcome> recent, {
    Iterable<bool> asUnderdog = const [],
    double minnow = 0,
    Iterable<bool> humiliations = const [],
  }) {
    final underdog = asUnderdog.toList();
    final m = minnow.clamp(0.0, 1.0);
    if (m <= 0) {
      var points = 0;
      var i = 0;
      for (final outcome in recent.take(formWindow)) {
        final under = i < underdog.length && underdog[i];
        i++;
        points += switch (outcome) {
          MatchOutcome.win => under ? winAsUnderdog : win,
          MatchOutcome.draw => under ? drawAsUnderdog : draw,
          MatchOutcome.loss => under ? lossAsUnderdog : loss,
        };
      }
      return points;
    }
    double slide(int from, int to) => from + (to - from) * m;
    final humiliated = humiliations.toList();
    var points = 0.0;
    var i = 0;
    for (final outcome in recent.take(formWindow)) {
      final under = i < underdog.length && underdog[i];
      final humiliation = !under && i < humiliated.length && humiliated[i];
      i++;
      points += switch (outcome) {
        MatchOutcome.win => under ? winAsUnderdog : win,
        MatchOutcome.draw => under ? drawAsUnderdog : slide(draw, minnowDraw),
        MatchOutcome.loss =>
          under
              ? slide(lossAsUnderdog, minnowLossAsUnderdog)
              : humiliation
              ? loss
              : slide(loss, minnowLoss),
      };
    }
    return points.round();
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
  ///
  /// The lowest brief, the qualifying campaign of a side with no route to the
  /// finals, weighs a little less again: missing it cost a minnow as much as a
  /// mid-table side missing the finals, and two such misses alone took a
  /// neutral board below the sacking bar.
  static double demandFactor(int target) => 1 + 0.18 * (target.clamp(1, 7) - 2);

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
  ///
  /// A missed brief costs a minnow less (see [minnowFactor] and
  /// [minnowMissedShare]); at 0 the swing is exactly the ordinary one.
  static int objectiveSwing(ObjectiveResult o, {double minnow = 0}) {
    final w = objectiveWeights(o.tier);
    final gap = (o.actual - o.target).clamp(-5, 3);
    final raw = gap >= 0
        ? w.met + gap * w.step + overachievementBonus(o.tier, gap)
        : -(w.met + (-gap) * w.step);
    final m = minnow.clamp(0.0, 1.0);
    final patience = gap < 0 && m > 0 ? 1 - (1 - minnowMissedShare) * m : 1.0;
    return (raw * demandFactor(o.target) * patience).round();
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

  /// Whether a brief already counts as met before its tournament is over.
  ///
  /// A finals run only ever goes deeper, so once a World Championship or
  /// continental brief is reached it cannot be lost again: the board credits
  /// it there and then, rather than when the run ends. Waiting left a side
  /// that had qualified as asked sitting on its finals form until the
  /// verdict, and the gauge jumped the day the tournament was settled. The
  /// Nations Cup and the qualifying-group rungs are table positions, which
  /// can still slip, so they wait for the verdict.
  static bool lockedIn(ObjectiveResult o) =>
      (o.tier == TournamentTier.world ||
          o.tier == TournamentTier.continental) &&
      o.actual >= 2 &&
      o.actual >= o.target;

  /// What each defeat at a finals tournament costs once its brief is
  /// [lockedIn]. Those games leave the form window, since the brief they
  /// were played for is already answered, and only losing still costs a
  /// little, so a side that qualified as asked and then loses every game is
  /// marked down a few points, not dragged back under the sacking bar.
  static const int lockedInLoss = -1;

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

    /// Alongside [recent]: which of those matches were played as the clear
    /// underdog (see [formPoints]).
    Iterable<bool> recentAsUnderdog = const [],
    required Iterable<({TournamentTier tier, Placing placing})> honours,
    required int? worldRank,
    Iterable<ObjectiveResult> objectives = const [],

    /// What the country thinks, 0–100. [PublicMood.neutral] means the board has
    /// no public opinion to weigh and behaves exactly as it did before Y.
    int publicMood = PublicMood.neutral,

    /// Where the gauge finished the PREVIOUS cycle, or null for a first cycle.
    /// See [carryOver] — a reputation buys a little rope, not a free pass.
    int? previousCycle,

    /// Defeats at finals whose brief is already [lockedIn]; those games are
    /// left out of [recent]. See [lockedInLoss].
    int lockedInLosses = 0,

    /// How much of a minnow the nation is (see [minnowFactor]): a softer form
    /// window, a smaller cost for a missed brief and a bad cycle that fades
    /// faster. 0, the default, is every other side and changes nothing.
    double minnow = 0,

    /// Alongside [recent]: which of those matches were humiliations (see
    /// [isHumiliation]), for the minnow's form.
    Iterable<bool> recentHumiliations = const [],
  }) {
    var best = 0;
    for (final h in honours) {
      final bonus = trophyBonus(h.tier, h.placing);
      if (bonus > best) best = bonus;
    }
    var fromObjectives = 0;
    for (final o in objectives) {
      fromObjectives += objectiveSwing(o, minnow: minnow);
    }
    return (openingFrom(previousCycle, minnow: minnow) +
            formPoints(
              recent,
              asUnderdog: recentAsUnderdog,
              minnow: minnow,
              humiliations: recentHumiliations,
            ) +
            lockedInLosses * lockedInLoss +
            best +
            fromObjectives +
            rankBonus(worldRank) +
            PublicMood.boardShift(publicMood))
        .clamp(0, 100);
  }
}
