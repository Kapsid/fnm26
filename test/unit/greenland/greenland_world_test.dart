import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';
import '../../story/driver.dart';
import 'greenland_fixtures.dart';

/// The Greenland campaign's world: Greenland in San Marino's place, from the
/// very first draw through later cycles, a bundle and a move into the saves;
/// and over a century run, a squad its own youth keeps refilling.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const def = Campaigns.greenland;
  const greenland = DormantNations.greenlandId;
  const sanMarino = 45;
  final marker = DormantNations.markerFor(greenland);

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
    expect(fixtures.where((f) => names(f, greenland)), isNotEmpty);
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, contains(greenland));
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
    for (final m in await comp.messages(id)) {
      expect('${m.title} ${m.body}', isNot(contains('San Marino')));
    }
  }

  test("Greenland's world from the first day: San Marino's place, the "
      'bottom of the ranking, its own players', () async {
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
    expect(world.map((n) => n.id), contains(greenland));
    expect(world.map((n) => n.id), isNot(contains(sanMarino)));
    bool european(int id) =>
        world.firstWhere((n) => n.id == id).confederation ==
        Confederation.europe;
    expect(
      world.where((n) => european(n.id)).length,
      base.where((n) => n.confederation == Confederation.europe).length,
    );

    // A European qualifying group, and the bottom Nations Cup league.
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalQualifying,
      confederation: Confederation.europe,
    );
    expect(
      groups.where((g) => g.standings.any((s) => s.nationId == greenland)),
      hasLength(1),
    );
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    final europeTiers = [
      for (final e in tiers.entries)
        if (european(e.key)) e.value,
    ];
    expect(
      tiers[greenland],
      europeTiers.reduce((a, b) => a > b ? a : b),
      reason: 'the bottom league',
    );

    // Last in the world ranking on day one.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.last.id, greenland);
    expect(ranking.nations, hasLength(base.length));

    // The default XI is Greenland's own.
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    for (final pid in lineup) {
      expect(
        (pid >= 21201 && pid <= 21223) || (pid >= 20212000 && pid <= 20212079),
        isTrue,
        reason: 'player $pid',
      );
    }

    await expectNoSanMarino(c, id);

    // The campaign reads its own goal from the first day.
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.def.id, 'greenland');
    expect(progress.reached, 0);
    expect(progress.cycleRuns.single.over, isFalse);
    expect(progress.worldRuns, hasLength(1));
  });

  test("the second cycle is still Greenland's world, and a moved run shows "
      'in the saves with its name', () async {
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
    expect(career.nationId, greenland);
    await expectNoSanMarino(c, id);
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(id);
    expect(
      fixtures.where(
        (f) =>
            names(f, greenland) && f.date.isAfter(CareerService.cycleOpens(1)),
      ),
      isNotEmpty,
    );

    // A century is long: the run is still open after its second cycle.
    c.invalidate(hubDataProvider(id));
    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.settled, isFalse);
    expect(progress.cycleRuns, hasLength(2));
    expect(progress.worldRuns, hasLength(2));

    // Moved into the saves (the markers moveToSaves writes once it is
    // settled), it shows there with Greenland's name and flag.
    final comp = c.read(competitionRepositoryProvider);
    await comp.markDrawWatched(id, 0, campaignMovedKind);
    await comp.markDrawWatched(id, 1, campaignMovedAtKind);
    c.invalidate(savesProvider);
    final saves = await c.read(savesProvider.future);
    expect(saves.map((s) => s.id), contains(id));
    final known = await c.read(knownNationsByIdProvider.future);
    expect(known[greenland]?.name, 'Greenland');
    expect(known[greenland]?.code, 'GRL');
  });

  test("a career bundle keeps the world Greenland's", () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final bundle = await CareerBundle.export(
      c.read(appDatabaseProvider),
      d.careerId,
    );
    final dir = Directory.systemTemp.createTempSync('fnm-greenland-bundle');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File(p.join(dir.path, 'greenland.fnm'));
    await file.writeAsBytes(CareerBundle.encode(bundle));

    final other = storyContainer();
    addTearDown(other.dispose);
    await other.read(seedLoaderProvider).ensureSeeded();
    expect(
      await other.read(careerTransferServiceProvider).import(file.path),
      isNull,
    );
    final run = (await other.read(campaignRunsProvider.future))['greenland']!;
    expect(
      await other
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(run.id, 0, marker),
      isTrue,
    );
    // The name-pool marks travel too, so the imported career names its
    // Greenlanders from the same pools, and so exactly as the original does.
    for (final kind in [namePoolsV3Kind, namePoolsV4Kind]) {
      expect(CareerBundle.watchedKindsOf(bundle), contains(kind));
      expect(
        await other
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(run.id, 0, kind),
        isTrue,
        reason: kind,
      );
    }
    Future<Map<int, String>> names(ProviderContainer from, int id) async {
      final career = (await from.read(careerRepositoryProvider).byId(id))!;
      return {
        for (final pl
            in await from
                .read(playerRepositoryProvider)
                .byNation(greenland, saveSeed: career.rngSeed, careerId: id))
          pl.id: pl.name,
      };
    }

    expect(await names(other, run.id), await names(c, d.careerId));
    final world = await other.read(nationRepositoryProvider).forCareer(run.id);
    expect(world.map((n) => n.id), contains(greenland));
    expect(world.map((n) => n.id), isNot(contains(sanMarino)));
    await expectNoSanMarino(other, run.id);
  });

  test("a century run: Greenland's players come through the same pipeline as "
      "San Marino's in a normal career, three rollovers on", () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final players = c.read(playerRepositoryProvider);

    // The Greenland run, and a normal San Marino career on the same seed.
    final gl =
        (await c.read(campaignServiceProvider).start(def, managerName: 'M')).id;
    final sm =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: sanMarino,
                  managerName: 'M',
                  rngSeed: def.rngSeed,
                ))
            .valueOrNull!
            .id;

    Future<(List<Player>, List<Player>)> pools(int id, int nationId) async {
      final now = (await careers.byId(id))!;
      final years = CareerService.agingYears(now);
      final senior = await players.byNation(
        nationId,
        agingYears: years,
        saveSeed: now.rngSeed,
        careerId: id,
      );
      final youth = await players.youthByNation(
        nationId,
        agingYears: years,
        saveSeed: now.rngSeed,
        careerId: id,
      );
      return (senior, youth);
    }

    bool ownNational(Player p, int nationId, Set<int> seededIds) =>
        p.nationId == nationId &&
        (seededIds.contains(p.id) ||
            (PlayerLifecycle.isNewgenId(p.id) &&
                PlayerLifecycle.nationIdOf(p.id) == nationId));

    Future<Set<int>> seededIds(int nationId) async => {
      for (final p in await players.byNation(nationId)) p.id,
    };
    final glSeeded = {
      for (final p in greenlandPool()) p.id,
    };
    final smSeeded = await seededIds(sanMarino);
    final (glDayOne, _) = await pools(gl, greenland);
    final (smDayOne, _) = await pools(sm, sanMarino);
    // The same deep pool, give or take a player: who has retired or been
    // released depends on each player's id.
    expect(
      glDayOne.length,
      closeTo(smDayOne.length, 3),
      reason: 'the same deep pool',
    );

    for (var roll = 1; roll <= 3; roll++) {
      for (final id in [gl, sm]) {
        await decideWorldChampionship(c, id);
        await c.read(seasonServiceProvider).startNextCycle(id);
        expect((await careers.byId(id))!.cyclePointer, roll);
      }
      final (glSenior, glYouth) = await pools(gl, greenland);
      final (smSenior, smYouth) = await pools(sm, sanMarino);
      final why = 'cycle $roll';

      // Every player is Greenland's own: seeded or its own newgens.
      expect(
        [...glSenior, ...glYouth].every(
          (p) => ownNational(p, greenland, glSeeded),
        ),
        isTrue,
        reason: why,
      );
      expect(
        [...smSenior, ...smYouth].every(
          (p) => ownNational(p, sanMarino, smSeeded),
        ),
        isTrue,
        reason: why,
      );

      // The same machinery: newgens in the senior pool, a youth pyramid
      // from the intake age to U-21, and pools of the same order of size as
      // San Marino's (releases and retirements are per player id, so the
      // counts are close rather than equal).
      int newgens(List<Player> ps) =>
          ps.where((p) => PlayerLifecycle.isNewgenId(p.id)).length;
      expect(newgens(glSenior), greaterThan(0), reason: why);
      expect(
        newgens(glSenior),
        closeTo(newgens(smSenior), newgens(smSenior) * 0.35 + 3),
        reason: why,
      );
      expect(
        glSenior.length,
        closeTo(smSenior.length, smSenior.length * 0.15),
        reason: why,
      );
      expect(glSenior.length, greaterThanOrEqualTo(glDayOne.length * 0.8));
      expect(
        glYouth.length,
        closeTo(smYouth.length, smYouth.length * 0.25 + 3),
        reason: why,
      );
      final glAges = {for (final p in glYouth) p.age};
      expect(glAges, contains(PlayerLifecycle.intakeAge), reason: why);
      expect(glAges.reduce((a, b) => a > b ? a : b), greaterThanOrEqualTo(19));
      // Enough for a full squad in every line.
      for (final cat in PositionCategory.values) {
        expect(
          glSenior.where((p) => p.category == cat).length,
          greaterThanOrEqualTo(cat == PositionCategory.goalkeeper ? 3 : 6),
          reason: '$why $cat',
        );
      }

      // The world is still Greenland's.
      final world = await c.read(nationRepositoryProvider).forCareer(gl);
      expect(world.map((n) => n.id), contains(greenland));
      expect(world.map((n) => n.id), isNot(contains(sanMarino)));
      final ranking = (await c.read(worldRankingProvider(gl).future))!;
      expect(ranking.nations.map((n) => n.id), contains(greenland));
      expect(ranking.nations.map((n) => n.id), isNot(contains(sanMarino)));
      final fixtures = await c
          .read(competitionRepositoryProvider)
          .allFixtures(gl);
      expect(fixtures.where((f) => names(f, sanMarino)), isEmpty);
      expect(
        fixtures.where(
          (f) =>
              names(f, greenland) &&
              !f.date.isBefore(CareerService.cycleOpens(roll)),
        ),
        isNotEmpty,
        reason: '$why has Greenland fixtures',
      );
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}
