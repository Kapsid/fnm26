import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_preview_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match preview', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
    );
    expect(find.byType(MatchHeadline), findsOneWidget);
    await expectAppGolden('goldens/match_preview_phone.png');
  });
}
