import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/cloud/backup_describer.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/calendar2_draws.dart';
import '../../story/driver.dart';

/// Hail Mary's world: Vatican City in San Marino's place in Europe, from the
/// very first draw through the next cycle, its stars (a European
/// Championship, a World Championship, the world title), a career bundle, a cloud backup's description and a move into the saves.
/// Mirrors isle_of_man_world_test.dart and texas_world_test.dart.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const def = Campaigns.vatican;
  const vatican = DormantNations.vaticanId;
  const sanMarino = 45;
  final marker = DormantNations.markerFor(vatican);

  /// Records a World Championship final in the career's current cycle, which
  /// is what ends a cycle.
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

  bool names(Fixture f, int id) => f.homeNationId == id || f.awayNationId == id;

  /// Nothing the career stored refers to San Marino.
  Future<void> expectNoSanMarino(ProviderContainer c, int id) async {
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = await comp.allFixtures(id);
    expect(fixtures.where((f) => names(f, sanMarino)), isEmpty);
    expect(fixtures.where((f) => names(f, vatican)), isNotEmpty);
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, isNot(contains(sanMarino)));
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.map((n) => n.id), isNot(contains(sanMarino)));
    expect(ranking.points.keys, isNot(contains(sanMarino)));
    final cycle =
        (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer;
    final snap = await c
        .read(seedRankingRepositoryProvider)
        .forCycle(id, cycle);
    expect(snap.keys, isNot(contains(sanMarino)));
    for (final h in await comp.honours(id)) {
      expect(
        [h.championId, h.coChampionId, h.runnerUpId, h.thirdId, h.thirdId2],
        isNot(contains(sanMarino)),
        reason: '${h.competition} ${h.year}',
      );
    }
    final word = RegExp(r'\bSan Marino\b');
    for (final m in await comp.messages(id)) {
      expect(word.hasMatch('${m.title} ${m.body}'), isFalse);
    }
  }

  test("Vatican City's world from the first day: San Marino's place, the "
      'last rank, its own players', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final id = d.careerId;
    final repo = c.read(nationRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);

    // The marker landed with the career, and the world is the swapped one.
    expect(await comp.hasWatchedDraw(id, 0, marker), isTrue);
    final world = await repo.forCareer(id);
    final base = await repo.all();
    // A swap, plus Belarus (a European run's world, CampaignDef.withBelarus).
    expect(world, hasLength(base.length + 1));
    expect(world.map((n) => n.id), contains(DormantNations.belarusId));
    expect(world.map((n) => n.id), contains(vatican));
    expect(world.map((n) => n.id), isNot(contains(sanMarino)));
    // Greenland, San Marino's other stand-in, stays out: only this
    // campaign's dormant nation joins.
    expect(world.map((n) => n.id), isNot(contains(DormantNations.greenlandId)));
    bool european(int id) =>
        world.firstWhere((n) => n.id == id).confederation ==
        Confederation.europe;
    expect(
      world.where((n) => european(n.id)).length,
      base.where((n) => n.confederation == Confederation.europe).length + 1,
    );

    // A European qualifying group of five, as for every side of the
    // Nations Cup's bottom league in the EURO 2028 shape
    // (campaign_seeds_test.dart). On calendar2 the qualifying draw comes
    // after the first Nations Cup.
    await drawEuroQualifyingNow(c, id);
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: Confederation.europe,
    );
    final mine = groups.where(
      (g) => g.standings.any((s) => s.nationId == vatican),
    );
    expect(mine, hasLength(1));
    expect(mine.single.standings, hasLength(5));

    // On day one Vatican City stands last, where San Marino would.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations, hasLength(base.length + 1));
    expect(ranking.nations.last.id, vatican);

    // The default XI is Vatican City's own.
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    for (final pid in lineup) {
      expect(
        (pid >= 21701 && pid <= 21723) || (pid >= 20217000 && pid <= 20217079),
        isTrue,
        reason: 'player $pid',
      );
    }

    await expectNoSanMarino(c, id);

    // The campaign reads its own goal from the first day.
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.def.id, 'vatican');
    expect(progress.reached, 0);
    expect(progress.settled, isFalse);
  });

  test('the stars climb: a European Championship place, a World '
      'Championship place, the world title, and only then is the run '
      'settled', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    Future<CampaignProgress> progress() async {
      c.invalidate(hubDataProvider(id));
      final now = await c.read(campaignProgressProvider(id).future);
      return now!;
    }

    // Nothing reached yet.
    expect((await progress()).reached, 0);

    // Into a European Championship: the first star, the run still open.
    await comp.createKnockout(
      careerId: id,
      cycle: 0,
      confederation: Confederation.europe,
      kind: CompetitionKind.continentalFinals,
      name: 'European Championship',
      pairings: [(vatican, 26)],
      date: DateTime(CareerService.continentalFinalsYear(0), 6, 29),
      firstRound: 'CR16',
    );
    var now = await progress();
    expect(now.reached, 1);
    expect(now.settled, isFalse);
    expect(now.stars, 0);

    // Into a World Championship: the second, still open.
    await comp.createKnockout(
      careerId: id,
      cycle: 0,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(vatican, 1)],
      date: DateTime(CareerService.worldCupYear(0), 7, 1),
      firstRound: 'R16',
    );
    now = await progress();
    expect(now.reached, 2);
    expect(now.settled, isFalse);
    expect(now.stars, 0);

    // The world title: the third star, and nothing left to reach.
    await comp.addKnockoutFixtures(
      careerId: id,
      round: 'FINAL',
      pairings: [(vatican, 26)],
      date: DateTime(CareerService.worldCupYear(0), 7, 19),
      kind: CompetitionKind.worldCupFinals,
    );
    final fin = await comp.fixturesByRound(id, 'FINAL');
    await comp.recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
    now = await progress();
    expect(now.reached, 3);
    expect(now.settled, isTrue);
    expect(now.stars, 3);
  });

  test("the second cycle is still Vatican City's world, the run still open, "
      'and a moved run shows in the saves with its name', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final id = d.careerId;
    final season = c.read(seasonServiceProvider);

    await decideWorldChampionship(c, id);
    expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
    await season.startNextCycle(id);
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    expect(career.cyclePointer, 1);
    expect(career.nationId, vatican);
    await expectNoSanMarino(c, id);
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(id);
    expect(
      fixtures.where(
        (f) => names(f, vatican) && f.date.isAfter(CareerService.cycleOpens(1)),
      ),
      isNotEmpty,
    );

    // No end: the run is open after its first cycle, and its board may not
    // sack the manager.
    c.invalidate(hubDataProvider(id));
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.settled, isFalse);
    expect(progress.cycleRuns, hasLength(2));
    final comp = c.read(competitionRepositoryProvider);
    expect(await campaignBarsSacking(comp, career), isTrue);

    await comp.markDrawWatched(id, 0, campaignMovedKind);
    await comp.markDrawWatched(id, 1, campaignMovedAtKind);
    c.invalidate(savesProvider);
    final saves = await c.read(savesProvider.future);
    expect(saves.map((s) => s.id), contains(id));
    final known = await c.read(knownNationsByIdProvider.future);
    expect(known[vatican]?.name, 'Vatican City');
    expect(known[vatican]?.code, 'VAT');
  });

  test("a career bundle keeps the world Vatican City's, and a cloud backup "
      'names the nation', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final db = c.read(appDatabaseProvider);
    final dir = Directory.systemTemp.createTempSync('fnm-vatican-bundle');
    addTearDown(() => dir.deleteSync(recursive: true));

    // The whole-database backup a cloud upload describes.
    final backup = p.join(dir.path, 'backup.sqlite');
    await db.customStatement("VACUUM INTO '$backup'");
    expect(
      careersInBackup(backup).map((s) => s.nationName),
      contains('Vatican City'),
    );

    final bundle = await CareerBundle.export(db, d.careerId);
    expect(CareerBundle.watchedKindsOf(bundle), contains(marker));
    final file = File(p.join(dir.path, 'vatican.fnm'));
    await file.writeAsBytes(CareerBundle.encode(bundle));

    final other = storyContainer();
    addTearDown(other.dispose);
    await other.read(seedLoaderProvider).ensureSeeded();
    expect(
      await other.read(careerTransferServiceProvider).import(file.path),
      isNull,
    );
    final run = (await other.read(campaignRunsProvider.future))['vatican']!;
    expect(
      await other
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(run.id, 0, marker),
      isTrue,
    );
    Future<Map<int, String>> squad(ProviderContainer from, int id) async {
      final career = (await from.read(careerRepositoryProvider).byId(id))!;
      return {
        for (final pl
            in await from
                .read(playerRepositoryProvider)
                .byNation(vatican, saveSeed: career.rngSeed, careerId: id))
          pl.id: pl.name,
      };
    }

    expect(await squad(other, run.id), await squad(c, d.careerId));
    final world = await other.read(nationRepositoryProvider).forCareer(run.id);
    expect(world.map((n) => n.id), contains(vatican));
    expect(world.map((n) => n.id), isNot(contains(sanMarino)));
    await expectNoSanMarino(other, run.id);
  });

  test('in the base world and an Isle of Man career San Marino stays San '
      'Marino; in a Greenland career Greenland, not Vatican City, takes its '
      'place', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final repo = c.read(nationRepositoryProvider);
    final isle = await StoryDriver.startCampaign(c, Campaigns.isleOfMan);
    final isleWorld = await repo.forCareer(isle.careerId);
    expect(isleWorld.map((n) => n.id), contains(sanMarino));
    expect(isleWorld.map((n) => n.id), isNot(contains(vatican)));
    final g = await StoryDriver.startCampaign(c, Campaigns.greenland);
    final greenlandWorld = await repo.forCareer(g.careerId);
    expect(greenlandWorld.map((n) => n.id), isNot(contains(sanMarino)));
    expect(greenlandWorld.map((n) => n.id), contains(212));
    expect(greenlandWorld.map((n) => n.id), isNot(contains(vatican)));
    expect((await repo.all()).map((n) => n.id), contains(sanMarino));
    expect((await repo.all()).map((n) => n.id), isNot(contains(vatican)));
    // Every database knows Vatican City, so a save's nation always has a
    // name.
    expect((await repo.byId(vatican))?.name, 'Vatican City');
  });
}
