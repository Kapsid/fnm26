import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/tactics/call_up_advice_sheet.dart';

import '../helpers/pump_app.dart';

/// The call-up quick picks are one row of three tiles that must fit the
/// narrowest phones in the longest languages.
void main() {
  final calls = <String>[];

  Future<void> pump(
    WidgetTester tester, {
    required double width,
    required Locale locale,
    StaffTier tier = StaffTier.good,
    bool previous = true,
    double height = 800,
  }) async {
    calls.clear();
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: CallUpQuickPicks(
            tier: tier,
            onBest: () => calls.add('best'),
            onPrevious: previous ? () => calls.add('previous') : null,
            onAssistant: () => calls.add('assistant'),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.pumpAndSettle();
  }

  for (final locale in const [Locale('en'), Locale('cs'), Locale('de')]) {
    for (final width in const [320.0, 360.0, 390.0]) {
      testWidgets('no overflow at $width in ${locale.languageCode}', (
        tester,
      ) async {
        await pump(tester, width: width, locale: locale, tier: StaffTier.none);
        expect(tester.takeException(), isNull);
        final tiles = find.byType(OutlinedButton);
        expect(tiles, findsNWidgets(3));
        final heights = {
          for (var i = 0; i < 3; i++) tester.getSize(tiles.at(i)).height,
        };
        expect(heights.length, 1);
        expect(heights.first, greaterThanOrEqualTo(44));
      });
    }
  }

  testWidgets('fits the tablet column at 1180x820', (tester) async {
    await pump(
      tester,
      width: 1180,
      height: 820,
      locale: const Locale('cs'),
      tier: StaffTier.none,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the three tiles call their handlers', (tester) async {
    await pump(tester, width: 360, locale: const Locale('en'));
    final tiles = find.byType(OutlinedButton);
    for (var i = 0; i < 3; i++) {
      await tester.tap(tiles.at(i));
    }
    expect(calls, ['best', 'previous', 'assistant']);
  });

  testWidgets('previous and assistant disable when unavailable', (
    tester,
  ) async {
    await pump(
      tester,
      width: 360,
      locale: const Locale('en'),
      tier: StaffTier.none,
      previous: false,
    );
    for (var i = 1; i < 3; i++) {
      await tester.tap(find.byType(OutlinedButton).at(i), warnIfMissed: false);
    }
    expect(calls, isEmpty);
  });
}
