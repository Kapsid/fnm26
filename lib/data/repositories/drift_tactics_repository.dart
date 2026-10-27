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
    final row = await (_db.select(
      _db.tactics,
    )..where((t) => t.careerId.equals(careerId))).getSingleOrNull();
    if (row == null) return null;

    final slotRows =
        await (_db.select(_db.lineupSlots)
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
      fullBacks: await _fullBacks(careerId),
    );
  }

  /// The prefix of the cycle-0 `draws_watched` marks that hold the full-back
  /// arrows: `fullBack.left.up`, `fullBack.right.down` and so on.
  ///
  /// A marker rather than a column on `tactics`, so the arrows needed no
  /// schema change and travel in every backup and career bundle that carries
  /// the markers. Only a non-neutral arrow writes a mark: a save from before
  /// the arrows existed has none, and reads as neutral.
  static const String fullBackMarkPrefix = 'fullBack.';

  static String fullBackMark(FullBackSide side, FullBackPush push) =>
      '$fullBackMarkPrefix${side.name}.${push.name}';

  Future<FullBackPushes> _fullBacks(int careerId) async {
    final kinds =
        await (_db.selectOnly(_db.drawsWatched)
              ..addColumns([_db.drawsWatched.kind])
              ..where(
                _db.drawsWatched.careerId.equals(careerId) &
                    _db.drawsWatched.cycle.equals(0) &
                    _db.drawsWatched.kind.like('$fullBackMarkPrefix%'),
              ))
            .map((r) => r.read(_db.drawsWatched.kind))
            .get();
    FullBackPush read(FullBackSide side) {
      for (final push in [FullBackPush.up, FullBackPush.down]) {
        if (kinds.contains(fullBackMark(side, push))) return push;
      }
      return FullBackPush.neutral;
    }

    return FullBackPushes(
      left: read(FullBackSide.left),
      right: read(FullBackSide.right),
    );
  }

  @override
  Future<void> saveTactic(int careerId, Tactic tactic) async {
    final i = tactic.instructions;
    await _db.transaction(() async {
      await _db
          .into(_db.tactics)
          .insertOnConflictUpdate(
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
      await (_db.delete(
        _db.lineupSlots,
      )..where((t) => t.careerId.equals(careerId))).go();
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
      await (_db.delete(_db.drawsWatched)..where(
            (t) =>
                t.careerId.equals(careerId) &
                t.cycle.equals(0) &
                t.kind.like('$fullBackMarkPrefix%'),
          ))
          .go();
      for (final side in FullBackSide.values) {
        final push = tactic.fullBacks.of(side);
        if (push == FullBackPush.neutral) continue;
        await _db
            .into(_db.drawsWatched)
            .insertOnConflictUpdate(
              DrawsWatchedCompanion.insert(
                careerId: careerId,
                cycle: 0,
                kind: fullBackMark(side, push),
              ),
            );
      }
    });
  }
}
