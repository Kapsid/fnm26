import 'dart:math';

import 'package:fnm/domain/services/ranking/elo.dart';

/// A cycle's earnings, split by source (all euros).
typedef IncomeBreakdown = ({int grant, int prize, int commercial});

/// The federation departments the manager invests in each cycle.
enum Department { youth, commercial, medical, naturalization, boardRelations }

extension DepartmentX on Department {
  String get label => switch (this) {
    Department.youth => 'Youth Academy',
    Department.commercial => 'Commercial / PR',
    Department.medical => 'Medical & Sports Science',
    Department.naturalization => 'Naturalisation Office',
    Department.boardRelations => 'Board Relations',
  };

  /// A one-line description of what the department buys, for the invest UI.
  String get blurb => switch (this) {
    Department.youth =>
      'Better academy prospects debut for your nation next cycle.',
    Department.commercial =>
      'Sponsorship brings extra income at the end of the cycle.',
    Department.medical =>
      'Fewer injuries. Your squad stays available all cycle.',
    Department.naturalization =>
      'More foreign players offer to switch to your nation.',
    Department.boardRelations =>
      'The board judges your results more patiently.',
  };
}

/// The federation economy model: how much a save starts with, what it earns
/// each cycle, and what each department investment buys. Pure and centralised
/// so every number lives in one place and the loop is easy to tune and test.
abstract final class FederationFinance {
  // --- Starting balance -----------------------------------------------------

  /// A new save's opening cash, scaled by the nation's world standing so
  /// footballing powers run richer federations than minnows.
  ///
  /// Deliberately still STEPPED, where the per-cycle grant
  /// ([centralGrantFor]) is now smooth. The two are different kinds of number:
  /// the grant is paid every cycle and has to answer to what just happened on
  /// the pitch, while this is read once, before a ball is kicked, and its
  /// bands are a legible promise about the save you are starting ("a top-eight
  /// nation runs a rich federation"). Its one artefact is the cliff at each
  /// boundary — ninth place opens 15M poorer than eighth — which is worth
  /// revisiting on its own, with its own measurement, rather than as a side
  /// effect of the grant moving.
  static int initialBudget(int worldRank) {
    if (worldRank <= 8) return 45000000;
    if (worldRank <= 20) return 30000000;
    if (worldRank <= 40) return 20000000;
    if (worldRank <= 80) return 12000000;
    return 8000000;
  }

  // --- Income (earned each cycle) ------------------------------------------

  /// The central funding a federation at [midpointRank] receives for a cycle
  /// it neither climbed nor slid through. Every other grant is this number
  /// moved by standing and movement — see [centralGrantFor], which is what the
  /// game actually pays. Kept as a named constant because it is the anchor the
  /// whole economy is reasoned against: it is also what a mid-table nation
  /// opens a save with (see [initialBudget]) and what the staff wage table is
  /// priced against (see `Staff.costPerCycle`).
  static const int centralGrant = 12000000;

  /// The world place whose federation is paid exactly [centralGrant]. The
  /// middle of the 41–80 band [initialBudget] already hands 12M to, so the
  /// grant's anchor and the opening balance agree about what "mid-table" means.
  static const int midpointRank = 60;

  /// Ranking points that separate [midpointRank] from either end of the world
  /// table. Measured off the widened seed table (2026-09-21): first place is
  /// 498 points above the midpoint and 209th is 509 below it, so 500 is the
  /// distance to "as good as it gets" in both directions.
  static const int standingSpanPoints = 500;

  /// Ranking points a championship-winning cycle is worth — the same measured
  /// figure `IntakeStanding.fullClimbPoints` uses, and for the same reason: a
  /// champion climbing from 25th to 5th gains about 170 points, so 200 is a
  /// cycle nobody has a right to expect.
  static const int fullClimbPoints = 200;

  /// The most standing alone adds to the grant, as a fraction of
  /// [centralGrant]: +35% for the best side in the world.
  static const double maxStandingBonus = 0.35;

  /// The most standing alone takes away. Shallower than [maxStandingBonus] on
  /// purpose: a small nation's federation still has to function.
  static const double maxStandingPenalty = 0.15;

  /// The most one cycle's climb adds, as a fraction of [centralGrant].
  static const double maxMovementBonus = 0.25;

  /// The most one cycle's slide takes away. Shallower again — a bad cycle
  /// should hurt, not end a footballing nation.
  static const double maxMovementPenalty = 0.10;

  /// The band the grant is held inside, as multiples of [centralGrant]:
  /// **€9.0M to €19.2M**.
  ///
  /// The floor is the load-bearing half. The federation's only compulsory
  /// outgoing is the staff wage bill (`Staff.totalCost`), which tops out at
  /// €8.4M a cycle for three elite hires; investment in departments is
  /// voluntary and capped by the budget the manager can see. So the worst cycle
  /// the game can produce — bottom of the world, having slid there — still pays
  /// an elite back room and leaves change, and a manager can never be
  /// bankrupted by one bad cycle.
  static const double minGrantMultiplier =
      1 - maxStandingPenalty - maxMovementPenalty;
  static const double maxGrantMultiplier =
      1 + maxStandingBonus + maxMovementBonus;

  /// Euros the grant is rounded to, so the finance screen shows a figure a
  /// person would write down. [centralGrant] and both band ends are exact
  /// multiples of it, so rounding never moves the anchor.
  static const int grantRounding = 10000;

  /// The central funding a federation earns for a finished cycle:
  /// [centralGrant] moved by where the nation stands and how far it climbed.
  ///
  /// The flat grant used to be the same 12M for the world champion and for
  /// 200th, which made half the federation's income deaf to everything that
  /// happened on the pitch. The prize tables ([resultsPrize]) already pay for
  /// how deep a run went; this pays for the STANDING that run built, which is
  /// a slower, longer-lived signal — a nation that spent a cycle climbing is
  /// funded like one on the way up for the cycle after, whether or not it
  /// happened to draw a quarter-final.
  ///
  /// Two rules it obeys, both borrowed from `IntakeStanding` because they were
  /// right there:
  ///
  ///  * **Movement is measured in POINTS, not places.** The world table is not
  ///    a straight line (see [Elo.seedFromRanking]): the gap between first and
  ///    fifth is wider than the gap between fortieth and hundredth. Counting
  ///    places would pay a climb from 60th to 55th the same as one from 6th to
  ///    1st. Standing is measured the same way, for the same reason.
  ///  * **The midpoint is the null control.** A nation at [midpointRank] whose
  ///    position has not moved is paid exactly [centralGrant], to the euro. It
  ///    is asserted as a permanent test.
  ///
  /// [worldRank] is where the nation finished the cycle (1 = best) and
  /// [rankChangeOverCycle] is how many places it CLIMBED getting there
  /// (negative = slid down), so the rank it started from is the sum of the two.
  static int centralGrantFor({
    required int worldRank,
    required int rankChangeOverCycle,
  }) {
    final now = worldRank < 1 ? 1 : worldRank;
    final before = max(1, now + rankChangeOverCycle);
    final nowPoints = Elo.seedFromRanking(now);

    // Where the nation stands, priced against the midpoint.
    final standingPoints = nowPoints - Elo.seedFromRanking(midpointRank);
    final standing =
        (standingPoints /
                standingSpanPoints *
                (standingPoints >= 0 ? maxStandingBonus : maxStandingPenalty))
            .clamp(-maxStandingPenalty, maxStandingBonus);

    // What the cycle's movement was worth.
    final gained = nowPoints - Elo.seedFromRanking(before);
    final movement =
        (gained /
                fullClimbPoints *
                (gained >= 0 ? maxMovementBonus : maxMovementPenalty))
            .clamp(-maxMovementPenalty, maxMovementBonus);

    final multiplier = (1 + standing + movement).clamp(
      minGrantMultiplier,
      maxGrantMultiplier,
    );
    final euros = centralGrant * multiplier;
    return (euros / grantRounding).round() * grantRounding;
  }

  /// Prize money for how deep a nation went in the World Cup finals, by the
  /// deepest round they reached (cumulative, not per round).
  static const Map<String, int> _wcRunPrize = {
    'GROUP': 6000000,
    'R32': 9000000,
    'R16': 13000000,
    'QF': 19000000,
    'SF': 28000000,
    '3RD': 30000000,
    'FINAL': 34000000,
  };

  /// Prize money for a continental-championship run (about half the World Cup).
  static const Map<String, int> _contRunPrize = {
    'CGROUP': 3000000,
    'CR16': 5000000,
    'CQF': 7000000,
    'CSF': 11000000,
    'C3RD': 12000000,
    'CFINAL': 14000000,
  };

  /// A one-off bonus for actually lifting a trophy, by competition name.
  static const Map<String, int> _titleBonus = {
    'World Championship': 20000000,
    'Nations Cup': 4000000,
    'Continental Clash': 3000000,
  };

  /// Prize money for a finished cycle: the deepest World Cup and continental
  /// runs plus any titles won. [wcRounds]/[contRounds] are the finals rounds
  /// the nation appeared in; [titlesWon] the competitions it won (the
  /// continental cup is matched by name via [continentalName]).
  static int resultsPrize({
    required Set<String> wcRounds,
    required Set<String> contRounds,
    required Set<String> titlesWon,
    String? continentalName,
  }) {
    var prize = 0;
    prize += _deepest(wcRounds, _wcRunPrize);
    prize += _deepest(contRounds, _contRunPrize);
    for (final title in titlesWon) {
      prize += _titleBonus[title] ?? 0;
      if (continentalName != null && title == continentalName) {
        prize += 10000000; // continental crown
      }
    }
    return prize;
  }

  static int _deepest(Set<String> rounds, Map<String, int> table) {
    var best = 0;
    for (final r in rounds) {
      final v = table[r] ?? 0;
      if (v > best) best = v;
    }
    return best;
  }

  /// The commercial return realised at a cycle's close from the euros invested
  /// in Commercial/PR that cycle — a 1.6× payback, the money-makes-money loop.
  static int commercialReturn(int invested) => (invested * 1.6).round();

  // --- Investment effects ---------------------------------------------------

  /// The most a department can usefully absorb in one cycle — effects are
  /// capped here, and the invest UI uses it as the slider ceiling.
  static const int maxInvestPerDepartment = 40000000;

  /// The talent scale bonus applied to a nation's newgen intake for a cycle,
  /// from the euros invested in the Youth Academy. Diminishing, capped so an
  /// academy lifts prospects without breaking the curve (~+12 overall at most).
  ///
  /// The cap is reached exactly at [maxInvestPerDepartment] — it used to need
  /// 60M to hit 0.18 while the slider stopped at 40M, so the impact preview
  /// topped out at "+8" and the advertised ceiling was unreachable however much
  /// the manager spent.
  static double youthTalentBonus(int invested) =>
      min(0.18, invested / maxInvestPerDepartment * 0.18);

  /// The multiplier applied to a nation's per-minute injury rate for a cycle,
  /// from the euros invested in Medical — down to 30% of the base rate.
  ///
  /// The reduction used to bottom out at 20M, half the slider's range, so the
  /// impact preview froze at ×0.40 and the top half of the slider bought
  /// nothing. Same rate per euro as before; it now keeps paying to the ceiling.
  static double injuryFactor(int invested) =>
      1 - min(0.7, invested / 20000000 * 0.6);

  /// The probability that a foreign player offers to naturalise this cycle,
  /// from the euros invested in the Naturalisation Office. A small base chance
  /// even with no spend, rising to ~75% at full investment. The curve is
  /// concave (exponent < 1), so even a modest investment already lifts the
  /// chance noticeably rather than needing a near-maximum spend to matter.
  static double naturalizationChance(int invested) => min(
    0.78,
    0.08 + pow(invested / 40000000, 0.7).toDouble() * 0.67,
  );

  /// Extra board patience (in reputation-equivalent points) bought by investing
  /// in Board Relations this cycle — it lifts the manager's standing in the
  /// board's eyes and lowers the bar below which they'd be sacked, up to ~+20 at
  /// full investment.
  static int boardTolerance(int invested) =>
      min(20, (invested / 40000000 * 20).round());
}

/// The federation's long-term infrastructure, expressed as a "building" per
/// department whose LEVEL grows with the total euros ploughed into it across
/// every cycle of the save. Purely a read model over the investment history —
/// it visualises accumulated commitment (the thing a single cycle's slider
/// can't show) without changing the per-cycle effect curves.
abstract final class FederationBuildings {
  /// Euros of *maintained* investment that separate one building level from the
  /// next — reached in a couple of well-funded cycles, so infrastructure grows
  /// at a satisfying pace.
  static const int eurosPerLevel = 15000000;

  /// How much of a building's standing carries into the next cycle. Below 1 it
  /// decays, so a department left unfunded slides back down its levels rather
  /// than holding forever — infrastructure has to be maintained.
  static const double carryOver = 0.75;

  /// The highest level a building can reach.
  static const int maxLevel = 10;

  /// The maintained ("effective") euros behind a building after applying the
  /// per-cycle [carryOver] decay to each past cycle's spend, given [spendByCycle]
  /// (cycle → euros) up to and including [currentCycle]. Recent, sustained
  /// funding dominates; old one-off splurges fade.
  static int maintainedEuros(
    Map<int, int> spendByCycle,
    int currentCycle,
  ) {
    var effective = 0.0;
    for (var c = 0; c <= currentCycle; c++) {
      effective = effective * carryOver + (spendByCycle[c] ?? 0);
    }
    return effective.round();
  }

  /// The building level for [cumulativeEuros] poured into a department over the
  /// save so far — level 1 from the first euro, one level per [eurosPerLevel].
  static int levelFor(int cumulativeEuros) {
    final level = 1 + cumulativeEuros ~/ eurosPerLevel;
    return level > maxLevel ? maxLevel : level;
  }

  /// How far (0–1) the building is toward its next level; 1.0 once maxed.
  static double progressFor(int cumulativeEuros) {
    if (levelFor(cumulativeEuros) >= maxLevel) return 1;
    return (cumulativeEuros % eurosPerLevel) / eurosPerLevel;
  }

  /// A short display name for a department's building.
  static String nameFor(Department d) => switch (d) {
    Department.youth => 'Academy',
    Department.commercial => 'Commercial HQ',
    Department.medical => 'Medical Centre',
    Department.naturalization => 'Scouting Office',
    Department.boardRelations => 'Boardroom',
  };
}
