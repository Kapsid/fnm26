/// Persists the world-ranking positions frozen at the start of each cycle.
///
/// A cycle's draws (qualifying and finals, plus their ceremony re-derivations)
/// all seed from the same frozen snapshot, so they stay consistent no matter
/// when they run. Cycle 0 is never snapshotted — callers fall back to the
/// static seed ranking there.
abstract interface class SeedRankingRepository {
  /// The frozen positions (nationId → rank, 1 = top) for [cycle] of [careerId],
  /// or an empty map if that cycle was never snapshotted.
  Future<Map<int, int>> forCycle(int careerId, int cycle);

  /// Freezes [rankById] (nationId → rank) as the seeding ranking for [cycle].
  Future<void> snapshot(int careerId, int cycle, Map<int, int> rankById);
}
