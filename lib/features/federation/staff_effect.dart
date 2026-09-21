import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What the people in the staff room actually do, in words.
///
/// The manager's complaint was that hiring somebody changed nothing he could
/// see. Reading the seams each role is wired into says why: the staff room is
/// nearly cosmetic, and only two of its three jobs reach anything at all.
///
///  * The FITNESS COACH multiplies the side's per-minute injury rate by
///    [Staff.injuryFactor] — `match_providers.dart` folds it into
///    `injuryFactorByNation` alongside the medical department's.
///  * The ASSISTANT does the same through [Staff.assistantInjuryFactor], and
///    adds [Staff.youthTalentBonus] to the nation's newgen intake in
///    `federation_providers.dart`.
///  * The SCOUT reaches nothing. [Staff.capsToKnow] — the number of caps
///    before a prospect's ceiling is known rather than estimated — is defined
///    and never called; `Prospects.capsToKnow` is a flat three whoever is in
///    the job. So is [Staff.familiarityGain], the assistant's drilling work.
///
/// This states that rather than dressing it up. A manager who can read that
/// the scout buys nothing can stop paying him, which is worth more than a
/// sentence implying otherwise. Making the staff room matter is its own piece
/// of work, and it starts from here.
///
/// One definition, shared by the read-only staff room on the manager's screen
/// and the hiring card on the budget screen, so the two can never quote
/// different numbers for the same hire. The pre-match strength panel prices
/// the same two injury factors in rating points through `StrengthFactors`;
/// these are the same multipliers in the unit they are applied in.
abstract final class StaffEffect {
  /// The best anybody in the job can be. [StaffMarket] always offers a slot at
  /// this tier, so it is the top of what a vacancy could be filled with.
  static const StaffTier best = StaffTier.elite;

  /// The cheapest real hire, which is the other end of that range.
  static const StaffTier cheapest = StaffTier.basic;

  /// The reduction [role] at [tier] makes to the side's injury rate, as a
  /// percentage off the base rate — the same unit the medical department's
  /// slider reads in, priced off the factor the match preview multiplies in.
  static int injuryReductionPct(StaffRole role, StaffTier tier) =>
      switch (role) {
        StaffRole.fitnessCoach => _pct(Staff.injuryFactor(tier)),
        StaffRole.assistant => _pct(Staff.assistantInjuryFactor(tier)),
        StaffRole.scout => 0,
      };

  static int _pct(double factor) => ((1 - factor) * 100).round();

  /// What the assistant's hours with the youngest players are worth on the
  /// newgen intake, in the approximate overall points the academy slider uses.
  static int youthOverall(StaffTier assistant) =>
      DepartmentEffect.overallFromTalentBonus(
        Staff.youthTalentBonus(assistant),
      );

  /// Whether [role] does anything at all at any tier. False for the scout, and
  /// the screen says so plainly rather than inventing a benefit.
  static bool hasEffect(StaffRole role) => role != StaffRole.scout;

  /// What the person currently in the job is doing, one short line per effect.
  ///
  /// Empty for a role wired to nothing, and the card says so rather than
  /// leaving a gap the manager would read as an oversight.
  static List<String> describe(
    AppLocalizations l,
    StaffRole role,
    StaffTier tier,
  ) => switch (role) {
    StaffRole.fitnessCoach => [
      l.staffEffectInjury(injuryReductionPct(role, tier)),
    ],
    StaffRole.assistant => [
      l.staffEffectInjury(injuryReductionPct(role, tier)),
      l.staffEffectYouth(youthOverall(tier)),
    ],
    StaffRole.scout => const [],
  };

  /// What filling the vacancy would be worth, across the range the market
  /// offers — from the cheapest applicant to the best one.
  static List<String> describeHiring(AppLocalizations l, StaffRole role) =>
      switch (role) {
        StaffRole.fitnessCoach => [
          l.staffHiringInjury(
            injuryReductionPct(role, cheapest),
            injuryReductionPct(role, best),
          ),
        ],
        StaffRole.assistant => [
          l.staffHiringInjury(
            injuryReductionPct(role, cheapest),
            injuryReductionPct(role, best),
          ),
          l.staffHiringYouth(youthOverall(cheapest), youthOverall(best)),
        ],
        StaffRole.scout => const [],
      };
}
