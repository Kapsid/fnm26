import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone play-off event, pinned before the tablet layout is added.
void main() {
  testWidgets('playoff_phone', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        intercontinentalPlayoffProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakePlayoff(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.intercontinentalPlayoff}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourContPlayoffThrough), findsOneWidget);
    await expectAppGolden('goldens/playoff_phone.png');
  });
}
