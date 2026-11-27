import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/euro_qualifying28.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

List<T> _load<T>(String f, T Function(Map<String, Object?>) from) =>
    (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
        .map((e) => from(e as Map<String, Object?>))
        .toList();

/// The European qualifying draw of cycle 0 for [seed], as a new career
/// (and so every campaign run) stores it: the EURO 2028 shape ([Euro28]),
/// drawn with the real [Euro28.drawGroups] from pots in the first Nations
/// Cup's overall ranking with its league phase not yet played, the order
/// `drawEuroQualifyingNow` reads (the fourth test pins it to the real
/// thing, so a change there breaks this helper loudly).
///
/// A real run's draw is made once that league phase is played, on its
/// results: only the bottom pot (League D, Europe's last six) is the same
/// whatever happens. See [euroQualifyingPotOrder].
List<List<int>> euroQualifyingGroups(int seed, List<Nation> nations) =>
    euroQualifyingGroupsFor(
      seed,
      nations,
      euroQualifyingPotOrder(seed, nations),
    );

/// The EURO 2028 qualifying groups of cycle 0 for [seed] drawn from the pot
/// order [order] (see [Euro28.potOrder]): the hosts kept apart, as
/// `CareerService.buildEuroQualifying` draws them.
List<List<int>> euroQualifyingGroupsFor(
  int seed,
  List<Nation> nations,
  List<int> order,
) {
  const europe = Confederation.europe;
  final field = {
    for (final n in WorldCupHosts.continentalQualifiers(
      confederation: europe,
      cycle: 0,
      seed: seed,
      nations: nations,
    ))
      n.id,
  };
  return Euro28.drawGroups(
    order: order,
    rng: SeededRng(seed ^ (0 * 0x71) ^ 0xCAFE ^ 0xE28),
    separate: {
      for (final n in nations)
        if (n.confederation == europe && !field.contains(n.id)) n.id,
    },
  );
}

/// Europe's first Nations Cup of cycle 0 for [seed], league by league: the
/// groups as `CareerService.buildNationsCup` draws them (on the ranking's
/// ladder, groups of four), each in its stored order.
List<({String name, List<int> nationIds})> firstNationsCupGroups(
  int seed,
  List<Nation> nations,
) {
  const europe = Confederation.europe;
  final members = nations.where((n) => n.confederation == europe).toList()
    ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final tiers = NationsCup.seedTiers(nations, (n) => n.ranking);
  final ladder = NationsCup.mergeRemainders({
    for (final n in members) n.id: tiers[n.id] ?? 0,
  }, (_) => europe);
  final byTier = <int, List<Nation>>{};
  for (final n in members) {
    (byTier[ladder[n.id]!] ??= []).add(n);
  }
  final confTerm = (europe.index * 7) ^ (Calendar2.firstEdition * 0xED17);
  return [
    for (final tier in byTier.keys.toList()..sort())
      if (byTier[tier]!.length >= 4)
        for (final (i, g)
            in const ScheduleGenerator()
                .generate(
                  balancedHomeAway: true,
                  confederation: europe,
                  nations: byTier[tier]!,
                  rngSeed: seed ^ 0x5A17 ^ (tier * 0x9E37) ^ confTerm,
                  start: DateTime(2026, 9),
                  groupSize: 4,
                )
                .groups
                .indexed)
          (
            name: '${NationsCup.leagueLetter(tier)}${i + 1}',
            nationIds: g.nationIds,
          ),
  ];
}

/// The pot order of the EURO 2028 qualifying draw of cycle 0 for [seed]
/// (see `CareerService.euro28PotOrder`), the first Nations Cup unplayed:
/// [Euro28.potOrder] over its overall ranking with every record level, so
/// each league reads place by place across its groups, each group's sides
/// in the order the repository stores them (by nation id). [standings]
/// replaces the cup's tables (a played league phase, for a what-if).
List<int> euroQualifyingPotOrder(
  int seed,
  List<Nation> nations, {
  List<NcTable>? standings,
}) {
  final members =
      nations.where((n) => n.confederation == Confederation.europe).toList()
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final tables =
      standings ??
      [
        for (final g in firstNationsCupGroups(seed, nations))
          (
            name: g.name,
            standings: GroupStanding.table([...g.nationIds]..sort(), const []),
          ),
      ];
  return Euro28.potOrder(
    field: [for (final n in members) n.id],
    ncRanking: EuroPlayoffs.overallRanking(tables),
    fallback: [for (final n in members) n.id],
  );
}

/// Whether [id] is drawn into a EURO 2028 qualifying group of five in
/// cycle 0 for [seed] whatever the first Nations Cup's results: it plays in
/// the cup's bottom league, that league is exactly the draw's last, short
/// pot (Europe's 54 less four pots of twelve: six), and a short pot fills
/// the first groups, the six of five. The cup's overall ranking puts a
/// lower league's sides below every higher league's, so no result moves a
/// side out of that pot.
bool inBottomPotOfFive(int seed, List<Nation> nations, int id) {
  final cup = firstNationsCupGroups(seed, nations);
  final bottom = cup
      .map((g) => NationsCup.tierOfGroupName(g.name))
      .reduce((a, b) => a > b ? a : b);
  final league = [
    for (final g in cup)
      if (NationsCup.tierOfGroupName(g.name) == bottom) ...g.nationIds,
  ];
  final field = nations
      .where((n) => n.confederation == Confederation.europe)
      .length;
  final sizes = Euro28.groupSizes(field);
  final shortPot = field % Euro28.groupCount(field);
  return league.contains(id) &&
      league.length == shortPot &&
      sizes.take(shortPot).every((n) => n == 5);
}

/// The old draw (groups of six, the hosts out) for a confederation that
/// still qualifies that way.
List<List<int>> qualifyingGroups(
  int seed,
  List<Nation> nations,
  Confederation confederation,
) {
  final members =
      nations.where((n) => n.confederation == confederation).toList()
        ..sort((a, b) => a.ranking.compareTo(b.ranking));
  final field = {
    for (final n in WorldCupHosts.continentalQualifiers(
      confederation: confederation,
      cycle: 0,
      seed: seed,
      nations: nations,
    ))
      n.id,
  };
  final cq = const ScheduleGenerator().generate(
    confederation: confederation,
    nations: members.where((n) => field.contains(n.id)).toList(),
    rngSeed: seed ^ 0 ^ 0xCAFE,
    start: DateTime(2026, 9),
    groupSize: 6,
    windows: (
      start: DateTime(2026, 9),
      deadline: DateTime(2027, 6, 30),
      seed: seed ^ 0xCAFE ^ 0xF1D0,
      fillAll: false,
    ),
  );
  return [for (final g in cq.groups) g.nationIds];
}

/// The world a run of [def] started now is drawn from: the seed's nations,
/// its dormant nation in place of the one it replaces, and Belarus for a
/// European scenario ([CampaignDef.withBelarus]), as an ordinary career has.
///
/// A run's hosts follow the current rules and the stadium bars (the lighter
/// ones) in every cycle: the markers its creation and rollovers stamp, on
/// the run's nation. A World Championship the run hands its hosts
/// ([CampaignDef.worldHostNationIds]) rides on each of them, as the
/// creation stamps it.
List<Nation> campaignWorld(CampaignDef def, List<Nation> nations) => [
  for (final n in DormantNations.worldFrom(
    nations,
    {
      if (def.withBelarus) DormantNations.belarusId,
      ?def.dormantNationId,
    },
    dormant: (id) => DormantNations.all.firstWhere((n) => n.id == id),
  ))
    if (n.id == def.nationId || def.worldHostNationIds.contains(n.id))
      n.copyWith(
        hostBids: {
          ...n.hostBids,
          if (n.id == def.nationId)
            for (var c = 0; c < def.cycles + 1; c++) ...{
              HostBidding.managerKey(c): 1,
              HostBidding.rules2Key(c): 1,
              HostBidding.rules3Key(c): 1,
            },
          if (def.worldHostNationIds.contains(n.id))
            HostBidding.forcedWcKey(0):
                def.worldHostNationIds.indexOf(n.id) + 1,
        },
      )
    else
      n,
];

/// A seed whose EURO 2028 draw (unplayed cup) pairs Georgia with Albania on
/// a European career's world: the predictor's check against a real career.
const int _euro28PairingSeed = 9271;

void main() {
  // A new campaign run starts on the current starting ranking, the one in
  // nations.json (see CampaignService.start).
  final nations = _load('nations.json', Nation.fromJson);

  // These host checks read the draw with no bids in it. That is the only draw
  // a campaign run ever sees: host bids are never offered in a campaign (see
  // host_bid_flow_test), so no bid can make a campaign nation a host.
  test('no campaign nation or rival hosts the European Championship', () {
    for (final c in Campaigns.all) {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: c.rngSeed,
        nations: campaignWorld(c, nations),
      );
      expect(hosts, isNot(contains(c.nationId)), reason: c.id);
      if (c.rivalNationId case final rival?) {
        expect(hosts, isNot(contains(rival)), reason: '${c.id} rival');
      }
    }
  });

  test('Home Soil: Sweden leads the World Championship hosts, with Denmark '
      'and Norway, and none of them hosts the European Championship', () {
    const def = Campaigns.homeSoil;
    final w = campaignWorld(def, nations);
    expect(
      WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(0),
        nations: w,
        seed: def.rngSeed,
      ),
      def.worldHostNationIds,
    );
    expect(def.worldHostNationIds.first, def.nationId);
    final euro = WorldCupHosts.continentalHostsFor(
      confederation: Confederation.europe,
      cycle: 0,
      seed: def.rngSeed,
      nations: w,
    );
    for (final id in def.worldHostNationIds) {
      expect(euro, isNot(contains(id)), reason: '$id');
    }
    // Without the handed hosts the draw does not name Sweden: its grounds
    // reach no bar, so no seed alone could make it a host.
    final drawn = WorldCupHosts.hostsFor(
      year: CareerService.worldCupYear(0),
      nations: campaignWorld(Campaigns.legacy, nations),
      seed: def.rngSeed,
    );
    expect(drawn, isNot(contains(def.nationId)));
  });

  test("Best of Guineas: Equatorial Guinea hosts neither cycle's African "
      'Championship', () {
    const def = Campaigns.guineas;
    for (var cycle = 0; cycle < def.cycles; cycle++) {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.africa,
        cycle: cycle,
        seed: def.rngSeed,
        nations: campaignWorld(def, nations),
      );
      expect(hosts, isNot(contains(def.nationId)), reason: 'cycle $cycle');
    }
  });

  test('Young Finns: Finland hosts neither the World nor the European '
      'Championship in any of its three cycles', () {
    const def = Campaigns.youngFinns;
    final finWorld = campaignWorld(def, nations);
    expect(def.cycles, 3);
    for (var cycle = 0; cycle < def.cycles; cycle++) {
      final world = WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(cycle),
        nations: finWorld,
        seed: def.rngSeed,
      );
      final euro = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: cycle,
        seed: def.rngSeed,
        nations: finWorld,
      );
      expect(world, isNot(contains(def.nationId)), reason: 'cycle $cycle');
      expect(euro, isNot(contains(def.nationId)), reason: 'cycle $cycle');
      // So Finland plays the qualifying campaign every cycle.
      expect(
        WorldCupHosts.continentalQualifiers(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: def.rngSeed,
          nations: finWorld,
        ).map((n) => n.id),
        contains(def.nationId),
        reason: 'cycle $cycle',
      );
    }
  });

  test('Best of Guineas draws Guinea and Guinea-Bissau into Equatorial '
      "Guinea's qualifying group", () {
    const def = Campaigns.guineas;
    final groups = qualifyingGroups(
      def.rngSeed,
      campaignWorld(def, nations),
      Confederation.africa,
    );
    expect(
      groups.where(
        (g) => g.contains(116) && g.contains(123) && g.contains(124),
      ),
      hasLength(1),
    );
  });

  // In the format before EURO 2028, which the Grudge keeps (its euro28 is
  // false): the seed fixes the draw.
  test('Grudge draws Georgia and Albania into the same qualifying group', () {
    expect(Campaigns.grudge.euro28, isFalse);
    final groups = qualifyingGroups(
      Campaigns.grudge.rngSeed,
      campaignWorld(Campaigns.grudge, nations),
      Confederation.europe,
    );
    expect(groups.where((g) => g.contains(19) && g.contains(1)), hasLength(1));
  });

  // Every European side plays EURO 2028 qualifying, the hosts too: this
  // holds for any seed now, and is kept as the brief's premise.
  test('Transplant: San Marino is in the qualifying draw', () {
    expect(
      euroQualifyingGroups(
        Campaigns.transplant.rngSeed,
        campaignWorld(Campaigns.transplant, nations),
      ).expand((g) => g),
      contains(45),
    );
  });

  test('the helper matches the draw a real career stores', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    // A European career on a Grudge-like world (Belarus in), in the EURO
    // 2028 shape: seed 9271 pairs Georgia with Albania there on the
    // unplayed cup. (The Grudge itself keeps the older draw; see below.)
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 19,
                  managerName: 'M',
                  rngSeed: _euro28PairingSeed,
                  currentHostRules: true,
                  newCareerNations: Campaigns.grudge.withBelarus,
                ))
            .valueOrNull!;
    // On calendar2 drawn after the first Nations Cup, with these inputs.
    await drawEuroQualifyingNow(c, career.id);
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          career.id,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.europe,
        );
    final stored = [
      for (final t in tables) [for (final s in t.standings) s.nationId]..sort(),
    ];
    expect(
      stored.where((g) => g.contains(19) && g.contains(1)),
      hasLength(1),
    );
    final rebuilt = [
      for (final g in euroQualifyingGroups(
        _euro28PairingSeed,
        campaignWorld(Campaigns.grudge, nations),
      ))
        [...g]..sort(),
    ];
    expect(
      stored.map((g) => g.join(',')).toSet(),
      rebuilt.map((g) => g.join(',')).toSet(),
    );
  });

  test('a real Grudge run stores the older draw its seed promises', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 19,
                  managerName: 'M',
                  rngSeed: Campaigns.grudge.rngSeed,
                  currentHostRules: true,
                  newCareerNations: Campaigns.grudge.withBelarus,
                  euro28: Campaigns.grudge.euro28,
                ))
            .valueOrNull!;
    await drawEuroQualifyingNow(c, career.id);
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          career.id,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.europe,
        );
    final stored = [
      for (final t in tables) [for (final s in t.standings) s.nationId]..sort(),
    ];
    expect(
      stored.where((g) => g.contains(19) && g.contains(1)),
      hasLength(1),
    );
    final rebuilt = [
      for (final g in qualifyingGroups(
        Campaigns.grudge.rngSeed,
        campaignWorld(Campaigns.grudge, nations),
        Confederation.europe,
      ))
        [...g]..sort(),
    ];
    expect(
      stored.map((g) => g.join(',')).toSet(),
      rebuilt.map((g) => g.join(',')).toSet(),
    );
  });

  test('Best of Guineas: a real career stores the shared group', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: _load('players.json', Player.fromJson),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    const def = Campaigns.guineas;
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: def.nationId,
                  managerName: 'M',
                  rngSeed: def.rngSeed,
                  currentHostRules: true,
                  newCareerNations: def.withBelarus,
                ))
            .valueOrNull!;
    final tables = await c
        .read(competitionRepositoryProvider)
        .tournamentGroupTables(
          career.id,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.africa,
        );
    final stored = [
      for (final t in tables) [for (final s in t.standings) s.nationId]..sort(),
    ];
    expect(
      stored.where(
        (g) => g.contains(116) && g.contains(123) && g.contains(124),
      ),
      hasLength(1),
    );
    final rebuilt = [
      for (final g in qualifyingGroups(
        def.rngSeed,
        campaignWorld(def, nations),
        Confederation.africa,
      ))
        [...g]..sort(),
    ];
    expect(
      stored.map((g) => g.join(',')).toSet(),
      rebuilt.map((g) => g.join(',')).toSet(),
    );
  });

  group('Greenland', () {
    const def = Campaigns.greenland;
    // Its world: San Marino out, Greenland in (what forCareer gives the run).
    final world = campaignWorld(def, nations);

    test('seed 212 keeps Greenland from hosting either championship in '
        'all 25 cycles of its century', () {
      expect(def.rngSeed, 212);
      for (var cycle = 0; cycle < def.cycles; cycle++) {
        final world0 = WorldCupHosts.hostsFor(
          year: CareerService.worldCupYear(cycle),
          nations: world,
          seed: def.rngSeed,
        );
        final euro = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: def.rngSeed,
          nations: world,
        );
        expect(world0, isNot(contains(212)), reason: 'cycle $cycle');
        expect(euro, isNot(contains(212)), reason: 'cycle $cycle');
      }
    });

    test('seed 212 draws Greenland into a European qualifying group of '
        'five, whatever the first Nations Cup', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(212)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 5);
      expect(inBottomPotOfFive(def.rngSeed, world, 212), isTrue);
    });

    test('a real Greenland run stores that draw', () async {
      SharedPreferences.setMockInitialValues({});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: def.nationId,
                    managerName: 'M',
                    rngSeed: def.rngSeed,
                    currentHostRules: true,
                    worldMarkers: [DormantNations.markerFor(212)],
                    // A run's world: Belarus in, as for every European run.
                    newCareerNations: def.withBelarus,
                  ))
              .valueOrNull!;
      await drawEuroQualifyingNow(c, career.id);
      final tables = await c
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            career.id,
            CompetitionKind.continentalQualifying,
            confederation: Confederation.europe,
          );
      final stored = [
        for (final t in tables)
          [for (final s in t.standings) s.nationId]..sort(),
      ];
      final rebuilt = [
        for (final g in euroQualifyingGroups(def.rngSeed, world))
          [...g]..sort(),
      ];
      expect(
        stored.map((g) => g.join(',')).toSet(),
        rebuilt.map((g) => g.join(',')).toSet(),
      );
    });
  });
  group('Zanzibar', () {
    const def = Campaigns.zanzibar;
    // Its world: Chad out, Zanzibar in (what forCareer gives the run).
    final world = campaignWorld(def, nations);

    test('seed 213 keeps Zanzibar from hosting either championship in all '
        '25 cycles of its century', () {
      expect(def.rngSeed, 213);
      expect(def.cycles, 25);
      for (var cycle = 0; cycle < def.cycles; cycle++) {
        final world0 = WorldCupHosts.hostsFor(
          year: CareerService.worldCupYear(cycle),
          nations: world,
          seed: def.rngSeed,
        );
        final africa = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.africa,
          cycle: cycle,
          seed: def.rngSeed,
          nations: world,
        );
        expect(world0, isNot(contains(213)), reason: 'cycle $cycle');
        expect(africa, isNot(contains(213)), reason: 'cycle $cycle');
      }
    });

    test('seed 213 draws Zanzibar into a full African qualifying group', () {
      final mine = qualifyingGroups(
        def.rngSeed,
        world,
        Confederation.africa,
      ).where((g) => g.contains(213)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 6);
      expect(mine.single, isNot(contains(110)));
    });

    test('a real Zanzibar run stores that draw', () async {
      SharedPreferences.setMockInitialValues({});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: def.nationId,
                    managerName: 'M',
                    rngSeed: def.rngSeed,
                    currentHostRules: true,
                    newCareerNations: def.withBelarus,
                    worldMarkers: [DormantNations.markerFor(213)],
                  ))
              .valueOrNull!;
      final tables = await c
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            career.id,
            CompetitionKind.continentalQualifying,
            confederation: Confederation.africa,
          );
      final stored = [
        for (final t in tables)
          [for (final s in t.standings) s.nationId]..sort(),
      ];
      final rebuilt = [
        for (final g in qualifyingGroups(
          def.rngSeed,
          world,
          Confederation.africa,
        ))
          [...g]..sort(),
      ];
      expect(
        stored.map((g) => g.join(',')).toSet(),
        rebuilt.map((g) => g.join(',')).toSet(),
      );
      expect(stored.where((g) => g.contains(213)), hasLength(1));
    });
  });

  group('Isle of Man', () {
    const def = Campaigns.isleOfMan;
    final world = campaignWorld(def, nations);

    test('seed 214 keeps Isle of Man from hosting either championship in all '
        '25 cycles of its run', () {
      expect(def.rngSeed, 214);
      expect(def.cycles, 25);
      for (var cycle = 0; cycle < def.cycles; cycle++) {
        final world0 = WorldCupHosts.hostsFor(
          year: CareerService.worldCupYear(cycle),
          nations: world,
          seed: def.rngSeed,
        );
        final euro = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: def.rngSeed,
          nations: world,
        );
        expect(world0, isNot(contains(214)), reason: 'cycle $cycle');
        expect(euro, isNot(contains(214)), reason: 'cycle $cycle');
      }
    });

    test('seed 214 draws the Isle of Man into a European qualifying group '
        'of five, whatever the first Nations Cup, Andorra nowhere', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(214)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 5);
      expect(inBottomPotOfFive(def.rngSeed, world, 214), isTrue);
      expect(world.map((n) => n.id), isNot(contains(2)));
      // Europe's real 54: the Nations Cup's bottom league is two groups of
      // three.
      expect(
        world.where((n) => n.confederation == Confederation.europe),
        hasLength(54),
      );
    });
  });

  group('Czechoslovakia', () {
    const def = Campaigns.czechoslovakia;
    final world = campaignWorld(def, nations);

    test(
      'seed 215 keeps Czechoslovakia from hosting either championship in all '
      '4 cycles of its run',
      () {
        expect(def.rngSeed, 215);
        expect(def.cycles, 4);
        for (var cycle = 0; cycle < def.cycles; cycle++) {
          final world0 = WorldCupHosts.hostsFor(
            year: CareerService.worldCupYear(cycle),
            nations: world,
            seed: def.rngSeed,
          );
          final euro = WorldCupHosts.continentalHostsFor(
            confederation: Confederation.europe,
            cycle: cycle,
            seed: def.rngSeed,
            nations: world,
          );
          expect(world0, isNot(contains(215)), reason: 'cycle $cycle');
          expect(euro, isNot(contains(215)), reason: 'cycle $cycle');
        }
      },
    );

    test('its world has neither Czechia nor Slovakia, and one European '
        'nation fewer', () {
      expect(world.map((n) => n.id), isNot(contains(12)));
      expect(world.map((n) => n.id), isNot(contains(48)));
      // One fewer than the run's world before the merge: Belarus joins, two
      // become one, so Europe has 53.
      expect(world, hasLength(nations.length));
      expect(
        world.where((n) => n.confederation == Confederation.europe),
        hasLength(53),
      );
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(215)).toList();
      expect(mine, hasLength(1));
    });
  });

  group('Texas', () {
    const def = Campaigns.texas;
    // Its world: Anguilla out, Texas in (what forCareer gives the run), and
    // no Belarus: a North American scenario.
    final world = campaignWorld(def, nations);

    test('seed 221 keeps Texas from hosting either championship in all '
        'five cycles of its run', () {
      expect(def.rngSeed, 221);
      expect(def.cycles, 5);
      expect(def.withBelarus, isFalse);
      for (var cycle = 0; cycle < def.cycles; cycle++) {
        final world0 = WorldCupHosts.hostsFor(
          year: CareerService.worldCupYear(cycle),
          nations: world,
          seed: def.rngSeed,
        );
        final northAmerica = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.northAmerica,
          cycle: cycle,
          seed: def.rngSeed,
          nations: world,
        );
        expect(world0, isNot(contains(216)), reason: 'cycle $cycle');
        expect(northAmerica, isNot(contains(216)), reason: 'cycle $cycle');
      }
    });

    test('seed 221 draws Texas, a top seed, into a North American '
        'qualifying group it heads, Anguilla nowhere', () {
      final mine = qualifyingGroups(
        def.rngSeed,
        world,
        Confederation.northAmerica,
      ).where((g) => g.contains(216)).toList();
      expect(mine, hasLength(1));
      // It heads its group: every other side in it is ranked below it.
      final rank = {for (final n in world) n.id: n.ranking};
      for (final other in mine.single.where((id) => id != 216)) {
        expect(rank[other]!, greaterThan(rank[216]!), reason: 'nation $other');
      }
      expect(mine.single, isNot(contains(99)));
      expect(world.map((n) => n.id), isNot(contains(66)));
      // A swap: North America keeps its 35.
      expect(
        world.where((n) => n.confederation == Confederation.northAmerica),
        hasLength(35),
      );
    });

    test('a real Texas run stores that draw', () async {
      SharedPreferences.setMockInitialValues({});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: def.nationId,
                    managerName: 'M',
                    rngSeed: def.rngSeed,
                    currentHostRules: true,
                    worldMarkers: [DormantNations.markerFor(216)],
                  ))
              .valueOrNull!;
      final tables = await c
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            career.id,
            CompetitionKind.continentalQualifying,
            confederation: Confederation.northAmerica,
          );
      final stored = [
        for (final t in tables)
          [for (final s in t.standings) s.nationId]..sort(),
      ];
      final rebuilt = [
        for (final g in qualifyingGroups(
          def.rngSeed,
          world,
          Confederation.northAmerica,
        ))
          [...g]..sort(),
      ];
      expect(
        stored.map((g) => g.join(',')).toSet(),
        rebuilt.map((g) => g.join(',')).toSet(),
      );
      expect(stored.where((g) => g.contains(216)), hasLength(1));
    });
  });

  group('Vatican City', () {
    const def = Campaigns.vatican;
    // Its world: San Marino out, Vatican City in, Belarus in (a European
    // run).
    final world = campaignWorld(def, nations);

    test('seed 217 keeps Vatican City from hosting either championship in '
        'any of the fifty cycles of its run', () {
      expect(def.rngSeed, 217);
      expect(def.cycles, 50);
      expect(def.withBelarus, isTrue);
      for (var cycle = 0; cycle < def.cycles; cycle++) {
        final world0 = WorldCupHosts.hostsFor(
          year: CareerService.worldCupYear(cycle),
          nations: world,
          seed: def.rngSeed,
        );
        final euro = WorldCupHosts.continentalHostsFor(
          confederation: Confederation.europe,
          cycle: cycle,
          seed: def.rngSeed,
          nations: world,
        );
        expect(world0, isNot(contains(217)), reason: 'cycle $cycle');
        expect(euro, isNot(contains(217)), reason: 'cycle $cycle');
      }
    });

    test('seed 217 draws Vatican City into a European qualifying group of '
        'five, whatever the first Nations Cup, San Marino nowhere', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(217)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 5);
      expect(inBottomPotOfFive(def.rngSeed, world, 217), isTrue);
      expect(world.map((n) => n.id), isNot(contains(45)));
      // A swap, with Belarus: Europe's 54.
      expect(
        world.where((n) => n.confederation == Confederation.europe),
        hasLength(54),
      );
    });

    test('a real Vatican City run stores that draw', () async {
      SharedPreferences.setMockInitialValues({});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: def.nationId,
                    managerName: 'M',
                    rngSeed: def.rngSeed,
                    currentHostRules: true,
                    worldMarkers: [DormantNations.markerFor(217)],
                    newCareerNations: def.withBelarus,
                  ))
              .valueOrNull!;
      await drawEuroQualifyingNow(c, career.id);
      final tables = await c
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            career.id,
            CompetitionKind.continentalQualifying,
            confederation: Confederation.europe,
          );
      final stored = [
        for (final t in tables)
          [for (final s in t.standings) s.nationId]..sort(),
      ];
      final rebuilt = [
        for (final g in euroQualifyingGroups(def.rngSeed, world))
          [...g]..sort(),
      ];
      expect(
        stored.map((g) => g.join(',')).toSet(),
        rebuilt.map((g) => g.join(',')).toSet(),
      );
      expect(stored.where((g) => g.contains(217)), hasLength(1));
    });
  });
}
