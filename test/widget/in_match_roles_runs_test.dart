import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';

import '../helpers/expect_whole.dart';
import '../helpers/in_match_editor.dart';

/// Roles and runs in the in-match editor: the same switch over its pitch,
/// the same sheet, a drawn run, and what is set comes back with the
/// confirmed setup. 4-4-2: slot 5 is the left midfielder, slot 9 a striker.
void main() {
  Future<void> setRoleAndRun(WidgetTester tester) async {
    await tester.tap(find.byKey(PitchPlanKeys.rolesMode).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pitchDisc9')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PitchPlanKeys.role(PlayerRole.poacher)));
    await tester.pumpAndSettle();
    expectNothingCut(tester, 'the in-match role sheet');
    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);

    // Hold the left midfielder and drag straight up the pitch.
    final lm = tester.getCenter(find.byKey(const ValueKey('pitchDisc5')));
    final g = await tester.startGesture(lm);
    await tester.pump(const Duration(milliseconds: 300));
    await g.moveBy(const Offset(0, -30));
    await tester.pump();
    await g.moveBy(const Offset(0, -40));
    await tester.pump();
    await g.up();
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.arrows), findsOneWidget);
    // The note says what was drawn, and offers to undo it.
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
    expect(find.byKey(PitchPlanKeys.bar), findsOneWidget);
    await setRoleAndRun(tester);
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    final r = outcome.result!;
    expect(r.roles.bySlot[9], PlayerRole.poacher);
    expect(r.arrows.bySlot[5], MoveArrow.forward);
  });

  testWidgets('undo puts the run back as it was', (tester) async {
    final outcome = await openEditor(tester, size: const Size(400, 2600));
    await setRoleAndRun(tester);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    expect(outcome.result!.arrows, SlotArrows.none);
    expect(outcome.result!.roles.bySlot[9], PlayerRole.poacher);
  });
}
