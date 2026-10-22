import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

Future<void> _pump(WidgetTester tester, Widget home) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => Scaffold(body: home)),
      GoRoute(
        path: '/nation',
        builder: (_, state) =>
            Text('nation page ${state.uri.queryParameters['nationId']}'),
      ),
    ],
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('NationTap opens the nation page on a phone', (tester) async {
    await _pump(
      tester,
      const NationTap(careerId: 1, nationId: 7, child: Text('Brazil')),
    );
    await tester.tap(find.text('Brazil'));
    await tester.pumpAndSettle();
    expect(find.text('nation page 7'), findsOneWidget);
  });

  testWidgets('NationTap opens the nation in the detail pane on a tablet', (
    tester,
  ) async {
    final pane = DetailPaneController();
    addTearDown(pane.dispose);
    await _pump(
      tester,
      DetailPaneScope(
        controller: pane,
        child: const NationTap(
          careerId: 1,
          nationId: 7,
          child: Text('Brazil'),
        ),
      ),
    );
    await tester.tap(find.text('Brazil'));
    await tester.pump();
    expect(pane.value, const NationTarget(7));
    expect(find.text('nation page 7'), findsNothing);
  });
}
