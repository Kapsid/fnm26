import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The Standings overview on an iPhone 15 (393 points) and on the narrowest
/// phone (320), in the languages with the longest competition names and
/// status chips: no tile may spill its name, zone or chip out of its cell.
void main() {
  for (final size in const [Size(393, 852), Size(320, 640)]) {
    for (final code in const ['en', 'de', 'pt', 'fr']) {
      testWidgets('tiles fit, $code at ${size.width.toInt()}', (tester) async {
        final save = await seedSave(tester);
        await pumpRoute(
          tester,
          save,
          '${Routes.tournaments}?careerId=${save.careerId}',
          size: size,
          locale: Locale(code),
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
