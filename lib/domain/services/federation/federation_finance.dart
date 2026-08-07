import 'dart:math';

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
  static int initialBudget(int worldRank) {
    if (worldRank <= 8) return 45000000;
    if (worldRank <= 20) return 30000000;
    if (worldRank <= 40) return 20000000;
    if (worldRank <= 80) return 12000000;
    return 8000000;
  }

  // --- Income (earned each cycle) ------------------------------------------

  /// Flat central funding every federation receives each cycle.
  static const int centralGrant = 12000000;

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
