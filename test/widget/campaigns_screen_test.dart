import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_brief_screen.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaign_stamp.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';

import '../helpers/seeded_save.dart';

/// The campaigns list: compact tiles in sections by length, a filter by
/// completion, the stars the manager has earned, and the way into a run
/// through each campaign's brief. A free manager unless a test says
/// otherwise: campaigns never ask him to pay for a free one.
void main() {
  final free = [premiumUnlockedProvider.overrideWith((ref) => false)];

  Finder tile(String id) => find.byKey(CampaignTile.keyFor(id));

  /// Taps [id]'s tile, scrolled into view, and settles on the brief.
  Future<void> openBrief(WidgetTester tester, String id) async {
    await tester.scrollUntilVisible(tile(id), 200);
    await tester.pumpAndSettle();
    await tester.tap(tile(id));
    await settle(tester);
    expect(find.byType(CampaignBriefScreen), findsOneWidget);
  }

  testWidgets('the list: a tile per campaign in sections by length, no stars '
      'yet', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    expect(
      find.byKey(CampaignsScreen.sectionKey(CampaignLength.oneCycle)),
      findsOneWidget,
    );
    expect(find.text('ONE CYCLE · 3'), findsOneWidget);
    expect(find.text('The Transplant'), findsOneWidget);
    expect(find.text('Grudge'), findsOneWidget);
    expect(find.text('Finish the Legacy'), findsOneWidget);
    expect(find.text('1 cycle'), findsNWidgets(3));
    await tester.scrollUntilVisible(find.text('Young Finns'), 200);
    expect(find.text('A FEW CYCLES · 2'), findsOneWidget);
    expect(find.text('Best of Guineas'), findsOneWidget);
    expect(find.text('3 cycles'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('A Greenland Century'), 200);
    expect(find.text('THE LONG HAUL · 1'), findsOneWidget);
    expect(find.text('25 cycles'), findsOneWidget);
    expect(find.byKey(CampaignTile.starsKey), findsNothing);
    expect(find.byKey(CampaignTile.inProgressKey), findsNothing);
  });

  testWidgets('a best of 2 shows two of three stars, 0 a cross; the brief '
      'carries the stamp', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(() async {
      final store = save.container.read(campaignRecordStoreProvider);
      await store.record('transplant', 2);
      await store.record('grudge', 0);
    });
    await pumpRoute(tester, save, Routes.campaigns);
    final transplantStars = find.descendant(
      of: tile('transplant'),
      matching: find.byKey(CampaignTile.starsKey),
    );
    expect(
      find.descendant(
        of: transplantStars,
        matching: find.byIcon(Icons.star_rounded),
      ),
      findsNWidgets(2),
    );
    expect(
      find.descendant(
        of: transplantStars,
        matching: find.byIcon(Icons.star_border_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: tile('grudge'),
        matching: find.byIcon(Icons.close_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Conquered, 2 stars',
      ),
      findsOneWidget,
    );

    await openBrief(tester, 'transplant');
    expect(find.byKey(CampaignStamp.stampKey), findsOneWidget);
    expect(find.text('Conquered'), findsOneWidget);
  });

  testWidgets('a run in progress: the tile says so, and the filters sort the '
      'campaigns by completion', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(() async {
      await save.container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me');
      await save.container
          .read(campaignRecordStoreProvider)
          .record('transplant', 1);
    });
    await pumpRoute(tester, save, Routes.campaigns);
    expect(
      find.descendant(
        of: tile('grudge'),
        matching: find.byKey(CampaignTile.inProgressKey),
      ),
      findsOneWidget,
    );

    Future<void> filter(CampaignFilter f) async {
      await tester.tap(find.byKey(CampaignsScreen.filterKey(f)));
      await tester.pumpAndSettle();
    }

    await filter(CampaignFilter.inProgress);
    expect(tile('grudge'), findsOneWidget);
    expect(tile('transplant'), findsNothing);
    expect(tile('legacy'), findsNothing);

    await filter(CampaignFilter.completed);
    expect(tile('transplant'), findsOneWidget);
    expect(tile('grudge'), findsNothing);

    await filter(CampaignFilter.notPlayed);
    expect(tile('transplant'), findsNothing);
    expect(tile('grudge'), findsNothing);
    expect(tile('legacy'), findsOneWidget);

    await filter(CampaignFilter.all);
    expect(tile('transplant'), findsOneWidget);
    expect(tile('grudge'), findsOneWidget);
  });

  testWidgets('a filter nothing passes says so', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    await tester.tap(
      find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(CampaignsScreen.emptyKey), findsOneWidget);
    expect(find.byType(CampaignTile), findsNothing);
  });

  testWidgets('a tile opens the brief, whose Start lands on the campaign hub', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    await openBrief(tester, 'transplant');
    // The manager's name defaults to the last save's.
    expect(find.widgetWithText(TextField, 'M'), findsOneWidget);

    await tester.tap(find.byKey(CampaignBriefScreen.startKey));
    await settle(tester, allowSpinner: true);
    final router = save.container.read(routerProvider);
    final uri = router.routeInformationProvider.value.uri;
    expect(uri.path, Routes.hub);
    final id = int.parse(uri.queryParameters['careerId']!);
    expect(id, isNot(save.careerId));
    final tag = await tester.runAsync(
      () => save.container.read(campaignOfProvider(id).future),
    );
    expect(tag?.def.id, 'transplant');
    expect(tag?.moved, isFalse);

    // Unmount, so the hub's timers do not outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('the brief of a started campaign offers Resume and Abandon; '
      'Abandon brings Start back', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(
      () => save.container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me'),
    );
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=grudge');
    expect(find.byKey(CampaignBriefScreen.startKey), findsNothing);
    expect(find.byKey(CampaignBriefScreen.resumeKey), findsOneWidget);
    expect(find.byKey(CampaignBriefScreen.abandonKey), findsOneWidget);
    // Not settled: nothing to move yet.
    expect(find.byKey(CampaignBriefScreen.moveKey), findsNothing);

    await tester.ensureVisible(find.byKey(CampaignBriefScreen.abandonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CampaignBriefScreen.abandonKey));
    await tester.pumpAndSettle();
    // The confirmation dialog's own Abandon.
    await tester.tap(find.text('Abandon').last);
    await settle(tester);
    expect(find.byKey(CampaignBriefScreen.startKey), findsOneWidget);
    final runs = await tester.runAsync(
      () => save.container.read(campaignRunsProvider.future),
    );
    expect(runs, isEmpty);
  });

  testWidgets('home offers Campaigns, and Continue resumes the real save', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(
      () => save.container
          .read(campaignServiceProvider)
          .start(Campaigns.transplant, managerName: 'Me'),
    );
    await pumpRoute(tester, save, Routes.home);
    expect(find.byKey(HomeScreen.campaignsKey), findsOneWidget);
    expect(find.text('Campaigns'), findsOneWidget);

    await tester.tap(find.text(enL.homeContinue));
    await settle(tester, allowSpinner: true);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.hub);
    expect(uri.queryParameters['careerId'], '${save.careerId}');

    // Resuming a save starts the play-time clock: stop it before teardown.
    await tester.runAsync(save.container.read(playTimeTrackerProvider).stop);

    // Unmount, so the hub's timers do not outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets("a free manager: the lock on Pro tiles, and the brief's Start "
      'says Part of Unlimited and opens the paywall, never a run', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    for (final id in ['legacy', 'guineas', 'youngFinns', 'greenland']) {
      await tester.scrollUntilVisible(tile(id), 200);
      final badge = find.descendant(
        of: tile(id),
        matching: find.byKey(CampaignTile.proBadgeKey),
      );
      expect(badge, findsOneWidget, reason: id);
      // A lock, not the word "Pro", which stays as its semantics label.
      expect(
        find.descendant(of: badge, matching: find.byIcon(Icons.lock)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: badge, matching: find.text('Pro')),
        findsNothing,
      );
      expect(
        find.descendant(of: tile(id), matching: find.text('Free')),
        findsNothing,
      );
    }
    await tester.scrollUntilVisible(tile('transplant'), -200);
    expect(
      find.descendant(of: tile('transplant'), matching: find.text('Free')),
      findsOneWidget,
    );

    await openBrief(tester, 'guineas');
    final start = find.byKey(CampaignBriefScreen.startKey);
    expect(
      find.descendant(of: start, matching: find.text('Part of Unlimited')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: start, matching: find.byIcon(Icons.lock)),
      findsOneWidget,
    );
    await tester.ensureVisible(start);
    await tester.pumpAndSettle();
    await tester.tap(start);
    await settle(tester);
    expect(find.byType(PaywallSheet), findsOneWidget);
    final runs = await tester.runAsync(
      () => save.container.read(campaignRunsProvider.future),
    );
    expect(runs, isEmpty);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.campaignBrief);
  });

  testWidgets('a Pro manager starts Finish the Legacy from its brief', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [premiumUnlockedProvider.overrideWith((ref) => true)],
    );
    await pumpRoute(tester, save, Routes.campaigns);
    await openBrief(tester, 'legacy');
    expect(find.text('Finish the Legacy'), findsOneWidget);
    expect(find.text('Win the European Championship'), findsOneWidget);
    expect(find.text('And the World Championship'), findsOneWidget);
    expect(find.text('And the Nations Cup'), findsOneWidget);
    final briefStart = find.byKey(CampaignBriefScreen.startKey);
    expect(
      find.descendant(of: briefStart, matching: find.text('Start')),
      findsOneWidget,
    );
    await tester.ensureVisible(briefStart);
    await tester.pumpAndSettle();
    await tester.tap(briefStart);
    await settle(tester, allowSpinner: true);
    expect(find.byType(PaywallSheet), findsNothing);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.hub);
    final id = int.parse(uri.queryParameters['careerId']!);
    final tag = await tester.runAsync(
      () => save.container.read(campaignOfProvider(id).future),
    );
    expect(tag?.def.id, 'legacy');
    expect(tag?.def.nationId, 50);

    // Unmount, so the hub's timers do not outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('the filter and the scroll position survive a visit to a '
      'brief', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(
      () => save.container
          .read(campaignRecordStoreProvider)
          .record('greenland', 1),
    );
    await pumpRoute(tester, save, Routes.campaigns, size: const Size(360, 640));
    // Scrolled down to the last campaign, then into its brief and back.
    await openBrief(tester, 'greenland');
    await tester.tap(find.byIcon(Icons.arrow_back));
    await settle(tester);
    expect(find.byType(CampaignsScreen), findsOneWidget);
    expect(tile('greenland').hitTestable(), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
      -300,
    );
    await tester.tap(
      find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CampaignTile), findsOneWidget);
    await openBrief(tester, 'greenland');
    await tester.tap(find.byIcon(Icons.arrow_back));
    await settle(tester);
    final chip = tester.widget<ChoiceChip>(
      find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
    );
    expect(chip.selected, isTrue);
    expect(find.byType(CampaignTile), findsOneWidget);
  });

  for (final locale in ['de', 'fi', 'hu', 'el', 'pt']) {
    testWidgets('the real campaigns, one in progress, fit a 360 phone at 1.4 '
        'in $locale', (tester) async {
      final save = await seedSave(tester, overrides: free);
      await tester.runAsync(() async {
        await save.container
            .read(campaignServiceProvider)
            .start(Campaigns.grudge, managerName: 'Me');
        await save.container
            .read(campaignRecordStoreProvider)
            .record('legacy', 2);
      });
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpRoute(
        tester,
        save,
        Routes.campaigns,
        size: const Size(360, 780),
        locale: Locale(locale),
      );
      for (final def in Campaigns.all) {
        await tester.scrollUntilVisible(tile(def.id), 200);
        await tester.pumpAndSettle();
        // The title is shown whole, not cut off with an ellipsis.
        final title = find.descendant(
          of: tile(def.id),
          matching: find.byWidgetPredicate(
            (w) => w is Text && w.maxLines == 3,
          ),
        );
        expect(
          tester.renderObject<RenderParagraph>(title).didExceedMaxLines,
          isFalse,
          reason: def.id,
        );
      }
      expect(
        find.descendant(
          of: tile('grudge'),
          matching: find.byKey(CampaignTile.inProgressKey),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  group('a catalogue of 24 campaigns', () {
    // Stand-ins: the words fall back to the Transplant's, which is fine for
    // layout and filtering; the lengths cover every section.
    const lengths = [1, 2, 3, 4, 5, 25];
    final catalogue = [
      for (var i = 0; i < 24; i++)
        CampaignDef(
          id: 'c$i',
          nationId: 50,
          rngSeed: i,
          goal: CampaignGoal.titleTreble,
          cycles: lengths[i % lengths.length],
          needsPro: i.isOdd,
          difficulty: i.isEven
              ? CampaignDifficulty.medium
              : CampaignDifficulty.hard,
        ),
    ];
    final overrides = [
      ...free,
      campaignCatalogProvider.overrideWithValue(catalogue),
    ];

    testWidgets('sections split them by length, and a filter narrows them', (
      tester,
    ) async {
      final save = await seedSave(tester, overrides: overrides);
      await tester.runAsync(() async {
        final store = save.container.read(campaignRecordStoreProvider);
        await store.record('c0', 3);
        await store.record('c6', 0);
      });
      await pumpRoute(tester, save, Routes.campaigns);
      // 1 cycle: c0, c6, c12, c18. 2 to 4: three in every six. 5 and more:
      // two in every six.
      expect(find.text('ONE CYCLE · 4'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(CampaignsScreen.sectionKey(CampaignLength.short)),
        300,
      );
      expect(find.text('A FEW CYCLES · 12'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(CampaignsScreen.sectionKey(CampaignLength.long)),
        300,
      );
      expect(find.text('THE LONG HAUL · 8'), findsOneWidget);
      await tester.scrollUntilVisible(tile('c23'), 300);
      expect(tile('c23'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
        -600,
      );
      await tester.tap(
        find.byKey(CampaignsScreen.filterKey(CampaignFilter.completed)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CampaignTile), findsNWidgets(2));
      expect(find.text('ONE CYCLE · 2'), findsOneWidget);
      expect(
        find.byKey(CampaignsScreen.sectionKey(CampaignLength.short)),
        findsNothing,
      );
    });

    for (final locale in ['de', 'fi', 'hu', 'el', 'pt']) {
      testWidgets('fits a 360 phone at text scale 1.4 in $locale', (
        tester,
      ) async {
        final save = await seedSave(tester, overrides: overrides);
        await tester.runAsync(
          () =>
              save.container.read(campaignRecordStoreProvider).record('c0', 2),
        );
        tester.platformDispatcher.textScaleFactorTestValue = 1.4;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await pumpRoute(
          tester,
          save,
          Routes.campaigns,
          size: const Size(360, 780),
          locale: Locale(locale),
        );
        // Every tile built once on the way down: an overflow anywhere fails.
        await tester.scrollUntilVisible(tile('c23'), 300);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('a tablet lays the tiles out in columns', (tester) async {
      final save = await seedSave(
        tester,
        overrides: overrides,
        formFactor: FormFactor.tablet,
      );
      await pumpRoute(tester, save, Routes.campaigns, size: kTabletSize);
      expect(find.byKey(CampaignsScreen.tabletLayoutKey), findsOneWidget);
      final a = tester.getTopLeft(tile('c0'));
      final b = tester.getTopLeft(tile('c6'));
      // Side by side, on one row.
      expect(a.dy, b.dy);
      expect(b.dx, greaterThan(a.dx));
      expect(tester.takeException(), isNull);
    });
  });

  for (final locale in ['de', 'fi', 'hu', 'el', 'pt']) {
    testWidgets('the Finish the Legacy brief fits a 360 phone at 1.4 in '
        '$locale', (tester) async {
      final save = await seedSave(tester, overrides: free);
      await tester.runAsync(
        () => save.container
            .read(campaignRecordStoreProvider)
            .record('legacy', 3),
      );
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpRoute(
        tester,
        save,
        '${Routes.campaignBrief}?id=legacy',
        size: const Size(360, 780),
        locale: Locale(locale),
      );
      expect(find.byKey(CampaignStamp.stampKey), findsOneWidget);
      await tester.ensureVisible(find.byKey(CampaignBriefScreen.startKey));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
