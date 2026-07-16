import 'package:fnm/domain/entities/enums.dart';

/// A player's all-time record for the legends ranking.
typedef LegendStat = ({
  int playerId,
  String name,
  PlayerPosition position,
  int caps,
  int goals,
  int assists,
  int motm,
  double avgRating,
});

/// A ranked legend: their record plus the computed legend score.
typedef RankedLegend = ({
  int playerId,
  String name,
  PlayerPosition position,
  int caps,
  int goals,
  int assists,
  int motm,
  double avgRating,
  double score,
});

/// Ranks a nation's players into an all-time hall of fame and picks an
/// all-time XI. The legend score rewards longevity (caps), decisiveness (goals,
/// assists, man-of-the-match awards) and sustained quality (average rating over
/// a real body of games) — so a one-cap wonder never outranks a servant of the
/// shirt. Pure, so the ranking is deterministic and testable.
abstract final class Legends {
  /// The all-time XI shape: a classic 4-3-3.
  static const Map<PositionCategory, int> xiShape = {
    PositionCategory.goalkeeper: 1,
    PositionCategory.defender: 4,
    PositionCategory.midfielder: 3,
    PositionCategory.forward: 3,
  };

  /// A player's legend score. Quality only counts once a player has a real body
  /// of caps behind them, so form-flash cameos don't inflate the table.
  static double score(LegendStat s) {
    final quality = ((s.avgRating - 6.5).clamp(0.0, 3.0)) * s.caps * 1.2;
    return s.caps + s.goals * 3 + s.assists * 1.5 + s.motm * 5 + quality;
  }

  /// [stats] ranked by legend score, highest first.
  static List<RankedLegend> rank(List<LegendStat> stats) {
    final ranked = [
      for (final s in stats)
        (
          playerId: s.playerId,
          name: s.name,
          position: s.position,
          caps: s.caps,
          goals: s.goals,
          assists: s.assists,
          motm: s.motm,
          avgRating: s.avgRating,
          score: score(s),
        ),
    ]..sort((a, b) => b.score.compareTo(a.score));
    return ranked;
  }

  /// The greatest XI: the top-scoring legends filling a 4-3-3, best per line.
  /// Falls back to leaving a slot empty only if a line has no candidates.
  static List<RankedLegend> allTimeXi(List<RankedLegend> ranked) {
    final xi = <RankedLegend>[];
    for (final entry in xiShape.entries) {
      final line = ranked
          .where((l) => l.position.category == entry.key)
          .take(entry.value);
      xi.addAll(line);
    }
    return xi;
  }
}
