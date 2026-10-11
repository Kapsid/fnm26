import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/friendlies/other_friendlies_providers.dart';
import 'package:fnm/features/results/round_results_screen.dart';

import '../helpers/pump_app.dart';
import '../helpers/round_results_fixture.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone round results', (tester) async {
    tester.view.physicalSize = kPhoneSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const RepaintBoundary(
        key: kAppRoot,
        child: RoundResultsScreen(careerId: 1),
      ),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => fourGroupsView()),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text(enL.resultsGroup('A')), findsOneWidget);
    await expectAppGolden('goldens/round_results_phone.png');
  });

  testWidgets('phone round results, tall (every group)', (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const RepaintBoundary(
        key: kAppRoot,
        child: RoundResultsScreen(careerId: 1),
      ),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => fourGroupsView()),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text(enL.resultsGroup('A')), findsOneWidget);
    await expectAppGolden('goldens/round_results_phone_tall.png');
  });

  testWidgets('phone round results, an unknown nation reads Unknown', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final full = fourGroupsView();
    final view = (
      results: full.results,
      nations: {...full.nations}..remove(5),
      playerNationId: full.playerNationId,
      directCount: full.directCount,
      contentionPos: full.contentionPos,
      relegateCount: full.relegateCount,
      noRelegationGroups: full.noRelegationGroups,
    );
    await tester.pumpApp(
      const RoundResultsScreen(careerId: 1),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => view),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text('\u2014'), findsNothing);
    expect(find.text(enL.hubUnknown), findsWidgets);
  });
}
