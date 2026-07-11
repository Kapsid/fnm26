import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/ranking/elo.dart';

void main() {
  test('a win over an equal side gains points; the loser loses as many', () {
    final delta = Elo.homeDelta(
      homePoints: 1500,
      awayPoints: 1500,
      homeScore: 2,
      awayScore: 0,
      weight: Elo.qualifier,
    );
    expect(delta, greaterThan(0));
    // Exchange is zero-sum: the away side moves by -delta.
    expect(delta, (Elo.qualifier * 0.5).round());
  });

  test('beating a stronger side gains more than beating a weaker one', () {
    final upset = Elo.homeDelta(
      homePoints: 1400,
      awayPoints: 1800,
      homeScore: 1,
      awayScore: 0,
      weight: Elo.finals,
    );
    final expected = Elo.homeDelta(
      homePoints: 1800,
      awayPoints: 1400,
      homeScore: 1,
      awayScore: 0,
      weight: Elo.finals,
    );
    expect(upset, greaterThan(expected));
  });

  test('a draw with a much stronger side is a net gain', () {
    final delta = Elo.homeDelta(
      homePoints: 1300,
      awayPoints: 1800,
      homeScore: 1,
      awayScore: 1,
      weight: Elo.qualifier,
    );
    expect(delta, greaterThan(0));
  });

  test('bigger games move more points', () {
    int gain(double weight) => Elo.homeDelta(
          homePoints: 1500,
          awayPoints: 1500,
          homeScore: 1,
          awayScore: 0,
          weight: weight,
        );
    expect(gain(Elo.finals), greaterThan(gain(Elo.friendly)));
  });

  test('seed points fall as the seed ranking worsens', () {
    expect(Elo.seedFromRanking(1), greaterThan(Elo.seedFromRanking(50)));
    expect(Elo.seedFromRanking(300), 1000); // clamped floor
  });
}
