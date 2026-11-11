import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/home_ground.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

Fixture _fixture({
  required int home,
  int away = 200,
  String? round,
  int id = 1,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2030, 10, 10),
  homeNationId: home,
  awayNationId: away,
  round: round,
);

/// A home game of [home] against a modest visitor (ranked 100th).
MatchGround _home(
  int home, {
  int id = 1,
  String? round,
  int awayRanking = 100,
  int homeStrength = 70,
  int awayStrength = 70,
  double moodFill = 0,
  Map<int, ({Venue venue, double fillBonus})> homeGrounds = const {},
  Map<int, List<({Venue venue, double fillBonus})>> homeEstates = const {},
  Map<int, List<String>>? cities,
  Venue? override,
}) => Attendance.forFixture(
  fixture: _fixture(home: home, id: id, round: round),
  neutral: false,
  citiesByNation: cities ?? _cities,
  seed: 7,
  awayRanking: awayRanking,
  homeStrength: homeStrength,
  awayStrength: awayStrength,
  moodFill: moodFill,
  homeGrounds: homeGrounds,
  homeEstates: homeEstates,
  homeGroundOverride: override,
);

Set<String> _citiesOver(
  int nation, {
  String? round,
  int awayRanking = 100,
  int games = 60,
}) => {
  for (var id = 1; id <= games; id++)
    _home(nation, id: id, round: round, awayRanking: awayRanking).city,
};

void main() {
  const england = 14;
  final englandGrounds = VenueGenerator.forHost(
    hostId: england,
    cities: _cities[england],
  );

  test('the same fixture is always at the same ground, whoever asks', () {
    for (var id = 1; id <= 40; id++) {
      // The shown match passes the sides' ratings and the fans' mood; a
      // skipped one passes none. Neither moves the ground.
      final shown = _home(
        england,
        id: id,
        homeStrength: 84,
        awayStrength: 61,
        moodFill: 0.08,
      );
      final background = _home(england, id: id);
      expect(shown.stadium, background.stadium);
      expect(shown.city, background.city);
      expect(_home(england, id: id).stadium, background.stadium);
    }
  });

  test('home qualifiers rotate over the three biggest grounds', () {
    final used = _citiesOver(england);
    expect(used.length, greaterThan(1));
    expect(used.length, lessThanOrEqualTo(HomeGround.competitivePool));
    final top = {
      for (final v in englandGrounds.take(HomeGround.competitivePool)) v.city,
    };
    expect(top, containsAll(used));
    // The national stadium still hosts the most.
    final london = [
      for (var id = 1; id <= 60; id++) _home(england, id: id).city,
    ].where((c) => c == 'London').length;
    expect(london, greaterThan(60 ~/ HomeGround.competitivePool));
    // Nations Cup league games rotate the same way.
    expect(_citiesOver(england, round: 'NGROUP').length, greaterThan(1));
  });

  test('friendlies go further afield, to the five biggest', () {
    final used = _citiesOver(england, round: 'FRIENDLY');
    expect(used.length, greaterThan(HomeGround.competitivePool));
    expect(used.length, lessThanOrEqualTo(HomeGround.friendlyPool));
  });

  test('a big match is at the national stadium', () {
    // A visitor in the top 20.
    expect(_citiesOver(england, awayRanking: 5), {'London'});
    expect(
      _citiesOver(england, awayRanking: HomeGround.bigOpponentRanking),
      {'London'},
    );
    // A decisive knockout leg: a play-off, a Nations Cup quarter-final.
    expect(_citiesOver(england, round: 'NQF'), {'London'});
    // A big friendly is still a friendly.
    expect(
      _citiesOver(england, round: 'FRIENDLY', awayRanking: 3).length,
      greaterThan(1),
    );
  });

  test('a nation at altitude never leaves its mountain city', () {
    for (final (nation, city) in [
      (61, 'Quito'),
      (60, 'Bogotá'),
      (57, 'La Paz'),
      (119, 'Addis Ababa'),
      (88, 'Mexico City'),
    ]) {
      expect(
        MatchClimate.acclimatisedAltitude(nation),
        greaterThanOrEqualTo(MatchClimate.altitudeFloor),
      );
      for (final round in [null, 'NGROUP', 'FRIENDLY']) {
        expect(_citiesOver(nation, round: round), {city}, reason: '$nation');
      }
    }
  });

  test('a sea-level nation is never sent up a mountain', () {
    // Peru plays at sea level in Lima; Arequipa and Cusco are high.
    const peru = 63;
    for (final round in [null, 'FRIENDLY']) {
      for (final city in _citiesOver(peru, round: round, games: 120)) {
        expect(MatchClimate.altitudeOf(peru, city), 0, reason: city);
      }
    }
  });

  test('a country with one ground just keeps it', () {
    const one = <int, List<String>>{
      900: ['Kastel'],
    };
    for (final round in [null, 'FRIENDLY']) {
      final used = {
        for (var id = 1; id <= 30; id++)
          _home(900, id: id, round: round, cities: one).city,
      };
      expect(used, {'Kastel'});
    }
  });

  group("the manager's estate", () {
    const arena = (city: 'Birmingham', stadium: 'Arena Nova', capacity: 95000);
    final estate = [
      (venue: arena, fillBonus: 0.04),
      for (final v in englandGrounds) (venue: v, fillBonus: 0.0),
    ];
    MatchGround mine({int id = 1, int awayRanking = 100, String? round}) =>
        _home(
          england,
          id: id,
          round: round,
          awayRanking: awayRanking,
          homeGrounds: {england: (venue: arena, fillBonus: 0.04)},
          homeEstates: {england: estate},
        );

    test('once worked on, its biggest ground takes the big matches', () {
      for (var id = 1; id <= 30; id++) {
        expect(mine(id: id, awayRanking: 2).stadium, 'Arena Nova');
        expect(mine(id: id, round: 'NSF').stadium, 'Arena Nova');
      }
    });

    test('the rest rotate over the estate, each at its own fill', () {
      final grounds = {for (var id = 1; id <= 60; id++) mine(id: id).stadium};
      expect(grounds, contains('Arena Nova'));
      expect(grounds.length, greaterThan(1));
      final top = {for (final g in estate.take(3)) g.venue.stadium};
      expect(top, containsAll(grounds));
    });

    test('with only the national stadium listed, it plays there', () {
      for (var id = 1; id <= 30; id++) {
        final g = _home(
          england,
          id: id,
          homeGrounds: {england: (venue: arena, fillBonus: 0)},
        );
        expect(g.stadium, 'Arena Nova');
      }
    });
  });

  test('an override bypasses the rotation', () {
    const pick = (city: 'Leeds', stadium: 'Elland', capacity: 37000);
    for (var id = 1; id <= 10; id++) {
      expect(
        _home(england, id: id, awayRanking: 1, override: pick).stadium,
        'Elland',
      );
    }
    expect(
      homeGroundFor(
        candidates: const [],
        national: englandGrounds.first,
        fixture: _fixture(home: england),
        seed: 7,
        override: pick,
      ),
      pick,
    );
  });
}
