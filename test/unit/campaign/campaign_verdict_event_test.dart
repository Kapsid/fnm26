import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
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
        // A campaign run's world: no Belarus (DormantNations.forNewCareers),
        // or the two calendars part ways and the comparison means nothing.
        newCareerNations: false,
        // A campaign run's hosts: drawn without the stadium bars.
        stadiumHostRules: false,
      );
      // Less the general sponsor's stops: a campaign run has no sponsor (it
      // is played on the money it was set), and declining one changes
      // nothing else.
      normal.beforeEvent = (e) async {
        final sponsor =
            e.kind == HubEventKind.sponsor ||
            (e.route?.startsWith(Routes.sponsor) ?? false);
        if (!sponsor) normalKinds.add(e.kind);
      };
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
      // The first step at which Georgia's place in the finals field is known
      // (see the verdict check below).
      int? fieldKnownAt;
      bool? playoffEntrant;
      var drawSeen = false;
      int? starsAtVerdict;
      final comp = c.read(competitionRepositoryProvider);
      final georgia = Campaigns.grudge.nationId;
      d.beforeEvent = (e) async {
        final i = events.length;
        events.add(e);
        if (drawSeen) {
          firstAfterContinentalDraw ??= i;
          playoffEntrant ??= EuroPlayoffs.fromSlots(
            await comp.drawSlots(
              d.careerId,
              0,
              CompetitionKind.continentalPlayoff,
              confederation: Confederation.europe,
            ),
          ).any((p) => p.seeds.contains(georgia));
          if (fieldKnownAt == null) {
            final played = [
              for (final f in await comp.cycleFixturesForNation(
                d.careerId,
                georgia,
              ))
                if (EuroPlayoffs.rounds.contains(f.round) && f.hasResult) f,
            ];
            final pathDecided = played.any(
              (f) =>
                  f.round == EuroPlayoffs.finalRound ||
                  !campaignNationWon(f, georgia),
            );
            if (!playoffEntrant! || pathDecided) fieldKnownAt = i;
          }
        }
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

      // The verdict arrived, once, as soon as Georgia's place in the finals
      // field was known (that decides the Grudge's "and qualify" star). On
      // the calendar2 rhythm Europe's finals are drawn in November with a
      // placeholder per play-off path and created after the March
      // play-offs: a side drawn straight in, or in neither the draw nor a
      // path, knows at the draw (the step after it, as before calendar2); a
      // path's entrant only once its path is decided. Seed 240's Georgia
      // finishes above Albania but outside the top two, a play-off
      // entrant (a semi won on 21 March, the path final on the 26th). A side
      // beaten there is then offered send-off friendlies by the qualified
      // (hub order 1b-i, ahead of the verdict): those may come first.
      expect(verdictAt, isNotNull);
      expect(
        firstAfterContinentalDraw,
        isNotNull,
        reason: 'the continental finals draw event was seen',
      );
      expect(fieldKnownAt, isNotNull, reason: 'the finals field was settled');
      if (!playoffEntrant!) {
        expect(fieldKnownAt, firstAfterContinentalDraw);
      }
      var verdictDue = fieldKnownAt!;
      while (events[verdictDue].kind == HubEventKind.warmUpOffer) {
        verdictDue++;
      }
      expect(verdictAt, lessThanOrEqualTo(verdictDue));
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
