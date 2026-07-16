/// Persists the set of players a manager has called up to the national squad
/// for a save.
///
/// An empty result means the manager has not curated the squad; callers should
/// then treat the whole nation pool as available (see [SquadRepository.callUps]
/// docs on the default).
abstract interface class SquadRepository {
  /// The ids of players currently called up for [careerId]. An empty set means
  /// no explicit selection has been made yet (the full nation pool applies).
  Future<Set<int>> callUps(int careerId);

  /// Replaces the called-up squad for [careerId] with [playerIds].
  Future<void> setCallUps(int careerId, Set<int> playerIds);

  /// Drops every call-up for [careerId], returning the save to "no explicit
  /// selection" — used when the manager moves to a new nation, whose players
  /// share no ids with the old squad.
  Future<void> clearCallUps(int careerId);
}
