import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// Computes a single position-weighted "overall" rating from a player's
/// attributes.
///
/// Each [PositionCategory] weights the ten attributes differently — a striker's
/// finishing matters far more than their tackling, and vice versa for a centre
/// back. This keeps one canonical definition of "overall" (DRY) that the squad,
/// tactics, and match-engine code can all rely on.
abstract final class OverallRating {
  /// Returns the position-weighted overall rating (`1..99`).
  static int forPosition(PlayerPosition position, PlayerAttributes a) {
    final w = _weightsByCategory[position.category]!;
    final weighted = a.passing * w.passing +
        a.shooting * w.shooting +
        a.dribbling * w.dribbling +
        a.tackling * w.tackling +
        a.positioning * w.positioning +
        a.composure * w.composure +
        a.decisions * w.decisions +
        a.pace * w.pace +
        a.stamina * w.stamina +
        a.strength * w.strength;
    return weighted.round().clamp(1, 99);
  }

  static const _weightsByCategory = <PositionCategory, _Weights>{
    PositionCategory.goalkeeper: _Weights(
      positioning: 0.25,
      composure: 0.20,
      decisions: 0.20,
      passing: 0.10,
      strength: 0.10,
      pace: 0.05,
      stamina: 0.05,
      tackling: 0.05,
    ),
    PositionCategory.defender: _Weights(
      tackling: 0.22,
      positioning: 0.18,
      strength: 0.15,
      pace: 0.12,
      decisions: 0.10,
      composure: 0.08,
      passing: 0.08,
      stamina: 0.05,
      dribbling: 0.02,
    ),
    PositionCategory.midfielder: _Weights(
      passing: 0.20,
      decisions: 0.15,
      dribbling: 0.12,
      stamina: 0.12,
      positioning: 0.10,
      composure: 0.10,
      tackling: 0.08,
      pace: 0.08,
      shooting: 0.03,
      strength: 0.02,
    ),
    PositionCategory.forward: _Weights(
      shooting: 0.25,
      pace: 0.18,
      dribbling: 0.15,
      composure: 0.12,
      positioning: 0.12,
      decisions: 0.06,
      passing: 0.05,
      stamina: 0.04,
      strength: 0.02,
      tackling: 0.01,
    ),
  };
}

/// Per-attribute weights; unspecified attributes default to `0`.
class _Weights {
  const _Weights({
    this.passing = 0,
    this.shooting = 0,
    this.dribbling = 0,
    this.tackling = 0,
    this.positioning = 0,
    this.composure = 0,
    this.decisions = 0,
    this.pace = 0,
    this.stamina = 0,
    this.strength = 0,
  });

  final double passing;
  final double shooting;
  final double dribbling;
  final double tackling;
  final double positioning;
  final double composure;
  final double decisions;
  final double pace;
  final double stamina;
  final double strength;
}
