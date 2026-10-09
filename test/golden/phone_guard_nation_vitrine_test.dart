import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone vitrine, pinned before its body moves into NationView. Must pass
/// unchanged for the rest of the tablet work.
void main() {
  for (final (name, size) in [
    ('nation_vitrine_phone', kPhoneSize),
    ('nation_vitrine_phone_tall', const Size(390, 2000)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}'
        '&nationId=${save.nationId}',
        size: size,
      );
      expect(find.text(enL.nationsHonours), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
