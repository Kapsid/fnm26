import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/shared/widgets/widgets.dart';

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

  testWidgets('the manager can pause and draw team by team by tapping', (
    tester,
  ) async {
    final nations = {
      for (var i = 1; i <= 8; i++) i: nation(id: i, name: 'Nation $i'),
    };

    await tester.pumpApp(
      Scaffold(
        body: DrawCeremony(
          groups: const [
            (name: 'A', nationIds: [1, 2]),
            (name: 'B', nationIds: [3, 4]),
            (name: 'C', nationIds: [5, 6]),
            (name: 'D', nationIds: [7, 8]),
          ],
          nations: nations,
          potCount: 2,
          onContinue: () {},
        ),
      ),
    );
    await tester.pump();

    // Pausing stops the autoplay so nothing advances on its own.
    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Play'), findsOneWidget);

    final before = find.byType(FlagDisc).evaluate().length;
    // Well past the old autoplay interval — nothing should have moved.
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(FlagDisc).evaluate().length, before);

    // Pick the ball-by-ball draw mode for this team-by-team test.
    await tester.tap(find.text('Ball'));
    await tester.pump();

    // Tapping over the groups (the tap target is the grid) pulls the balls one
    // at a time; the whole field of eight comes out and then the draw is done.
    for (var i = 0; i < 8; i++) {
      if (find.text('Tap to draw the next team').evaluate().isEmpty) break;
      await tester.tap(find.text('GROUP A'));
      await tester.pump(const Duration(milliseconds: 400));
    }
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);
  });
}
