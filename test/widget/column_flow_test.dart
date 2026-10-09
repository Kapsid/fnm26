import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/pump_app.dart';

Widget _tile(int i, {double height = 40}) =>
    SizedBox(key: ValueKey(i), height: height, child: Text('tile $i'));

Future<void> _pump(WidgetTester tester, double width, List<Widget> tiles) =>
    tester.pumpApp(
      Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(child: ColumnFlow(children: tiles)),
          ),
        ),
      ),
    );

void main() {
  test('columns: as many 280 tiles as fit, one to three', () {
    expect(ColumnFlow.columnsFor(200), 1);
    expect(ColumnFlow.columnsFor(571), 1);
    expect(ColumnFlow.columnsFor(572), 2);
    expect(ColumnFlow.columnsFor(864), 3);
    expect(ColumnFlow.columnsFor(3000), 3);
    expect(ColumnFlow.columnsFor(double.infinity), 1);
    expect(ColumnFlow.columnsFor(3000, maxColumns: 5), 5);
  });

  testWidgets('two a row at 600, the odd one alone below', (tester) async {
    await _pump(tester, 600, [for (var i = 0; i < 3; i++) _tile(i)]);
    final a = tester.getRect(find.byKey(const ValueKey(0)));
    final b = tester.getRect(find.byKey(const ValueKey(1)));
    final c = tester.getRect(find.byKey(const ValueKey(2)));
    expect(a.top, b.top);
    expect(b.left, greaterThan(a.right));
    expect(c.top, greaterThan(a.bottom));
    expect(c.left, a.left);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a row is as tall as its tallest tile', (tester) async {
    await _pump(tester, 600, [_tile(0), _tile(1, height: 90)]);
    // The short tile is stretched to the row's height.
    expect(
      tester.getSize(find.byKey(const ValueKey(0))).height,
      tester.getSize(find.byKey(const ValueKey(1))).height,
    );
  });

  testWidgets('stacked at 300', (tester) async {
    await _pump(tester, 300, [for (var i = 0; i < 2; i++) _tile(i)]);
    final a = tester.getRect(find.byKey(const ValueKey(0)));
    final b = tester.getRect(find.byKey(const ValueKey(1)));
    expect(b.top, a.bottom + 12);
    expect(a.width, 300);
  });

  testWidgets('the screen header: back, title, trailing', (tester) async {
    var back = 0;
    await tester.pumpApp(
      Scaffold(
        body: TabletScreenHeader(
          title: 'RANKING',
          onBack: () => back++,
          trailing: const Text('action'),
        ),
      ),
    );
    expect(find.text('RANKING'), findsOneWidget);
    expect(find.text('action'), findsOneWidget);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    expect(back, 1);
  });

  testWidgets('no back arrow without onBack', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: TabletScreenHeader(title: 'RANKING')),
    );
    expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
  });
}
