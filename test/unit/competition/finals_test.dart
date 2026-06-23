import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
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

  test('finals berths sum to 32', () {
    expect(QualificationFormat.totalFinalsBerths, 32);
  });

  group('WorldCupFinals', () {
    test('draws 32 qualifiers into 8 groups of 4', () {
      final ids = List.generate(32, (i) => i + 1);
      final ranking = {for (final id in ids) id: id};
      final draw = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: ranking,
        rngSeed: 42,
      );
      expect(draw.groups, hasLength(8));
      for (final g in draw.groups) {
        expect(g.nationIds, hasLength(4));
        expect(g.fixtures, hasLength(6)); // 4 teams single round-robin
      }
      // Every nation placed exactly once.
      final placed = draw.groups.expand((g) => g.nationIds).toList();
      expect(placed.toSet(), ids.toSet());
    });

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
  });
}
