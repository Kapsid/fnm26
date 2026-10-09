import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';

void main() {
  Future<bool> probe(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late bool result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            result = context.isTabletWindow;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('tablet window', (tester) async {
    expect(await probe(tester, const Size(1194, 834)), isTrue);
  });

  testWidgets('phone window', (tester) async {
    expect(await probe(tester, const Size(390, 844)), isFalse);
  });

  testWidgets('a tablet squeezed into split view is not a tablet window', (
    tester,
  ) async {
    expect(await probe(tester, const Size(507, 834)), isFalse);
  });
}
