import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/repositories/absence_repository.dart';

/// Drift-backed [AbsenceRepository].
class DriftAbsenceRepository implements AbsenceRepository {
  DriftAbsenceRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Map<int, PlayerAbsence>> forCareer(int careerId) async {
    final rows = await (_db.select(_db.playerAbsences)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    return {
      for (final r in rows)
        r.playerId: PlayerAbsence(
          playerId: r.playerId,
          yellows: r.yellows,
          banMatches: r.banMatches,
          injuryMatches: r.injuryMatches,
        ),
    };
  }

  @override
  Future<void> replace(int careerId, Iterable<PlayerAbsence> absences) async {
    await _db.transaction(() async {
      await (_db.delete(_db.playerAbsences)
            ..where((t) => t.careerId.equals(careerId)))
          .go();
      await _db.batch((b) {
        for (final a in absences) {
          if (!a.isNotable) continue;
          b.insert(
            _db.playerAbsences,
            PlayerAbsencesCompanion.insert(
              careerId: careerId,
              playerId: a.playerId,
              yellows: Value(a.yellows),
              banMatches: Value(a.banMatches),
              injuryMatches: Value(a.injuryMatches),
            ),
          );
        }
      });
    });
  }
}
