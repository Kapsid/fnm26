import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../helpers/seeded_save.dart';

/// The phone European Championship screen on the seeded save, its qualifying
/// draw watched, so it lands on the qualifying groups: pinned before its tab
/// bodies move into shared code.
void main() {
  for (final (name, size) in [
    ('continental_detail_phone', kPhoneSize),
    ('continental_detail_phone_tall', const Size(390, 3200)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.continental}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
