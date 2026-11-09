import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/repositories/player_repository.dart';

/// A world manager's name, built from his country's name pool.
abstract final class ManagerNames {
  /// The pool a manager of nationality [code] is named from: his country's,
  /// or England's when his is missing or empty.
  static NamePoolLists poolFor(Map<String, NamePoolLists> pools, String code) {
    final own = pools[code.toUpperCase()];
    if (own != null && own.first.isNotEmpty && own.sur.isNotEmpty) return own;
    return pools['ENG'] ?? (first: const <String>[], sur: const <String>[]);
  }

  /// Somebody's first name and somebody else's surname from [pool], the way
  /// a staff coach is named (`StaffMarket`): culturally plausible, and
  /// belonging to nobody who exists. A double first name gives its first
  /// word; a surname is the pool's whole surname (`StaffMarket` takes the
  /// last word of a full name, which is the surname there).
  static String build(NamePoolLists pool, SeededRng rng) {
    if (pool.first.isEmpty || pool.sur.isEmpty) {
      throw StateError('A manager cannot be named from an empty pool');
    }
    final first = pool.first[rng.nextInt(pool.first.length)]
        .trim()
        .split(' ')
        .first;
    final last = pool.sur[rng.nextInt(pool.sur.length)].trim();
    return '$first $last';
  }
}
