import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/playoff_paths.dart';

/// The bug this guards: the manager's play-off fixture used to be invented
/// ("you against the best other entrant") instead of being taken from the
/// bracket, so the tie he played and the tie the bracket showed could be
/// different games — and a nation could be knocked out of a tie it was never
/// in. Every entrant must have a path, and that path must be the bracket's.
void main() {
  final ranking = {1: 5, 2: 12, 3: 20, 4: 31, 5: 44, 6: 58};
  final pool = [1, 2, 3, 4, 5, 6];

  List<PlayoffTie> bracketFor(int seed) => WorldCupFinals.playoffBracket(
    byConfederation: const {},
    rankingById: ranking,
    rng: SeededRng(seed),
    pool: pool,
  );

  test('every entrant has a path — nobody is eliminated without a tie', () {
    for (final id in pool) {
      expect(
        playoffPathOf(pool: pool, rankingById: ranking, nationId: id),
        isNotNull,
        reason: 'nation $id is in the pool and must have a tie to play',
      );
    }
  });

  test('a nation outside the pool has no path', () {
    expect(
      playoffPathOf(pool: pool, rankingById: ranking, nationId: 99),
      isNull,
    );
  });

  test('the two best-ranked entrants go straight to a path final', () {
    for (final id in [1, 2]) {
      final path = playoffPathOf(
        pool: pool,
        rankingById: ranking,
        nationId: id,
      )!;
      expect(path.semiSlot, isNull);
    }
    expect(
      playoffPathOf(pool: pool, rankingById: ranking, nationId: 1)!.finalSlot,
      0,
    );
    expect(
      playoffPathOf(pool: pool, rankingById: ranking, nationId: 2)!.finalSlot,
      1,
    );
  });

  test('the path is the bracket: every tie a nation plays is its own', () {
    for (var seed = 0; seed < 25; seed++) {
      final ties = bracketFor(seed);
      final semis = [
        for (final t in ties)
          if (!t.isFinal) t,
      ];
      final finals = [
        for (final t in ties)
          if (t.isFinal) t,
      ];
      for (final id in pool) {
        final path = playoffPathOf(
          pool: pool,
          rankingById: ranking,
          nationId: id,
        )!;
        final slot = path.semiSlot;
        if (slot != null) {
          final semi = semis[slot];
          expect(
            semi.home == id || semi.away == id,
            isTrue,
            reason: 'nation $id should contest semi $slot (seed $seed)',
          );
        }
        // The path final is the manager's only if he got there — as a bye seed,
        // or by winning the semi in his half.
        final reachedFinal = slot == null || semis[slot].winner == id;
        final f = finals[path.finalSlot];
        expect(
          f.home == id || f.away == id,
          reachedFinal,
          reason: 'nation $id in final ${path.finalSlot} (seed $seed)',
        );
      }
    }
  });
}
