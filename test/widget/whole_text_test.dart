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

  testWidgets('a short name is ranged left, like any other text', (
    tester,
  ) async {
    // It used to centre anything that did not ask for an alignment, so a short
    // name floated into the middle of its column while the flag and the icon
    // beside it stayed put. The row read as broken, and only ever for the
    // SHORT names — which is what made it look random.
    await tester.pumpApp(
      Scaffold(
        body: Row(
          children: [
            const SizedBox(width: 20, height: 20),
            SizedBox(
              width: 200,
              child: WholeText('Vlk', key: const ValueKey('name')),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final box = tester.getRect(find.byKey(const ValueKey('name')));
    final text = tester.getRect(find.text('Vlk'));
    expect(
      text.left - box.left,
      lessThan(1),
      reason: 'the name sits against the leading edge of its box',
    );
  });

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

  testWidgets('a two-word name never loses its surname on one line', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Center(
          child: SizedBox(
            width: 50,
            child: WholeText('Xenon John', maxLines: 1),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // It used to wrap onto a second line that maxLines then threw away, so the
    // squad list showed "Xenon" and swallowed the man's surname.
    final rendered = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .join();
    expect(rendered, contains('John'));
  });

  testWidgets('offered a shorter form, a name too long is initialled', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: Center(
          child: SizedBox(
            width: 40,
            child: WholeText(
              'Xenon John',
              maxLines: 1,
              shortText: initialledName('Xenon John'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('X. John'), findsOneWidget);
  });

  testWidgets('a name with room to spare is never initialled', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: WholeText(
              'Xenon John',
              maxLines: 1,
              shortText: initialledName('Xenon John'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xenon John'), findsOneWidget);
  });

  test('the forename gives way first, and only the forename', () {
    expect(initialledName('Xenon John'), 'X. John');
    expect(initialledName('Jan van der Berg'), 'J. van der Berg');
    // One word is already as short as it goes, and an initial stays one.
    expect(initialledName('Ronaldo'), 'Ronaldo');
    expect(initialledName('J. Berg'), 'J. Berg');
  });

  test('break opportunities go between letters, not between words', () {
    expect(withBreakOpportunities('Kane'), 'K​a​n​e');
    expect(
      withBreakOpportunities('De Bruyne'),
      'D​e B​r​u​y​n​e',
    );
  });
}
