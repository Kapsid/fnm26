import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_stadium_rules.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

Nation _code(String code) => _nations.firstWhere((n) => n.code == code);

/// The nations of [conf] (all of them for null) whose seed grounds reach the
/// bar alone, as sorted codes.
List<String> _soloEligible(
  HostBar Function(Confederation) bar, [
  Confederation? conf,
]) {
  final out = <String>[
    for (final n in _nations)
      if (conf == null || n.confederation == conf)
        if (HostStadiumRules.meets(
          HostStadiumRules.qualifyingSeats(nationId: n.id, editionCycle: 0),
          bar(n.confederation),
        ))
          n.code,
  ]..sort();
  return out;
}

Nation _n(int id, String code, Confederation c, int ranking) =>
    Nation(id: id, name: code, code: code, confederation: c, ranking: ranking);

void main() {
  group('bars', () {
    test('values are the spec table, picked per confederation', () {
      expect(HostStadiumRules.worldChampionship, (
        grounds: 10,
        finalSeats: 60000,
        semiGrounds: 2,
        semiSeats: 40000,
        otherSeats: 30000,
      ));
      expect(HostStadiumRules.continental(Confederation.europe), (
        grounds: 8,
        finalSeats: 50000,
        semiGrounds: 2,
        semiSeats: 35000,
        otherSeats: 25000,
      ));
      for (final c in [
        Confederation.africa,
        Confederation.asia,
        Confederation.northAmerica,
      ]) {
        expect(HostStadiumRules.continental(c), (
          grounds: 6,
          finalSeats: 40000,
          semiGrounds: 1,
          semiSeats: 30000,
          otherSeats: 20000,
        ));
      }
      expect(HostStadiumRules.continental(Confederation.southAmerica), (
        grounds: 5,
        finalSeats: 40000,
        semiGrounds: 1,
        semiSeats: 30000,
        otherSeats: 20000,
      ));
      expect(HostStadiumRules.continental(Confederation.oceania), (
        grounds: 2,
        finalSeats: 10000,
        semiGrounds: 0,
        semiSeats: 0,
        otherSeats: 5000,
      ));
      expect(
        HostStadiumRules.of(HostBidComp.worldChampionship, Confederation.asia),
        HostStadiumRules.worldChampionship,
      );
      expect(
        HostStadiumRules.of(HostBidComp.continental, Confederation.oceania),
        HostStadiumRules.continental(Confederation.oceania),
      );
    });

    test('shortfall: biggest is the final, the next ones the semis', () {
      const bar = (
        grounds: 6,
        finalSeats: 40000,
        semiGrounds: 1,
        semiSeats: 30000,
        otherSeats: 20000,
      );
      expect(HostStadiumRules.shortfall(const [], bar), (
        grounds: 6,
        finalGround: true,
        semiGrounds: 1,
      ));
      // Unsorted input: 45k is the final, 32k the semi.
      expect(
        HostStadiumRules.shortfall(const [21000, 45000, 20000, 32000], bar),
        (grounds: 2, finalGround: false, semiGrounds: 0),
      );
      // Two big grounds but the second is too small for a semi.
      expect(
        HostStadiumRules.shortfall(const [39000, 29000, 19000], bar),
        (grounds: 4, finalGround: true, semiGrounds: 1),
      );
      expect(
        HostStadiumRules.meets(
          const [45000, 32000, 25000, 25000, 20000, 20000],
          bar,
        ),
        isTrue,
      );
    });
  });

  group('solo-eligible in the seed data (spec section 6 column)', () {
    test('World Championship hosts are ENG ESP GER FRA ITA TUR ARG BRA USA '
        'RSA CHN JPN KOR', () {
      final got = _soloEligible((_) => HostStadiumRules.worldChampionship);
      expect(
        got,
        ([
          'ENG', 'ESP', 'GER', 'FRA', 'ITA', 'TUR', 'ARG', 'BRA', 'USA', //
          'RSA', 'CHN', 'JPN', 'KOR',
        ]..sort()),
        reason:
            'spec: 13 (ENG ESP GER FRA ITA TUR, ARG BRA, USA, RSA, CHN '
            'JPN KOR)',
      );
    });

    test('EURO solo-eligible count is 7', () {
      final got = _soloEligible(
        HostStadiumRules.continental,
        Confederation.europe,
      );
      expect(got, hasLength(7), reason: 'spec: 7 European; data: $got');
    });

    test('AFCON 9, Asian Cup 14', () {
      final africa = _soloEligible(
        HostStadiumRules.continental,
        Confederation.africa,
      );
      final asia = _soloEligible(
        HostStadiumRules.continental,
        Confederation.asia,
      );
      expect(africa, hasLength(9), reason: 'spec: 9 African; data: $africa');
      expect(asia, hasLength(14), reason: 'spec: 14 Asian; data: $asia');
    });

    test('Gold Cup USA MEX CAN', () {
      expect(
        _soloEligible(
          HostStadiumRules.continental,
          Confederation.northAmerica,
        ),
        ['CAN', 'MEX', 'USA'],
        reason: 'spec: USA, MEX, CAN',
      );
    });

    test('Copa 9 of 10', () {
      final all = _nations
          .where((n) => n.confederation == Confederation.southAmerica)
          .length;
      final got = _soloEligible(
        HostStadiumRules.continental,
        Confederation.southAmerica,
      );
      expect(all, 10);
      expect(got, hasLength(9), reason: 'spec: 9 of 10; data: $got');
    });

    test('Oceania NZL FIJ NCL PNG TAH', () {
      expect(
        _soloEligible(HostStadiumRules.continental, Confederation.oceania),
        ['FIJ', 'NCL', 'NZL', 'PNG', 'TAH'],
        reason: 'spec: NZL FIJ NCL PNG TAH',
      );
    });
  });

  group('qualifying grounds', () {
    test('generated cities never count', () {
      for (final n in _nations) {
        final seed = [
          for (final g in nationalStadiumData[n.id] ?? const <(String, int)>[])
            g.$2,
        ]..sort((a, b) => b.compareTo(a));
        expect(
          HostStadiumRules.qualifyingSeats(nationId: n.id, editionCycle: 0),
          seed,
          reason: n.code,
        );
      }
      // The full venue list a finals reads pads with generated cities; an
      // estate built from it counts only the curated grounds.
      final usa = _code('USA');
      final venues = VenueGenerator.forHost(
        hostId: usa.id,
        cities: _cities[usa.id],
        count: 16,
      );
      final estate = NationalStadiums.forNation(
        nationId: usa.id,
        seed: venues,
        works: const [],
      );
      expect(estate.length, greaterThan(nationalStadiumData[usa.id]!.length));
      expect(
        HostStadiumRules.qualifyingSeats(
          nationId: usa.id,
          editionCycle: 0,
          estate: estate,
        ),
        HostStadiumRules.qualifyingSeats(nationId: usa.id, editionCycle: 0),
      );
      // A made-up city of any size never counts.
      expect(
        HostStadiumRules.qualifyingSeats(
          nationId: usa.id,
          editionCycle: 0,
          estate: [
            ...estate,
            const NationalStadium(
              city: 'Nowhere',
              name: 'X',
              baseCapacity: 99000,
            ),
          ],
        ),
        HostStadiumRules.qualifyingSeats(nationId: usa.id, editionCycle: 0),
      );
    });

    test('an estate ground counts only from the cycle it opens', () {
      final aut = _code('AUT');
      final seedSeats = HostStadiumRules.qualifyingSeats(
        nationId: aut.id,
        editionCycle: 0,
      );
      final estate = NationalStadiums.forNation(
        nationId: aut.id,
        seed: [
          for (final (city, seats) in nationalStadiumData[aut.id]!)
            (city: city, stadium: city, capacity: seats),
        ],
        // Built in cycle 2: opens in cycle 3.
        works: [
          StadiumWork.build(
            nationId: aut.id,
            cycle: 2,
            city: 'Linz',
          ),
        ],
      );
      final built = estate.firstWhere((s) => s.built).capacity;
      expect(
        HostStadiumRules.qualifyingSeats(
          nationId: aut.id,
          editionCycle: 2,
          estate: estate,
        ),
        seedSeats,
      );
      expect(
        HostStadiumRules.qualifyingSeats(
          nationId: aut.id,
          editionCycle: 3,
          estate: estate,
        ),
        [...seedSeats, built]..sort((a, b) => b.compareTo(a)),
      );
    });
  });

  group('joint bids', () {
    final bar = HostStadiumRules.continental(Confederation.europe);
    final nor = _n(1, 'NOR', Confederation.europe, 40);
    final fin = _n(2, 'FIN', Confederation.europe, 41);
    final swe = _n(3, 'SWE', Confederation.europe, 30);
    final den = _n(4, 'DEN', Confederation.europe, 20);
    final pol = _n(5, 'POL', Confederation.europe, 39);
    final bra = _n(6, 'BRA', Confederation.southAmerica, 40);

    test('joint bid prefers the same subregion, caps at 3, needs 2 grounds '
        'per co-host, lists the final-ground holder first', () {
      final seats = {
        nor.id: [40000, 30000, 28000, 26000],
        // Nearest ranked and holding the biggest ground, but one ground only.
        fin.id: [70000, 12000],
        swe.id: [52000, 36000, 30000],
        den.id: [38000, 30000],
        // Closes the gap alone, but outside the subregion.
        pol.id: [60000, 50000, 45000, 40000, 30000],
        bra.id: [90000, 90000, 90000, 90000, 90000],
      };
      expect(HostStadiumRules.meets(seats[nor.id]!, bar), isFalse);
      expect(
        HostStadiumRules.jointBid(
          lead: nor,
          candidates: [nor, fin, swe, den, pol, bra],
          seatsById: seats,
          bar: bar,
        ),
        [swe.id, nor.id, den.id],
      );

      // No neighbour can help: the confederation is next.
      expect(
        HostStadiumRules.jointBid(
          lead: nor,
          candidates: [nor, fin, pol, bra],
          seatsById: seats,
          bar: bar,
        ),
        [pol.id, nor.id],
      );

      // Four would reach the bar, three cannot: no bid.
      final small = {
        nor.id: [30000, 30000],
        swe.id: [30000, 30000],
        den.id: [36000, 30000],
        fin.id: [52000, 36000],
      };
      expect(
        HostStadiumRules.meets([for (final s in small.values) ...s], bar),
        isTrue,
      );
      expect(
        HostStadiumRules.jointBid(
          lead: nor,
          candidates: [nor, swe, den, fin],
          seatsById: small,
          bar: bar,
        ),
        isNull,
      );
    });

    test('a nation that meets the bar alone stands alone', () {
      expect(
        HostStadiumRules.jointBid(
          lead: pol,
          candidates: [nor, swe, pol],
          seatsById: {
            pol.id: [60000, 50000, 45000, 40000, 30000, 30000, 30000, 30000],
          },
          bar: bar,
        ),
        [pol.id],
      );
    });

    test('no bid when no neighbours close the gap', () {
      expect(
        HostStadiumRules.jointBid(
          lead: nor,
          candidates: [nor, swe, den, bra],
          seatsById: {
            nor.id: [40000, 30000],
            swe.id: [30000, 26000],
            den.id: [25000, 25000],
            bra.id: [90000, 90000, 90000, 90000, 90000, 90000],
          },
          bar: bar,
        ),
        isNull,
      );
    });
  });

  group('AI planned grounds', () {
    test('plannedAi only for the top 30 and within the cap', () {
      const wc = HostStadiumRules.worldChampionship;
      const eight = [65000, 45000, 45000, 35000, 35000, 35000, 35000, 35000];
      expect(
        HostStadiumRules.plannedAi(
          worldRank: 10,
          comp: HostBidComp.worldChampionship,
          seats: eight,
          bar: wc,
        ),
        [30000, 30000],
      );
      expect(
        HostStadiumRules.plannedAi(
          worldRank: 30,
          comp: HostBidComp.worldChampionship,
          seats: eight,
          bar: wc,
        ),
        hasLength(2),
      );
      expect(
        HostStadiumRules.plannedAi(
          worldRank: 31,
          comp: HostBidComp.worldChampionship,
          seats: eight,
          bar: wc,
        ),
        isEmpty,
      );
      // Five missing: over the World Championship cap of 4.
      expect(
        HostStadiumRules.plannedAi(
          worldRank: 1,
          comp: HostBidComp.worldChampionship,
          seats: eight.take(5).toList(),
          bar: wc,
        ),
        isEmpty,
      );
      // Continental: the final and a semi ground, sized to their slots.
      final euro = HostStadiumRules.continental(Confederation.europe);
      const six = [40000, 30000, 30000, 30000, 30000, 30000];
      final planned = HostStadiumRules.plannedAi(
        worldRank: 5,
        comp: HostBidComp.continental,
        seats: six,
        bar: euro,
      );
      expect(planned, [50000, 35000]);
      expect(HostStadiumRules.meets([...six, ...planned], euro), isTrue);
      // Three missing: over the continental cap of 2.
      expect(
        HostStadiumRules.plannedAi(
          worldRank: 5,
          comp: HostBidComp.continental,
          seats: six.take(5).toList(),
          bar: euro,
        ),
        isEmpty,
      );
    });
  });

  group('v2 marker', () {
    test('rules2 round-trips and is not a bid or rules marker', () {
      final kind = HostBidding.rules2Kind(5);
      expect(kind, 'hostRules2:5');
      expect(HostBidding.decodeRules2(kind), 5);
      expect(HostBidding.decodeRules2('hostRules:5:3'), isNull);
      expect(HostBidding.decodeRules2('hostRules2:x'), isNull);
      expect(HostBidding.decodeRules(kind), isNull);
      expect(HostBidMarker.decode(kind), isNull);
      expect(HostBidMarker.decodePledge(kind), isNull);
      expect(HostBidding.decodeResult(kind), isNull);

      final key = HostBidding.rules2Key(5);
      expect(key, 'r2:5');
      expect(key.startsWith('mgr:'), isFalse);
      for (final comp in HostBidComp.values) {
        expect(key, isNot(HostBidding.nationKey(comp, 5)));
      }
      expect(HostBidMarker.decode(key), isNull);
      expect(HostBidding.decodeRules(key), isNull);

      final marked = [
        for (final n in _nations)
          if (n.code == 'NOR')
            n.copyWith(hostBids: {HostBidding.managerKey(0): 1, key: 1})
          else
            n,
      ];
      expect(WorldCupHosts.isV2(5, marked), isTrue);
      expect(WorldCupHosts.isV2(4, marked), isFalse);
      expect(WorldCupHosts.isV2(5, _nations), isFalse);

      // The key changes no host draw before its own cycle (that cycle and
      // the ones after are held to the stadium bars: hosts_v2_test).
      final plain = [
        for (final n in _nations)
          if (n.code == 'NOR')
            n.copyWith(hostBids: {HostBidding.managerKey(0): 1})
          else
            n,
      ];
      for (var cycle = 0; cycle < 5; cycle++) {
        expect(
          WorldCupHosts.hostsFor(
            year: 2030 + 4 * cycle,
            nations: marked,
            seed: 77,
          ),
          WorldCupHosts.hostsFor(
            year: 2030 + 4 * cycle,
            nations: plain,
            seed: 77,
          ),
        );
        for (final c in Confederation.values) {
          expect(
            WorldCupHosts.continentalHostsFor(
              confederation: c,
              cycle: cycle,
              seed: 77,
              nations: marked,
            ),
            WorldCupHosts.continentalHostsFor(
              confederation: c,
              cycle: cycle,
              seed: 77,
              nations: plain,
            ),
          );
        }
      }
    });

    test(
      "the nation read carries a rules2 marker on the manager's nation",
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final db = createTestDatabase();
        final c = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            premiumUnlockedProvider.overrideWith((ref) => true),
            seedSourceProvider.overrideWithValue(
              InMemorySeedSource(nationList: _nations, playerList: const []),
            ),
            countryCitiesProvider.overrideWith((ref) async => _cities),
          ],
        );
        addTearDown(c.dispose);
        addTearDown(db.close);
        await c.read(seedLoaderProvider).ensureSeeded();
        final nor = _code('NOR');
        final career =
            (await c
                    .read(careerServiceProvider)
                    .create(nationId: nor.id, managerName: 'M', rngSeed: 3))
                .valueOrNull!;
        final repo = c.read(nationRepositoryProvider);

        // A new save is stamped for cycle 0 at its creation.
        final before = await repo.forCareer(career.id);
        expect(WorldCupHosts.isV2(0, before), isTrue);
        expect(WorldCupHosts.isV2(1, before), isFalse);

        await db
            .into(db.drawsWatched)
            .insert(
              DrawsWatchedCompanion.insert(
                careerId: career.id,
                cycle: 1,
                kind: HostBidding.rules2Kind(1),
              ),
            );
        final after = await repo.forCareer(career.id);
        expect(WorldCupHosts.isV2(1, after), isTrue);
        expect(WorldCupHosts.isV2(2, after), isFalse);
        final carrier = after.firstWhere(
          (n) => n.hostBids.containsKey(HostBidding.rules2Key(1)),
        );
        expect(carrier.id, nor.id);
        // Nothing else about the world moved.
        expect(
          [
            for (final n in after)
              n.copyWith(
                hostBids: {
                  for (final e in n.hostBids.entries)
                    if (e.key != HostBidding.rules2Key(1)) e.key: e.value,
                },
              ),
          ],
          before,
        );
      },
    );
  });
}
