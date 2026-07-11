import 'package:fnm/domain/entities/player_absence.dart';

/// Persists disciplinary and injury standings for a save's players.
///
/// Only players with something to track are stored: [forCareer] returns a map
/// keyed by player id, and [replace] swaps in a fresh set of standings for the
/// whole save (rows for players no longer notable are dropped).
abstract interface class AbsenceRepository {
  /// The standings for every tracked player in [careerId].
  Future<Map<int, PlayerAbsence>> forCareer(int careerId);

  /// Replaces all standings for [careerId] with [absences].
  Future<void> replace(int careerId, Iterable<PlayerAbsence> absences);
}
