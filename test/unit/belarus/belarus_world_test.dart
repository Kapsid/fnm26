import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

/// Belarus is back from 1.0.9, in every ordinary career created from then on
/// and in no other: Europe plays with 54. A save made before (no marker) and
/// every campaign run keep the world they had. Mirrors zanzibar_world_test.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const belarus = DormantNations.belarusId;
  const palestine = 185;
  final marker = DormantNations.markerFor(belarus);

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

  bool plays(Fixture f, int id) => f.homeNationId == id || f.awayNationId == id;

  /// Nobody is booked twice on one day, anywhere in the career.
  Future<void> expectNoDoubleBookings(ProviderContainer c, int id) async {
    final seen = <(int, DateTime)>{};
    for (final f
        in await c.read(competitionRepositoryProvider).allFixtures(id)) {
      final day = DateTime(f.date.year, f.date.month, f.date.day);
      for (final n in [f.homeNationId, f.awayNationId]) {
        expect(seen.add((n, day)), isTrue, reason: 'nation $n twice on $day');
      }
    }
  }

  /// Europe's groups of [kind] this cycle: every group a playable size and
  /// nobody in two groups.
  Future<Set<int>> europeGroups(
    ProviderContainer c,
    int id,
    CompetitionKind kind, {
    required int min,
    required int max,
  }) async {
    final groups = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(id, kind, confederation: Confederation.europe);
    final members = <int>{};
    for (final g in groups) {
      expect(
        g.standings.length,
        inInclusiveRange(min, max),
        reason: '$kind ${g.name}',
      );
      for (final s in g.standings) {
        expect(members.add(s.nationId), isTrue, reason: '$kind ${s.nationId}');
      }
    }
    return members;
  }

  test('a new ordinary career has Belarus: 54 in Europe, in its qualifying, '
      'ranking and Nations Cup ladder', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 11);
    final id = d.careerId;
    final repo = c.read(nationRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);

    expect(await comp.hasWatchedDraw(id, 0, marker), isTrue);
    final world = await repo.forCareer(id);
    final base = await repo.all();
    expect(world, hasLength(base.length + 1));
    expect(world.map((n) => n.id).toSet(), {...base.map((n) => n.id), belarus});
    expect(
      world.where((n) => n.confederation == Confederation.europe),
      hasLength(54),
    );
    // Straight after Palestine, on Palestine's 94.
    final at = world.indexWhere((n) => n.id == belarus);
    expect(world[at - 1].id, palestine);
    expect(world[at].ranking, 94);

    // In a European qualifying group from the first draw.
    final cq = await europeGroups(
      c,
      id,
      CompetitionKind.continentalQualifying,
      min: 4,
      max: 6,
    );
    expect(cq, contains(belarus));
    final fixtures = await comp.allFixtures(id);
    expect(fixtures.where((f) => plays(f, belarus)), isNotEmpty);

    // On the world ranking and the Nations Cup ladder.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations, hasLength(base.length + 1));
    expect(ranking.points.keys, contains(belarus));
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, contains(belarus));
    final europeTiers = [
      for (final n in world)
        if (n.confederation == Confederation.europe) tiers[n.id],
    ];
    expect(europeTiers.whereType<int>(), hasLength(54));

    // The new-game pickers offer it too.
    expect(
      (await c.read(nationsProvider.future)).map((n) => n.id),
      contains(belarus),
    );
    await expectNoDoubleBookings(c, id);
  });

  test('Europe with 54 stays sound over two cycles: groups, the ladder, no '
      'double bookings', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 23);
    final id = d.careerId;
    final careers = c.read(careerRepositoryProvider);
    final season = c.read(seasonServiceProvider);

    Future<void> checkLadder() async {
      final tiers = await careers.nationsCupTiers(id);
      final world = await c.read(nationRepositoryProvider).forCareer(id);
      final byTier = <int, int>{};
      for (final n in world) {
        if (n.confederation != Confederation.europe) continue;
        final t = tiers[n.id];
        expect(t, isNotNull, reason: 'nation ${n.id} off the ladder');
        byTier[t!] = (byTier[t] ?? 0) + 1;
      }
      expect(byTier.values.fold(0, (a, b) => a + b), 54);
      for (final e in byTier.entries) {
        expect(e.value, greaterThanOrEqualTo(4), reason: 'league ${e.key}');
      }
    }

    /// World Championship qualifying, drawn as the cycle draws it (lazily,
    /// in January of the year before the finals).
    Future<void> checkWorldQualifying() async {
      final career = (await careers.byId(id))!;
      final cycle = career.cyclePointer;
      await CareerService.buildWorldCupQualifying(
        comp: c.read(competitionRepositoryProvider),
        nations: await c.read(nationRepositoryProvider).forCareer(id),
        careerId: id,
        nationId: career.nationId,
        rngSeed: career.rngSeed,
        cycle: cycle,
        wcYear: CareerService.worldCupYear(cycle),
      );
      final wq = await europeGroups(
        c,
        id,
        CompetitionKind.worldCupQualifying,
        min: 4,
        max: 5,
      );
      expect(wq, contains(belarus));
      expect(wq.length, greaterThanOrEqualTo(52));
    }

    await checkLadder();
    await checkWorldQualifying();
    await expectNoDoubleBookings(c, id);
    final ladder0 = await careers.nationsCupTiers(id);
    for (var cycle = 0; cycle < 2; cycle++) {
      await decideWorldChampionship(c, id);
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
      await season.startNextCycle(id);
      expect((await careers.byId(id))!.cyclePointer, cycle + 1);
      await checkLadder();
      final cq = await europeGroups(
        c,
        id,
        CompetitionKind.continentalQualifying,
        min: 4,
        max: 6,
      );
      expect(cq, contains(belarus));
      await checkWorldQualifying();
      await expectNoDoubleBookings(c, id);
    }
    // Promotion and relegation move nations, never the leagues' sizes.
    final ladder2 = await careers.nationsCupTiers(id);
    int size(Map<int, int> t, int tier) =>
        t.values.where((v) => v == tier).length;
    for (final tier in {...ladder0.values}) {
      expect(size(ladder2, tier), size(ladder0, tier), reason: 'tier $tier');
    }
  });

  test('a career made without the marker (every save before 1.0.9) never '
      'sees Belarus', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 11, newCareerNations: false);
    final id = d.careerId;
    final repo = c.read(nationRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    expect(await comp.hasWatchedDraw(id, 0, marker), isFalse);
    expect(
      (await repo.forCareer(id)).map((n) => n.id).toList(),
      (await repo.all()).map((n) => n.id).toList(),
    );
    expect(
      (await comp.allFixtures(id)).where((f) => plays(f, belarus)),
      isEmpty,
    );
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, isNot(contains(belarus)));
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.map((n) => n.id), isNot(contains(belarus)));

    // Another launch's seeding changes nothing for it.
    await c.read(seedLoaderProvider).ensureSeeded();
    expect(
      (await repo.forCareer(id)).map((n) => n.id),
      isNot(contains(belarus)),
    );
  });

  test('campaign runs keep their world: no Belarus', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    for (final def in [Campaigns.greenland, Campaigns.zanzibar]) {
      final d = await StoryDriver.startCampaign(c, def);
      final comp = c.read(competitionRepositoryProvider);
      expect(await comp.hasWatchedDraw(d.careerId, 0, marker), isFalse);
      final world = await c
          .read(nationRepositoryProvider)
          .forCareer(d.careerId);
      expect(world.map((n) => n.id), isNot(contains(belarus)));
      expect(
        (await comp.allFixtures(d.careerId)).where((f) => plays(f, belarus)),
        isEmpty,
      );
    }
  });

  test('a manager can take Belarus itself', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 5, nationId: belarus);
    final id = d.careerId;
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    for (final pid in lineup) {
      expect(
        pid >= 601 && pid <= 623,
        isTrue,
        reason: 'player $pid',
      );
    }
    expect(
      (await c
              .read(competitionRepositoryProvider)
              .allFixtures(
                id,
              ))
          .where((f) => plays(f, belarus)),
      isNotEmpty,
    );
  });

  test(
    'a career bundle keeps the world: Belarus in, on the same squad',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 11);
      final db = c.read(appDatabaseProvider);
      final dir = Directory.systemTemp.createTempSync('fnm-belarus-bundle');
      addTearDown(() => dir.deleteSync(recursive: true));

      final bundle = await CareerBundle.export(db, d.careerId);
      expect(CareerBundle.watchedKindsOf(bundle), contains(marker));
      final file = File(p.join(dir.path, 'belarus.fnm'));
      await file.writeAsBytes(CareerBundle.encode(bundle));

      final other = storyContainer();
      addTearDown(other.dispose);
      await other.read(seedLoaderProvider).ensureSeeded();
      expect(
        await other.read(careerTransferServiceProvider).import(file.path),
        isNull,
      );
      final imported =
          (await other.read(careerRepositoryProvider).all()).single;
      expect(
        await other
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(imported.id, 0, marker),
        isTrue,
      );
      final world = await other
          .read(nationRepositoryProvider)
          .forCareer(imported.id);
      expect(world.map((n) => n.id), contains(belarus));
      Future<Map<int, String>> squad(ProviderContainer from, int id) async {
        final career = (await from.read(careerRepositoryProvider).byId(id))!;
        return {
          for (final pl
              in await from
                  .read(playerRepositoryProvider)
                  .byNation(belarus, saveSeed: career.rngSeed, careerId: id))
            pl.id: pl.name,
        };
      }

      expect(await squad(other, imported.id), await squad(c, d.careerId));

      // And a bundle of a career made without it stays without it.
      final old = await StoryDriver.start(c, 12, newCareerNations: false);
      final oldBundle = await CareerBundle.export(db, old.careerId);
      expect(CareerBundle.watchedKindsOf(oldBundle), isNot(contains(marker)));
    },
  );

  test('the flag and the stadium map ship', () {
    final flag = File('assets/flags/blr.svg');
    expect(flag.existsSync(), isTrue);
    final svg = flag.readAsStringSync();
    expect(svg, contains('#ce1720')); // red
    expect(svg, contains('#007c30')); // green
    expect(File('assets/geo/$belarus.json').existsSync(), isTrue);
  });
}
