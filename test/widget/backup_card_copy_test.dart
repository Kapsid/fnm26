import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';

/// The backup card's copy, in both languages, on the narrowest phone.
///
/// This card carries the only warning a player gets that NOTHING backs his
/// saves up by itself, so it has to be readable where it is longest. Czech runs
/// it about a fifth longer than English.
void main() {
  Future<void> pumpCard(
    WidgetTester tester,
    Locale locale,
    double width,
  ) async {
    tester.view
      ..physicalSize = Size(width, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  final l = AppLocalizations.of(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.backupTitle, style: AppTypography.labelMedium),
                      const SizedBox(height: 4),
                      Text(l.backupBlurb, style: AppTypography.labelSmall),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: l.backupExport,
                        icon: Icons.ios_share_rounded,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings_backup_restore_rounded,
                          size: 18,
                        ),
                        label: Text(l.backupRestore),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final width in [320.0, 360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the backup card fits at ${width.toInt()}px',
        (tester) async {
          await pumpCard(tester, locale, width);
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
        },
      );
    }

    testWidgets('${locale.languageCode}: the blurb says nothing is automatic', (
      tester,
    ) async {
      await pumpCard(tester, locale, 360);
      final l = locale.languageCode == 'en'
          ? await AppLocalizations.delegate.load(const Locale('en'))
          : await AppLocalizations.delegate.load(const Locale('cs'));
      // The whole point of the card. A blurb that only recommends a backup
      // lets a player assume something else is already keeping one.
      expect(
        l.backupBlurb.toLowerCase(),
        contains(
          locale.languageCode == 'en'
              ? 'nothing backs it up'
              : 'nic je samo nezálohuje',
        ),
        reason: 'the card must say the backup is not automatic',
      );
    });
  }
}
