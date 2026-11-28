import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/player_slot_sheet.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/expect_whole.dart';
import '../helpers/in_match_editor.dart';

/// The set runs drawn on the pitch, by slot.
Map<int, PitchRun> _arrows(WidgetTester tester) {
  final f = find.byKey(PitchPlanKeys.arrows);
  if (f.evaluate().isEmpty) return const {};
  final painter =
      tester.widget<CustomPaint>(f.first).painter! as PitchRunsPainter;
  return {for (final r in painter.runs) r.slot: r.run};
}

/// Roles and runs in the in-match editor, on its one pitch: a tap on a disc
/// opens the man's sheet, where his place, role and run are set, and what
/// is set comes back with the confirmed setup. 4-4-2: slot 5 is the left
/// midfielder, slot 9 a striker.
void main() {
  Future<void> close(WidgetTester tester) async {
    Navigator.of(tester.element(find.byKey(SlotSheetKeys.sheet))).pop();
    await tester.pumpAndSettle();
  }

  Future<void> setRoleAndRun(WidgetTester tester) async {
    // No Players / Roles & runs switch: one pitch, its legend behind a
    // small info button.
    expect(find.byType(SegmentedButton<bool>), findsNothing);
    expect(find.byKey(PitchPlanKeys.legendButton), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pitchDisc9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SlotSheetKeys.role(PlayerRole.poacher)));
    await tester.pumpAndSettle();
    expectNothingCut(tester, 'the in-match sheet');
    await close(tester);
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);

    // The left midfielder's sheet: his first run, on the compass.
    await tester.tap(find.byKey(const ValueKey('pitchDisc5')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(SlotSheetKeys.run(MoveArrow.forward)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SlotSheetKeys.run(MoveArrow.forward)));
    await tester.pumpAndSettle();
    expect(_arrows(tester), {5: const PitchRun.manual(MoveArrow.forward)});
    // The caption says what he now does.
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.runCaption),
        matching: find.text('Get forward'),
      ),
      findsOneWidget,
    );
    await close(tester);
  }

  testWidgets('phone: a role and a run come back with the setup', (
    tester,
  ) async {
    final outcome = await openEditor(tester, size: const Size(400, 2600));
    await setRoleAndRun(tester);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    final r = outcome.result!;
    expect(r.roles, const SlotRoles({9: PlayerRole.poacher}));
    expect(r.arrows, const SlotArrows({5: MoveArrow.forward}));
  });

  testWidgets('tablet: the same, beside the lists', (tester) async {
    final outcome = await openEditor(
      tester,
      size: const Size(1194, 834),
      tabletLayout: true,
    );
    await setRoleAndRun(tester);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    final r = outcome.result!;
    expect(r.roles.bySlot[9], PlayerRole.poacher);
    expect(r.arrows.bySlot[5], MoveArrow.forward);
  });

  testWidgets('the centre of the compass gives the role its run back, and a '
      'place switched in the sheet comes back too', (tester) async {
    final outcome = await openEditor(tester, size: const Size(400, 2600));
    await setRoleAndRun(tester);
    await tester.tap(find.byKey(const ValueKey('pitchDisc5')));
    await tester.pumpAndSettle();
    // Each run the place offers in turn: only one is ever drawn.
    for (final a in MoveArrowX.optionsFor(PlayerPosition.lm)) {
      await tester.tap(find.byKey(SlotSheetKeys.run(a)));
      await tester.pumpAndSettle();
      expect(_arrows(tester), {5: PitchRun.manual(a)});
    }
    await tester.tap(find.byKey(SlotSheetKeys.run(MoveArrow.none)));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing);
    // Pushed on as a winger.
    await tester.tap(find.byKey(SlotSheetKeys.post(PlayerPosition.lw)));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pitchPos5')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('pitchPos5')),
        matching: find.text('LW'),
      ),
      findsOneWidget,
    );
    await close(tester);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    expect(outcome.result!.arrows, SlotArrows.none);
    expect(outcome.result!.roles.bySlot[9], PlayerRole.poacher);
    expect(outcome.result!.switches.bySlot[5], PlayerPosition.lw);
  });

  testWidgets('Swap in the sheet brings a man on through the sub rules', (
    tester,
  ) async {
    final outcome = await openEditor(tester, size: const Size(400, 2600));
    await tester.tap(find.byKey(const ValueKey('pitchDisc9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SlotSheetKeys.swap));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bench12').last);
    await tester.pumpAndSettle();
    // The sheet stays, on the man who came on.
    expect(
      find.descendant(
        of: find.byKey(SlotSheetKeys.sheet),
        matching: find.text('Bench12'),
      ),
      findsOneWidget,
    );
    await close(tester);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    expect(outcome.result!.lineup[9], 12);
  });
}
