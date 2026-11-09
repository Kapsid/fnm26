import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';

import '../helpers/seeded_save.dart';

/// The phone Tournaments overview, pinned before its tiles are built from
/// the specs both layouts share.
///
/// At 390 wide a tile whose name takes two lines ("World Championship",
/// "African Championship", ...) used to overflow its fixed 1.25 aspect cell
/// by a few pixels; the cells now grow to their taller tile. The guard still
/// counts RenderFlex overflows and expects none, so one creeping back in
/// fails here.
void main() {
  for (final (name, size, overflows) in [
    ('tournaments_phone', kPhoneSize, 0),
    ('tournaments_phone_tall', const Size(390, 1600), 0),
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
