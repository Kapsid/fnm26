import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// The two controls the wall at the end of the free cycle puts on screen, in
/// both languages and on both of the phone widths that matter. Czech is the
/// longer language nearly everywhere, and "Pokračovat v kariéře" sits next to
/// an icon inside a fixed-height button.
void main() {
  Future<void> pumpControls(
    WidgetTester tester,
    Locale locale,
    double width,
  ) async {
    tester.view
      ..physicalSize = Size(width, 760)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                final l = AppLocalizations.of(context);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: l.hubContinueCareer,
                      icon: Icons.lock_open_rounded,
                      onPressed: () {},
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(l.hubBackToSaves),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final width in [360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the wall\'s controls fit at ${width.toInt()}px',
        (tester) async {
          await pumpControls(tester, locale, width);
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the end-of-trial rollover');
        },
      );
    }
  }
}
