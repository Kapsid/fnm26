import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/setup_warning.dart';

import '../helpers/pump_app.dart';

/// A manager who never opened the tactics screen had no way of learning that
/// the armband and the set-piece takers were his to name — both quietly
/// default to "let the engine decide". This says so before kick-off.
void main() {
  Future<void> pumpWith(
    WidgetTester tester, {
    required bool captain,
    required bool setPieces,
  }) async {
    await tester.pumpApp(
      const Scaffold(body: SquadSetupWarning(careerId: 1)),
      overrides: [
        squadSetupProvider(
          1,
        ).overrideWith((ref) async => (captain: captain, setPieces: setPieces)),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a side with both set says nothing', (tester) async {
    await pumpWith(tester, captain: true, setPieces: true);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
  });

  testWidgets('no captain is called out', (tester) async {
    await pumpWith(tester, captain: false, setPieces: true);
    expect(
      find.text('No captain named — tap to give somebody the armband'),
      findsOneWidget,
    );
  });

  testWidgets('no set-piece takers are called out', (tester) async {
    await pumpWith(tester, captain: true, setPieces: false);
    expect(
      find.text('No set-piece takers named — tap to choose who steps up'),
      findsOneWidget,
    );
  });

  testWidgets('neither set reads as one warning, not two', (tester) async {
    await pumpWith(tester, captain: false, setPieces: false);
    expect(
      find.text('No captain and no set-piece takers — tap to set them'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });
}
