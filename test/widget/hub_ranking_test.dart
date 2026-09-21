import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The dashboard header: the nation's world ranking beside the date.
///
/// The manager asked for it there because that is the line he already reads
/// for "where am I today". The header was already carrying a formatted date
/// and a manager's name on a 360px phone, so the whole risk of this change is
/// width: the figure and its arrow have to survive intact in both languages,
/// and the squad status panel below it stays exactly where it was.
///
/// Every number here is a plain [Text] with maxLines: 1 so the width guard can
/// actually fail — this project's WholeText scales itself down to fit, which
/// makes a width guard blind inside one.
void main() {
  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
  ///
  /// `takeException` alone is not enough and never was: it passes for any
  /// amount of quiet truncation.
  void expectWhole(Finder finder, String what) {
    final elements = finder.evaluate();
    expect(elements, isNotEmpty, reason: '$what is not on screen at all');
    for (final element in elements) {
      final paragraph = element.renderObject! as RenderParagraph;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            '$what is cut off: it wants '
            '${paragraph.getMaxIntrinsicWidth(double.infinity)}px '
            'and was given ${paragraph.size.width}px',
      );
    }
  }

  /// Pumps [child] at [width] in [locale], with the locale on the MaterialApp
  /// itself rather than a Localizations.override around the child.
  Future<void> pumpAt(
    WidgetTester tester,
    Widget child, {
    required double width,
    required String locale,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The header as the dashboard lays it out: the same list, with the same
  /// side padding, so it gets exactly the width and the freedom of height it
  /// gets on the phone.
  Widget header({int? rank = 12, int movement = 0, String? date}) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      HubHeader(
        code: 'BRA',
        nationName: 'Brazil',
        managerName: 'A. Manager',
        date: date ?? '14 Sep 2026',
        rank: rank,
        movement: movement,
      ),
    ],
  );

  group('the dashboard says where the nation stands', () {
    testWidgets('the world position sits beside the date', (tester) async {
      await pumpAt(tester, header(), width: 400, locale: 'en');

      expect(find.text('#12'), findsOneWidget);
      expect(find.textContaining('14 Sep 2026'), findsOneWidget);
    });

    testWidgets('a climb draws an up arrow and the places gained', (
      tester,
    ) async {
      await pumpAt(tester, header(movement: 21), width: 400, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      // The direction is the arrow; the figure is the distance, never a minus
      // sign the manager has to read twice.
      expect(find.text('21'), findsOneWidget);
    });

    testWidgets('a slide draws a down arrow', (tester) async {
      await pumpAt(tester, header(movement: -13), width: 400, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.text('13'), findsOneWidget);
    });

    testWidgets('standing still draws no arrow at all', (tester) async {
      await pumpAt(tester, header(movement: 0), width: 360, locale: 'en');

      expect(find.byIcon(Icons.arrow_drop_up), findsNothing);
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      expect(find.text('#12'), findsOneWidget);
    });

    testWidgets('an unranked save shows the date alone', (tester) async {
      await pumpAt(tester, header(rank: null), width: 360, locale: 'en');

      expect(find.textContaining('#'), findsNothing);
      expect(find.textContaining('14 Sep 2026'), findsOneWidget);
    });
  });

  group('the figure survives a narrow phone', () {
    // 360 and 400 are the two widths this batch keeps shipping bugs at, and
    // Czech is where the date and the manager's name are longest.
    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('rank and movement are whole at $width in $locale', (
          tester,
        ) async {
          await pumpAt(
            tester,
            header(rank: 137, movement: -24, date: '14. září 2026'),
            width: width,
            locale: locale,
          );

          expectWhole(find.text('#137'), 'the world position');
          expectWhole(find.text('24'), 'the movement');
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
        });

        testWidgets('the header stays one line at $width in $locale', (
          tester,
        ) async {
          await pumpAt(
            tester,
            header(rank: 137, movement: -24, date: '14. září 2026'),
            width: width,
            locale: locale,
          );

          // A label left free to wrap makes the row taller than the header
          // allows, which reads as a squashed flag rather than as an overflow
          // anyone can see. The nation's name is one line of headlineMedium
          // (32) over one line of bodySmall (18); a wrap adds another 18.
          expect(
            tester.getSize(find.byType(HubHeader)).height,
            lessThanOrEqualTo(56),
          );
        });
      }
    }
  });
}
