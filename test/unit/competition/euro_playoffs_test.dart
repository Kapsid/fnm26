import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';

/// A row with [points] (and as many goals), for hand-made tables.
GroupStanding row(int id, int points) => GroupStanding(id)
  ..played = 6
  ..won = points ~/ 3
  ..drawn = points % 3
  ..goalsFor = points;

/// A league of [groups] groups of four, nations numbered from [first] in
/// table order, each group's rows on falling points.
List<NcTable> league(String letter, int first, {int groups = 4}) => [
  for (var g = 0; g < groups; g++)
    (
      name: '$letter${g + 1}',
      standings: [
        for (var p = 0; p < 4; p++) row(first + g * 4 + p, 12 - 3 * p - g),
      ],
    ),
];

void main() {
  group('pathCount', () {
    test('24 less the top two of ten groups less one host is three', () {
      expect(EuroPlayoffs.pathCount(size: 24, hosts: 1, groupCount: 10), 3);
    });
    test('two hosts leave two paths; none below zero, none above four', () {
      expect(EuroPlayoffs.pathCount(size: 24, hosts: 2, groupCount: 10), 2);
      expect(EuroPlayoffs.pathCount(size: 24, hosts: 1, groupCount: 12), 0);
      expect(EuroPlayoffs.pathCount(size: 24, hosts: 0, groupCount: 8), 4);
    });
  });

  group('overallRanking', () {
    test('league by league, place by place, across groups on record', () {
      final tables = [...league('B', 100), ...league('A', 0)];
      final order = EuroPlayoffs.overallRanking(tables);
      // League A first, its four group winners first, best record first.
      expect(order.take(4), [0, 4, 8, 12]);
      expect(order.sublist(4, 8), [1, 5, 9, 13]);
      expect(order[16], 100);
      expect(order, hasLength(32));
    });
  });

  group('draw', () {
    final tables = [
      ...league('A', 0),
      ...league('B', 100),
      ...league('C', 200),
      ...league('D', 300, groups: 2),
    ];

    test('one path per league, its group winners first and seeded', () {
      final paths = EuroPlayoffs.draw(
        tables: tables,
        // League A's top two in every group qualified directly.
        ineligible: {0, 1, 4, 5, 8, 9, 12, 13},
        count: 3,
        rng: SeededRng(1),
      );
      expect(paths.map((p) => p.letter), ['A', 'B', 'C']);
      // A: the best of League A that did not qualify, on the overall ranking.
      expect(paths[0].seeds, [2, 6, 10, 14]);
      // B and C: their four group winners, seeded best first.
      expect(paths[1].seeds, [100, 104, 108, 112]);
      expect(paths[2].seeds, [200, 204, 208, 212]);
      for (final p in paths) {
        expect(p.finalHostSemi, inInclusiveRange(0, 1));
      }
    });

    test('hosts and direct qualifiers are never drawn', () {
      final paths = EuroPlayoffs.draw(
        tables: tables,
        ineligible: {100, 2, 6},
        count: 3,
        rng: SeededRng(2),
      );
      final drawn = {for (final p in paths) ...p.seeds};
      expect(drawn.intersection({100, 2, 6}), isEmpty);
      expect(drawn, hasLength(12));
    });

    test('a short league fills from the league below, best ranked first', () {
      // League A has only two sides left; B's winners come up.
      final ineligible = {
        for (var i = 0; i < 16; i++)
          if (i != 15 && i != 11) i,
      };
      final paths = EuroPlayoffs.draw(
        tables: tables,
        ineligible: ineligible,
        count: 3,
        rng: SeededRng(3),
      );
      expect(paths[0].seeds.take(2).toSet(), {11, 15});
      expect(paths[0].seeds.skip(2), [100, 104]);
      // B keeps its two other group winners first, then its best runners-up.
      expect(paths[1].seeds, [108, 112, 101, 105]);
      // No side in two paths.
      final all = [for (final p in paths) ...p.seeds];
      expect(all.toSet(), hasLength(all.length));
    });

    test('a league with too few sides below fills from anywhere left', () {
      // Only League D (eight sides) and League A's last two are eligible.
      final ineligible = {
        for (final t in tables)
          for (final s in t.standings)
            if (s.nationId < 300 && s.nationId != 3 && s.nationId != 7)
              s.nationId,
      };
      final paths = EuroPlayoffs.draw(
        tables: tables,
        ineligible: ineligible,
        count: 3,
        rng: SeededRng(4),
      );
      // Ten sides make two full paths, never a short one.
      expect(paths, hasLength(2));
      expect(paths[0].seeds, hasLength(4));
      expect(paths[0].seeds.take(2).toSet(), {3, 7});
    });

    test('a nation the cup never knew comes after every side it did', () {
      final paths = EuroPlayoffs.draw(
        tables: league('A', 0),
        ineligible: {for (var i = 0; i < 14; i++) i},
        count: 1,
        rng: SeededRng(5),
        fallback: [999, 998],
      );
      expect(paths.single.seeds, [14, 15, 999, 998]);
    });

    test('is deterministic', () {
      PlayoffPath one(int seed) => EuroPlayoffs.draw(
        tables: tables,
        ineligible: const {},
        count: 3,
        rng: SeededRng(seed),
      ).first;
      expect(one(9).finalHostSemi, one(9).finalHostSemi);
      expect(one(9).seeds, one(9).seeds);
    });
  });

  test('semis: seed 1 hosts seed 4, seed 2 hosts seed 3', () {
    const path = (letter: 'B', seeds: [1, 2, 3, 4], finalHostSemi: 1);
    expect(EuroPlayoffs.semis(path), [(1, 4), (2, 3)]);
  });

  test('paths survive storage: rows and back', () {
    const paths = <PlayoffPath>[
      (letter: 'A', seeds: [1, 2, 3, 4], finalHostSemi: 1),
      (letter: 'B', seeds: [5, 6, 7, 8], finalHostSemi: 0),
    ];
    final slots = EuroPlayoffs.toSlots(paths);
    expect(slots, hasLength(10));
    final back = EuroPlayoffs.fromSlots(slots.reversed.toList());
    expect(back.map((p) => p.letter), ['A', 'B']);
    expect(back[0].seeds, [1, 2, 3, 4]);
    expect(back[0].finalHostSemi, 1);
    expect(back[1].finalHostSemi, 0);
  });

  group('resolvedDraw', () {
    DrawSlot slot(String g, int pos, {int? id, String? key, int? resolved}) => (
      groupName: g,
      position: pos,
      nationId: id,
      placeholderKey: key,
      resolvedNationId: resolved,
    );

    test('stays empty while a placeholder is unresolved', () {
      final draw = EuroPlayoffs.resolvedDraw([
        slot('A', 0, id: 1),
        slot('A', 1, id: 2),
        slot('A', 2, id: 3),
        slot('A', 3, key: EuroPlayoffs.placeholderKey('B')),
      ], rngSeed: 7);
      expect(draw.groups, isEmpty);
    });

    test('puts each winner in the exact slot its placeholder held', () {
      final slots = [
        slot('B', 0, id: 10),
        slot('B', 1, id: 11),
        slot('B', 2, key: EuroPlayoffs.placeholderKey('A'), resolved: 77),
        slot('B', 3, id: 12),
        slot('A', 3, key: EuroPlayoffs.placeholderKey('C'), resolved: 88),
        slot('A', 0, id: 1),
        slot('A', 1, id: 2),
        slot('A', 2, id: 3),
      ];
      final draw = EuroPlayoffs.resolvedDraw(slots, rngSeed: 7);
      expect(draw.groups.map((g) => g.name), ['A', 'B']);
      expect(draw.groups[0].nationIds, [1, 2, 3, 88]);
      expect(draw.groups[1].nationIds, [10, 11, 77, 12]);
      // A full round robin of real sides, three matchdays.
      for (final g in draw.groups) {
        expect(g.fixtures, hasLength(6));
        final sides = {for (final f in g.fixtures) ...[f.$2, f.$3]};
        expect(sides, g.nationIds.toSet());
        expect({for (final f in g.fixtures) f.$1}, {1, 2, 3});
      }
    });
  });

  test('placeholder keys and pseudo ids round-trip', () {
    expect(EuroPlayoffs.letterOf(EuroPlayoffs.placeholderKey('C')), 'C');
    expect(EuroPlayoffs.letterOf('finalHost:1'), isNull);
    expect(EuroPlayoffs.pathOfPseudo(EuroPlayoffs.pseudoId(2)), 2);
    expect(EuroPlayoffs.pathOfPseudo(-1), isNull);
    expect(EuroPlayoffs.pathOfPseudo(5), isNull);
  });
}
