import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
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
    await addSecondSave(tester, save);
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byType(SaveTile), findsNWidgets(2));
    await expectAppGolden('goldens/saves_two_phone.png');
  });
}
