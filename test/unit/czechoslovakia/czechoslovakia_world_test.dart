import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

/// Reunited's world: Czechoslovakia in the place of Czechia and Slovakia,
/// both gone, Europe one nation smaller, every Czech and Slovak
/// international in its squad, and the history of all three its own.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const def = Campaigns.czechoslovakia;
  const tch = DormantNations.czechoslovakiaId;
  const czechia = 12;
  const slovakia = 48;
  final marker = DormantNations.markerFor(tch);

  bool names(Fixture f, int id) => f.homeNationId == id || f.awayNationId == id;

  /// The real players of the two nations: their seeded ids.
  bool real(int id) => (id >= 1201 && id <= 1223) || (id >= 4801 && id <= 4823);

  Future<void> expectNeitherNation(ProviderContainer c, int id) async {
    final comp = c.read(competitionRepositoryProvider);
    final fixtures = await comp.allFixtures(id);
    for (final gone in [czechia, slovakia]) {
      expect(fixtures.where((f) => names(f, gone)), isEmpty);
    }
    expect(fixtures.where((f) => names(f, tch)), isNotEmpty);
    final tiers = await c.read(careerRepositoryProvider).nationsCupTiers(id);
    expect(tiers.keys, isNot(contains(czechia)));
    expect(tiers.keys, isNot(contains(slovakia)));
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    expect(ranking.nations.map((n) => n.id), isNot(contains(czechia)));
    expect(ranking.nations.map((n) => n.id), isNot(contains(slovakia)));
  }

  test('one nation in two places: Europe plays with one fewer, and every '
      'Czech and Slovak international plays for Czechoslovakia', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final id = d.careerId;
    final repo = c.read(nationRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);

    expect(await comp.hasWatchedDraw(id, 0, marker), isTrue);
    final world = await repo.forCareer(id);
    final base = await repo.all();
    expect(world, hasLength(base.length - 1));
    expect(world.map((n) => n.id), contains(tch));
    expect(world.map((n) => n.id), isNot(contains(czechia)));
    expect(world.map((n) => n.id), isNot(contains(slovakia)));
    expect(
      world.where((n) => n.confederation == Confederation.europe).length,
      base.where((n) => n.confederation == Confederation.europe).length - 1,
    );

    // Every seeded international of both, naturalised in at the start.
    final links = await c
        .read(careerRepositoryProvider)
        .acceptedNaturalizations(id);
    expect(links.map((l) => l.playerId).where(real), hasLength(46));
    expect(links.where((l) => !real(l.playerId)), isEmpty);

    // The XI is theirs: the real players start, the stored pool is depth.
    final tactic = await c.read(tacticsRepositoryProvider).tacticForCareer(id);
    final lineup = tactic!.lineup.whereType<int>().toList();
    expect(lineup, hasLength(11));
    expect(lineup.where(real).length, greaterThanOrEqualTo(10));

    // It starts above both nations it is made of.
    final ranking = (await c.read(worldRankingProvider(id).future))!;
    final at = ranking.nations.indexWhere((n) => n.id == tch);
    expect(at, lessThan(base.indexWhere((n) => n.id == slovakia)));

    // The history of all three is its own.
    final honours = await comp.honours(id);
    final euro76 = honours.singleWhere(
      (h) => h.competition == 'European Championship' && h.year == 1976,
    );
    expect(euro76.championId, tch);
    final euro96 = honours.singleWhere(
      (h) => h.competition == 'European Championship' && h.year == 1996,
    );
    expect(euro96.runnerUpId, tch);

    await expectNeitherNation(c, id);

    final progress = (await c.read(campaignProgressProvider(id).future))!;
    expect(progress.def.id, 'czechoslovakia');
    expect(progress.reached, 0);
  });

  test('the second cycle is still one nation in two places', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.startCampaign(c, def);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    await comp.createKnockout(
      careerId: id,
      cycle: 0,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      pairings: [(26, 1)],
      date: DateTime(CareerService.worldCupYear(0), 7, 19),
      firstRound: 'FINAL',
    );
    final fin = await comp.fixturesByRound(id, 'FINAL');
    await comp.recordResult(
      fixtureId: fin.single.id,
      homeScore: 1,
      awayScore: 0,
    );
    expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
    await c.read(seasonServiceProvider).startNextCycle(id);
    final career = (await c.read(careerRepositoryProvider).byId(id))!;
    expect(career.cyclePointer, 1);
    expect(career.nationId, tch);
    await expectNeitherNation(c, id);
  });

  test('in the base world Czechia and Slovakia stay apart', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final repo = c.read(nationRepositoryProvider);
    final ids = (await repo.all()).map((n) => n.id);
    expect(ids, containsAll([czechia, slovakia]));
    expect(ids, isNot(contains(tch)));
    expect((await repo.byId(tch))?.name, 'Czechoslovakia');
  });
}
