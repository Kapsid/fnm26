import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone board objectives, pinned before the tablet layout is added.
void main() {
  for (final (name, size) in [
    ('board_phone', kPhoneSize),
    ('board_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.boardObjectives}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.boardObjectivesConfidence), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
