import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// A save row carries its controls on the right and its text on the left, and
/// the text used to run straight underneath them: "Cesta na MS 2030" sat in a
/// Row with nothing constraining it, so it spilled out of the column it
/// belonged to and collided with the buttons.
///
/// Export has since moved out of that trailing group and into the column as a
/// LABELLED row, so the bin is the leftmost control now. Its label is ordinary
/// column text and is held to the same line as everything else there.
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

  String _exportLabel(Locale locale) =>
      locale.languageCode == 'en' ? 'Export this save' : 'Exportovat tuto hru';

  Future<void> pumpTile(
    WidgetTester tester,
    Locale locale, {
    double width = 320,
    bool busy = false,
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
          body: SaveTile(
            save: save,
            nation: nation,
            onContinue: () {},
            onDelete: () {},
            onShare: busy ? null : () {},
          ),
        ),
      ),
    );
    // A spinner never stops, so a busy tile would hang pumpAndSettle.
    if (busy) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    // Three widths, not one. A row that holds at the narrowest is not
    // guaranteed to hold wider — one of this batch's bugs failed at 400 and
    // passed at 360, because what changes with the width is which of the
    // things sharing the row gets the leftover.
    for (final width in [320.0, 360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: nothing spills out of the row at '
        '${width.toInt()}px',
        (tester) async {
          await pumpTile(tester, locale, width: width);
          expect(
            tester.takeException(),
            isNull,
            reason: 'the save row must not overflow',
          );
          expectNothingCut(tester, 'the save row in ${locale.languageCode}');
        },
      );
    }

    // A file action that is running has to LOOK like it is running. Writing a
    // career out takes seconds on a long save, and a row that does not change
    // when pressed reads as a row that ignored you, so it gets pressed again.
    testWidgets('${locale.languageCode}: a running export shows a spinner', (
      tester,
    ) async {
      await pumpTile(tester, locale, busy: true);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(_exportLabel(locale)), findsOneWidget);
      // While it runs the row must be DEAD, or a second write queues behind
      // the first. Found by predicate rather than by type: TextButton.icon
      // builds a private SUBCLASS of TextButton, and byType is an exact match.
      expect(
        find.byWidgetPredicate(
          (w) => w is TextButton && w.onPressed == null,
        ),
        findsOneWidget,
        reason: 'a second export must not queue behind the first',
      );
    });

    testWidgets('${locale.languageCode}: an idle export shows its icon', (
      tester,
    ) async {
      await pumpTile(tester, locale);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is TextButton && w.onPressed != null,
        ),
        findsOneWidget,
        reason: 'an idle export must be pressable',
      );
    });

    testWidgets('${locale.languageCode}: no text reaches the controls', (
      tester,
    ) async {
      await pumpTile(tester, locale);

      // The delete bin is the leftmost control; every scrap of text has to
      // finish before it starts, or it is painting underneath one.
      final controlsStart = tester
          .getTopLeft(find.byIcon(Icons.delete_outline))
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
