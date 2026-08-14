import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// The rounded mean overall of a squad's strongest eleven.
///
/// The best eleven rather than the whole squad: a 26-man mean is dragged down
/// by the third-choice keeper, so two sides that would field identical teams
/// would show different numbers purely on squad depth.
int squadOverall(List<Player> squad) {
  if (squad.isEmpty) return 0;
  final rated = [for (final p in squad) p.overall]..sort((a, b) => b - a);
  final best = rated.take(11).toList();
  return (best.reduce((a, b) => a + b) / best.length).round();
}

/// Computes a single position-weighted "overall" rating from a player's
/// attributes.
///
/// Each [PositionCategory] weights the three qualities differently — a striker's
/// technique and pace matter far more than a centre back's, and vice versa for
/// aerial strength. This keeps one canonical definition of "overall" (DRY) that
/// the squad, tactics, and match-engine code can all rely on.
abstract final class OverallRating {
  /// Returns the position-weighted overall rating (`1..99`).
  static int forPosition(PlayerPosition position, PlayerAttributes a) {
    final w = _weightsByCategory[position.category]!;
    final weighted =
        a.physical * w.physical +
        a.technical * w.technical +
        a.stamina * w.stamina;
    return weighted.round().clamp(1, 99);
  }

  static const _weightsByCategory = <PositionCategory, _Weights>{
    // Keepers lean on technique (a shot-stopping proxy) with some physique.
    PositionCategory.goalkeeper: _Weights(
      technical: 0.60,
      physical: 0.30,
      stamina: 0.10,
    ),
    // Defenders balance physique and technique, with real endurance.
    PositionCategory.defender: _Weights(
      physical: 0.42,
      technical: 0.40,
      stamina: 0.18,
    ),
    // Midfielders run the game: technique first, then endurance.
    PositionCategory.midfielder: _Weights(
      technical: 0.48,
      stamina: 0.28,
      physical: 0.24,
    ),
    // Forwards are technique and pace, endurance least of all.
    PositionCategory.forward: _Weights(
      technical: 0.52,
      physical: 0.34,
      stamina: 0.14,
    ),
  };
}

/// Per-quality weights; unspecified qualities default to `0`.
class _Weights {
  const _Weights({
    this.physical = 0,
    this.technical = 0,
    this.stamina = 0,
  });

  final double physical;
  final double technical;
  final double stamina;
}
