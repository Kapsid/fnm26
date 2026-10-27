import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

/// A little extra difficulty for the manager's side when it is a MID-TIER
/// nation, and nobody else.
///
/// Why it exists. A mid-tier nation (roughly world ranks 25 to 90, best
/// elevens averaging about 64 to 82) found results came a little too easily:
/// measured in `test/unit/match/mid_tier_difficulty_test.dart`, a mid side
/// the manager runs takes more points off an equal or a stronger opponent
/// than the same nation does when the AI plays it. No single advantage
/// explains it (it is the sum of a flatter live engine near level, the
/// drilled shape and the scout's dossier, none of which the AI side ever
/// gets), and trimming any one of them would also move elite and minnow
/// sides, which feel right. So this is a smooth term instead: zero at both
/// ends of the world, full in the middle.
///
/// What it touches:
///  * the manager's own matches only, played ([engineFactor], applied on the
///    chemistry seam in `match_providers`) and skipped ([skipPoints], applied
///    in `SeasonService._withManagerTactics`); the AI-v-AI world never reads
///    it;
///  * nothing stored: it is worked out per match from the eleven he fields;
///  * nothing shown: it is not a strength factor and has no copy.
///
/// The input is the mean overall of the eleven he fields (the displayed
/// overall, before condition), so a mid nation with a golden generation
/// grows out of it and one in decline grows into it.
abstract final class MidTierDifficulty {
  /// The size of the term at full strength, as a deficit on the side's
  /// attack and defence in the live engine (the chemistry seam: a fully
  /// drilled shape is worth +0.08 on the same scale, `TeamChemistry`).
  ///
  /// Tuned 2026-10-26 in the lab (`test/helpers/difficulty_lab.dart`): at
  /// 0.025 a mid side (fielding 68 or 74) loses 0.08 to 0.09 expected points
  /// a match to an equal or a six-points-stronger opponent when played and
  /// 0.06 to 0.10 when skipped, and 0.06 to 0.08 to a six-points-weaker one.
  /// Points move about linearly with it near there.
  static const double peak = 0.025;

  /// Below this fielded rating the term is zero (minnows, already hard).
  static const double minnowEdge = 60;

  /// From here the term is at full strength (about world rank 85).
  static const double bandLow = 66;

  /// Up to here the term is at full strength (about world rank 35).
  static const double bandHigh = 78;

  /// From this fielded rating up the term is zero (the elite, about the top
  /// fifteen).
  static const double eliteEdge = 84;

  /// Rating points a skipped match takes off per unit of [engineFactor]
  /// deficit. Measured, not borrowed: the skip path credits chemistry at 30
  /// points a unit, but the skipped side's strength is rounded to a whole
  /// point, and at 30 that rounding swallowed part of a sub-point term (a
  /// mid side lost only 0.03 to 0.04 points a match to a stronger opponent
  /// skipped, against 0.09 played). At 35 the two paths land within about
  /// 0.02 points of each other in every cell of the lab.
  static const double skipPointsPerUnit = 35;

  /// How much of the term applies to a side fielding [rating]: 0 outside
  /// ([minnowEdge], [eliteEdge]), 1 inside [[bandLow], [bandHigh]], and a
  /// smoothstep ramp between, so no rating point is a cliff.
  static double weight(double rating) {
    if (rating <= minnowEdge || rating >= eliteEdge) return 0;
    if (rating < bandLow) {
      return _smooth((rating - minnowEdge) / (bandLow - minnowEdge));
    }
    if (rating > bandHigh) {
      return _smooth((eliteEdge - rating) / (eliteEdge - bandHigh));
    }
    return 1;
  }

  /// The multiplier the live engine applies to the manager's side (on top of
  /// its chemistry): 1.0 for elite and minnow sides.
  static double engineFactor(double rating) => 1 - peak * weight(rating);

  /// The same term for a skipped match, in rating points (zero or negative).
  static double skipPoints(double rating) =>
      -peak * weight(rating) * skipPointsPerUnit;

  /// THE PLAYED SEAM: the chemistry map the live engine is handed for the
  /// manager's match (`match_providers`). His drilled shape
  /// ([TeamChemistry.factor] of [familiarity]) times [engineFactor] of the
  /// eleven he fields. Only [managerNationId] is a key: the opponent is not
  /// in it, so the engine plays it at a neutral 1.0 and it never feels the
  /// term.
  static Map<int, double> chemistryByNation({
    required int managerNationId,
    required double familiarity,
    required double fieldedRating,
  }) => {
    managerNationId:
        TeamChemistry.factor(familiarity) * engineFactor(fieldedRating),
  };

  /// The salt on the career seed for [skippedStrength]'s dither stream (see
  /// [ditherRng]), so it never shares draws with the scoreline.
  static const int ditherSalt = 0x0D1F;

  /// The stream [skippedStrength] dithers on for fixture [fixtureId] of the
  /// career seeded [rngSeed]: the fixture's own stream off a salted career
  /// seed. Salting the seed rather than the fixture id matters: a salted id
  /// is a small number, the id of some other fixture in the same career
  /// whose scoreline would then share this stream.
  static SeededRng ditherRng(int rngSeed, int fixtureId) =>
      SeededRng.forFixture(rngSeed ^ ditherSalt, fixtureId);

  /// THE SKIPPED SEAM: the strength the rating simulator is handed for the
  /// manager's side in a match he skipped
  /// (`SeasonService._withManagerTactics`).
  ///
  /// [lift] is his side's strength with everything else already applied
  /// (plan, dossier, chemistry), rounded to a whole point as it always was.
  /// The term ([skipPoints], under a point) is then added DITHERED: a whole
  /// point taken off with a chance equal to its size, drawn from [rng]. A
  /// plain round turned it into a 0-or-1 step per match, a cliff on the
  /// ramp; dithered, each match's expected lift is exactly the term, and a
  /// fixture's stream keeps the result the same every time it is played.
  ///
  /// A side with no term (elite, minnow) draws nothing and comes out exactly
  /// as `lift.round()`, as before the term existed.
  static int skippedStrength({
    required double lift,
    required double fieldedRating,
    required SeededRng rng,
  }) {
    final whole = lift.round();
    final term = skipPoints(fieldedRating);
    if (term == 0) return whole;
    final floor = term.floor();
    final frac = term - floor;
    return whole + floor + (rng.nextDouble() < frac ? 1 : 0);
  }

  static double _smooth(double t) => t * t * (3 - 2 * t);
}
