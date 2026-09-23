import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  final nations = [
    nation(id: 1, name: 'France', ranking: 2, isFreeDemo: true),
    nation(id: 2, name: 'Germany', ranking: 16),
    nation(
      id: 3,
      name: 'Brazil',
      ranking: 1,
      isFreeDemo: true,
      confederation: Confederation.southAmerica,
    ),
  ];

  final overrides = [
    nationsProvider.overrideWith((ref) async => nations),
    starPlayersProvider.overrideWith(
      (ref) async => {1: player(id: 101, nationId: 1, name: 'Luc Mercier')},
    ),
  ];

  testWidgets('lists nations for the selected confederation', (tester) async {
    await tester.pumpApp(const NationSelectScreen(), overrides: overrides);
    await tester.pump(); // resolve the futures

    // Europe is the default tab: France + Germany shown, Brazil (CONMEBOL) not.
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Brazil'), findsNothing);
  });

  testWidgets('every nation is selectable on the free tier', (tester) async {
    // The nation list is not what the trial holds back: a free player picks
    // any country in the world and plays a whole cycle with it.
    await tester.pumpApp(
      const NationSelectScreen(),
      overrides: [
        ...overrides,
        premiumUnlockedProvider.overrideWith((ref) => false),
      ],
    );
    await tester.pump();

    expect(find.text('SELECT'), findsNWidgets(2)); // France + Germany
    expect(find.text('PREMIUM'), findsNothing);
    // The star-player line was removed from the card by design.
    expect(find.textContaining('Luc Mercier'), findsNothing);
  });

  testWidgets('search filters the list', (tester) async {
    await tester.pumpApp(const NationSelectScreen(), overrides: overrides);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'germ');
    await tester.pump();

    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('France'), findsNothing);
  });
}
