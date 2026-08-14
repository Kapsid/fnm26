import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/pump_app.dart';

/// A manager watching a tournament he is not in used to get every round of it
/// in one list — thirty-two ties of scrolling with no sense of where the
/// tournament had reached. The list now turns a page at a time.
/// How many ties the list is showing. Each tie renders one score (or 'vs')
/// between the two nations, so counting those counts the ties on the page.
int _ties(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .where(
      (t) => t.data != null && RegExp(r'^(vs|\d+ - \d+)$').hasMatch(t.data!),
    )
    .length;

void main() {
  Fixture tie(String round, int home, int away, {int? hs, int? as}) => Fixture(
    id: round.hashCode.abs() % 1000 + home * 100 + away,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 6, 20),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: hs != null,
    round: round,
  );

  const rounds = <BracketRound>[
    ('R16', 'Round of 16'),
    ('QF', 'Quarter-finals'),
    ('SF', 'Semi-finals'),
    ('FINAL', 'Final'),
  ];

  /// A tournament played out to its final, so every round has ties.
  List<Fixture> fullBracket() => [
    for (var i = 0; i < 8; i++)
      tie('R16', 200 + i * 2, 201 + i * 2, hs: 1, as: 0),
    for (var i = 0; i < 4; i++)
      tie('QF', 200 + i * 4, 204 + i * 4, hs: 1, as: 0),
    tie('SF', 200, 208, hs: 1, as: 0),
    tie('SF', 216, 224, hs: 2, as: 1),
    tie('FINAL', 200, 216, hs: 1, as: 0),
  ];

  Widget bracket(List<Fixture> fixtures) => Scaffold(
    body: TournamentBracket(
      fixtures: fixtures,
      rounds: rounds,
      ladder: rounds,
      playerNationId: 1,
      code: (id) => 'N$id',
      name: (id) => 'Nation $id',
    ),
  );

  testWidgets('the passive sim shows one round at a time', (tester) async {
    await tester.pumpApp(bracket(fullBracket()));
    await tester.pumpAndSettle();

    // Everything played, so it opens on the last round — the final, one tie.
    expect(find.text('FINAL'), findsOneWidget);
    expect(find.text('4/4'), findsOneWidget);
    expect(_ties(tester), 1);
    expect(find.text('QUARTER-FINALS'), findsNothing);
  });

  testWidgets('a live tournament opens on the round being played', (
    tester,
  ) async {
    // The last sixteen is done; the quarter-finals are not.
    final fixtures = [
      for (var i = 0; i < 8; i++)
        tie('R16', 200 + i * 2, 201 + i * 2, hs: 1, as: 0),
      for (var i = 0; i < 4; i++) tie('QF', 200 + i * 4, 204 + i * 4),
    ];
    await tester.pumpApp(bracket(fixtures));
    await tester.pumpAndSettle();

    expect(find.text('QUARTER-FINALS'), findsOneWidget);
    expect(_ties(tester), 4);
  });

  testWidgets('the pager walks the rounds in both directions', (tester) async {
    await tester.pumpApp(bracket(fullBracket()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('passive-sim-prev-round')));
    await tester.pumpAndSettle();
    expect(find.text('SEMI-FINALS'), findsOneWidget);
    expect(_ties(tester), 2);

    await tester.tap(find.byKey(const Key('passive-sim-next-round')));
    await tester.pumpAndSettle();
    expect(find.text('FINAL'), findsOneWidget);
  });

  testWidgets('the pager stops at both ends', (tester) async {
    await tester.pumpApp(bracket(fullBracket()));
    await tester.pumpAndSettle();

    // On the last round, there is nowhere forward to go.
    final next = tester.widget<IconButton>(
      find.byKey(const Key('passive-sim-next-round')),
    );
    expect(next.onPressed, isNull);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('passive-sim-prev-round')));
      await tester.pumpAndSettle();
    }
    expect(find.text('ROUND OF 16'), findsOneWidget);
    final prev = tester.widget<IconButton>(
      find.byKey(const Key('passive-sim-prev-round')),
    );
    expect(prev.onPressed, isNull);
  });
}
