import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What the people in the staff room actually do, in words.
///
/// The manager's complaint was that hiring somebody changed nothing he could
/// see. So every line here is read off the seam the role is wired into, and
/// every role now reaches one:
///
///  * The FITNESS COACH multiplies the side's per-minute injury rate by
///    [Staff.injuryFactor] — `match_providers.dart` folds it into
///    `injuryFactorByNation` alongside the medical department's.
///  * The ASSISTANT does the same through [Staff.assistantInjuryFactor], and
///    adds [Staff.youthTalentBonus] to the nation's newgen intake in
///    `federation_providers.dart`.
///  * The SCOUT does two things. His TALENT READ: `Prospects.scoutedStars`
///    reads [Staff.exactReadShare] of unproven prospects exactly and never
///    misses by more than a star, and `Prospects.capsToKnowWith` settles the
///    read into the truth after [Staff.capsToKnow] caps instead of three. His
///    OPPONENT DOSSIER: [Staff.dossierBonus] rating points on the manager's
///    side in every match, through `MatchTeam.ratingBonus` when he plays it
///    and `SeasonService._withManagerTactics` when he skips it.
///
/// One definition, shared by the read-only staff room on the manager's screen
/// and the hiring card on the budget screen, so the two can never quote
/// different numbers for the same hire. The pre-match strength panel prices
/// the same two injury factors in rating points through `StrengthFactors`,
/// and shows the dossier as its own line; these are the same figures in the
/// unit they are applied in.
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

  /// The share of unproven prospects [scout] reads exactly, as a percentage.
  ///
  /// [Staff.exactReadShare] are read dead right by the scout's own judgement;
  /// the rest get a guess within a star either way, which lands on the truth a
  /// third of the time. Together: half, seven in ten and nine in ten. (A guess
  /// clamped at one or five stars lands a little more often, so this is the
  /// floor of what the manager sees, never an overstatement.)
  static int readSpotOnPct(StaffTier scout) {
    final share = Staff.exactReadShare(scout);
    return ((share + (1 - share) / 3) * 100).round();
  }

  /// Caps before a prospect's ceiling is known, with [scout] in the job.
  static int capsToKnow(StaffTier scout) => Prospects.capsToKnowWith(scout);

  /// How many caps sooner than with nobody in the job.
  static int capsSooner(StaffTier scout) =>
      Prospects.capsToKnow - capsToKnow(scout);

  static int _pct(double factor) => ((1 - factor) * 100).round();

  /// What the assistant's hours with the youngest players are worth on the
  /// newgen intake, in the approximate overall points the academy slider uses.
  static int youthOverall(StaffTier assistant) =>
      DepartmentEffect.overallFromTalentBonus(
        Staff.youthTalentBonus(assistant),
      );

  /// Whether [role] does anything at all at any tier. True for all three now
  /// that the scout reads prospects and opponents; kept so a role wired to
  /// nothing in future is told so plainly rather than handed a benefit.
  static bool hasEffect(StaffRole role) => switch (role) {
    StaffRole.fitnessCoach || StaffRole.assistant || StaffRole.scout => true,
  };

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
    // Nobody in the job describes nothing: the card shows the hiring range.
    StaffRole.scout when tier == StaffTier.none => const [],
    StaffRole.scout => [
      l.staffEffectScoutRead(readSpotOnPct(tier)),
      l.staffEffectScoutCaps(capsToKnow(tier)),
      l.staffEffectScoutDossier(Staff.dossierBonus(tier)),
    ],
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
        StaffRole.scout => [
          l.staffHiringScoutRead(
            readSpotOnPct(cheapest),
            readSpotOnPct(best),
          ),
          l.staffHiringScoutCaps(capsSooner(cheapest), capsSooner(best)),
          l.staffHiringScoutDossier(
            Staff.dossierBonus(cheapest),
            Staff.dossierBonus(best),
          ),
        ],
      };
}
