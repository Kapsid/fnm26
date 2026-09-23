/// What the manager himself is good at.
///
/// The squad evolves across a long career and the manager never did: his only
/// number was a reputation the board used to decide whether to keep him. These
/// are four things he can actually get better AT, earned by doing the job, and
/// each one is wired to a system that already exists rather than being a badge.
enum ManagerSkill {
  /// How much a dressing room takes from what he says — press answers and
  /// players who come to see him.
  manManagement,

  /// How quickly a side settles into a shape he has asked them to play.
  tactical,

  /// What comes out of the academy.
  youthDevelopment,

  /// What he can talk the federation into funding.
  negotiation,
}

abstract final class ManagerSkills {
  /// The scale. Twenty is the ceiling; nobody starts near it.
  static const int floor = 1;
  static const int ceiling = 20;

  /// Where every manager begins, and the level at which a skill does NOTHING
  /// either way. Every effect below is expressed as a departure from this, so
  /// an untouched save plays exactly as it did before any of this existed.
  static const int starting = 5;

  /// Points for finishing a four-year cycle — the job's own unit of time.
  static const int pointsPerCycle = 2;

  /// And for winning something, which is the other way a manager learns.
  static const int pointsPerTrophy = 1;

  /// How many points a career has earned in total.
  static int pointsEarned({
    required int cyclesCompleted,
    required int trophies,
  }) => cyclesCompleted * pointsPerCycle + trophies * pointsPerTrophy;

  /// How many are still unspent, given what has been put into the skills.
  ///
  /// Spending is not stored: it is the difference between the levels and where
  /// they started. One less column, and no way for the two to disagree.
  static int pointsAvailable({
    required int earned,
    required Map<ManagerSkill, int> levels,
  }) {
    var spent = 0;
    for (final skill in ManagerSkill.values) {
      spent += (levels[skill] ?? starting) - starting;
    }
    return earned - spent;
  }

  /// Whether [skill] can be raised right now.
  static bool canRaise({
    required ManagerSkill skill,
    required int earned,
    required Map<ManagerSkill, int> levels,
  }) =>
      (levels[skill] ?? starting) < ceiling &&
      pointsAvailable(earned: earned, levels: levels) > 0;

  /// How hard what he says lands, as a multiplier on a press answer's or a
  /// grievance's effect on the dressing room.
  ///
  /// It cuts both ways on purpose: a poor man-manager is not merely less
  /// persuasive, he is *worse* at it than the average, which is what makes the
  /// skill worth points rather than a slow drip of free morale.
  static double moraleSwing(int manManagement) => _factor(manManagement, 0.030);

  /// How fast a formation beds in, as a multiplier on the per-match
  /// familiarity gain.
  static double familiarityGain(int tactical) => _factor(tactical, 0.030);

  /// Added to the federation's youth-talent bonus, so a good developer gets
  /// more out of the same academy.
  static double youthTalentBonus(int youthDevelopment) =>
      (youthDevelopment - starting) * 0.010;

  /// A multiplier on money coming in.
  static double incomeBonus(int negotiation) => _factor(negotiation, 0.020);

  /// A departure from [starting], clamped to the scale so a stored value from
  /// a corrupted save cannot produce a wild multiplier.
  static double _factor(int level, double perStep) =>
      1 + (level.clamp(floor, ceiling) - starting) * perStep;
}
