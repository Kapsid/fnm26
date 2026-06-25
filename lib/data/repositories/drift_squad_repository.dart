import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/squad_repository.dart';

/// Drift-backed [SquadRepository].
class DriftSquadRepository implements SquadRepository {
  DriftSquadRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Set<int>> callUps(int careerId) async {
    final rows = await (_db.select(_db.callUps)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    return {for (final r in rows) r.playerId};
  }

  @override
  Future<void> setCallUps(int careerId, Set<int> playerIds) async {
    await _db.transaction(() async {
      await (_db.delete(_db.callUps)
            ..where((t) => t.careerId.equals(careerId)))
          .go();
      await _db.batch((b) {
        for (final id in playerIds) {
          b.insert(
            _db.callUps,
            CallUpsCompanion.insert(careerId: careerId, playerId: id),
          );
        }
      });
    });
  }
}
