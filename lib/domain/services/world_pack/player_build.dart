import 'dart:math' as math;

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

/// The shape of a player's three qualities, as the database editor offers it.
enum PlayerType {
  balanced(1, 1, 1),
  athlete(1.15, 0.9, 1),
  technician(0.9, 1.15, 0.95),
  engine(0.95, 0.95, 1.15);

  const PlayerType(this.physical, this.technical, this.stamina);

  final double physical;
  final double technical;
  final double stamina;
}

/// Turns an Overall number and a [PlayerType] into the game's three stored
/// qualities, and back.
abstract final class PlayerBuild {
  static int _q(double v) => v.round().clamp(1, 99);

  static PlayerAttributes _scaled(PlayerType t, double s) => PlayerAttributes(
    physical: _q(t.physical * s),
    technical: _q(t.technical * s),
    stamina: _q(t.stamina * s),
  );

  /// Qualities in the ratio of [type] whose position-weighted overall is
  /// [overall] (within 1; exact where the 1..99 clamp allows).
  static PlayerAttributes attributesFor(
    PlayerPosition pos,
    PlayerType type,
    int overall,
  ) {
    final target = overall.clamp(1, 99);
    int rate(PlayerAttributes a) => OverallRating.forPosition(pos, a);

    // The overall is monotone in the scale: find the smallest scale that
    // reaches the target.
    var lo = 0.0;
    var hi = 400.0;
    for (var i = 0; i < 60; i++) {
      final mid = (lo + hi) / 2;
      if (rate(_scaled(type, mid)) >= target) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    var best = _scaled(type, hi);
    // Rounding may overshoot; take whichever neighbour is closest.
    final under = _scaled(type, lo);
    if ((rate(under) - target).abs() < (rate(best) - target).abs()) {
      best = under;
    }

    // Clamping at 99 can leave the overall short: lift the qualities that are
    // not yet capped, strongest effect first.
    var guard = 0;
    while (rate(best) < target && guard++ < 300) {
      PlayerAttributes? pick;
      var pickGain = 0;
      for (final c in [
        best.copyWith(physical: best.physical + 1),
        best.copyWith(technical: best.technical + 1),
        best.copyWith(stamina: best.stamina + 1),
      ]) {
        if (c.physical > 99 || c.technical > 99 || c.stamina > 99) continue;
        final gain = rate(c) - rate(best);
        if (gain > pickGain) {
          pick = c;
          pickGain = gain;
        }
      }
      // A single step may round to no gain; step the heaviest open quality.
      pick ??=
          [
                best.copyWith(physical: best.physical + 1),
                best.copyWith(technical: best.technical + 1),
                best.copyWith(stamina: best.stamina + 1),
              ]
              .where(
                (c) => c.physical <= 99 && c.technical <= 99 && c.stamina <= 99,
              )
              .firstOrNull;
      if (pick == null) break;
      best = pick;
    }
    return best;
  }

  /// The type whose ratio is nearest [a] by cosine similarity.
  static PlayerType typeOf(PlayerAttributes a) {
    double cos(PlayerType t) {
      final dot =
          a.physical * t.physical +
          a.technical * t.technical +
          a.stamina * t.stamina;
      final na = math.sqrt(
        a.physical * a.physical +
            a.technical * a.technical +
            a.stamina * a.stamina,
      );
      final nt = math.sqrt(
        t.physical * t.physical +
            t.technical * t.technical +
            t.stamina * t.stamina,
      );
      return dot / (na * nt);
    }

    return PlayerType.values.reduce((x, y) => cos(y) > cos(x) ? y : x);
  }
}
