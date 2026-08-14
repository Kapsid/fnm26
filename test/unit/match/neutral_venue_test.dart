import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
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
}
