import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/host_bid_screen.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// Tall enough that every department slider is built.
const Size _tall = Size(390, 2400);

Future<int> _balance(WidgetTester tester, SeededSave save) async =>
    (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))!.budget;

/// Moves the [i]th department slider on the budget screen to [levels].
Future<void> _setDept(WidgetTester tester, int i, int levels) async {
  final slider = tester.widget<Slider>(
    find
        .descendant(
          of: find.byType(BudgetSetupScreen),
          matching: find.byType(Slider),
        )
        .at(i),
  );
  slider.onChanged!(levels.toDouble());
  await tester.pump();
}

void main() {
  // d) Hosting and the national stadiums sit at the bottom, under the
  // department sliders; nothing pushes the sliders down any more.
  testWidgets('d) the hosting card and the stadiums entry sit under the '
      'sliders', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
      size: _tall,
    );
    final sliders = find.descendant(
      of: find.byType(BudgetSetupScreen),
      matching: find.byType(Slider),
    );
    expect(sliders, findsWidgets);
    final lastSlider = tester.getBottomLeft(sliders.last).dy;
    final card = find.byKey(HostBidStatusCard.cardKey);
    expect(card, findsOneWidget);
    expect(tester.getTopLeft(card).dy, greaterThan(lastSlider));
    final stadiums = find.byKey(NationalStadiumsEntry.entryKey);
    expect(
      tester.getTopLeft(stadiums).dy,
      greaterThan(tester.getTopLeft(card).dy),
    );
    // On the budget screen the card informs; the bid is made at the close of
    // the cycle, so no row opens the bid screen here.
    expect(
      find.byKey(HostBidStatusCard.entryKey(HostBidComp.continental)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a won grant tops up this cycle at once, and only adds', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final repo = save.container.read(careerRepositoryProvider);
    final comp = save.container.read(competitionRepositoryProvider);
    const already = (
      youth: 3000000,
      commercial: 2000000,
      medical: 0,
      naturalization: 0,
      boardRelations: 0,
    );
    await tester.runAsync(() async {
      // The budget round is done; €7M won with a bid landed since.
      await repo.setInvestment(save.careerId, 0, already);
      await repo.setBudget(save.careerId, 9000000);
      await comp.markDrawWatched(save.careerId, 0, budgetSetupKind);
      await comp.markDrawWatched(
        save.careerId,
        0,
        HostBidding.grantOpenKind(HostBidComp.continental, 1, 7000000),
      );
    });
    final grant = (await tester.runAsync(
      () => save.container.read(hostBidGrantProvider(save.careerId).future),
    ))!;
    expect(grant.amount, 7000000);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}&grant=1',
      size: _tall,
    );
    expect(find.text(enL.hostBidGrantBanner('€7M')), findsOneWidget);
    // Youth cannot go under what the budget round gave it.
    await _setDept(tester, 0, 0);
    expect(
      tester.widget<Slider>(find.byType(Slider).first).value,
      3,
    );
    // Put €4M of the grant into medical; €3M stays in the bank.
    await _setDept(tester, 2, 4);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.federationConfirmBudget),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(await _balance(tester, save), 5000000);
    final now = (await tester.runAsync(
      () => repo.investment(save.careerId, 0),
    ))!;
    expect(now.medical, 4000000);
    expect(now.youth, 3000000);
    expect(now.commercial, 2000000);
    save.container.invalidate(hostBidGrantProvider(save.careerId));
    expect(
      await tester.runAsync(
        () => save.container.read(hostBidGrantProvider(save.careerId).future),
      ),
      isNull,
    );
  });
}
