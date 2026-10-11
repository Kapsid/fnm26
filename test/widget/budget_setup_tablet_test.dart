import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/federation/staff_providers.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  _Gate? gate,
  bool hires = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (gate != null)
        careerRepositoryProvider.overrideWith(
          (ref) => _GatedRepository(ref.watch(appDatabaseProvider), gate),
        ),
      if (hires)
        // A hire (ManagerService) invalidates morale, which nothing on this
        // page watches, so nothing rebuilds it.
        // Test-only, no app change: in riverpod 2.6.1
        // (async_notifier/base.dart 461-466) an invalidated FutureProvider
        // element that is never rebuilt before the container is disposed
        // has its future completed a second time on that dispose ("Bad
        // state: Future already completed"). A value with no awaits is never
        // left in that state. Revisit at the Riverpod 3 upgrade.
        moraleProvider(kSeededCareerId).overrideWith((ref) async => 50),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.budgetSetup}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

/// Armed by a test once the save is seeded: until then nothing is held.
class _Gate {
  Completer<void>? completer;
}

/// The real repository, holding the investment write back while its gate is
/// armed: the manager can then leave the page while the budget is still
/// being written.
class _GatedRepository extends DriftCareerRepository {
  _GatedRepository(super._db, this.gate);

  final _Gate gate;

  @override
  Future<void> setInvestment(
    int careerId,
    int cycle,
    FederationInvestment i,
  ) async {
    await gate.completer?.future;
    return super.setInvestment(careerId, cycle, i);
  }
}

/// The stored career, not `save.career` (that is the career as created,
/// before the opening budget was granted to it).
Future<Career> _career(WidgetTester tester, SeededSave save) async =>
    (await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    ))!;

/// The total stored as this cycle's investment.
Future<int> _invested(WidgetTester tester, SeededSave save) async {
  final career = await _career(tester, save);
  final stored = (await tester.runAsync(
    () => save.container
        .read(careerRepositoryProvider)
        .investment(save.careerId, career.cyclePointer),
  ))!;
  return stored.youth +
      stored.commercial +
      stored.medical +
      stored.naturalization +
      stored.boardRelations;
}

/// Spends every department in full and taps the page's Confirm.
Future<void> _spendAndConfirm(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await _set(tester, i, _slider(tester, i).max);
  }
  final ready = _confirmButton(tester);
  expect(ready.onPressed, isNotNull);
  await tester.tap(find.byWidget(ready));
  await tester.pump();
}

Slider _slider(WidgetTester tester, int i) =>
    tester.widget<Slider>(find.byType(Slider).at(i));

/// Drags the [i]th slider (Youth first) to [level], as a finger would. The
/// tablet's sliders run in whole levels of
/// [FederationFinance.investLevelPrice] (€1M), one a notch.
Future<void> _set(WidgetTester tester, int i, double level) async {
  _slider(tester, i).onChanged!(level);
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
    await _set(tester, 0, 8); // eight levels: €8M
    final line = DepartmentEffect.describe(enL, Department.youth, 8000000);
    expect(tester.widget<Text>(_effect(Department.youth)).data, line);
    // Said once: the slider's own effect line is hidden on a tablet.
    expect(find.text(line), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tablet slider moves €1M a notch', (tester) async {
    await _open(tester, kTabletSize);
    final youth = _slider(tester, 0);
    expect(youth.max, 40);
    expect(youth.divisions, 40);
    expect(_slider(tester, 2).max, 24); // Medical
    await _set(tester, 0, 1);
    expect(_slider(tester, 0).value, 1);
    expect(find.text(enL.deptLevelCost(1, '€1M')), findsOneWidget);
    // The drag bubble names the sum, so forty stops still read.
    expect(_slider(tester, 0).label, '€1M');
    expect(
      tester.widget<Text>(_effect(Department.youth)).data,
      DepartmentEffect.describe(enL, Department.youth, 1000000),
    );
    await _set(tester, 0, 7);
    expect(find.text(enL.deptLevelCost(7, '€7M')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tablet banks €0.5M: under a million is spent', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setBudget(save.careerId, 10500000),
    );
    save.container.invalidate(federationFundsProvider(save.careerId));
    await settle(tester);
    await _set(tester, 0, 9);
    // €1.5M left: another million fits.
    expect(_confirmButton(tester).onPressed, isNull);
    await _set(tester, 0, 10);
    // €0.5M left: no million fits, so it is banked.
    expect(find.text(enL.deptLevelCost(10, '€10M')), findsOneWidget);
    expect(_confirmButton(tester).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the allocation', (tester) async {
    await _open(tester, kTabletSize);
    await _set(tester, 0, 8); // eight €1M levels: €8M
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsNothing);
    // The phone reads the same €8M on its €4M notches: the second.
    expect(_slider(tester, 0).value, 2);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsOneWidget);
    expect(_slider(tester, 0).value, 8);
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
    expect(await _invested(tester, save), 0);
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
      expect(
        budgetReady(
          available: budget,
          allocated: spent,
          stepLevels: kTabletBudgetStepLevels,
        ),
        isTrue,
      );
      expect(career.budget, budget - spent);
    });
    // ...and not after.
    expect(topBarContinue(tester).label, isNot(enL.hubEventSetBudget));
    await tester.pumpWidget(const SizedBox());
  });

  // Settings pushed over the page while the budget is being written: the
  // budget is stored, and he is left on Settings, not pulled to the hub.
  testWidgets('a budget saved under a pushed page leaves him there', (
    tester,
  ) async {
    final gate = _Gate();
    final save = await _open(tester, kTabletSize, gate: gate);
    expect(await _invested(tester, save), 0);
    gate.completer = Completer<void>();
    await _spendAndConfirm(tester);
    final router = save.container.read(routerProvider);
    unawaited(router.push(Routes.settings));
    await settle(tester);
    expect(router.state.uri.path, Routes.settings);
    expect(await _invested(tester, save), 0);
    gate.completer!.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(router.state.uri.path, Routes.settings);
    expect(await _invested(tester, save), greaterThan(0));
    await tester.pumpWidget(const SizedBox());
  });

  // He goes elsewhere while the budget is being written, which unmounts the
  // page: the hub's data is still refreshed, so the top bar stops offering
  // the budget, and he is not pulled back to the hub.
  testWidgets('leaving while the budget is saving still moves the bar on', (
    tester,
  ) async {
    final gate = _Gate();
    final save = await _open(tester, kTabletSize, gate: gate);
    expect(await _invested(tester, save), 0);
    expect(topBarContinue(tester).label, enL.hubEventSetBudget);
    gate.completer = Completer<void>();
    await _spendAndConfirm(tester);
    final router = save.container.read(routerProvider)
      ..go('${Routes.finances}?careerId=${save.careerId}');
    await settle(tester);
    expect(router.state.uri.path, Routes.finances);
    expect(topBarContinue(tester).label, enL.hubEventSetBudget);
    gate.completer!.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(router.state.uri.path, Routes.finances);
    expect(await _invested(tester, save), greaterThan(0));
    expect(topBarContinue(tester).label, isNot(enL.hubEventSetBudget));
    await tester.pumpWidget(const SizedBox());
  });

  // The back arrow says what it does, as the phone's does: the budget can
  // wait, and the hub will ask again.
  testWidgets('the back arrow is "later", and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final back = find.byTooltip(enL.federationBudgetLater);
    expect(back, findsOneWidget);
    await tester.tap(back);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(save.container.read(routerProvider).state.uri.path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  // The picker is open when the window crosses 1000: the tablet layout gives
  // way to the phone one, and the StaffCard moves with its GlobalKey, so the
  // hire made after the swap still goes through.
  testWidgets('a hire made across a resize is stored', (tester) async {
    final save = await _open(tester, kTabletSize, hires: true);
    expect((await _career(tester, save)).staffAssistantId, isNull);
    late StaffCandidate first;
    await tester.runAsync(() async {
      final sub = save.container.listen(
        staffRoomProvider(save.careerId).future,
        (_, _) {},
      );
      first = (await sub.read())!.applicants[StaffRole.assistant]!.first;
      sub.close();
    });
    await tester.tap(find.text(roleName(enL, StaffRole.assistant)));
    await settle(tester);
    expect(find.text(first.name), findsOneWidget);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsNothing);
    await tester.tap(find.text(first.name));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect((await _career(tester, save)).staffAssistantId, first.id);
    await tester.pumpWidget(const SizedBox());
  });
}
