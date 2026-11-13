import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tactics/tactics_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The roles and set pieces tab as sub-tabs (1.1.2 redesign, variant A): one
/// chip per job, and per set piece the starters best first with the taker
/// marked "1." and the man after him "2.". The stores underneath are the
/// ones the engine reads, so every tap is checked against what was stored.
void main() {
  const size = Size(390, 1500);

  Future<({SeededSave save, List<Player> xi})> open(
    WidgetTester tester, {
    String sub = '',
  }) async {
    final save = await seedSave(tester);
    late List<Player> xi;
    await tester.runAsync(() async {
      final data = (await save.container.read(
        tacticDataProvider(save.careerId).future,
      ))!;
      xi = [
        for (final id in data.tactic.lineup.whereType<int>()) ?data.byId[id],
      ];
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=2'
      '${sub.isEmpty ? '' : '&sub=$sub'}',
      size: size,
    );
    return (save: save, xi: xi);
  }

  Future<SetPieceTakers> stored(WidgetTester tester, SeededSave save) async {
    late SetPieceTakers takers;
    await tester.runAsync(() async {
      takers = await save.container
          .read(setPieceTakersStoreProvider)
          .load(save.careerId);
    });
    return takers;
  }

  Finder mark(RolesSection s, int playerId, String text) => find.descendant(
    of: find.byKey(TacticsScreen.takerRowKey(s, playerId)),
    matching: find.text(text),
  );

  Future<void> tapKey(WidgetTester tester, Key key) async {
    await tester.ensureVisible(find.byKey(key));
    await tester.tap(find.byKey(key));
    await settle(tester, rounds: 10);
  }

  testWidgets('the chips switch between the six jobs', (tester) async {
    await open(tester);
    // Opens on the roles.
    expect(find.text(enL.tacticsRolesBlurb), findsOneWidget);
    expect(find.text(enL.tacticsTapToAssign), findsWidgets);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.captain));
    expect(find.text(enL.captainNone), findsOneWidget);
    expect(find.text(enL.tacticsRolesBlurb), findsNothing);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.penalties));
    expect(find.text(enL.tacticsPenaltiesBlurb), findsOneWidget);
    expect(find.text('1.'), findsOneWidget);
    expect(find.text('2.'), findsOneWidget);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.freeKicks));
    expect(find.text(enL.tacticsFreeKicksBlurb), findsOneWidget);
    expect(find.byKey(TacticsScreen.sameAsPenaltiesKey), findsOneWidget);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.corners));
    expect(find.text(enL.tacticsCornersBlurb), findsOneWidget);
    expect(find.byKey(TacticsScreen.sameAsPenaltiesKey), findsNothing);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.throwIns));
    expect(find.text(enL.tacticsThrowInsBlurb), findsOneWidget);
    expect(find.byType(ThrowInStylePicker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('?sub= opens the sub-tab the pre-match strip names', (
    tester,
  ) async {
    await open(tester, sub: 'captain');
    expect(find.text(enL.captainNone), findsOneWidget);
    expect(find.text(enL.tacticsRolesBlurb), findsNothing);
  });

  testWidgets("penalties: the coach's man first, a tap names a taker, a "
      'second tap hands it back', (tester) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    const s = RolesSection.penalties;
    final best = SetPiecePicks.penalty(xi)!;

    // Nobody named: the engine's own pick is 1., marked automatic.
    expect(mark(s, best, '1.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(TacticsScreen.takerRowKey(s, best)),
        matching: find.textContaining(enL.tacticsTakerAuto.toUpperCase()),
      ),
      findsOneWidget,
    );

    // Somebody else: an outfielder who is not the best.
    final other = xi.lastWhere(
      (p) => p.id != best && p.position.category != PositionCategory.goalkeeper,
    );
    await tapKey(tester, TacticsScreen.takerRowKey(s, other.id));
    expect((await stored(tester, save)).penalty, other.id);
    expect(mark(s, other.id, '1.'), findsOneWidget);
    // The best of the rest is who steps up if he goes off.
    expect(mark(s, best, '2.'), findsOneWidget);
    expect(
      find.textContaining(enL.tacticsTakerAuto.toUpperCase()),
      findsNothing,
    );

    // Tapped again: back to the coach.
    await tapKey(tester, TacticsScreen.takerRowKey(s, other.id));
    expect((await stored(tester, save)).penalty, isNull);
    expect(mark(s, best, '1.'), findsOneWidget);
    expect(mark(s, other.id, '1.'), findsNothing);
  });

  testWidgets("pick best names the coach's man, and then has nothing to do", (
    tester,
  ) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    const s = RolesSection.penalties;
    final best = SetPiecePicks.penalty(xi)!;

    await tapKey(tester, TacticsScreen.pickBestKey(s));
    expect((await stored(tester, save)).penalty, best);
    expect(mark(s, best, '1.'), findsOneWidget);
    final button = tester.widget<OutlinedButton>(
      find.descendant(
        of: find.byKey(TacticsScreen.pickBestKey(s)),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('free kicks: same as penalties, and the corners share him', (
    tester,
  ) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    final best = SetPiecePicks.penalty(xi)!;
    final other = xi.lastWhere(
      (p) => p.id != best && p.position.category != PositionCategory.goalkeeper,
    );
    await tapKey(
      tester,
      TacticsScreen.takerRowKey(RolesSection.penalties, other.id),
    );

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.freeKicks));
    await tapKey(tester, TacticsScreen.sameAsPenaltiesKey);
    final takers = await stored(tester, save);
    expect(takers.penalty, other.id);
    expect(takers.deadBall, other.id);
    expect(mark(RolesSection.freeKicks, other.id, '1.'), findsOneWidget);

    // One dead-ball man: the corners name him too.
    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.corners));
    expect(mark(RolesSection.corners, other.id, '1.'), findsOneWidget);
  });

  testWidgets('throw-ins: a tap names the thrower in the save', (
    tester,
  ) async {
    final (:save, :xi) = await open(tester, sub: 'throwIns');
    const s = RolesSection.throwIns;
    final best = SetPiecePicks.throwIn(xi)!;
    expect(mark(s, best, '1.'), findsOneWidget);

    final other = xi.lastWhere(
      (p) => p.id != best && p.position.category != PositionCategory.goalkeeper,
    );
    await tapKey(tester, TacticsScreen.takerRowKey(s, other.id));
    late int? thrower;
    await tester.runAsync(() async {
      thrower = await save.container
          .read(throwInTakerStoreProvider)
          .load(save.careerId);
    });
    expect(thrower, other.id);
    expect(mark(s, other.id, '1.'), findsOneWidget);
    expect(mark(s, best, '2.'), findsOneWidget);
  });
}
