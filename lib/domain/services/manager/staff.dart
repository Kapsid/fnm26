/// The people the manager hires around him.
///
/// Two problems, one answer. The federation budget had almost nothing to spend
/// on beyond its own departments, and the months between international windows
/// were empty — the calendar simply skipped them. Staff are a standing cost
/// that buys a standing effect, so the money means something and the gap has a
/// decision in it.
enum StaffRole {
  /// Runs the training between windows. Everything [TrainingFocus] does, he
  /// does more of.
  assistant,

  /// Reads what a young player will BECOME rather than what he is.
  scout,

  /// Keeps them on the pitch.
  fitnessCoach,
}

/// How good the person in the job is. [none] is the default and costs nothing —
/// a save that never hires anybody plays exactly as it did before.
enum StaffTier { none, basic, good, elite }

abstract final class Staff {
  /// What a tier costs per four-year cycle, in euros. Charged at the rollover
  /// alongside the federation's other outgoings.
  ///
  /// Priced against `FederationFinance.initialBudget`, which starts a mid-table
  /// nation around €12M a cycle: a full set of elite staff is a real chunk of
  /// that and has to be chosen over a department.
  static int costPerCycle(StaffTier tier) => switch (tier) {
    StaffTier.none => 0,
    StaffTier.basic => 400000,
    StaffTier.good => 1200000,
    StaffTier.elite => 2800000,
  };

  /// The whole wage bill for one cycle.
  static int totalCost(Map<StaffRole, StaffTier> staff) {
    var total = 0;
    for (final role in StaffRole.values) {
      total += costPerCycle(staff[role] ?? StaffTier.none);
    }
    return total;
  }

  /// How much of the training focus actually lands, as a multiplier. Without an
  /// assistant a manager still trains his side; he just gets less out of it.
  static double trainingEffect(StaffTier assistant) => switch (assistant) {
    StaffTier.none => 0.6,
    StaffTier.basic => 1.0,
    StaffTier.good => 1.3,
    StaffTier.elite => 1.6,
  };

  /// How many caps it takes before a player's ceiling is KNOWN rather than
  /// estimated — a better scout tells you sooner, which is the whole value of
  /// one: you find out before you have spent three years finding out.
  ///
  /// [baseCaps] is what the game would ask for with no scout at all.
  static int capsToKnow(StaffTier scout, int baseCaps) => switch (scout) {
    StaffTier.none => baseCaps,
    StaffTier.basic => (baseCaps * 0.75).round(),
    StaffTier.good => (baseCaps * 0.5).round(),
    StaffTier.elite => (baseCaps * 0.25).round(),
  };

  /// A multiplier on the side's injury rate. Compounds with the federation's
  /// medical department rather than replacing it: money and people are two
  /// different ways of keeping a squad fit.
  static double injuryFactor(StaffTier fitnessCoach) => switch (fitnessCoach) {
    StaffTier.none => 1.0,
    StaffTier.basic => 0.94,
    StaffTier.good => 0.87,
    StaffTier.elite => 0.78,
  };
}

/// What the side works on between windows.
///
/// International football is six or seven windows a year and a great deal of
/// waiting. This is what the manager does with the waiting.
enum TrainingFocus {
  /// A bit of everything, which is to say nothing in particular.
  balanced,

  /// Conditioning. Fewer knocks, fresher legs.
  fitness,

  /// Drilling the shape until it is second nature.
  cohesion,

  /// Hours with the youngest players in the pool.
  youth,
}

abstract final class Training {
  /// The injury multiplier a focus earns, scaled by who is running it.
  static double injuryFactor(TrainingFocus focus, StaffTier assistant) =>
      focus == TrainingFocus.fitness
      ? 1 - 0.12 * Staff.trainingEffect(assistant)
      : 1.0;

  /// The multiplier on how fast a shape beds in.
  static double familiarityGain(TrainingFocus focus, StaffTier assistant) =>
      focus == TrainingFocus.cohesion
      ? 1 + 0.25 * Staff.trainingEffect(assistant)
      : 1.0;

  /// Added to the youth-talent bonus, on top of the federation's academy
  /// spending and the manager's own eye for a young player.
  static double youthTalentBonus(TrainingFocus focus, StaffTier assistant) =>
      focus == TrainingFocus.youth
      ? 0.05 * Staff.trainingEffect(assistant)
      : 0.0;
}
