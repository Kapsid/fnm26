import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/ranking_release_repository.dart';

/// Drift-backed [RankingReleaseRepository].
class DriftRankingReleaseRepository implements RankingReleaseRepository {
  DriftRankingReleaseRepository(this._db);

  final AppDatabase _db;

  RankingRelease _toDomain(RankingReleaseRow r) => (
        publishedOn: r.publishedOn,
        cycle: r.cycle,
        nationId: r.nationId,
        playerRank: r.playerRank,
        leaderNationId: r.leaderNationId,
      );

  @override
  Future<List<RankingRelease>> all(int careerId) async {
    final rows = await (_db.select(_db.rankingReleases)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm(expression: t.publishedOn)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<RankingRelease?> latest(int careerId) async {
    final row = await (_db.select(_db.rankingReleases)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.publishedOn,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> add({
    required int careerId,
    required DateTime publishedOn,
    required int cycle,
    required int nationId,
    required int playerRank,
    required int leaderNationId,
  }) async {
    await _db.into(_db.rankingReleases).insert(
          RankingReleasesCompanion.insert(
            careerId: careerId,
            publishedOn: publishedOn,
            cycle: Value(cycle),
            nationId: Value(nationId),
            playerRank: playerRank,
            leaderNationId: leaderNationId,
          ),
          // Re-simulating a day must not file the same release twice.
          onConflict: DoUpdate(
            (_) => RankingReleasesCompanion(
              cycle: Value(cycle),
              nationId: Value(nationId),
              playerRank: Value(playerRank),
              leaderNationId: Value(leaderNationId),
            ),
          ),
        );
  }
}
