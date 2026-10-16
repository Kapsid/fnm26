import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/shape_profile.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

/// What an opponent's video room has on the manager: the shape he has drilled
/// most, the plan he last fielded it with, and how predictable he has been in
/// it (0..1, the stored `predictability`).
///
/// A class rather than a record typedef so it can carry [fromDrilling]: Dart
/// has no static members on a typedef.
class ScoutedPlan {
  const ScoutedPlan({
    required this.formation,
    required this.instructions,
    required this.predictability,
  });

  final Formation formation;
  final TacticalInstructions instructions;
  final double predictability;

  /// The plan an opponent would prepare for, read from the stored history.
  ///
  /// The shape with the highest familiarity whose `lastPlanKey` is set (0
  /// means "never fielded with a recorded plan", so it has nothing to decode);
  /// a tie keeps the shape listed first in [Formation]. Null when no stored
  /// shape carries a plan, which is a manager with no history yet.
  ///
  /// This reads RECENT matches only, never the tactic set for the match about
  /// to be played: a decoy plan for today is not what the opposition has on
  /// video.
  static ScoutedPlan? fromDrilling(Map<Formation, ShapeDrilling> rows) {
    Formation? best;
    ShapeDrilling? bestRow;
    for (final f in Formation.values) {
      final r = rows[f];
      if (r == null || r.lastPlanKey == 0) continue;
      if (bestRow == null || r.familiarity > bestRow.familiarity) {
        best = f;
        bestRow = r;
      }
    }
    if (best == null || bestRow == null) return null;
    return ScoutedPlan(
      formation: best,
      instructions: TeamChemistry.decodePlanKey(bestRow.lastPlanKey),
      predictability: bestRow.predictability.clamp(0, 1),
    );
  }
}

/// The AI opponent's counter to the manager's recent plans.
///
/// `AiTactics.forOpponent` picks a posture from the strength gap and the
/// nation's style; this then bends it towards whatever beats what the manager
/// has been doing. How far it bends is the READ: sharper for a better
/// opponent (a stronger federation has better scouts and players who can
/// carry out a plan) and sharper for a predictable manager (the stored
/// `predictability` is charged here now, not in `TeamChemistry.factor`).
///
/// Most of the counter lives in the sliders. Sometimes, when the manager's
/// shape is lopsided enough to be worth answering with a different shape, the
/// AI changes formation too, more readily for a pragmatic side than for one
/// with a rigid identity ([AiTactics.flexibility]).
abstract final class AiCounter {
  /// How far a fully read counter pushes a slider per point the scouted dial
  /// sits away from 50 (or from the exposed edge of the middle, see
  /// [apply]). Tuned 0.5 -> 0.8 on 2026-10-16: at 0.5 being read cost a
  /// predictable manager almost nothing outside the press, so varying the plan
  /// was no reason at all. At 0.8 a side that reads him completely answers a
  /// line at 80 with 36 more points of directness (45 points past the exposed
  /// edge at 35), and a fully predictable plan does clearly worse against a
  /// countering side than an unread one (`tactics_lab_test.dart`).
  static const double counterGain = 0.8;

  /// The scouted mentality from which an opponent reads "all-out attack" and
  /// answers by sitting deeper and less ambitiously.
  static const int attackingMentality = 70;

  /// How far off the 4-3-3 reading (`ShapeProfile`) the scouted shape must be,
  /// in attackers or defenders, before a change of formation is on the table.
  static const double shapeTrigger = 1;

  /// The seed for the counter of one fixture. The live match
  /// (`match_providers`) and the skip path (`hub_providers`) must agree on
  /// it, so a skipped match is countered exactly as the played one would be:
  /// the string is
  /// `'aicounter:<opponentId>:<fixtureId>:<career rngSeed>'`.
  static int fixtureSeed({
    required int opponentId,
    required int fixtureId,
    required int rngSeed,
  }) => varietySeed('aicounter:$opponentId:$fixtureId:$rngSeed');

  /// The read, 0..1: `(0.25 + 0.75 * predictability) * quality`, with
  /// quality `((opponentStrength - 60) / 30)` clamped to 0.3..1. Even an
  /// unpredictable manager is read a little (a quarter); even a weak side
  /// reads something (0.3 of it).
  static double read({
    required double predictability,
    required double opponentStrength,
  }) {
    final quality = ((opponentStrength - 60) / 30).clamp(0.3, 1.0);
    return (0.25 + 0.75 * predictability.clamp(0, 1)) * quality;
  }

  /// Bends [base] towards the counter to [scouted]. [scouted] null (no
  /// history yet) returns [base] unchanged. Deterministic in [seed].
  static AiSetup apply({
    required AiSetup base,
    required ScoutedPlan? scouted,
    required double opponentStrength,
    required NationStyle style,
    required int seed,
  }) {
    if (scouted == null) return base;
    final r = read(
      predictability: scouted.predictability,
      opponentStrength: opponentStrength,
    );
    final s = scouted.instructions;
    final b = base.instructions;

    // Each rule is a SHIFT the fully read counter would make, proportional to
    // how far the manager's dial sits from neutral; the AI then makes [r] of
    // it. Two rules that point the same dial the same way take the larger,
    // not the sum: the high line and the high press are one reason to go
    // long, not two.
    //
    // The line, the press and the build-up are read the way the engine reads
    // them ([MatchEngine.kNeutralExposure]): the middle is still exposed, so
    // the shift is measured from the exposed edge (35 or 65), not from 50. A
    // neutral plan therefore still draws a small answer, which is what "no
    // safe middle" means for the counter. The two answers that only a
    // COMMITTED plan invites (patience against a deep block, a deeper line
    // against a direct side) read from 50.
    const edge = MatchEngine.kNeutralExposure * 50;
    double above(int v) => (v - 50 + edge).clamp(0, 50).toDouble();
    double below(int v) => (50 - v + edge).clamp(0, 50).toDouble();
    double committedAbove(int v) => (v - 50).clamp(0, 50).toDouble();
    double committedBelow(int v) => (50 - v).clamp(0, 50).toDouble();

    // A high line or a high press leaves space in behind: go direct. A deep
    // line smothers the long ball, so against one keep it on the ground and
    // be patient (the engine's patience term).
    final directness =
        [
          above(s.defensiveLine),
          above(s.pressing),
        ].reduce((a, c) => a > c ? a : c) -
        committedBelow(s.defensiveLine);
    // A patient, short-passing side is pressed in its own build-up.
    final pressing = below(s.directness);
    // Width is answered with the opposite: crowd the middle against a wide
    // side, stretch a narrow one.
    final width = -(s.width - 50).toDouble();
    // All-out attack is met by sitting deeper and waiting for the gaps.
    final allOut = s.mentality >= attackingMentality
        ? (s.mentality - 50).toDouble()
        : 0.0;
    // A direct side is met with a deeper line: no space behind to run into
    // (the engine's smother). Shares the line with the answer above.
    final dropLine = [
      allOut,
      committedAbove(s.directness),
    ].reduce((a, c) => a > c ? a : c);

    int move(int v, double shift) =>
        (v + shift * counterGain * r).round().clamp(8, 92);

    final instructions = b.copyWith(
      directness: move(b.directness, directness),
      pressing: move(b.pressing, pressing),
      width: move(b.width, width),
      mentality: move(b.mentality, -allOut),
      defensiveLine: move(b.defensiveLine, -dropLine),
    );

    return (
      formation: _counterShape(
        base: base.formation,
        scouted: scouted.formation,
        read: r,
        style: style,
        seed: seed,
      ),
      instructions: instructions,
    );
  }

  /// The opponent's setup for one fixture: [base] (from
  /// `AiTactics.forOpponent`) countered against the plan scouted from the
  /// stored [drilling] rows.
  ///
  /// Deliberately has no parameter for the manager's CURRENT tactic: the
  /// counter reads what he has fielded, never what he has set for today, so
  /// a decoy plan can't game it. Shared by the live match and the skip path.
  static AiSetup forFixture({
    required AiSetup base,
    required Map<Formation, ShapeDrilling> drilling,
    required double opponentStrength,
    required NationStyle style,
    required int seed,
  }) => apply(
    base: base,
    scouted: ScoutedPlan.fromDrilling(drilling),
    opponentStrength: opponentStrength,
    style: style,
    seed: seed,
  );

  /// The formation to field: [base] unless the scouted shape is lopsided by
  /// at least [shapeTrigger] and a roll at `read * flexibility(style)` comes
  /// up. Many men forward is met with a back five; many men back is met with
  /// more men up front.
  static Formation _counterShape({
    required Formation base,
    required Formation scouted,
    required double read,
    required NationStyle style,
    required int seed,
  }) {
    final p = ShapeProfile.ofFormation(scouted);
    final manyAttackers =
        p.attackers - ShapeProfile.neutralAttackers >= shapeTrigger;
    final manyDefenders =
        p.defenders - ShapeProfile.neutralDefenders >= shapeTrigger;
    if (!manyAttackers && !manyDefenders) return base;
    final chance = read * AiTactics.flexibility(style);
    if (SeededRng(seed).nextDouble() >= chance) return base;
    if (manyAttackers) {
      // Sides that sit deep by nature drop into the deeper back five.
      return switch (style) {
        NationStyle.defensive ||
        NationStyle.counter ||
        NationStyle.physical => Formation.f541,
        _ => Formation.f532,
      };
    }
    // Sides that go for the throat push a fourth man up; the rest add width.
    return switch (style) {
      NationStyle.direct ||
      NationStyle.flair ||
      NationStyle.highPress => Formation.f424,
      _ => Formation.f433,
    };
  }
}
