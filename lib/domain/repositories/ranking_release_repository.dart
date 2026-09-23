/// One published world-ranking release.
typedef RankingRelease = ({
  DateTime publishedOn,

  /// The cycle and the nation the manager held at publication — movement is
  /// measured against that cycle's starting positions, the same baseline the
  /// ranking screen's arrows use, and never across a change of nation.
  int cycle,
  int nationId,
  int playerRank,
  int leaderNationId,
});

/// Persists the world ranking's periodic releases within a save.
///
/// The live points move with every result, but the ranking is only *published*
/// now and then (see the season service). Consecutive releases are what let the
/// manager be told how far they climbed since the last one.
abstract interface class RankingReleaseRepository {
  /// Every release for [careerId], oldest first.
  Future<List<RankingRelease>> all(int careerId);

  /// The most recent release for [careerId], or null if none has been
  /// published yet.
  Future<RankingRelease?> latest(int careerId);

  /// Records a release. Publishing twice for the same date overwrites, so a
  /// re-simulated day can't file a duplicate.
  Future<void> add({
    required int careerId,
    required DateTime publishedOn,
    required int cycle,
    required int nationId,
    required int playerRank,
    required int leaderNationId,
  });
}
