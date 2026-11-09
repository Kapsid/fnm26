import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/home/home_screen.dart';

import '../helpers/seeded_save.dart';

/// The home screen's two ways back in: the last normal save and the campaign
/// run played most recently, on the smallest phone the app supports.
void main() {
  const small = Size(360, 640);
  final noSaves = [savesProvider.overrideWith((ref) async => const [])];

  Future<int> startCampaign(WidgetTester tester, SeededSave save) async {
    await tester.runAsync(
      () => save.container
          .read(campaignServiceProvider)
          .start(Campaigns.youngFinns, managerName: 'Me'),
    );
    late int id;
    await tester.runAsync(() async {
      final runs = await save.container.read(campaignRunsProvider.future);
      id = runs[Campaigns.youngFinns.id]!.id;
    });
    return id;
  }

  /// Stamps [id] as last played [ahead] from now, to fix the order.
  Future<void> touch(
    WidgetTester tester,
    SeededSave save,
    int id,
    Duration ahead,
  ) async {
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .touch(id, DateTime.now().add(ahead)),
    );
    // startCampaign read the run, and nothing has disposed it yet.
    save.container
      ..invalidate(campaignRunsProvider)
      ..invalidate(savesProvider);
  }

  Finder continueSave() => find.byKey(HomeScreen.continueCareerKey);
  Finder continueCampaign() => find.byKey(HomeScreen.campaignContinueKey);

  testWidgets('no saves and no run: neither card', (tester) async {
    final save = await seedSave(tester, overrides: noSaves);
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(continueSave(), findsNothing);
    expect(continueCampaign(), findsNothing);
  });

  testWidgets('a normal save only: the unchanged Continue card', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(continueSave(), findsOneWidget);
    expect(continueCampaign(), findsNothing);
  });

  testWidgets('a campaign run only: the campaign card, titled', (tester) async {
    final save = await seedSave(tester, overrides: noSaves);
    await startCampaign(tester, save);
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(continueSave(), findsNothing);
    expect(continueCampaign(), findsOneWidget);
    expect(find.textContaining(enL.homeContinueCampaign), findsOneWidget);
    // Its title, and with three cycles the progress is stated.
    expect(find.text('Young Finns · Cycle 1 of 3'), findsOneWidget);
  });

  testWidgets('the save played last leads the campaign card', (tester) async {
    final save = await seedSave(tester);
    final runId = await startCampaign(tester, save);
    await touch(tester, save, runId, const Duration(minutes: 1));
    await touch(tester, save, save.careerId, const Duration(minutes: 5));
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(continueSave()).dy,
      lessThan(tester.getTopLeft(continueCampaign()).dy),
    );
  });

  testWidgets('both, on a 360x640 phone: fits, both visible, campaign taps', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final runId = await startCampaign(tester, save);
    await touch(tester, save, runId, const Duration(minutes: 5));
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(continueSave(), findsOneWidget);
    expect(continueCampaign(), findsOneWidget);
    expect(
      tester.getTopLeft(continueCampaign()).dy,
      lessThan(tester.getTopLeft(continueSave()).dy),
      reason: 'the run was stamped last, so it leads',
    );
    // Everything is on screen with no scrolling.
    final screen = Offset.zero & small;
    for (final f in [
      continueSave(),
      continueCampaign(),
      find.byKey(HomeScreen.campaignsKey),
    ]) {
      expect(screen.contains(tester.getBottomRight(f)), isTrue);
    }

    await tester.tap(continueCampaign());
    await settle(tester, allowSpinner: true);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.hub);
    expect(uri.queryParameters['careerId'], '$runId');

    await tester.runAsync(save.container.read(playTimeTrackerProvider).stop);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  Finder inHero(Finder f) =>
      find.descendant(of: find.byKey(HomeScreen.heroKey), matching: f);
  Finder inSecond(Finder f) => find.descendant(
    of: find.byKey(HomeScreen.secondContinueKey),
    matching: f,
  );

  testWidgets('first launch: no continue card, the logo and title instead', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: noSaves);
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.heroKey), findsNothing);
    expect(find.byKey(HomeScreen.secondContinueKey), findsNothing);
    expect(find.byKey(HomeScreen.brandKey), findsOneWidget);
    expect(find.text('Football Nations Manager'), findsOneWidget);
    expect(find.text(enL.homeLeadTheNation), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomeScreen.savesKey),
        matching: find.text(enL.homeLoadGame),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a save only: the big card alone, and no second card', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(inHero(find.byKey(HomeScreen.continueCareerKey)), findsOneWidget);
    expect(find.byKey(HomeScreen.secondContinueKey), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(HomeScreen.savesKey),
        matching: find.text(enL.homeAllSaves),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the big card is the save played last: the career', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final runId = await startCampaign(tester, save);
    await touch(tester, save, runId, const Duration(minutes: 1));
    await touch(tester, save, save.careerId, const Duration(minutes: 5));
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(inHero(find.byKey(HomeScreen.continueCareerKey)), findsOneWidget);
    expect(inSecond(continueCampaign()), findsOneWidget);
    expect(inSecond(find.text(enL.homeContinueCampaign)), findsOneWidget);
    expect(inSecond(find.text('Young Finns')), findsOneWidget);
  });

  testWidgets('the big card is the save played last: the campaign', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final runId = await startCampaign(tester, save);
    await touch(tester, save, save.careerId, const Duration(minutes: 1));
    await touch(tester, save, runId, const Duration(minutes: 5));
    await pumpRoute(tester, save, Routes.home, size: small);
    expect(inHero(continueCampaign()), findsOneWidget);
    expect(inHero(find.text('Young Finns · Cycle 1 of 3')), findsOneWidget);
    expect(
      inHero(find.textContaining(enL.homeContinueCampaign)),
      findsOneWidget,
    );
    expect(
      inSecond(find.byKey(HomeScreen.continueCareerKey)),
      findsOneWidget,
    );
    expect(inSecond(find.text(enL.homeContinue)), findsOneWidget);
  });

  for (final (label, size) in [
    ('iPhone SE 375x667', const Size(375, 667)),
    ('360x640', small),
    ('320x568', const Size(320, 568)),
  ]) {
    testWidgets('both cards on a $label: no overflow, no scrolling, every '
        'target 44 px or more', (tester) async {
      final save = await seedSave(tester);
      await startCampaign(tester, save);
      await pumpRoute(tester, save, Routes.home, size: size);
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
      final screen = Offset.zero & size;
      for (final f in [
        find.byKey(HomeScreen.heroKey),
        find.byKey(HomeScreen.secondContinueKey),
        find.byKey(HomeScreen.savesKey),
        find.byKey(HomeScreen.campaignsKey),
        find.byKey(HomeScreen.editorKey),
        find.byKey(HomeScreen.settingsKey),
        find.byKey(HomeScreen.newGameKey),
      ]) {
        expect(f, findsOneWidget);
        final r = tester.getRect(f);
        expect(screen.contains(r.topLeft), isTrue, reason: '$f');
        expect(
          screen.contains(r.bottomRight - const Offset(1, 1)),
          isTrue,
          reason: '$f',
        );
      }
      for (final f in [
        find.byKey(HomeScreen.secondContinueKey),
        find.byKey(HomeScreen.savesKey),
        find.byKey(HomeScreen.campaignsKey),
        find.byKey(HomeScreen.editorKey),
        find.byKey(HomeScreen.settingsKey),
      ]) {
        final r = tester.getRect(f);
        expect(r.height, greaterThanOrEqualTo(44), reason: '$f');
        expect(r.width, greaterThanOrEqualTo(44), reason: '$f');
      }
      // The tiles keep to their floors.
      expect(
        tester.getSize(find.byKey(HomeScreen.savesKey)).height,
        greaterThanOrEqualTo(70),
      );
      expect(
        tester.getSize(find.byKey(HomeScreen.editorKey)).height,
        greaterThanOrEqualTo(48),
      );
      // Settings is a tile, named for screen readers and on long press.
      expect(find.byTooltip(enL.homeSettings), findsOneWidget);
    });
  }

  testWidgets('a tablet shows the campaign card in the bento beside the logo', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await startCampaign(tester, save);
    await pumpRoute(tester, save, Routes.home, size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
    expect(continueCampaign(), findsOneWidget);
    // The tablet shows the phone's bento, campaign card included.
    expect(find.textContaining(enL.homeContinueCampaign), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
