import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone results list, pinned before the tablet layout is added beside
/// it. The qualifying draw is watched first, or every fixture stays hidden.
void main() {
  for (final (name, size) in [
    ('results_phone', kPhoneSize),
    ('results_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.results}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.resultsNoFixtures), findsNothing);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
