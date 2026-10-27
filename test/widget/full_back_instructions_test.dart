import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/full_back_instructions.dart';

import '../helpers/pump_app.dart';

/// The full-size full-back control on the Instructions tabs.
void main() {
  Widget harness(Formation f, List<(FullBackSide, FullBackPush)> changes) {
    var value = FullBackPushes.neutral;
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) => ListView(
          children: [
            FullBackInstructions(
              formation: f,
              value: value,
              onChanged: (side, push) {
                changes.add((side, push));
                setState(() => value = value.withSide(side, push));
              },
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('one row per full-back, each a three-way choice', (
    tester,
  ) async {
    final changes = <(FullBackSide, FullBackPush)>[];
    await tester.pumpApp(harness(Formation.f442, changes));
    expect(find.text('Left-back'), findsOneWidget);
    expect(find.text('Right-back'), findsOneWidget);
    expect(find.text('Push on'), findsNWidgets(2));
    await tester.tap(find.byKey(const ValueKey('fullBackChoice.right.down')));
    await tester.pump();
    expect(changes, [(FullBackSide.right, FullBackPush.down)]);
    final chip = tester.widget<ChoiceChip>(
      find.byKey(const ValueKey('fullBackChoice.right.down')),
    );
    expect(chip.selected, isTrue);
  });

  testWidgets('a back three has no full-backs and no rows', (tester) async {
    await tester.pumpApp(harness(Formation.f352, []));
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('fits 360 wide at text scale 1.4 in Finnish', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpApp(
      harness(Formation.f442, []),
      locale: const Locale('fi'),
    );
    expect(tester.takeException(), isNull);
  });
}
