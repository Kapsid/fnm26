import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone World Championship screen on a finals-stage edition, pinned
/// before its tab bodies move into shared code: the bracket it lands on, and
/// the qualifying and finals group tabs, each in full.
void main() {
  for (final (name, size, tab) in [
    ('cup_detail_phone', kPhoneSize, null),
    ('cup_detail_phone_bracket_tall', const Size(390, 2000), null),
    ('cup_detail_phone_qualifying_tall', const Size(390, 2400), 1),
    ('cup_detail_phone_finals_tall', const Size(390, 2400), 3),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [
          cupDetailProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeCupData(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.cup}?careerId=${save.careerId}',
        size: size,
      );
      if (tab != null) await showTab(tester, tab);
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
