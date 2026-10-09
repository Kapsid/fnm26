import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/master_detail.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<void> pump(WidgetTester tester, {Widget? detail}) async {
    tester.view.physicalSize = const Size(1000, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: MasterDetail(
          master: const SizedBox.expand(key: Key('master')),
          detail: detail,
          placeholder: const MasterDetailPlaceholder(text: 'Pick a player'),
        ),
      ),
    );
  }

  testWidgets('starts at 40/60 with the placeholder when nothing is picked', (
    tester,
  ) async {
    await pump(tester);
    expect(tester.getSize(find.byKey(const Key('master'))).width, 400);
    expect(find.text('Pick a player'), findsOneWidget);
  });

  testWidgets('shows the detail once there is one', (tester) async {
    await pump(tester, detail: const Text('Vondráček'));
    expect(find.text('Vondráček'), findsOneWidget);
    expect(find.text('Pick a player'), findsNothing);
  });

  testWidgets('the divider drags, and stops at the limits', (tester) async {
    await pump(tester);
    // Touch slop first, then the rest, so the divider must follow the finger
    // from the first pixel (DragStartBehavior.down).
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(MasterDetail.dividerKey)),
    );
    await gesture.moveBy(const Offset(36, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(64, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 500);
    await tester.drag(
      find.byKey(MasterDetail.dividerKey),
      const Offset(900, 0),
    );
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 600);
    await tester.drag(
      find.byKey(MasterDetail.dividerKey),
      const Offset(-900, 0),
    );
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 250);
  });
}
