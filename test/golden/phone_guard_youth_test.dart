import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../helpers/seeded_save.dart';

/// The phone youth screen, pinned before the tablet layout is added: the
/// (empty) watchlist it opens on, and the oldest level in full.
void main() {
  testWidgets('youth_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.youth}?careerId=${save.careerId}',
    );
    expect(find.text(enL.youthWatchEmpty), findsOneWidget);
    await expectAppGolden('goldens/youth_phone.png');
  });

  testWidgets('youth_u21_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.youth}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await showTab(tester, YouthLevel.values.length);
    expect(find.text(YouthLevel.u21.label), findsWidgets);
    await expectAppGolden('goldens/youth_u21_phone_tall.png');
  });
}
