import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/tactics_repository.dart';

/// Drift-backed [TacticsRepository].
class DriftTacticsRepository implements TacticsRepository {
  DriftTacticsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Tactic?> tacticForCareer(int careerId) async {
    final row = await (_db.select(_db.tactics)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (row == null) return null;

    final slotRows = await (_db.select(_db.lineupSlots)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm(expression: t.slot)]))
        .get();
    final lineup = List<int?>.filled(11, null);
    for (final s in slotRows) {
      if (s.slot >= 0 && s.slot < 11) lineup[s.slot] = s.playerId;
    }

    final instructions = TacticalInstructions(
      mentality: row.mentality,
      pressing: row.pressing,
      tempo: row.tempo,
      width: row.width,
      defensiveLine: row.defensiveLine,
      directness: row.directness,
    );
    return Tactic(
      formation: row.formation,
      lineup: lineup,
      // A tactic that has never had a style named still HAS one if its dials
      // happen to describe a known way of playing — a fresh save's balanced
      // defaults being the obvious case. Naming it is honest, and stops the
      // screen opening on "Custom" before the manager has touched anything.
      playstyle: row.playstyle == Playstyle.custom
          ? PlaystyleX.matching(instructions)
          : row.playstyle,
      instructions: instructions,
    );
  }

  @override
  Future<void> saveTactic(int careerId, Tactic tactic) async {
    final i = tactic.instructions;
    await _db.transaction(() async {
      await _db.into(_db.tactics).insertOnConflictUpdate(
            TacticsCompanion.insert(
              careerId: Value(careerId),
              formation: tactic.formation,
              playstyle: Value(tactic.playstyle),
              mentality: Value(i.mentality),
              pressing: Value(i.pressing),
              tempo: Value(i.tempo),
              width: Value(i.width),
              defensiveLine: Value(i.defensiveLine),
              directness: Value(i.directness),
            ),
          );
      await (_db.delete(_db.lineupSlots)
            ..where((t) => t.careerId.equals(careerId)))
          .go();
      await _db.batch((b) {
        for (var slot = 0; slot < tactic.lineup.length; slot++) {
          b.insert(
            _db.lineupSlots,
            LineupSlotsCompanion.insert(
              careerId: careerId,
              slot: slot,
              playerId: Value(tactic.lineup[slot]),
            ),
          );
        }
      });
    });
  }
}
