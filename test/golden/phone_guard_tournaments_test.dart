import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';

import '../helpers/seeded_save.dart';

/// The phone Tournaments overview, pinned before its tiles are built from
/// the specs both layouts share.
///
/// At 390 wide a tile whose name takes two lines ("World Championship",
/// "African Championship", ...) already overflows its 1.25 aspect cell by a
/// few pixels. That is the phone as it ships, so this guard pins it as it is:
/// it lets RenderFlex overflows through, counts them, and expects the same
/// count, so a change that adds or removes one still fails here.
void main() {
  for (final (name, size, overflows) in [
    ('tournaments_phone', kPhoneSize, 6),
    ('tournaments_phone_tall', const Size(390, 1600), 6),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      var seen = 0;
      final original = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
          seen++;
          return;
        }
        original?.call(details);
      };
      try {
        await pumpRoute(
          tester,
          save,
          '${Routes.tournaments}?careerId=${save.careerId}',
          size: size,
        );
      } finally {
        FlutterError.onError = original;
      }
      expect(seen, overflows, reason: 'the overview overflows differently');
      expect(find.byKey(TourKeys.worldRanking), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
