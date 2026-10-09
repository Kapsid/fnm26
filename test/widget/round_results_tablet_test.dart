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
}
