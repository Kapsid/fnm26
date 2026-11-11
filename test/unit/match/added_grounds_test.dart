import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

const _england = 14;
const _base = kPackAddedIdBase;

Fixture _fixture(int id, {String? round, int home = _england}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2030, 10, 10),
  homeNationId: home,
  awayNationId: 200,
  round: round,
);

MatchGround _ground(
  int id, {
  String? round,
  bool neutral = false,
  Map<int, List<Venue>> added = const {},
}) => Attendance.forFixture(
  fixture: _fixture(id, round: round),
  neutral: neutral,
  tournamentHostIds: neutral ? const [_england] : const [],
  citiesByNation: _cities,
  seed: 7,
  awayRanking: 100,
  addedGrounds: added,
);

/// The grounds a custom world adds to England: one big enough for the
/// rotation, in a city the game does not know, and one too small for it.
final _stadiums = [
  const PackStadium(
    id: _base,
    nationId: _england,
    name: 'Testford Arena',
    city: 'Testford',
    capacity: 80000,
  ),
  const PackStadium(
    id: _base + 1,
    nationId: _england,
    name: 'Little Ground',
    city: 'Smallbury',
    capacity: 1200,
  ),
];

void main() {
  final added = NationalStadiums.addedGrounds(_stadiums);
  final venues = {
    for (final e in added.entries) e.key: [for (final g in e.value) g.venue],
  };

  test('added grounds come biggest first, by nation', () {
    expect(added.keys, [_england]);
    expect(added[_england]!.map((g) => g.id), [_base, _base + 1]);
    expect(added[_england]!.first.venue, (
      city: 'Testford',
      stadium: 'Testford Arena',
      capacity: 80000,
    ));
  });

  test('withAdded merges them in by seats and leaves no-added alone', () {
    final grounds = VenueGenerator.forHost(
      hostId: _england,
      cities: _cities[_england],
    );
    expect(VenueGenerator.withAdded(grounds, const []), same(grounds));
    final merged = VenueGenerator.withAdded(grounds, venues[_england]!);
    expect(merged.length, grounds.length + 2);
    expect(merged.last.stadium, 'Little Ground');
    final seats = [for (final v in merged) v.capacity];
    expect(seats, [...seats]..sort((a, b) => b.compareTo(a)));
    // The game's keep their order.
    expect(
      [
        for (final v in merged)
          if (grounds.contains(v)) v,
      ],
      grounds,
    );
  });

  test('a home game can be played at an added ground, the same every '
      'time, and a career without one plays where it always did', () {
    final used = <String>{};
    for (var id = 1; id <= 80; id++) {
      final round = id.isEven ? 'FRIENDLY' : null;
      final plain = _ground(id, round: round);
      expect(
        _ground(id, round: round, added: const {}).stadium,
        plain.stadium,
      );
      final g = _ground(id, round: round, added: venues);
      expect(_ground(id, round: round, added: venues).stadium, g.stadium);
      used.add(g.stadium);
      if (g.stadium != 'Testford Arena') {
        expect(g.city, isNot('Smallbury'));
      }
    }
    expect(used, contains('Testford Arena'));
    // Too small for the rotation.
    expect(used, isNot(contains('Little Ground')));
  });

  test('a neutral finals never uses an added ground', () {
    for (var id = 1; id <= 40; id++) {
      final g = _ground(id, round: 'GROUP', neutral: true, added: venues);
      expect(g.stadium, _ground(id, round: 'GROUP', neutral: true).stadium);
    }
  });

  test('a city the game does not know is at sea level, with its '
      "country's look", () {
    expect(MatchClimate.altitudeOf(_england, 'Testford'), 0);
    expect(MatchClimate.altitudeOf(57, 'Testford'), 0);
    expect(CityGeography.of('ENG', 'Testford'), isNull);
  });

  group('the estate', () {
    final seed = VenueGenerator.forHost(
      hostId: _england,
      cities: _cities[_england],
      count: 16,
    );

    test('takes the added grounds in, each under a site of its own', () {
      final plain = NationalStadiums.forNation(
        nationId: _england,
        seed: seed,
        works: const [],
      );
      final none = NationalStadiums.forNation(
        nationId: _england,
        seed: seed,
        works: const [],
        added: const [],
      );
      expect([for (final s in none) s.ref], [for (final s in plain) s.ref]);
      final withAdded = NationalStadiums.forNation(
        nationId: _england,
        seed: seed,
        works: const [],
        added: added[_england]!,
      );
      expect(withAdded.length, plain.length + 2);
      final testford = withAdded.firstWhere((s) => s.city == 'Testford');
      expect(testford.name, 'Testford Arena');
      expect(testford.site, 'Testford#+$_base');
      expect(testford.built, isFalse);
      // In among the game's by its seats.
      expect(withAdded.indexOf(testford), lessThan(plain.length));
    });

    test('a work on an added ground lands on it alone', () {
      final work = StadiumWork.resize(
        nationId: _england,
        cycle: 1,
        stadium: (city: 'Smallbury#+${_base + 1}', built: false),
        seats: 5000,
        enlarge: true,
      );
      expect(StadiumWork.decode(work.encode())?.stadium, work.stadium);
      final estate = NationalStadiums.forNation(
        nationId: _england,
        seed: seed,
        works: [work],
        added: added[_england]!,
      );
      final small = estate.firstWhere((s) => s.city == 'Smallbury');
      expect(small.capacity, 5000);
      expect(small.upgrades, 1);
      expect(estate.where((s) => s.upgrades > 0), [small]);
    });
  });

  group('the press room', () {
    const reporters = [
      PackAddedReporter(id: _base, name: 'Mira Holcova', outlet: 'Vltava'),
      PackAddedReporter(id: _base + 1, name: 'Jan Brod', outlet: 'Ostrava FM'),
    ];

    test('with none added it is the room it always was', () {
      for (final seed in [0, 1, 7, 12345, -9]) {
        expect(Press.roomFor(seed, added: const []), Press.roomFor(seed));
        expect(Press.roomFor(seed).length, Press.reporters.length);
      }
    });

    test('added reporters join it, the same for the same seed', () {
      final added = Press.addedReporters(reporters);
      expect(added.map((r) => r.index), [_base, _base + 1]);
      expect(added.first.name, 'Mira Holcova');
      final room = Press.roomFor(7, added: added);
      expect(room.length, Press.reporters.length + 2);
      expect(room.map((r) => r.index), containsAll([_base, _base + 1]));
      expect(Press.roomFor(7, added: added), room);
      // Some conference opens with one of them.
      expect(
        {
          for (var seed = 0; seed < 60; seed++)
            Press.roomFor(seed, added: added).first.index,
        },
        contains(_base),
      );
    });
  });
}
