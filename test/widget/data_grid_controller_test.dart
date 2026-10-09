import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('a controller scrolls the rows (the header stays)', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final rows = [for (var i = 0; i < 100; i++) i];
    await tester.pumpApp(
      Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: DataGrid<int>(
            rows: rows,
            controller: controller,
            columnSets: [
              GridColumnSet(
                id: 'all',
                label: 'All',
                columns: [
                  GridColumn(id: 'n', label: 'N', cell: (r) => Text('row $r')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('row 0'), findsOneWidget);
    controller.jumpTo(DataGrid.rowHeight * 50);
    await tester.pump();
    expect(find.text('row 0'), findsNothing);
    expect(find.text('row 50'), findsOneWidget);
    expect(find.byKey(DataGrid.headerKey), findsOneWidget);
  });

  testWidgets('revealRow centres a row by its place in the sorted order', (
    tester,
  ) async {
    final controller = DataGridController<int>();
    final rows = [for (var i = 0; i < 100; i++) i];
    await tester.pumpApp(
      Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: DataGrid<int>(
            rows: rows,
            rowsController: controller,
            columnSets: [
              GridColumnSet(
                id: 'all',
                label: 'All',
                columns: [
                  GridColumn(
                    id: 'n',
                    label: 'N',
                    sortKey: (r) => r,
                    cell: (r) => Text('row $r'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(controller.indexOf(7), 7);
    await tester.tap(find.text('N')); // ascending
    await tester.pump();
    await tester.tap(find.text('N')); // descending
    await tester.pump();
    expect(controller.indexOf(7), 92);
    expect(controller.revealRow(7), isTrue);
    await tester.pump();
    final row = find.text('row 7');
    expect(row, findsOneWidget);
    final view = tester.getRect(find.byType(ListView));
    expect(tester.getCenter(row).dy, inInclusiveRange(view.top, view.bottom));
    expect(controller.revealRow(1000), isFalse);
  });
}
