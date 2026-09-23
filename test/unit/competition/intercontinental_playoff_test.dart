import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';

void main() {
  // Ranked in id order, so the six-team bracket seeds as 1..6: the semis are
  // (3 v 6) and (4 v 5), and each path final pits a seed against a semi winner.
  final ranking = {1: 5, 2: 12, 3: 20, 4: 31, 5: 44, 6: 58};
  final pool = [1, 2, 3, 4, 5, 6];

  test('a played result overrides the deterministic tie', () {
    final baseline = WorldCupFinals.playoffWinners(pool, ranking, SeededRng(7));

    // Force the weakest side through its semi and then its path final. Both
    // ties have to be named: a played result only stands for a tie the nation
    // is actually in, so forcing only the final would be ignored.
    final forced = WorldCupFinals.playoffWinners(
      pool,
      ranking,
      SeededRng(7),
      playedResults: {
        WorldCupFinals.tieKey(round: 'SEMI', slot: 0): 6,
        WorldCupFinals.tieKey(round: 'FINAL', slot: 0): 6,
      },
    );

    expect(forced, contains(6));
    expect(forced, isNot(equals(baseline)));
  });

  test('a played result for a nation not in the tie is ignored', () {
    final baseline = WorldCupFinals.playoffWinners(pool, ranking, SeededRng(7));
    final bogus = WorldCupFinals.playoffWinners(
      pool,
      ranking,
      SeededRng(7),
      // Nation 2 is in the OTHER path; it cannot win this final.
      playedResults: {WorldCupFinals.tieKey(round: 'FINAL', slot: 0): 2},
    );
    expect(bogus, equals(baseline));
  });

  test('winners still number exactly the available berths', () {
    final w = WorldCupFinals.playoffWinners(pool, ranking, SeededRng(3));
    expect(w, hasLength(2));
  });

  test('the bracket and the winners agree', () {
    final winners = WorldCupFinals.playoffWinners(
      pool,
      ranking,
      SeededRng(11),
    );
    final bracket = WorldCupFinals.playoffBracket(
      byConfederation: const {},
      rankingById: ranking,
      rng: SeededRng(11),
      pool: pool,
    );
    final finalWinners = [
      for (final t in bracket)
        if (t.isFinal) t.winner,
    ];
    expect(finalWinners.toSet(), winners.toSet());
  });

  test('the bracket and the winners agree on a played result too', () {
    final played = {
      WorldCupFinals.tieKey(round: 'SEMI', slot: 0): 6,
      WorldCupFinals.tieKey(round: 'FINAL', slot: 0): 6,
    };
    final winners = WorldCupFinals.playoffWinners(
      pool,
      ranking,
      SeededRng(11),
      playedResults: played,
    );
    final bracket = WorldCupFinals.playoffBracket(
      byConfederation: const {},
      rankingById: ranking,
      rng: SeededRng(11),
      pool: pool,
      playedResults: played,
    );
    final finalWinners = [
      for (final t in bracket)
        if (t.isFinal) t.winner,
    ];
    expect(finalWinners.toSet(), winners.toSet());
    expect(winners, contains(6));
  });
}
