import 'dart:math';

/// A FIFA-style Elo ranking model.
///
/// Each nation carries a points total; a match nudges the two sides toward or
/// away from each other based on the result versus what their ratings predicted
/// (an upset moves more points than an expected win). Bigger games carry more
/// weight. The exchange is zero-sum, so the world's total points are conserved.
abstract final class Elo {
  /// Base points for a nation with no history (mid-table).
  static const int base = 1300;

  /// Importance weight (the K-factor) for a match, by how much is at stake.
  static const double friendly = 8;
  static const double qualifier = 20;
  static const double finals = 35;

  /// Starting points for a nation seeded from its static seed [ranking]
  /// position (1 = strongest). Keeps early tables looking sensible before any
  /// results have moved anyone.
  static int seedFromRanking(int ranking) =>
      (1900 - (ranking - 1) * 4).clamp(1000, 1900);

  /// The change to the home side's points after a match; the away side moves by
  /// the negative of the same amount. [homeScore]/[awayScore] decide the result
  /// and [weight] is one of the importance constants above.
  static int homeDelta({
    required int homePoints,
    required int awayPoints,
    required int homeScore,
    required int awayScore,
    required double weight,
  }) {
    final expected = 1 / (1 + pow(10, (awayPoints - homePoints) / 400));
    final actual = homeScore > awayScore
        ? 1.0
        : homeScore == awayScore
            ? 0.5
            : 0.0;
    return (weight * (actual - expected)).round();
  }
}
