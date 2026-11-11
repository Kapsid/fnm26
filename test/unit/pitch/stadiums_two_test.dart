import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/domain/services/match/stadium/stadium_signature.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';

/// Stadiums 2.0 (release 1.2): the city geography table, the small-ground
/// rules, the look the federation's works give a ground, and the third set
/// of landmarks. All of it cosmetic.
void main() {
  final cities =
      (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .map((k, v) => MapEntry(int.parse(k), (v! as List).cast<String>()));
  final codes = {
    for (final n
        in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .cast<Map<String, Object?>>())
      n['id']! as int: n['code']! as String,
    // The dormant nations, not in the bundled data.
    6: 'BLR',
    212: 'GRL',
    213: 'ZAN',
  };

  group('city geography', () {
    test('every city a national team plays its home games in is tagged', () {
      final missing = <String>[];
      for (final MapEntry(key: id, value: list) in cities.entries) {
        final code = codes[id]!;
        final home = {
          for (final v in VenueGenerator.forHost(
            hostId: id,
            cities: list,
            count: 16,
          ).take(5))
            v.city,
          ?MatchClimate.homeCityOf(id),
        };
        for (final c in home) {
          if (CityGeography.of(code, c) == null) missing.add('$code $c');
        }
      }
      expect(missing, isEmpty);
    });

    test('capitals off the home rotation are tagged too', () {
      for (final (code, city) in [
        ('TUR', 'Ankara'),
        ('CAN', 'Ottawa'),
        ('NGA', 'Abuja'),
        ('SUI', 'Bern'),
        ('BRA', 'Brasília'),
        ('MAR', 'Rabat'),
        ('TAN', 'Dodoma'),
        ('CMR', 'Yaoundé'),
      ]) {
        expect(CityGeography.of(code, city), isNotNull, reason: city);
      }
    });

    test('every tagged city is a city of its nation in the game data', () {
      final known = {
        for (final MapEntry(key: id, value: list) in cities.entries)
          for (final c in list) '${codes[id]}:${Landmarks.fold(c)}',
        for (final MapEntry(key: id, value: list) in cities.entries)
          for (final v in VenueGenerator.forHost(
            hostId: id,
            cities: list,
            count: 16,
          ))
            '${codes[id]}:${Landmarks.fold(v.city)}',
      };
      final stray = [
        for (final (code, city) in CityGeography.entries)
          if (!known.contains('$code:${Landmarks.fold(city)}')) '$code $city',
      ];
      expect(stray, isEmpty);
      expect(CityGeography.taggedCities, greaterThan(880));
    });

    test('matched with accents and case aside, by nation', () {
      expect(CityGeography.of('POL', 'GDANSK'), {
        CityFeature.coast,
        CityFeature.industrial,
        CityFeature.oldTown,
      });
      expect(CityGeography.of('ESP', 'Valencia'), contains(CityFeature.coast));
      expect(CityGeography.of('VEN', 'Valencia'), isEmpty);
    });

    test('an unknown city falls back to its country; a small island is all '
        'coast', () {
      expect(CityGeography.of('CZE', 'Nowhere'), isNull);
      expect(CityGeography.of('XXX', 'Prague'), isNull);
      expect(CityGeography.of('MLT', 'Birkirkara'), {CityFeature.coast});
    });

    test('the far layer follows the city', () {
      const eu = Confederation.europe;
      Horizon h(Horizon c, String tags, [Confederation f = eu]) =>
          CityGeography.horizonFor(c, {
            for (final t in tags.split(''))
              ?{
                'c': CityFeature.coast,
                'r': CityFeature.river,
                'm': CityFeature.mountains,
                'd': CityFeature.desert,
                'f': CityFeature.forest,
                'o': CityFeature.oldTown,
              }[t],
          }, f);
      // The coast looks out to sea, a fjord country's to its fjords.
      expect(h(Horizon.plains, 'c'), Horizon.sea);
      expect(h(Horizon.fjords, 'c'), Horizon.fjords);
      // Mountains: the country's own range, else snowy peaks.
      expect(h(Horizon.plains, 'm'), Horizon.alps);
      expect(
        h(Horizon.plains, 'm', Confederation.southAmerica),
        Horizon.andes,
      );
      expect(h(Horizon.volcanoes, 'm'), Horizon.volcanoes);
      expect(h(Horizon.desert, 'm'), Horizon.atlas);
      expect(h(Horizon.forestHills, 'd'), Horizon.desert);
      expect(h(Horizon.plains, 'f'), Horizon.forestHills);
      // Inland: never the sea, nor a range it is nowhere near.
      expect(h(Horizon.sea, 'r'), Horizon.forestHills);
      expect(h(Horizon.alps, 'o'), Horizon.forestHills);
      expect(h(Horizon.plains, 'ro'), Horizon.plains);
    });

    test('the spec reads the city, and keeps the country look for an '
        'unknown one', () {
      final known = _spec('BRA', 'Brasília', 60000);
      expect(known.horizon, Horizon.forestHills); // not Brazil's sea
      expect(known.features, isEmpty);
      final coast = _spec('FRA', 'Marseille', 60000);
      expect(coast.horizon, Horizon.sea);
      expect(coast.features, {CityFeature.coast});
      final unknown = _spec('BRA', 'Mock Town', 60000);
      expect(unknown.horizon, NationBackdrops.table['BRA']!.$2);
      expect(unknown.features, isEmpty);
    });
  });

  group('small grounds', () {
    test('the scale bands', () {
      expect(GroundScale.of(7999), GroundScale.old);
      expect(GroundScale.of(8000), GroundScale.compact);
      expect(GroundScale.of(19999), GroundScale.compact);
      expect(GroundScale.of(20000), GroundScale.big);
    });

    test('under 20,000: one tier, the main stand part roofed, open '
        'corners', () {
      for (final cap in [5000, 12000, 19000]) {
        final s = _spec('CZE', 'Brno', cap);
        expect(s.tiers, 1, reason: '$cap');
        expect(s.partRoof, isTrue, reason: '$cap');
        expect(s.openCorners, isTrue, reason: '$cap');
      }
      expect(_spec('CZE', 'Brno', 5000).scale, GroundScale.old);
      expect(_spec('CZE', 'Brno', 12000).scale, GroundScale.compact);
    });

    test('big grounds keep the look they always had', () {
      for (final cap in [20000, 30000, 44999, 45000, 80000]) {
        final s = _spec('ESP', 'Madrid', cap);
        expect(s.scale, GroundScale.big);
        expect(s.partRoof, isFalse);
        expect(s.tiers, cap < 45000 ? 2 : 3);
        expect(
          s.signature,
          StadiumSignature.of(
            stadium: 'Mock Ground',
            nationCode: 'ESP',
            confederation: Confederation.europe,
            capacity: cap,
          ),
        );
      }
    });
  });

  group("the federation's works", () {
    const seed = [
      (city: 'Brno', stadium: 'Mock Brno Ground', capacity: 12000),
      (city: 'Prague', stadium: 'Mock Prague Ground', capacity: 20000),
    ];
    List<NationalStadium> estate(List<StadiumWork> works) =>
        NationalStadiums.forNation(nationId: 12, seed: seed, works: works);
    GroundWorks of(
      String city,
      String stadium,
      List<StadiumWork> works,
      int cycle,
    ) => GroundWorks.forGround(
      city: city,
      stadium: stadium,
      estate: estate(works),
      works: works,
      nationId: 12,
      cycle: cycle,
    );

    test('an untouched ground has none', () {
      expect(of('Brno', 'Mock Brno Ground', const [], 3), GroundWorks.none);
      // Another nation's works never touch it.
      const other = StadiumWork.resize(
        nationId: 13,
        cycle: 3,
        stadium: (city: 'Brno', built: false),
        seats: 20000,
        enlarge: true,
      );
      expect(of('Brno', 'Mock Brno Ground', [other], 3), GroundWorks.none);
    });

    test('an enlargement is under way in its cycle, done in the next', () {
      const up = StadiumWork.resize(
        nationId: 12,
        cycle: 3,
        stadium: (city: 'Brno', built: false),
        seats: 20000,
        enlarge: true,
      );
      final now = of('Brno', 'Mock Brno Ground', [up], 3);
      expect(now.upgrades, 1);
      expect(now.underWay, isTrue);
      expect(now.baseCapacity, 12000);
      final later = of('Brno', 'Mock Brno Ground', [up], 4);
      expect(later.upgrades, 1);
      expect(later.underWay, isFalse);
      // The other ground is untouched.
      expect(of('Prague', 'Mock Prague Ground', [up], 3), GroundWorks.none);
    });

    test('a built ground is an Arena Nova: a modern closed bowl', () {
      const build = StadiumWork.build(nationId: 12, cycle: 2, city: 'Ostrava');
      final w = of('Ostrava', NationalStadiums.newStadiumName('Ostrava'), [
        build,
      ], 3);
      expect(w.built, isTrue);
      final s = _spec(
        'CZE',
        'Ostrava',
        12000,
        stadium: NationalStadiums.newStadiumName('Ostrava'),
        works: w,
      );
      expect(s.works, w);
      expect(s.scale, GroundScale.big);
      expect(s.partRoof, isFalse);
      expect(s.openCorners, isFalse);
      expect(s.signature.bowl, BowlShape.oval);
      expect(s.signature.roof, isIn([RoofStyle.ring, RoofStyle.cantilever]));
      expect(s.signature.seats, SeatPattern.mosaic);
      expect(s.signature.lights, FloodlightStyle.roofEdge);
    });

    test('an enlargement adds a roof where there was none, else a tier', () {
      // A ground that was open to the sky, and one that was not.
      String? open;
      String? roofed;
      for (var i = 0; i < 200 && (open == null || roofed == null); i++) {
        final name = 'Mock Ground $i';
        final sig = StadiumSignature.of(
          stadium: name,
          nationCode: 'CZE',
          confederation: Confederation.europe,
          capacity: 25000,
        );
        if (sig.roof == RoofStyle.open) {
          open ??= name;
        } else {
          roofed ??= name;
        }
      }
      const works = GroundWorks(upgrades: 1, baseCapacity: 25000);
      final a = _spec('CZE', 'Brno', 32000, stadium: open!, works: works);
      expect(a.signature.roof, RoofStyle.cantilever);
      expect(a.tiers, 2);
      final b = _spec('CZE', 'Brno', 32000, stadium: roofed!, works: works);
      expect(b.tiers, 3);
      expect(b.partRoof, isFalse);
      // An old ground enlarged loses its terraces and open end.
      final c = _spec(
        'CZE',
        'Brno',
        7500,
        works: const GroundWorks(upgrades: 1, baseCapacity: 5000),
      );
      expect(c.scale, GroundScale.compact);
      expect(c.partRoof, isFalse);
    });
  });

  group('the third set of landmarks', () {
    const third = {
      'Yerevan': LandmarkKind.ararat,
      'Yokohama': LandmarkKind.fuji,
      'Saitama': LandmarkKind.fuji,
      'Shizuoka': LandmarkKind.fuji,
      'Puebla': LandmarkKind.popocatepetl,
      'Quito': LandmarkKind.cotopaxi,
      'La Paz': LandmarkKind.illimani,
      'Naples': LandmarkKind.vesuvius,
      'Arusha': LandmarkKind.kilimanjaro,
      'Innsbruck': LandmarkKind.alpinePeaks,
      'Salzburg': LandmarkKind.alpinePeaks,
      'Wals-Siezenheim': LandmarkKind.alpinePeaks,
      'Bern': LandmarkKind.alpinePeaks,
      'Bergen': LandmarkKind.fjord,
      'Cologne': LandmarkKind.cologneCathedral,
      'Florence': LandmarkKind.florenceDome,
      'Kraków': LandmarkKind.wawel,
      'Bratislava': LandmarkKind.bratislavaCastle,
      'Sofia': LandmarkKind.nevskyCathedral,
      'Belgrade': LandmarkKind.belgradeFortress,
      'Vilnius': LandmarkKind.gediminasTower,
      'Tbilisi': LandmarkKind.narikala,
      'Baku': LandmarkKind.maidenTower,
      'Seville': LandmarkKind.giralda,
      'Marrakesh': LandmarkKind.koutoubia,
      'Rabat': LandmarkKind.hassanTower,
      'Siem Reap': LandmarkKind.angkor,
      'Yangon': LandmarkKind.shwedagon,
      'Havana': LandmarkKind.morroCastle,
      'Porto': LandmarkKind.clerigos,
      'Kolkata': LandmarkKind.victoriaMemorial,
    };

    test('each resolves for its city, a city of the game data', () {
      final known = {
        for (final list in cities.values)
          for (final c in list) c,
        for (final MapEntry(key: id, value: list) in cities.entries)
          for (final v in VenueGenerator.forHost(
            hostId: id,
            cities: list,
            count: 16,
          ))
            v.city,
      };
      for (final MapEntry(key: city, value: kind) in third.entries) {
        expect(known, contains(city), reason: city);
        expect(Landmarks.forCity(city), kind, reason: city);
      }
      // Every new kind has a city.
      final newKinds = LandmarkKind.values.skip(
        LandmarkKind.ararat.index,
      );
      expect(third.values.toSet(), newKinds.toSet());
      expect(newKinds.length, 26);
    });

    test('local spellings too, and namesakes stay unmatched', () {
      for (final (city, kind) in [
        ('Köln', LandmarkKind.cologneCathedral),
        ('Firenze', LandmarkKind.florenceDome),
        ('Napoli', LandmarkKind.vesuvius),
        ('Sevilla', LandmarkKind.giralda),
        ('Beograd', LandmarkKind.belgradeFortress),
        ('La Habana', LandmarkKind.morroCastle),
        ('Marrakech', LandmarkKind.koutoubia),
      ]) {
        expect(Landmarks.forCity(city), kind, reason: city);
      }
      for (final city in ['Porto Alegre', 'Porto-Novo', 'La Plata']) {
        expect(Landmarks.forCity(city), LandmarkKind.none, reason: city);
      }
    });

    test('each a silhouette one unit tall; snow on the high peaks', () {
      for (final k in third.values.toSet()) {
        final b = LandmarkPaths.of(k).getBounds();
        expect(b.isEmpty, isFalse, reason: k.name);
        expect(b.top, closeTo(-1, 0.05), reason: k.name);
        expect(b.bottom, closeTo(0, 0.02), reason: k.name);
        expect(b.width, lessThanOrEqualTo(2.01), reason: k.name);
        final cap = LandmarkPaths.capOf(k);
        if (cap != null) {
          expect(LandmarkPaths.isMountain(k), isTrue, reason: k.name);
          expect(cap.getBounds().isEmpty, isFalse, reason: k.name);
        }
        if (LandmarkPaths.isMountain(k)) {
          expect(LandmarkPaths.floodlitAtNight(k), isFalse, reason: k.name);
          expect(LandmarkPaths.hasWindows(k), isFalse, reason: k.name);
        }
      }
      expect(LandmarkPaths.capOf(LandmarkKind.vesuvius), isNull);
    });

    test('the modern trademarked silhouettes are flagged off promo; every '
        'new one is promo-safe', () {
      for (final k in [
        LandmarkKind.operaHouse,
        LandmarkKind.burj,
        LandmarkKind.sailHotel,
        LandmarkKind.twinTowers,
        LandmarkKind.tokyoTower,
        LandmarkKind.cnTower,
        LandmarkKind.skyTower,
        LandmarkKind.kingdomCentre,
        LandmarkKind.aspireTorch,
        LandmarkKind.costanera,
        LandmarkKind.dublinSpire,
        LandmarkKind.seoulTower,
        LandmarkKind.orientalPearl,
        LandmarkKind.kicc,
        LandmarkKind.motherland,
      ]) {
        expect(Landmarks.promoSafe(k), isFalse, reason: k.name);
      }
      for (final k in third.values) {
        expect(Landmarks.promoSafe(k), isTrue, reason: k.name);
      }
      expect(Landmarks.promoSafe(LandmarkKind.colosseum), isTrue);
    });
  });
}

StadiumSpec _spec(
  String code,
  String city,
  int capacity, {
  String stadium = 'Mock Ground',
  GroundWorks works = GroundWorks.none,
}) {
  const home = Nation(
    id: 1,
    name: 'Home',
    code: 'HOM',
    confederation: Confederation.europe,
    ranking: 30,
    primaryColor: '#D52B1E',
    secondaryColor: '#FFFFFF',
  );
  const away = Nation(
    id: 2,
    name: 'Away',
    code: 'AWY',
    confederation: Confederation.europe,
    ranking: 40,
    primaryColor: '#0039A6',
    secondaryColor: '#FFFFFF',
  );
  return StadiumSpec.from(
    (
      stadium: stadium,
      city: city,
      groundNationId: 1,
      capacity: capacity,
      attendance: capacity ~/ 2,
      soldOut: false,
    ),
    home,
    away,
    0.1,
    groundNationCode: code,
    groundConfederation: code == 'BRA'
        ? Confederation.southAmerica
        : Confederation.europe,
    works: works,
  );
}
