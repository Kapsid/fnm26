import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<bool> probeLayout(
    WidgetTester tester,
    Size size,
    FormFactor formFactor,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late bool result;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [formFactorProvider.overrideWithValue(formFactor)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              result = useTabletLayout(context, ref);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    return result;
  }

  testWidgets('a tablet layout needs a tablet AND a tablet-sized window', (
    tester,
  ) async {
    expect(
      await probeLayout(tester, const Size(1194, 834), FormFactor.tablet),
      isTrue,
    );
  });

  testWidgets('the default 800x600 test window on a phone build stays phone', (
    tester,
  ) async {
    expect(
      await probeLayout(tester, const Size(800, 600), FormFactor.phone),
      isFalse,
    );
  });

  testWidgets('a tablet in split view stays phone', (tester) async {
    expect(
      await probeLayout(tester, const Size(507, 834), FormFactor.tablet),
      isFalse,
    );
  });
}
