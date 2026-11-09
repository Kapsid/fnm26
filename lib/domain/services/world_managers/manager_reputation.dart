import 'package:fnm/domain/entities/world_manager.dart';

/// A world manager's standing, 0 to 100. Derived from his spells and honours
/// every time it is needed, never stored.
abstract final class ManagerReputation {
  /// The rank a nation missing from the ranking is read at: worth nothing.
  static const int unranked = 211;

  /// `clamp(0, 100, 20 + Σ spells (years × (211 − rank) / 211 × 6)
  /// + honours × 8 + Σ briefNet × 4)`.
  ///
  /// A spell still open is counted up to [asOf]; without one, up to the
  /// latest date [w] knows of, so the answer never depends on the clock.
  static int of(
    int managerId,
    ManagerWorld w,
    Map<int, int> rankById,
    Map<int, int> honoursByManager, {
    DateTime? asOf,
  }) {
    final end = asOf ?? _latest(w);
    return score(
      [
        for (final s in w.spells)
          if (s.managerId == managerId) s,
      ],
      rankById,
      honoursByManager[managerId] ?? 0,
      end,
    );
  }

  /// [of] over [spells] already picked out for one manager.
  static int score(
    Iterable<ManagerSpell> spells,
    Map<int, int> rankById,
    int honours,
    DateTime asOf,
  ) {
    var r = 20.0 + honours * 8;
    for (final s in spells) {
      final to = s.toDate ?? asOf;
      final days = to.difference(s.fromDate).inDays;
      final years = days <= 0 ? 0.0 : days / 365.25;
      final rank = (rankById[s.nationId] ?? unranked).clamp(1, unranked);
      r += years * (unranked - rank) / unranked * 6;
      r += s.briefNet * 4;
    }
    return r.round().clamp(0, 100);
  }

  static DateTime _latest(ManagerWorld w) {
    var d = DateTime(1900);
    for (final s in w.spells) {
      if (s.fromDate.isAfter(d)) d = s.fromDate;
      final to = s.toDate;
      if (to != null && to.isAfter(d)) d = to;
    }
    return d;
  }
}
