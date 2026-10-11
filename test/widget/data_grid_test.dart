import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
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
      GridColumn(
        id: 'name',
        label: 'Name',
        flex: 3,
        cell: (p) => Text(p.name),
        sortKey: (p) => p.name,
      ),
      GridColumn(
        id: 'ovr',
        label: 'OVR',
        width: 48,
        numeric: true,
        cell: (p) => Text('${p.ovr}'),
        sortKey: (p) => p.ovr,
      ),
    ],
  ),
  GridColumnSet(
    id: 'career',
    label: 'Career',
    columns: [
      GridColumn(
        id: 'name',
        label: 'Name',
        flex: 3,
        cell: (p) => Text(p.name),
        sortKey: (p) => p.name,
      ),
      GridColumn(
        id: 'age',
        label: 'Age',
        width: 48,
        numeric: true,
        cell: (p) => Text('${p.age}'),
        sortKey: (p) => p.age,
      ),
    ],
  ),
];

List<String> _order(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => t.data ?? '')
    .where((s) => ['Staněk', 'Kubišta', 'Rejthar'].contains(s))
    .toList();

Future<void> _pump(
  WidgetTester tester, {
  List<P> rows = _rows,
  List<GridColumnSet<P>>? sets,
  ValueChanged<P>? onSelect,
  P? selected,
}) async {
  tester.view.physicalSize = const Size(800, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: DataGrid<P>(
        rows: rows,
        columnSets: sets ?? _sets,
        onSelect: onSelect,
        selected: selected,
      ),
    ),
  );
}

void main() {
  testWidgets('rows keep their given order until a header is tapped', (
    tester,
  ) async {
    await _pump(tester);
    expect(_order(tester), ['Staněk', 'Kubišta', 'Rejthar']);
  });

  testWidgets('a numeric column sorts high to low first, then reverses', (
    tester,
  ) async {
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
    await tester.tap(find.text('CAREER'));
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
    final many = [
      for (var i = 0; i < 2000; i++) (name: 'P$i', ovr: i % 99, age: 20),
    ];
    await _pump(tester, rows: many);
    expect(find.text('P0'), findsOneWidget);
    expect(find.text('P1999'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ties keep their incoming order, ascending and descending', (
    tester,
  ) async {
    // 60 rows is past the sort's small-list path, where an unstable sort
    // would scramble equal keys; the first screenful shows the order.
    final tied = [
      for (var i = 0; i < 60; i++)
        (name: 'R${i.toString().padLeft(2, '0')}', ovr: 80, age: 20),
    ];
    List<String> visible() => tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .where((s) => s.startsWith('R'))
        .take(10)
        .toList();
    final expected = [
      for (var i = 0; i < 10; i++) 'R${i.toString().padLeft(2, '0')}',
    ];
    await _pump(tester, rows: tied);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(visible(), expected);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(visible(), expected);
  });

  testWidgets(
    'a parent rebuild with new column builders re-renders the cells',
    (tester) async {
      final v2 = <GridColumnSet<P>>[
        GridColumnSet(
          id: 'overview',
          label: 'Overview',
          columns: [
            GridColumn(
              id: 'name',
              label: 'Name',
              flex: 3,
              cell: (p) => Text('${p.name}!'),
              sortKey: (p) => p.name,
            ),
            GridColumn(
              id: 'ovr',
              label: 'OVR',
              width: 48,
              numeric: true,
              cell: (p) => Text('${p.ovr}'),
              sortKey: (p) => p.ovr,
            ),
          ],
        ),
      ];
      await _pump(tester);
      expect(find.text('Staněk'), findsOneWidget);
      await _pump(tester, sets: v2);
      expect(find.text('Staněk!'), findsOneWidget);
      expect(find.text('Staněk'), findsNothing);
    },
  );

  testWidgets('a parent that removes the active view falls back to the first', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.text('CAREER'));
    await tester.pump();
    expect(find.text('Age'), findsOneWidget);
    await _pump(tester, sets: [_sets.first]);
    expect(find.text('OVR'), findsOneWidget);
    expect(find.text('Age'), findsNothing);
  });

  testWidgets('replacing the rows re-sorts them with the current sort', (
    tester,
  ) async {
    const replaced = <P>[
      (name: 'Staněk', ovr: 79, age: 29),
      (name: 'Kubišta', ovr: 90, age: 23),
      (name: 'Rejthar', ovr: 80, age: 30),
    ];
    await _pump(tester);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(_order(tester), ['Rejthar', 'Staněk', 'Kubišta']);
    await _pump(tester, rows: replaced);
    expect(_order(tester), ['Kubišta', 'Rejthar', 'Staněk']);
  });

  testWidgets('the header is a full-height, labelled tap target', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    expect(
      tester.getSize(find.byKey(DataGrid.headerKey)).height,
      DataGrid.headerHeight,
    );
    expect(
      tester.getSemantics(find.text('OVR')),
      containsSemantics(isButton: true, isSelected: false),
    );
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(
      tester.getSemantics(find.text('OVR')),
      containsSemantics(isButton: true, isSelected: true),
    );
    semantics.dispose();
  });

  testWidgets('the selected row is highlighted', (tester) async {
    await _pump(tester, selected: _rows[1]);
    final material = tester.widget<Material>(
      find
          .ancestor(of: find.text('Kubišta'), matching: find.byType(Material))
          .first,
    );
    expect(material.color, AppColors.surfaceContainerHighest);
  });

  testWidgets(
    'a narrow grid scrolls sideways as one, header and rows aligned',
    (
      tester,
    ) async {
      final wide = <GridColumnSet<P>>[
        GridColumnSet(
          id: 'wide',
          label: 'Wide',
          columns: [
            for (var i = 0; i < 6; i++)
              GridColumn<P>(
                id: 'c$i',
                label: 'Col$i',
                width: 100,
                cell: (p) => Text('${p.name}$i'),
              ),
          ],
        ),
      ];
      tester.view.physicalSize = const Size(400, 500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        Scaffold(
          body: DataGrid<P>(rows: _rows, columnSets: wide),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(DataGrid.scrollKey), findsOneWidget);
      for (var i = 0; i < 6; i++) {
        expect(
          tester.getTopLeft(find.text('Col$i')).dx,
          tester.getTopLeft(find.text('Staněk$i')).dx,
        );
      }
      await tester.drag(find.byKey(DataGrid.scrollKey), const Offset(-200, 0));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester.getTopLeft(find.text('Col5')).dx,
        tester.getTopLeft(find.text('Staněk5')).dx,
      );
      expect(tester.getTopLeft(find.text('Col0')).dx, lessThan(0));
    },
  );

  testWidgets('a wide enough grid does not scroll', (tester) async {
    await _pump(tester);
    expect(find.byKey(DataGrid.scrollKey), findsNothing);
  });
}
