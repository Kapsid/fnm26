import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The shared knockout bracket — the World Cup and the continental cups run the
/// same shape, and the continental screens used to get a list-only view.
void main() {
  Fixture tie(String round, int home, int away, {int? hs, int? as}) => Fixture(
    id: home * 100 + away,
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

  String code(int id) => 'N$id';
  String name(int id) => 'Nation $id';

  Widget bracket({
    required List<Fixture> fixtures,
    required List<BracketRound> rounds,
    required List<BracketRound> ladder,
    int? champion,
    String? runSummary,
    String championLabel = 'CHAMPIONS',
  }) => Scaffold(
    body: TournamentBracket(
      fixtures: fixtures,
      rounds: rounds,
      ladder: ladder,
      champion: champion,
      championLabel: championLabel,
      runSummary: runSummary,
      playerNationId: 1,
      code: code,
      name: name,
    ),
  );

  const wcRounds = <BracketRound>[
    ('SF', 'Semi-finals'),
    ('3RD', 'Third place'),
    ('FINAL', 'Final'),
  ];
  const wcLadder = <BracketRound>[('SF', 'SF'), ('FINAL', 'Final')];

  const euroRounds = <BracketRound>[
    ('CSF', 'Semi-finals'),
    ('C3RD', 'Third place'),
    ('CFINAL', 'Final'),
  ];
  const euroLadder = <BracketRound>[('CSF', 'SF'), ('CFINAL', 'Final')];

  testWidgets('the List/Bracket toggle switches views', (tester) async {
    await tester.pumpApp(
      bracket(
        fixtures: [
          tie('SF', 1, 2, hs: 2, as: 1),
          tie('FINAL', 1, 3, hs: 0, as: 1),
        ],
        rounds: wcRounds,
        ladder: wcLadder,
      ),
    );
    await tester.pumpAndSettle();

    // List view: one round at a time, opening on the last played round.
    expect(find.text('FINAL'), findsOneWidget);
    await tester.tap(find.byKey(const Key('passive-sim-prev-round')));
    await tester.pumpAndSettle();

    // Round headings and full nation names.
    expect(find.text('SEMI-FINALS'), findsOneWidget);
    expect(find.text('Nation 2'), findsOneWidget);

    await tester.tap(find.text('Bracket'));
    await tester.pumpAndSettle();

    // Bracket view: compact columns keyed by code, not name.
    expect(find.text('SEMI-FINALS'), findsNothing);
    expect(find.text('N2'), findsWidgets);
  });

  testWidgets('a continental cup gets the same bracket', (tester) async {
    // The whole point of (k): C-prefixed rounds render identically.
    await tester.pumpApp(
      bracket(
        fixtures: [
          tie('CSF', 1, 2, hs: 2, as: 1),
          tie('CFINAL', 1, 3, hs: 3, as: 0),
        ],
        rounds: euroRounds,
        ladder: euroLadder,
        champion: 1,
        championLabel: 'EUROPEAN CHAMPIONSHIP CHAMPIONS',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EUROPEAN CHAMPIONSHIP CHAMPIONS'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
    expect(find.text('Bracket'), findsOneWidget);
    await tester.tap(find.byKey(const Key('passive-sim-prev-round')));
    await tester.pumpAndSettle();
    expect(find.text('SEMI-FINALS'), findsOneWidget);

    await tester.tap(find.text('Bracket'));
    await tester.pumpAndSettle();
    expect(find.text('N1'), findsWidgets);
  });

  testWidgets('a full Round of 32 fits without overflowing', (tester) async {
    // Regression: the bracket had a flat height of 460 with only horizontal
    // scrolling, so a 16-tie round overflowed its column and was clipped —
    // "not scrollable and part is not visible".
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(420, 900);
    addTearDown(tester.view.reset);

    final r32 = [
      for (var i = 0; i < 16; i++)
        tie('R32', 100 + i * 2, 101 + i * 2, hs: 1, as: 0),
    ];
    await tester.pumpApp(
      bracket(
        fixtures: [...r32, tie('FINAL', 100, 130, hs: 2, as: 1)],
        rounds: const [('R32', 'Round of 32'), ('FINAL', 'Final')],
        ladder: const [('R32', 'R32'), ('FINAL', 'Final')],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bracket'));
    await tester.pumpAndSettle();

    // A RenderFlex overflow would be reported as a test exception.
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);

    // Every tie is laid out — the column is tall enough for all sixteen.
    for (var i = 0; i < 16; i++) {
      expect(
        find.text('N${100 + i * 2}'),
        findsWidgets,
        reason: 'tie $i must be laid out, not clipped away',
      );
    }
  });

  testWidgets('the bracket scrolls sideways to reach later rounds', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      bracket(
        fixtures: [
          for (var i = 0; i < 8; i++)
            tie('R16', 200 + i * 2, 201 + i * 2, hs: 1, as: 0),
          for (var i = 0; i < 4; i++)
            tie('QF', 200 + i * 4, 204 + i * 4, hs: 1, as: 0),
          tie('SF', 200, 208, hs: 1, as: 0),
          tie('FINAL', 200, 216, hs: 1, as: 0),
        ],
        rounds: const [('R16', 'Round of 16'), ('FINAL', 'Final')],
        ladder: const [
          ('R16', 'R16'),
          ('QF', 'QF'),
          ('SF', 'SF'),
          ('FINAL', 'Final'),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bracket'));
    await tester.pumpAndSettle();

    // Four 150px columns don't fit a 360px phone, so the row must scroll.
    final scrollable = find
        .byType(Scrollable)
        .evaluate()
        .map(
          (e) => (e.widget as Scrollable).axisDirection,
        );
    expect(
      scrollable,
      contains(AxisDirection.right),
      reason: 'the bracket must scroll horizontally',
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('the run banner shows only when there is a run', (tester) async {
    await tester.pumpApp(
      bracket(fixtures: [tie('SF', 1, 2)], rounds: wcRounds, ladder: wcLadder),
    );
    await tester.pumpAndSettle();
    expect(find.text('YOUR RUN'), findsNothing);

    await tester.pumpApp(
      bracket(
        fixtures: [tie('SF', 1, 2)],
        rounds: wcRounds,
        ladder: wcLadder,
        runSummary: 'Into the Semi-finals',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('YOUR RUN'), findsOneWidget);
    expect(find.text('Into the Semi-finals'), findsOneWidget);
  });

  testWidgets('an undecided tie reads "vs" rather than a score', (
    tester,
  ) async {
    await tester.pumpApp(
      bracket(fixtures: [tie('SF', 1, 2)], rounds: wcRounds, ladder: wcLadder),
    );
    await tester.pumpAndSettle();
    expect(find.text('vs'), findsOneWidget);
  });

  group('playerRunSummary', () {
    test('is prefix-agnostic, so continental rounds work', () {
      // 'CFINAL' must read as a final, not an unknown round.
      expect(
        playerRunSummary(
          playerNationId: 1,
          champion: null,
          knockout: [tie('CFINAL', 1, 2, hs: 0, as: 1)],
          groups: const [],
          championTitle: 'Winners!',
        ),
        'Runners-up',
      );
      expect(
        playerRunSummary(
          playerNationId: 1,
          champion: 1,
          knockout: [tie('CFINAL', 1, 2, hs: 2, as: 1)],
          groups: const [],
          championTitle: 'Winners!',
        ),
        'Winners!',
      );
    });

    test('reports the deepest round reached', () {
      expect(
        playerRunSummary(
          playerNationId: 1,
          champion: 9,
          knockout: [
            tie('R16', 1, 5, hs: 1, as: 0),
            tie('QF', 1, 6, hs: 0, as: 2),
          ],
          groups: const [],
          championTitle: 'Winners!',
        ),
        'Knocked out in the Quarter-finals',
      );
    });

    test('a nation that never reached the finals has no run', () {
      expect(
        playerRunSummary(
          playerNationId: 99,
          champion: 1,
          knockout: [tie('QF', 1, 2, hs: 1, as: 0)],
          groups: const [],
          championTitle: 'Winners!',
        ),
        isNull,
      );
    });
  });

  test('baseRound strips a competition prefix', () {
    expect(baseRound('CQF'), 'QF');
    expect(baseRound('C3RD'), '3RD');
    expect(baseRound('CFINAL'), 'FINAL');
    expect(baseRound('QF'), 'QF');
    expect(baseRound('FINAL'), 'FINAL');
  });

  // Both phone widths in both languages. A bracket tie is two nations and a
  // scoreline, and the scoreline is the whole content of the screen — so the
  // longest nation names the world holds are given to it on purpose.
  for (final width in [360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the knockout ties hold at ${width.toInt()}px in '
        '${locale.languageCode}',
        (tester) async {
          tester.view
            ..devicePixelRatio = 1
            ..physicalSize = Size(width, 1000);
          addTearDown(tester.view.reset);

          await tester.pumpApp(
            Scaffold(
              body: TournamentBracket(
                fixtures: [
                  tie('SF', 100, 101, hs: 3, as: 2),
                  tie('SF', 102, 103, hs: 1, as: 0),
                  tie('3RD', 101, 103, hs: 2, as: 2),
                  tie('FINAL', 100, 102, hs: 4, as: 3),
                ],
                rounds: wcRounds,
                ladder: wcRounds,
                champion: 100,
                championLabel: 'CHAMPIONS',
                playerNationId: 1,
                code: code,
                // The longest names in the shipped nation pool.
                name: (id) => switch (id) {
                  100 => 'Bosnia and Herzegovina',
                  101 => 'Trinidad and Tobago',
                  102 => 'Central African Republic',
                  _ => 'Saint Vincent and the Grenadines',
                },
              ),
            ),
            locale: locale,
          );
          await tester.pumpAndSettle();

          expectLocale(
            tester,
            find.byType(TournamentBracket),
            locale.languageCode,
          );
          expectNothingCut(tester, 'the bracket in ${locale.languageCode}');
        },
      );
    }
  }
}
