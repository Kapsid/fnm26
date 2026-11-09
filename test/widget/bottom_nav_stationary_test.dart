import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

/// Changing tab must not slide the bottom dock: the old and new pages
/// crossfade, so the dock sits at the same place on every frame.
void main() {
  testWidgets('the dock does not move while switching tabs', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: const Size(393, 852),
    );
    final before = tester.getTopLeft(find.byType(AppBottomNav).first);

    save.container
        .read(routerProvider)
        .go('${Routes.tactics}?careerId=${save.careerId}');
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 40));
      final count = find.byType(AppBottomNav).evaluate().length;
      for (var n = 0; n < count; n++) {
        expect(tester.getTopLeft(find.byType(AppBottomNav).at(n)), before);
      }
    }
    await settle(tester);
    expect(tester.getTopLeft(find.byType(AppBottomNav).first), before);
  });
}
