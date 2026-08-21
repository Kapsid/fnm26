import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// A save row carries three buttons on its right — share, delete, and the
/// chevron into the save — and the text beside them ran straight underneath.
/// "Cesta na MS 2030" sat in a Row with nothing constraining it, so it spilled
/// out of the column it belonged to and collided with the controls.
void main() {
  final save = Career(
    id: 1,
    managerName: 'Martin Urbanczyk',
    nationId: 1,
    rngSeed: 7,
    createdAt: DateTime(2026, 7),
    inGameDate: DateTime(2030, 6),
    cyclePointer: 1,
    lastPlayedAt: DateTime(2026, 8, 20),
    playedSeconds: 7200,
  );

  const nation = Nation(
    id: 1,
    name: 'Bosnia and Herzegovina',
    code: 'BIH',
    confederation: Confederation.europe,
    ranking: 60,
  );

  Future<void> pumpTile(WidgetTester tester, Locale locale) async {
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
          body: SaveTile(
            save: save,
            nation: nation,
            onContinue: () {},
            onDelete: () {},
            onShare: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    testWidgets('${locale.languageCode}: nothing spills out of the row', (
      tester,
    ) async {
      await pumpTile(tester, locale);
      expect(
        tester.takeException(),
        isNull,
        reason: 'the save row must not overflow',
      );
    });

    testWidgets('${locale.languageCode}: no text reaches the controls', (
      tester,
    ) async {
      await pumpTile(tester, locale);

      // The share button is the leftmost control; every scrap of text has to
      // finish before it starts, or it is painting underneath one.
      final controlsStart = tester
          .getTopLeft(find.byIcon(Icons.ios_share_rounded))
          .dx;
      for (final element in find.byType(Text).evaluate()) {
        final text = element.widget as Text;
        final right = tester.getBottomRight(find.byWidget(text)).dx;
        expect(
          right,
          lessThanOrEqualTo(controlsStart),
          reason: '"${text.data}" runs into the buttons',
        );
      }
    });
  }
}
