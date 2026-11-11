import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';

import '../helpers/seeded_save.dart';

/// The player page and a world manager's page on the 11 inch iPad: the
/// silver header and Overview on the left, the rest on the right.
void main() {
  testWidgets('player_tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
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
      size: kTabletSize,
    );
    expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectAppGolden('goldens/player_tablet.png');
    await tester.tap(find.byKey(PlayerDetailScreen.tabCareerKey));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await expectAppGolden('goldens/player_tablet_career.png');
  });

  testWidgets('manager_detail_tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final managerId = await tester.runAsync(() async {
      await save.container
          .read(worldManagerServiceProvider)
          .ensureSeeded(save.careerId);
      final w = await save.container
          .read(worldManagerRepositoryProvider)
          .load(save.careerId);
      return w.spells.firstWhere((s) => s.current).managerId;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.worldManager}?careerId=${save.careerId}&managerId=$managerId',
      size: kTabletSize,
    );
    expect(find.byKey(ManagerDetailScreen.tabletLayoutKey), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectAppGolden('goldens/manager_detail_tablet.png');
  });
}
