import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone call-ups', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.callUps}?careerId=${save.careerId}',
    );
    expect(find.byType(CallUpScreen), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    await expectAppGolden('goldens/call_ups_phone.png');
  });

  // The pool scrolls, so a phone-height frame only proves the top of it. A
  // tall frame lays the whole first line out.
  testWidgets('phone call-ups, tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.callUps}?careerId=${save.careerId}',
      size: const Size(390, 2200),
    );
    expect(find.byType(CallUpScreen), findsOneWidget);
    await expectAppGolden('goldens/call_ups_phone_tall.png');
  });
}
