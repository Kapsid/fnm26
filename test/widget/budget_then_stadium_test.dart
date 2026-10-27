import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// Tall enough that every department slider is built.
const Size _tall = Size(390, 2400);

/// b8 item 3: once the budget was set, the only way to the national stadiums
/// was a bare icon in the finances app bar, and a tester never found it. The
/// finances page now carries the labelled stadiums row the budget screen has.
void main() {
  /// Spends the whole budget, a slider at a time, and confirms it.
  Future<void> setBudget(WidgetTester tester) async {
    final sliders = find.descendant(
      of: find.byType(BudgetSetupScreen),
      matching: find.byType(Slider),
    );
    for (var i = 0; i < sliders.evaluate().length; i++) {
      final s = tester.widget<Slider>(sliders.at(i));
      s.onChanged!(s.max);
      await tester.pump();
    }
    final confirm = find.widgetWithText(
      PrimaryButton,
      enL.federationConfirmBudget,
    );
    expect(tester.widget<PrimaryButton>(confirm).onPressed, isNotNull);
    await tester.tap(confirm);
    await settle(tester);
  }

  for (final formFactor in FormFactor.values) {
    testWidgets(
      'budget, then the stadiums from the hub via the finances ($formFactor)',
      (
        tester,
      ) async {
        final save = await seedSave(tester, formFactor: formFactor);
        final size = formFactor == FormFactor.tablet ? kTabletSize : _tall;
        await pumpRoute(
          tester,
          save,
          '${Routes.budgetSetup}?careerId=${save.careerId}',
          size: size,
        );
        await setBudget(tester);
        final router = save.container.read(routerProvider);
        expect(router.state.uri.path, Routes.hub);
        expect(find.byType(HubScreen), findsOneWidget);
        // The budget is in: the round is marked done.
        final done = await tester.runAsync(
          () => save.container
              .read(competitionRepositoryProvider)
              .hasWatchedDraw(save.careerId, 0, budgetSetupKind),
        );
        expect(done, isTrue);

        // From the hub itself: the phone's board strip money button, the
        // tablet's Federation > Finances in the sidebar (both this icon).
        final finances = find.byIcon(Icons.account_balance);
        expect(finances, findsWidgets);
        await tester.ensureVisible(finances.first);
        await tester.tap(finances.first);
        await settle(tester);
        expect(find.byType(FinancesScreen), findsOneWidget);
        final entry = find.byKey(NationalStadiumsEntry.entryKey);
        await tester.scrollUntilVisible(
          entry,
          200,
          scrollable: find.byType(Scrollable).last,
        );
        expect(find.text(enL.stadiumsTitle), findsWidgets);
        // The works window shut with the budget, and the row says so.
        expect(find.text(enL.stadiumsEntrySubClosed), findsOneWidget);
        await tester.tap(entry);
        await settle(tester);
        expect(find.byType(NationalStadiumsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
