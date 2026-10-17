import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';

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

  /// How much one more match on the SAME plan adds to predictability: twenty
  /// in a row and opponents have it completely.
  static const double predictabilityStep = 0.05;

  /// The rolling per-match update to a formation's predictability, which is
  /// how sharply opponents read the manager's MOST RECENT plan.
  ///
  /// It measures one thing: how many consecutive matches that exact plan
  /// (shape and [planKey]) has been played. Fielding it again feeds the
  /// video, [predictabilityStep] a match. A change of plan resets it to 0,
  /// the weak, general read anybody gets (`AiCounter.read`), and a shape not
  /// fielded is not on anybody's video any more, so it reads 0 as well.
  ///
  /// Until 2026-10-17 a change only took 0.12 off, so a manager read at 1.0
  /// who changed plan met a counter to his NEW plan, seen once, at 0.91 of the
  /// sharpest read; and the read stayed on the most familiar shape, so after
  /// a change of formation the AI kept countering the abandoned one for about
  /// nine matches. "Varying your approach is a real way to stay hard to
  /// read" (spec, owner's answers) needs the reset.
  static double bumpPredictability(
    double current, {
    required bool used,
    required bool samePlan,
  }) {
    if (!used || !samePlan) return 0;
    return (current + predictabilityStep).clamp(0, 1);
  }

  /// The shape the manager fielded in his most recent recorded match, or
  /// null when no stored shape carries a plan.
  ///
  /// [afterMatch] keeps a plan key on that one row only, so normally exactly
  /// one row has one. Saves recorded before 2026-10-17 kept a key on every
  /// shape ever fielded; among several, the most predictable is the one most
  /// likely played last (an unused shape's figure decayed), then the most
  /// familiar, then the first in [Formation]. The next recorded match
  /// normalises the rows.
  static Formation? lastFielded(Map<Formation, ShapeDrilling> rows) {
    Formation? best;
    ShapeDrilling? bestRow;
    for (final f in Formation.values) {
      final r = rows[f];
      if (r == null || r.lastPlanKey == 0) continue;
      if (bestRow == null ||
          r.predictability > bestRow.predictability ||
          (r.predictability == bestRow.predictability &&
              r.familiarity > bestRow.familiarity)) {
        best = f;
        bestRow = r;
      }
    }
    return best;
  }

  /// The stored drilling after one more match fielded in [used] with the plan
  /// fingerprinted by [planKey] ([planKey] 0 records no plan).
  ///
  /// The fielded shape climbs in familiarity and every other stored shape
  /// decays ([bumpFamiliarity]). Predictability follows [bumpPredictability]:
  /// it climbs only when this is the same shape AND plan as the most recent
  /// match ([lastFielded]); a different plan in the same shape, or any other
  /// shape, starts again from 0. Only the fielded shape keeps its plan key,
  /// so the stored history always names the most recent plan: older plans
  /// are not what the opposition is preparing for.
  static Map<Formation, ShapeDrilling> afterMatch(
    Map<Formation, ShapeDrilling> rows,
    Formation used, {
    required int planKey,
  }) {
    final was = rows[used];
    // The same plan again only counts when it is the plan of the match just
    // before; a shape's first outing can't already have been scouted.
    final samePlan =
        planKey != 0 &&
        lastFielded(rows) == used &&
        was != null &&
        was.lastPlanKey == planKey;
    return {
      for (final e in rows.entries)
        if (e.key != used)
          e.key: (
            familiarity: bumpFamiliarity(e.value.familiarity, used: false),
            predictability: bumpPredictability(
              e.value.predictability,
              used: false,
              samePlan: false,
            ),
            lastPlanKey: 0,
          ),
      used: (
        familiarity: bumpFamiliarity(was?.familiarity ?? 0, used: true),
        predictability: bumpPredictability(
          was?.predictability ?? 0,
          used: true,
          samePlan: samePlan,
        ),
        lastPlanKey: planKey,
      ),
    };
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
  /// opponent's video room reconstructs from the manager's last outing (see
  /// `ScoutedPlan.fromDrilling`).
  ///
  /// Throws [ArgumentError] for 0 ("never fielded") or anything [planKey]
  /// could not have produced; [tryDecodePlanKey] returns null instead.
  static TacticalInstructions decodePlanKey(int key) {
    final plan = tryDecodePlanKey(key);
    if (plan == null) {
      throw ArgumentError.value(key, 'key', 'not a plan key');
    }
    return plan;
  }

  /// [decodePlanKey] for stored data: null for 0 or for a key [planKey] could
  /// not have produced, so one unreadable row reads as "no history" instead
  /// of breaking every match preview and advance that scouts it.
  static TacticalInstructions? tryDecodePlanKey(int key) {
    if (key <= 0) return null;
    final bands = List<int>.filled(6, 0);
    var rest = key;
    for (var i = 5; i >= 0; i--) {
      bands[i] = rest % 11;
      rest ~/= 11;
    }
    if (rest != 1) return null;
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
