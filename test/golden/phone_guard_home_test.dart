import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/home/home_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone home, a bento grid: the logo and title on top, the save played
/// last, New Game, Saves, Campaigns, Editor and Settings at the foot.
void main() {
  testWidgets('home_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.home);
    expect(find.byKey(HomeScreen.heroKey), findsOneWidget);
    expect(find.byKey(HomeScreen.continueCareerKey), findsOneWidget);
    await expectAppGolden('goldens/home_phone.png');
  });

  testWidgets('home_phone_se_both', (tester) async {
    // An iPhone SE (375 x 667) with a save AND a campaign run: both continue
    // cards, nothing scrolled away, nothing overflowing.
    const se = Size(375, 667);
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container
          .read(campaignServiceProvider)
          .start(Campaigns.youngFinns, managerName: 'Me'),
    );
    // The normal save was played last, so it leads.
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .touch(save.careerId, DateTime.now().add(const Duration(hours: 1))),
    );
    save.container
      ..invalidate(campaignRunsProvider)
      ..invalidate(savesProvider);
    await pumpRoute(tester, save, Routes.home, size: se);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.heroKey), findsOneWidget);
    expect(find.byKey(HomeScreen.secondContinueKey), findsOneWidget);
    await expectAppGolden('goldens/home_phone_se_both.png');
  });

  testWidgets('home_phone_first_launch', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [savesProvider.overrideWith((ref) async => const [])],
    );
    await pumpRoute(tester, save, Routes.home);
    expect(find.byKey(HomeScreen.heroKey), findsNothing);
    expect(find.byKey(HomeScreen.brandKey), findsOneWidget);
    await expectAppGolden('goldens/home_phone_first_launch.png');
  });
}
