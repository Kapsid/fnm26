import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The buttons on the saves screen, in both languages, at the narrowest phone
/// the app supports. Czech is the longer language nearly everywhere, and it is
/// where "Pozice plné — pořiďte si Pro pro 10" ran out of its button.
void main() {
  Future<void> pumpButton(
    WidgetTester tester,
    Locale locale,
    String Function(AppLocalizations) label, {
    IconData? icon,
  }) async {
    tester.view
      ..physicalSize = const Size(320, 700)
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
              builder: (context) => PrimaryButton(
                label: label(AppLocalizations.of(context)),
                icon: icon,
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    group('${locale.languageCode} saves screen', () {
      testWidgets('the slots-full Pro prompt fits its button', (tester) async {
        await pumpButton(
          tester,
          locale,
          (l) => l.careerSlotsFullGoPro,
          icon: Icons.add,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('the new-game button fits', (tester) async {
        await pumpButton(tester, locale, (l) => l.careerNewGame, icon: Icons.add);
        expect(tester.takeException(), isNull);
      });

      testWidgets('the slots-full label fits', (tester) async {
        await pumpButton(
          tester,
          locale,
          (l) => l.careerSlotsFull,
          icon: Icons.add,
        );
        expect(tester.takeException(), isNull);
      });
    });
  }
}
