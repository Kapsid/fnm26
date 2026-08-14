import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:flutter_test/flutter_test.dart';

/// A standings row for [id] carrying [points], so a boundary with fewer places
/// than candidates can be checked to pick the right sides.
GroupStanding _row(int id, {int points = 0}) =>
    GroupStanding(id)..won = points ~/ 3;

Nation _n(int id, int ranking) => Nation(
  id: id,
  name: 'N$id',
  code: 'N$id',
  confederation: Confederation.europe,
  ranking: ranking,
);

void main() {
  group('NationsCup', () {
    test('group name encodes the league tier', () {
      expect(NationsCup.tierOfGroupName('A1'), 0);
      expect(NationsCup.tierOfGroupName('B3'), 1);
      expect(NationsCup.tierOfGroupName('C2'), 2);
      expect(NationsCup.leagueLetter(0), 'A');
      expect(NationsCup.leagueLetter(2), 'C');
    });

    group('lowestTier', () {
      // Three European leagues (tiers 0..2) plus a deeper South American
      // ladder that must not be mistaken for Europe's.
      final tiers = {
        1: 0, 2: 0, // Europe League A
        3: 1, // Europe League B
        4: 2, // Europe League C — the bottom
        5: 0, 6: 1, 7: 2, 8: 3, // South America, four leagues deep
      };
      Confederation? confOf(int id) =>
          id <= 4 ? Confederation.europe : Confederation.southAmerica;

      test('is the deepest league of that confederation alone', () {
        expect(
          NationsCup.lowestTier(
            tiers: tiers,
            confederation: Confederation.europe,
            confederationOf: confOf,
          ),
          2,
          reason: "South America's fourth league must not deepen Europe's",
        );
        expect(
          NationsCup.lowestTier(
            tiers: tiers,
            confederation: Confederation.southAmerica,
            confederationOf: confOf,
          ),
          3,
        );
      });

      test('only the bottom league has no relegation', () {
        bool lowest(String group) => NationsCup.isLowestLeague(
          groupName: group,
          tiers: tiers,
          confederation: Confederation.europe,
          confederationOf: confOf,
        );
        expect(lowest('A1'), isFalse, reason: 'League A drops into B');
        expect(lowest('B1'), isFalse, reason: 'League B drops into C');
        expect(lowest('C1'), isTrue, reason: 'League C has nowhere to fall');
      });

      test('a confederation with a single league is its own bottom', () {
        expect(
          NationsCup.isLowestLeague(
            groupName: 'A1',
            tiers: {1: 0, 2: 0},
            confederation: Confederation.oceania,
            confederationOf: (_) => Confederation.oceania,
          ),
          isTrue,
        );
      });

      test('an unladdered confederation is its own bottom', () {
        expect(
          NationsCup.lowestTier(
            tiers: const {},
            confederation: Confederation.africa,
            confederationOf: (_) => Confederation.africa,
          ),
          0,
        );
      });
    });

    test('seeds leagues of sixteen by ranking', () {
      final nations = [for (var i = 1; i <= 40; i++) _n(i, i)];
      final tiers = NationsCup.seedTiers(nations, (n) => n.ranking);
      expect(tiers[1], 0); // best → League A
      expect(tiers[16], 0);
      expect(tiers[17], 1); // 17th → League B
      expect(tiers[33], 2); // 33rd → League C
    });

    test('promotes group winners and relegates group bottoms', () {
      // Two leagues: nations 1 (A) and 2 (B). Winner of B climbs, bottom of A
      // drops; the lowest league never relegates, the top never promotes.
      final tiers = {1: 0, 2: 0, 3: 1, 4: 1};
      final next = NationsCup.promoteRelegate(
        tiers: tiers,
        groups: [
          (tier: 0, winner: _row(1), bottom: _row(2)), // A: 2 relegated to B
          // B: 3 promoted to A, 4 stays (lowest league)
          (tier: 1, winner: _row(3), bottom: _row(4)),
        ],
      );
      expect(next[1], 0); // A winner stays top
      expect(next[2], 1); // relegated to B
      expect(next[3], 0); // promoted to A
      expect(next[4], 1); // lowest league, no further relegation
    });

    test('a boundary moves as many up as it sends down', () {
      // League B has two groups, League C only one — the old rule sent two down
      // and brought one up, so C grew by one every cycle. Only the WORSE of B's
      // two bottom sides now drops, and C's single winner takes its place.
      final tiers = {1: 0, 2: 0, 3: 0, 4: 0, 5: 1, 6: 1};
      final next = NationsCup.promoteRelegate(
        tiers: tiers,
        groups: [
          (tier: 0, winner: _row(1), bottom: _row(2, points: 9)),
          (tier: 0, winner: _row(3), bottom: _row(4, points: 3)),
          (tier: 1, winner: _row(5), bottom: _row(6)),
        ],
      );
      expect(next[4], 1); // the worse bottom side goes down
      expect(next[2], 0); // the better one is spared — there was one place
      expect(next[5], 0); // C's winner fills it
      expect(next.values.where((t) => t == 0).length, 4); // sizes hold
      expect(next.values.where((t) => t == 1).length, 2);
    });

    test('empty results leave the ladder unchanged', () {
      final tiers = {1: 0, 2: 1};
      expect(NationsCup.promoteRelegate(tiers: tiers, groups: const []), tiers);
    });

    test('single-league promo/relegation swaps with the neighbours', () {
      // Player in League B (tier 1). League A = {1,2}, B = {3,4,5,6}, C = {7,8}.
      // rank == nation id (lower = stronger).
      final tiers = {1: 0, 2: 0, 3: 1, 4: 1, 5: 1, 6: 1, 7: 2, 8: 2};
      final next = NationsCup.promoteRelegateLeague(
        tiers: tiers,
        playerTier: 1,
        winners: [3], // League B winner climbs to A
        bottoms: [6], // League B bottom drops to C
        rankOf: (id) => id,
      );
      expect(next[3], 0); // promoted to A
      expect(next[2], 1); // A's weakest (id 2) drops to B
      expect(next[6], 2); // relegated to C
      expect(next[7], 1); // C's strongest (id 7) rises to B
      // League sizes stay put (2 / 4 / 2).
      int count(int t) => next.values.where((v) => v == t).length;
      expect([count(0), count(1), count(2)], [2, 4, 2]);
    });
  });
}
