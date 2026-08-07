import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What a department's spend actually buys, in words.
///
/// The federation's five departments each have a real effect on the save —
/// better prospects, fewer injuries, more money, a foreign player asking to
/// switch allegiance, a more patient board — but that was only ever legible on
/// the finances screen's impact table, one screen removed from the sliders
/// where the decision is made. A manager dragging a slider could see the euros
/// leave and nothing about what they bought.
///
/// One definition, used by the slider and the impact table, so the two can
/// never quote different numbers for the same money.
abstract final class DepartmentEffect {
  /// The academy bonus expressed as approximate overall points (~+12 at full
  /// investment), which is a far more tangible read than a talent multiplier.
  static int youthOverall(int euros) =>
      (FederationFinance.youthTalentBonus(euros) / 0.18 * 12).round();

  /// The injury-rate reduction as a percentage off the base rate.
  static int injuryReductionPct(int euros) =>
      ((1 - FederationFinance.injuryFactor(euros)) * 100).round();

  /// The chance a foreign player offers to naturalise this cycle, as a
  /// percentage.
  static int naturalisationPct(int euros) =>
      (FederationFinance.naturalizationChance(euros) * 100).round();

  /// A one-line description of what [euros] in [dept] buys this cycle.
  static String describe(
    AppLocalizations l,
    Department dept,
    int euros,
  ) => switch (dept) {
    Department.youth => l.deptEffectYouth(youthOverall(euros)),
    Department.commercial => l.deptEffectCommercial(
      _euros(FederationFinance.commercialReturn(euros)),
    ),
    Department.medical => l.deptEffectMedical(injuryReductionPct(euros)),
    Department.naturalization => l.deptEffectNaturalisation(
      naturalisationPct(euros),
    ),
    Department.boardRelations => l.deptEffectBoard(
      FederationFinance.boardTolerance(euros),
    ),
  };

  /// Compact euros, matching the finance UI's format.
  static String _euros(int euros) {
    if (euros >= 1000000) {
      final m = euros / 1000000;
      return '€${m.toStringAsFixed(m == m.roundToDouble() ? 0 : 1)}M';
    }
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }
}
