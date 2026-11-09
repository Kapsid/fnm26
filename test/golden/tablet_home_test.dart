import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/home/home_screen.dart';

import '../helpers/seeded_save.dart';

/// An 11in iPad held upright.
const Size _portrait = Size(834, 1194);

/// The tablet home, layout START A: the logo block left and the phone's bento
/// grid right in landscape; the logo over the grid in portrait.
void main() {
  Future<SeededSave> withCampaign(WidgetTester tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
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
    return save;
  }

  testWidgets('home_tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, Routes.home, size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byKey(HomeScreen.heroKey), findsOneWidget);
    await expectAppGolden('goldens/home_tablet.png');
  });

  testWidgets('home_tablet_both_small', (tester) async {
    // The 9.7in iPad, the least room, with a save AND a campaign run.
    final save = await withCampaign(tester);
    await pumpRoute(tester, save, Routes.home, size: kTabletSizes.last);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.heroKey), findsOneWidget);
    expect(find.byKey(HomeScreen.secondContinueKey), findsOneWidget);
    await expectAppGolden('goldens/home_tablet_both_small.png');
  });

  testWidgets('home_tablet_first_launch', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [savesProvider.overrideWith((ref) async => const [])],
    );
    await pumpRoute(tester, save, Routes.home, size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.heroKey), findsNothing);
    expect(find.byKey(HomeScreen.brandKey), findsOneWidget);
    await expectAppGolden('goldens/home_tablet_first_launch.png');
  });

  testWidgets('home_tablet_portrait', (tester) async {
    final save = await withCampaign(tester);
    await pumpRoute(tester, save, Routes.home, size: _portrait);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
    // The logo stacks over the grid.
    final brand = tester.getRect(find.byKey(HomeScreen.brandKey));
    final hero = tester.getRect(find.byKey(HomeScreen.heroKey));
    expect(hero.top, greaterThan(brand.bottom));
    await expectAppGolden('goldens/home_tablet_portrait.png');
  });

  testWidgets('home_tablet_portrait_first_launch', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [savesProvider.overrideWith((ref) async => const [])],
    );
    await pumpRoute(tester, save, Routes.home, size: _portrait);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.heroKey), findsNothing);
    await expectAppGolden('goldens/home_tablet_portrait_first_launch.png');
  });
}
