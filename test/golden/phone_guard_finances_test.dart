import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

import '../helpers/seeded_save.dart';

/// The phone finances, pinned before the tablet layout is added beside it:
/// once as a fresh save shows it, once with this cycle's investment locked
/// in (the screen's other section).
void main() {
  for (final (name, size) in [
    ('finances_phone', kPhoneSize),
    ('finances_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.finances}?careerId=${save.careerId}',
        size: size,
      );
      expect(
        find.text(
          '${departmentBuildingName(enL, Department.youth)}'
          '  ·  ${departmentLabel(enL, Department.youth)}',
        ),
        findsOneWidget,
      );
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('finances_phone_invested_tall', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setInvestment(save.careerId, save.career.cyclePointer, (
            youth: 8000000,
            commercial: 4000000,
            medical: 2000000,
            naturalization: 0,
            boardRelations: 1000000,
          )),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.finances}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.federationThisSeasonLocked), findsOneWidget);
    await expectAppGolden('goldens/finances_phone_invested_tall.png');
  });
}
