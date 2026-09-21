import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';

/// The yearly development report, grouped.
///
/// "He improved from 34" says nothing on its own: a 34-rated boy nobody has
/// picked is not news, and the same line about a first-choice regular is the
/// most important thing on the screen. So the table is read in three blocks —
/// regulars, fringe, youth — and every assertion here is about a manager being
/// able to tell which block a name is in, at the widths a phone really is and
/// in both languages.
void main() {
  /// Asserts that NOTHING anywhere on the screen ran out of room. Catches the
  /// label somebody added without a maxLines, which wraps and makes its row
  /// taller than the row beside it rather than overflowing loudly.
  void expectNothingCut(WidgetTester tester) {
    for (final element in find.byType(Text).evaluate()) {
      final paragraph = element.renderObject;
      if (paragraph is! RenderParagraph) continue;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            'something on the development report is cut off: '
            '"${(element.widget as Text).data}"',
      );
    }
  }

  SquadDevRow row(
    String name, {
    required int age,
    required int rating,
    required int change,
    SquadDevTier? tier,
  }) => SquadDevRow(
    name: name,
    age: age,
    position: 'CM',
    rating: rating,
    change: change,
    status: SquadDevStatus.stayed,
    tier: tier,
  );

  /// One of each: a regular who is a boy, a regular who is not, a fringe man
  /// and a youth nobody has picked. Short names, because what these four are
  /// for is the grouping; the long name has a test of its own below.
  final mixed = [
    row('Kapitán', age: 30, rating: 84, change: 1, tier: SquadDevTier.regular),
    row('Mladík', age: 19, rating: 71, change: 6, tier: SquadDevTier.regular),
    row('Obránce', age: 27, rating: 66, change: 3, tier: SquadDevTier.fringe),
    row('Dorost', age: 18, rating: 34, change: 2, tier: SquadDevTier.youth),
  ];

  Future<AppLocalizations> pumpTable(
    WidgetTester tester, {
    required double width,
    required Locale locale,
    required List<SquadDevRow> rows,
  }) async {
    tester.view
      ..physicalSize = Size(width, 2400)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SquadDevTable(rows: rows),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.pumpAndSettle();
    return AppLocalizations.of(
      tester.element(find.byType(SquadDevTable)),
    );
  }

  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      final at = 'at ${width.toInt()}px in ${locale.languageCode}';

      testWidgets('the report reads regulars, fringe, youth, $at', (
        tester,
      ) async {
        final l = await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        final regulars = tester.getTopLeft(find.text(l.squadDevTierRegulars)).dy;
        final fringe = tester.getTopLeft(find.text(l.squadDevTierFringe)).dy;
        final youth = tester.getTopLeft(find.text(l.squadDevTierYouth)).dy;
        expect(regulars, lessThan(fringe));
        expect(fringe, lessThan(youth));
        expectNothingCut(tester);
      });

      testWidgets('a boy who has been called up is a regular, $at', (
        tester,
      ) async {
        final l = await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        // Nineteen, and under the regulars heading rather than under youth —
        // a call-up outranks a birthday, which is the whole point of the
        // grouping.
        final boy = tester.getTopLeft(find.text('Mladík')).dy;
        expect(boy, greaterThan(tester.getTopLeft(find.text(l.squadDevTierRegulars)).dy));
        expect(boy, lessThan(tester.getTopLeft(find.text(l.squadDevTierFringe)).dy));
        expectNothingCut(tester);
      });

      testWidgets('the biggest mover leads his section, $at', (tester) async {
        final l = await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        expect(l.squadDevTierRegulars, isNotEmpty);
        expect(
          tester.getTopLeft(find.text('Mladík')).dy,
          lessThan(tester.getTopLeft(find.text('Kapitán')).dy),
          reason: '+6 belongs above +1',
        );
      });

      testWidgets('a row says the name, the age and old to new, $at', (
        tester,
      ) async {
        await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        expect(find.text('Kapitán'), findsOneWidget);
        expect(find.text('30'), findsOneWidget);
        // 83 → 84: where he came from is the half that was missing.
        expect(find.text('83'), findsOneWidget);
        expect(find.text('84'), findsOneWidget);
        expectNothingCut(tester);
      });
    }
  }

  testWidgets('a name too long gives up its forename, never its end', (
    tester,
  ) async {
    // The longest name in the shipped pool. Whole, or initialled — those are
    // the only two things the row may print, and an ellipsis is neither.
    const longName = 'Nomenjanahary Raheriniaina';
    await pumpTable(
      tester,
      width: 360,
      locale: const Locale('cs'),
      rows: [
        row(longName, age: 26, rating: 79, change: 4, tier: SquadDevTier.regular),
      ],
    );
    expect(
      find.text(longName).evaluate().length +
          find.text(initialledName(longName)).evaluate().length,
      1,
      reason: 'the name on screen is neither the name nor its initial',
    );
    expectNothingCut(tester);
  });

  testWidgets('a section with nobody in it is not rendered at all', (
    tester,
  ) async {
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: [
        row('Only Regular', age: 28, rating: 80, change: 2, tier: SquadDevTier.regular),
      ],
    );
    expect(find.text(l.squadDevTierRegulars), findsOneWidget);
    expect(find.text(l.squadDevTierFringe), findsNothing);
    expect(find.text(l.squadDevTierYouth), findsNothing);
  });

  testWidgets('a report from an older save has no headings at all', (
    tester,
  ) async {
    // Rows decoded from a body written before tiers existed carry none, and
    // must still render as the flat table they always were.
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: [
        row('Old Body', age: 24, rating: 78, change: 3),
        row('Other Body', age: 31, rating: 72, change: -1),
      ],
    );
    expect(find.text(l.squadDevTierRegulars), findsNothing);
    expect(find.text(l.squadDevTierFringe), findsNothing);
    expect(find.text(l.squadDevTierYouth), findsNothing);
    expect(find.text('Old Body'), findsOneWidget);
    expect(find.text('Other Body'), findsOneWidget);
  });

  testWidgets('a long pool still pages, and every page keeps its headings', (
    tester,
  ) async {
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('cs'),
      rows: [
        for (var i = 0; i < 24; i++)
          row(
            'Hráč Číslo $i',
            age: 28,
            rating: 70 + i % 9,
            change: 24 - i,
            tier: SquadDevTier.regular,
          ),
      ],
    );
    expect(find.text(l.squadDevTierRegulars), findsOneWidget);
    expectNothingCut(tester);
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    // The section carries on, so it says so again rather than leaving a page
    // of names under no heading at all.
    expect(find.text(l.squadDevTierRegulars), findsOneWidget);
    expectNothingCut(tester);
  });
}
