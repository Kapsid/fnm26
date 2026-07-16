import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/tournaments/venues_card.dart';

import '../helpers/pump_app.dart';

/// A co-hosted tournament is played across every host, so the card must show
/// every host's grounds — it used to take a single nation and show only theirs
/// under a "HOSTS" heading.
void main() {
  List<Venue> venues(String prefix) => [
        (city: '${prefix}ville', stadium: 'Arena $prefix', capacity: 60000),
        (city: '${prefix}town', stadium: '$prefix Park', capacity: 45000),
      ];

  testWidgets('a solo host reads as one host', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: VenuesCard(
          hosts: [(code: 'ESP', name: 'Spain', venues: venues('A'))],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('HOST'), findsOneWidget);
    expect(find.text('Spain'), findsOneWidget);
    expect(find.text('Arena A'), findsOneWidget);
  });

  testWidgets('co-hosts are both named, with both sets of grounds',
      (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: VenuesCard(
          hosts: [
            (code: 'ESP', name: 'Spain', venues: venues('A')),
            (code: 'POR', name: 'Portugal', venues: venues('B')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CO-HOSTS'), findsOneWidget);
    expect(find.text('Spain & Portugal'), findsOneWidget);
    // Both countries' stadiums, each labelled with its country.
    expect(find.text('Arena A'), findsOneWidget);
    expect(find.text('Arena B'), findsOneWidget, reason: "the co-host's ground");
    expect(find.text('SPAIN'), findsOneWidget);
    expect(find.text('PORTUGAL'), findsOneWidget);
  });

  testWidgets('capacities are thousands-separated', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: VenuesCard(
          hosts: [(code: 'ESP', name: 'Spain', venues: venues('A'))],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('60,000 seats'), findsOneWidget);
  });

  testWidgets('no hosts renders nothing', (tester) async {
    await tester.pumpApp(const Scaffold(body: VenuesCard(hosts: [])));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });
}
