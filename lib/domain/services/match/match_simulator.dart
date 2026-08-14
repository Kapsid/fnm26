import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/nation.dart';

/// The result of a simulated match.
class MatchOutcome {
  const MatchOutcome(this.homeScore, this.awayScore);

  final int homeScore;
  final int awayScore;
}

/// Simulates a match between two teams. The real tactical engine (M6) will
/// provide a richer implementation behind this same seam.
// ignore: one_member_abstracts
abstract interface class MatchSimulator {
  MatchOutcome simulate({
    required int homeStrength,
    required int awayStrength,
    required SeededRng rng,
  });
}

/// Lightweight deterministic placeholder: derives expected goals from the
/// strength gap (plus home advantage) and samples a scoreline. Used until the
/// tactical engine lands.
class RatingMatchSimulator implements MatchSimulator {
  const RatingMatchSimulator();

  /// A nation's overall strength on a ~40–92 scale, derived from its ranking.
  static int strengthOf(Nation nation) =>
      (92 - (nation.ranking - 1) * 0.21).round().clamp(40, 92);

  @override
  MatchOutcome simulate({
    required int homeStrength,
    required int awayStrength,
    required SeededRng rng,
    bool homeAdvantage = true,
  }) {
    // +5 home advantage — but a neutral-venue finals gives neither side one.
    final diff = (homeStrength + (homeAdvantage ? 5 : 0)) - awayStrength;
    // Strength tells MULTIPLICATIVELY, not as a flat slope. The old linear
    // +0.05 goals per point meant every point of the gap was worth as much
    // between two good sides as between a superpower and a minnow: ten points
    // (a Brazil against an Ecuador) already swung a full goal each way and read
    // like a mismatch. Scaling instead means a modest gap barely moves the
    // scoreline while a real gulf still runs away — and the underdog's xG tails
    // off toward zero rather than hitting a floor.
    final edge = exp(0.026 * diff);
    final homeXg = (1.30 * edge).clamp(0.10, 5.5);
    final awayXg = (1.15 / edge).clamp(0.10, 5.5);
    return _scoreline(homeXg, awayXg, rng);
  }

  /// Samples both scorelines together — segment by segment, in step — so a side
  /// that has pulled well clear can ease off for the rest of the match. Sampled
  /// apart, the two are memoryless and a hot seed runs away to seven.
  MatchOutcome _scoreline(double homeXg, double awayXg, SeededRng rng) {
    var home = 0;
    var away = 0;
    // ~Poisson by summing independent chances across 8 segments.
    for (var i = 0; i < 8; i++) {
      if (rng.chance(homeXg / 8 * _blowoutDamping(home, away))) home++;
      if (rng.chance(awayXg / 8 * _blowoutDamping(away, home))) away++;
    }
    return MatchOutcome(home, away);
  }

  /// Once a side is well clear it stops chasing goals — substitutions, a
  /// dropped tempo, and an opponent packing the box. The live engine damps its
  /// scoring the same way; the two are always tuned together.
  double _blowoutDamping(int scored, int conceded) {
    final margin = scored - conceded;
    if (margin < 3) return 1.0;
    return 1.0 / (1.0 + (margin - 2) * 0.6);
  }
}
