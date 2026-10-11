import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Clash with a played tie, pinned before its tab bodies move.
void main() {
  testWidgets('clash_phone', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        continentalClashProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeClash(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continentalClash}?careerId=${save.careerId}',
    );
    final me = realNationsById[seededNationId]!;
    expect(find.text(enL.tourContWinTheClash(me.name)), findsOneWidget);
    await expectAppGolden('goldens/clash_phone.png');
  });
}
