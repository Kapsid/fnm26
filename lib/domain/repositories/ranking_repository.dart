/// Persists live world-ranking points per nation within a save.
///
/// Points are seeded lazily from the static seed ranking the first time a save
/// is read (see [pointsFor]); thereafter results move them via the Elo model.
abstract interface class RankingRepository {
  /// The current points for every nation in [careerId]. If the save has no
  /// stored points yet, [seed] (nationId → points) is written and returned.
  Future<Map<int, int>> pointsFor(int careerId, Map<int, int> seed);

  /// Writes [points] (nationId → points) for [careerId], replacing any current
  /// values for the nations present.
  Future<void> save(int careerId, Map<int, int> points);
}
