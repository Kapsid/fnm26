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

  /// How much of the training actually lands, as a multiplier.
  ///
  /// [StaffTier.none] is ZERO rather than a fraction. It used to be 0.6 — a
  /// manager with no assistant still trains his side, he just gets less out of
  /// it — which was right while the focus was a separate CHOICE the manager
  /// made. Now that the assistant IS the training, "nobody in the job" has to
  /// mean "no effect", or hiring nobody would quietly buy a bonus and a save
  /// from before any of this existed would stop playing the way it did.
  static double trainingEffect(StaffTier assistant) => switch (assistant) {
    StaffTier.none => 0.0,
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

  /// What the ASSISTANT's conditioning work is worth on top of the fitness
  /// coach's, as a multiplier on the injury rate.
  ///
  /// This, [familiarityGain] and [youthTalentBonus] are what became of the
  /// training focus. The manager used to pick one of fitness, cohesion or
  /// youth work and get its full effect; the choice was noise, because there
  /// was never a reason to change it once made. The assistant now does all
  /// three, each at HALF the old weight — so a manager gives nothing up to get
  /// any of them, and a side with no assistant sits exactly where it always
  /// did.
  static double assistantInjuryFactor(StaffTier assistant) =>
      1 - 0.06 * trainingEffect(assistant);

  /// The multiplier on how fast a shape beds in.
  static double familiarityGain(StaffTier assistant) =>
      1 + 0.12 * trainingEffect(assistant);

  /// Added to the youth-talent bonus, on top of the federation's academy
  /// spending and the manager's own eye for a young player.
  static double youthTalentBonus(StaffTier assistant) =>
      0.025 * trainingEffect(assistant);
}
