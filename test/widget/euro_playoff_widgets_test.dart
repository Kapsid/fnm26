import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_draw_screen.dart';
import 'package:fnm/features/tournaments/euro_playoff_draw_screen.dart';
import 'package:fnm/features/tournaments/euro_playoff_providers.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// The play-off paths, the EURO's groups with a placeholder per path, and
/// the finals draw ceremony telling a manager in the play-offs where his
/// path's winner was drawn: all read from what is stored, never drawn.
void main() {
  const codes = [
    'ENG', 'FRA', 'GER', 'ESP', 'ITA', 'NED', 'POR', 'BEL', //
    'CRO', 'DEN', 'SUI', 'AUT', 'POL', 'SWE', 'NOR', 'CZE',
  ];
  final nations = {
    for (final (i, code) in codes.indexed)
      i + 1: Nation(
        id: i + 1,
        name: 'Nation ${i + 1}',
        code: code,
        confederation: Confederation.europe,
        ranking: i + 1,
      ),
  };

  const pathA = (letter: 'A', seeds: [1, 2, 3, 4], finalHostSemi: 1);
  const pathB = (letter: 'B', seeds: [5, 6, 7, 16], finalHostSemi: 0);
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
    slot('A', 3, key: EuroPlayoffs.placeholderKey('B')),
    slot('B', 0, id: 11),
    slot('B', 1, id: 12),
    slot('B', 2, id: 13),
    slot('B', 3, key: EuroPlayoffs.placeholderKey('A')),
  ];
  Fixture semi(int id, int home, int away, {int? hs, int? as}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    matchday: 99,
    date: DateTime(2028, 3, 21),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: hs != null,
    round: EuroPlayoffs.semiRound,
  );

  EuroPlayoffData data({int player = 16}) => EuroPlayoffData(
    paths: const [pathA, pathB],
    fixtures: [
      semi(1, 1, 4, hs: 2, as: 1),
      semi(2, 2, 3, hs: 0, as: 1),
      semi(3, 5, 16),
      semi(4, 6, 7),
    ],
    finalsSlots: finalsSlots,
    nations: nations,
    playerNationId: player,
  );

  testWidgets('the paths: semis, the drawn final venue and the winner group', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(child: EuroPlayoffPaths(data: data())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Path A'), findsOneWidget);
    expect(find.text('Path B'), findsOneWidget);
    // The manager's path is marked, once.
    expect(find.text('Your path'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('euroPlayoff.path.B')),
        matching: find.text('Your path'),
      ),
      findsOneWidget,
    );
    expect(find.text('Semi-final 1'), findsNWidgets(2));
    // Path A's final at the home of semi-final 2's winner; path B's at 1's.
    expect(
      find.text('Final, hosted by the winner of semi-final 2'),
      findsOneWidget,
    );
    expect(
      find.text('Final, hosted by the winner of semi-final 1'),
      findsOneWidget,
    );
    expect(
      find.text('Winner of semi-final 2 v winner of semi-final 1'),
      findsOneWidget,
    );
    // The scores of the semis played, and each winner's finals group.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('The winner goes to Group B'), findsOneWidget);
    expect(find.text('The winner goes to Group A'), findsOneWidget);
  });

  testWidgets('the EURO groups name each path winner until it is won', (
    tester,
  ) async {
    final stored = drawWithPlaceholders(finalsSlots);
    await tester.pumpApp(
      Scaffold(
        body: EuroPendingGroups(
          draw: stored.draw,
          letters: stored.letters,
          playerNationId: 16,
          playerPathLetter: 'B',
          code: (id) => nations[id]?.code ?? '??',
          name: (id) => nations[id]?.name ?? '?',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Path B winner'), findsOneWidget);
    expect(find.text('Path A winner'), findsOneWidget);
    expect(find.text('Nation 8'), findsOneWidget);
    // In the slot it was drawn into: Group A's fourth place.
    expect(stored.draw.groups.first.name, 'A');
    expect(
      stored.letters[stored.draw.groups.first.nationIds[3]],
      'B',
      reason: 'path B winner in group A, position 4',
    );
    expect(find.byKey(const Key('euroPending.path.B')), findsOneWidget);
  });

  testWidgets('the finals draw ceremony: "your group if you win Path B"', (
    tester,
  ) async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final stored = drawWithPlaceholders(finalsSlots);
    await tester.pumpApp(
      const ContinentalDrawScreen(
        careerId: 1,
        confederation: Confederation.europe,
      ),
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        continentalDrawProvider.overrideWith(
          (ref, key) async => ContinentalDrawData(
            draw: FinalsDraw(groups: stored.draw.groups),
            nations: nations,
            playerNationId: 16,
            placeholderLetters: stored.letters,
            playerPathLetter: 'B',
          ),
        ),
      ],
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(ContinentalDrawScreen.pathNoteKey), findsOneWidget);
    expect(
      find.text('Your group if you win Path B: Group A'),
      findsOneWidget,
    );
    // Let the ceremony's timers run out before the test ends.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  test('the draw data lights the manager path ball and finds its group', () {
    final stored = drawWithPlaceholders(finalsSlots);
    final d = ContinentalDrawData(
      draw: stored.draw,
      nations: nations,
      playerNationId: 16,
      placeholderLetters: stored.letters,
      playerPathLetter: 'B',
    );
    expect(d.highlightId, EuroPlayoffs.pseudoId(1));
    expect(d.playerPathGroup, 'A');
    final direct = ContinentalDrawData(
      draw: stored.draw,
      nations: nations,
      playerNationId: 8,
    );
    expect(direct.highlightId, 8);
    expect(direct.playerPathGroup, isNull);
  });
}
