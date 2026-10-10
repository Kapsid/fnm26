import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone home screen, pinned before the tablet layout is added beside
/// it: the logo, the title, the Continue card for the save, New game.
void main() {
  testWidgets('home_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.home);
    expect(find.text(enL.homeContinue), findsOneWidget);
    await expectAppGolden('goldens/home_phone.png');
  });
}
