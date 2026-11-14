import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/features/tournaments/drawn_groups.dart';
import 'package:fnm/features/tournaments/euro_playoff_draw_screen.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_screen.dart';
import 'package:fnm/features/tournaments/wc_playoff_draw_screen.dart';
import 'package:fnm/features/tournaments/wc_playoff_providers.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// The World Championship's calendar2 play-offs on screen: Europe's paths
/// and the intercontinental paths read from what is stored, the finals'
/// groups with a placeholder for every path winner, and the finals draw
/// ceremony telling a manager in the play-offs where his path's winner was
/// drawn. Never drawn here.
void main() {
  const codes = [
    'ENG', 'FRA', 'GER', 'ESP', 'ITA', 'NED', 'POR', 'BEL', //
    'CRO', 'DEN', 'SUI', 'AUT', 'POL', 'SWE', 'NOR', 'CZE',
    'JAM', 'IRQ', 'BOL', 'SUR', 'COD', 'NCL',
  ];
  final nations = {
    for (final (i, code) in codes.indexed)
      i + 1: Nation(
        id: i + 1,
        name: 'Nation ${i + 1}',
        code: code,
        confederation: i < 16 ? Confederation.europe : Confederation.asia,
        ranking: i + 1,
      ),
  };

  const pathA = (letter: 'A', seeds: [1, 2, 3, 4], finalHostSemi: 1);
  const pathB = (letter: 'B', seeds: [5, 6, 7, 16], finalHostSemi: 0);
  const ic1 = (path: '1', seed: 17, semiHome: 19, semiAway: 22);
  const ic2 = (path: '2', seed: 18, semiHome: 20, semiAway: 21);
  DrawSlot slot(String g, int pos, {int? id, String? key}) => (
    groupName: g,
    position: pos,
    nationId: id,
    placeholderKey: key,
    resolvedNationId: null,
  );
  final finalsSlots = [
    slot('A', 0, id: 8),
    slot('A', 1, id: 9),
    slot('A', 2, id: 10),
    slot('A', 3, key: UefaWcPlayoffs.placeholderKey('B')),
    slot('B', 0, id: 11),
    slot('B', 1, id: 12),
    slot('B', 2, id: 13),
    slot('B', 3, key: IcPlayoffs.placeholderKey('1')),
    slot('C', 0, id: 14),
    slot('C', 1, id: 15),
    slot('C', 2, key: UefaWcPlayoffs.placeholderKey('A')),
    slot('C', 3, key: IcPlayoffs.placeholderKey('2')),
  ];
  Fixture fx(
    int id,
    String round,
    int home,
    int away, {
    int? hs,
    int? as,
  }) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    matchday: 99,
    date: DateTime(2030, 3, 26),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: hs != null,
    round: round,
  );

  WcPlayoffData data({int player = 16}) => WcPlayoffData(
    uefaPaths: const [pathA, pathB],
    icPaths: const [ic1, ic2],
    fixtures: [
      fx(1, UefaWcPlayoffs.semiRound, 1, 4, hs: 2, as: 1),
      fx(2, UefaWcPlayoffs.semiRound, 2, 3, hs: 0, as: 1),
      fx(3, UefaWcPlayoffs.semiRound, 5, 16),
      fx(4, UefaWcPlayoffs.semiRound, 6, 7),
      fx(5, IcPlayoffs.semiRound, 19, 22, hs: 3, as: 0),
      fx(6, IcPlayoffs.semiRound, 20, 21),
      fx(7, IcPlayoffs.finalRound, 17, 19),
    ],
    finalsSlots: finalsSlots,
    nations: nations,
    playerNationId: player,
  );

  testWidgets('Europe\'s paths and the intercontinental paths, with each '
      'winner\'s finals group', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: WcPlayoffPaths(data: data(), headings: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wcPlayoff.uefa.A')), findsOneWidget);
    expect(find.byKey(const Key('wcPlayoff.uefa.B')), findsOneWidget);
    expect(find.byKey(const Key('wcPlayoff.ic.1')), findsOneWidget);
    expect(find.byKey(const Key('wcPlayoff.ic.2')), findsOneWidget);
    // The manager's path is marked, once.
    expect(
      find.descendant(
        of: find.byKey(const Key('wcPlayoff.uefa.B')),
        matching: find.text('Your path'),
      ),
      findsOneWidget,
    );
    expect(find.text('Your path'), findsOneWidget);
    expect(find.text('The winner goes to Group A'), findsOneWidget);
    expect(find.text('The winner goes to Group C'), findsNWidgets(2));
    expect(find.text('The winner goes to Group B'), findsOneWidget);
    // Path 1's final is set (the seed against the semi's winner); path 2's
    // seed waits.
    expect(
      find.descendant(
        of: find.byKey(const Key('wcPlayoff.ic.2')),
        matching: find.text('Seeded into the path final'),
      ),
      findsOneWidget,
    );
    expect(
      find.text('Nation 18 v the winner of the semi-final'),
      findsOneWidget,
    );
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('the draw screen: the European paths only, then continue', (
    tester,
  ) async {
    final db = createTestDatabase();
    addTearDown(db.close);
    await tester.pumpApp(
      const WcPlayoffDrawScreen(careerId: 1),
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        wcPlayoffProvider.overrideWith((ref, id) async => data()),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wcPlayoff.uefa.A')), findsOneWidget);
    expect(find.byKey(const Key('wcPlayoff.ic.1')), findsNothing);
    expect(find.byKey(WcPlayoffDrawScreen.continueKey), findsOneWidget);
  });

  testWidgets('the finals groups name each placeholder until it is won', (
    tester,
  ) async {
    final stored = wcDrawWithPlaceholders(finalsSlots);
    await tester.pumpApp(
      Scaffold(
        body: EuroPendingGroups(
          draw: stored.draw,
          letters: {
            for (final e in stored.keys.entries)
              e.key: wcPlaceholderMark(e.value),
          },
          labels: {
            for (final e in stored.keys.entries) e.key: 'L:${e.value}',
          },
          playerNationId: 16,
          playerPathLetter: 'B',
          code: (id) => nations[id]?.code ?? '??',
          name: (id) => nations[id]?.name ?? '?',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('L:UEFA-B'), findsOneWidget);
    expect(find.text('L:IC-1'), findsOneWidget);
    expect(find.text('L:IC-2'), findsOneWidget);
    expect(find.text('Nation 8'), findsOneWidget);
    // In the slots they were drawn into.
    expect(stored.keys[stored.draw.groups[0].nationIds[3]], 'UEFA-B');
    expect(stored.keys[stored.draw.groups[2].nationIds[2]], 'UEFA-A');
  });

  testWidgets('the finals draw ceremony: "your group if you win Path B"', (
    tester,
  ) async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final stored = wcDrawWithPlaceholders(finalsSlots);
    final drawData = FinalsDrawData(
      draw: stored.draw,
      nations: nations,
      playerNationId: 16,
      potByNation: potsFromGroups([
        for (final g in stored.draw.groups)
          (name: g.name, nationIds: g.nationIds),
      ]),
      cycle: 0,
      alreadyWatched: false,
      placeholderKeys: stored.keys,
      playerPathKey: UefaWcPlayoffs.placeholderKey('B'),
    );
    expect(drawData.highlightId, UefaWcPlayoffs.pseudoId(1));
    expect(drawData.playerPathGroup, 'A');
    await tester.pumpApp(
      const FinalsDrawScreen(careerId: 1),
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        finalsDrawProvider.overrideWith((ref, id) async => drawData),
      ],
    );
    await tester.pumpAndSettle();
    // The pots name the placeholders (pot 4, at the foot of the list).
    await tester.scrollUntilVisible(
      find.text('European Path B winner'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('European Path B winner'), findsOneWidget);
    expect(find.text('Intercontinental Path 1 winner'), findsOneWidget);
    await tester.tap(find.text('Start the draw'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(FinalsDrawScreen.pathNoteKey), findsOneWidget);
    expect(
      find.text('Your group if you win Path B: Group A'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  test('a manager drawn straight in follows his own ball', () {
    final stored = wcDrawWithPlaceholders(finalsSlots);
    final d = FinalsDrawData(
      draw: stored.draw,
      nations: nations,
      playerNationId: 8,
      potByNation: const {},
      cycle: 0,
      alreadyWatched: false,
      placeholderKeys: stored.keys,
    );
    expect(d.highlightId, 8);
    expect(d.playerPathGroup, isNull);
    expect(EuroPlayoffs.letterOf('UEFA-B'), isNull);
  });
}
