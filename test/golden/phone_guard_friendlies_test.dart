import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// The phone friendlies, pinned before the tablet layout is added beside
/// them: no gap (a fresh save), and the fake gap of two windows, short and
/// whole.
void main() {
  testWidgets('friendlies_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.friendlies}?careerId=${save.careerId}',
    );
    expect(find.text(enL.friendliesContinue), findsOneWidget);
    await expectAppGolden('goldens/friendlies_none_phone.png');
  });

  for (final (name, size) in [
    ('friendlies_phone', kPhoneSize),
    ('friendlies_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [fakeFriendliesOverride()],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.friendlies}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.friendliesNoneThisWindow), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
