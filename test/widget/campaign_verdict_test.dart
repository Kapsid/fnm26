import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_hub_card.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaign_stamp.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/campaign/campaign_verdict_screen.dart';

import '../helpers/seeded_save.dart';

/// The verdict of a settled campaign and the hub card of a campaign career.
/// The seeded career is made a campaign one by overriding its tag and its
/// progress (the grading itself is tested in campaign_progress_test).
void main() {
  List<Override> grudge({
    required bool settled,
    required int stars,
    CampaignDef def = Campaigns.grudge,
  }) => [
    campaignOfProvider(
      kSeededCareerId,
    ).overrideWith((ref) async => (def: def, moved: false)),
    // Test-only: Continue invalidates the next event, which nothing on this
    // page watches; an invalidated FutureProvider left unbuilt completes its
    // future twice on container dispose (riverpod 2.6.1, see
    // manager_rename_phone_test). A value with no awaits is never left so.
    nextEventProvider(kSeededCareerId).overrideWith(
      (ref) async => const HubEvent(
        kind: HubEventKind.match,
        label: 'Next',
        icon: Icons.sports_soccer,
      ),
    ),
    campaignProgressProvider(kSeededCareerId).overrideWith(
      (ref) async => (
        def: def,
        settled: settled,
        stars: stars,
        reached: stars,
        myPosition: 2,
        rivalPosition: 4,
        goalDifferenceGap: 3,
        ordinal: 0,
        rivalWins: 1,
        rivalMatchesPlayed: 2,
        rivalsBeaten: const <int>{},
        cycleRuns: const [(ordinal: 0, over: false)],
        worldRuns: const <({int ordinal, bool over})>[],
        nationsCupRun: null,
      ),
    ),
  ];

  testWidgets('a settled Transplant says why the run ends here; a Grudge '
      'does not', (tester) async {
    final save = await seedSave(
      tester,
      overrides: grudge(
        settled: true,
        stars: 1,
        def: Campaigns.transplant,
      ),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.campaignVerdict}?careerId=${save.careerId}',
    );
    expect(find.byKey(CampaignVerdictScreen.cannotContinueKey), findsOneWidget);
    expect(find.textContaining('too far from the real one'), findsOneWidget);
  });

  testWidgets('a settled Grudge has no such note', (tester) async {
    final save = await seedSave(
      tester,
      overrides: grudge(settled: true, stars: 1),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.campaignVerdict}?careerId=${save.careerId}',
    );
    expect(find.byKey(CampaignVerdictScreen.cannotContinueKey), findsNothing);
  });

  testWidgets(
    'a settled 2-star Grudge: Conquered, two stars, Continue records',
    (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        overrides: grudge(settled: true, stars: 2),
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.campaignVerdict}?careerId=${save.careerId}',
      );
      expect(find.text('Conquered'), findsWidgets);
      expect(find.byKey(CampaignVerdictScreen.headlineKey), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(CampaignStamp.stampKey),
          matching: find.byIcon(Icons.star_rounded),
        ),
        findsNWidgets(2),
      );
      expect(find.text('The run in numbers'.toUpperCase()), findsOneWidget);
      expect(find.text('Meetings won: 1 of 2'), findsOneWidget);

      await tester.tap(find.byKey(CampaignVerdictScreen.continueKey));
      await settle(tester);
      final marked = await tester.runAsync(
        () => save.container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(save.careerId, 0, campaignVerdictKind),
      );
      expect(marked, isTrue);
      final best = await tester.runAsync(
        () => save.container.read(campaignRecordStoreProvider).best('grudge'),
      );
      expect(best, 2);
      final uri = save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri;
      expect(uri.path, Routes.hub);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );

  testWidgets('a failed campaign: Not this time, and a record of 0', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: grudge(settled: true, stars: 0),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.campaignVerdict}?careerId=${save.careerId}',
    );
    expect(find.text('Not this time'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(CampaignStamp.stampKey),
        matching: find.byIcon(Icons.star_rounded),
      ),
      findsNothing,
    );
    await tester.tap(find.byKey(CampaignVerdictScreen.continueKey));
    await settle(tester);
    final best = await tester.runAsync(
      () => save.container.read(campaignRecordStoreProvider).best('grudge'),
    );
    expect(best, 0);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('the verdict lays out on a tablet', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: grudge(settled: true, stars: 3),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.campaignVerdict}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.byKey(CampaignVerdictScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byKey(CampaignStamp.stampKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the hub of a campaign career shows the card with the rival', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: grudge(settled: false, stars: 0),
    );
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byKey(CampaignHubCard.cardKey), findsOneWidget);
    await tester.tap(find.byKey(CampaignHubCard.headerKey));
    await tester.pumpAndSettle();
    expect(find.text('Qualifying: 2nd'), findsOneWidget);
    expect(find.text('Albania: 4th'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('Best of Guineas: each rival ticked once beaten, the African '
      'Championship cycle by cycle', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        campaignOfProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => (def: Campaigns.guineas, moved: false)),
        campaignProgressProvider(kSeededCareerId).overrideWith(
          (ref) async => (
            def: Campaigns.guineas,
            settled: false,
            stars: 0,
            reached: 0,
            myPosition: null,
            rivalPosition: null,
            goalDifferenceGap: null,
            ordinal: 2,
            rivalWins: 1,
            rivalMatchesPlayed: 3,
            rivalsBeaten: const {123},
            cycleRuns: const [
              (ordinal: 2, over: true),
              (ordinal: 0, over: false),
            ],
            worldRuns: const <({int ordinal, bool over})>[],
            nationsCupRun: null,
          ),
        ),
      ],
    );
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byKey(CampaignHubCard.cardKey), findsOneWidget);
    await tester.tap(find.byKey(CampaignHubCard.headerKey));
    await tester.pumpAndSettle();
    Finder icon(int id, IconData data) => find.descendant(
      of: find.byKey(CampaignHubCard.rivalToBeatKey(id)),
      matching: find.byIcon(data),
    );
    expect(icon(123, Icons.check_circle_rounded), findsOneWidget);
    expect(icon(124, Icons.radio_button_unchecked_rounded), findsOneWidget);
    expect(find.text('Guinea'), findsOneWidget);
    expect(find.text('Guinea-Bissau'), findsOneWidget);
    expect(find.text('African Championship 2028: Group stage'), findsOneWidget);
    expect(
      find.text('African Championship 2032: To be decided'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('the tablet hub shows the card too', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: grudge(settled: false, stars: 0),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.byKey(CampaignHubCard.cardKey), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('a normal career has no card', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byKey(CampaignHubCard.cardKey), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  test('the run in numbers counts only the campaign competition', () {
    // Friendlies, World Championship rounds and qualifying (null round),
    // the play-off and the Nations Cup never count.
    for (final goal in CampaignGoal.values) {
      if (goal == CampaignGoal.qualifyBothThenTitle ||
          goal == CampaignGoal.titleTreble) {
        continue;
      }
      for (final round in [
        null,
        'FRIENDLY',
        'GROUP',
        'R16',
        'FINAL',
        'NGROUP',
        'CPO',
      ]) {
        // Young Finns: the World Championship finals are its competition.
        final worldFinals =
            goal == CampaignGoal.qualifyWorldThenTitles &&
            {'GROUP', 'R16', 'FINAL'}.contains(round);
        expect(
          campaignRunCounts(goal, round),
          worldFinals,
          reason: '$goal $round',
        );
      }
      // Qualifying counts, except for Best of Guineas and Young Finns: their
      // competition is the finals (and Guineas' rivals, whatever the round).
      expect(
        campaignRunCounts(goal, 'CQ'),
        goal != CampaignGoal.beatRivalsThenContinental &&
            goal != CampaignGoal.qualifyWorldThenTitles,
      );
    }
    for (final round in ['CGROUP', 'CFINAL', 'GROUP', 'QF', 'FINAL']) {
      expect(
        campaignRunCounts(CampaignGoal.qualifyWorldThenTitles, round),
        isTrue,
      );
    }
    // The continental finals count for the Transplant and Best of Guineas.
    for (final round in ['CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL']) {
      expect(campaignRunCounts(CampaignGoal.qualifyContinental, round), isTrue);
      expect(campaignRunCounts(CampaignGoal.aboveRival, round), isFalse);
      expect(
        campaignRunCounts(CampaignGoal.beatRivalsThenContinental, round),
        isTrue,
      );
    }
    // Greenland: every competitive match, World Championship
    // qualifying (no round) included; never a friendly.
    for (final round in [null, 'CQ', 'NGROUP', 'NL', 'CPO', 'CGROUP', 'R16']) {
      expect(
        campaignRunCounts(CampaignGoal.qualifyBothThenTitle, round),
        isTrue,
        reason: '$round',
      );
    }
    expect(
      campaignRunCounts(CampaignGoal.qualifyBothThenTitle, 'FRIENDLY'),
      isFalse,
    );
    // Finish the Legacy: its three titles, both championships' finals and
    // the whole Nations Cup; never qualifying, a play-off or a friendly.
    for (final round in [
      'CGROUP',
      'CFINAL',
      'GROUP',
      'FINAL',
      'NGROUP',
      'NSF',
      'NFINAL',
    ]) {
      expect(
        campaignRunCounts(CampaignGoal.titleTreble, round),
        isTrue,
        reason: round,
      );
    }
    for (final round in [null, 'CQ', 'CPO', 'FRIENDLY']) {
      expect(
        campaignRunCounts(CampaignGoal.titleTreble, round),
        isFalse,
        reason: '$round',
      );
    }
  });
}
