import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/player_slot_sheet.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/slot_sheet_pitch.dart';

/// Position, role and run on the one tactics pitch: the discs are clean
/// (a small role glyph, the run line) and take no tap of their own on the
/// rim; a tap on the man opens his sheet, where his place within the shape,
/// his role and his run are set, each landing on the pitch at once. A hold
/// and drag still swaps. On a 360 phone with large text, in German, and on a
/// tablet.
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
    200: player(
      id: 200,
      nationId: 1,
      name: 'Benchman',
      position: f.positions[9],
    ),
  };

  SheetPitch harness() => SheetPitch(
    Tactic(formation: f, lineup: [for (var i = 0; i < 11; i++) 100 + i]),
    squad(),
    bench: [squad()[200]!],
  );

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

  testWidgets('clean discs: no rim targets, nothing drawn for nothing set', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness().build());
    for (var s = 0; s < 11; s++) {
      expect(find.byKey(PitchPlanKeys.tag(s)), findsNothing, reason: '$s');
      expect(find.byKey(ValueKey('pitchFullBack$s')), findsNothing);
    }
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing, reason: 'no runs');
    expect(find.byKey(PitchPlanKeys.roleRuns), findsNothing);
  });

  testWidgets('a tap on the disc opens his sheet: who he is, the roles with '
      'their fit and the best one starred', (tester) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 6);
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.sheet),
        matching: find.text('PlayerG'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(SlotSheetKeys.fit), findsOneWidget);
    expect(find.byKey(SlotSheetKeys.swap), findsOneWidget);
    expect(find.byKey(SlotSheetKeys.profile), findsOneWidget);
    // A central midfielder's options, with how each suits a technician.
    for (final r in PlayerRoleX.optionsFor(PlayerPosition.cm)) {
      expect(find.byKey(SlotSheetKeys.role(r)), findsOneWidget);
    }
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.roleFit(PlayerRole.playmaker)),
        matching: find.text('Good fit'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.roleFit(PlayerRole.boxToBox)),
        matching: find.text('Poor fit'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(SlotSheetKeys.recommended(PlayerRole.playmaker)),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.text('Creates chances. Far more assists.'), findsOneWidget);

    await tapInSheet(tester, SlotSheetKeys.role(PlayerRole.playmaker));
    expect(h.tactic.roleAt(6), PlayerRole.playmaker);
    expect(find.byKey(PitchPlanKeys.tag(6)), findsOneWidget, reason: 'live');
    // A central man has no sideways runs on his compass.
    expect(find.byKey(SlotSheetKeys.run(MoveArrow.inside)), findsNothing);
    expect(find.byKey(SlotSheetKeys.run(MoveArrow.forward)), findsOneWidget);
    await closeSlotSheet(tester);
    expect(find.byKey(PitchPlanKeys.tag(7)), findsNothing);
  });

  testWidgets("the position row switches the slot's place within the shape", (
    tester,
  ) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 6);
    // CM, and the two the shape allows it.
    for (final p in [PlayerPosition.cm, PlayerPosition.dm, PlayerPosition.am]) {
      expect(find.byKey(SlotSheetKeys.post(p)), findsOneWidget);
    }
    await tapInSheet(tester, SlotSheetKeys.post(PlayerPosition.am));
    expect(h.tactic.positions[6], PlayerPosition.am);
    expect(h.tactic.formation, f, reason: 'the shape stays');
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('pitchPos6')),
        matching: find.text('AM'),
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'Plays between the lines, behind the strikers.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    // An attacking midfielder's roles now.
    for (final r in PlayerRoleX.optionsFor(PlayerPosition.am)) {
      expect(find.byKey(SlotSheetKeys.role(r)), findsOneWidget);
    }
    await closeSlotSheet(tester);

    // A second switch, then the limit: a third slot cannot change.
    await openSlotSheet(tester, 7);
    await tapInSheet(tester, SlotSheetKeys.post(PlayerPosition.dm));
    await closeSlotSheet(tester);
    await openSlotSheet(tester, 10);
    expect(find.byKey(SlotSheetKeys.postLimit), findsOneWidget);
    await tapInSheet(tester, SlotSheetKeys.post(PlayerPosition.rm));
    expect(h.tactic.positions[10], PlayerPosition.rw, reason: 'refused');
    await closeSlotSheet(tester);
  });

  testWidgets('a centre-back and the keeper: no position row', (tester) async {
    phone(tester);
    await tester.pumpApp(harness().build());
    await openSlotSheet(tester, 2);
    expect(find.text('POSITION'), findsNothing);
    expect(find.byKey(SlotSheetKeys.run(MoveArrow.forward)), findsOneWidget);
    expect(find.byKey(SlotSheetKeys.run(MoveArrow.back)), findsNothing);
    await closeSlotSheet(tester);
    await openSlotSheet(tester, 0);
    expect(find.text('POSITION'), findsNothing);
    expect(find.text('A keeper has no run to set.'), findsOneWidget);
    await closeSlotSheet(tester);
  });

  testWidgets('the compass: one run per man, the centre is the role run', (
    tester,
  ) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
    // The right winger, an inverted winger: his role's run drawn dashed.
    await openSlotSheet(tester, 10);
    await tapInSheet(tester, SlotSheetKeys.role(PlayerRole.invertedWinger));
    expect(roleRunsOnPitch(tester)[10], const PitchRun.role(RoleRun.cutInside));
    expect(setRunsOnPitch(tester), isEmpty);
    // Every run a wide man has, each the only one drawn for him.
    for (final a in MoveArrowX.optionsFor(PlayerPosition.rw)) {
      await tapInSheet(tester, SlotSheetKeys.run(a));
      expect(h.tactic.arrowAt(10), a);
      expect(h.tactic.arrows.bySlot[10], a, reason: 'stored');
      expect(setRunsOnPitch(tester), {10: PitchRun.manual(a)});
      expect(
        roleRunsOnPitch(tester).containsKey(10),
        isFalse,
        reason: 'the set arrow replaces the role run',
      );
      expect(
        find.descendant(
          of: find.byKey(SlotSheetKeys.runCaption),
          matching: find.text(
            switch (a) {
              MoveArrow.forward => 'Get forward',
              MoveArrow.back => 'Sit deeper',
              MoveArrow.inside => 'Come inside',
              MoveArrow.outside => 'Stay wide',
              MoveArrow.forwardInside => 'Forward and inside',
              MoveArrow.forwardOutside => 'Forward and wide',
              MoveArrow.none => '',
            },
          ),
        ),
        findsOneWidget,
      );
    }
    // The centre: no arrow of his own, the role's run back.
    await tapInSheet(tester, SlotSheetKeys.run(MoveArrow.none));
    expect(h.tactic.arrowAt(10), MoveArrow.none);
    expect(setRunsOnPitch(tester), isEmpty);
    expect(roleRunsOnPitch(tester)[10], const PitchRun.role(RoleRun.cutInside));
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.runCaption),
        matching: find.text("Role's natural run"),
      ),
      findsOneWidget,
    );
    await closeSlotSheet(tester);
  });

  testWidgets('Swap brings the man on, and the sheet follows him', (
    tester,
  ) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 9);
    await tapInSheet(tester, SlotSheetKeys.swap);
    expect(h.tactic.lineup[9], 200);
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.sheet),
        matching: find.text('Benchman'),
      ),
      findsOneWidget,
    );
    await closeSlotSheet(tester);
  });

  testWidgets('Advanced is folded; open, its duties toggle', (tester) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 9);
    expect(find.byKey(SlotSheetKeys.toggle('penalty')), findsNothing);
    await tapInSheet(tester, SlotSheetKeys.advanced);
    await tapInSheet(tester, SlotSheetKeys.toggle('penalty'));
    expect(h.duties['penalty'], isTrue);
    await tapInSheet(tester, SlotSheetKeys.toggle('penalty'));
    expect(h.duties['penalty'], isFalse);
    await closeSlotSheet(tester);
  });

  testWidgets('without player pages there is no profile link', (
    tester,
  ) async {
    phone(tester);
    final h = harness()..playerPages = false;
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 9);
    expect(find.byKey(SlotSheetKeys.profile), findsNothing);
    expect(find.byKey(SlotSheetKeys.swap), findsOneWidget);
    await closeSlotSheet(tester);
  });

  testWidgets('a hold and drag on a disc still swaps the two men', (
    tester,
  ) async {
    phone(tester);
    final h = harness();
    await tester.pumpApp(h.build());
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
    expect(h.swapped, [(6, 7)]);
    expect(h.tactic.lineup[6], 107);
    expect(find.byKey(SlotSheetKeys.sheet), findsNothing, reason: 'no sheet');
  });

  testWidgets('the legend is behind a small info button', (tester) async {
    phone(tester);
    await tester.pumpApp(
      Scaffold(body: ListView(children: const [PitchHintRow()])),
    );
    expect(find.byKey(PitchPlanKeys.legend), findsNothing);
    await tester.tap(find.byKey(PitchPlanKeys.legendButton));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.legend), findsOneWidget);
    expectNothingCut(tester, 'the legend');
  });

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('nothing is cut at 360 wide, text x$scale', (tester) async {
      phone(tester);
      await tester.pumpApp(large(harness().build(), scale));
      expectNothingCut(tester, 'the pitch at x$scale');
      // The widest sheet: a winger, two places, four roles, six runs.
      await openSlotSheet(tester, 10);
      await tester.drag(
        find.byKey(SlotSheetKeys.sheet),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the winger sheet at x$scale');
      await closeSlotSheet(tester);
    });

    testWidgets('nothing is cut in German at 360 wide, text x$scale', (
      tester,
    ) async {
      phone(tester);
      // German has the longest role names.
      await tester.pumpApp(
        large(harness().build(), scale),
        locale: const Locale('de'),
      );
      expectNothingCut(tester, 'the pitch (de) at x$scale');
      for (final slot in [4, 8]) {
        await openSlotSheet(tester, slot);
        await tapInSheet(tester, SlotSheetKeys.advanced);
        expectNothingCut(tester, 'sheet $slot (de) at x$scale');
        await closeSlotSheet(tester);
      }
    });
  }

  testWidgets('on a tablet the sheet is a panel beside the pitch', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(1194, 834)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final h = harness();
    await tester.pumpApp(h.build());
    await openSlotSheet(tester, 9);
    await tapInSheet(tester, SlotSheetKeys.role(PlayerRole.falseNine));
    expect(h.tactic.roleAt(9), PlayerRole.falseNine);
    expectNothingCut(tester, 'the tablet panel');
    final panel = tester.getRect(find.byKey(SlotSheetKeys.sheet));
    expect(panel.right, lessThanOrEqualTo(1194));
    expect(panel.width, lessThanOrEqualTo(480));
    await closeSlotSheet(tester);
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);
  });
}
