import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';

/// Drift-backed [SeedRankingRepository].
class DriftSeedRankingRepository implements SeedRankingRepository {
  DriftSeedRankingRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Map<int, int>> forCycle(int careerId, int cycle) async {
    final rows = await (_db.select(_db.seedRankings)
          ..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle)))
        .get();
    return {for (final r in rows) r.nationId: r.rank};
  }

  @override
  Future<void> snapshot(
    int careerId,
    int cycle,
    Map<int, int> rankById,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.seedRankings)
            ..where((t) => t.careerId.equals(careerId) & t.cycle.equals(cycle)))
          .go();
      await _db.batch((b) {
        for (final entry in rankById.entries) {
          b.insert(
            _db.seedRankings,
            SeedRankingsCompanion.insert(
              careerId: careerId,
              cycle: cycle,
              nationId: entry.key,
              rank: entry.value,
            ),
          );
        }
      });
    });
  }
}
