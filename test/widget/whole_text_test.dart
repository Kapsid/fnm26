import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/find_name.dart';
import '../helpers/pump_app.dart';

/// A name that ends in an ellipsis is not a name. Every list that shows a
/// person — the squad, the call-up screen, the pitch — has to be able to
/// promise the whole thing, however long it is.
void main() {
  Future<void> pumpAt(WidgetTester tester, String name, double width) =>
      tester.pumpApp(
        Scaffold(
          body: Center(
            child: SizedBox(width: width, child: WholeText(name)),
          ),
        ),
      );

  testWidgets('a sixteen-letter surname arrives whole in a narrow box', (
    tester,
  ) async {
    await pumpAt(tester, 'Papastathopoulos', 60);
    await tester.pumpAndSettle();

    expect(findName('Papastathopoulos'), findsOneWidget);
  });

  testWidgets('nothing it renders contains an ellipsis', (tester) async {
    await pumpAt(tester, 'Schweinsteiger', 40);
    await tester.pumpAndSettle();

    final rendered = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .join();
    expect(rendered.contains('…'), isFalse);
    expect(rendered.contains('...'), isFalse);
  });

  testWidgets('it never draws wider than the box it was given', (tester) async {
    await pumpAt(tester, 'Papastathopoulos', 60);
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(WholeText)).width, lessThanOrEqualTo(60));
  });

  testWidgets('a name that already fits is left exactly as it was given', (
    tester,
  ) async {
    await pumpAt(tester, 'Kane', 120);
    await tester.pumpAndSettle();

    // Not merely readable — untouched. Break opportunities are a concession
    // paid only by the names that need them.
    expect(find.text('Kane'), findsOneWidget);
  });

  testWidgets('a name that does not fit wraps before it shrinks', (
    tester,
  ) async {
    await pumpAt(tester, 'Papastathopoulos', 60);
    await tester.pumpAndSettle();

    final data = tester.widget<Text>(find.byType(Text)).data!;
    expect(
      data.contains(breakOpportunity),
      isTrue,
      reason: 'it should have been given somewhere to break',
    );
  });

  test('break opportunities go between letters, not between words', () {
    expect(withBreakOpportunities('Kane'), 'K​a​n​e');
    expect(
      withBreakOpportunities('De Bruyne'),
      'D​e B​r​u​y​n​e',
    );
  });
}
