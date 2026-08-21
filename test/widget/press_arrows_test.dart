import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/press/press_sheet.dart';

import '../helpers/pump_app.dart';

/// What an answer costs, shown as arrows rather than as a figure on a scale
/// the manager has never been shown.
void main() {
  Future<void> pumpAnswer(WidgetTester tester, PressEffect effect) =>
      tester.pumpApp(
        Scaffold(
          body: AnswerTile(
            label: 'I back these players',
            effect: effect,
            onTap: () {},
          ),
        ),
      );

  testWidgets('no bare numbers are printed beside the labels', (tester) async {
    await pumpAnswer(tester, (morale: 6, board: -3));
    await tester.pumpAndSettle();

    for (final text in tester.widgetList<Text>(find.byType(Text))) {
      final data = text.data ?? '';
      expect(
        RegExp(r'\d').hasMatch(data),
        isFalse,
        reason: '"$data" still shows a raw figure',
      );
    }
  });

  testWidgets('the strongest stance draws three arrows', (tester) async {
    await pumpAnswer(tester, (morale: 6, board: 0));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_upward_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
  });

  testWidgets('a rise and a fall are drawn together, each its own way', (
    tester,
  ) async {
    // Backing the players: the squad loves it, the board hears excuses.
    await pumpAnswer(tester, (morale: 6, board: -3));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_upward_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNWidgets(2));
  });

  testWidgets('a nudge is a single arrow', (tester) async {
    await pumpAnswer(tester, (morale: 0, board: -1));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
  });

  testWidgets('saying nothing draws no arrows at all', (tester) async {
    await pumpAnswer(tester, (morale: 0, board: 0));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
  });
}
