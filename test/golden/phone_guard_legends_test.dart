import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone legends, pinned: as a fresh save shows them (none yet), and the
/// fake legends in a tall window (the all-time XI on the pitch, the whole
/// hall of fame as cards below it).
///
/// The hall of fame's old list rows each overflowed their 44 px leading slot
/// by a few pixels at 390 wide; the cards that replaced them overflow
/// nowhere, and the tall guard now says so.
void main() {
  testWidgets('legends_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    await expectAppGolden('goldens/legends_phone.png');
  });

  testWidgets('legends_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeLegendsOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.recordsHallOfFame), findsOneWidget);
    await expectAppGolden('goldens/legends_phone_tall.png');
  });
}
