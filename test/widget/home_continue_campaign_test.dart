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

  Finder continueSave() => find.text(enL.homeContinue);
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
    expect(find.text(enL.homeContinueCampaign), findsOneWidget);
    expect(find.text('Young Finns'), findsOneWidget);
    // Three cycles: the progress is stated.
    expect(find.textContaining('Cycle 1 of 3'), findsOneWidget);
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

  testWidgets('a tablet shows the campaign card beside the title', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await startCampaign(tester, save);
    await pumpRoute(tester, save, Routes.home, size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
    expect(continueCampaign(), findsOneWidget);
    expect(continueSave(), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
