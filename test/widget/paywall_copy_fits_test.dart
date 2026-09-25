import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/features/paywall/paywall_parts.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The pitch on the upgrade page, at phone widths, in both languages.
///
/// These lines got longer on purpose: they used to name what the purchase
/// unlocks and now make the case for it, which is a sentence rather than a
/// label. A benefit row wraps, so expectNothingCut cannot fail on it; what
/// must not happen is a single word too long for the column.
void main() {
  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final width in [320.0, 360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the benefits fit at ${width.toInt()}px',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.theme,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.marginMobile),
                    child: PaywallBenefits(),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expectNoBrokenWord(
            find.byType(Text),
            'a benefit line in ${locale.languageCode} at ${width.toInt()}px',
          );
        },
      );
    }

    testWidgets('${locale.languageCode}: the pitch says more than a label', (
      tester,
    ) async {
      final l = await AppLocalizations.delegate.load(locale);
      // Each line has to carry an argument, not a feature name. A bare
      // "Endless cycles" is what this replaced.
      for (final line in [
        l.paywallBenefitEndless,
        l.paywallBenefitSaves,
        l.paywallBenefitCarryOn,
        l.paywallBenefitOffline,
        l.gateLead,
      ]) {
        expect(
          line.split(' ').length,
          greaterThan(6),
          reason: '"$line" reads as a label rather than a reason',
        );
        expect(line, isNot(contains('—')), reason: 'no em dashes in copy');
      }
    });
  }
}
