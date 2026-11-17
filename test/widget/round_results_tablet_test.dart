import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/friendlies/other_friendlies_providers.dart';
import 'package:fnm/features/results/round_results_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';
import '../helpers/round_results_fixture.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in [kTabletSize, const Size(1080, 810)]) {
    testWidgets(
      'each group: scores beside the table, two groups a row '
      '${size.width.toInt()}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpApp(
          const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
          overrides: [
            roundResultsViewProvider(
              1,
            ).overrideWith((ref) async => fourGroupsView()),
            otherFriendliesProvider(1).overrideWith((ref) async => const []),
          ],
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byKey(RoundResultsScreen.tabletLayoutKey), findsOneWidget);
        expect(find.byType(MatchResultRow), findsNWidgets(8));

        final a = tester.getRect(
          find.text(enL.resultsGroup('A').toUpperCase()),
        );
        final b = tester.getRect(
          find.text(enL.resultsGroup('B').toUpperCase()),
        );
        final c = tester.getRect(
          find.text(enL.resultsGroup('C').toUpperCase()),
        );
        expect(a.top, b.top, reason: 'A and B share a row');
        expect(c.top, greaterThan(a.bottom));

        final score = tester.getCenter(find.byType(MatchResultRow).first);
        final tableRow = tester.getCenter(find.text('Nation 3').first);
        expect(score.dx, lessThan(tableRow.dx));
        expect(find.text(enL.resultsContinue), findsOneWidget);
      },
    );
  }

  for (final size in kTabletSizes) {
    testWidgets('a knockout round: one column of ties, no tables, $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
        overrides: [
          roundResultsViewProvider(
            1,
          ).overrideWith((ref) async => knockoutView()),
          otherFriendliesProvider(1).overrideWith((ref) async => const []),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(RoundResultsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(MatchResultRow), findsNWidgets(2));
      expect(find.text('QUARTER-FINALS'), findsOneWidget);
      // One column, centred: both ties share a left edge.
      final rows = find.byType(MatchResultRow);
      expect(tester.getRect(rows.at(0)).left, tester.getRect(rows.at(1)).left);
      expect(find.text(enL.resultsGroup('A').toUpperCase()), findsNothing);
    });

    testWidgets('a friendly window: the other friendlies in one panel, $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
        overrides: [
          roundResultsViewProvider(
            1,
          ).overrideWith((ref) async => emptyRoundView()),
          otherFriendliesProvider(1).overrideWith(
            (ref) async => const [
              (homeId: 1, awayId: 2, homeScore: 1, awayScore: 1),
              (homeId: 3, awayId: 4, homeScore: 0, awayScore: 2),
            ],
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.text(enL.resultsFriendlyInternationals.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(enL.resultsContinue), findsOneWidget);
    });
  }

  // A nation the view cannot name reads as unknown, never as a dash.
  testWidgets('a nation missing from the view is named Unknown', (
    tester,
  ) async {
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final v = fourGroupsView();
    final view = (
      results: v.results,
      nations: {...v.nations}..remove(4),
      playerNationId: v.playerNationId,
      directCount: v.directCount,
      contentionPos: v.contentionPos,
      playoffNations: v.playoffNations,
      relegateCount: v.relegateCount,
      noRelegationGroups: v.noRelegationGroups,
    );
    await tester.pumpApp(
      const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => view),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(RoundResultsScreen.tabletLayoutKey), findsOneWidget);
    // Group A's table names its other three and calls the fourth unknown.
    expect(find.text('Nation 3'), findsWidgets);
    expect(find.text(enL.hubUnknown), findsOneWidget);
    expect(find.text('—'), findsNothing);
  });
}
