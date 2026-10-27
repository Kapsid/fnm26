import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

final List<({int id, String name, Confederation conf})> _nations = [
  for (final n
      in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List)
          .cast<Map<String, Object?>>())
    (
      id: n['id']! as int,
      name: n['name']! as String,
      conf: Confederation.values.byName(n['confederation']! as String),
    ),
];

List<Venue> _seed(int nationId) => VenueGenerator.forHost(
  hostId: nationId,
  cities: _cities[nationId],
  count: 16,
);

/// [nationId]'s national set with no works, as every career starts it.
List<NationalStadium> _estate(int nationId) => NationalStadiums.openIn(
  NationalStadiums.nationalSet(
    NationalStadiums.forNation(
      nationId: nationId,
      seed: _seed(nationId),
      works: const [],
    ),
  ),
  0,
);

void main() {
  group('level is capacity', () {
    test('the bands: 15k, 25k, 40k and 60k are the steps', () {
      expect(StadiumLevels.levelOf(3300), 1);
      expect(StadiumLevels.levelOf(14999), 1);
      expect(StadiumLevels.levelOf(15000), 2);
      expect(StadiumLevels.levelOf(24999), 2);
      expect(StadiumLevels.levelOf(25000), 3);
      expect(StadiumLevels.levelOf(39999), 3);
      expect(StadiumLevels.levelOf(40000), 4);
      expect(StadiumLevels.levelOf(59999), 4);
      expect(StadiumLevels.levelOf(60000), 5);
      expect(StadiumLevels.levelOf(90000), 5);
    });

    test('seed grounds show the level their real capacity earns', () {
      // England's national bowl (90,000) is level 5, Andorra's (3,300) 1.
      expect(_estate(14).first.capacity, 90000);
      expect(_estate(14).first.level, 5);
      expect(_estate(2).first.level, 1);
      for (final n in _nations) {
        for (final s in _estate(n.id)) {
          expect(s.level, StadiumLevels.levelOf(s.capacity));
        }
      }
    });

    test('an enlargement lands inside the next band, a downsize the one '
        'below', () {
      for (var seats = 1000; seats < 100000; seats += 700) {
        final level = StadiumLevels.levelOf(seats);
        final up = StadiumLevels.enlargedTo(seats);
        final down = StadiumLevels.downsizedTo(seats);
        if (level == 5) {
          expect(up, isNull);
        } else {
          expect(StadiumLevels.levelOf(up!), level + 1, reason: '$seats');
          expect(up, greaterThan(seats));
        }
        if (level == 1) {
          expect(down, isNull);
        } else {
          expect(StadiumLevels.levelOf(down!), level - 1, reason: '$seats');
          expect(down, lessThan(seats));
        }
      }
    });

    test('the cost scales with the seats added, in whole millions', () {
      // 39,000 to 48,000 (level 4): 9,000 seats, €5M x 2.0. 26,000 to
      // 48,000: 22,000 seats, €8M x 2.0. 59,000 to 64,000 (level 5): €4M
      // x 2.8, rounded up. 3,000 to 20,000 (level 2): €7M x 1.0.
      expect(NationalStadiums.enlargeCost(39000), 10000000);
      expect(NationalStadiums.enlargeCost(26000), 16000000);
      expect(NationalStadiums.enlargeCost(59000), 12000000);
      expect(NationalStadiums.enlargeCost(3000), 7000000);
      expect(NationalStadiums.enlargeCost(70000), isNull);
      for (var seats = 1000; seats < 60000; seats += 900) {
        final cost = NationalStadiums.enlargeCost(seats)!;
        expect(cost % FederationFinance.investLevelPrice, 0);
        expect(
          cost,
          greaterThanOrEqualTo(
            NationalStadiums.enlargeCost(seats + 100) ?? cost,
          ),
        );
      }
      expect(NationalStadiums.downsizeRefund, 0);
    });

    test('each step up costs more the higher the level it reaches', () {
      // The owner's call: x1.0 into level 2, x1.4 into 3, x2.0 into 4, x2.8
      // into 5, on top of the seats-added price.
      expect(NationalStadiums.levelCostTenths, [10, 10, 14, 20, 28]);
      // One ground at each level's standard size, enlarged a step: the same
      // 12,000 or 16,000 seats added each time, dearer each time.
      expect(NationalStadiums.enlargeCost(10000), 5000000); // into level 2
      expect(NationalStadiums.enlargeCost(20000), 7000000); // into level 3
      expect(NationalStadiums.enlargeCost(32000), 12000000); // into level 4
      expect(NationalStadiums.enlargeCost(48000), 17000000); // into level 5
      // Level 1 to level 5 a step at a time: €41M (it was €22M).
      var seats = 10000;
      var total = 0;
      for (
        var cost = NationalStadiums.enlargeCost(seats);
        cost != null;
        cost = NationalStadiums.enlargeCost(seats)
      ) {
        total += cost;
        seats = StadiumLevels.enlargedTo(seats)!;
      }
      expect(total, 41000000);
      expect(StadiumLevels.levelOf(seats), StadiumLevels.maxLevel);
      // A ground at each level's standard size costs more to enlarge than
      // one at the standard size a level below.
      for (var level = 2; level < StadiumLevels.maxLevel; level++) {
        final from = StadiumLevels.standard[level - 2];
        final next = StadiumLevels.standard[level - 1];
        expect(
          NationalStadiums.enlargeCost(next),
          greaterThan(NationalStadiums.enlargeCost(from)!),
          reason: 'into level ${level + 1} vs into level $level',
        );
      }
    });

    test('a new stadium is quite expensive and sized by the nation', () {
      expect(NationalStadiums.newCapacity(2), 8000);
      expect(NationalStadiums.buildCost(2), 22000000);
      expect(NationalStadiums.newCapacity(20), 73000);
      expect(NationalStadiums.buildCost(20), 38000000);
      for (final id in [2, 12, 14, 20, 182, 212]) {
        expect(
          NationalStadiums.buildCost(id) % FederationFinance.investLevelPrice,
          0,
        );
      }
    });
  });

  group('income', () {
    test('every ground earns, small and from its seats', () {
      // Top nation: the whole estate is 5-10% of its grant (a top-of-the-
      // world standing pays up to centralGrant x 1.35, about €16M).
      const topGrant =
          FederationFinance.centralGrant *
          (1 + FederationFinance.maxStandingBonus);
      final rows = <String>[];
      for (final id in [14, 20, 50, 58, 4, 13, 12, 182, 2]) {
        final estate = _estate(id);
        final total = NationalStadiums.incomeOf(estate, id);
        final best = NationalStadiums.groundIncome(
          seats: estate.first.capacity,
          nationId: id,
        );
        final name = _nations.firstWhere((n) => n.id == id).name;
        rows.add(
          '$name: ${estate.length} grounds, top ${estate.first.capacity} '
          '(L${estate.first.level}) earns $best, estate $total, '
          '${(total / topGrant * 100).toStringAsFixed(1)}% of €16.2M',
        );
        // A few hundred thousand per ground at most.
        for (final s in estate) {
          final g = NationalStadiums.groundIncome(
            seats: s.capacity,
            nationId: id,
          );
          expect(g, greaterThan(0), reason: '$name ${s.city}');
          expect(
            g,
            lessThanOrEqualTo(NationalStadiums.maxGroundIncome),
            reason: '$name ${s.city}',
          );
        }
      }
      // ignore: avoid_print
      print(rows.join('\n'));
      for (final id in [14, 20, 50]) {
        final total = NationalStadiums.incomeOf(_estate(id), id);
        expect(total, greaterThan(topGrant * 0.05), reason: '$id');
        // The cap holds the whole to a tenth of the grant.
        expect(
          NationalStadiums.cappedToGrant(total, topGrant.round()),
          lessThanOrEqualTo(topGrant * 0.10),
          reason: '$id',
        );
      }
      expect(NationalStadiums.cappedToGrant(1717000, 16200000), 1620000);
      expect(NationalStadiums.cappedToGrant(500000, 16200000), 500000);
      // A microstate's estate earns tens of thousands.
      expect(NationalStadiums.incomeOf(_estate(2), 2), lessThan(60000));
    });

    test('enlarging a ground the crowds fill pays more', () {
      final estate = _estate(20);
      final s = estate.firstWhere((g) => g.level < 5);
      final up = StadiumLevels.enlargedTo(s.capacity)!;
      expect(
        NationalStadiums.groundIncome(seats: up, nationId: 20),
        greaterThan(
          NationalStadiums.groundIncome(seats: s.capacity, nationId: 20),
        ),
      );
    });

    test('a white elephant costs its keep; downsizing it pays again', () {
      // Andorra's ground blown up to level 3: more seats than the nation
      // can fill, so the upkeep eats the takings.
      const huge = 32000;
      final atHuge = NationalStadiums.groundIncome(seats: huge, nationId: 2);
      final down = StadiumLevels.downsizedTo(huge)!;
      final atDown = NationalStadiums.groundIncome(seats: down, nationId: 2);
      expect(atHuge, 0);
      expect(atDown, greaterThanOrEqualTo(atHuge));
      final back = NationalStadiums.groundIncome(
        seats: StadiumLevels.downsizedTo(down)!,
        nationId: 2,
      );
      expect(back, greaterThan(0));
    });

    test('reputation: a point an enlargement, two a stadium, none a '
        'downsize, at most six', () {
      const works = [
        StadiumWork.resize(
          nationId: 12,
          cycle: 0,
          stadium: (city: 'Prague', built: false),
          seats: 32000,
          enlarge: true,
        ),
        StadiumWork.resize(
          nationId: 12,
          cycle: 1,
          stadium: (city: 'Brno', built: false),
          seats: 10000,
          enlarge: false,
        ),
        StadiumWork.build(nationId: 12, cycle: 1, city: 'Ostrava'),
      ];
      expect(NationalStadiums.points(works), 3);
      expect(NationalStadiums.reputationPoints(works, 1), 1);
      expect(NationalStadiums.reputationPoints(works, 2), 3);
      expect(
        NationalStadiums.reputationFor(20),
        NationalStadiums.maxReputation,
      );
    });
  });

  group('who may bid', () {
    int countFor(Confederation conf, HostingRequirement req) => _nations
        .where(
          (n) =>
              n.conf == conf &&
              HostingRequirements.meets([
                for (final s in _estate(n.id)) s.capacity,
              ], req),
        )
        .length;

    test('World Championship: 6 grounds, 3 of 30,000+; top nations only', () {
      final counts = {
        for (final c in Confederation.values)
          c: countFor(c, HostingRequirements.worldChampionship),
      };
      // ignore: avoid_print
      print('WC eligible at start: $counts');
      expect(counts, {
        Confederation.europe: 14,
        Confederation.southAmerica: 8,
        Confederation.northAmerica: 3,
        Confederation.africa: 9,
        Confederation.asia: 14,
        Confederation.oceania: 1,
      });
      final ok = HostingRequirements.worldChampionship;
      bool may(int id) => HostingRequirements.meets([
        for (final s in _estate(id)) s.capacity,
      ], ok);
      expect(may(14), isTrue); // England
      expect(may(20), isTrue); // Germany
      expect(may(12), isFalse); // Czechia
      expect(may(2), isFalse); // Andorra
    });

    test('continental: scaled to each finals', () {
      final counts = {
        for (final c in Confederation.values)
          c: countFor(c, HostingRequirements.continental(c)),
      };
      // ignore: avoid_print
      print('Continental eligible at start: $counts');
      expect(counts, {
        Confederation.europe: 20,
        Confederation.southAmerica: 10,
        Confederation.northAmerica: 7,
        Confederation.africa: 15,
        Confederation.asia: 19,
        Confederation.oceania: 5,
      });
    });

    test('the shortfall says exactly what is missing', () {
      const req = HostingRequirements.worldChampionship;
      expect(
        HostingRequirements.shortfall([60000, 25000, 20000], req),
        (grounds: 3, bigGrounds: 2),
      );
      expect(
        HostingRequirements.shortfall(
          [90000, 80000, 70000, 60000, 30000, 20000, 18000, 16000],
          req,
        ),
        (grounds: 0, bigGrounds: 0),
      );
    });

    test('an enlargement can make a nation eligible', () {
      // Czechia's grounds lack big ones; enlarge its three biggest twice.
      final seats = [for (final s in _estate(12)) s.capacity];
      const req = HostingRequirements.worldChampionship;
      final before = HostingRequirements.shortfall(seats, req);
      expect(before.bigGrounds, greaterThan(0));
      final after = [...seats];
      for (var i = 0; i < 4; i++) {
        after[i] = StadiumLevels.enlargedTo(after[i])!;
        after[i] = StadiumLevels.enlargedTo(after[i]) ?? after[i];
        after[i] = StadiumLevels.enlargedTo(after[i]) ?? after[i];
      }
      expect(
        HostingRequirements.shortfall(after, req).bigGrounds,
        lessThan(before.bigGrounds),
      );
    });
  });

  group('markers', () {
    test('round-trip, a colon in a city included', () {
      const works = [
        StadiumWork.resize(
          nationId: 12,
          cycle: 3,
          stadium: (city: 'Prague', built: false),
          seats: 32000,
          enlarge: true,
        ),
        StadiumWork.resize(
          nationId: 12,
          cycle: 4,
          stadium: (city: 'Odd:Town', built: true),
          seats: 20000,
          enlarge: false,
        ),
        StadiumWork.build(nationId: 12, cycle: 2, city: 'Brno'),
        StadiumWork.legacyUpgrade(
          nationId: 12,
          cycle: 1,
          stadium: (city: 'Ostrava', built: false),
          level: 2,
        ),
      ];
      for (final w in works) {
        final back = StadiumWork.decode(w.encode())!;
        expect(back.encode(), w.encode());
        expect(back.stadium, w.stadium);
        expect(back.capacity, w.capacity);
        expect(back.up, w.up);
        expect(back.isBuild, w.isBuild);
        expect(back.isLegacy, w.isLegacy);
        expect(back.cycle, w.cycle);
      }
    });

    test('an old +10% upgrade marker still reads at what it paid for', () {
      final w = StadiumWork.decode('stadiumUp:12:0:2:s:Prague')!;
      expect(w.isLegacy, isTrue);
      final seed = _seed(12);
      final prague = seed.firstWhere((v) => v.city == 'Prague');
      final all = NationalStadiums.forNation(
        nationId: 12,
        seed: seed,
        works: [w],
      );
      final s = all.firstWhere((s) => s.city == 'Prague');
      expect(
        s.capacity,
        NationalStadiums.legacyCapacityAt(prague.capacity, 2),
      );
      expect(s.upgrades, 2);
    });

    test('other markers are not works', () {
      for (final k in [
        'stadiumIncome:1:500000',
        'stadiumUp:x',
        'stadiumSize:1:2:x:u:s:A',
        'stadiumSize:1:2:3000:q:s:A',
        'stadiumBuild:1',
        'hostBid:cont:1:12:3:250',
        'budgetSet',
      ]) {
        expect(StadiumWork.decode(k), isNull, reason: k);
      }
    });
  });

  group('a nation in a career', () {
    test('no works: exactly the static grounds, for every nation', () {
      for (final id in _cities.keys) {
        final seed = _seed(id);
        final open = NationalStadiums.openIn(
          NationalStadiums.forNation(nationId: id, seed: seed, works: const []),
          0,
        );
        expect([for (final s in open) s.venue], seed, reason: 'nation $id');
      }
    });

    test('resizes apply in order and move the host-bid size score', () {
      final seed = _seed(12);
      final before = HostBidOdds.sizeScore(seed);
      final city = seed.first.city;
      final first = StadiumLevels.enlargedTo(seed.first.capacity)!;
      final second = StadiumLevels.enlargedTo(first)!;
      final works = [
        StadiumWork.resize(
          nationId: 12,
          cycle: 2,
          stadium: (city: city, built: false),
          seats: second,
          enlarge: true,
        ),
        StadiumWork.resize(
          nationId: 12,
          cycle: 1,
          stadium: (city: city, built: false),
          seats: first,
          enlarge: true,
        ),
        // Another nation's work changes nothing here.
        StadiumWork.resize(
          nationId: 14,
          cycle: 0,
          stadium: (city: seed[1].city, built: false),
          seats: 64000,
          enlarge: true,
        ),
      ];
      final open = NationalStadiums.openIn(
        NationalStadiums.forNation(nationId: 12, seed: seed, works: works),
        3,
      );
      expect(open.first.capacity, second);
      expect(open.first.upgrades, 2);
      expect(open[1].capacity, seed[1].capacity);
      expect(
        HostBidOdds.sizeScore([for (final s in open) s.venue]),
        greaterThan(before),
      );
    });

    test('a new stadium opens the cycle after it is paid for', () {
      final seed = _seed(12);
      const build = StadiumWork.build(nationId: 12, cycle: 2, city: 'Brno');
      final all = NationalStadiums.forNation(
        nationId: 12,
        seed: seed,
        works: const [build],
      );
      expect(all.where((s) => s.built), hasLength(1));
      expect(NationalStadiums.openIn(all, 2).any((s) => s.built), isFalse);
      final open = NationalStadiums.openIn(all, 3);
      final built = open.singleWhere((s) => s.built);
      expect(built.capacity, NationalStadiums.newCapacity(12));
      expect(built.name, NationalStadiums.newStadiumName('Brno'));
      for (var i = 1; i < open.length; i++) {
        expect(open[i].capacity, lessThanOrEqualTo(open[i - 1].capacity));
      }
    });
  });

  group("a built stadium's own name", () {
    test('round-trips through its marker in any script, colons included', () {
      for (final name in const [
        'Arena: Ünité',
        '国立競技場',
        'สนามราชมังคลา',
        'Стадион Победа',
        'स्टेडियम',
      ]) {
        final n = StadiumName(
          nationId: 12,
          seq: 3,
          city: 'Brno: Old Town',
          name: name,
        );
        final back = StadiumName.decode(n.encode())!;
        expect(back.nationId, 12);
        expect(back.seq, 3);
        expect(back.city, 'Brno: Old Town');
        expect(back.name, name);
      }
      // Not a name marker, or a broken one: nothing.
      expect(StadiumName.decode('stadiumBuild:12:0:Brno'), isNull);
      expect(StadiumName.decode('stadiumName:12:x:Brno:A'), isNull);
      expect(StadiumName.decode('stadiumName:12:1:Brno:'), isNull);
      expect(StadiumName.decode('stadiumName:12:1:%E0%A4:A'), isNull);
      // And a name marker is never read as a work.
      expect(
        StadiumWork.decode(
          const StadiumName(nationId: 1, seq: 1, city: 'A', name: 'B').encode(),
        ),
        isNull,
      );
    });

    test(
      'is cleaned: trimmed, one line, held to its length, blank is none',
      () {
        expect(StadiumName.clean('  Estadio \n  Ñandú\t '), 'Estadio Ñandú');
        expect(StadiumName.clean('   '), isNull);
        expect(StadiumName.clean(''), isNull);
        final long = StadiumName.clean('x' * 200)!;
        expect(long.runes, hasLength(StadiumName.maxRunes));
        // Whatever the field allows (32 visible characters) is kept whole.
        const thai = 'สนามกีฬาแห่งชาติราชมังคลากีฬาสถาน';
        expect(StadiumName.clean(thai), thai);
      },
    );

    test('the latest of several renames stands; a nation without one shows '
        'the generated name, and seed grounds keep theirs', () {
      final seed = _seed(12);
      const works = [
        StadiumWork.build(nationId: 12, cycle: 0, city: 'Brno'),
        StadiumWork.build(nationId: 12, cycle: 1, city: 'Zlin'),
      ];
      const names = [
        StadiumName(nationId: 12, seq: 1, city: 'Brno', name: 'First'),
        StadiumName(nationId: 12, seq: 3, city: 'Brno', name: 'Third'),
        StadiumName(nationId: 12, seq: 2, city: 'Brno', name: 'Second'),
        // Another nation's, and a seed city's: never read here.
        StadiumName(nationId: 13, seq: 9, city: 'Zlin', name: 'Elsewhere'),
        StadiumName(nationId: 12, seq: 1, city: 'Nowhere', name: 'Ghost'),
      ];
      final all = NationalStadiums.forNation(
        nationId: 12,
        seed: seed,
        works: works,
        names: names,
      );
      final built = {for (final s in all.where((s) => s.built)) s.city: s};
      expect(built['Brno']!.name, 'Third');
      expect(built['Brno']!.venue.stadium, 'Third');
      expect(built['Zlin']!.name, NationalStadiums.newStadiumName('Zlin'));
      final plain = NationalStadiums.forNation(
        nationId: 12,
        seed: seed,
        works: works,
      );
      expect(
        [for (final s in all.where((s) => !s.built)) s.name],
        [for (final s in plain.where((s) => !s.built)) s.name],
      );
      expect(
        [for (final s in plain.where((s) => s.built)) s.name],
        [
          NationalStadiums.newStadiumName('Brno'),
          NationalStadiums.newStadiumName('Zlin'),
        ],
      );
    });
  });
}
