import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

void main() {
  group('every nation has a city and a horizon', () {
    test('nations.json and the dormant nations all have a row', () {
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List)
              .cast<Map<String, Object?>>();
      final codes = {
        for (final n in nations) n['code']! as String,
        for (final n in DormantNations.all) n.code,
      };
      final missing = codes.where(
        (c) => !NationBackdrops.table.containsKey(c),
      );
      expect(missing, isEmpty);
    });

    test('every style and every horizon is used somewhere', () {
      final cities = {for (final v in NationBackdrops.table.values) v.$1};
      final horizons = {for (final v in NationBackdrops.table.values) v.$2};
      expect(cities, CityStyle.values.toSet());
      expect(horizons, Horizon.values.toSet());
    });

    test('the mocked grounds read as their places', () {
      expect(NationBackdrops.of('CZE', Confederation.europe, capacity: 40000), (
        CityStyle.oldEuropean,
        Horizon.forestHills,
      ));
      expect(
        NationBackdrops.of('BOL', Confederation.southAmerica, capacity: 40000),
        (CityStyle.latinAmerican, Horizon.andes),
      );
      expect(NationBackdrops.of('QAT', Confederation.asia, capacity: 40000), (
        CityStyle.glassTowers,
        Horizon.desert,
      ));
      expect(NationBackdrops.of('NGA', Confederation.africa, capacity: 40000), (
        CityStyle.african,
        Horizon.sea,
      ));
      expect(NationBackdrops.of('RUS', Confederation.europe, capacity: 40000), (
        CityStyle.sovietBlocks,
        Horizon.plains,
      ));
    });

    test('a small ground sits in a small town, under its own horizon', () {
      expect(
        NationBackdrops.of('BOL', Confederation.southAmerica, capacity: 8000),
        (
          CityStyle.smallTown,
          Horizon.andes,
        ),
      );
    });

    test('an editor-made nation falls back to its confederation', () {
      final (city, horizon) = NationBackdrops.of(
        'XYZ',
        Confederation.africa,
        capacity: 30000,
      );
      expect(city, CityStyle.african);
      expect(horizon, isA<Horizon>());
    });
  });

  group('the season', () {
    BackdropSeason at(double lat, int month, {bool continental = false}) =>
        BackdropSeason.at(
          latitude: lat,
          date: DateTime(2026, month, 15),
          continental: continental,
        );

    test('a northern winter brings snow, a maritime one need not', () {
      expect(at(55.8, 1, continental: true), BackdropSeason.snow);
      expect(at(59.9, 2, continental: true), BackdropSeason.snow);
      expect(at(38.7, 1), BackdropSeason.green);
    });

    test('Central Europe turns in October and November', () {
      expect(at(50.1, 10), BackdropSeason.autumn);
      expect(at(48.2, 11, continental: true), BackdropSeason.autumn);
      expect(at(50.1, 6), BackdropSeason.green);
    });

    test('a hot summer dries the grass', () {
      expect(at(40.4, 7), BackdropSeason.dry);
      expect(at(37.9, 8), BackdropSeason.dry);
      expect(at(1.4, 7), BackdropSeason.green);
    });

    test('the southern hemisphere has its seasons the other way round', () {
      expect(at(-34.6, 1), BackdropSeason.dry);
      expect(at(-34.6, 7), BackdropSeason.green);
      expect(at(-45.0, 4), BackdropSeason.autumn);
    });

    test('the season is the same every time for one date', () {
      for (var d = 1; d <= 28; d++) {
        final date = DateTime(2027, 1, d);
        BackdropSeason s() =>
            BackdropSeason.at(latitude: 47, date: date, continental: false);
        expect(s(), s());
      }
    });

    test('StadiumSpec carries the season of its date', () {
      const russia = Nation(
        id: 900,
        name: 'Russia',
        code: 'RUS',
        confederation: Confederation.europe,
        ranking: 30,
        primaryColor: '#D52B1E',
      );
      const czechia = Nation(
        id: 901,
        name: 'Czechia',
        code: 'CZE',
        confederation: Confederation.europe,
        ranking: 40,
        primaryColor: '#D7141A',
      );
      const MatchGround g = (
        stadium: 'S',
        city: 'Moscow',
        groundNationId: 900,
        capacity: 50000,
        attendance: 40000,
        soldOut: false,
      );
      final winter = StadiumSpec.from(
        g,
        russia,
        czechia,
        0.1,
        groundNationCode: 'RUS',
        date: DateTime(2027, 1, 20),
      );
      expect(winter.season, BackdropSeason.snow);
      expect(winter.city, CityStyle.sovietBlocks);
      expect(winter.neutral, isFalse);
      final none = StadiumSpec.from(
        g,
        russia,
        czechia,
        0.1,
        groundNationCode: 'RUS',
      );
      expect(none.season, BackdropSeason.green);
      final neutral = StadiumSpec.from(
        g,
        czechia,
        russia,
        0.5,
        groundNationCode: 'RUS',
      );
      expect(neutral.neutral, isTrue);
    });
  });
}
