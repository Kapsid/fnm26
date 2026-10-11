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

  // The €1M level is the tablet's: a phone slider still moves €4M a notch,
  // ten notches, and anything under €4M left over is banked.
  testWidgets('a phone slider still moves €4M a notch', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
    );
    // A budget that leaves €3M over once three notches are spent.
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setBudget(save.careerId, 15000000),
    );
    save.container.invalidate(federationFundsProvider(save.careerId));
    await settle(tester);
    final youth = find.byType(Slider).first;
    expect(tester.widget<Slider>(youth).max, 10);
    expect(tester.widget<Slider>(youth).divisions, 10);
    expect(tester.widget<Slider>(youth).label, isNull);
    final confirm = find.widgetWithText(
      PrimaryButton,
      enL.federationConfirmBudget,
    );

    tester.widget<Slider>(youth).onChanged!(2);
    await tester.pump();
    expect(find.text(enL.deptLevelCost(2, '€8M')), findsOneWidget);
    // €7M left: a whole notch still fits.
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNull);

    tester.widget<Slider>(youth).onChanged!(3);
    await tester.pump();
    expect(find.text(enL.deptLevelCost(3, '€12M')), findsOneWidget);
    // €3M left: under a notch, banked.
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
  });
}
