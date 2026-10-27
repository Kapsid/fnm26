import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../story/driver.dart';

/// A campaign run is told its verdict the moment its goal is settled, once,
/// and its cycle ends in the campaigns list: never the rollover, never the
/// free-cycle wall, until the manager moves it into his saves.
void main() {
  Future<T> read<T>(ProviderContainer c, AutoDisposeFutureProvider<T> p) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  test(
    'the next event of a fresh campaign builds without a provider cycle',
    () async {
      final c = freeStoryContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.startCampaign(c, Campaigns.grudge);
      final e = await d.nextEvent();
      expect(e.kind, HubEventKind.budget);
    },
  );

  test(
    'Grudge: one verdict when settled, and the cycle ends in the campaigns '
    'list; a normal career over the same steps is unchanged',
    () async {
      // The same world as an ordinary career, for the comparison: a new
      // campaign run starts on the current starting ranking, as a new career
      // does (see CampaignService.start).
      final normalKinds = <HubEventKind>[];
      final n = freeStoryContainer();
      final normal = await StoryDriver.start(
        n,
        Campaigns.grudge.rngSeed,
        nationId: Campaigns.grudge.nationId,
      );
      normal.beforeEvent = (e) async => normalKinds.add(e.kind);
      // 200 steps, or the whole cycle if it is shorter.
      for (var i = 0; i < 200; i++) {
        if (!await normal.step(stopAtRollover: true)) break;
      }
      n.dispose();

      final c = freeStoryContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.startCampaign(c, Campaigns.grudge);
      final events = <HubEvent>[];
      int? verdictAt;
      int? firstAfterContinentalDraw;
      var drawSeen = false;
      int? starsAtVerdict;
      d.beforeEvent = (e) async {
        final i = events.length;
        events.add(e);
        if (drawSeen) firstAfterContinentalDraw ??= i;
        if (e.route != null &&
            Uri.parse(e.route!).path == Routes.continentalDraw) {
          drawSeen = true;
        }
        if (e.kind == HubEventKind.campaignVerdict &&
            e.route!.startsWith(Routes.campaignVerdict)) {
          verdictAt ??= i;
          final p = await read(c, campaignProgressProvider(d.careerId));
          expect(p!.settled, isTrue);
          starsAtVerdict = p.stars;
        }
      };
      var steps = 0;
      while (await d.step()) {
        expect(++steps, lessThan(5000), reason: 'the run never ended');
      }

      // The verdict arrived, once, no later than the step after the
      // continental finals draw (when the finals field decides the Grudge).
      expect(verdictAt, isNotNull);
      expect(
        firstAfterContinentalDraw,
        isNotNull,
        reason: 'the continental finals draw event was seen',
      );
      expect(verdictAt, lessThanOrEqualTo(firstAfterContinentalDraw!));
      final verdicts = events
          .where((e) => e.route?.startsWith(Routes.campaignVerdict) ?? false)
          .length;
      expect(verdicts, 1, reason: 'acknowledged, it does not come back');
      expect(
        await read(c, campaignBestProvider(Campaigns.grudge.id)),
        starsAtVerdict,
      );

      // The cycle ended in the campaigns list: no rollover, no trial wall.
      final last = events.last;
      expect(last.kind, HubEventKind.campaignVerdict);
      expect(last.route, Routes.campaigns);
      expect(
        events.map((e) => e.kind),
        isNot(contains(HubEventKind.cycleRollover)),
      );
      expect(
        events.where((e) => e.route?.startsWith(Routes.cycleRollover) ?? false),
        isEmpty,
      );
      expect(
        await c.read(competitionRepositoryProvider).worldChampion(d.careerId),
        isNotNull,
      );

      // Below the UI too: the unmoved run cannot be rolled, and is not
      // walled (premium is off; a normal save here would be).
      final season = c.read(seasonServiceProvider);
      expect(await season.trialBlocksNextCycle(d.careerId), isFalse);
      await season.startNextCycle(d.careerId);
      final career = await c.read(careerRepositoryProvider).byId(d.careerId);
      expect(career!.cyclePointer, 0);

      // The same world as a normal career, step for step, verdicts aside.
      final campaignKinds = [
        for (final e in events)
          if (e.kind != HubEventKind.campaignVerdict) e.kind,
      ];
      expect(normalKinds, isNotEmpty);
      expect(campaignKinds.take(normalKinds.length).toList(), normalKinds);

      // Moved into the saves, it is an ordinary save: the rollover, and the
      // free cycle's wall.
      expect(
        await c.read(campaignServiceProvider).moveToSaves(d.careerId),
        CampaignMoveResult.moved,
      );
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
      expect(await season.trialBlocksNextCycle(d.careerId), isTrue);
    },
    timeout: const Timeout(Duration(minutes: 40)),
  );
}
