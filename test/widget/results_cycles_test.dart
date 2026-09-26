import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/results/results_screen.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// My matches, folded by cycle.
///
/// A career runs for decades and this screen is read by scrolling, so the list
/// grew without limit: "how did the 2034 cycle go?" meant scrolling past every
/// match of it. One section per cycle now, shut except the one being played,
/// and the summary line carries the answer so the common question is answered
/// without opening anything.
void main() {
  const careerId = 7;

  final nations = {
    for (var i = 1; i <= 3; i++)
      i: Nation(
        id: i,
        name: 'Nation $i',
        code: 'N$i',
        confederation: Confederation.europe,
        ranking: i,
      ),
  };

  /// One match of the manager's, [mine]–[theirs] from his side.
  Fixture played({
    required int id,
    required DateTime date,
    required int mine,
    required int theirs,
    int nation = 1,
    String? round,
    int competitionId = 10,
  }) => Fixture(
    id: id,
    careerId: careerId,
    competitionId: competitionId,
    matchday: id,
    date: date,
    homeNationId: nation,
    awayNationId: nation == 2 ? 3 : 2,
    homeScore: mine,
    awayScore: theirs,
    played: true,
    round: round,
  );

  /// Cycle 0 closes with the 2030 World Championship, cycle 1 with 2034.
  final firstCycle = [
    played(id: 1, date: DateTime(2027, 3), mine: 2, theirs: 0),
    played(id: 2, date: DateTime(2027, 9), mine: 1, theirs: 1),
    played(id: 3, date: DateTime(2028, 3), mine: 0, theirs: 3),
    // The finals, and how far it got: beaten in the quarter-final.
    played(
      id: 4,
      date: DateTime(2030, 6, 20),
      mine: 0,
      theirs: 1,
      round: 'QF',
      competitionId: 11,
    ),
  ];
  final secondCycle = [
    played(id: 5, date: DateTime(2031, 3), mine: 3, theirs: 0, nation: 2),
    played(id: 6, date: DateTime(2031, 9), mine: 2, theirs: 1, nation: 2),
  ];

  Future<void> pumpResults(
    WidgetTester tester, {
    double width = 400,
    Locale locale = const Locale('en'),
    int cyclePointer = 1,
    Map<int, int> nationByCycle = const {0: 1, 1: 2},
    List<Fixture>? fixtures,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpApp(
      const ResultsScreen(careerId: careerId),
      locale: locale,
      overrides: [
        resultsProvider(careerId).overrideWith(
          (ref) async => ResultsData(
            fixtures: fixtures ?? [...firstCycle, ...secondCycle],
            nations: nations,
            playerNationId: 2,
            cyclePointer: cyclePointer,
            nationByCycle: nationByCycle,
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the cycle being played is open and the one before it is not', (
    tester,
  ) async {
    await pumpResults(tester);

    // This cycle's matches are on screen…
    expect(find.text('1 Mar 2031'), findsOneWidget);
    expect(find.text('1 Sep 2031'), findsOneWidget);
    // …and the cycle before it is one card, whatever it holds.
    expect(find.text('1 Mar 2027'), findsNothing);
    expect(find.text('1 Sep 2027'), findsNothing);
    expect(find.text('20 Jun 2030'), findsNothing);
  });

  testWidgets('the summary line answers the question without being opened', (
    tester,
  ) async {
    await pumpResults(tester);

    // The cycle, the nation, the balance, and what it ended in — all four for
    // the folded cycle, read off its header alone.
    expect(find.text('2030 cycle · Nation 1'), findsOneWidget);
    expect(find.text('4 played  ·  1W 1D 2L'), findsOneWidget);
    expect(find.text('World Championship: Quarter-finals'), findsOneWidget);
  });

  testWidgets('the cycle being played has not ended in anything yet', (
    tester,
  ) async {
    await pumpResults(tester);
    expect(find.text('2034 cycle · Nation 2'), findsOneWidget);
    expect(find.text('2 played  ·  2W 0D 0L'), findsOneWidget);
    expect(
      find.text('Still being played'),
      findsOneWidget,
      reason:
          'the finals are years away, so "did not qualify" would be a lie the '
          'summary line cannot afford',
    );
  });

  testWidgets('tapping the summary opens that cycle', (tester) async {
    await pumpResults(tester);

    await tester.tap(find.text('2030 cycle · Nation 1'));
    await tester.pumpAndSettle();

    expect(find.text('1 Mar 2027'), findsOneWidget);
    expect(find.text('20 Jun 2030'), findsOneWidget);
  });

  testWidgets('and tapping the open one folds it away', (tester) async {
    await pumpResults(tester);
    expect(find.text('1 Mar 2031'), findsOneWidget);

    await tester.tap(find.text('2034 cycle · Nation 2'));
    await tester.pumpAndSettle();

    expect(find.text('1 Mar 2031'), findsNothing);
  });

  testWidgets('a match a manager played for another nation counts as his', (
    tester,
  ) async {
    await pumpResults(tester);
    // Cycle 0 was served at Nation 1 and read from Nation 1's side: one win,
    // one draw, two defeats. Counted from the CURRENT nation it would have
    // been nothing at all.
    expect(find.text('4 played  ·  1W 1D 2L'), findsOneWidget);
  });

  testWidgets('one cycle in, there is still a summary to read', (tester) async {
    await pumpResults(
      tester,
      cyclePointer: 0,
      nationByCycle: const {0: 1},
      fixtures: firstCycle,
    );
    expect(find.text('2030 cycle · Nation 1'), findsOneWidget);
    expect(find.text('1 Mar 2027'), findsOneWidget);
  });

  for (final width in const [320.0, 360.0, 400.0]) {
    for (final locale in const ['en', 'cs']) {
      final at = 'at ${width.toInt()}px in $locale';

      testWidgets('every word of a folded cycle reads whole, $at', (
        tester,
      ) async {
        await pumpResults(
          tester,
          width: width,
          locale: Locale(locale),
        );
        final header = locale == 'cs'
            ? 'Cyklus 2030 · Nation 1'
            : '2030 cycle · Nation 1';
        final finder = find.text(header);
        expect(finder, findsOneWidget, reason: 'the header is not on screen');
        expectWhole(finder, 'the folded cycle header');
        expectNothingCut(tester, 'the my-matches list in $locale');
        expect(tester.takeException(), isNull);
      });

      testWidgets('and so does the cycle it opens, $at', (tester) async {
        await pumpResults(
          tester,
          width: width,
          locale: Locale(locale),
        );
        final header = locale == 'cs'
            ? 'Cyklus 2030 · Nation 1'
            : '2030 cycle · Nation 1';
        await tester.tap(find.text(header));
        await tester.pumpAndSettle();
        expectNothingCut(tester, 'the opened cycle in $locale');
        expect(tester.takeException(), isNull);
      });
    }
  }
}
