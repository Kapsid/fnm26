import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/features/match/match_ground.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

Fixture _fixture({
  required int home,
  required int away,
  String? round,
  int id = 1,
  DateTime? date,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: date ?? DateTime(2030, 10, 10),
  homeNationId: home,
  awayNationId: away,
  round: round,
);

void main() {
  group('the national ground', () {
    MatchGround home(int nation) => Attendance.forFixture(
      fixture: _fixture(home: nation, away: 14),
      neutral: false,
      citiesByNation: _cities,
      seed: 7,
    );

    test('Ecuador hosts in Quito, Colombia in Bogotá, Bolivia in La Paz', () {
      expect(home(61).city, 'Quito');
      expect(home(60).city, 'Bogotá');
      expect(home(57).city, 'La Paz');
      expect(home(119).city, 'Addis Ababa');
      // Everybody else is still at the biggest ground.
      expect(home(88).city, 'Mexico City');
      expect(home(14).city, 'London');
    });

    test('a ground under a thousand seats no longer throws', () {
      // San Marino (45): its smallest finals ground holds 700.
      for (var id = 1; id <= 60; id++) {
        final g = Attendance.forFixture(
          fixture: _fixture(home: 14, away: 20, round: 'GROUP', id: id),
          neutral: true,
          tournamentHostIds: const [45],
          venueCount: 5,
          citiesByNation: _cities,
          seed: 7,
        );
        expect(g.attendance, lessThanOrEqualTo(g.capacity));
      }
    });

    test(
      'a finals with no hosts falls back to the home side, at its ground',
      () {
        final g = Attendance.forFixture(
          fixture: _fixture(home: 57, away: 56, round: 'CGROUP'),
          neutral: true,
          citiesByNation: _cities,
          seed: 7,
        );
        expect(g.groundNationId, 57);
      },
    );
  });

  group("the manager's estate", () {
    const grounds = [
      NationalStadium(city: 'Guayaquil', name: 'A', baseCapacity: 57000),
      NationalStadium(city: 'Quito', name: 'B', baseCapacity: 41000),
    ];

    test('untouched, it plays where every AI nation does', () {
      expect(nationalGroundOf(grounds, 61, worked: false).city, 'Quito');
    });

    test('an altitude nation stays up there whatever is built', () {
      expect(nationalGroundOf(grounds, 61, worked: true).city, 'Quito');
    });

    test('once worked on, a sea-level estate plays at its biggest', () {
      // Albania: Tirana is not up a mountain, so a built-up Durres is home.
      const al = [
        NationalStadium(city: 'Durres', name: 'A', baseCapacity: 40000),
        NationalStadium(city: 'Tirana', name: 'B', baseCapacity: 22000),
      ];
      expect(nationalGroundOf(al, 1, worked: true).city, 'Durres');
    });

    test('an altitude nation whose home city has no ground: the biggest', () {
      expect(
        nationalGroundOf(grounds.sublist(0, 1), 61, worked: true).city,
        'Guayaquil',
      );
    });

    test('no ground in the home city: the biggest', () {
      expect(
        nationalGroundOf(grounds.sublist(0, 1), 61, worked: false).city,
        'Guayaquil',
      );
    });
  });

  test('conditionsAt reads the ground and the month', () {
    final f = _fixture(home: 57, away: 56);
    final g = Attendance.forFixture(
      fixture: f,
      neutral: false,
      citiesByNation: _cities,
      seed: 7,
    );
    final c = conditionsAt(f, g);
    expect(c.altitude, MatchClimate.altitudeOf(57, 'La Paz'));
    expect(c.awayDrain, greaterThan(1.9));
  });
}
