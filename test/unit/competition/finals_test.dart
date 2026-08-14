import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';

GroupStanding _standing(int id, {required int points, int gd = 0, int gf = 0}) {
  final s = GroupStanding(id)
    ..won = points ~/ 3
    ..drawn = points % 3
    ..goalsFor = gf
    ..goalsAgainst = gf - gd;
  return s;
}

void main() {
  group('Qualification.qualifiers', () {
    test('single league takes the top N by table order', () {
      final table = [
        _standing(1, points: 18),
        _standing(2, points: 15),
        _standing(3, points: 12),
        _standing(4, points: 9),
        _standing(5, points: 6),
      ];
      expect(Qualification.qualifiers([table], 3), [1, 2, 3]);
    });

    test('multi-group takes all winners then best runners-up', () {
      final a = [_standing(1, points: 18), _standing(2, points: 9)];
      final b = [_standing(3, points: 15), _standing(4, points: 12)];
      // 3 berths: both winners (1,3) + best runner-up (4 has more pts than 2).
      expect(Qualification.qualifiers([a, b], 3), [1, 3, 4]);
    });
  });

  test('direct finals berths sum to 46 (+2 playoff = 48)', () {
    expect(QualificationFormat.totalFinalsBerths, 46);
    expect(
      QualificationFormat.totalFinalsBerths + QualificationFormat.playoffBerths,
      48,
    );
  });

  group('WorldCupFinals', () {
    test('draws 48 qualifiers into 12 groups of 4', () {
      final ids = List.generate(48, (i) => i + 1);
      final ranking = {for (final id in ids) id: id};
      final draw = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: ranking,
        rngSeed: 42,
      );
      expect(draw.groups, hasLength(12));
      for (final g in draw.groups) {
        expect(g.nationIds, hasLength(4));
        expect(g.fixtures, hasLength(6)); // 4 teams single round-robin
      }
      // Every nation placed exactly once.
      final placed = draw.groups.expand((g) => g.nationIds).toList();
      expect(placed.toSet(), ids.toSet());
    });

    test('draws 10 qualifiers into 2 groups of 5 (Copa América)', () {
      final ids = List.generate(10, (i) => i + 1);
      final ranking = {for (final id in ids) id: id};
      final draw = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: ranking,
        rngSeed: 7,
        perGroup: 5,
      );
      expect(draw.groups, hasLength(2));
      for (final g in draw.groups) {
        expect(g.nationIds, hasLength(5));
        expect(g.fixtures, hasLength(10)); // 5 teams single round-robin
      }
      // Nobody left out: all ten placed exactly once.
      final placed = draw.groups.expand((g) => g.nationIds).toList();
      expect(placed, hasLength(10));
      expect(placed.toSet(), ids.toSet());
    });

    test('copaQuarters takes the top four of two groups into 4 QF ties', () {
      List<GroupStanding> group(List<int> ids) {
        final rows = [for (final id in ids) GroupStanding(id)];
        // Give them descending points so table order == list order.
        for (var i = 0; i < rows.length; i++) {
          rows[i].won = rows.length - i;
        }
        return rows;
      }

      final a = group([1, 2, 3, 4, 5]);
      final b = group([6, 7, 8, 9, 10]);
      final ties = WorldCupFinals.copaQuarters([a, b]);
      expect(ties, hasLength(4)); // 8 teams → 4 quarter-finals
      final teams = ties.expand((t) => [t.$1, t.$2]).toList();
      expect(teams, hasLength(8));
      // The two group's fifth-placed sides (5 and 10) are the only ones out.
      expect(teams, isNot(contains(5)));
      expect(teams, isNot(contains(10)));
      // Winners kept apart: A1 (1) and B1 (6) are not drawn against each other.
      expect(
        ties.any((t) => {t.$1, t.$2}.containsAll({1, 6})),
        isFalse,
      );
    });

    test('co-hosts are each seeded into their own opening group', () {
      final ids = List.generate(48, (i) => i + 1);
      final ranking = {for (final id in ids) id: id};
      // Two low-ranked co-hosts (40 and 45) should still open Groups A and B.
      final draw = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: ranking,
        rngSeed: 42,
        hosts: const [40, 45],
      );
      expect(draw.groups[0].nationIds, contains(40));
      expect(draw.groups[1].nationIds, contains(45));
      // And not doubled up in the same group.
      expect(draw.groups[0].nationIds, isNot(contains(45)));
    });

    test(
      'round of 32 seeds 24 group qualifiers + 8 best thirds into 16 ties',
      () {
        // 12 groups of 4; group i gives its teams descending points so ranks are
        // well-defined across groups.
        final groups = [
          for (var i = 0; i < 12; i++)
            [
              _standing(i * 4 + 1, points: 9, gf: 12 - i),
              _standing(i * 4 + 2, points: 6, gf: 12 - i),
              _standing(i * 4 + 3, points: 3, gf: 12 - i),
              _standing(i * 4 + 4, points: 0, gf: 12 - i),
            ],
        ];
        final ties = WorldCupFinals.roundOf32(groups);
        expect(ties, hasLength(16)); // 32 teams → 16 ties
        // 32 distinct teams: all 12 winners, all 12 runners-up, 8 of 12 thirds.
        final teams = ties.expand((t) => [t.$1, t.$2]).toSet();
        expect(teams, hasLength(32));
        // No fourth-placed team qualifies.
        expect(teams.any((id) => id % 4 == 0), isFalse);
      },
    );

    test('round of 16 pairs winners with runners-up across groups', () {
      final groups = [
        for (var i = 0; i < 8; i++)
          [
            _standing(i * 2 + 1, points: 9),
            _standing(i * 2 + 2, points: 6),
          ],
      ];
      final ties = WorldCupFinals.roundOf16(groups);
      expect(ties, hasLength(8));
      // 1st tie: winner of A (1) vs runner-up of B (4).
      expect(ties.first, (1, 4));
    });

    test('resolveTie always yields a winner', () {
      final level = WorldCupFinals.resolveTie(1, 1, SeededRng(7));
      expect(level.$1 == level.$2, isFalse);
      expect(WorldCupFinals.resolveTie(2, 0, SeededRng(7)), (2, 0));
    });

    test('knockoutFromGroups pairs winners vs runners-up (4 groups → QF)', () {
      final groups = [
        for (var i = 0; i < 4; i++)
          [
            _standing(i * 2 + 1, points: 9),
            _standing(i * 2 + 2, points: 6),
          ],
      ];
      final ties = WorldCupFinals.knockoutFromGroups(groups);
      expect(ties, hasLength(4)); // 8 teams → quarter-finals
      expect(ties.first, (1, 4)); // winner A vs runner-up B
      // Every qualifier appears exactly once.
      final teams = ties.expand((t) => [t.$1, t.$2]).toSet();
      expect(teams, {1, 2, 3, 4, 5, 6, 7, 8});
    });

    test('knockoutFromGroups handles 2 groups → semi-finals', () {
      final groups = [
        [_standing(1, points: 9), _standing(2, points: 6)],
        [_standing(3, points: 9), _standing(4, points: 6)],
      ];
      final ties = WorldCupFinals.knockoutFromGroups(groups);
      expect(ties, hasLength(2));
      expect(ties, [(1, 4), (3, 2)]);
    });
  });

  group('playoffWinners', () {
    // Six entrants with realistic world-ranking gaps (id 1 strongest).
    final pool = [1, 2, 3, 4, 5, 6];
    final ranks = {1: 20, 2: 35, 3: 50, 4: 65, 5: 80, 6: 95};

    test('returns exactly the playoff berths, drawn from the field', () {
      final w = WorldCupFinals.playoffWinners(pool, ranks, SeededRng(7));
      expect(w, hasLength(2));
      expect(pool, containsAll(w));
      expect(w.toSet(), hasLength(2)); // no duplicates
    });

    test('is deterministic for a given seed', () {
      final a = WorldCupFinals.playoffWinners(pool, ranks, SeededRng(42));
      final b = WorldCupFinals.playoffWinners(pool, ranks, SeededRng(42));
      expect(a, b);
    });

    test('stronger seeds win the play-off far more often', () {
      var topTwo = 0;
      for (var seed = 0; seed < 200; seed++) {
        final w = WorldCupFinals.playoffWinners(pool, ranks, SeededRng(seed));
        // The two best-ranked (1 and 2) get byes to the finals and are favoured.
        topTwo += w.where((id) => id <= 2).length;
      }
      // Out of 400 winner slots, the two seeds should take a clear majority.
      expect(topTwo / 400, greaterThan(0.6));
    });
  });

  group('playoffBracket', () {
    // Build one qualifying group per confederation with playoff entrants, each
    // sized (finalsBerths + playoffEntrants) so its lowest-ranked entrants spill
    // into the intercontinental play-off pool. Six confederations contribute:
    // CONMEBOL 1, CONCACAF 2, CAF 1, AFC 1, OFC 1 → a six-team field.
    var nextId = 1;
    final byConfederation = <Confederation, List<List<GroupStanding>>>{};
    final ranks = <int, int>{};
    final poolIds = <int>[];
    for (final conf in Confederation.values) {
      final fmt = QualificationFormat.forConfederation(conf);
      final n = fmt.finalsBerths + fmt.playoffEntrants;
      final rows = <GroupStanding>[];
      for (var i = 0; i < n; i++) {
        final id = nextId++;
        rows.add(_standing(id, points: (n - i) * 3));
        ranks[id] = id; // lower id = stronger
        // Anything beyond the direct berths is a play-off entrant.
        if (i >= fmt.finalsBerths) poolIds.add(id);
      }
      byConfederation[conf] = [rows];
    }

    test('the six lowest also-rans form the play-off field', () {
      expect(poolIds, hasLength(6));
    });

    test('records two semis and two path finals', () {
      final ties = WorldCupFinals.playoffBracket(
        byConfederation: byConfederation,
        rankingById: ranks,
        rng: SeededRng(7),
      );
      expect(ties, hasLength(4));
      expect(ties.where((t) => t.isFinal), hasLength(2));
      for (final t in ties) {
        expect(poolIds, contains(t.winner));
        expect(t.winner, anyOf(t.home, t.away));
      }
    });

    test('is deterministic for a given seed', () {
      List<PlayoffTie> run() => WorldCupFinals.playoffBracket(
        byConfederation: byConfederation,
        rankingById: ranks,
        rng: SeededRng(42),
      );
      expect(run().map((t) => t.winner), run().map((t) => t.winner));
    });

    test('path-final winners are exactly selectFinalists play-off qualifiers', () {
      const seed = 123;
      final ties = WorldCupFinals.playoffBracket(
        byConfederation: byConfederation,
        rankingById: ranks,
        rng: SeededRng(seed),
      );
      final displayWinners = [
        for (final t in ties)
          if (t.isFinal) t.winner,
      ].toSet();
      // The same seed must reproduce the finalist selection's play-off outcome,
      // so the finals-draw screen shows the nations that actually got through.
      final finalists = WorldCupFinals.selectFinalists(
        byConfederation: byConfederation,
        rankingById: ranks,
        hosts: const [],
        playoffRng: SeededRng(seed),
      );
      final actualPlayoffQualifiers = finalists.where(poolIds.contains).toSet();
      expect(displayWinners, actualPlayoffQualifiers);
      expect(displayWinners, hasLength(2));
    });
  });
}
