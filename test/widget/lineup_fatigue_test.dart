import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// The pre-match line-up marks who is tired, on the pitch and on the bench,
/// and says nothing about a fresh man.
void main() {
  const f = Formation.f442;
  final squad = <int, Player>{
    for (var i = 0; i < 11; i++)
      100 + i: player(
        id: 100 + i,
        nationId: 1,
        name: 'Player Number$i',
        position: f.positions[i],
      ),
  };
  final bencher = player(id: 200, nationId: 1, name: 'Jo Tiredman');
  final freshBencher = player(id: 201, nationId: 1, name: 'Jo Freshman');

  Widget body() => Column(
    children: [
      SizedBox(
        width: 390,
        height: 520,
        child: RepaintBoundary(
          key: const ValueKey('lineup'),
          child: TacticsPitch(
            formation: f,
            instructions: const TacticalInstructions(),
            lineup: [for (var i = 0; i < 11; i++) 100 + i],
            byId: squad,
            fatigueByPlayer: const {
              101: FatigueState.tired,
              102: FatigueState.exhausted,
              103: FatigueState.ready,
              104: FatigueState.fresh,
            },
            onTapSlot: (_) {},
            onSwap: (_, _) {},
            onBenchIn: (_, _) {},
          ),
        ),
      ),
      Row(
        children: [
          BenchChip(player: bencher, fatigue: FatigueState.exhausted),
          BenchChip(player: freshBencher, fatigue: FatigueState.fresh),
        ],
      ),
    ],
  );

  testWidgets('tired and exhausted show a marker, fresh does not', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 640);
    addTearDown(tester.view.reset);
    await tester.pumpApp(body());

    // Pitch: slots 1 (tired), 2 (exhausted), 3 (ready) marked; 0 and the fresh
    // slot 4 are not.
    expect(find.byKey(const ValueKey('pitchFatigue1')), findsOneWidget);
    expect(find.byKey(const ValueKey('pitchFatigue2')), findsOneWidget);
    expect(find.byKey(const ValueKey('pitchFatigue3')), findsOneWidget);
    expect(find.byKey(const ValueKey('pitchFatigue0')), findsNothing);
    expect(find.byKey(const ValueKey('pitchFatigue4')), findsNothing);

    // Bench: exactly one marker, on the exhausted man's chip.
    final marks = find.descendant(
      of: find.byType(BenchChip),
      matching: find.byIcon(Icons.battery_alert_rounded),
    );
    expect(marks, findsOneWidget);
    expect(
      find.descendant(
        of: find.widgetWithText(BenchChip, 'Tiredman'),
        matching: find.byIcon(Icons.battery_alert_rounded),
      ),
      findsOneWidget,
    );

    // Spoken, too.
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Exhausted',
      ),
      findsWidgets,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Tired',
      ),
      findsWidgets,
    );
  });

  testWidgets('golden: phone line-up with fatigue markers', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 640);
    addTearDown(tester.view.reset);
    await tester.pumpApp(body());
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('../golden/goldens/lineup_fatigue_markers.png'),
    );
  });
}
