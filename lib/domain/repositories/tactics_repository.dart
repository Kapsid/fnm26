import 'package:fnm/domain/entities/tactics.dart';

/// Persists the team tactic (shape, XI, instructions) for a save.
abstract interface class TacticsRepository {
  /// The saved tactic for [careerId], or null if none set.
  Future<Tactic?> tacticForCareer(int careerId);

  /// Saves (replaces) the tactic for [careerId].
  Future<void> saveTactic(int careerId, Tactic tactic);
}
