import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../story/driver.dart';

/// A campaign longer than one cycle rolls, unmoved, from one cycle into the
/// next, keeping its nation; at the end of its last cycle it ends in the
/// campaigns list, as a one-cycle campaign does at the end of its only one.
void main() {
  /// Records a World Championship final in the career's current cycle.
  Future<void> decideWorldChampionship(ProviderContainer c, int id) async {
    final comp = c.read(competitionRepositoryProvider);
    final cycle =
        (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer;
    await comp.createKnockout(
      careerId: id,
      cycle: cycle,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(26, 1)],
      date: DateTime(CareerService.worldCupYear(cycle), 7, 19),
      firstRound: 'FINAL',
    );
    final fin = await comp.fixturesByRound(id, 'FINAL');
    await comp.recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
  }

  test('an unmoved two-cycle run rolls into its second cycle, then ends in '
      'the campaigns list', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, Campaigns.guineas);
    final season = c.read(seasonServiceProvider);
    final careers = c.read(careerRepositoryProvider);

    // The end of the first cycle: the rollover, not the campaigns list.
    await decideWorldChampionship(c, d.careerId);
    expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
    expect(await season.trialBlocksNextCycle(d.careerId), isFalse);
    // An offer taken elsewhere is ignored: the campaign keeps its nation.
    await season.startNextCycle(d.careerId, switchToNationId: 26);
    var career = (await careers.byId(d.careerId))!;
    expect(career.cyclePointer, 1);
    expect(career.nationId, Campaigns.guineas.nationId);
    expect(
      (await c.read(activeCampaignProvider(d.careerId).future))?.def.id,
      'guineas',
    );

    // The end of the second, and last: the verdict, then the list.
    await decideWorldChampionship(c, d.careerId);
    final verdict = await d.nextEvent();
    expect(verdict.kind, HubEventKind.campaignVerdict);
    expect(verdict.route, startsWith(Routes.campaignVerdict));
    await c.read(campaignServiceProvider).acknowledgeVerdict(d.careerId);
    final done = await d.nextEvent();
    expect(done.kind, HubEventKind.campaignVerdict);
    expect(done.route, Routes.campaigns);

    // Below the UI too: it cannot be rolled a third time.
    expect(await season.trialBlocksNextCycle(d.careerId), isFalse);
    await season.startNextCycle(d.careerId);
    career = (await careers.byId(d.careerId))!;
    expect(career.cyclePointer, 1);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a Pro run whose purchase is refunded meets the wall at its next '
      'cycle, and rolls again once Pro is back', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, Campaigns.guineas);
    expect(Campaigns.guineas.needsPro, isTrue);
    final season = c.read(seasonServiceProvider);
    final careers = c.read(careerRepositoryProvider);

    await decideWorldChampionship(c, d.careerId);
    expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);

    // Refunded: the store no longer names the unlock.
    c.read(premiumUnlockedProvider.notifier).state = false;
    expect(await season.trialBlocksNextCycle(d.careerId), isTrue);
    await season.startNextCycle(d.careerId);
    expect((await careers.byId(d.careerId))!.cyclePointer, 0);
    expect(
      (await c.read(activeCampaignProvider(d.careerId).future))?.def.id,
      'guineas',
      reason: 'the run is kept, only held where it was',
    );

    // Bought again: it rolls.
    c.read(premiumUnlockedProvider.notifier).state = true;
    expect(await season.trialBlocksNextCycle(d.careerId), isFalse);
    await season.startNextCycle(d.careerId);
    expect((await careers.byId(d.careerId))!.cyclePointer, 1);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
