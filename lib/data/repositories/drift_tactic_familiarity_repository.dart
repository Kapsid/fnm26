import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

class DriftTacticFamiliarityRepository implements TacticFamiliarityRepository {
  DriftTacticFamiliarityRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Map<Formation, ShapeDrilling>> forCareer(int careerId) async {
    final rows = await (_db.select(
      _db.tacticFamiliarities,
    )..where((t) => t.careerId.equals(careerId))).get();
    return {
      for (final r in rows)
        r.formation: (
          familiarity: r.familiarity,
          predictability: r.predictability,
          lastPlanKey: r.lastPlanKey,
        ),
    };
  }

  @override
  Future<void> recordMatch(
    int careerId,
    Formation used, {
    int planKey = 0,
  }) async {
    final next = TeamChemistry.afterMatch(
      await forCareer(careerId),
      used,
      planKey: planKey,
    );
    await _db.transaction(() async {
      for (final e in next.entries) {
        await _db
            .into(_db.tacticFamiliarities)
            .insertOnConflictUpdate(
              TacticFamiliaritiesCompanion.insert(
                careerId: careerId,
                formation: e.key,
                familiarity: Value(e.value.familiarity),
                predictability: Value(e.value.predictability),
                lastPlanKey: Value(e.value.lastPlanKey),
              ),
            );
      }
    });
  }

  @override
  Future<void> reset(int careerId) async {
    await (_db.delete(
      _db.tacticFamiliarities,
    )..where((t) => t.careerId.equals(careerId))).go();
  }
}
