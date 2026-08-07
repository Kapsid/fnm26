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
    final rows = await (_db.select(_db.tacticFamiliarities)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    return {
      for (final r in rows)
        r.formation: (
          familiarity: r.familiarity,
          predictability: r.predictability,
        ),
    };
  }

  @override
  Future<void> recordMatch(
    int careerId,
    Formation used, {
    int planKey = 0,
  }) async {
    final rows = await (_db.select(_db.tacticFamiliarities)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    final current = {for (final r in rows) r.formation: r};
    final was = current[used];
    // The same plan again only counts as such when there IS a previous plan —
    // a shape's first outing can't already have been scouted.
    final samePlan = was != null &&
        was.lastPlanKey != 0 &&
        was.lastPlanKey == planKey;

    final next = <Formation, ({double fam, double pred, int plan})>{
      // The fielded shape climbs; every other stored shape decays a little.
      used: (
        fam: TeamChemistry.bumpFamiliarity(was?.familiarity ?? 0, used: true),
        pred: TeamChemistry.bumpPredictability(
          was?.predictability ?? 0,
          used: true,
          samePlan: samePlan,
        ),
        plan: planKey,
      ),
      for (final r in rows)
        if (r.formation != used)
          r.formation: (
            fam: TeamChemistry.bumpFamiliarity(r.familiarity, used: false),
            pred: TeamChemistry.bumpPredictability(
              r.predictability,
              used: false,
              samePlan: false,
            ),
            plan: r.lastPlanKey,
          ),
    };
    await _db.transaction(() async {
      for (final e in next.entries) {
        await _db.into(_db.tacticFamiliarities).insertOnConflictUpdate(
              TacticFamiliaritiesCompanion.insert(
                careerId: careerId,
                formation: e.key,
                familiarity: Value(e.value.fam),
                predictability: Value(e.value.pred),
                lastPlanKey: Value(e.value.plan),
              ),
            );
      }
    });
  }

  @override
  Future<void> reset(int careerId) async {
    await (_db.delete(_db.tacticFamiliarities)
          ..where((t) => t.careerId.equals(careerId)))
        .go();
  }
}
