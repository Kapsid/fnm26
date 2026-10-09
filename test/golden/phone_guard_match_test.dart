import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match at kick-off', (tester) async {
    final save = await seedSave(tester);
    // Warm the preview as the pre-match screen does, so the match opens on
    // it rather than on a spinner.
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    expect(find.byType(MatchScoreboard), findsOneWidget);
    expect(find.byType(MatchDetailTabs), findsOneWidget);
    await expectAppGolden('goldens/match_phone.png');
    await tester.pumpWidget(const SizedBox());
  });
}
