import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone legends, pinned before the tablet layout is added beside them:
/// as a fresh save shows them (none yet), and the fake hall of fame in a
/// tall window.
///
/// At 390 wide every hall-of-fame row already overflows its 44 px leading
/// slot by a few pixels (an 18 px rank beside the position chip). That is the
/// phone as it ships (every row of the fake), so the tall guard pins it as it
/// is, as the tournaments guard does: it lets RenderFlex overflows through,
/// counts them, and expects one per row, so a change that adds or removes one
/// still fails here.
void main() {
  testWidgets('legends_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    await expectAppGolden('goldens/legends_phone.png');
  });

  testWidgets('legends_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeLegendsOverride()]);
    var seen = 0;
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
        seen++;
        return;
      }
      original?.call(details);
    };
    try {
      await pumpRoute(
        tester,
        save,
        '${Routes.legends}?careerId=${save.careerId}',
        size: const Size(390, 2400),
      );
    } finally {
      FlutterError.onError = original;
    }
    expect(
      seen,
      fakeLegends().hallOfFame.length,
      reason: 'the hall of fame overflows differently',
    );
    expect(find.text(enL.recordsHallOfFame), findsOneWidget);
    await expectAppGolden('goldens/legends_phone_tall.png');
  });
}
