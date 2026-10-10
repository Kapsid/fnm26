import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool invested = false,
}) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
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

/// The panel headed [title]. `.first`: a body may repeat its own heading
/// (the balance does), and the header comes first in the tree.
Finder _panel(String title) => find
    .ancestor(
      of: find.text(title.toUpperCase()).first,
      matching: find.byType(Panel),
    )
    .first;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('balance beside the projection, the buildings below, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(FinancesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final balance = tester.getRect(_panel(enL.federationBalance));
      final income = tester.getRect(_panel(enL.federationProjectedAtSeasonEnd));
      final buildings = tester.getRect(_panel(enL.federationDevelopment));
      expect(balance.top, income.top);
      expect(income.left, greaterThan(balance.right));
      expect(buildings.top, greaterThan(balance.bottom));
      for (final d in Department.values) {
        expect(
          find.text(
            '${departmentBuildingName(enL, d)}  ·  ${departmentLabel(enL, d)}',
          ),
          findsOneWidget,
        );
      }
      // Nothing invested yet: no locked-in panel.
      expect(
        find.text(enL.federationThisSeasonLocked.toUpperCase()),
        findsNothing,
      );
      expect(find.text(enL.federationNextCycleLocked), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("this cycle's investment sits beside the buildings", (
    tester,
  ) async {
    await _open(tester, kTabletSize, invested: true);
    expect(tester.takeException(), isNull);
    final locked = tester.getRect(_panel(enL.federationThisSeasonLocked));
    final buildings = tester.getRect(_panel(enL.federationDevelopment));
    expect(locked.top, buildings.top);
    expect(locked.left, greaterThan(buildings.right));
    expect(
      find.descendant(
        of: _panel(enL.federationThisSeasonLocked),
        matching: find.text('€8M'),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
