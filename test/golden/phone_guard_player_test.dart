import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone player page, pinned before its body moves into PlayerView.
void main() {
  testWidgets('phone player page', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
    );
    expect(find.byType(PlayerDetailScreen), findsOneWidget);
    expect(find.text(name), findsOneWidget);
    await expectAppGolden('goldens/player_phone.png');
  });
}
