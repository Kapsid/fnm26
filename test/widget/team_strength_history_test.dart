import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/stats/stats_providers.dart';

import '../helpers/pump_app.dart';

/// The manager's career screen is where anyone goes to read their history, and
/// until now it said what the side won without ever saying how good it got.
/// The curve was only on the team screen.
void main() {
  const czechia = Nation(
    id: 11,
    name: 'Czechia',
    code: 'CZE',
    confederation: Confederation.europe,
    ranking: 30,
  );

  ManagerHistory historyWith(List<ManagerCycle> cycles) => ManagerHistory(
    managerName: 'Martin Urbanczyk',
    cycles: cycles,
    played: 40,
    won: 25,
    drawn: 8,
    lost: 7,
    goalsFor: 80,
    goalsAgainst: 35,
    titles: 2,
  );

  ManagerCycle cycle(int year) => ManagerCycle(
    cycle: 1,
    year: year,
    nation: czechia,
    played: 10,
    won: 6,
    drawn: 2,
    lost: 2,
    goalsFor: 20,
    goalsAgainst: 10,
    worldCup: 'Semi-finals',
    continental: 'Quarter-finals',
  );

  Future<void> pumpCareer(
    WidgetTester tester, {
    required List<TeamOverallPoint> strength,
    double width = 400,
    Locale locale = const Locale('en'),
  }) async {
    tester.view
      // Tall enough that the whole page is laid out: the career card above the
      // curve is long, and a lazy ListView would otherwise never build the
      // curve at all at the narrower width.
      ..physicalSize = Size(width, 1600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          child: const ManagerHistoryScreen(careerId: 1),
        ),
      ),
      overrides: [
        managerHistoryProvider(
          1,
        ).overrideWith((ref) async => historyWith([cycle(2034)])),
        teamOverallHistoryProvider(1).overrideWith((ref) async => strength),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the career screen charts the side year by year', (tester) async {
    await pumpCareer(
      tester,
      strength: const [
        (year: 2030, overall: 71),
        (year: 2031, overall: 74),
        (year: 2032, overall: 78),
      ],
    );

    expect(find.byKey(const Key('career-team-strength')), findsOneWidget);
    // Both ends of the run are labelled, and the side it belongs to is named:
    // a career can span several jobs, and the curve is the current one's.
    expect(find.text('2030'), findsOneWidget);
    expect(find.text('2032'), findsOneWidget);
    expect(find.text('Overall 78'), findsOneWidget);
    expect(find.text('Czechia'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a one-year career draws no empty frame', (tester) async {
    await pumpCareer(tester, strength: const [(year: 2030, overall: 71)]);

    expect(find.byKey(const Key('career-team-strength')), findsNothing);
    expect(find.text('Overall 71'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a career with no recorded seasons draws nothing', (
    tester,
  ) async {
    await pumpCareer(tester, strength: const []);

    expect(find.byKey(const Key('career-team-strength')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Two rows have shipped broken in Czech this batch. Prove it instead.
  for (final width in [400.0, 360.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the strength curve fits ${width.toInt()}px in ${locale.languageCode}',
        (tester) async {
          await pumpCareer(
            tester,
            width: width,
            locale: locale,
            strength: const [
              (year: 2030, overall: 71),
              (year: 2031, overall: 74),
              (year: 2032, overall: 78),
              (year: 2033, overall: 76),
            ],
          );

          expect(find.byKey(const Key('career-team-strength')), findsOneWidget);
          expect(
            tester.takeException(),
            isNull,
            reason: 'nothing in the strength card may run off its width',
          );
        },
      );
    }
  }
}
