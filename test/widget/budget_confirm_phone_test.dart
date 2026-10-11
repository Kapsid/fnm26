import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
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
    expect(
      budgetReady(
        available: before.budget,
        allocated: spent,
        stepLevels: kPhoneBudgetStepLevels,
      ),
      isTrue,
    );
    expect(after.budget, before.budget - spent);
    expect(save.container.read(routerProvider).state.uri.path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  // A phone slider moves €1M a notch, like the tablet's: forty notches, a
  // bubble naming the sum, and anything under €1M left over is banked.
  testWidgets('a phone slider moves €1M a notch', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
    );
    // A budget that leaves €0.5M over once twelve notches are spent.
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setBudget(save.careerId, 12500000),
    );
    save.container.invalidate(federationFundsProvider(save.careerId));
    await settle(tester);
    final youth = find.byType(Slider).first;
    expect(tester.widget<Slider>(youth).max, 40);
    expect(tester.widget<Slider>(youth).divisions, 40);
    expect(tester.widget<Slider>(youth).label, isNotNull);
    final confirm = find.widgetWithText(
      PrimaryButton,
      enL.federationConfirmBudget,
    );

    tester.widget<Slider>(youth).onChanged!(11);
    await tester.pump();
    expect(find.text(enL.deptLevelCost(11, '€11M')), findsOneWidget);
    // €1.5M left: a whole notch still fits.
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNull);

    tester.widget<Slider>(youth).onChanged!(12);
    await tester.pump();
    expect(find.text(enL.deptLevelCost(12, '€12M')), findsOneWidget);
    // €0.5M left: under a notch, banked.
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
  });
}
