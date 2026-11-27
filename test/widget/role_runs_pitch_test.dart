import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

/// Where screenshots go when `ROLE_ARROW_SHOTS` names a folder; without it
/// the screens are only checked.
final String? _shotsDir = Platform.environment['ROLE_ARROW_SHOTS'];

Future<void> _shot(WidgetTester tester, String name) async {
  final dir = _shotsDir;
  if (dir == null) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(kAppRoot),
  );
  await tester.runAsync(() async {
    final img = await boundary.toImage(pixelRatio: 2);
    final png = await img.toByteData(format: ui.ImageByteFormat.png);
    Directory(dir).createSync(recursive: true);
    File('$dir/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
    img.dispose();
  });
}

/// The runs drawn in the layer keyed [key], by slot.
Map<int, PitchRun> _layer(WidgetTester tester, Key key) {
  final f = find.byKey(key);
  if (f.evaluate().isEmpty) return const {};
  final painter =
      tester.widget<CustomPaint>(f.first).painter! as PitchRunsPainter;
  return {for (final r in painter.runs) r.slot: r.run};
}

/// Every role draws its natural run on the tactics pitch, dashed, under the
/// arrows the manager sets; a set arrow takes the role run's place. On the
/// career tactics screen and in the in-match editor (its pitch and its list).
void main() {
  testWidgets('career tactics: role runs drawn, a set arrow overrides one', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final id = save.careerId;
    // The seeded side plays 4-3-3: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 dm,
    // 6 cm, 7 cm, 8 lw, 9 st, 10 rw.
    const roles = {
      0: PlayerRole.sweeperKeeper,
      1: PlayerRole.wingBack,
      2: PlayerRole.ballPlayingDefender,
      3: PlayerRole.coveringDefender,
      4: PlayerRole.invertedFullBack,
      5: PlayerRole.anchor,
      6: PlayerRole.boxToBox,
      7: PlayerRole.playmaker,
      8: PlayerRole.invertedWinger,
      9: PlayerRole.falseNine,
      10: PlayerRole.touchlineWinger,
    };
    // Straight to the store and the screen's own provider: the service's
    // writes also refresh the match preview and the hub's next event, which
    // this save never opened, and those left a future behind at teardown.
    final repo = save.container.read(tacticsRepositoryProvider);
    Future<void> change(Tactic Function(Tactic t) f) async {
      await tester.runAsync(() async {
        final t = (await repo.tacticForCareer(id))!;
        await repo.saveTactic(id, f(t));
      });
      save.container.invalidate(tacticDataProvider);
      await settle(tester);
    }

    await change((t) {
      var next = t;
      for (final e in roles.entries) {
        next = next.withRole(e.key, e.value);
      }
      // The right winger is told to come inside: his arrow, not his role's.
      return next.withArrow(10, MoveArrow.forwardInside);
    });
    await pumpRoute(tester, save, '${Routes.tactics}?careerId=$id');
    expect(find.byType(TacticsPitch), findsOneWidget);

    final shown = _layer(tester, PitchPlanKeys.roleRuns);
    for (final e in roles.entries) {
      if (e.key == 10) continue;
      expect(shown[e.key], PitchRun.role(e.value.run), reason: '${e.key}');
    }
    // Slot 10's role run is replaced by the arrow set there.
    expect(shown.containsKey(10), isFalse);
    expect(_layer(tester, PitchPlanKeys.arrows), {
      10: const PitchRun.manual(MoveArrow.forwardInside),
    });
    await _shot(tester, 'career_tactics_players_mode');

    // In the roles mode the legend says which line is which.
    await tester.tap(find.byKey(PitchPlanKeys.rolesMode));
    await settle(tester);
    expect(find.byKey(PitchPlanKeys.legend), findsOneWidget);
    expect(find.text(enL.tacticsRunLegendRole), findsOneWidget);
    expect(find.text(enL.tacticsRunLegendManual), findsOneWidget);
    await _shot(tester, 'career_tactics_roles_mode');

    // Taking the arrow off brings the role's run back.
    await change((t) => t.withArrow(10, MoveArrow.none));
    expect(
      _layer(tester, PitchPlanKeys.roleRuns)[10],
      const PitchRun.role(RoleRun.hugLine),
    );
    expect(find.byKey(PitchPlanKeys.arrows), findsNothing);
    // Let the screen go before the save's container does.
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });

  testWidgets('in-match: role runs on the pitch and in the list', (
    tester,
  ) async {
    // 4-4-2: 0 gk, 1 lb, 2 cb, 3 cb, 4 rb, 5 lm, 6 cm, 7 cm, 8 rm, 9 st,
    // 10 st.
    const roles = {
      1: PlayerRole.defensiveFullBack,
      2: PlayerRole.stopper,
      3: PlayerRole.ballPlayingDefender,
      4: PlayerRole.wingBack,
      5: PlayerRole.invertedWinger,
      6: PlayerRole.ballWinner,
      7: PlayerRole.boxToBox,
      8: PlayerRole.defensiveWinger,
      9: PlayerRole.targetMan,
      10: PlayerRole.pressingForward,
    };
    await openEditor(
      tester,
      size: const Size(390, 844),
      roles: const SlotRoles(roles),
      // The second striker is told to drop: his arrow, not his role's.
      arrows: const SlotArrows({10: MoveArrow.back}),
    );
    expect(Formation.f442.positions[5], PlayerPosition.lm);
    expect(Formation.f442.positions[8], PlayerPosition.rm);
    final shown = _layer(tester, PitchPlanKeys.roleRuns);
    for (final e in roles.entries) {
      if (e.key == 10) continue;
      expect(shown[e.key], PitchRun.role(e.value.run), reason: '${e.key}');
    }
    expect(shown.containsKey(10), isFalse);
    expect(shown.containsKey(0), isFalse, reason: 'no role, no run');
    expect(_layer(tester, PitchPlanKeys.arrows), {
      10: const PitchRun.manual(MoveArrow.back),
    });
    await _shot(tester, 'in_match_pitch');

    // The right-back's push mark is still reachable over his wing-back run,
    // and pushing him on replaces that run with his arrow.
    final mark = find.byKey(const ValueKey('pitchFullBack4'));
    expect(mark, findsOneWidget);
    await tester.tap(mark);
    await tester.pumpAndSettle();
    expect(
      _layer(tester, PitchPlanKeys.arrows)[4],
      const PitchRun.manual(MoveArrow.forward),
    );
    expect(_layer(tester, PitchPlanKeys.roleRuns).containsKey(4), isFalse);

    // The list of men on the pitch shows the same run beside each name.
    final chip = find.text(enL.tacticsTabOnPitch);
    await tester.ensureVisible(chip.first);
    await tester.pumpAndSettle();
    await tester.tap(chip.first);
    await tester.pumpAndSettle();
    final list = find.byKey(PitchPlanKeys.runGlyph(5));
    await tester.ensureVisible(list);
    await tester.pumpAndSettle();
    final glyph = tester.widget<PitchRunGlyph>(list);
    expect(glyph.run, const PitchRun.role(RoleRun.cutInside));
    expect(
      tester.widget<PitchRunGlyph>(find.byKey(PitchPlanKeys.runGlyph(10))).run,
      const PitchRun.manual(MoveArrow.back),
    );
    expect(find.byKey(PitchPlanKeys.runGlyph(0)), findsNothing);
    await _shot(tester, 'in_match_list');
  });
}
