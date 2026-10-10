import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone nation pick, pinned before the tablet layout is added beside
/// it: Europe's list (as tall as it goes), and a search across every
/// confederation.
void main() {
  for (final (name, size) in [
    ('nations_phone', kPhoneSize),
    ('nations_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(tester, save, Routes.nations, size: size);
      expect(find.text(enL.nationsSelectHeading), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('nations_search_phone', (tester) async {
    EditableText.debugDeterministicCursor = true;
    addTearDown(() => EditableText.debugDeterministicCursor = false);
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.nations);
    await tester.enterText(find.byType(TextField), 'ger');
    await settle(tester);
    await expectAppGolden('goldens/nations_search_phone.png');
  });
}
