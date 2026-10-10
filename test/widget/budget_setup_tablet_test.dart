import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.budgetSetup}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Slider _slider(WidgetTester tester, int i) =>
    tester.widget<Slider>(find.byType(Slider).at(i));

/// Drags the [i]th slider (Youth first) to [euros], as a finger would.
Future<void> _set(WidgetTester tester, int i, double euros) async {
  _slider(tester, i).onChanged!(euros);
  await tester.pump();
}

Finder _effect(Department d) => find.byKey(ValueKey('budget.effect.${d.name}'));

/// The page's own Confirm (the top bar's Continue is outside the page).
PrimaryButton _confirmButton(WidgetTester tester) =>
    tester.widget<PrimaryButton>(
      find.descendant(
        of: find.byKey(BudgetSetupScreen.tabletLayoutKey),
        matching: find.byType(PrimaryButton),
      ),
    );

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the sliders left, staff and effects right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final editor = tester.getRect(find.byType(InvestmentEditor));
      final staff = tester.getRect(find.byType(StaffCard));
      final effects = tester.getRect(
        find.byKey(BudgetSetupScreen.effectsKey),
      );
      expect(staff.left, greaterThan(editor.right));
      expect(effects.left, staff.left);
      // The tour finds both of its targets.
      expect(find.byKey(TourKeys.budgetDepartments), findsOneWidget);
      expect(find.byKey(TourKeys.budgetStaff), findsOneWidget);
      // Nothing allocated: every department says so, once, on the right.
      for (final d in Department.values) {
        expect(
          tester.widget<Text>(_effect(d)).data,
          enL.deptEffectNone,
        );
      }
      expect(find.text(enL.deptEffectNone), findsNWidgets(5));
      expect(_confirmButton(tester).onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a slider moves its effect on the right', (tester) async {
    await _open(tester, kTabletSize);
    await _set(tester, 0, 8000000);
    final line = DepartmentEffect.describe(enL, Department.youth, 8000000);
    expect(tester.widget<Text>(_effect(Department.youth)).data, line);
    // Said once: the slider's own effect line is hidden on a tablet.
    expect(find.text(line), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the allocation', (tester) async {
    await _open(tester, kTabletSize);
    await _set(tester, 0, 8000000);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsNothing);
    expect(_slider(tester, 0).value, 8000000);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsOneWidget);
    expect(_slider(tester, 0).value, 8000000);
    expect(
      tester.widget<Text>(_effect(Department.youth)).data,
      DepartmentEffect.describe(enL, Department.youth, 8000000),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('spent in full, confirmed: stored, and the bar moves on', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    // Review Focus 2: the bar offers the budget before...
    expect(topBarContinue(tester).label, enL.hubEventSetBudget);
    // The stored balance, not `save.career`: that is the career as created,
    // before the opening budget was granted to it.
    final budget = (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))!.budget;
    expect(budget, greaterThan(0));
    for (var i = 0; i < 5; i++) {
      final slider = _slider(tester, i);
      await _set(tester, i, slider.max);
    }
    final ready = _confirmButton(tester);
    expect(ready.onPressed, isNotNull);
    await tester.tap(find.byWidget(ready));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.hub,
    );
    await tester.runAsync(() async {
      final career = (await save.container
          .read(careerRepositoryProvider)
          .byId(save.careerId))!;
      final stored = await save.container
          .read(careerRepositoryProvider)
          .investment(save.careerId, career.cyclePointer);
      final spent =
          stored.youth +
          stored.commercial +
          stored.medical +
          stored.naturalization +
          stored.boardRelations;
      expect(spent, greaterThan(0));
      expect(budgetReady(available: budget, allocated: spent), isTrue);
      expect(career.budget, budget - spent);
    });
    // ...and not after.
    expect(topBarContinue(tester).label, isNot(enL.hubEventSetBudget));
    await tester.pumpWidget(const SizedBox());
  });
}
