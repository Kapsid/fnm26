import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/stats/team_overall_history.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// A manager can read his squad's overall on any match preview, but not
/// whether it is rising or falling. The curve is the answer.
void main() {
  Future<void> pumpChart(
    WidgetTester tester,
    List<TeamOverallPoint> history, {
    double width = 360,
    Locale locale = const Locale('en'),
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = Size(width, 690);
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: TeamOverallHistoryCard(
          key: const Key('team-overall-history'),
          history: history,
        ),
      ),
      locale: locale,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('team detail charts the nation overall by year', (tester) async {
    await pumpChart(tester, const [
      (year: 2030, overall: 71),
      (year: 2031, overall: 74),
      (year: 2032, overall: 78),
    ]);

    expect(find.byKey(const Key('team-overall-history')), findsOneWidget);
    // The run is labelled at both ends, and the latest number is spelled out.
    expect(find.text('2030'), findsOneWidget);
    expect(find.text('2032'), findsOneWidget);
    expect(find.text('Overall 78'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('a save with one season shows no curve yet', (tester) async {
    // One point is not a trend, and an empty chart says less than none.
    await pumpChart(tester, const [(year: 2030, overall: 71)]);
    expect(find.text('2030'), findsNothing);
  });

  testWidgets('a flat run does not divide by zero', (tester) async {
    await pumpChart(tester, const [
      (year: 2030, overall: 70),
      (year: 2031, overall: 70),
      (year: 2032, overall: 70),
    ]);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  // Both phone widths in both languages. The card is a heading, a run of
  // years and a rating, and the rating is the reason anyone opens it.
  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the curve holds its labels at ${width.toInt()}px in '
        '${locale.languageCode}',
        (tester) async {
          await pumpChart(
            tester,
            const [
              (year: 2030, overall: 71),
              (year: 2031, overall: 74),
              (year: 2032, overall: 78),
              (year: 2033, overall: 81),
              (year: 2034, overall: 88),
            ],
            width: width,
            locale: locale,
          );
          expectLocale(
            tester,
            find.byType(TeamOverallHistoryCard),
            locale.languageCode,
          );
          expectNothingCut(
            tester,
            'the overall curve in ${locale.languageCode}',
          );
        },
      );
    }
  }
}
