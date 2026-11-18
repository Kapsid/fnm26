import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// Team records on a phone (1.1.2 redesign, variant A): underline tabs, the
/// top three on a podium with the leader in silver, and a History tab that
/// holds the overall curve and the way to the legacy screens.
void main() {
  Future<void> open(WidgetTester tester) async {
    final save = await seedSave(tester, overrides: [fakeTeamStatsOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.teamStats}?careerId=${save.careerId}',
      size: const Size(390, 1600),
    );
  }

  testWidgets('the top three stand on the podium, the rest below', (
    tester,
  ) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    final view = fakeTeamStats();
    expect(find.byKey(RecordPodium.podiumKey), findsOneWidget);
    final leader = view.names[view.scorers.first.playerId]!;
    expect(
      find.descendant(
        of: find.byKey(RecordPodium.placeKey(1)),
        matching: find.text(leader),
      ),
      findsOneWidget,
    );
    // Fourth is the first row of the list.
    expect(find.text('4'), findsOneWidget);
    // Games and Ratings have their podiums too.
    for (final tab in [1, 2]) {
      await tester.tap(find.byKey(RecordTabs.tabKey(tab)));
      await tester.pumpAndSettle();
      expect(find.byKey(RecordPodium.podiumKey), findsOneWidget);
      expect(find.byKey(RecordPodium.placeKey(1)), findsOneWidget);
    }
  });

  testWidgets('History holds the overall curve and the legacy screens', (
    tester,
  ) async {
    await open(tester);
    expect(
      find.byKey(
        const Key('team-overall-history'),
        // With no curve yet (one point) the card draws nothing.
        skipOffstage: false,
      ),
      findsNothing,
    );
    expect(find.byType(LegacyTiles), findsNothing);
    await tester.ensureVisible(find.byKey(RecordTabs.tabKey(4)));
    await tester.tap(find.byKey(RecordTabs.tabKey(4)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.byKey(
        const Key('team-overall-history'),
        // With no curve yet (one point) the card draws nothing.
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(find.byType(LegacyTiles), findsOneWidget);
  });
}
