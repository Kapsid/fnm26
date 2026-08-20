import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/nation_squad_tab.dart';

import '../helpers/find_name.dart';
import '../helpers/pump_app.dart';

Player _p(int id, String name, PlayerPosition pos, int overall) => Player(
  id: id,
  nationId: 1,
  name: name,
  position: pos,
  age: 25,
  club: 'Club $id',
  attributes: PlayerAttributes(
    physical: overall,
    technical: overall,
    stamina: overall,
  ),
);

NationSquadRow _row(
  Player p, {
  int caps = 0,
  int goals = 0,
  bool calledUp = false,
  PlayerAbsence? absence,
}) => (
  player: p,
  caps: caps,
  goals: goals,
  calledUp: calledUp,
  starting: false,
  absence: absence,
  condition: null,
);

final _data = NationSquadData(
  rows: [
    _row(
      _p(1, 'Alonso', PlayerPosition.st, 88),
      caps: 40,
      goals: 20,
      calledUp: true,
    ),
    _row(_p(2, 'Barrow', PlayerPosition.cb, 80), caps: 12),
    _row(_p(3, 'Costa', PlayerPosition.cm, 76), calledUp: true),
    _row(_p(4, 'Duval', PlayerPosition.gk, 74)),
    _row(
      _p(5, 'Engel', PlayerPosition.lb, 70),
      absence: const PlayerAbsence(playerId: 5, injuryMatches: 2),
    ),
  ],
  calledUp: 2,
  saveSeed: 7,
);

/// The squad tab's controls.
///
/// The filters shipped as four stacked blocks of chips whose selected state was
/// only a border tint, so on a phone the pool was pushed off the screen and the
/// active filter was invisible. These pin the compacted strip down: it fits, it
/// says which slice is on, and it actually filters.
void main() {
  Future<void> pumpTab(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const Scaffold(body: NationSquadTab(careerId: 1)),
      overrides: [
        nationSquadProvider(1).overrideWith((ref) async => _data),
        absenceOutlookProvider(
          1,
        ).overrideWith((ref) async => const <int, AbsenceOutlook>{}),
        captainProvider(1).overrideWith((ref) async => null),
        captainMoraleProvider(1).overrideWith((ref) async => 0),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the filter strip fits a narrow phone', (tester) async {
    await pumpTab(tester);
    expect(find.text('EVERYONE'), findsOneWidget);
    expect(find.text('ALL LINES'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'the controls and rows must not overflow',
    );
  });

  testWidgets('the whole pool is listed by default', (tester) async {
    await pumpTab(tester);
    for (final name in ['Alonso', 'Barrow', 'Costa', 'Duval', 'Engel']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('Showing 5 of 5 players'), findsOneWidget);
  });

  testWidgets('the squad filter narrows the list to the called-up', (
    tester,
  ) async {
    await pumpTab(tester);
    await tester.tap(find.text('IN THE SQUAD'));
    await tester.pumpAndSettle();

    expect(find.text('Alonso'), findsOneWidget);
    expect(find.text('Costa'), findsOneWidget);
    expect(find.text('Barrow'), findsNothing);
    expect(find.text('Showing 2 of 5 players'), findsOneWidget);
  });

  testWidgets('the unavailable filter finds the injured player', (
    tester,
  ) async {
    await pumpTab(tester);
    await tester.ensureVisible(find.text('UNAVAILABLE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UNAVAILABLE'));
    await tester.pumpAndSettle();

    expect(find.text('Engel'), findsOneWidget);
    expect(find.text('Alonso'), findsNothing);
  });

  testWidgets('a line filter and a slice filter combine', (tester) async {
    await pumpTab(tester);
    await tester.tap(find.text('IN THE SQUAD'));
    await tester.pumpAndSettle();
    // The line chips sit to the right of the slice chips on one scrolling
    // strip, so on a narrow phone they have to be scrolled to.
    await tester.ensureVisible(find.text('MIDFIELD'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('MIDFIELD'));
    await tester.pumpAndSettle();

    expect(find.text('Costa'), findsOneWidget);
    expect(find.text('Alonso'), findsNothing, reason: 'a forward, not a mid');
    expect(find.text('Showing 1 of 5 players'), findsOneWidget);
  });

  testWidgets('sorting is a menu, not a row of chips', (tester) async {
    await pumpTab(tester);
    // Five sort orders used to take a labelled row of their own. Only the
    // active one is shown now, and the rest live behind it.
    expect(find.text('RATING'), findsOneWidget);
    expect(find.text('GOALS'), findsNothing, reason: 'no sort chip row');

    await tester.tap(find.text('RATING'));
    await tester.pumpAndSettle();
    // Opened: every order is offered, in sentence case (menu items, not chips).
    for (final order in ['Rating', 'Caps', 'Goals', 'Age', 'Name']) {
      expect(find.text(order), findsOneWidget);
    }

    await tester.tap(find.text('Caps'));
    await tester.pumpAndSettle();
    expect(find.text('Rating'), findsNothing, reason: 'the menu closed');
  });

  testWidgets('a very long surname is shown whole, not cut', (tester) async {
    // The reported bug: surnames arrived as "Papastathop…", which is not a
    // name, on the one screen whose whole job is telling the manager who is
    // in his pool.
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const Scaffold(body: NationSquadTab(careerId: 1)),
      overrides: [
        nationSquadProvider(1).overrideWith(
          (ref) async => NationSquadData(
            rows: [_row(_p(1, 'Papastathopoulos', PlayerPosition.cb, 82))],
            calledUp: 0,
            saveSeed: 7,
          ),
        ),
        absenceOutlookProvider(
          1,
        ).overrideWith((ref) async => const <int, AbsenceOutlook>{}),
        captainProvider(1).overrideWith((ref) async => null),
        captainMoraleProvider(1).overrideWith((ref) async => 0),
      ],
    );
    await tester.pumpAndSettle();

    expect(findName('Papastathopoulos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}