import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
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

/// The European qualifying draw of cycle 0 for [seed], rebuilt exactly as
/// `CareerService.buildCalendar` does it (the fourth test pins it to the real
/// thing, so a change there breaks this helper loudly).
List<List<int>> euroQualifyingGroups(int seed, List<Nation> nations) =>
    qualifyingGroups(seed, nations, Confederation.europe);

/// [euroQualifyingGroups] for any qualifying confederation.
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
/// the run's nation.
List<Nation> campaignWorld(CampaignDef def, List<Nation> nations) => [
  for (final n in DormantNations.worldFrom(
    nations,
    {
      if (def.withBelarus) DormantNations.belarusId,
      ?def.dormantNationId,
    },
    dormant: (id) => DormantNations.all.firstWhere((n) => n.id == id),
  ))
    if (n.id == def.nationId)
      n.copyWith(
        hostBids: {
          ...n.hostBids,
          for (var c = 0; c < def.cycles + 1; c++) ...{
            HostBidding.managerKey(c): 1,
            HostBidding.rules2Key(c): 1,
            HostBidding.rules3Key(c): 1,
          },
        },
      )
    else
      n,
];

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

  test('Grudge draws Georgia and Albania into the same qualifying group', () {
    final groups = euroQualifyingGroups(
      Campaigns.grudge.rngSeed,
      campaignWorld(Campaigns.grudge, nations),
    );
    expect(groups.where((g) => g.contains(19) && g.contains(1)), hasLength(1));
  });

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
    // A Grudge run's world: Belarus in (the dormant source supplies it).
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
        Campaigns.grudge.rngSeed,
        campaignWorld(Campaigns.grudge, nations),
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

    test('seed 212 draws Greenland into a European qualifying group of five '
        'or more', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(212)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, greaterThanOrEqualTo(5));
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
        'of six, Andorra nowhere', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(214)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 6);
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
        'six, San Marino nowhere', () {
      final mine = euroQualifyingGroups(
        def.rngSeed,
        world,
      ).where((g) => g.contains(217)).toList();
      expect(mine, hasLength(1));
      expect(mine.single.length, 6);
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
