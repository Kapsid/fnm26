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
/// chip per job, and per set piece the starters best first with the ordered
/// takers marked "1.", "2.", "3." (corners: one order per flag). The stores
/// underneath are the ones the engine reads, so every tap is checked against
/// what was stored.
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

  Finder cornerMark({
    required bool left,
    required int id,
    required String text,
  }) => find.descendant(
    of: find.byKey(TacticsScreen.cornerRowKey(left: left, playerId: id)),
    matching: find.text(text),
  );

  /// The starters as the lists rank them: outfielders by technical, best
  /// first, ties in line-up order, keepers last.
  List<int> ranked(List<Player> xi) {
    bool keeper(Player p) => p.position.category == PositionCategory.goalkeeper;
    final order = {for (var i = 0; i < xi.length; i++) xi[i].id: i};
    return [
      for (final p
          in [...xi]..sort((a, b) {
            if (keeper(a) != keeper(b)) return keeper(a) ? 1 : -1;
            final by = b.attributes.technical.compareTo(a.attributes.technical);
            return by != 0 ? by : order[a.id]!.compareTo(order[b.id]!);
          }))
        p.id,
    ];
  }

  Future<void> tapKey(WidgetTester tester, Key key) async {
    final target = find.byKey(key);
    // The list builds lazily: scroll down until the target exists.
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .last,
      );
    }
    // Scrolled to the middle, not the top edge: the chip row sits over the
    // top of the list, and a row parked under it takes no tap.
    await Scrollable.ensureVisible(tester.element(target), alignment: 0.5);
    await tester.pump();
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
    expect(find.text(enL.tacticsOrderTapHint), findsOneWidget);
    // Nobody named: only the coach's man, marked automatic.
    expect(find.text('1.'), findsOneWidget);
    expect(find.text('2.'), findsNothing);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.freeKicks));
    expect(find.text(enL.tacticsFreeKicksBlurb), findsOneWidget);
    expect(find.byKey(TacticsScreen.sameAsPenaltiesKey), findsOneWidget);

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.corners));
    expect(find.text(enL.tacticsCornersBlurb), findsOneWidget);
    expect(find.text(enL.tacticsCornersLeft.toUpperCase()), findsOneWidget);
    expect(find.text(enL.tacticsCornersRight.toUpperCase()), findsOneWidget);
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

  testWidgets("penalties: the coach's man first, taps build the order, a "
      'tap on a numbered man takes him off', (tester) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    const s = RolesSection.penalties;
    final r = ranked(xi);
    final best = SetPiecePicks.penalty(xi)!;
    expect(r.first, best);

    // Nobody named: the engine's own pick is 1., marked automatic.
    expect(mark(s, best, '1.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(TacticsScreen.takerRowKey(s, best)),
        matching: find.textContaining(enL.tacticsTakerAuto.toUpperCase()),
      ),
      findsOneWidget,
    );

    // Three taps, three places, in the order tapped.
    final a = r[4], b = r[1], c = r[6];
    await tapKey(tester, TacticsScreen.takerRowKey(s, a));
    expect((await stored(tester, save)).penalties, [a]);
    expect(mark(s, a, '1.'), findsOneWidget);
    expect(mark(s, best, '1.'), findsNothing);
    expect(
      find.textContaining(enL.tacticsTakerAuto.toUpperCase()),
      findsNothing,
    );
    await tapKey(tester, TacticsScreen.takerRowKey(s, b));
    await tapKey(tester, TacticsScreen.takerRowKey(s, c));
    expect((await stored(tester, save)).penalties, [a, b, c]);
    expect(mark(s, b, '2.'), findsOneWidget);
    expect(mark(s, c, '3.'), findsOneWidget);

    // A fourth tap on a full order takes the last place.
    final d = r[2];
    await tapKey(tester, TacticsScreen.takerRowKey(s, d));
    expect((await stored(tester, save)).penalties, [a, b, d]);
    expect(mark(s, d, '3.'), findsOneWidget);
    expect(mark(s, c, '3.'), findsNothing);

    // A numbered man tapped: off the order, the men behind him move up.
    await tapKey(tester, TacticsScreen.takerRowKey(s, a));
    expect((await stored(tester, save)).penalties, [b, d]);
    expect(mark(s, b, '1.'), findsOneWidget);
    expect(mark(s, d, '2.'), findsOneWidget);
    expect(mark(s, a, '1.'), findsNothing);

    // Everybody off: back to the coach.
    await tapKey(tester, TacticsScreen.takerRowKey(s, b));
    await tapKey(tester, TacticsScreen.takerRowKey(s, d));
    expect((await stored(tester, save)).penalties, isEmpty);
    expect(mark(s, best, '1.'), findsOneWidget);
  });

  testWidgets('pick best fills the order with the best men, and then has '
      'nothing to do', (tester) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    const s = RolesSection.penalties;
    final r = ranked(xi);

    await tapKey(tester, TacticsScreen.pickBestKey(s));
    expect((await stored(tester, save)).penalties, r.take(3).toList());
    expect(mark(s, r[0], '1.'), findsOneWidget);
    expect(mark(s, r[1], '2.'), findsOneWidget);
    expect(mark(s, r[2], '3.'), findsOneWidget);
    final button = tester.widget<OutlinedButton>(
      find.descendant(
        of: find.byKey(TacticsScreen.pickBestKey(s)),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('free kicks: same as penalties copies the order, the corners '
      'keep their own', (tester) async {
    final (:save, :xi) = await open(tester, sub: 'penalties');
    final r = ranked(xi);
    final a = r[5], b = r[3];
    await tapKey(tester, TacticsScreen.takerRowKey(RolesSection.penalties, a));
    await tapKey(tester, TacticsScreen.takerRowKey(RolesSection.penalties, b));

    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.freeKicks));
    await tapKey(tester, TacticsScreen.sameAsPenaltiesKey);
    final takers = await stored(tester, save);
    expect(takers.penalties, [a, b]);
    expect(takers.freeKicks, [a, b]);
    expect(takers.cornersLeft, isEmpty);
    expect(takers.cornersRight, isEmpty);
    expect(mark(RolesSection.freeKicks, a, '1.'), findsOneWidget);
    expect(mark(RolesSection.freeKicks, b, '2.'), findsOneWidget);

    // The corners are their own: still the coach's man on both flags.
    await tapKey(tester, TacticsScreen.sectionChipKey(RolesSection.corners));
    expect(cornerMark(left: true, id: a, text: '1.'), findsNothing);
    expect(cornerMark(left: true, id: r.first, text: '1.'), findsOneWidget);
    expect(cornerMark(left: false, id: r.first, text: '1.'), findsOneWidget);
  });

  testWidgets('corners: the left and right flags each keep their own order', (
    tester,
  ) async {
    final (:save, :xi) = await open(tester, sub: 'corners');
    final r = ranked(xi);
    final a = r[4], b = r[2], c = r[7];

    await tapKey(tester, TacticsScreen.cornerRowKey(left: true, playerId: a));
    await tapKey(tester, TacticsScreen.cornerRowKey(left: true, playerId: b));
    var takers = await stored(tester, save);
    expect(takers.cornersLeft, [a, b]);
    expect(takers.cornersRight, isEmpty);
    expect(cornerMark(left: true, id: a, text: '1.'), findsOneWidget);
    expect(cornerMark(left: true, id: b, text: '2.'), findsOneWidget);
    // The right flag still shows the coach's man, not the left's order.
    expect(cornerMark(left: false, id: a, text: '1.'), findsNothing);
    expect(cornerMark(left: false, id: r.first, text: '1.'), findsOneWidget);

    // Two men a flag: a third tap takes the second place.
    await tapKey(tester, TacticsScreen.cornerRowKey(left: true, playerId: c));
    expect((await stored(tester, save)).cornersLeft, [a, c]);

    await tapKey(tester, TacticsScreen.cornerPickBestKey(left: false));
    takers = await stored(tester, save);
    expect(takers.cornersRight, r.take(2).toList());
    expect(takers.cornersLeft, [a, c]);
    expect(takers.freeKicks, isEmpty);
    expect(cornerMark(left: false, id: r[1], text: '2.'), findsOneWidget);
    expect(tester.takeException(), isNull);
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
