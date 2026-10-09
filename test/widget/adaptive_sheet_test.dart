import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';

import '../helpers/pump_app.dart';

Future<void> _open(WidgetTester tester, Size size, {bool dismissible = true}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showAdaptiveSheet<void>(
            context: context,
            isDismissible: dismissible,
            builder: (_) => const Text('sheet body'),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('on a phone it is a bottom sheet, as before', (tester) async {
    await _open(tester, const Size(390, 844));
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('sheet body'), findsOneWidget);
  });

  testWidgets('on a tablet it is a centred dialog', (tester) async {
    await _open(tester, const Size(1194, 834));
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    // The Dialog widget itself fills the window; its Material is the card.
    final rect = tester.getRect(
      find.descendant(of: find.byType(Dialog), matching: find.byType(Material)).first,
    );
    expect(rect.width, lessThanOrEqualTo(560));
    expect(rect.center.dx, closeTo(597, 1));
  });

  testWidgets('a sheet that must not be dismissed is not, on a tablet', (
    tester,
  ) async {
    await _open(tester, const Size(1194, 834), dismissible: false);
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('sheet body'), findsOneWidget);
  });
}
