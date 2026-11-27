import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
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

/// Roles and runs in the in-match editor, on its one pitch: the role badge
/// on a disc opens the same sheet, a tap on his arrow mark sets his run, and
/// what is set comes back with the confirmed setup. 4-4-2: slot 5 is the
/// left midfielder, slot 9 a striker.
void main() {
  Future<void> setRoleAndRun(WidgetTester tester) async {
    // No Players / Roles & runs switch: one pitch, with its legend.
    expect(find.byType(SegmentedButton<bool>), findsNothing);
    expect(find.byKey(PitchPlanKeys.legend), findsOneWidget);
    await tester.tap(find.byKey(PitchPlanKeys.badge(9)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PitchPlanKeys.role(PlayerRole.poacher)));
    await tester.pumpAndSettle();
    expectNothingCut(tester, 'the in-match role sheet');
    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);

    // One tap on the left midfielder's arrow mark: his first run.
    await tester.tap(find.byKey(PitchPlanKeys.runMark(5)));
    await tester.pumpAndSettle();
    expect(_arrows(tester), {5: const PitchRun.manual(MoveArrow.forward)});
    // The note says what he now does.
    expect(find.textContaining('Get forward'), findsOneWidget);
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

  testWidgets('tapping round every run the place offers comes back to none', (
    tester,
  ) async {
    final outcome = await openEditor(tester, size: const Size(400, 2600));
    await setRoleAndRun(tester);
    // The rest of a left midfielder's runs in turn, then none again.
    final seen = <MoveArrow>[MoveArrow.forward];
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(PitchPlanKeys.runMark(5)));
      await tester.pumpAndSettle();
      seen.add(_arrows(tester)[5]?.arrow ?? MoveArrow.none);
    }
    expect(seen, [
      ...MoveArrowX.optionsFor(PlayerPosition.lm),
      MoveArrow.none,
    ]);
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    expect(outcome.result!.arrows, SlotArrows.none);
    expect(outcome.result!.roles.bySlot[9], PlayerRole.poacher);
  });
}
