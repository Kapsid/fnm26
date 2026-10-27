import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';

/// The El Salvador report: the play-off bracket showed El Salvador beating the
/// UAE for a finals place, and El Salvador was not in the finals.
///
/// The ties the manager does not play are decided by the model, all on one
/// shared rng stream. A tie he HAS played used to be skipped on that stream,
/// so every tie after it drew a different number from the one it drew while
/// his tie was still to come, and could change winner. The bracket he looked
/// at before kick-off was not the one that filled the finals.
void main() {
  // Six entrants, best-ranked first: 1 and 2 have byes, 3 v 6 and 4 v 5 meet
  // in the semis.
  const pool = [101, 102, 103, 104, 105, 106];
  final ranking = {for (var i = 0; i < pool.length; i++) pool[i]: 40 + i * 9};

  String semi(int slot) => WorldCupFinals.tieKey(
    round: WorldCupFinals.playoffSemiRound,
    slot: slot,
  );
  String fin(int slot) => WorldCupFinals.tieKey(
    round: WorldCupFinals.playoffFinalRound,
    slot: slot,
  );

  List<PlayoffTie> bracket(int seed, Map<String, int> played) =>
      WorldCupFinals.playoffBracket(
        byConfederation: const {},
        rankingById: ranking,
        rng: SeededRng(seed),
        hostBerths: const {},
        pool: pool,
        playedResults: played,
      );

  List<int> winners(int seed, Map<String, int> played) =>
      WorldCupFinals.playoffWinners(
        pool,
        ranking,
        SeededRng(seed),
        playedResults: played,
      );

  test('playing your own tie never changes a tie you were not in', () {
    var shifted = 0;
    for (var seed = 1; seed <= 400; seed++) {
      final before = bracket(seed, const {});
      // Each tie the manager could be in, played to the very result the
      // bracket projected for it. Nothing changed on the pitch, so nothing
      // anywhere in the bracket may change.
      final keys = [semi(0), semi(1), fin(0), fin(1)];
      for (var t = 0; t < keys.length; t++) {
        final played = {keys[t]: before[t].winner};
        final after = bracket(seed, played);
        for (var u = 0; u < before.length; u++) {
          if (before[u].winner != after[u].winner) shifted++;
          expect(
            (after[u].home, after[u].away, after[u].winner),
            (before[u].home, before[u].away, before[u].winner),
            reason: 'seed $seed: playing ${keys[t]} moved tie $u',
          );
        }
        // And the finals places are the two path-final winners shown.
        expect(winners(seed, played), [
          for (final tie in after)
            if (tie.isFinal) tie.winner,
        ]);
      }
    }
    expect(shifted, 0);
  });

  test('a played upset stands, and only the ties it feeds can move', () {
    for (var seed = 1; seed <= 200; seed++) {
      final before = bracket(seed, const {});
      // Semi 0 goes the other way from the projection.
      final upset = before[0].winner == before[0].home
          ? before[0].away
          : before[0].home;
      final after = bracket(seed, {semi(0): upset});
      expect(after[0].winner, upset);
      // The other half of the bracket is untouched.
      expect(after[1], before[1], reason: 'seed $seed: semi 1');
      expect(after[3], before[3], reason: 'seed $seed: path final 1');
      // Path final 0 now has the upset winner in it.
      expect(after[2].away, upset);
    }
  });

  test('with nothing played, the bracket is the one it always was', () {
    // Instant resolution (the manager not in the play-off) must keep every
    // stored finals field and shown bracket of an existing save: same stream,
    // same order, same outcomes as before the fix.
    for (var seed = 1; seed <= 200; seed++) {
      final rng = SeededRng(seed);
      int match(int a, int b) {
        final ra = ranking[a]!;
        final rb = ranking[b]!;
        final winA = (0.5 + (rb - ra) * 0.006).clamp(0.2, 0.8);
        return rng.chance(winA) ? a : b;
      }

      final w1 = match(103, 106);
      final w2 = match(104, 105);
      final f1 = match(101, w1);
      final f2 = match(102, w2);
      expect(winners(seed, const {}), [f1, f2], reason: 'seed $seed');
    }
  });
}
