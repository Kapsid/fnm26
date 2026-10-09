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
}
