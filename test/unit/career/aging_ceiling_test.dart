import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// The paywall names a year the manager can play to. That year is a promise,
/// and the thing that has to keep it is [CareerService.maxAgingYears]: past the
/// ceiling the pool stops aging, no intake arrives and nobody retires, so the
/// world is frozen even though the calendar runs on.
///
/// Nothing connects the two but this test. Lower the ceiling, or move the
/// start year, and the copy quietly starts promising a year the game reaches
/// as a museum.
void main() {
  /// The last year the pool is still alive.
  int ceilingYear() =>
      CareerService.cycleStart.year + CareerService.maxAgingYears;

  test('the world is still living in the year the paywall names', () {
    for (final copy in [
      AppLocalizationsEn().paywallBenefitEndless,
      AppLocalizationsCs().paywallBenefitEndless,
    ]) {
      final year = RegExp(r'\b(\d{4})\b').firstMatch(copy)?.group(1);
      expect(
        year,
        isNotNull,
        reason: 'the endless-cycles line names a year: "$copy"',
      );
      expect(
        int.parse(year!),
        lessThanOrEqualTo(ceilingYear()),
        reason:
            '"$copy" promises $year, but the pool freezes at '
            '${ceilingYear()}. Raise CareerService.maxAgingYears or lower '
            'the year in the copy.',
      );
    }
  });

  test('the ceiling is reached by aging, not by the calendar alone', () {
    // A save opened on day one is at zero, and the clamp only ever bites at
    // the far end — otherwise an ordinary career would be frozen from the off.
    expect(CareerService.maxAgingYears, greaterThan(100));
  });
}
