import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/round_robin.dart';

/// A calendar2 group spreads every side's home and away games: never three
/// at home (or away) running, the meetings and rounds unchanged.
void main() {
  int worstRun(List<List<Pairing>> rounds, List<int> teams) {
    var worst = 0;
    for (final t in teams) {
      bool? last;
      var run = 0;
      for (final r in rounds) {
        for (final (h, a) in r) {
          if (h != t && a != t) continue;
          final home = h == t;
          run = home == last ? run + 1 : 1;
          last = home;
          if (run > worst) worst = run;
        }
      }
    }
    return worst;
  }

  for (final n in [3, 4, 5, 6]) {
    test('a group of $n', () {
      for (var seed = 0; seed < 25; seed++) {
        final teams = [for (var i = 0; i < n; i++) 10 + i];
        final plain = doubleRoundRobin(teams, rng: SeededRng(seed));
        final balanced = balancedDoubleRoundRobin(teams, rng: SeededRng(seed));
        expect(balanced, hasLength(plain.length));
        expect(worstRun(balanced, teams), lessThanOrEqualTo(n == 4 ? 2 : 2));
        // Every side meets every other once at home and once away.
        final games = {
          for (final r in balanced)
            for (final (h, a) in r) '$h-$a',
        };
        expect(games, hasLength(n * (n - 1)));
        // Each round still holds the same meetings.
        for (var r = 0; r < plain.length ~/ 2; r++) {
          expect(
            {
              for (final (h, a) in balanced[r])
                ({h, a}.toList()..sort()).join(),
            },
            {
              for (final (h, a) in plain[r]) ({h, a}.toList()..sort()).join(),
            },
          );
        }
      }
    });
  }

  test('the same seed draws the same schedule', () {
    final teams = [1, 2, 3, 4, 5];
    expect(
      balancedDoubleRoundRobin(teams, rng: SeededRng(9)),
      balancedDoubleRoundRobin(teams, rng: SeededRng(9)),
    );
  });

  test(
    'the stored patterns are what the full search finds, for every size',
    () {
      for (var n = 3; n <= 6; n++) {
        expect(balancedPatterns[n], searchBalancedPattern(n), reason: 'n=$n');
      }
    },
  );

  test('a draw never searches on the device: a group of six is instant', () {
    final teams = [11, 22, 33, 44, 55, 66];
    final sw = Stopwatch()..start();
    for (var s = 0; s < 50; s++) {
      balancedDoubleRoundRobin(teams, rng: SeededRng(s));
    }
    // 50 groups of six searched took about five seconds here (1.1.2).
    expect(sw.elapsedMilliseconds, lessThan(200));
  });
}
