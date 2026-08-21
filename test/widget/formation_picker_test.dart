import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show layoutOf;

import '../helpers/pump_app.dart';

/// Seventeen shapes were already offered — as seventeen text chips, which is a
/// list of numbers rather than a choice: "4-1-4-1" and "4-4-1-1" are one glyph
/// apart and neither says what the side would look like.
void main() {
  testWidgets('every shape in the game is offered, drawn', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byType(FormationTile),
      findsNWidgets(Formation.values.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the shapes added with the picker are among them', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('4-3-2-1'), findsOneWidget);
    expect(find.text('3-5-1-1'), findsOneWidget);
  });

  testWidgets('tapping a shape reports it', (tester) async {
    Formation? picked;
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FormationPicker(
            selected: Formation.f442,
            onSelected: (f) => picked = f,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('4-3-3'));
    expect(picked, Formation.f433);
  });

  test('every shape has eleven positions and eleven dots', () {
    for (final f in Formation.values) {
      expect(f.positions, hasLength(11), reason: '${f.label} positions');
      expect(layoutOf(f), hasLength(11), reason: '${f.label} layout');
    }
  });
}
