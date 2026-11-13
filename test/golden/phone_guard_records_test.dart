import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone record book: as a fresh save shows it (nothing played yet), and
/// full (the fake book and rivalry), every card in a tall window. Since
/// 1.1.2 the full book is the redesign: headline tiles, team records, record
/// holders, the rival, the way out at the bottom.
void main() {
  testWidgets('records_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.records}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsPlayToWriteHistory(me.name)), findsOneWidget);
    await expectAppGolden('goldens/records_phone.png');
  });

  testWidgets('records_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeRecordsOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.records}?careerId=${save.careerId}',
      size: const Size(390, 1100),
    );
    expect(find.text(enL.recordsFiercestRival), findsOneWidget);
    expect(find.text(enL.recordsRecordHolders.toUpperCase()), findsOneWidget);
    await expectAppGolden('goldens/records_phone_tall.png');
  });
}
