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

/// The roles-and-runs mode of the tactics pitch: the switch above it, the
/// sheet a tap opens (roles with what they do and how they suit the man,
/// and the runs), the run drawn by holding and dragging a disc, the glyph a
/// role wears and the arrows drawn on the pitch. On a 360 phone with large
/// text and on a tablet.
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
  late List<MoveArrow> drawn;
  late List<int> tapped;

  Widget harness({bool startInRolesMode = false}) {
    tactic = Tactic(
      formation: f,
      lineup: [for (var i = 0; i < 11; i++) 100 + i],
    );
    drawn = [];
    tapped = [];
    var rolesMode = startInRolesMode;
    final byId = squad();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => ListView(
          children: [
            PitchPlanBar(
              rolesMode: rolesMode,
              onChanged: (on) => setState(() => rolesMode = on),
            ),
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
                rolesMode: rolesMode,
                onTapSlot: tapped.add,
                onSwap: (_, _) {},
                onBenchIn: (_, _) {},
                onPlanSlot: (slot) => showSlotPlanSheet(
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
                onDrawArrow: (slot, a) {
                  drawn.add(a);
                  setState(() => tactic = tactic.withArrow(slot, a));
                },
              ),
            ),
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

  testWidgets('players mode keeps the old gestures: a tap picks a player', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    expect(find.byKey(PitchPlanKeys.bar), findsOneWidget);
    expect(find.byKey(PitchPlanKeys.hint), findsNothing);
    await tester.tap(find.byKey(const ValueKey('pitchDisc6')));
    await tester.pumpAndSettle();
    expect(tapped, [6]);
    expect(find.byKey(PitchPlanKeys.sheet), findsNothing);
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing, reason: 'no runs');
  });

  testWidgets('roles mode: a tap opens the sheet; a role and a run stick', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness());
    await tester.tap(find.byKey(PitchPlanKeys.rolesMode));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.hint), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pitchDisc6')));
    await tester.pumpAndSettle();
    expect(tapped, isEmpty, reason: 'no player picker in roles mode');
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
    final forward = find.byKey(PitchPlanKeys.arrow(MoveArrow.forward));
    await tester.ensureVisible(forward);
    await tester.tap(forward);
    await tester.pumpAndSettle();
    expect(tactic.roleAt(6), PlayerRole.playmaker);
    expect(tactic.arrowAt(6), MoveArrow.forward);
    // A central man has no sideways runs.
    expect(find.byKey(PitchPlanKeys.arrow(MoveArrow.inside)), findsNothing);

    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.sheet), findsNothing);
    expect(find.byKey(PitchPlanKeys.tag(6)), findsOneWidget);
    expect(find.byKey(PitchPlanKeys.tag(7)), findsNothing);
    expect(find.byKey(PitchPlanKeys.arrows), findsOneWidget);
  });

  testWidgets("a full-back's run is his push arrow", (tester) async {
    phone(tester);
    await tester.pumpApp(harness(startInRolesMode: true));
    await tester.tap(find.byKey(const ValueKey('pitchDisc1')));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.arrow(MoveArrow.inside)), findsNothing);
    final forward = find.byKey(PitchPlanKeys.arrow(MoveArrow.forward));
    await tester.ensureVisible(forward);
    await tester.tap(forward);
    await tester.pumpAndSettle();
    expect(tactic.fullBacks, const FullBackPushes(left: FullBackPush.up));
    expect(tactic.arrows, SlotArrows.none);
  });

  testWidgets('hold and drag draws a run, snapped to the nearest one', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpApp(harness(startInRolesMode: true));
    // The left winger, dragged up and to the right: forward and inside.
    final lw = tester.getCenter(find.byKey(const ValueKey('pitchDisc8')));
    final g = await tester.startGesture(lw);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(PitchPlanKeys.preview), findsOneWidget);
    await g.moveBy(const Offset(20, -20));
    await tester.pump();
    await g.moveBy(const Offset(30, -30));
    await tester.pump();
    expect(find.text('Forward and inside'), findsOneWidget);
    await g.up();
    await tester.pumpAndSettle();
    expect(drawn, [MoveArrow.forwardInside]);
    expect(tactic.arrowAt(8), MoveArrow.forwardInside);
    expect(find.byKey(PitchPlanKeys.preview), findsNothing);

    // A short wiggle draws nothing.
    final again = await tester.startGesture(lw);
    await tester.pump(const Duration(milliseconds: 300));
    await again.moveBy(const Offset(4, -3));
    await tester.pump();
    await again.up();
    await tester.pumpAndSettle();
    expect(drawn, [MoveArrow.forwardInside]);
  });

  for (final scale in [1.0, 1.6]) {
    testWidgets('nothing is cut at 360 wide, text x$scale', (tester) async {
      phone(tester);
      await tester.pumpApp(large(harness(), scale));
      await tester.tap(find.byKey(PitchPlanKeys.rolesMode));
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the pitch bar at x$scale');
      // The widest sheet: a winger, six runs and four roles.
      await tester.tap(find.byKey(const ValueKey('pitchDisc10')));
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the role sheet at x$scale');
      // German has the longest role names.
      await tester.tap(find.byKey(PitchPlanKeys.close));
      await tester.pumpAndSettle();
    });

    testWidgets('nothing is cut in German at 360 wide, text x$scale', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpApp(
        large(harness(startInRolesMode: true), scale),
        locale: const Locale('de'),
      );
      expectNothingCut(tester, 'the pitch bar (de) at x$scale');
      await tester.tap(find.byKey(const ValueKey('pitchDisc4')));
      await tester.pumpAndSettle();
      expectNothingCut(tester, 'the full-back sheet (de) at x$scale');
    });
  }

  testWidgets('on a tablet the sheet opens and a role sticks', (tester) async {
    tester.view
      ..physicalSize = const Size(1194, 834)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(harness(startInRolesMode: true));
    await tester.tap(find.byKey(const ValueKey('pitchDisc9')));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.sheet), findsOneWidget);
    await tester.tap(find.byKey(PitchPlanKeys.role(PlayerRole.falseNine)));
    await tester.pumpAndSettle();
    expect(tactic.roleAt(9), PlayerRole.falseNine);
    expectNothingCut(tester, 'the tablet sheet');
    await tester.tap(find.byKey(PitchPlanKeys.close));
    await tester.pumpAndSettle();
    expect(find.byKey(PitchPlanKeys.tag(9)), findsOneWidget);
  });
}
