import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/match/attendance.dart';

Fixture _fixture({
  required String round,
  int id = 1,
  int home = 10,
  int away = 20,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2030, 6, 20),
  homeNationId: home,
  awayNationId: away,
  round: round,
);

void main() {
  const cities = <int, List<String>>{
    10: ['Homeville', 'Homeport', 'Homeford'],
    20: ['Awaytown', 'Awayport', 'Awayford'],
    99: ['Hostberg', 'Hostmar', 'Hostholm', 'Hostvik'],
  };

  MatchGround ground(
    Fixture f, {
    required bool neutral,
    List<int> hosts = const [],
  }) => Attendance.forFixture(
    fixture: f,
    neutral: neutral,
    tournamentHostIds: hosts,
    citiesByNation: cities,
    seed: 4242,
  );

  group('a neutral finals is played at the host, not a finalist', () {
    test('a group game with neither side hosting is in the host country', () {
      final g = ground(
        _fixture(round: 'GROUP'),
        neutral: true,
        hosts: const [99],
      );
      expect(g.groundNationId, 99);
      expect(cities[99], contains(g.city));
    });

    test('the final is at the host, whoever is nominally at home', () {
      // The bug this guards: the host played no part in the tie, so the ground
      // fell back to the listed home side and the showpiece was staged in a
      // finalist's own country.
      final g = ground(
        _fixture(round: 'FINAL', id: 77),
        neutral: true,
        hosts: const [99],
      );
      expect(g.groundNationId, 99);
      expect(g.groundNationId, isNot(10));
      expect(g.groundNationId, isNot(20));
    });

    test('the continental final is at its host too', () {
      final g = ground(
        _fixture(round: 'CFINAL', id: 88),
        neutral: true,
        hosts: const [99],
      );
      expect(g.groundNationId, 99);
    });

    test('the showpiece uses the marquee ground, not a rotated one', () {
      final finalGround = ground(
        _fixture(round: 'FINAL', id: 5),
        neutral: true,
        hosts: const [99],
      );
      // The primary host's biggest city is the first in its list.
      expect(finalGround.city, cities[99]!.first);
      expect(
        finalGround.capacity,
        greaterThanOrEqualTo(finalGround.attendance),
      );
    });

    test('a joint candidature still stages the showpiece at the lead host', () {
      final g = ground(
        _fixture(round: 'CFINAL', id: 31),
        neutral: true,
        hosts: const [99, 10],
      );
      expect(g.groundNationId, 99);
    });

    test('group games spread across a joint candidature', () {
      final owners = {
        for (var id = 1; id <= 24; id++)
          ground(
            _fixture(round: 'CGROUP', id: id),
            neutral: true,
            hosts: const [99, 10],
          ).groundNationId,
      };
      expect(owners, {99, 10});
    });
  });

  test('a home-and-away tie is still played at the home side', () {
    final g = ground(_fixture(round: 'FRIENDLY'), neutral: false);
    expect(g.groundNationId, 10);
    expect(g.city, cities[10]!.first);
  });

  test('unknown hosts fall back to the home side rather than nowhere', () {
    final g = ground(_fixture(round: 'GROUP'), neutral: true);
    expect(g.groundNationId, 10);
  });

  test('a bigger finals rotates over more of the host\'s grounds', () {
    const big = <int, List<String>>{
      99: [
        'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', //
        'C9', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16',
      ],
    };
    Set<String> citiesUsed(int venueCount) => {
      for (var id = 1; id <= 400; id++)
        Attendance.forFixture(
          fixture: _fixture(round: 'GROUP', id: id),
          neutral: true,
          tournamentHostIds: const [99],
          citiesByNation: big,
          seed: 4242,
          venueCount: venueCount,
        ).city,
    };
    expect(citiesUsed(8), hasLength(8));
    expect(citiesUsed(16), hasLength(16));
  });

  group('a finals the manager\'s nation hosts uses its live estate', () {
    // The estate after the career's works: a built Arena Nova at the top and
    // a downsized ground, biggest first.
    const estate = <Venue>[
      (city: 'Hostvik', stadium: 'Hostvik Arena Nova', capacity: 52000),
      (city: 'Hostberg', stadium: 'Hostberg Park', capacity: 41000),
      (city: 'Hostmar', stadium: 'Hostmar Field', capacity: 9000),
    ];

    test('the tournament lists the estate, a co-host its static grounds', () {
      final plain = VenueGenerator.forHosts(
        hostIds: const [99, 20],
        citiesByHost: cities,
        count: 6,
      );
      final live = VenueGenerator.forHosts(
        hostIds: const [99, 20],
        citiesByHost: cities,
        count: 6,
        estates: const {99: estate},
      );
      expect(live[99], estate);
      expect(live[20], plain[20], reason: 'the co-host is untouched');
      // An empty or absent estate changes nothing.
      expect(
        VenueGenerator.forHosts(
          hostIds: const [99, 20],
          citiesByHost: cities,
          count: 6,
          estates: const {99: []},
        ),
        plain,
      );
    });

    test('the final is in the Arena Nova and every crowd fits the estate', () {
      MatchGround at(int id, String round) => Attendance.forFixture(
        fixture: _fixture(round: round, id: id),
        neutral: true,
        tournamentHostIds: const [99],
        citiesByNation: cities,
        seed: 4242,
        hostEstates: const {99: estate},
      );
      final fin = at(1, 'FINAL');
      expect(fin.stadium, 'Hostvik Arena Nova');
      expect(fin.capacity, 52000);
      final names = {for (final v in estate) v.stadium};
      for (var id = 1; id <= 60; id++) {
        final g = at(id, 'GROUP');
        expect(names, contains(g.stadium));
        final v = estate.firstWhere((v) => v.stadium == g.stadium);
        expect(g.capacity, v.capacity);
        expect(g.attendance, lessThanOrEqualTo(v.capacity));
      }
      // Without the estate the same final is at the static marquee ground.
      expect(
        ground(_fixture(round: 'FINAL'), neutral: true, hosts: [99]).stadium,
        isNot('Hostvik Arena Nova'),
      );
    });
  });
}
