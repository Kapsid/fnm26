import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/seeded_save.dart';

/// `settle` used to give up silently on a spinner that never went away, so a
/// golden could be taken of a screen still loading. It must say so instead.
void main() {
  testWidgets('a spinner that outlives the cap fails the test', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
    await expectLater(
      settle(tester, maxWait: const Duration(milliseconds: 200)),
      throwsA(isA<TestFailure>()),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('unless the spinner is the content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
    await settle(
      tester,
      maxWait: const Duration(milliseconds: 200),
      allowSpinner: true,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a screen without a spinner settles', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('ready')));
    await settle(tester, rounds: 2);
    expect(find.text('ready'), findsOneWidget);
  });
}
