import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Nations Cup on a mid-season ladder, pinned before its tab
/// bodies move into the shared mixin.
void main() {
  for (final (name, size) in [
    ('nations_cup_phone', kPhoneSize),
    ('nations_cup_phone_tall', const Size(390, 1600)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: null,
          )).overrideWith((ref) async => fakeNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.tourContGroupHeading('B1')), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
