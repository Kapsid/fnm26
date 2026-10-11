import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone settings, pinned before their cards move into widgets of their
/// own and the tablet layout is added beside them. With a save, so the walk
/// through is offered; tall, so the backup card at the foot is in it.
void main() {
  for (final (name, size) in [
    ('settings_phone', kPhoneSize),
    ('settings_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(tester, save, Routes.settings, size: size);
      expect(find.text(enL.settingsSoundHapticsTitle), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
