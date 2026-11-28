import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/player_slot_sheet.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/slot_sheet_pitch.dart';

/// The full-backs' push on the tactics pitch: set in the man's sheet, where
/// his compass offers push on and hold back, and drawn as a mark on his disc
/// once set (an untouched one draws none). None where the shape has no
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

  SheetPitch pitch(
    Formation f, {
    FullBackPushes pushes = FullBackPushes.neutral,
  }) => SheetPitch(
    Tactic(
      formation: f,
      lineup: [for (var i = 0; i < 11; i++) 100 + i],
      fullBacks: pushes,
    ),
    squadFor(f),
  );

  int slotOf(Formation f, PlayerPosition p) => f.positions.indexOf(p);
  Finder mark(int slot) => find.byKey(ValueKey('pitchFullBack$slot'));

  void phone(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets("a full-back's sheet offers push on and hold back; the mark "
      'follows', (tester) async {
    phone(tester);
    final h = pitch(Formation.f442);
    await tester.pumpApp(h.build());
    final lb = slotOf(Formation.f442, PlayerPosition.lb);
    final rb = slotOf(Formation.f442, PlayerPosition.rb);
    expect(mark(lb), findsNothing, reason: 'untouched: no mark');

    await openSlotSheet(tester, lb);
    // Only his two runs on the compass, and the role's in the middle.
    for (final a in MoveArrow.values) {
      expect(
        find.byKey(SlotSheetKeys.run(a)),
        a == MoveArrow.none || a == MoveArrow.forward || a == MoveArrow.back
            ? findsOneWidget
            : findsNothing,
        reason: '$a',
      );
    }
    await tapInSheet(tester, SlotSheetKeys.run(MoveArrow.forward));
    expect(h.tactic.fullBacks.left, FullBackPush.up);
    expect(
      find.descendant(
        of: mark(lb),
        matching: find.byIcon(Icons.arrow_upward_rounded),
      ),
      findsOneWidget,
    );
    await tapInSheet(tester, SlotSheetKeys.run(MoveArrow.back));
    expect(h.tactic.fullBacks.left, FullBackPush.down);
    expect(
      find.descendant(
        of: mark(lb),
        matching: find.byIcon(Icons.arrow_downward_rounded),
      ),
      findsOneWidget,
    );
    // The centre: no push, the role's own run.
    await tapInSheet(tester, SlotSheetKeys.run(MoveArrow.none));
    expect(h.tactic.fullBacks.left, FullBackPush.neutral);
    expect(mark(lb), findsNothing);
    // The other flank never moved.
    expect(h.tactic.fullBacks.right, FullBackPush.neutral);
    expect(mark(rb), findsNothing);
    await closeSlotSheet(tester);
  });

  testWidgets('the mark is read-only and says what it is', (tester) async {
    phone(tester);
    final h = pitch(
      Formation.f442,
      pushes: const FullBackPushes(left: FullBackPush.up),
    );
    await tester.pumpApp(h.build());
    final lb = slotOf(Formation.f442, PlayerPosition.lb);
    expect(
      tester.getSemantics(mark(lb).first),
      matchesSemantics(label: 'Left-back arrow: Push on'),
    );
    // A tap on it is a tap on the man: his sheet opens, the push stays.
    await tester.tap(mark(lb), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(SlotSheetKeys.sheet), findsOneWidget);
    expect(h.tactic.fullBacks.left, FullBackPush.up);
    await closeSlotSheet(tester);
  });

  testWidgets('a back three has no full-backs and no marks', (tester) async {
    await tester.pumpApp(
      pitch(
        Formation.f352,
        pushes: const FullBackPushes(
          left: FullBackPush.up,
          right: FullBackPush.up,
        ),
      ).build(),
    );
    expect(
      find.byWidgetPredicate(
        (w) =>
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('pitchFullBack'),
      ),
      findsNothing,
    );
  });

  testWidgets('a back five, both pushed, has both marks', (tester) async {
    await tester.pumpApp(
      pitch(
        Formation.f532,
        pushes: const FullBackPushes(
          left: FullBackPush.up,
          right: FullBackPush.down,
        ),
      ).build(),
    );
    expect(mark(slotOf(Formation.f532, PlayerPosition.lb)), findsOneWidget);
    expect(mark(slotOf(Formation.f532, PlayerPosition.rb)), findsOneWidget);
  });
}
