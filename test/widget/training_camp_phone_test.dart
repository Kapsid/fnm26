import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone's camp choice: its tap now leaves through a captured router,
/// so pin what it does on a phone.
void main() {
  testWidgets('a tapped camp is stored, then the hub', (tester) async {
    final plan = fakeCampPlan(campHosts(1));
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
    );
    Future<({int hostId, int campIndex})?> stored() =>
        tester.runAsync<({int hostId, int campIndex})?>(
          () => save.container
              .read(careerRepositoryProvider)
              .trainingCamp(save.careerId, plan.cycle, plan.tournament),
        );
    expect(await stored(), isNull);
    final option = plan.options[1];
    await tester.tap(find.text(option.camp.name));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(save.container.read(routerProvider).state.uri.path, Routes.hub);
    final camp = await stored();
    expect(camp?.hostId, option.hostId);
    expect(camp?.campIndex, option.camp.index);
    await tester.pumpWidget(const SizedBox());
  });
}
