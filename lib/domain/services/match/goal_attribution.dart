import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// Attributes a match's goals to a squad's players for quick-simmed games (the
/// detailed engine names its own scorers). Picks are weighted by finishing
/// ability and position so strikers score most and keepers almost never.
abstract final class GoalAttribution {
  static double _weight(Player p) {
    // Kept in step with the live engine's scorer weighting (see
    // `MatchEngine._pickScorer`), so a quick-simmed match and a played one
    // spread their goals across the lines the same way.
    final mult = switch (p.position.category) {
      PositionCategory.forward => 4.8,
      PositionCategory.midfielder => 1.4,
      PositionCategory.defender => 0.30,
      PositionCategory.goalkeeper => 0.01,
    };
    return (p.attributes.technical + 5) * mult;
  }

  /// How much of a starter's scoring chance a substitute carries — they are on
  /// the pitch for roughly the last half-hour.
  static const double benchShare = 0.33;

  /// Returns one scorer player id per goal (length == [goals]).
  ///
  /// [benchIds] marks the members of [pool] who came off the bench, so a
  /// substitute can score without being as likely to as a man who played the
  /// whole ninety.
  static List<int> scorers({
    required List<Player> pool,
    required int goals,
    required SeededRng rng,
    Set<int> benchIds = const {},
  }) {
    if (goals <= 0 || pool.isEmpty) return [];
    final weights = [
      for (final p in pool)
        benchIds.contains(p.id) ? _weight(p) * benchShare : _weight(p),
    ];
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
