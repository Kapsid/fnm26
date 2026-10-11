import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone World Championship kickoff once its entrance has played out.
void main() {
  testWidgets('kickoff_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tournamentKickoff}?careerId=${save.careerId}',
    );
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text(enL.tourSharedFinalsAreHere), findsOneWidget);
    await expectAppGolden('goldens/kickoff_phone.png');
    await tester.pumpWidget(const SizedBox());
  });
}
