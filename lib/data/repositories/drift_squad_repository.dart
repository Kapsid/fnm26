import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/repositories/squad_repository.dart';

/// Drift-backed [SquadRepository].
class DriftSquadRepository implements SquadRepository {
  DriftSquadRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Set<int>> callUps(int careerId) async {
    final rows = await (_db.select(
      _db.callUps,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {for (final r in rows) r.playerId};
  }

  @override
  Future<void> clearCallUps(int careerId) async {
    await (_db.delete(
      _db.callUps,
    )..where((t) => t.careerId.equals(careerId))).go();
    // Drafts belong to the squad they were naming; a new nation's pool shares
    // no ids with the old one, so keeping them would restore ghosts.
    await (_db.delete(
      _db.callUpDrafts,
    )..where((t) => t.careerId.equals(careerId))).go();
  }

  @override
  Future<Set<int>> callUpDraft(int careerId, String draftKey) async {
    final rows =
        await (_db.select(_db.callUpDrafts)..where(
              (t) => t.careerId.equals(careerId) & t.draftKey.equals(draftKey),
            ))
            .get();
    return {for (final r in rows) r.playerId};
  }

  @override
  Future<void> saveCallUpDraft(
    int careerId,
    String draftKey,
    Set<int> playerIds,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.callUpDrafts)..where(
            (t) => t.careerId.equals(careerId) & t.draftKey.equals(draftKey),
          ))
          .go();
      await _db.batch((b) {
        for (final id in playerIds) {
          b.insert(
            _db.callUpDrafts,
            CallUpDraftsCompanion.insert(
              careerId: careerId,
              draftKey: draftKey,
              playerId: id,
            ),
          );
        }
      });
    });
  }

  @override
  Future<void> clearCallUpDraft(int careerId, String draftKey) async {
    await (_db.delete(_db.callUpDrafts)..where(
          (t) => t.careerId.equals(careerId) & t.draftKey.equals(draftKey),
        ))
        .go();
  }

  @override
  Future<void> setCallUps(int careerId, Set<int> playerIds) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.callUps,
      )..where((t) => t.careerId.equals(careerId))).go();
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
