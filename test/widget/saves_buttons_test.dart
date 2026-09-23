import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// The buttons on the saves screen, in both languages, at the narrowest phone
/// the app supports. Czech is the longer language nearly everywhere, and this
/// is where its labels run out of their buttons.
void main() {
  Future<void> pumpButton(
    WidgetTester tester,
    Locale locale,
    String Function(AppLocalizations) label, {
    IconData? icon,
    double width = 320,
  }) async {
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

  Future<void> pumpText(
    WidgetTester tester,
    Locale locale,
    double width,
    String Function(AppLocalizations) text,
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) => Text(
                text(AppLocalizations.of(context)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpTextButton(
    WidgetTester tester,
    Locale locale,
    double width,
    String Function(AppLocalizations) label,
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) => TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock_open_rounded, size: 18),
                label: Text(label(AppLocalizations.of(context))),
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
      testWidgets('the new-game button fits', (tester) async {
        await pumpButton(
          tester,
          locale,
          (l) => l.careerNewGame,
          icon: Icons.add,
        );
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });

      testWidgets('the slots-full label fits', (tester) async {
        await pumpButton(
          tester,
          locale,
          (l) => l.careerSlotsFull,
          icon: Icons.add,
        );
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });

      // What a FREE manager sees once his two saves are taken: the button
      // becomes the door to the purchase, and a line underneath promises the
      // saves he already has are not going anywhere.
      for (final width in [360.0, 400.0]) {
        testWidgets(
          'the unlock-more label fits at ${width.toInt()}px',
          (tester) async {
            await pumpButton(
              tester,
              locale,
              (l) => l.careerSlotsUnlockMore,
              icon: Icons.lock_open,
              width: width,
            );
            expect(tester.takeException(), isNull);
            expectNothingCut(tester);
          },
        );

        // The door to the shop, which stands on this screen whether or not
        // the slots are full. Czech runs it to "PREJIT NA PRO", which is four
        // times the English label.
        testWidgets(
          'the go-pro label fits at ${width.toInt()}px',
          (tester) async {
            await pumpTextButton(
              tester,
              locale,
              width,
              (l) => l.paywallGoPro,
            );
            expect(tester.takeException(), isNull);
            expectNothingCut(tester);
          },
        );

        // The two file controls. Czech runs the whole-DB one to
        // "ZALOHOVAT VSECHNY HRY", which is the longest label on the screen.
        for (final label in ['backup-all', 'export-save'])
          testWidgets(
            'the $label label fits at ${width.toInt()}px',
            (tester) async {
              await pumpTextButton(
                tester,
                locale,
                width,
                (l) => label == 'backup-all'
                    ? l.careerBackupAll
                    : l.careerExportSave,
              );
              expect(tester.takeException(), isNull);
              expectNothingCut(tester);
            },
          );

        testWidgets(
          'the over-limit reassurance fits at ${width.toInt()}px',
          (tester) async {
            await pumpText(
              tester,
              locale,
              width,
              (l) => '${l.careerSlotsUsed(12)}  ${l.careerSlotsKeepNote}',
            );
            expect(tester.takeException(), isNull);
            expectNothingCut(tester);
          },
        );
      }
    });
  }
}
