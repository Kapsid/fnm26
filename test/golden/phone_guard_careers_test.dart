import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone Career menu, pinned before the tablet layout is added beside
/// it. All six lines fit a phone.
void main() {
  testWidgets('careers_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.careers}?careerId=${save.careerId}',
    );
    expect(find.text(enL.careerMyMatches), findsOneWidget);
    await expectAppGolden('goldens/careers_phone.png');
  });
}
