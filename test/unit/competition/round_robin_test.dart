import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/round_robin.dart';

void main() {
  Map<String, int> countPairs(List<List<Pairing>> rounds) {
    final counts = <String, int>{};
    for (final round in rounds) {
      for (final (h, a) in round) {
        counts['$h-$a'] = (counts['$h-$a'] ?? 0) + 1;
      }
    }
    return counts;
  }

  test('even groups: each ordered pair plays exactly once (home & away)', () {
    final teams = [1, 2, 3, 4, 5, 6];
    final rounds = doubleRoundRobin(teams, rng: SeededRng(1));

    expect(rounds.length, 2 * (teams.length - 1)); // 10 matchdays
    for (final r in rounds) {
      expect(r.length, teams.length ~/ 2); // 3 games each
    }
    final counts = countPairs(rounds);
    for (final a in teams) {
      for (final b in teams) {
        if (a != b) expect(counts['$a-$b'], 1, reason: '$a-$b');
      }
    }
  });

  test('odd groups: a bye sits one team out; pairs still play twice', () {
    final teams = [1, 2, 3, 4, 5];
    final rounds = doubleRoundRobin(teams, rng: SeededRng(2));

    expect(rounds.length, 2 * teams.length); // 10
    for (final r in rounds) {
      expect(r.length, teams.length ~/ 2); // 2 games (one byes)
    }
    final counts = countPairs(rounds);
    for (final a in teams) {
      for (final b in teams) {
        if (a != b) expect(counts['$a-$b'], 1, reason: '$a-$b');
      }
    }
  });

  test('deterministic for a given seed', () {
    final a = doubleRoundRobin([1, 2, 3, 4], rng: SeededRng(7));
    final b = doubleRoundRobin([1, 2, 3, 4], rng: SeededRng(7));
    expect(a.toString(), b.toString());
  });
}
