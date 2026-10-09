import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/data_grid.dart';

import '../helpers/pump_app.dart';

typedef P = ({String name, int ovr, int age});

const _rows = <P>[
  (name: 'Staněk', ovr: 79, age: 29),
  (name: 'Kubišta', ovr: 76, age: 23),
  (name: 'Rejthar', ovr: 80, age: 30),
];

final _sets = <GridColumnSet<P>>[
  GridColumnSet(
    id: 'overview',
    label: 'Overview',
    columns: [
      GridColumn(id: 'name', label: 'Name', flex: 3, cell: (p) => Text(p.name), sortKey: (p) => p.name),
      GridColumn(id: 'ovr', label: 'OVR', width: 48, numeric: true, cell: (p) => Text('${p.ovr}'), sortKey: (p) => p.ovr),
    ],
  ),
  GridColumnSet(
    id: 'career',
    label: 'Career',
    columns: [
      GridColumn(id: 'name', label: 'Name', flex: 3, cell: (p) => Text(p.name), sortKey: (p) => p.name),
      GridColumn(id: 'age', label: 'Age', width: 48, numeric: true, cell: (p) => Text('${p.age}'), sortKey: (p) => p.age),
    ],
  ),
];

List<String> _order(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => t.data ?? '')
    .where((s) => ['Staněk', 'Kubišta', 'Rejthar'].contains(s))
    .toList();

Future<void> _pump(WidgetTester tester, {List<P> rows = _rows, ValueChanged<P>? onSelect, P? selected}) async {
  tester.view.physicalSize = const Size(800, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: DataGrid<P>(rows: rows, columnSets: _sets, onSelect: onSelect, selected: selected),
    ),
  );
}

void main() {
  testWidgets('rows keep their given order until a header is tapped', (tester) async {
    await _pump(tester);
    expect(_order(tester), ['Staněk', 'Kubišta', 'Rejthar']);
  });

  testWidgets('a numeric column sorts high to low first, then reverses', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(_order(tester), ['Rejthar', 'Staněk', 'Kubišta']);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(_order(tester), ['Kubišta', 'Staněk', 'Rejthar']);
  });

  testWidgets('a text column sorts A to Z first', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Name'));
    await tester.pump();
    expect(_order(tester), ['Kubišta', 'Rejthar', 'Staněk']);
  });

  testWidgets('switching views swaps the columns', (tester) async {
    await _pump(tester);
    expect(find.text('OVR'), findsOneWidget);
    await tester.tap(find.text('Career'));
    await tester.pump();
    expect(find.text('OVR'), findsNothing);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('23'), findsOneWidget);
  });

  testWidgets('tapping a row selects it', (tester) async {
    P? picked;
    await _pump(tester, onSelect: (p) => picked = p);
    await tester.tap(find.text('Kubišta'));
    expect(picked?.name, 'Kubišta');
  });

  testWidgets('a long list builds only what is on screen', (tester) async {
    final many = [for (var i = 0; i < 2000; i++) (name: 'P$i', ovr: i % 99, age: 20)];
    await _pump(tester, rows: many);
    expect(find.text('P0'), findsOneWidget);
    expect(find.text('P1999'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
