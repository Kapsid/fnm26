import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

/// The phone hub, pinned before the tablet layout is added beside it. Must
/// pass unchanged for the rest of the tablet work.
void main() {
  testWidgets('phone hub', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byType(HubHeader), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);
    await expectAppGolden('goldens/hub_phone.png');
  });
}
