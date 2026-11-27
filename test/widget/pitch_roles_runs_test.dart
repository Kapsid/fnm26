import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// Roles and runs on the one tactics pitch: no Players / Roles & runs
/// switch. Each disc wears a role badge that opens the slot's sheet (roles
/// with what they do and how they suit the man, and the runs), and an arrow
/// mark, the full-backs' push mark's own, that moves his run on one tap. A
/// tap or a drag on the disc itself still picks or swaps the man. On a 360
/// phone with large text and on a tablet.
void main() {
  // 4-3-3: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm, 6 cm, 7 cm, 8 lw, 9 st, 10 rw.
  const f = Formation.f433;
  Map<int, Player> squad() => {
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'Player${String.fromCharCode(65 + i)}',
        position: f.positions[i],
        // Technique is their strength: a playmaker suits them, a runner's
        // job does not.
        attributes: const PlayerAttributes(
          physical: 66,
          technical: 82,
          stamina: 64,
        ),
      ),
  };

  late Tactic tactic;
  late List<int> tapped;
  late List<(int, int)> swapped;

  Widget harness({bool editable = true}) {
    tactic = Tactic(
      formation: f,
      lineup: [for (var i = 0; i < 11; i++) 100 + i],
    );
    tapped = [];
    swapped = [];
    final byId = squad();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => ListView(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: TacticsPitch(
                formation: tactic.formation,
                instructions: tactic.instructions,
                lineup: tactic.lineup,
                byId: byId,
                fullBacks: tactic.fullBacks,
                roles: pitchRolesOf(tactic),
                arrows: pitchArrowsOf(tactic),
                onTapSlot: tapped.add,
                onSwap: (a, b) => swapped.add((a, b)),
                onBenchIn: (_, _) {},
                onCycleFullBack: !editable
                    ? null
                    : (side) async {
                        setState(
                          () => tactic = tactic.copyWith(
                            fullBacks: tactic.fullBacks.cycled(side),
                          ),
                        );
                        return tactic.fullBacks.of(side);
                      },
                onCycleArrow: !editable
                    ? null
                    : (slot) async {
                        setState(
                          () => tactic = tactic.withArrow(
                            slot,
                            nextPitchArrow(
                              tactic.positions[slot],
                              tactic.arrowAt(slot),
                            ),
                          ),
                        );
                        return tactic.arrowAt(slot);
                      },
                onPlanSlot: !editable
                    ? null
                    : (slot) => showSlotPlanSheet(
                        context,
                        position: tactic.positions[slot],
                        player: byId[tactic.lineup[slot]],
                        role: tactic.roleAt(slot),
                        arrow: tactic.arrowAt(slot),
                        onRole: (r) =>
                            setState(() => tactic = tactic.withRole(slot, r)),
                        onArrow: (a) =>
                            setState(() => tactic = tactic.withArrow(slot, a)),
                      ),
              ),
            ),
            const PitchRunLegend(),
          ],
        ),
      ),
    );
  }

  void phone(WidgetTester tester, {double width = 360}) {
    tester.view
      ..physicalSize = Size(width, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget large(Widget child, double scale) => Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    ),
  );

  testWidgets('one pitch: no switch, and the legend and hint always shown', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    expect(find.byType(SegmentedButton<bool>), findsNothing);
    expect(find.text('Roles & runs'), findsNothing);
    expect(find.byKey(PitchPlanKeys.legend), findsOneWidget);
    expect(find.byKey(PitchPlanKeys.hint), findsOneWidget);
    // Every filled disc has a role badge; every outfield man an arrow mark
    // (the full-backs their push mark), the keeper none.
    for (var s = 0; s < 11; s++) {
      expect(find.byKey(PitchPlanKeys.badge(s)), findsOneWidget, reason: '$s');
    }
    expect(find.byKey(PitchPlanKeys.runMark(0)), findsNothing);
    for (final s in [1, 4]) {
      expect(find.byKey(ValueKey('pitchFullBack$s')), findsOneWidget);
      expect(find.byKey(PitchPlanKeys.runMark(s)), findsNothing);
    }
    for (final s in [2, 3, 5, 6, 7, 8, 9, 10]) {
      expect(find.byKey(PitchPlanKeys.runMark(s)), findsOneWidget);
    }
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing, reason: 'no runs');
  });

  testWidgets('a tap on the disc picks a player; the badge opens the sheet', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    await tester.tap(find.byKey(const ValueKey('pitchDisc6')));
    await tester.pumpAndSettle();
    expect(tapped, [6]);
    expect(find.byKey(PitchPlanKeys.sheet), findsNothing);

    await tester.tap(find.byKey(PitchPlanKeys.badge(6)));
    await tester.pumpAndSettle();
    expect(tapped, [6], reason: 'the badge is not the player picker');
    expect(find.byKey(PitchPlanKeys.sheet), findsOneWidget);
    // A central midfielder's options, with how each suits a technician.
    for (final r in PlayerRoleX.optionsFor(PlayerPosition.cm)) {
      expect(find.byKey(PitchPlanKeys.role(r)), findsOneWidget);
    }
    expect(
      find.descendant(
        of: find.byKey(PitchPlanKeys.fit(PlayerRole.playmaker)),
        matching: find.text('Good fit'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(PitchPlanKeys.fit(PlayerRole.boxToBox)),
        matching: find.text('Poor fit'),
      ),
      findsOneWidget,
    );
    expect(find.text('Creates chances. Far more assists.'), findsOneWidget);

    await tester.tap(find.byKey(PitchPlanKeys.role(PlayerRole.playmaker)));
    await tester.pumpAndSettle();
    expect(tactic.roleAt(6), PlayerRole.playmaker);
    // A central man has no sideways runs.
    expect(find.byKey(PitchPlanKeys.arrow(MoveArrow.inside)), findsNothing);
    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.sheet), findsNothing);
    expect(find.byKey(PitchPlanKeys.tag(6)), findsOneWidget);
    expect(find.byKey(PitchPlanKeys.tag(7)), findsNothing);
  });

  testWidgets('the badge is a 32-point target clear of the arrow mark', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    for (var s = 0; s < 11; s++) {
      final badge = tester.getRect(find.byKey(PitchPlanKeys.badge(s)));
      expect(badge.width, greaterThanOrEqualTo(32 - 1e-6), reason: '$s');
      expect(badge.height, greaterThanOrEqualTo(32 - 1e-6), reason: '$s');
      // Wholly inside the man's own node, so all of it takes the tap.
      final disc = tester.getRect(find.byKey(ValueKey('pitchDisc$s')));
      expect(badge.top, greaterThanOrEqualTo(disc.top - 7.5), reason: '$s');
      expect(badge.right, lessThanOrEqualTo(disc.right + 5), reason: '$s');
      // Clear of the disc's centre: a tap on the man is his.
      expect(badge.contains(disc.center), isFalse, reason: '$s');
      final mark = s == 1 || s == 4
          ? find.byKey(ValueKey('pitchFullBack$s'))
          : find.byKey(PitchPlanKeys.runMark(s));
      if (mark.evaluate().isEmpty) continue;
      final m = tester.getRect(mark);
      expect(badge.overlaps(m), isFalse, reason: '$s');
    }
  });

  testWidgets("a tap on the arrow mark walks the slot's runs and back", (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    // The left winger: all six runs a wide man has, then none again.
    final seen = <MoveArrow>[];
    for (var i = 0; i <= MoveArrowX.optionsFor(PlayerPosition.lw).length; i++) {
      await tester.tap(find.byKey(PitchPlanKeys.runMark(8)));
      await tester.pumpAndSettle();
      seen.add(tactic.arrowAt(8));
    }
    expect(seen, [
      ...MoveArrowX.optionsFor(PlayerPosition.lw),
      MoveArrow.none,
    ]);
    expect(tapped, isEmpty, reason: 'the mark is not the player picker');
    expect(swapped, isEmpty);

    // A centre-back has one run: forward, then none.
    await tester.tap(find.byKey(PitchPlanKeys.runMark(2)));
    await tester.pumpAndSettle();
    expect(tactic.arrowAt(2), MoveArrow.forward);
    expect(tactic.arrows.bySlot[2], MoveArrow.forward, reason: 'stored');
    await tester.tap(find.byKey(PitchPlanKeys.runMark(2)));
    await tester.pumpAndSettle();
    expect(tactic.arrowAt(2), MoveArrow.none);

    // The striker's run is drawn solid, his role's dashed one gone.
    await tester.tap(find.byKey(PitchPlanKeys.runMark(9)));
    await tester.pumpAndSettle();
    final painter =
        tester.widget<CustomPaint>(find.byKey(PitchPlanKeys.arrows)).painter!
            as PitchRunsPainter;
    expect(
      {for (final r in painter.runs) r.slot: r.run},
      {
        9: const PitchRun.manual(MoveArrow.forward),
      },
    );
  });

  testWidgets("a full-back's mark keeps his push, stored as before", (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    await tester.tap(find.byKey(const ValueKey('pitchFullBack1')));
    await tester.pumpAndSettle();
    expect(tactic.fullBacks, const FullBackPushes(left: FullBackPush.up));
    expect(tactic.arrows, SlotArrows.none);
    expect(tactic.arrowAt(1), MoveArrow.forward);
    await tester.tap(find.byKey(const ValueKey('pitchFullBack1')));
    await tester.pumpAndSettle();
    expect(tactic.arrowAt(1), MoveArrow.back);
    expect(tapped, isEmpty);
  });

  testWidgets('a hold and drag on a disc still swaps the two men', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    final from = tester.getCenter(find.byKey(const ValueKey('pitchDisc6')));
    final to = tester.getCenter(find.byKey(const ValueKey('pitchDisc7')));
    final g = await tester.startGesture(from);
    await tester.pump(const Duration(milliseconds: 300));
    await g.moveBy((to - from) / 2);
    await tester.pump();
    await g.moveTo(to);
    await tester.pump();
    await g.up();
    await tester.pumpAndSettle();
    expect(swapped, [(6, 7)]);
    expect(tactic.arrows, SlotArrows.none, reason: 'a drag draws no run');
    expect(find.byKey(PitchPlanKeys.sheet), findsNothing);
  });

  testWidgets('read-only, a pitch shows set roles only and no marks', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness(editable: false));
    for (var s = 0; s < 11; s++) {
      expect(find.byKey(PitchPlanKeys.badge(s)), findsNothing);
      expect(find.byKey(PitchPlanKeys.runMark(s)), findsNothing);
      expect(find.byKey(PitchPlanKeys.tag(s)), findsNothing);
    }
  });

  for (final scale in [1.0, 1.6]) {
    testWidgets('nothing is cut at 360 wide, text x$scale', (tester) async {
      phone(tester);
      await tester.pumpApp(large(harness(), scale));
      expectNothingCut(tester, 'the pitch and legend at x$scale');
      // The widest sheet: a winger, six runs and four roles.
      await tester.tap(find.byKey(PitchPlanKeys.badge(10)));
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the role sheet at x$scale');
      await tester.tap(find.byKey(PitchPlanKeys.close));
      await tester.pumpAndSettle();
    });

    testWidgets('nothing is cut in German at 360 wide, text x$scale', (
      tester,
    ) async {
      phone(tester);
      // German has the longest role names.
      await tester.pumpApp(
        large(harness(), scale),
        locale: const Locale('de'),
      );
      expectNothingCut(tester, 'the pitch and legend (de) at x$scale');
      await tester.tap(find.byKey(PitchPlanKeys.badge(4)));
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the full-back sheet (de) at x$scale');
    });
  }

  testWidgets('on a tablet the sheet opens and a role sticks', (tester) async {
    tester.view
      ..physicalSize = const Size(1194, 834)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(harness());
    await tester.tap(find.byKey(PitchPlanKeys.badge(9)));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.sheet), findsOneWidget);
    await tester.tap(find.byKey(PitchPlanKeys.role(PlayerRole.falseNine)));
    await tester.pumpAndSettle();
    expect(tactic.roleAt(9), PlayerRole.falseNine);
    expectNothingCut(tester, 'the tablet sheet');
    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);
    final badge = tester.getRect(find.byKey(PitchPlanKeys.badge(9)));
    expect(badge.width, greaterThanOrEqualTo(32 - 1e-6));
  });
}
