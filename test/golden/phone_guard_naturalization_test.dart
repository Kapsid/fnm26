import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone naturalisation decision, pinned before its offer card and
/// buttons are shared with the tablet: an offer, and nothing to decide.
void main() {
  for (final (name, size) in [
    ('naturalization_phone', kPhoneSize),
    ('naturalization_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await offerNaturalization(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.naturalization}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.federationNaturalise), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('naturalization_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.naturalization}?careerId=${save.careerId}',
    );
    expect(find.text(enL.federationContinue), findsOneWidget);
    await expectAppGolden('goldens/naturalization_none_phone.png');
  });
}
