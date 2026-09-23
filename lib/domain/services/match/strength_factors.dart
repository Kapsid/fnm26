import 'package:fnm/domain/services/club/club_form.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/squad/captaincy.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

/// One thing making the side stronger or weaker, in the manager's terms.
typedef StrengthFactor = ({
  StrengthFactorKind kind,

  /// Rating points, signed. Positive helps.
  int delta,

  /// The subject when there is one: a formation name, a player's name.
  String? subject,
});

/// The things that move a side's strength on the day, each of which the engine
/// already applies and none of which the manager was ever shown.
enum StrengthFactorKind { familiarity, fatigue, clubForm, morale, captain, staff }

/// What is making the side stronger or weaker today, read as rating points.
///
/// Fatigue, the shape the side has drilled, where the players stand at their
/// clubs, the dressing room, the armband and the staff room all already move
/// the numbers — and every one of them is invisible, which is why four separate
/// pieces of feedback said the dials do nothing. This is the ONE reading every
/// screen renders, so two screens can never quote different figures for the
/// same effect.
///
/// The rule this file lives by: NOTHING here invents a number. Every figure is
/// read from the seam that already applies it, and where that seam is not
/// expressed in rating points the conversion is written out in the comment
/// above it. A parallel model that disagreed with the engine would be worse
/// than showing nothing at all.
///
/// One thing is deliberately NOT here: predictability. `TeamChemistry`
/// documents it as hidden — it is what the opposition has worked out about the
/// side, not something the manager is told — so the familiarity line is
/// computed from familiarity ALONE (see [_familiarity]), which also means no
/// caller can recover predictability by subtracting this reading from the
/// chemistry the engine actually used.
abstract final class StrengthFactors {
  /// The rating a side is assumed to carry when the caller has no fielded XI to
  /// average. The same 70 `_teamRating` in the match preview falls back to for
  /// an empty XI — a multiplier only becomes points against SOME rating, and
  /// this is the one the app already uses when it does not know.
  static const int defaultSideRating = 70;

  /// Every factor currently acting on the side, biggest absolute first,
  /// dropping the ones that are doing nothing.
  ///
  /// [sideRating] is the fielded side's average overall, used to turn the
  /// chemistry MULTIPLIER into points. [captainMoraleBonus] is what the named
  /// captain is actually worth (`Captaincy.moraleBonus`); pass it when the
  /// captain is known, and see [_captain] for what is assumed when only
  /// [hasCaptain] is.
  static List<StrengthFactor> of({
    required double familiarity,
    required Map<int, PlayerCondition> conditionByPlayer,
    required int morale,
    required bool hasCaptain,
    required Map<StaffRole, StaffTier> staff,
    int sideRating = defaultSideRating,
    String? formationName,
    int? captainMoraleBonus,
  }) {
    final captain = _captain(
      morale: morale,
      hasCaptain: hasCaptain,
      moraleBonus: captainMoraleBonus,
    );
    final factors = <StrengthFactor>[
      (
        kind: StrengthFactorKind.familiarity,
        delta: _familiarity(familiarity, sideRating),
        subject: formationName,
      ),
      (
        kind: StrengthFactorKind.fatigue,
        delta: _fatigue(conditionByPlayer, morale),
        subject: null,
      ),
      (
        kind: StrengthFactorKind.clubForm,
        delta: _clubForm(conditionByPlayer),
        subject: null,
      ),
      // The armband's share is taken OUT of the morale line: the captain works
      // through morale (see `Captaincy`), so reporting both in full would count
      // the same points twice.
      (
        kind: StrengthFactorKind.morale,
        delta: Condition.moraleDelta(morale) - captain,
        subject: null,
      ),
      (kind: StrengthFactorKind.captain, delta: captain, subject: null),
      (kind: StrengthFactorKind.staff, delta: _staff(staff), subject: null),
    ];
    return [
      for (final f in factors)
        if (f.delta != 0) f,
    ]..sort((a, b) {
      final bySize = b.delta.abs().compareTo(a.delta.abs());
      // List.sort is not stable, so ties fall back to the declared order —
      // otherwise the same side could read in a different order twice running.
      return bySize != 0 ? bySize : a.kind.index.compareTo(b.kind.index);
    });
  }

  /// The drilled shape, in points.
  ///
  /// `TeamChemistry.factor` returns an attack/defence MULTIPLIER, which the
  /// engine applies to a side's attack and defence — both of which are weighted
  /// means of the fielded players' ratings (`MatchEngine._attack`). So the
  /// multiplier is worth `(factor - 1) x the side's rating` in points, which is
  /// exactly how it lands.
  ///
  /// Predictability is left at its default of zero ON PURPOSE. The engine
  /// passes the stored figure, and the side really is giving part of the
  /// drilled bonus back — but predictability is hidden by design, and a
  /// manager handed both this line and the engine's own chemistry could read it
  /// straight off the difference. So this is what the drilling is worth, not
  /// what survives the opposition's video room.
  static int _familiarity(double familiarity, int sideRating) =>
      ((TeamChemistry.factor(familiarity) - 1) * sideRating).round();

  /// Tired legs, in points.
  ///
  /// `PlayerCondition.overallDelta` is the shift the engine applies to that
  /// player's rating (`MatchTeam.conditionByPlayer`), and it is the sum of four
  /// things: his form, his legs, the dressing room and his club standing. Two
  /// of those are reported on their own lines, so this line is what is LEFT
  /// once the club standing and the squad-wide morale shift are taken out of
  /// each man's delta — his legs, his recent form and, in a tournament, the
  /// base camp. Named for the biggest of the three, which is also the one the
  /// manager asked about.
  ///
  /// Summed across the named squad, not averaged: each man's delta is applied
  /// to that man, so the total is the rating the squad as a whole is carrying.
  ///
  /// Approximate at the extremes only, where `Condition.of` clamps the combined
  /// delta to −9…+6 and the parts no longer add up to the whole.
  static int _fatigue(Map<int, PlayerCondition> byPlayer, int morale) {
    final moraleDelta = Condition.moraleDelta(morale);
    var total = 0;
    for (final c in byPlayer.values) {
      total += c.overallDelta - _clubDelta(c) - moraleDelta;
    }
    return total;
  }

  /// Where the squad stands at their clubs, in points.
  ///
  /// `ClubForm.sharpnessDelta` is already rating points — it is the `clubDelta`
  /// that `Condition.of` folds into each man's overall shift — so this is a
  /// straight sum over the named squad, on the same scale as [_fatigue].
  static int _clubForm(Map<int, PlayerCondition> byPlayer) {
    var total = 0;
    for (final c in byPlayer.values) {
      total += _clubDelta(c);
    }
    return total;
  }

  static int _clubDelta(PlayerCondition c) {
    final standing = c.clubStanding;
    return standing == null ? 0 : ClubForm.sharpnessDelta(standing);
  }

  /// What the armband is worth, in points.
  ///
  /// `Captaincy` routes the captain through MORALE rather than into ratings, and
  /// the morale handed to this function already has his lift in it. So his
  /// points are the difference the lift makes to `Condition.moraleDelta` — the
  /// same seam the morale line reads — and the morale line has this subtracted
  /// so neither is counted twice.
  ///
  /// When the caller knows only THAT a captain is named and not who he is, the
  /// lift is taken as `Captaincy.maxMoraleBonus`: the most the seam can
  /// produce, so this is an upper bound on a captaincy we were not told enough
  /// about to price. Pass `captainMoraleBonus` to price the actual man.
  static int _captain({
    required int morale,
    required bool hasCaptain,
    required int? moraleBonus,
  }) {
    if (!hasCaptain) return 0;
    final lift = (moraleBonus ?? Captaincy.maxMoraleBonus).clamp(
      0,
      Captaincy.maxMoraleBonus,
    );
    if (lift == 0) return 0;
    // A poor choice is never a penalty (see `Captaincy.moraleBonus`), so the
    // floor is zero even where the rounding in moraleDelta would go the other
    // way.
    final without = Condition.moraleDelta((morale - lift).clamp(0, 100));
    return (Condition.moraleDelta(morale) - without).clamp(
      0,
      Captaincy.maxMoraleBonus,
    );
  }

  /// What the staff room is worth on the day, in points.
  ///
  /// The fitness coach and the assistant's conditioning work are the only staff
  /// effects the match itself feels: the match preview multiplies the side's
  /// injury rate by exactly these two (`Staff.injuryFactor` x
  /// `Staff.assistantInjuryFactor`). The scout buys knowledge of a young
  /// player's ceiling and the assistant's drilling work buys familiarity over
  /// time — neither moves today's eleven, so neither is counted here.
  ///
  /// Injury rate is not points, so: the engine rolls one knock per team per
  /// minute at `MatchEngine.injuryPerMinute`, which over ninety minutes is the
  /// expected number of knocks at the base rate; the staff multiply that rate,
  /// so `(1 - factor)` of those knocks do not happen. Each one that does costs
  /// the side a man, which the engine prices at
  /// `MatchEngine.shortHandedAttackPenalty` for the rest of the match — and a
  /// knock arrives at a uniformly random minute, so half the match is left on
  /// average.
  ///
  /// That is an UPPER bound: a side with a substitution left replaces the man
  /// rather than playing on short. It is also, honestly, a small number — a
  /// full elite staff room is worth about a point. Better a true point than an
  /// invented five.
  static int _staff(Map<StaffRole, StaffTier> staff) {
    final factor =
        Staff.injuryFactor(staff[StaffRole.fitnessCoach] ?? StaffTier.none) *
        Staff.assistantInjuryFactor(staff[StaffRole.assistant] ?? StaffTier.none);
    final knocksAvoided = MatchEngine.injuryPerMinute * 90 * (1 - factor);
    return (knocksAvoided * MatchEngine.shortHandedAttackPenalty * 0.5).round();
  }
}
