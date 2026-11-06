import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';

Nation n(
  int id,
  String code, {
  Confederation c = Confederation.europe,
  int rank = 40,
}) => Nation(
  id: id,
  name: code,
  code: code,
  confederation: c,
  ranking: rank,
  primaryColor: id == 1 ? '#D32F2F' : '#1565C0',
);

MatchGround g(int cap, int att) => (
  stadium: 'S',
  city: 'Paris',
  groundNationId: 1,
  capacity: cap,
  attendance: att,
  soldOut: att >= cap,
);

void main() {
  test('a neutral venue in a third country flies that country flag', () {
    final s = StadiumSpec.from(
      g(60000, 50000),
      n(1, 'FRA'),
      n(2, 'GER'),
      0.5,
      groundNationCode: 'ESP',
    );
    expect(s.flagCode, 'ESP');
  });
  final home = n(1, 'FRA'), away = n(2, 'GER');
  test('capacity 12000 gives one tier and open corners', () {
    final s = StadiumSpec.from(
      g(12000, 6000),
      home,
      away,
      0.1,
      groundNationCode: 'FRA',
    );
    expect(s.tiers, 1);
    expect(s.openCorners, isTrue);
  });
  test('80000 gives three tiers', () {
    final s = StadiumSpec.from(
      g(80000, 80000),
      home,
      away,
      0.1,
      groundNationCode: 'FRA',
    );
    expect(s.tiers, 3);
    expect(s.openCorners, isFalse);
    expect(
      StadiumSpec.from(
        g(30000, 1),
        home,
        away,
        0.1,
        groundNationCode: 'FRA',
      ).tiers,
      2,
    );
  });
  test('fill follows attendance', () {
    expect(
      StadiumSpec.from(
        g(50000, 25000),
        home,
        away,
        0.1,
        groundNationCode: 'FRA',
      ).fill,
      0.5,
    );
    expect(
      StadiumSpec.from(
        g(50000, 50000),
        home,
        away,
        0.1,
        groundNationCode: 'FRA',
      ).fill,
      1.0,
    );
    expect(
      StadiumSpec.from(
        g(50000, 25000),
        home,
        away,
        0.1,
        groundNationCode: 'FRA',
      ).flagCode,
      'FRA',
    );
  });
  test('neighbours bring more away fans than long-haul', () {
    final far = n(3, 'BRA', c: Confederation.southAmerica, rank: 40);
    double e(Nation a) => AwayFanShare.estimate(
      home: home,
      away: a,
      neutral: false,
      tournament: false,
      distanceKm: AwayFanShare.proxyDistanceKm(home, a),
    );
    expect(e(away), greaterThan(e(far)));
    for (final a in [away, far]) {
      expect(e(a), inInclusiveRange(0.03, 0.45));
    }
    final neutral = AwayFanShare.estimate(
      home: home,
      away: away,
      neutral: true,
      tournament: true,
      distanceKm: 500,
    );
    expect(neutral, inInclusiveRange(0.35, 0.65));
  });
}
