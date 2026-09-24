import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The home/away marker on a call-up window's fixture line.
///
/// It used to be "v " and "@ ", a convention from American score lines that a
/// tester could not read and that was never translated: in Czech "v" is a
/// preposition, so the away marker said something wrong rather than nothing.
/// It is a word now, which is longer, and the slot it sits in is fixed width,
/// so the word is what has to be checked.
void main() {
  Future<void> pumpMarker(
    WidgetTester tester,
    Locale locale,
    double width,
    bool home,
  ) async {
    tester.view
      ..physicalSize = Size(width, 700)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final l = AppLocalizations.of(context);
              return Row(
                children: [
                  SizedBox(
                    width: 58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('30. lis'),
                        Text(
                          home ? l.callUpHome : l.callUpAway,
                          maxLines: 1,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: Text('Bosnia and Herzegovina')),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final home in [true, false]) {
      final which = home ? 'home' : 'away';
      testWidgets('${locale.languageCode}: the $which marker fits at 320px', (
        tester,
      ) async {
        await pumpMarker(tester, locale, 320, home);
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });
    }

    testWidgets('${locale.languageCode}: the markers are words, not symbols', (
      tester,
    ) async {
      final l = await AppLocalizations.delegate.load(locale);
      for (final s in [l.callUpHome, l.callUpAway]) {
        expect(
          s.length,
          greaterThan(2),
          reason: '"$s" is a symbol again, which is what this replaced',
        );
        expect(s, isNot(anyOf('v', '@')));
      }
    });
  }
}
