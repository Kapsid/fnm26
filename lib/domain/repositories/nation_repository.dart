import 'package:fnm/domain/entities/nation.dart';

/// Read access to the national-team reference data.
///
/// Which list to read: a caller with a career in scope uses [forCareer],
/// whether it enumerates or only looks up. A caller with no career that only
/// looks up uses [everyKnown]. A caller with no career that enumerates (the
/// new-game pickers) uses [all]. For a normal career [forCareer] is exactly
/// [all], so following the rule never changes a normal career.
abstract interface class NationRepository {
  /// The BASE world: every nation except the dormant ones (see
  /// `DormantNations`), ordered by ranking (strongest first).
  Future<List<Nation>> all();

  /// Only nations available in the free demo (never a dormant one).
  Future<List<Nation>> freeDemo();

  /// The nation with [id], or `null` if none exists. Finds a dormant nation
  /// too.
  Future<Nation?> byId(int id);

  /// Every stored row, dormant ones included, ordered by ranking. A
  /// DICTIONARY for lookups that are not tied to one career (the saves list).
  /// Never enumerate it as a world.
  Future<List<Nation>> everyKnown();

  /// The world of [careerId]: [all], or, for a career carrying
  /// `DormantNations.markerFor(d)`, [all] minus `DormantNations.replaces[d]`
  /// plus `d`, re-sorted by ranking. A nation that lodged a host bid in the
  /// career carries it in `Nation.hostBids`. A career begun before the
  /// stored starting ranking last moved has a cycle-0 seed ranking of its
  /// own, and its world carries those positions as `Nation.ranking` (see
  /// `SeedLoader`), so it keeps the ranking it started on. For a normal
  /// career it is exactly [all].
  Future<List<Nation>> forCareer(int careerId);
}
