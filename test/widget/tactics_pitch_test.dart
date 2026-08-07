import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// The pitch's drag-and-drop: hold a player briefly, drag them onto another
/// slot. The hold is what beats the surrounding ListView's scroll gesture.
void main() {
  // A full XI, one player per slot, ids 100..110.
  final formation = Formation.f442;
  final lineup = [for (var i = 0; i < 11; i++) 100 + i];
  final byId = <int, Player>{
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'P$i',
        position: formation.positions[i],
      ),
  };

  Widget harness({
    required void Function(int, int) onSwap,
    void Function(int, int)? onBenchIn,
    void Function(int, double)? onMoveToSpace,
  }) {
    // The pitch lives inside a ListView in the real screen — that scroll view
    // is exactly what the drag gesture has to win the arena against.
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: TacticsPitch(
            formation: formation,
            instructions: const TacticalInstructions(),
            lineup: lineup,
            byId: byId,
            onTapSlot: (_) {},
            onSwap: onSwap,
            onBenchIn: onBenchIn ?? (_, __) {},
            onMoveToSpace: onMoveToSpace,
          ),
        ),
      ],
    );
  }

  /// A phone-sized surface tall enough for the whole 3:4 pitch, so every slot
  /// is on screen and hit-testable.
  void sizeSurface(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(420, 900);
    addTearDown(tester.view.reset);
  }

  test('the drag hold is shorter than a full long-press', () {
    // The framework default (500ms) reads as an unresponsive scroll: the page
    // moves and the player never lifts. These tests hold for exactly
    // kDragHoldDelay, so reverting to the default would fail them.
    expect(kDragHoldDelay, lessThan(kLongPressTimeout));
    expect(kDragHoldDelay, greaterThan(kPressTimeout));
  });

  testWidgets('holding briefly then dragging onto another slot swaps them',
      (tester) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // Two players in the same line, so the drag resolves to a plain swap.
    final from = tester.getCenter(find.text('P2'));
    final to = tester.getCenter(find.text('P3'));

    final gesture = await tester.startGesture(from);
    // Hold still past the drag delay so the drag beats the ListView's scroll.
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(swaps, isNotEmpty, reason: 'the drag should have reported a swap');
    expect(swaps.single, (2, 3));
  });

  testWidgets('dragging a player across lines reshapes rather than swapping',
      (tester) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // A defender onto a forward: different lines, so the screen resolves this
    // through resolveDrag (swap or reshape) — either way it must report.
    final gesture = await tester.startGesture(tester.getCenter(find.text('P2')));
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('P9')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(swaps.single, (2, 9));
  });

  testWidgets('a bench player can be dragged onto the pitch', (tester) async {
    sizeSurface(tester);
    final subs = <(int, int)>[];
    final bench = player(id: 200, nationId: 1, name: 'Sub One');
    // SubDragRow uses a ListTile, which needs the Material the real screen's
    // Scaffold provides.
    await tester.pumpApp(
      Scaffold(
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: TacticsPitch(
                formation: formation,
                instructions: const TacticalInstructions(),
                lineup: lineup,
                byId: byId,
                onTapSlot: (_) {},
                onSwap: (_, __) {},
                onBenchIn: (slot, id) => subs.add((slot, id)),
              ),
            ),
            SubDragRow(player: bench),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('Sub One')));
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(find.text('P9')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(subs.single, (9, 200), reason: 'the sub replaces the dragged-on slot');
  });

  testWidgets('dragging without holding first scrolls instead of swapping',
      (tester) async {
    sizeSurface(tester);
    final swaps = <(int, int)>[];
    await tester.pumpApp(harness(onSwap: (a, b) => swaps.add((a, b))));
    await tester.pumpAndSettle();

    // The hold is what disambiguates a player move from a list scroll, so an
    // immediate drag must scroll and leave the XI alone.
    await tester.drag(find.text('P2'), const Offset(0, -120));
    await tester.pumpAndSettle();

    expect(
      swaps,
      isEmpty,
      reason: 'an immediate drag is a scroll, not a player move',
    );
  });

  testWidgets('dropping a player in open space reports where he landed', (
    tester,
  ) async {
    sizeSurface(tester);
    int? movedSlot;
    double? movedY;
    await tester.pumpApp(
      harness(
        onSwap: (_, __) {},
        onMoveToSpace: (slot, dropY) {
          movedSlot = slot;
          movedY = dropY;
        },
      ),
    );
    await tester.pumpAndSettle();

    final pitch = tester.getRect(find.byType(TacticsPitch));
    // Pick a midfielder up and release him high up the pitch, in the space
    // wide of the forwards rather than on top of one.
    // P5 is a midfielder in 4-4-2 — the same naming the other drag tests use.
    final start = tester.getCenter(find.text('P5'));
    final gesture = await tester.startGesture(start);
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 40));
    await gesture.moveTo(
      Offset(pitch.left + pitch.width * 0.08, pitch.top + pitch.height * 0.10),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(movedSlot, isNotNull, reason: 'the space drop was never reported');
    expect(movedY, isNotNull);
    expect(movedY, lessThan(0.35), reason: 'dropped high up the pitch');
  });
}
