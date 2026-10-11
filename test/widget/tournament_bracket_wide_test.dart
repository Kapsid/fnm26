import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/pump_app.dart';

/// The list view's pages; their headers are written in capitals, so none of
/// them reads 'R16' or 'Final' the way the bracket's column labels do.
const _rounds = <BracketRound>[
  ('R16', 'Round of 16'),
  ('QF', 'Quarter-finals'),
  ('SF', 'Semi-finals'),
  ('FINAL', 'Final'),
];

const _ladder = <BracketRound>[
  ('R16', 'R16'),
  ('QF', 'QF'),
  ('SF', 'SF'),
  ('FINAL', 'Final'),
];

List<Fixture> _bracket() {
  var id = 0;
  Fixture tie(String round, int home, int away) => Fixture(
    id: id++,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: 1,
    awayScore: 0,
    round: round,
    played: true,
  );
  return [
    for (var i = 0; i < 8; i++) tie('R16', 2 * i + 1, 2 * i + 2),
    for (var i = 0; i < 4; i++) tie('QF', 4 * i + 1, 4 * i + 3),
    for (var i = 0; i < 2; i++) tie('SF', 8 * i + 1, 8 * i + 5),
    tie('FINAL', 1, 9),
  ];
}

Future<void> _pump(WidgetTester tester, {required bool wide}) async {
  tester.view.physicalSize = const Size(1000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: TournamentBracket(
        fixtures: _bracket(),
        rounds: _rounds,
        ladder: _ladder,
        playerNationId: 1,
        code: (id) => 'N$id',
        name: (id) => 'Nation $id',
        wide: wide,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('wide: opens on the bracket, columns across the width', (
    tester,
  ) async {
    await _pump(tester, wide: true);
    final r16 = tester.getCenter(find.text('R16'));
    final last = tester.getCenter(find.text('Final'));
    // Four 150-wide columns 8 apart would put the centres 3 x 158 apart.
    expect(last.dx - r16.dx, greaterThan(3 * 158 + 100));
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone (not wide): opens on the list, as before', (
    tester,
  ) async {
    await _pump(tester, wide: false);
    // The list view pages one round at a time; the bracket's column labels
    // are not on screen until the manager switches to it.
    expect(find.text('R16'), findsNothing);
    await tester.tap(find.text('Bracket'));
    await tester.pump();
    final r16 = tester.getCenter(find.text('R16'));
    final last = tester.getCenter(find.text('Final'));
    expect(last.dx - r16.dx, 3 * 158);
  });
}
