import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/dashboard_grid.dart';
import 'package:fnm/shared/tablet/panel.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('panel shows its title in capitals, action and body', (
    tester,
  ) async {
    await tester.pumpApp(
      Panel(
        title: 'Next match',
        action: TextButton(onPressed: () {}, child: const Text('Preview')),
        child: const Text('body'),
      ),
    );
    expect(find.text('NEXT MATCH'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('tiles fill 12 columns per row, sized by span', (tester) async {
    tester.view.physicalSize = const Size(1224, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const Scaffold(
        body: SingleChildScrollView(
          child: DashboardGrid(
            gap: 12,
            tiles: [
              DashboardTile(span: 6, child: SizedBox(key: Key('a'), height: 40)),
              DashboardTile(span: 6, child: SizedBox(key: Key('b'), height: 80)),
              DashboardTile(span: 12, child: SizedBox(key: Key('c'), height: 40)),
            ],
          ),
        ),
      ),
    );
    final a = tester.getRect(find.byKey(const Key('a')));
    final b = tester.getRect(find.byKey(const Key('b')));
    final c = tester.getRect(find.byKey(const Key('c')));
    expect(a.top, b.top, reason: 'a and b share a row');
    expect(a.width, closeTo(606, 0.5)); // (1224 - 12) / 2
    expect(a.height, b.height, reason: 'a row is as tall as its tallest tile');
    expect(c.top, greaterThan(b.bottom));
    expect(c.width, closeTo(1224, 0.5));
  });
}
