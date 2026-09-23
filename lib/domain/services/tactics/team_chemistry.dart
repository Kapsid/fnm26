import 'package:fnm/domain/entities/tactics.dart';

/// Tactical familiarity → a whole-team match multiplier. A side that plays the
/// same shape week after week grows drilled and cohesive; a manager who keeps
/// chopping and changing (or who has just taken a new nation) starts from
/// neutral. Pure and deterministic — the stored `familiarity` (0..1) is the only
/// input, mutated after each match by [bumpFamiliarity].
///
/// Familiarity does not act alone. Naming the same eleven in the same shape with
/// the same instructions for four years is not just drilling — it is a plan
/// every scout in the world has on video, so a second stored figure,
/// [bumpPredictability], tracks how well opponents have read the side and takes
/// part of the drilled bonus back. Predictability is deliberately HIDDEN: it is
/// what the opposition knows, not what the manager is told.
abstract final class TeamChemistry {
  /// The most a perfectly drilled shape adds.
  ///
  /// 0.07 → 0.08. The ceiling deliberately barely moves: at 0.07 a perfectly
  /// drilled, unread side was ALREADY worth about a third of a goal a game,
  /// which is plenty. The problem was that almost nobody plays at the ceiling —
  /// a manager who names the same shape for years also gets read, and against
  /// the old 0.04 [readPenalty] that left a settled side a net 0.03, one goal
  /// every seven games, which is below what a human being can detect across a
  /// career. So the change here is mostly in the RATIO below, not in this
  /// number.
  static const double drilledBonus = 0.08;

  /// The most a completely read side gives back. Smaller than [drilledBonus],
  /// so continuity is still worth having — it just stops being free.
  ///
  /// Held at 0.04 while [drilledBonus] rose, which is the point of the pair:
  /// the RATIO moves from 4/7 to 1/2, so the video room now takes half of the
  /// drilling rather than four sevenths of it. A settled, thoroughly scouted
  /// side nets 0.04 instead of 0.03 — a third again as much — while the ceiling
  /// for a manager who keeps his shape but varies his plan moves only 0.07 →
  /// 0.08. The dial grew where it was invisible, not where it was already loud.
  static const double readPenalty = 0.04;

  /// The attack/defence multiplier for a side whose current formation sits at
  /// [familiarity] (0..1) and has been read to [predictability] (0..1).
  ///
  /// Neutral (1.0) for an unfamiliar/new side, up to ~1.08 for a long-settled
  /// shape nobody has worked out, settling around ~1.04 for a manager who has
  /// named the same team and the same plan for years.
  static double factor(double familiarity, [double predictability = 0]) =>
      1 +
      familiarity.clamp(0, 1) * drilledBonus -
      predictability.clamp(0, 1) * readPenalty;

  /// The rolling per-match update to a formation's familiarity: the shape the
  /// manager actually fielded climbs; every other stored shape decays a little,
  /// so switching systems costs the drilling built up in the old one.
  static double bumpFamiliarity(double current, {required bool used}) =>
      (used ? current + 0.08 : current - 0.03).clamp(0, 1);

  /// The rolling per-match update to a formation's predictability.
  ///
  /// Fielding it again with the SAME plan feeds the video: opponents learn a
  /// little more every time. Fielding it with a genuinely different plan — or
  /// not fielding it at all — makes what they had learned stale, and it fades
  /// faster than it built, so a manager is always one change of approach away
  /// from being hard to prepare for again.
  static double bumpPredictability(
    double current, {
    required bool used,
    required bool samePlan,
  }) {
    if (!used) return (current - 0.07).clamp(0, 1);
    return (samePlan ? current + 0.05 : current - 0.12).clamp(0, 1);
  }

  /// A fingerprint of the plan behind a tactic, used to tell "the same again"
  /// from a real change. Coarse on purpose (each dial in bands of ten): nudging
  /// the tempo by a point is not a new plan, and shouldn't buy a manager a
  /// clean slate.
  ///
  /// Never 0 — that value means "never fielded" in storage.
  static int planKey(TacticalInstructions i) {
    int band(int v) => (v.clamp(0, 100) / 10).round();
    var key = 1;
    for (final v in [
      i.mentality,
      i.pressing,
      i.tempo,
      i.width,
      i.defensiveLine,
      i.directness,
    ]) {
      key = key * 11 + band(v);
    }
    return key;
  }
}
