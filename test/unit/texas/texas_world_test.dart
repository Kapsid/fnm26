import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/cloud/backup_describer.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player_ids.dart';
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

import '../../story/driver.dart';

/// The Lone Star's world: Texas in Anguilla's place in North America, from
/// the very first draw through the next cycle, a career bundle, a cloud
/// backup's description and a move into the saves. Mirrors
/// isle_of_man_world_test.dart.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const def = Campaigns.texas;
  const texas = DormantNations.texasId;
  const anguilla = 66;
  const usa = 99;
  final marker = DormantNations.markerFor(texas);

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

  /// Nothing the career stored refers to Anguilla.
  Future<void> expectNoAnguilla(ProviderContainer c, int id) async {
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = await comp.allFixtures(id);
    expect(fixtures.where((f) => names(f, anguilla)), isEmpty);
    expect(fixtures.where((f) => names(f, texas)), isNotEmpty);
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, isNot(contains(anguilla)));
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.map((n) => n.id), isNot(contains(anguilla)));
    expect(ranking.points.keys, isNot(contains(anguilla)));
    final cycle =
        (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer;
    final snap = await c
        .read(seedRankingRepositoryProvider)
        .forCycle(id, cycle);
    expect(snap.keys, isNot(contains(anguilla)));
    for (final h in await comp.honours(id)) {
      expect(
        [h.championId, h.coChampionId, h.runnerUpId, h.thirdId, h.thirdId2],
        isNot(contains(anguilla)),
        reason: '${h.competition} ${h.year}',
      );
    }
    final anguillaWord = RegExp(r'\bAnguilla\b');
    for (final m in await comp.messages(id)) {
      expect(anguillaWord.hasMatch('${m.title} ${m.body}'), isFalse);
    }
  }

  test("Texas's world from the first day: Anguilla's place, its own rank, "
      'its own players, the United States as they were', () async {
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
    // A swap, and no Belarus: a North American run's world.
    expect(world, hasLength(base.length));
    expect(world.map((n) => n.id), isNot(contains(DormantNations.belarusId)));
    expect(world.map((n) => n.id), contains(texas));
    expect(world.map((n) => n.id), isNot(contains(anguilla)));
    expect(world.map((n) => n.id), contains(usa));
    // No other dormant nation joins: only this campaign's.
    expect(world.map((n) => n.id), isNot(contains(DormantNations.isleOfManId)));
    bool northAmerican(int id) =>
        world.firstWhere((n) => n.id == id).confederation ==
        Confederation.northAmerica;
    expect(
      world.where((n) => northAmerican(n.id)).length,
      base.where((n) => n.confederation == Confederation.northAmerica).length,
    );

    // A North American qualifying group of five or more, the United States
    // in it (seed 221, campaign_seeds_test.dart).
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: Confederation.northAmerica,
    );
    final mine = groups.where(
      (g) => g.standings.any((s) => s.nationId == texas),
    );
    expect(mine, hasLength(1));
    expect(mine.single.standings.length, greaterThanOrEqualTo(5));
    expect(mine.single.standings.map((s) => s.nationId), contains(usa));

    // On day one Texas stands on its own rank, between Haiti and Guatemala,
    // not at the foot of the table where Anguilla stood.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations, hasLength(base.length));
    final at = ranking.nations.indexWhere((n) => n.id == texas);
    expect(at, greaterThan(ranking.nations.indexWhere((n) => n.id == 85)));
    expect(at, lessThan(ranking.nations.indexWhere((n) => n.id == 83)));
    expect(at, lessThan(base.indexWhere((n) => n.id == anguilla)));

    // The default XI is Texas's own.
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    for (final pid in lineup) {
      expect(
        (pid >= 21601 && pid <= 21623) || (pid >= 20216000 && pid <= 20216079),
        isTrue,
        reason: 'player $pid',
      );
    }

    // The United States keep every core player: nobody is taken from them.
    final run = (await c.read(careerRepositoryProvider).byId(id))!;
    final players = c.read(playerRepositoryProvider);
    final usaRun = await players.byNation(
      usa,
      saveSeed: run.rngSeed,
      careerId: id,
    );
    // The classic pools on purpose: the base world, not this career.
    final usaBase = await players.byNation(
      usa,
      saveSeed: run.rngSeed,
      newCareerNames: true,
    );
    Set<int> core(Iterable<int> ids) => {
      for (final i in ids)
        if (i < kFirstFringeId) i,
    };
    expect(core(usaRun.map((p) => p.id)), core(usaBase.map((p) => p.id)));
    expect(usaRun.every((p) => p.nationId == usa), isTrue);

    await expectNoAnguilla(c, id);

    // The campaign reads its own goal from the first day.
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.def.id, 'texas');
    expect(progress.reached, 0);
    expect(progress.cycleRuns.single.over, isFalse);
    expect(progress.worldRuns, hasLength(1));
  });

  test("the second cycle is still Texas's world, and a moved run shows in "
      'the saves with its name', () async {
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
    expect(career.nationId, texas);
    await expectNoAnguilla(c, id);
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(id);
    expect(
      fixtures.where(
        (f) => names(f, texas) && f.date.isAfter(CareerService.cycleOpens(1)),
      ),
      isNotEmpty,
    );

    // Four cycles: the run is still open after its second.
    c.invalidate(hubDataProvider(id));
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.settled, isFalse);
    expect(progress.cycleRuns, hasLength(2));
    expect(progress.worldRuns, hasLength(2));

    final comp = c.read(competitionRepositoryProvider);
    await comp.markDrawWatched(id, 0, campaignMovedKind);
    await comp.markDrawWatched(id, 1, campaignMovedAtKind);
    c.invalidate(savesProvider);
    final saves = await c.read(savesProvider.future);
    expect(saves.map((s) => s.id), contains(id));
    final known = await c.read(knownNationsByIdProvider.future);
    expect(known[texas]?.name, 'Texas');
    expect(known[texas]?.code, 'TEX');
  });

  test("a career bundle keeps the world Texas's, and a cloud backup names "
      'the nation', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final db = c.read(appDatabaseProvider);
    final dir = Directory.systemTemp.createTempSync('fnm-texas-bundle');
    addTearDown(() => dir.deleteSync(recursive: true));

    // The whole-database backup a cloud upload describes.
    final backup = p.join(dir.path, 'backup.sqlite');
    await db.customStatement("VACUUM INTO '$backup'");
    expect(
      careersInBackup(backup).map((s) => s.nationName),
      contains('Texas'),
    );

    final bundle = await CareerBundle.export(db, d.careerId);
    expect(CareerBundle.watchedKindsOf(bundle), contains(marker));
    final file = File(p.join(dir.path, 'texas.fnm'));
    await file.writeAsBytes(CareerBundle.encode(bundle));

    final other = storyContainer();
    addTearDown(other.dispose);
    await other.read(seedLoaderProvider).ensureSeeded();
    expect(
      await other.read(careerTransferServiceProvider).import(file.path),
      isNull,
    );
    final run = (await other.read(campaignRunsProvider.future))['texas']!;
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
                .byNation(texas, saveSeed: career.rngSeed, careerId: id))
          pl.id: pl.name,
      };
    }

    expect(await squad(other, run.id), await squad(c, d.careerId));
    final world = await other.read(nationRepositoryProvider).forCareer(run.id);
    expect(world.map((n) => n.id), contains(texas));
    expect(world.map((n) => n.id), isNot(contains(anguilla)));
    await expectNoAnguilla(other, run.id);
  });

  test(
    'in the base world and in a Zanzibar career, Anguilla stays Anguilla',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final z = await StoryDriver.startCampaign(c, Campaigns.zanzibar);
      final repo = c.read(nationRepositoryProvider);
      final zanzibarWorld = await repo.forCareer(z.careerId);
      expect(zanzibarWorld.map((n) => n.id), contains(anguilla));
      expect(zanzibarWorld.map((n) => n.id), isNot(contains(texas)));
      expect((await repo.all()).map((n) => n.id), contains(anguilla));
      expect((await repo.all()).map((n) => n.id), isNot(contains(texas)));
      // Every database knows Texas, so a save's nation always has a name.
      expect((await repo.byId(texas))?.name, 'Texas');
    },
  );
}
