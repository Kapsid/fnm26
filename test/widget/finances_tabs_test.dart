import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/shared/widgets/app_segmented_tabs.dart';

import '../helpers/expect_whole.dart';
import '../helpers/seeded_save.dart';

/// The finances in three tabs: Overview, Departments, Facilities. Each shows
/// its own part of the page, and the Facilities' Stadiums tile opens the
/// national stadiums.
Future<SeededSave> _open(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  Size size = kPhoneSize,
  bool invested = false,
}) async {
  final save = await seedSave(tester, formFactor: formFactor);
  if (invested) {
    await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).setInvestment(
        save.careerId,
        save.career.cyclePointer,
        (
          youth: 8000000,
          commercial: 0,
          medical: 0,
          naturalization: 0,
          boardRelations: 0,
        ),
      ),
    );
  }
  await pumpRoute(
    tester,
    save,
    '${Routes.finances}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<void> _tab(WidgetTester tester, Key key) async {
  // A long label can put a tab past the edge of the strip: scroll to it.
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  // The page slides in first; then its providers load.
  await tester.pumpAndSettle();
  await settle(tester);
}

void main() {
  testWidgets('phone: three tabs, each with its own part of the page', (
    tester,
  ) async {
    await _open(tester, size: const Size(390, 1400), invested: true);
    expect(tester.takeException(), isNull);
    for (final key in [
      FinancesScreen.tabOverviewKey,
      FinancesScreen.tabDepartmentsKey,
      FinancesScreen.tabFacilitiesKey,
    ]) {
      expect(find.byKey(key), findsOneWidget);
    }
    expect(find.byType(AppSegmentedControl), findsOneWidget);

    // Overview: the balance, the projection, the note on the next budget.
    expect(find.text(enL.federationBalance), findsOneWidget);
    expect(find.text(enL.federationProjectedAtSeasonEnd), findsOneWidget);
    expect(find.text(enL.federationNextCycleLocked), findsOneWidget);
    expect(find.text(enL.federationThisSeasonLocked), findsNothing);
    expect(find.byKey(FinancesScreen.stadiumsTileKey), findsNothing);

    // Departments: this cycle's money, department by department.
    await _tab(tester, FinancesScreen.tabDepartmentsKey);
    expect(find.text(enL.federationThisSeasonLocked), findsOneWidget);
    for (final d in Department.values) {
      expect(find.text(departmentLabel(enL, d)), findsOneWidget);
    }
    expect(find.text('€8M'), findsOneWidget);
    expect(find.text(enL.federationInvestAtCeremony), findsOneWidget);
    expect(find.text(enL.federationBalance), findsNothing);

    // Facilities: a tile per building, then the stadiums.
    await _tab(tester, FinancesScreen.tabFacilitiesKey);
    expect(find.text(enL.federationDevelopment), findsOneWidget);
    for (final d in Department.values) {
      final tile = find.byKey(FinancesScreen.buildingKey(d));
      expect(tile, findsOneWidget);
      expect(
        find.descendant(
          of: tile,
          matching: find.text(departmentBuildingName(enL, d)),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile,
          matching: find.textContaining(' / ${FederationBuildings.maxLevel}'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile,
          matching: find.byType(LinearProgressIndicator),
        ),
        findsOneWidget,
      );
    }
    // Two to a row.
    final youth = tester.getRect(
      find.byKey(FinancesScreen.buildingKey(Department.youth)),
    );
    final commercial = tester.getRect(
      find.byKey(FinancesScreen.buildingKey(Department.commercial)),
    );
    expect(commercial.top, youth.top);
    expect(commercial.left, greaterThan(youth.right));
    expect(find.byKey(FinancesScreen.stadiumsTileKey), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone: the Stadiums tile opens the national stadiums', (
    tester,
  ) async {
    await _open(tester, size: const Size(390, 1400));
    await _tab(tester, FinancesScreen.tabFacilitiesKey);
    final tile = find.byKey(FinancesScreen.stadiumsTileKey);
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await settle(tester);
    expect(find.byType(NationalStadiumsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final locale in const ['cs', 'de', 'fi']) {
    testWidgets('phone at the largest text, $locale: the tiles fit', (
      tester,
    ) async {
      final save = await seedSave(tester);
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpRoute(
        tester,
        save,
        '${Routes.finances}?careerId=${save.careerId}',
        size: const Size(320, 1600),
        locale: Locale(locale),
      );
      expect(tester.takeException(), isNull);
      await _tab(tester, FinancesScreen.tabFacilitiesKey);
      expect(tester.takeException(), isNull);
      expectNothingCut(tester, 'the facilities in $locale');
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('tablet: the same three tabs', (tester) async {
    await _open(
      tester,
      formFactor: FormFactor.tablet,
      size: kTabletSize,
      invested: true,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(FinancesScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.federationNextCycleLocked), findsOneWidget);
    await _tab(tester, FinancesScreen.tabDepartmentsKey);
    expect(find.text('€8M'), findsOneWidget);
    await _tab(tester, FinancesScreen.tabFacilitiesKey);
    // Three to a row on a tablet.
    final youth = tester.getRect(
      find.byKey(FinancesScreen.buildingKey(Department.youth)),
    );
    final medical = tester.getRect(
      find.byKey(FinancesScreen.buildingKey(Department.medical)),
    );
    expect(medical.top, youth.top);
    expect(find.byKey(FinancesScreen.stadiumsTileKey), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
