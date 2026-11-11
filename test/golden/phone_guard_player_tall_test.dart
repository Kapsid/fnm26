import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';

import '../helpers/seeded_save.dart';

/// The whole phone player page in a tall window, one golden per tab: the
/// header card over Overview, Stats and Career.
void main() {
  for (final (tab, file) in [
    (PlayerDetailScreen.tabOverviewKey, 'player_phone_tall'),
    (PlayerDetailScreen.tabStatsKey, 'player_phone_tall_stats'),
    (PlayerDetailScreen.tabCareerKey, 'player_phone_tall_career'),
  ]) {
    testWidgets(file, (tester) async {
      final save = await seedSave(tester);
      late int playerId;
      await tester.runAsync(() async {
        final pool = await save.container
            .read(playerRepositoryProvider)
            .byNation(
              save.nationId,
              agingYears: CareerService.agingYears(save.career),
              saveSeed: save.career.rngSeed,
              careerId: save.career.id,
            );
        playerId = pool.first.id;
      });
      await pumpRoute(
        tester,
        save,
        '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
        size: const Size(390, 1600),
      );
      await tester.tap(find.byKey(tab));
      await settle(tester);
      expect(tester.takeException(), isNull);
      if (tab == PlayerDetailScreen.tabStatsKey) {
        expect(find.text(enL.playerCareerRecord), findsOneWidget);
      }
      await expectAppGolden('goldens/$file.png');
    });
  }
}
