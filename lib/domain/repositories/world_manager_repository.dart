import 'package:fnm/domain/entities/world_manager.dart';

abstract interface class WorldManagerRepository {
  Future<bool> hasManagers(int careerId);

  /// Every manager and spell of the career, in two queries.
  Future<ManagerWorld> load(int careerId);

  /// Writes [c] in one transaction; nothing is kept if any row fails.
  Future<void> apply(int careerId, ManagerChanges c);

  /// The spell in charge of [nationId] on [date], if any.
  Future<ManagerSpell?> inChargeOn(int careerId, int nationId, DateTime date);

  Future<List<ManagerSpell>> spellsOf(int careerId, int managerId);

  Future<List<ManagerTie>> ties(int careerId);

  /// Appends a tie numbered one past the career's highest.
  Future<void> addTie(
    int careerId, {
    required int managerId,
    required TieKind kind,
    required int delta,
    required DateTime date,
  });

  /// Spells opened or closed on or after [since].
  Future<List<ManagerSpell>> movesSince(int careerId, DateTime since);
}
