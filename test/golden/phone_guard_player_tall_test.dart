import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../helpers/seeded_save.dart';

/// The whole phone player page in a tall window, pinned before the card's
/// sections are split into two runs for the tablet page.
void main() {
  testWidgets('player_phone_tall', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.playerCareerRecord), findsOneWidget);
    await expectAppGolden('goldens/player_phone_tall.png');
  });
}
