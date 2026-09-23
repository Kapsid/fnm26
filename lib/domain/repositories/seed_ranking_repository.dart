/// Persists world-ranking snapshots used to seed draws.
///
/// Two kinds share this store, keyed by [cycle]:
/// * the real cycle number holds the positions frozen at the cycle's START —
///   the baseline the ranking-movement arrows measure against, and the seed for
///   the early (host/qualifying) draws;
/// * a synthetic `drawSeedCycle(cycle, slot)` key holds the LIVE ranking
///   snapshotted when a finals draw is generated, so a cup's pots reflect
///   current form (e.g. the World Cup finals pots by the ranking after
///   qualifying) and the draw ceremony reproduces those pots exactly.
///
/// Cycle 0's start is never snapshotted — callers fall back to the static seed
/// ranking there.
abstract interface class SeedRankingRepository {
  /// The frozen positions (nationId → rank, 1 = top) for [cycle] of [careerId],
  /// or an empty map if that cycle was never snapshotted.
  Future<Map<int, int>> forCycle(int careerId, int cycle);

  /// Freezes [rankById] (nationId → rank) as the seeding ranking for [cycle].
  Future<void> snapshot(int careerId, int cycle, Map<int, int> rankById);
}
