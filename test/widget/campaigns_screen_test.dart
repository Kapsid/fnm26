import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

/// The campaigns list: a card per scenario, the stamp the manager has earned,
/// the actions a run allows, and the way into one from the brief. A free
/// manager throughout: campaigns never ask him to pay.
void main() {
  final free = [premiumUnlockedProvider.overrideWith((ref) => false)];

  testWidgets('the list shows a card per campaign and no stamp yet', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    expect(find.text('The Transplant'), findsOneWidget);
    expect(find.text('Grudge'), findsOneWidget);
    expect(find.text('Free'), findsNWidgets(2));
    expect(find.byKey(CampaignCard.startKey), findsAtLeastNWidgets(2));
    // The third card, Best of Guineas, below the fold.
    await tester.scrollUntilVisible(find.text('Best of Guineas'), 300);
    expect(find.text('Best of Guineas'), findsOneWidget);
    expect(find.byKey(CampaignStamp.stampKey), findsNothing);
  });

  testWidgets('a best of 2 stamps Conquered with two stars, 0 stamps Failed', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(() async {
      final store = save.container.read(campaignRecordStoreProvider);
      await store.record('transplant', 2);
      await store.record('grudge', 0);
    });
    await pumpRoute(tester, save, Routes.campaigns);
    expect(find.text('Conquered'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(CampaignStamp.stampKey).first,
        matching: find.byIcon(Icons.star_rounded),
      ),
      findsNWidgets(2),
    );
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('an unsettled run offers Resume and Abandon, not Start', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await tester.runAsync(
      () => save.container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me'),
    );
    await pumpRoute(tester, save, Routes.campaigns);
    expect(find.byKey(CampaignCard.resumeKey), findsOneWidget);
    expect(find.byKey(CampaignCard.abandonKey), findsOneWidget);
    // The Grudge, which has a run, offers Start no more; the Transplant,
    // which has none, still does.
    Finder startOn(String title) => find.descendant(
      of: find.ancestor(
        of: find.text(title),
        matching: find.byType(CampaignCard),
      ),
      matching: find.byKey(CampaignCard.startKey),
    );
    expect(startOn('Grudge'), findsNothing);
    expect(startOn('The Transplant'), findsOneWidget);
    // A free campaign keeps its plain Start.
    expect(
      find.descendant(
        of: startOn('The Transplant'),
        matching: find.text('Start'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(CampaignCard.moveKey), findsNothing);
  });

  testWidgets('Start opens the brief, whose Start lands on the campaign hub', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    await tester.tap(find.byKey(CampaignCard.startKey).first);
    await settle(tester);
    expect(find.byType(CampaignBriefScreen), findsOneWidget);
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

  testWidgets('the brief of a started campaign offers Resume and Abandon', (
    tester,
  ) async {
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

  /// The Best of Guineas card, scrolled into view.
  Future<Finder> guineasCard(WidgetTester tester) async {
    final card = find.ancestor(
      of: find.text('Best of Guineas'),
      matching: find.byType(CampaignCard),
    );
    await tester.scrollUntilVisible(find.text('Best of Guineas'), 300);
    await tester.pumpAndSettle();
    return card;
  }

  testWidgets('a free manager: Pro on Best of Guineas, and Start opens the '
      'paywall, never a run', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    final card = await guineasCard(tester);
    expect(
      find.descendant(of: card, matching: find.byKey(CampaignCard.proBadgeKey)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Free')),
      findsNothing,
    );
    // A lock, not the word "Pro", which stays as its semantics label.
    expect(
      find.descendant(
        // Scoped to this card: Young Finns wears a badge too.
        of: find.descendant(
          of: card,
          matching: find.byKey(CampaignCard.proBadgeKey),
        ),
        matching: find.byIcon(Icons.lock),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        // Scoped to this card: Young Finns wears a badge too.
        of: find.descendant(
          of: card,
          matching: find.byKey(CampaignCard.proBadgeKey),
        ),
        matching: find.text('Pro'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        // Scoped to this card: Young Finns wears a badge too.
        of: find.descendant(
          of: card,
          matching: find.byKey(CampaignCard.proBadgeKey),
        ),
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Pro',
        ),
      ),
      findsOneWidget,
    );
    final start = find.descendant(
      of: card,
      matching: find.byKey(CampaignCard.startKey),
    );
    await tester.ensureVisible(start);
    await tester.pumpAndSettle();
    await tester.tap(start);
    await settle(tester);
    expect(find.byType(PaywallSheet), findsOneWidget);
    expect(find.byType(CampaignBriefScreen), findsNothing);
    final runs = await tester.runAsync(
      () => save.container.read(campaignRunsProvider.future),
    );
    expect(runs, isEmpty);
  });

  testWidgets('a free manager: Young Finns wears the lock too, and Start '
      'opens the paywall', (tester) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, Routes.campaigns);
    await tester.scrollUntilVisible(find.text('Young Finns'), 300);
    await tester.pumpAndSettle();
    final card = find.ancestor(
      of: find.text('Young Finns'),
      matching: find.byType(CampaignCard),
    );
    final badge = find.descendant(
      of: card,
      matching: find.byKey(CampaignCard.proBadgeKey),
    );
    expect(badge, findsOneWidget);
    expect(
      find.descendant(of: badge, matching: find.byIcon(Icons.lock)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Free')),
      findsNothing,
    );
    final start = find.descendant(
      of: card,
      matching: find.byKey(CampaignCard.startKey),
    );
    // Locked: the button says what it takes, with a lock, not "Start".
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
  });

  testWidgets("a free manager: the brief's Start opens the paywall too", (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: free);
    await pumpRoute(tester, save, '${Routes.campaignBrief}?id=guineas');
    final start = find.byKey(CampaignBriefScreen.startKey);
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

  testWidgets('a Pro manager starts Best of Guineas from its card', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [premiumUnlockedProvider.overrideWith((ref) => true)],
    );
    await pumpRoute(tester, save, Routes.campaigns);
    final card = await guineasCard(tester);
    expect(
      find.descendant(of: card, matching: find.byKey(CampaignCard.proBadgeKey)),
      findsOneWidget,
    );
    final start = find.descendant(
      of: card,
      matching: find.byKey(CampaignCard.startKey),
    );
    await tester.ensureVisible(start);
    await tester.pumpAndSettle();
    await tester.tap(start);
    await settle(tester);
    expect(find.byType(PaywallSheet), findsNothing);
    expect(find.byType(CampaignBriefScreen), findsOneWidget);
    final briefStart = find.byKey(CampaignBriefScreen.startKey);
    await tester.ensureVisible(briefStart);
    await tester.pumpAndSettle();
    await tester.tap(briefStart);
    await settle(tester, allowSpinner: true);
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
    expect(tag?.def.id, 'guineas');

    // Unmount, so the hub's timers do not outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
