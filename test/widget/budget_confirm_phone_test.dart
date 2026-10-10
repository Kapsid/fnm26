import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The phone's budget Confirm: its post-await code now reads through a
/// captured container and router, so pin what it does on a phone.
void main() {
  testWidgets('Confirm stores the budget and lands on the hub', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
    );
    final repo = save.container.read(careerRepositoryProvider);
    // The stored balance, not `save.career` (that is the career as created,
    // before the opening budget was granted).
    final before = (await tester.runAsync(() => repo.byId(save.careerId)))!;
    expect(before.budget, greaterThan(0));
    final investedBefore = (await tester.runAsync(
      () => repo.investment(save.careerId, before.cyclePointer),
    ))!;
    expect(
      investedBefore.youth +
          investedBefore.commercial +
          investedBefore.medical +
          investedBefore.naturalization +
          investedBefore.boardRelations,
      0,
    );

    final sliders = find.byType(Slider);
    expect(sliders, findsNWidgets(5));
    for (var i = 0; i < 5; i++) {
      final slider = tester.widget<Slider>(sliders.at(i));
      slider.onChanged!(slider.max);
      await tester.pump();
    }
    final confirm = find.widgetWithText(
      PrimaryButton,
      enL.federationConfirmBudget,
    );
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNotNull);
    await tester.tap(confirm);
    await settle(tester);
    expect(tester.takeException(), isNull);

    final after = (await tester.runAsync(() => repo.byId(save.careerId)))!;
    final stored = (await tester.runAsync(
      () => repo.investment(save.careerId, after.cyclePointer),
    ))!;
    final spent =
        stored.youth +
        stored.commercial +
        stored.medical +
        stored.naturalization +
        stored.boardRelations;
    expect(spent, greaterThan(0));
    expect(budgetReady(available: before.budget, allocated: spent), isTrue);
    expect(after.budget, before.budget - spent);
    expect(save.container.read(routerProvider).state.uri.path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });
}
