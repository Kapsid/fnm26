import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone achievements and challenges, pinned before the tablet layouts
/// are added beside them: a fresh save's lists, the achievements as the
/// screen opens and both lists in a tall window.
void main() {
  testWidgets('achievements_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.achievements}?careerId=${save.careerId}',
    );
    expect(find.text(enL.achievementsChallengesHeading), findsWidgets);
    await expectAppGolden('goldens/achievements_phone.png');
  });

  testWidgets('achievements_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.achievements}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await expectAppGolden('goldens/achievements_phone_tall.png');
  });

  testWidgets('challenges_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.challenges}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.achievementsHardestTests), findsOneWidget);
    await expectAppGolden('goldens/challenges_phone_tall.png');
  });
}
