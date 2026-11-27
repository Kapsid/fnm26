import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/campaign/campaign_grading.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_verdict_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Home Soil: Sweden, an average side, handed the World Championship of its
/// one cycle with Denmark and Norway. Out of the group is one star, the
/// quarter-final two, the semi-final three; going out in the group fails it.
const sweden = 51;
const denmark = 13;
const norway = 39;

void main() {
  late ProviderContainer container;
  late List<Nation> nations;
  late List<Player> players;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // Free: no Pro needed to start it.
        premiumUnlockedProvider.overrideWith((ref) => false),
        rolloverVerdictProvider.overrideWith(
          (ref, careerId) async => RolloverVerdict(
            performance: 50,
            headline: const MsgText(MsgKey.finishGroupStage),
            detail: const MsgText(MsgKey.finishGroupStage),
            sacked: false,
            currentNation: null,
            offers: const [],
            reputation: 0,
            nationalHero: false,
            cyclesAtNation: 1,
          ),
        ),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: PoolGenerator.expand(players),
          ),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  CompetitionRepository comp() => container.read(competitionRepositoryProvider);

  Future<int> start() async =>
      (await container
              .read(campaignServiceProvider)
              .start(Campaigns.homeSoil, managerName: 'Me'))
          .id;

  Future<CampaignProgress> progress(int careerId) async {
    container
      ..invalidate(hubDataProvider(careerId))
      ..invalidate(campaignProgressProvider(careerId));
    final p = await container.read(
      campaignProgressProvider(careerId).future,
    );
    return p!;
  }

  /// The run's world as the career reads it, its markers on the nations.
  Future<List<Nation>> world(int careerId) =>
      container.read(nationRepositoryProvider).forCareer(careerId);

  /// European sides outside the hosts, strongest first.
  List<int> others(int n) => [
    for (final x in nations)
      if (x.confederation == Confederation.europe &&
          !Campaigns.homeSoil.worldHostNationIds.contains(x.id))
        x.id,
  ].take(n).toList();

  /// A World Championship group of Sweden and three others, every game
  /// played: Sweden win each one when [swedenWin], else lose each.
  Future<List<int>> playGroup(int careerId, {required bool swedenWin}) async {
    final group = [sweden, ...others(3)];
    await comp().saveTournamentGroups(
      careerId: careerId,
      cycle: 0,
      confederation: Confederation.europe,
      kind: CompetitionKind.worldCupFinals,
      name: 'World Championship',
      draw: FinalsDraw(
        groups: [
          FinalsGroupDraw(
            name: 'A',
            nationIds: group,
            fixtures: [
              for (var i = 0; i < group.length; i++)
                for (var j = i + 1; j < group.length; j++)
                  (i + j, group[i], group[j]),
            ],
          ),
        ],
      ),
      groupStart: DateTime(CareerService.worldCupYear(0), 6, 12),
    );
    for (final f in await comp().fixturesByRound(careerId, 'GROUP')) {
      final mine = f.homeNationId == sweden || f.awayNationId == sweden;
      final swedenHome = f.homeNationId == sweden;
      final homeWins = !mine || (swedenHome == swedenWin);
      await comp().recordResult(
        fixtureId: f.id,
        homeScore: homeWins ? 2 : 0,
        awayScore: homeWins ? 0 : 2,
      );
    }
    return group;
  }

  /// A knockout tie of [round] with Sweden in it, Sweden winning it when
  /// [swedenWin].
  Future<void> tie(
    int careerId,
    String round, {
    required int opponent,
    required bool swedenWin,
    required int day,
  }) async {
    await comp().addKnockoutFixtures(
      careerId: careerId,
      round: round,
      pairings: [(sweden, opponent)],
      date: DateTime(CareerService.worldCupYear(0), 7, day),
    );
    final f = (await comp().fixturesByRound(careerId, round)).single;
    await comp().recordResult(
      fixtureId: f.id,
      homeScore: swedenWin ? 1 : 0,
      awayScore: swedenWin ? 0 : 1,
    );
  }

  test('the campaign: Sweden, one cycle, free, medium, can be continued, '
      'with Denmark and Norway as co-hosts', () {
    const def = Campaigns.homeSoil;
    expect(def.nationId, sweden);
    expect(def.cycles, 1);
    expect(def.needsPro, isFalse);
    expect(def.difficulty, CampaignDifficulty.medium);
    expect(def.canContinue, isTrue);
    expect(def.withBelarus, isTrue);
    expect(def.goal, CampaignGoal.hostOutOfGroupThenQuarterThenSemi);
    expect(def.worldHostNationIds, [sweden, denmark, norway]);
    expect(def.namedNations, containsAll([sweden, denmark, norway]));
    expect(def.goldenGeneration, isFalse);
    expect(def.donorNationId, isNull);
    expect(def.dormantNationId, isNull);
    expect(Campaigns.byId('homeSoil'), def);
    expect(nations.firstWhere((n) => n.id == sweden).name, 'Sweden');
    // Among the one-cycle runs, right after Finish the Legacy.
    final ids = [for (final c in Campaigns.all) c.id];
    expect(ids.indexOf('homeSoil'), ids.indexOf('legacy') + 1);
    expect(
      [
        for (final c in Campaigns.all)
          if (c.worldHostNationIds.isNotEmpty) c.id,
      ],
      ['homeSoil'],
    );
  });

  test('hostOutOfGroupStars: out of the group, the quarter-final, the '
      'semi-final', () {
    expect(hostOutOfGroupStars(0), 0); // no finals yet
    expect(hostOutOfGroupStars(2), 0); // out in the group
    expect(hostOutOfGroupStars(3), 1); // the last 32 or the last 16
    expect(hostOutOfGroupStars(4), 2); // the quarter-final
    expect(hostOutOfGroupStars(5), 3); // the semi-final
    expect(hostOutOfGroupStars(6), 3);
    expect(hostOutOfGroupStars(7), 3);
  });

  test('Sweden is an average side: its real squad, outside the top 15', () {
    final byNation = <int, List<int>>{};
    for (final p in players) {
      (byNation[p.nationId] ??= []).add(
        OverallRating.forPosition(p.position, p.attributes),
      );
    }
    double bestEleven(int id) {
      final o = [...?byNation[id]]..sort((a, b) => b - a);
      final xi = o.take(11);
      return xi.isEmpty ? 0 : xi.reduce((a, b) => a + b) / xi.length;
    }

    final ranked = [for (final n in nations) n.id]
      ..sort((a, b) => bestEleven(b).compareTo(bestEleven(a)));
    expect(ranked.indexOf(sweden) + 1, greaterThan(15));
    expect(nations.firstWhere((n) => n.id == sweden).ranking, greaterThan(15));
  });

  test('no Nordic ground set reaches the bar, so the hosts are handed over: '
      'the biggest Nordic ground holds 50,000, the final needs 60,000', () {
    const bar = HostStadiumRules.worldChampionshipLighter;
    List<int> seats(int id) =>
        HostStadiumRules.qualifyingSeats(nationId: id, editionCycle: 0);
    expect(HostStadiumRules.meets(seats(sweden), bar), isFalse);
    final nordic = [...seats(sweden), ...seats(denmark), ...seats(norway)];
    expect(HostStadiumRules.meets(nordic, bar), isFalse);
    expect(nordic.reduce((a, b) => a > b ? a : b), 50000);
    // Sweden, ranked outside the top 30, may not count planned grounds.
    expect(
      HostStadiumRules.plannedAi(
        worldRank: nations.firstWhere((n) => n.id == sweden).ranking,
        comp: HostBidComp.worldChampionship,
        seats: seats(sweden),
        bar: bar,
      ),
      isEmpty,
    );
  });

  test('seed 1958: Sweden leads the hosts of its World Championship, with '
      'Denmark and Norway, in real grounds only', () async {
    final id = await start();
    final w = await world(id);
    final year = CareerService.worldCupYear(0);
    const def = Campaigns.homeSoil;
    expect(WorldCupHosts.forcedWorldHosts(0, w), [sweden, denmark, norway]);
    expect(
      WorldCupHosts.hostsFor(year: year, nations: w, seed: def.rngSeed),
      [sweden, denmark, norway],
    );
    expect(
      WorldCupHosts.hostFor(year: year, nations: w, seed: def.rngSeed),
      sweden,
    );
    // The ceremony shows the winning bid first.
    expect(
      WorldCupHosts.worldCupBids(
        year: year,
        nations: w,
        seed: def.rngSeed,
      ).first,
      [sweden, denmark, norway],
    );
    // None of them hosts the European Championship the summer before.
    expect(
      WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: def.rngSeed,
        nations: w,
      ),
      isNot(anyOf(contains(sweden), contains(denmark), contains(norway))),
    );
    // So Sweden plays the European qualifying campaign.
    expect(
      WorldCupHosts.continentalQualifiers(
        confederation: Confederation.europe,
        cycle: 0,
        seed: def.rngSeed,
        nations: w,
      ).map((n) => n.id),
      contains(sweden),
    );
    // Staged under the stadium bars, in the grounds that count toward the
    // bar, with no ground promised or invented.
    final plan = WorldCupHosts.worldCupGroundPlan(
      year: year,
      nations: w,
      seed: def.rngSeed,
    );
    expect(plan, isNotNull);
    expect(
      plan!.minSeats,
      HostStadiumRules.worldChampionshipLighter.otherSeats,
    );
    expect(plan.promised, isEmpty);
    expect(plan.planned, isEmpty);
    final venues = VenueGenerator.forHosts(
      hostIds: [sweden, denmark, norway],
      count: VenueGenerator.countForField(48),
      qualifyingOnly: true,
      minSeats: plan.minSeats,
      planned: plan.planned,
    );
    ({String city, int seats}) g(Venue v) => (city: v.city, seats: v.capacity);
    expect(venues[sweden]!.map(g), [
      (city: 'Stockholm', seats: 50000),
      (city: 'Gothenburg', seats: 43000),
    ]);
    expect(venues[denmark]!.map(g), [
      (city: 'Copenhagen', seats: 38000),
      (city: 'Brøndby', seats: 28000),
    ]);
    expect(venues[norway]!.map(g), [(city: 'Oslo', seats: 28000)]);
    // Every one a real ground of its host's.
    for (final e in venues.entries) {
      final real = nationalStadiumData[e.key]!;
      for (final v in e.value) {
        expect(real, contains((v.city, v.capacity)), reason: '$v');
      }
    }
  });

  test(
    'Sweden sits out World Championship qualifying, as a host does',
    () async {
      final id = await start();
      final fixtures = await comp().cycleFixturesForNation(id, sweden);
      // A World Championship qualifier: a group game with no round code.
      expect(
        fixtures.where((f) => f.groupId != null && f.round == null),
        isEmpty,
      );
    },
  );

  test('the board asks the host to get out of the group', () async {
    final id = await start();
    final outcomes = await container.read(
      cycleObjectiveOutcomesProvider(id).future,
    );
    final wc = outcomes.where((o) => o.tier == TournamentTier.world).single;
    expect(wc.target, 3);
    expect(wc.graded, isFalse);
  });

  test('at the start: nothing reached, nothing settled', () async {
    final id = await start();
    final p = await progress(id);
    expect(p.worldRuns, hasLength(1));
    expect(p.reached, 0);
    expect(p.settled, isFalse);
  });

  test('out in the group: no star, and settled once the knockouts are drawn '
      'without Sweden', () async {
    final id = await start();
    final group = await playGroup(id, swedenWin: false);
    expect((await progress(id)).settled, isFalse);
    await comp().addKnockoutFixtures(
      careerId: id,
      round: 'R32',
      pairings: [(group[1], group[2])],
      date: DateTime(CareerService.worldCupYear(0), 6, 28),
    );
    final p = await progress(id);
    expect(p.worldRuns.single, (ordinal: 2, over: true));
    expect(p.settled, isTrue);
    expect(p.stars, 0);
  });

  test(
    'one star: out of the group, beaten in the first knockout round',
    () async {
      final id = await start();
      final group = await playGroup(id, swedenWin: true);
      var p = await progress(id);
      expect(p.reached, 0);
      await tie(id, 'R32', opponent: group[1], swedenWin: false, day: 1);
      p = await progress(id);
      expect(p.reached, 1);
      expect(p.settled, isTrue);
      expect(p.stars, 1);
    },
  );

  test('two stars: the quarter-final reached and lost', () async {
    final id = await start();
    final group = await playGroup(id, swedenWin: true);
    await tie(id, 'R32', opponent: group[1], swedenWin: true, day: 1);
    await tie(id, 'R16', opponent: group[2], swedenWin: true, day: 5);
    var p = await progress(id);
    expect(p.reached, 1);
    expect(p.settled, isFalse);
    await tie(id, 'QF', opponent: group[3], swedenWin: false, day: 9);
    p = await progress(id);
    expect(p.reached, 2);
    expect(p.settled, isTrue);
    expect(p.stars, 2);
  });

  test('three stars: the semi-final; the run plays on until it is over for '
      'Sweden', () async {
    final id = await start();
    final group = await playGroup(id, swedenWin: true);
    await tie(id, 'R32', opponent: group[1], swedenWin: true, day: 1);
    await tie(id, 'R16', opponent: group[2], swedenWin: true, day: 5);
    await tie(id, 'QF', opponent: group[3], swedenWin: true, day: 9);
    await comp().addKnockoutFixtures(
      careerId: id,
      round: 'SF',
      pairings: [(sweden, others(4).last)],
      date: DateTime(CareerService.worldCupYear(0), 7, 14),
    );
    var p = await progress(id);
    expect(p.reached, 3);
    expect(p.settled, isFalse);
    final sf = (await comp().fixturesByRound(id, 'SF')).single;
    await comp().recordResult(fixtureId: sf.id, homeScore: 0, awayScore: 1);
    p = await progress(id);
    expect(p.settled, isTrue);
    expect(p.stars, 3);
  });

  test('the run in numbers counts the World Championship alone', () {
    const goal = CampaignGoal.hostOutOfGroupThenQuarterThenSemi;
    for (final r in ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL']) {
      expect(campaignRunCounts(goal, r), isTrue, reason: r);
    }
    for (final r in ['CQ', 'CGROUP', 'CQF', 'NGROUP', 'FRIENDLY', null]) {
      expect(campaignRunCounts(goal, r), isFalse, reason: r);
    }
  });
}
