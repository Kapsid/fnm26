import 'package:fnm/domain/entities/formation.dart';

/// How drilled the manager is in each shape, and how well opponents have read
/// it. Both figures are `0..1`; see `TeamChemistry` for how they combine into a
/// match multiplier and how each rises and decays.
typedef ShapeDrilling = ({double familiarity, double predictability});

/// Persisted tactical familiarity per formation, per career.
abstract interface class TacticFamiliarityRepository {
  /// Familiarity and predictability for each formation the manager has
  /// fielded. Formations never used are absent (treated as zero for both).
  Future<Map<Formation, ShapeDrilling>> forCareer(int careerId);

  /// Records that [used] was fielded this match with the plan fingerprinted by
  /// [planKey] (see `TeamChemistry.planKey`): raise its familiarity, move its
  /// predictability by whether the plan was the same again, and decay every
  /// other stored shape.
  Future<void> recordMatch(int careerId, Formation used, {int planKey = 0});

  /// Clears all familiarity for a career — e.g. when the manager takes a new
  /// nation and inherits an unfamiliar squad.
  Future<void> reset(int careerId);
}
