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

/// The Three Legs' world: the Isle of Man in Andorra's place in Europe, from the
/// very first draw through the next cycle, a career bundle, a cloud backup's
/// description and a move into the saves. Mirrors greenland_world_test.dart.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const def = Campaigns.isleOfMan;
  const isle = DormantNations.isleOfManId;
  const andorra = 2;
  final marker = DormantNations.markerFor(isle);

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

  /// Nothing the career stored refers to Andorra.
  Future<void> expectNoAndorra(ProviderContainer c, int id) async {
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = await comp.allFixtures(id);
    expect(fixtures.where((f) => names(f, andorra)), isEmpty);
    expect(fixtures.where((f) => names(f, isle)), isNotEmpty);
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, isNot(contains(andorra)));
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.map((n) => n.id), isNot(contains(andorra)));
    expect(ranking.points.keys, isNot(contains(andorra)));
    final cycle =
        (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer;
    final snap = await c
        .read(seedRankingRepositoryProvider)
        .forCycle(id, cycle);
    expect(snap.keys, isNot(contains(andorra)));
    for (final h in await comp.honours(id)) {
      expect(
        [h.championId, h.coChampionId, h.runnerUpId, h.thirdId, h.thirdId2],
        isNot(contains(andorra)),
        reason: '${h.competition} ${h.year}',
      );
    }
    final andorraWord = RegExp(r'\bAndorra\b');
    for (final m in await comp.messages(id)) {
      expect(andorraWord.hasMatch('${m.title} ${m.body}'), isFalse);
    }
  }

  test("the Isle of Man's world from the first day: Andorra's place, "
      "Andorra's rank, its own players", () async {
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
    expect(world, hasLength(base.length));
    expect(world.map((n) => n.id), contains(isle));
    expect(world.map((n) => n.id), isNot(contains(andorra)));
    // Greenland stays out: only this campaign's dormant nation joins.
    expect(world.map((n) => n.id), isNot(contains(DormantNations.greenlandId)));
    expect(world.map((n) => n.id), contains(45));
    bool european(int id) =>
        world.firstWhere((n) => n.id == id).confederation ==
        Confederation.europe;
    expect(
      world.where((n) => european(n.id)).length,
      base.where((n) => n.confederation == Confederation.europe).length,
    );

    // A European qualifying group of five or more. On calendar2 the
    // qualifying draw comes after the first Nations Cup.
    await drawEuroQualifyingNow(c, id);
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: Confederation.europe,
    );
    final mine = groups.where(
      (g) => g.standings.any((s) => s.nationId == isle),
    );
    expect(mine, hasLength(1));
    expect(mine.single.standings.length, greaterThanOrEqualTo(5));

    // On day one the Isle of Man stands where Andorra would.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations, hasLength(base.length));
    expect(
      ranking.nations.indexWhere((n) => n.id == isle),
      base.indexWhere((n) => n.id == andorra),
    );

    // The default XI is the Isle of Man's own.
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    for (final pid in lineup) {
      expect(
        (pid >= 21401 && pid <= 21423) || (pid >= 20214000 && pid <= 20214079),
        isTrue,
        reason: 'player $pid',
      );
    }

    await expectNoAndorra(c, id);

    // The campaign reads its own goal from the first day.
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.def.id, 'isleOfMan');
    expect(progress.reached, 0);
    expect(progress.cycleRuns.single.over, isFalse);
    expect(progress.worldRuns, hasLength(1));
  });

  test("the second cycle is still the Isle of Man's world, and a moved run "
      'shows in the saves with its name', () async {
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
    expect(career.nationId, isle);
    await expectNoAndorra(c, id);
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(id);
    expect(
      fixtures.where(
        (f) => names(f, isle) && f.date.isAfter(CareerService.cycleOpens(1)),
      ),
      isNotEmpty,
    );

    // A century is long: the run is still open after its second cycle.
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
    expect(known[isle]?.name, 'Isle of Man');
    expect(known[isle]?.code, 'IMN');
  });

  test("a career bundle keeps the world the Isle of Man's, and a cloud backup "
      'names the nation', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final db = c.read(appDatabaseProvider);
    final dir = Directory.systemTemp.createTempSync('fnm-isle-of-man-bundle');
    addTearDown(() => dir.deleteSync(recursive: true));

    // The whole-database backup a cloud upload describes.
    final backup = p.join(dir.path, 'backup.sqlite');
    await db.customStatement("VACUUM INTO '$backup'");
    expect(
      careersInBackup(backup).map((s) => s.nationName),
      contains('Isle of Man'),
    );

    final bundle = await CareerBundle.export(db, d.careerId);
    expect(CareerBundle.watchedKindsOf(bundle), contains(marker));
    final file = File(p.join(dir.path, 'isle_of_man.fnm'));
    await file.writeAsBytes(CareerBundle.encode(bundle));

    final other = storyContainer();
    addTearDown(other.dispose);
    await other.read(seedLoaderProvider).ensureSeeded();
    expect(
      await other.read(careerTransferServiceProvider).import(file.path),
      isNull,
    );
    final run = (await other.read(campaignRunsProvider.future))['isleOfMan']!;
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
                .byNation(isle, saveSeed: career.rngSeed, careerId: id))
          pl.id: pl.name,
      };
    }

    expect(await squad(other, run.id), await squad(c, d.careerId));
    final world = await other.read(nationRepositoryProvider).forCareer(run.id);
    expect(world.map((n) => n.id), contains(isle));
    expect(world.map((n) => n.id), isNot(contains(andorra)));
    await expectNoAndorra(other, run.id);
  });

  test(
    'in the base world and in a Greenland career, Andorra stays Andorra',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final g = await StoryDriver.startCampaign(c, Campaigns.greenland);
      final repo = c.read(nationRepositoryProvider);
      final greenlandWorld = await repo.forCareer(g.careerId);
      expect(greenlandWorld.map((n) => n.id), contains(andorra));
      expect(greenlandWorld.map((n) => n.id), isNot(contains(isle)));
      expect((await repo.all()).map((n) => n.id), contains(andorra));
      expect((await repo.all()).map((n) => n.id), isNot(contains(isle)));
      // Every database knows the Isle of Man, so a save's nation always has a name.
      expect((await repo.byId(isle))?.name, 'Isle of Man');
    },
  );
}
