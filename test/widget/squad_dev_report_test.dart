import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The yearly development report, tabbed.
///
/// "He improved from 34" says nothing on its own: a 34-rated boy nobody has
/// picked is not news, and the same line about a first-choice regular is the
/// most important thing on the screen. So the table is read in three blocks —
/// regulars, fringe, youth — each its own tab, each paging on its own: the
/// manager's own complaint was that reaching the youth meant paging through
/// the regulars and the fringe first. Every assertion here is about a
/// manager being able to find the right tab, trust its page count, and read
/// it at the widths a phone really is, in both languages.
void main() {
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
  /// for is the tabbing; the long name has a test of its own below.
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

      testWidgets('the strip carries a tab for every tier, $at', (
        tester,
      ) async {
        final l = await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        expect(find.text('${l.squadDevTierRegulars} · 2'), findsOneWidget);
        expect(find.text('${l.squadDevTierFringe} · 1'), findsOneWidget);
        expect(find.text('${l.squadDevTierYouth} · 1'), findsOneWidget);
        expectNothingCut(tester);
      });

      testWidgets(
        'the regulars tab is open by default, and a boy who has been '
        'called up sits in it, $at',
        (tester) async {
          await pumpTable(
            tester,
            width: width,
            locale: locale,
            rows: mixed,
          );
          // Nineteen, and shown under the default tab — a call-up outranks a
          // birthday, which is the whole point of the tiering.
          expect(find.text('Mladík'), findsOneWidget);
          expect(find.text('Kapitán'), findsOneWidget);
          expect(find.text('Obránce'), findsNothing);
          expect(find.text('Dorost'), findsNothing);
        },
      );

      testWidgets('tapping the youth tab shows youth and no regulars, $at', (
        tester,
      ) async {
        final l = await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
        await tester.ensureVisible(find.text('${l.squadDevTierYouth} · 1'));
        await tester.tap(find.text('${l.squadDevTierYouth} · 1'));
        await tester.pumpAndSettle();
        expect(find.text('Dorost'), findsOneWidget);
        expect(find.text('Kapitán'), findsNothing);
        expect(find.text('Mladík'), findsNothing);
        expect(find.text('Obránce'), findsNothing);
        expectNothingCut(tester);
      });

      testWidgets('the biggest mover leads his tab, $at', (tester) async {
        await pumpTable(
          tester,
          width: width,
          locale: locale,
          rows: mixed,
        );
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
        row(
          longName,
          age: 26,
          rating: 79,
          change: 4,
          tier: SquadDevTier.regular,
        ),
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

  testWidgets('a tier with nobody in it gets no tab', (tester) async {
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: [
        row(
          'Only Regular',
          age: 28,
          rating: 80,
          change: 2,
          tier: SquadDevTier.regular,
        ),
      ],
    );
    expect(find.textContaining(l.squadDevTierRegulars), findsOneWidget);
    expect(find.textContaining(l.squadDevTierFringe), findsNothing);
    expect(find.textContaining(l.squadDevTierYouth), findsNothing);
  });

  testWidgets('a report whose rows are all untiered has no tab strip', (
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
    expect(find.textContaining(l.squadDevTierRegulars), findsNothing);
    expect(find.textContaining(l.squadDevTierFringe), findsNothing);
    expect(find.textContaining(l.squadDevTierYouth), findsNothing);
    expect(find.text('Old Body'), findsOneWidget);
    expect(find.text('Other Body'), findsOneWidget);
  });

  testWidgets(
    'a long pool pages within its own tab, twelve players at a time',
    (tester) async {
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
      expect(find.text('${l.squadDevTierRegulars} · 24'), findsOneWidget);
      // Twelve players a page, twenty-four rows: the footer should read
      // page 1 of 2, out of the tab's own 24 — not the whole report.
      expect(find.text(l.squadDevPageOf('1', '2', '24')), findsOneWidget);
      expectNothingCut(tester);
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(find.text(l.squadDevPageOf('2', '2', '24')), findsOneWidget);
      // The tab strip persists across a page turn inside the same tab.
      expect(find.text('${l.squadDevTierRegulars} · 24'), findsOneWidget);
      expectNothingCut(tester);
    },
  );

  testWidgets('switching tabs resets the page to the first', (tester) async {
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: [
        for (var i = 0; i < 24; i++)
          row(
            'Regular $i',
            age: 28,
            rating: 70,
            change: 1,
            tier: SquadDevTier.regular,
          ),
        row('Only Youth', age: 18, rating: 40, change: 0, tier: SquadDevTier.youth),
      ],
    );
    // Page into the regulars tab first.
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text(l.squadDevPageOf('2', '2', '24')), findsOneWidget);
    // Now switch to youth: the page must be back at the first, not still on
    // whatever page the previous tab was showing.
    await tester.ensureVisible(find.text('${l.squadDevTierYouth} · 1'));
        await tester.tap(find.text('${l.squadDevTierYouth} · 1'));
    await tester.pumpAndSettle();
    expect(find.text('Only Youth'), findsOneWidget);
    // A single-row tab has one page, so no pager is shown at all.
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
  });

  testWidgets('the pager total matches the selected tab, not the report', (
    tester,
  ) async {
    final l = await pumpTable(
      tester,
      width: 360,
      locale: const Locale('en'),
      rows: [
        for (var i = 0; i < 14; i++)
          row(
            'Regular $i',
            age: 28,
            rating: 70,
            change: 1,
            tier: SquadDevTier.regular,
          ),
        row('Lone Youth', age: 18, rating: 40, change: 0, tier: SquadDevTier.youth),
      ],
    );
    // 14 regulars page as 12 + 2, and the total printed is 14 — the tab's own
    // count, not fifteen for the whole report.
    expect(find.text(l.squadDevPageOf('1', '2', '14')), findsOneWidget);
    await tester.ensureVisible(find.text('${l.squadDevTierYouth} · 1'));
        await tester.tap(find.text('${l.squadDevTierYouth} · 1'));
    await tester.pumpAndSettle();
    // One youth is one page: no pager at all, so nothing claims a total.
    expect(find.textContaining(l.squadDevTierYouth), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    testWidgets('the tab strip is not cut at phone width, ${locale.languageCode}', (
      tester,
    ) async {
      await pumpTable(
        tester,
        width: 320,
        locale: locale,
        rows: mixed,
      );
      expectNothingCut(tester);
    });
  }
}
