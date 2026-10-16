import 'package:fnm/domain/entities/tactics.dart';

/// Tactical familiarity → a whole-team match multiplier. A side that plays the
/// same shape week after week grows drilled and cohesive; a manager who keeps
/// chopping and changing (or who has just taken a new nation) starts from
/// neutral. Pure and deterministic — the stored `familiarity` (0..1) is the only
/// input, mutated after each match by [bumpFamiliarity].
///
/// Familiarity does not act alone. Naming the same eleven in the same shape with
/// the same instructions for four years is not just drilling: it is a plan
/// every scout in the world has on video, so a second stored figure,
/// [bumpPredictability], tracks how well opponents have read the side.
/// Predictability is deliberately HIDDEN (it is what the opposition knows, not
/// what the manager is told) and is charged in ONE place: `AiCounter`, where it
/// sharpens the opponent's counter to his recent plans. It used to take part of
/// the drilled bonus back here as well, which charged the same thing twice.
abstract final class TeamChemistry {
  /// The most a perfectly drilled shape adds.
  ///
  /// 0.07 → 0.08. At 0.07 a perfectly drilled side was already worth about a
  /// third of a goal a game, so the ceiling barely moves. Being read no longer
  /// takes part of it back here (see the class doc): a settled side keeps all
  /// of it, and pays for its predictability through the sharper counter it
  /// meets instead.
  static const double drilledBonus = 0.08;

  /// The attack/defence multiplier for a side whose current formation sits at
  /// [familiarity] (0..1): neutral (1.0) for an unfamiliar/new side, up to
  /// 1.08 for a long-settled shape.
  ///
  /// [predictability] is IGNORED. It is kept only so existing call sites
  /// compile; predictability is charged once, in `AiCounter`, which reads it
  /// from the stored history.
  static double factor(double familiarity, [double predictability = 0]) =>
      1 + familiarity.clamp(0, 1) * drilledBonus;

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

  /// The inverse of [planKey]: the plan behind a stored fingerprint, each
  /// dial at the centre of its band (a multiple of ten). It is what an
  /// opponent's video room reconstructs from the manager's last outing in a
  /// shape (see `ScoutedPlan.fromDrilling`).
  ///
  /// Throws [ArgumentError] for 0 ("never fielded") or anything [planKey]
  /// could not have produced.
  static TacticalInstructions decodePlanKey(int key) {
    if (key == 0) {
      throw ArgumentError.value(key, 'key', '0 means no stored plan');
    }
    final bands = List<int>.filled(6, 0);
    var rest = key;
    for (var i = 5; i >= 0; i--) {
      bands[i] = rest % 11;
      rest ~/= 11;
    }
    if (rest != 1) {
      throw ArgumentError.value(key, 'key', 'not a plan key');
    }
    return TacticalInstructions(
      mentality: bands[0] * 10,
      pressing: bands[1] * 10,
      tempo: bands[2] * 10,
      width: bands[3] * 10,
      defensiveLine: bands[4] * 10,
      directness: bands[5] * 10,
    );
  }
}
