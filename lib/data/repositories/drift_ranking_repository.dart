import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/ranking_repository.dart';

/// Drift-backed [RankingRepository].
class DriftRankingRepository implements RankingRepository {
  DriftRankingRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Map<int, int>> pointsFor(int careerId, Map<int, int> seed) async {
    final rows = await (_db.select(_db.rankPoints)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    if (rows.isNotEmpty) {
      return {for (final r in rows) r.nationId: r.points};
    }
    await save(careerId, seed);
    return Map.of(seed);
  }

  @override
  Future<void> save(int careerId, Map<int, int> points) async {
    await _db.batch((b) {
      for (final entry in points.entries) {
        b.insert(
          _db.rankPoints,
          RankPointsCompanion.insert(
            careerId: careerId,
            nationId: entry.key,
            points: entry.value,
          ),
          onConflict: DoUpdate(
            (_) => RankPointsCompanion(points: Value(entry.value)),
          ),
        );
      }
    });
  }
}
