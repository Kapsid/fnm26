import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone finals draw: the seeding pots, the ceremony two balls in, and the
/// ceremony skipped to the end. A fresh save has no finals draw, so it is a
/// fake one.
Future<SeededSave> _open(WidgetTester tester, {Size? size}) async {
  final save = await seedSave(
    tester,
    overrides: [
      finalsDrawProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakeFinalsDraw(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.finalsDraw}?careerId=${save.careerId}',
    size: size ?? kPhoneSize,
  );
  return save;
}

void main() {
  testWidgets('finals_draw_phone_pots_tall', (tester) async {
    await _open(tester, size: const Size(390, 2400));
    expect(find.text('Start the draw'), findsOneWidget);
    await expectAppGolden('goldens/finals_draw_phone_pots_tall.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('finals_draw_phone_mid', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Start the draw'));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await expectAppGolden('goldens/finals_draw_phone_mid.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('finals_draw_phone_done', (tester) async {
    await _open(tester);
    await tester.tap(find.text('Start the draw'));
    await tester.pump();
    await tester.tap(find.text(enL.tourSharedSkip));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await expectAppGolden('goldens/finals_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });
}
