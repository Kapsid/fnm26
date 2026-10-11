import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone head to head, pinned before the tablet layout is added beside
/// it: a fresh save's empty ledger, the fake ledger, a pairing picked from
/// it (the record with its link to every meeting), and the meetings page.
void main() {
  testWidgets('h2h_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
    );
    expect(find.text(enL.recordsPlayToBuildRecord), findsOneWidget);
    await expectAppGolden('goldens/h2h_phone.png');
  });

  testWidgets('h2h_ledger_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(fakeLedger().first.opponentName), findsOneWidget);
    await expectAppGolden('goldens/h2h_ledger_phone_tall.png');
  });

  testWidgets('h2h_pair_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await tester.tap(find.text(fakeLedger().first.opponentName));
    await settle(tester);
    expect(find.text(enL.recordsSeeAllMeetings), findsOneWidget);
    await expectAppGolden('goldens/h2h_pair_phone_tall.png');
  });

  testWidgets('h2h_meetings_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.h2hMeetings}?careerId=${save.careerId}'
      '&a=${save.nationId}&b=${rivalNation.id}',
      size: const Size(390, 2400),
    );
    expect(find.text('2–0'), findsOneWidget);
    await expectAppGolden('goldens/h2h_meetings_phone_tall.png');
  });
}
