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
  }) {
    final diff = (homeStrength + 5) - awayStrength; // +5 home advantage
    final homeXg = (1.3 + diff * 0.03).clamp(0.2, 4.5);
    final awayXg = (1.1 - diff * 0.03).clamp(0.2, 4.5);
    return MatchOutcome(_goals(homeXg, rng), _goals(awayXg, rng));
  }

  int _goals(double expected, SeededRng rng) {
    var goals = 0;
    // Sample ~Poisson by summing independent chances across 8 segments.
    for (var i = 0; i < 8; i++) {
      if (rng.chance(expected / 8)) goals++;
    }
    return goals;
  }
}
