import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone all-time world records, pinned before the tablet layout is
/// added beside it: the fake boards, all four, in a tall window.
void main() {
  testWidgets('all_time_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeAllTimeOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.allTimeRecords}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.recordsMostTournaments), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await expectAppGolden('goldens/all_time_phone_tall.png');
  });
}
