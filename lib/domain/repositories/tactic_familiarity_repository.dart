import 'package:fnm/domain/entities/formation.dart';

/// How drilled the manager is in each shape, and how well opponents have read
/// it. Both figures are `0..1`; see `TeamChemistry` for how each rises and
/// decays.
///
/// [lastPlanKey] is the fingerprint (`TeamChemistry.planKey`) of the plan of
/// the manager's MOST RECENT match, kept on the shape he fielded in it and 0
/// on every other shape (saves recorded before 2026-10-17 may still carry an
/// older key on other shapes; see `TeamChemistry.lastFielded`). It is what an
/// opponent's video room has on the manager: `ScoutedPlan.fromDrilling`
/// decodes it into the plan the AI counters, read as sharply as
/// [predictability] says, which counts how many matches in a row that exact
/// plan has been played (`TeamChemistry.bumpPredictability`).
typedef ShapeDrilling = ({
  double familiarity,
  double predictability,
  int lastPlanKey,
});

/// Persisted tactical familiarity per formation, per career.
abstract interface class TacticFamiliarityRepository {
  /// Familiarity and predictability for each formation the manager has
  /// fielded. Formations never used are absent (treated as zero for both).
  Future<Map<Formation, ShapeDrilling>> forCareer(int careerId);

  /// Records that [used] was fielded this match with the plan fingerprinted by
  /// [planKey] (see `TeamChemistry.planKey`), as `TeamChemistry.afterMatch`
  /// says: raise its familiarity, grow its predictability if the plan was the
  /// same as last match's (else start it again), and decay every other stored
  /// shape and clear its plan.
  Future<void> recordMatch(int careerId, Formation used, {int planKey = 0});

  /// Clears all familiarity for a career — e.g. when the manager takes a new
  /// nation and inherits an unfamiliar squad.
  Future<void> reset(int careerId);
}
