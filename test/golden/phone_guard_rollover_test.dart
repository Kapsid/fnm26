import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The phone end of a cycle, pinned before the tablet layout is added beside
/// it: the champion (the seeded world's 2026 one, from its history), the
/// board's verdict with the jobs on offer, and the money banked. The board
/// and the money are list views, so each is pinned tall as well.
void main() {
  Future<SeededSave> open(WidgetTester tester, Size size) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.cycleRollover}?careerId=${save.careerId}',
      size: size,
    );
    return save;
  }

  Future<void> next(WidgetTester tester) async {
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
  }

  testWidgets('rollover_champion_phone', (tester) async {
    await open(tester, kPhoneSize);
    // The seeded world carries its 2026 history, so the champion is there.
    expect(find.text(enL.hubWorldChampionsYear(2026)), findsOneWidget);
    await expectAppGolden('goldens/rollover_champion_phone.png');
  });

  for (final (name, size) in [
    ('rollover_board_phone', kPhoneSize),
    ('rollover_board_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      await open(tester, size);
      await next(tester);
      expect(find.text(enL.hubOffersOnTable), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  for (final (name, size) in [
    ('rollover_income_phone', kPhoneSize),
    ('rollover_income_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      await open(tester, size);
      await next(tester);
      await next(tester);
      expect(find.text(enL.hubFederationFinances), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
