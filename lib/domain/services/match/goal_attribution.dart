import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// Attributes a match's goals to a squad's players for quick-simmed games (the
/// detailed engine names its own scorers). Picks are weighted by finishing
/// ability and position so strikers score most and keepers almost never.
abstract final class GoalAttribution {
  static double _weight(Player p) {
    final mult = switch (p.position.category) {
      PositionCategory.forward => 4.2,
      PositionCategory.midfielder => 1.5,
      PositionCategory.defender => 0.35,
      PositionCategory.goalkeeper => 0.02,
    };
    return (p.attributes.shooting + 5) * mult;
  }

  /// Returns one scorer player id per goal (length == [goals]).
  static List<int> scorers({
    required List<Player> pool,
    required int goals,
    required SeededRng rng,
  }) {
    if (goals <= 0 || pool.isEmpty) return [];
    final weights = [for (final p in pool) _weight(p)];
    final total = weights.fold<double>(0, (s, w) => s + w);
    final result = <int>[];
    for (var g = 0; g < goals; g++) {
      var r = rng.nextDouble() * total;
      var picked = pool.last.id;
      for (var i = 0; i < pool.length; i++) {
        r -= weights[i];
        if (r <= 0) {
          picked = pool[i].id;
          break;
        }
      }
      result.add(picked);
    }
    return result;
  }
}
