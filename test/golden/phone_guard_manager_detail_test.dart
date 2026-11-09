import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_now_card.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/manager_row.dart';

import '../helpers/seeded_save.dart';

/// A world manager's page on a 390 px phone, opened off another nation's
/// page, in English and in German.
void main() {
  for (final lang in ['en', 'de']) {
    testWidgets('manager_detail_phone_$lang', (tester) async {
      final save = await seedSave(tester);
      final other = save.nations.firstWhere((n) => n.id != save.nationId).id;
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}&nationId=$other',
        size: const Size(390, 844),
        locale: Locale(lang),
      );
      expect(find.byKey(NationNowCard.managerKey), findsOneWidget);
      await tester.ensureVisible(find.byKey(ManagerRow.rowKey));
      await tester.pump();
      await tester.tap(find.byKey(ManagerRow.rowKey));
      await settle(tester);
      expect(find.byType(ManagerDetailScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/manager_detail_phone_$lang.png');
    });
  }
}
