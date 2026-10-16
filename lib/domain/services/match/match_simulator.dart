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
  ///
  /// 0.21 points a place all the way down, plus [_eliteSlope] more a place
  /// through the top [_eliteBand]. Without the extra the whole top forty sat
  /// inside ten points, the eight seeds barely a point clear of the next
  /// twelve, and a World Championship was won by a top-eight seed only about
  /// two times in five. This is only the ANCHOR — a quarter of a background
  /// side's strength (see `SeasonService._squadStrength`); the fielded XI is
  /// the rest, so a golden generation still lifts a nation past its seeding.
  static int strengthOf(Nation nation) =>
      (92 -
              (nation.ranking - 1) * 0.21 -
              (min(nation.ranking, _eliteBand) - 1) * _eliteSlope)
          .round()
          .clamp(40, 92);

  /// The extra anchor points a seed place is worth inside the elite band.
  static const double _eliteSlope = 0.4;

  /// How many seeds the elite band covers.
  static const int _eliteBand = 20;

  /// How loudly a strength gap speaks: expected goals scale by
  /// `exp(gapResponse * gap)` (0.026 → 0.028 → 0.06). At 0.028 a top-six
  /// side beat a 34th-ranked one only 55% of the time at a neutral ground and
  /// lost one in five — the World Championship was a lottery.
  static const double gapResponse = 0.06;

  /// The gap stops compounding past roughly this many points (it runs through
  /// `tanh`). With the steeper response a 25-point qualifier would otherwise
  /// go off like a 40-point one; a minnow is still routed, but a mid-table
  /// mismatch reads like football.
  static const double _gapCeiling = 25;

  /// How much a gap lifts the TOTAL of goals as well as tilting it: both sides'
  /// xG are divided by `cosh(x)^_totalDamping`. At 0 a mismatch inflates the
  /// total (the favourite's gain outruns the underdog's loss), which at the
  /// new response pushed the world's average past three a game.
  static const double _totalDamping = 0.3;

  /// Expected goals between equals: the host slot and the visitors (the +5
  /// home advantage on top), and both sides at a neutral ground, where the old
  /// 1.30/1.15 split quietly handed the nominal home side a second advantage.
  static const double _homeBaseXg = 1.235;
  static const double _awayBaseXg = 1.0925;
  static const double _neutralBaseXg = (_homeBaseXg + _awayBaseXg) / 2;

  /// How a level BACKGROUND knockout's extra time and shootout lean: the weight
  /// to hand `WorldCupFinals.decideKnockout`, which splits both by the share
  /// of the pair. Raw ratings made that share 89/(89+81) = 0.52, a coin toss;
  /// `exp(0.1 * strength)` makes it a logistic of the gap (8 points ≈ 0.69),
  /// so the side that was better for ninety minutes stays better for thirty
  /// and edges the shootout, without making penalties a formality.
  /// The manager's live matches pass their own pair and never come through
  /// here.
  static double knockoutWeight(int strength) => exp(0.1 * strength);

  @override
  MatchOutcome simulate({
    required int homeStrength,
    required int awayStrength,
    required SeededRng rng,
    bool homeAdvantage = true,
    double openness = 1.0,
  }) {
    // +5 home advantage — but a neutral-venue finals gives neither side one.
    final diff = (homeStrength + (homeAdvantage ? 5 : 0)) - awayStrength;
    // Strength tells MULTIPLICATIVELY, not as a flat slope: a modest gap moves
    // the scoreline a little and a real gulf runs away, with the underdog's xG
    // tailing off toward zero rather than hitting a floor. Only the GAP counts,
    // never the absolute level — two 64s play the same game as two 84s.
    //
    // Recalibrated on whole careers (the real 48-team World Championship with
    // qualifying), not on a bare bracket: see world_variance_test and
    // match_balance_test for the bands this now holds. MatchEngine — the
    // manager's own matches — was deliberately left alone.
    final gap = _gapCeiling * _tanh(diff / _gapCeiling);
    final x = gapResponse * gap;
    final edge = exp(x);
    final total = pow((edge + 1 / edge) / 2, _totalDamping);
    final homeBase = homeAdvantage ? _homeBaseXg : _neutralBaseXg;
    final awayBase = homeAdvantage ? _awayBaseXg : _neutralBaseXg;
    // [openness] is how open the two PLANS make the game (see
    // `MatchEngine.openness`), and only the manager's own skipped match ever
    // passes one: his plan is the only one anybody set. Every background
    // fixture leaves it at 1.0, where multiplying by it changes nothing, so
    // the world's results do not move by a single goal.
    final homeXg = (homeBase * edge / total * openness).clamp(0.10, 5.5);
    final awayXg = (awayBase / edge / total * openness).clamp(0.10, 5.5);
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

  static double _tanh(double x) {
    // dart:math has no tanh.
    final e = exp(2 * x);
    return (e - 1) / (e + 1);
  }
}
