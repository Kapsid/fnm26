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
  /// Final tournaments carry far more weight than qualifiers, which outweigh
  /// the Nations Cup, which outweighs friendlies.
  ///
  /// These are sized against [seedFromRanking]'s spread of 4 points per world
  /// place. Weights that are too small round away entirely: at K=8 an expected
  /// qualifying win is `8 × 0.1 = 0.8` → 1 point → a quarter of a place, and an
  /// expected friendly win rounds to 0 and moves nothing at all. The table then
  /// looks frozen. These follow FIFA's own K-factors, so a win is worth a
  /// visible move and an upset is worth a real climb.
  static const double friendly = 5;
  static const double nationsCup = 15;
  static const double qualifier = 25;
  static const double finals = 50;

  /// Knockout round codes, ignoring any competition prefix ('CQF', 'NSF', …).
  static const List<String> _knockoutSuffixes = [
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  ];

  /// The round code of a friendly international.
  static const String friendlyRound = 'FRIENDLY';

  /// The importance weight for a fixture's [round].
  ///
  /// World Cup qualifiers carry no round code at all, so null means qualifier.
  /// The Nations Cup is checked before the knockout suffixes because its own
  /// rounds ('NSF', 'NFINAL') end with them but are not finals football.
  static double weightForRound(String? round) {
    if (round == null) return qualifier;
    if (round == friendlyRound) return friendly;
    if (round.startsWith('N')) return nationsCup;
    // Both finals group stages, the World Cup's and a continental cup's.
    if (round == 'GROUP' || round == 'CGROUP') return finals;
    if (_knockoutSuffixes.any(round.endsWith)) return finals;
    // Continental qualifying ('CQ') and anything else unaccounted for.
    return qualifier;
  }

  /// Starting points for a nation seeded from its static seed [ranking]
  /// position (1 = strongest). Keeps early tables looking sensible before any
  /// results have moved anyone.
  static int seedFromRanking(int ranking) =>
      (1900 - (ranking - 1) * 4).clamp(1000, 1900);

  /// World positions (1 = top) for every nation in [pointsById], ordered by
  /// points. Ties break by [seedRankById] (the static seed order) when given,
  /// else by nation id, so the ordering is always deterministic.
  static Map<int, int> positions(
    Map<int, int> pointsById, {
    Map<int, int>? seedRankById,
  }) {
    final ids = pointsById.keys.toList()
      ..sort((a, b) {
        final byPoints =
            (pointsById[b] ?? base).compareTo(pointsById[a] ?? base);
        if (byPoints != 0) return byPoints;
        return (seedRankById?[a] ?? a).compareTo(seedRankById?[b] ?? b);
      });
    return {for (var i = 0; i < ids.length; i++) ids[i]: i + 1};
  }

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
