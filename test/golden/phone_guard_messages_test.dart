import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/messages/messages_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone inbox, pinned before the tablet layout is added beside it.
void main() {
  testWidgets('phone inbox', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.messages}?careerId=${save.careerId}',
    );
    expect(find.byType(MessagesScreen), findsOneWidget);
    await expectAppGolden('goldens/messages_phone.png');
  });
}
