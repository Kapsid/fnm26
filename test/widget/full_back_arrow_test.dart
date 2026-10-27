import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// The full-back arrows on the tactics pitch: one on each full-back's disc,
/// cycling neutral, push on, hold back; none where the shape has no
/// full-back.
void main() {
  Map<int, Player> squadFor(Formation f) => {
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'P$i',
        position: f.positions[i],
      ),
  };

  /// A pitch whose arrows live in the harness, as the screens keep them.
  Widget harness(
    Formation formation, {
    FullBackPushes initial = FullBackPushes.neutral,
    bool editable = true,
    ValueChanged<int>? onTapSlot,
  }) {
    var arrows = initial;
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => ListView(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: TacticsPitch(
                formation: formation,
                instructions: const TacticalInstructions(),
                lineup: [for (var i = 0; i < 11; i++) 100 + i],
                byId: squadFor(formation),
                fullBacks: arrows,
                onCycleFullBack: editable
                    ? (side) async {
                        setState(() => arrows = arrows.cycled(side));
                        return arrows.of(side);
                      }
                    : null,
                onTapSlot: onTapSlot ?? (_) {},
                onSwap: (_, _) {},
                onBenchIn: (_, _) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  int slotOf(Formation f, PlayerPosition p) => f.positions.indexOf(p);

  testWidgets('tapping a full-back arrow cycles it: up, down, neutral', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(harness(Formation.f442));
    final lb = find.byKey(
      ValueKey('pitchFullBack${slotOf(Formation.f442, PlayerPosition.lb)}'),
    );
    final rb = find.byKey(
      ValueKey('pitchFullBack${slotOf(Formation.f442, PlayerPosition.rb)}'),
    );
    expect(lb, findsOneWidget);
    expect(rb, findsOneWidget);
    // Neutral reads as the dim two-way mark.
    expect(
      find.descendant(of: lb, matching: find.byIcon(Icons.unfold_more_rounded)),
      findsOneWidget,
    );

    await tester.tap(lb);
    await tester.pump();
    expect(
      find.descendant(
        of: lb,
        matching: find.byIcon(Icons.arrow_upward_rounded),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Left-back: push on'), findsOneWidget);

    await tester.tap(lb);
    await tester.pump();
    expect(
      find.descendant(
        of: lb,
        matching: find.byIcon(Icons.arrow_downward_rounded),
      ),
      findsOneWidget,
    );

    await tester.tap(lb);
    await tester.pump();
    expect(
      find.descendant(of: lb, matching: find.byIcon(Icons.unfold_more_rounded)),
      findsOneWidget,
    );
    // The other flank never moved.
    expect(
      find.descendant(of: rb, matching: find.byIcon(Icons.unfold_more_rounded)),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(lb.first),
      matchesSemantics(
        label: 'Left-back arrow: No instruction',
        isButton: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('a back three has no full-backs and no arrows', (tester) async {
    await tester.pumpApp(harness(Formation.f352));
    expect(
      find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('pitchFullBack'),
      ),
      findsNothing,
    );
  });

  testWidgets('a back five has both arrows', (tester) async {
    await tester.pumpApp(harness(Formation.f532));
    expect(
      find.byKey(
        ValueKey('pitchFullBack${slotOf(Formation.f532, PlayerPosition.lb)}'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        ValueKey('pitchFullBack${slotOf(Formation.f532, PlayerPosition.rb)}'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('read-only, only a set arrow is drawn', (tester) async {
    await tester.pumpApp(
      harness(
        Formation.f442,
        initial: const FullBackPushes(right: FullBackPush.up),
        editable: false,
      ),
    );
    expect(
      find.byKey(
        ValueKey('pitchFullBack${slotOf(Formation.f442, PlayerPosition.lb)}'),
      ),
      findsNothing,
    );
    expect(
      find.byKey(
        ValueKey('pitchFullBack${slotOf(Formation.f442, PlayerPosition.rb)}'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a tap on the ball beside the arrow opens the picker', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final taps = <int>[];
    await tester.pumpApp(harness(Formation.f442, onTapSlot: taps.add));
    final lbSlot = slotOf(Formation.f442, PlayerPosition.lb);
    final disc = find.byKey(ValueKey('pitchDisc$lbSlot'));
    final size = tester.getSize(disc).width;
    await tester.tapAt(
      tester.getCenter(disc) + Offset(-size * 0.2, -size * 0.2),
    );
    await tester.pump();
    expect(taps, [lbSlot], reason: 'the picker, not the arrow');
    expect(
      find.descendant(
        of: find.byKey(ValueKey('pitchFullBack$lbSlot')),
        matching: find.byIcon(Icons.unfold_more_rounded),
      ),
      findsOneWidget,
      reason: 'the arrow did not move',
    );
  });
}
