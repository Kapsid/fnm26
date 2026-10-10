import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/federation/investment_editor.dart';

import '../helpers/seeded_save.dart';

/// The phone budget setup, pinned before its banner and confirm bar are
/// shared with the tablet: as it opens, and with money in two departments
/// (effect lines lit, the over-budget and ready states of the bar).
void main() {
  for (final (name, size) in [
    ('budget_phone', kPhoneSize),
    ('budget_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.budgetSetup}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(InvestmentEditor), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('budget_allocated_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    // Every slider to its top, in order: the first takes its cap, the next
    // what is left, and the budget is spent.
    for (var i = 0; i < 5; i++) {
      final slider = tester.widget<Slider>(find.byType(Slider).at(i));
      slider.onChanged?.call(slider.max);
      await tester.pump();
    }
    await settle(tester);
    await expectAppGolden('goldens/budget_allocated_phone_tall.png');
  });
}
