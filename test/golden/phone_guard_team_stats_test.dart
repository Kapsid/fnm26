import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone team records, pinned before their provider moves out of the
/// screen (Task 2) and before the tablet layout is added beside them (Task
/// 12): a fresh save, nothing scored yet.
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
}
