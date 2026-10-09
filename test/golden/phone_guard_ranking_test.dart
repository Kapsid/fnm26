import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone ranking, pinned before the tablet layout is added beside it.
void main() {
  for (final (name, size) in [
    ('ranking_phone', kPhoneSize),
    ('ranking_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.ranking}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(RankRow), findsWidgets);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
