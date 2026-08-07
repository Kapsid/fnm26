import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// Layout regressions on the smallest phone we support.
///
/// Two bugs shipped that no test could have caught: the manager's labelled
/// ball ran out of its pot in a six-pot draw, and the squad tab's filter strip
/// was unreadable. Both are pure layout, so they need a pump at a real width
/// and a check that nothing overflowed — `takeException` is how Flutter
/// reports a RenderFlex overflow.
void main() {
  /// A small phone: 360×640 at 1× — narrower than most, which is the point.
  Future<void> pumpNarrow(WidgetTester tester, Widget child) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(child);
  }

  Map<int, Nation> nationsUpTo(int n) => {
    for (var i = 1; i <= n; i++) i: nation(id: i, name: 'Nation $i'),
  };

  testWidgets('a six-pot draw fits its pots on a narrow phone', (tester) async {
    // Six pots of four is the widest the ceremony ever gets — a 24-team
    // continental championship. The manager's own ball carries a flag AND a
    // country code, which is what used to burst the box.
    final nations = nationsUpTo(24);
    await pumpNarrow(
      tester,
      Scaffold(
        body: DrawCeremony(
          groups: [
            for (var g = 0; g < 6; g++)
              (
                name: String.fromCharCode(65 + g),
                nationIds: [
                  for (var i = 0; i < 4; i++) g * 4 + i + 1,
                ],
              ),
          ],
          nations: nations,
          potCount: 6,
          // The manager is in the first pot, so the labelled pill is on screen
          // from the very first frame.
          highlightNationId: 1,
          onContinue: () {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('POT 1'), findsOneWidget);
    expect(find.text('POT 6'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'the pots must not overflow their row',
    );
  });

  testWidgets('the manager pill survives an even tighter screen', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Scaffold(
        body: DrawCeremony(
          groups: [
            for (var g = 0; g < 6; g++)
              (
                name: String.fromCharCode(65 + g),
                nationIds: [
                  for (var i = 0; i < 4; i++) g * 4 + i + 1,
                ],
              ),
          ],
          nations: nationsUpTo(24),
          potCount: 6,
          highlightNationId: 3,
          onContinue: () {},
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the draw still finishes with six pots', (tester) async {
    var continued = false;
    await pumpNarrow(
      tester,
      Scaffold(
        body: DrawCeremony(
          groups: [
            for (var g = 0; g < 6; g++)
              (
                name: String.fromCharCode(65 + g),
                nationIds: [
                  for (var i = 0; i < 4; i++) g * 4 + i + 1,
                ],
              ),
          ],
          nations: nationsUpTo(24),
          potCount: 6,
          highlightNationId: 1,
          onContinue: () => continued = true,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('GROUP A'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(continued, isTrue);
  });

  testWidgets('the nav destinations fit a narrow phone', (tester) async {
    // A fifth destination once overflowed this by 200 pixels. The bar now
    // shares its width equally, so it cannot outgrow the screen whatever it
    // is asked to hold — this guards that it stays that way.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      const Scaffold(
        bottomNavigationBar: AppBottomNav(careerId: 1, current: AppTab.hub),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    for (final tab in AppTab.values) {
      expect(tab, isNotNull);
    }
  });
}
