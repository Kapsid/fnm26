import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone career summary and manager's career, pinned before the tablet
/// layouts are added beside them, each whole in a tall window.
void main() {
  testWidgets('career_summary_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.careerSummary}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.careerTournamentHistory), findsOneWidget);
    await expectAppGolden('goldens/career_summary_phone_tall.png');
  });

  testWidgets('manager_history_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.managerHistory}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.careerCycleByCycle), findsOneWidget);
    await expectAppGolden('goldens/manager_history_phone_tall.png');
  });
}
