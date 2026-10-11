import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/saves_screen.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone saves list, pinned before Tasks 11 and 12 touch it: one save,
/// and two.
void main() {
  testWidgets('saves_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byType(SaveTile), findsOneWidget);
    await expectAppGolden('goldens/saves_phone.png');
  });

  testWidgets('saves_two_phone', (tester) async {
    final save = await seedSave(tester);
    final second = await addSecondSave(tester, save);
    // Pin the order. Both saves are stamped "just played" at creation, and the
    // stamp is stored to the second, so under load they can tie or swap.
    // The first save played most recently, the second a few seconds before:
    // both still read "Last 1m ago".
    await tester.runAsync(() async {
      final repo = save.container.read(careerRepositoryProvider);
      final now = DateTime.now();
      await repo.touch(save.careerId, now);
      await repo.touch(second, now.subtract(const Duration(seconds: 5)));
    });
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byType(SaveTile), findsNWidgets(2));
    await expectAppGolden('goldens/saves_two_phone.png');
  });
}
