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

  testWidgets('a tile may hold a list if it gives the list a fixed height', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: DashboardGrid(
            tiles: [
              DashboardTile(
                span: 6,
                child: SizedBox(
                  height: 120,
                  child: ListView(
                    children: [for (var i = 0; i < 20; i++) Text('row $i')],
                  ),
                ),
              ),
              const DashboardTile(span: 6, child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('row 0'), findsOneWidget);
  });

  testWidgets('an expanding panel gives its body all the height below the '
      'header', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SizedBox(
          height: 300,
          child: Panel(
            title: 'Pool',
            expand: true,
            padding: EdgeInsets.zero,
            child: SizedBox.expand(key: Key('body')),
          ),
        ),
      ),
    );
    // 300 minus the 34px header strip (the border is painted, not padded).
    expect(tester.getSize(find.byKey(const Key('body'))).height, 266);
  });

  testWidgets('a panel link is tappable', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      Scaffold(
        body: Panel(
          title: 'Inbox',
          action: PanelLink(label: 'View all', onTap: () => taps++),
          child: const Text('body'),
        ),
      ),
    );
    await tester.tap(find.text('View all'));
    expect(taps, 1);
  });
}
