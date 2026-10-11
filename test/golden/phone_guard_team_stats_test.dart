import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// The phone team records, pinned before their provider moves out of the
/// screen (Task 2) and before the tablet layout is added beside them (Task
/// 12): a fresh save, nothing scored yet; and the fake records, whole.
void main() {
  testWidgets('team_stats_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.teamStats}?careerId=${save.careerId}',
    );
    expect(find.text(enL.statsNoGoalsRecorded), findsOneWidget);
    await expectAppGolden('goldens/team_stats_phone.png');
  });

  testWidgets('team_stats_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeTeamStatsOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.teamStats}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(fakeTeamStats().names.values.first), findsWidgets);
    await expectAppGolden('goldens/team_stats_phone_tall.png');
  });
}
