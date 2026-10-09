import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone draw ceremony, pinned before it gains a landscape stage: the
/// seeded save's own qualifying draw before the first ball, two balls in (by
/// hand, which pauses the autoplay) and once skipped to the end, and the
/// continental and Nations Cup draws (fake, a fresh save has none yet) once
/// skipped.
Future<void> _skip(WidgetTester tester) async {
  await tester.tap(find.text(enL.tourSharedSkip));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('qualifying_draw_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.qualifyingDraw}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourPot(1)), findsOneWidget);
    await expectAppGolden('goldens/qualifying_draw_phone.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('qualifying_draw_phone_mid', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.qualifyingDraw}?careerId=${save.careerId}',
    );
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await expectAppGolden('goldens/qualifying_draw_phone_mid.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('qualifying_draw_phone_done_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.qualifyingDraw}?careerId=${save.careerId}',
      size: const Size(390, 1800),
    );
    await _skip(tester);
    await expectAppGolden('goldens/qualifying_draw_phone_done_tall.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('continental_draw_phone_done', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        continentalDrawProvider((
          careerId: kSeededCareerId,
          confederation: Confederation.europe,
        )).overrideWith((ref) async => fakeContinentalDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continentalDraw}?careerId=${save.careerId}'
      '&conf=${Confederation.europe.name}',
    );
    await _skip(tester);
    await expectAppGolden('goldens/continental_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nations_cup_draw_phone_done', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        nationsCupDrawProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeNationsCupDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.nationsCupDraw}?careerId=${save.careerId}',
    );
    await _skip(tester);
    await expectAppGolden('goldens/nations_cup_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });
}
