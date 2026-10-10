import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone host selection on the seeded save (its first event is the
/// continental host draw): the sealed envelope, and the envelope opened.
void main() {
  testWidgets('host_draw_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hostDraw}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourCandidates), findsOneWidget);
    await expectAppGolden('goldens/host_draw_phone.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('host_draw_phone_open_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hostDraw}?careerId=${save.careerId}',
      size: const Size(390, 1400),
    );
    await tester.tap(find.text(enL.tourSharedOpenEnvelope));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    await expectAppGolden('goldens/host_draw_phone_open_tall.png');
    await tester.pumpWidget(const SizedBox());
  });
}
