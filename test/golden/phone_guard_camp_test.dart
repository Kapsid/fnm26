import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone base-camp decision, pinned before its header and cards are
/// shared with the tablet: one host, three co-hosts, and nothing to decide.
void main() {
  for (final (name, hosts) in [
    ('camp_phone_tall', 1),
    ('camp_cohosts_phone_tall', 3),
  ]) {
    testWidgets(name, (tester) async {
      final plan = fakeCampPlan(campHosts(hosts));
      final save = await seedSave(
        tester,
        overrides: [
          trainingCampPlanProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => plan),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.trainingCamp}?careerId=${save.careerId}',
        size: const Size(390, 2400),
      );
      expect(find.text(plan.options.first.camp.name), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('camp_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.trainingCamp}?careerId=${save.careerId}',
    );
    expect(find.text(enL.hubContinue), findsOneWidget);
    await expectAppGolden('goldens/camp_none_phone.png');
  });
}
