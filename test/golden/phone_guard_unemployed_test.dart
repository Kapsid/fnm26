import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone out-of-work offers, pinned before the tablet layout is added
/// beside them. The draw is seeded through [unemployedOfferSeedProvider], so
/// the same three come every run. The page is a list view, so it is pinned
/// tall as well.
void main() {
  for (final (name, size) in [
    ('unemployed_phone', kPhoneSize),
    ('unemployed_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [unemployedOfferSeedProvider.overrideWithValue(7)],
      );
      await pumpRoute(tester, save, Routes.startFromBottom, size: size);
      expect(find.text(enL.bottomStartHeading), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
