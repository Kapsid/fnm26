import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactic_preset_tile.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

/// Saved presets in the in-match editor: the shape and all six sliders in one
/// tap, applied through the editor's own reshape so nobody new comes on.
void main() {
  const phone = Size(400, 2600);
  const chase = TacticPreset(
    name: 'Chase it',
    formation: Formation.f424,
    instructions: TacticalInstructions(
      mentality: 85,
      pressing: 80,
      tempo: 75,
      width: 70,
      defensiveLine: 75,
      directness: 70,
    ),
  );
  const sameShape = TacticPreset(
    name: 'Press more',
    formation: Formation.f442,
    instructions: TacticalInstructions(pressing: 90),
  );

  Future<void> applyPreset(WidgetTester tester, String name) async {
    await tester.tap(find.byKey(InMatchTacticsKeys.presetsButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> confirm(WidgetTester tester) async {
    await tester.tap(find.text(enL.tacticsApply));
    await tester.pumpAndSettle();
  }

  testWidgets('applying a preset sets shape and all six sliders, same eleven', (
    tester,
  ) async {
    final out = await openEditor(tester, size: phone, presets: [chase]);
    await applyPreset(tester, 'Chase it');
    await confirm(tester);
    final r = out.result!;
    expect(r.formation, Formation.f424);
    expect(r.instructions.mentality, 85);
    expect(r.instructions.pressing, 80);
    expect(r.instructions.tempo, 75);
    expect(r.instructions.width, 70);
    expect(r.instructions.defensiveLine, 75);
    expect(r.instructions.directness, 70);
    expect(r.lineup.whereType<int>().toSet(), {
      for (var i = 1; i <= 11; i++) i,
    });
  });

  testWidgets('applying the current shape changes only the sliders', (
    tester,
  ) async {
    final out = await openEditor(tester, size: phone, presets: [sameShape]);
    await applyPreset(tester, 'Press more');
    await confirm(tester);
    final r = out.result!;
    expect(r.formation, Formation.f442);
    expect(r.lineup, [for (var i = 1; i <= 11; i++) i]);
    expect(r.instructions.pressing, 90);
  });

  testWidgets('ten men stay ten', (tester) async {
    final out = await openEditor(
      tester,
      size: phone,
      presets: [chase],
      sentOffIds: {5},
      lineup: [1, 2, 3, 4, null, 6, 7, 8, 9, 10, 11],
    );
    await applyPreset(tester, 'Chase it');
    await confirm(tester);
    final r = out.result!;
    final on = r.lineup.whereType<int>().toSet();
    expect(on.length, 10);
    expect(on.intersection({12, 13, 14, 15, 16}), isEmpty);
  });

  testWidgets('sliders stay editable after a preset', (tester) async {
    final out = await openEditor(tester, size: phone, presets: [chase]);
    await applyPreset(tester, 'Chase it');
    // Tactics tab, then drag the first slider (mentality) to the far left.
    await tester.tap(find.text(enL.tacticsTabTactics));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Slider).first, const Offset(-400, 0));
    await tester.pumpAndSettle();
    await confirm(tester);
    expect(out.result!.instructions.mentality, lessThan(85));
    expect(out.result!.instructions.pressing, 80);
  });

  testWidgets('no presets: the button explains how to save one', (
    tester,
  ) async {
    await openEditor(tester, size: phone);
    await tester.tap(find.byKey(InMatchTacticsKeys.presetsButton));
    await tester.pumpAndSettle();
    expect(find.text(enL.tacticsNoPresetsInMatch), findsOneWidget);
    expect(find.byType(TacticPresetTile), findsNothing);
  });

  testWidgets('tablet: the presets button is on the app bar', (tester) async {
    await openEditor(
      tester,
      size: kTabletSize,
      tabletLayout: true,
      presets: [chase],
    );
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsOneWidget);
    expect(find.byKey(InMatchTacticsKeys.presetsButton), findsOneWidget);
  });
}
