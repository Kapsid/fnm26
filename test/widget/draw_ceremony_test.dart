import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('DrawCeremony reveals groups and finishes on skip', (
    tester,
  ) async {
    final nations = {
      1: nation(id: 1, name: 'Spain'),
      2: nation(id: 2, name: 'Italy'),
      3: nation(id: 3, name: 'France'),
      4: nation(id: 4, name: 'Germany'),
    };
    var continued = false;

    await tester.pumpApp(
      Scaffold(
        body: DrawCeremony(
          groups: const [
            (name: 'A', nationIds: [1, 2]),
            (name: 'B', nationIds: [3, 4]),
          ],
          nations: nations,
          potCount: 2,
          onContinue: () => continued = true,
        ),
      ),
    );
    await tester.pump();

    // Pots are shown.
    expect(find.text('POT 1'), findsOneWidget);
    expect(find.text('POT 2'), findsOneWidget);

    // Skip jumps to the finished draw.
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('GROUP A'), findsOneWidget);
    expect(find.text('GROUP B'), findsOneWidget);
    expect(find.text('Spain'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);

    await tester.tap(find.widgetWithText(PrimaryButton, 'Continue'));
    await tester.pump();
    expect(continued, isTrue);
  });
}
