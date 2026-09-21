import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/transfer_report.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The transfer table, at the widths a phone really is and in both languages.
///
/// `expect(tester.takeException(), isNull)` is NOT a width test: it passes for
/// any amount of ellipsis, and a table whose fees read "€42..." has failed at
/// the only job it has. `expectWhole` reads the paragraph instead and asks
/// whether it ran out of room, which it can only do for a plain [Text] — this
/// project's [WholeText] scales itself down to fit and never reports a cut.
///
/// So the row is guarded twice over. The fee, the pager and the count are
/// plain [Text] and are held to `expectWhole`. The player name is a
/// [WholeText], because no layout prints a twenty-six letter name at sixteen
/// points on a 360-point phone; what is held there is that it never gives up
/// more than its forename, which `expectNothingCut` and the name assertions
/// below check together.
void main() {
  /// The longest name in the shipped pool, and the worst row the report can
  /// write around it: a long pair of clubs and the widest fee there is.
  const longName = 'Nomenjanahary Raheriniaina';

  /// A name a phone CAN hold whole, so the guard has something it must not
  /// shorten as well as something it may.
  const shortName = 'Jan Novák';

  /// The two widest fees the report can write: six monospace characters of
  /// money, and the Czech word for a free transfer, which is longer than the
  /// English one.
  List<TransferRow> window({int count = 14, String name = longName}) => [
    for (var i = 0; i < count; i++)
      (
        name: name,
        position: 'CM',
        from: 'Sportovní Klub Ostrava',
        to: 'Athletic Association',
        fee: i.isEven ? '€1200M' : 'Zdarma',
        abroad: i.isEven,
        rating: 0,
        change: null,
        step: i % 3 - 1,
        fromCountry: 'cze',
        toCountry: 'eng',
      ),
  ];

  Future<void> pumpTable(
    WidgetTester tester, {
    required double width,
    required Locale locale,
    List<TransferRow>? rows,
  }) async {
    tester.view
      ..physicalSize = Size(width, 1200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TransferTable(rows: rows ?? window()),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.pumpAndSettle();
  }

  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      final at = 'at ${width.toInt()}px in ${locale.languageCode}';

      testWidgets('a move prints its fee whole, $at', (tester) async {
        await pumpTable(tester, width: width, locale: locale);
        // The fee is the figure the table exists to report. A digit lost here
        // turns a 1200 million move into a 120 million one, and the Czech
        // word for a free transfer used to read "Zdarm…" on every phone.
        expectWhole(find.text('€1200M'), 'the largest fee');
        expectWhole(find.text('Zdarma'), 'a free transfer');
        expectNothingCut(tester, 'the transfer table');
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });

      testWidgets('a name a phone can hold is printed in full, $at', (
        tester,
      ) async {
        await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: window(name: shortName),
        );
        expect(find.text(shortName), findsNWidgets(TransferTable.perPage));
        expectNothingCut(tester, 'the transfer table');
      });

      testWidgets('a name too long gives up its forename, never its end, $at', (
        tester,
      ) async {
        await pumpTable(tester, width: width, locale: locale);
        // Whole, or initialled. Those are the only two things the row may
        // show — an ellipsis is not one of them, and neither is a surname
        // with its tail taken off.
        final whole = find.text(longName).evaluate().length;
        final initialled = find
            .text(initialledName(longName))
            .evaluate()
            .length;
        expect(
          whole + initialled,
          TransferTable.perPage,
          reason: 'the name on screen is neither the name nor its initial',
        );
        expectNothingCut(tester, 'the transfer table');
      });

      testWidgets('the pager says which page it is on, $at', (tester) async {
        await pumpTable(tester, width: width, locale: locale);
        // Words and a page count, not chevrons: arrows on this screen are
        // moves. Whatever the pager says, it says it whole.
        expectWhole(
          find.descendant(
            of: find.byType(TextButton),
            matching: find.byType(Text),
          ),
          'a pager button',
        );
        expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
        expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
        expectNothingCut(tester, 'the transfer table');
      });

      testWidgets('every row says which way the move was, $at', (tester) async {
        await pumpTable(tester, width: width, locale: locale);
        // Six rows a page, one arrow each, and between them all three
        // directions: up, down and level.
        expect(
          find.byIcon(Icons.north_east_rounded).evaluate().length +
              find.byIcon(Icons.south_east_rounded).evaluate().length +
              find.byIcon(Icons.east_rounded).evaluate().length,
          TransferTable.perPage,
        );
        expect(find.byIcon(Icons.north_east_rounded), findsWidgets);
        expect(find.byIcon(Icons.south_east_rounded), findsWidgets);
        expect(find.byIcon(Icons.east_rounded), findsWidgets);
      });

      testWidgets('paging holds the row together, $at', (tester) async {
        await pumpTable(tester, width: width, locale: locale);
        await tester.tap(find.byType(TextButton).last);
        await tester.pumpAndSettle();
        expectWhole(find.text('€1200M'), 'the largest fee');
        expectNothingCut(tester, 'the transfer table');
        expect(tester.takeException(), isNull);
        expectNothingCut(tester);
      });
    }
  }

  testWidgets('a single page has no pager at all', (tester) async {
    await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: window(count: 3),
    );
    expect(find.byType(TextButton), findsNothing);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });
}
