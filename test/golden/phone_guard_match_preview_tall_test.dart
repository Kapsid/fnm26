import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_preview_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  // The preview scrolls: a tall frame pins the XI and the ground below the
  // fold. Its own file: pumped second in one file, the preview was still
  // loading when the frame was taken.
  testWidgets('phone match preview, tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
      size: const Size(390, 2200),
    );
    expect(find.byType(MatchHeadline), findsOneWidget);
    await expectAppGolden('goldens/match_preview_phone_tall.png');
  });
}
