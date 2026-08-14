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

  group('weightForRound', () {
    test('World Cup qualifiers carry no round code', () {
      expect(Elo.weightForRound(null), Elo.qualifier);
    });

    test('a friendly is a friendly', () {
      // Regression: the weight was picked with
      //   (isKnockout || round == 'GROUP') ? finals : qualifier
      // so friendlies silently counted as qualifiers and Elo.friendly was dead
      // code — a meaningless friendly moved as much as a qualifier.
      expect(Elo.weightForRound('FRIENDLY'), Elo.friendly);
    });

    test('both finals group stages count as finals', () {
      expect(Elo.weightForRound('GROUP'), Elo.finals);
      // Regression: only the World Cup's 'GROUP' was matched, so a continental
      // finals group game was scored as a qualifier.
      expect(Elo.weightForRound('CGROUP'), Elo.finals);
    });

    test('knockout rounds count as finals, whatever the prefix', () {
      for (final round in ['R32', 'R16', 'QF', 'SF', '3RD', 'FINAL']) {
        expect(Elo.weightForRound(round), Elo.finals, reason: round);
        expect(Elo.weightForRound('C$round'), Elo.finals, reason: 'C$round');
      }
    });

    test('the Nations Cup has its own weight, including its knockouts', () {
      // 'NSF'/'NFINAL' end with knockout suffixes but are not finals football.
      expect(Elo.weightForRound('NGROUP'), Elo.nationsCup);
      expect(Elo.weightForRound('NSF'), Elo.nationsCup);
      expect(Elo.weightForRound('NFINAL'), Elo.nationsCup);
    });

    test('continental qualifying counts as a qualifier', () {
      expect(Elo.weightForRound('CQ'), Elo.qualifier);
    });

    test('prestige orders the weights', () {
      expect(Elo.finals, greaterThan(Elo.qualifier));
      expect(Elo.qualifier, greaterThan(Elo.nationsCup));
      expect(Elo.nationsCup, greaterThan(Elo.friendly));
    });
  });

  group('the table actually moves', () {
    // seedFromRanking spreads nations 4 points per world place, so a delta
    // under ~4 is worth less than a single place. Weights that round to 0 or 1
    // are why the ranking looked frozen.
    int gain(double weight, {int home = 1500, int away = 1500}) =>
        Elo.homeDelta(
          homePoints: home,
          awayPoints: away,
          homeScore: 1,
          awayScore: 0,
          weight: weight,
        );

    test('a favoured side still climbs for a qualifying win', () {
      // A clear favourite (about 3:1) beating the side below them. The old K
      // of 8 gave 8 × 0.24 ≈ 2 — half a world place, so the table looked stuck.
      final delta = gain(Elo.qualifier, home: 1600, away: 1400);
      expect(delta, greaterThanOrEqualTo(4), reason: 'at least a world place');
    });

    test('an overwhelming favourite gains almost nothing, as Elo intends', () {
      // Not a bug: at a 500-point gap the win was ~95% expected, so there is
      // nothing to prove. Raising K must not turn this into a windfall.
      expect(gain(Elo.qualifier, home: 1800, away: 1300), lessThan(4));
    });

    test('an expected friendly win is not silently worth nothing', () {
      final delta = gain(Elo.friendly, home: 1700, away: 1400);
      expect(delta, greaterThan(0));
    });

    test('an even qualifying win is worth at least a place', () {
      // 4 points = one world place at the seeded spread.
      expect(gain(Elo.qualifier), greaterThanOrEqualTo(4));
    });
  });
}
