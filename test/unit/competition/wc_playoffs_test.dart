import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';

/// A row with [points] (and as many goals), for hand-made tables.
GroupStanding row(int id, int points) => GroupStanding(id)
  ..played = 6
  ..won = points ~/ 3
  ..drawn = points % 3
  ..goalsFor = points;

/// Europe's qualifying: [groups] groups of four, nation `g*10 + p` finishing
/// p-th in group g, the runners-up's records falling with the group index.
List<List<GroupStanding>> qualifying({int groups = 12}) => [
  for (var g = 0; g < groups; g++)
    [for (var p = 0; p < 4; p++) row(g * 10 + p, 18 - 4 * p - (g % 4))],
];

/// A Nations Cup league of four groups of four, nations from [first].
List<NcTable> league(String letter, int first) => [
  for (var g = 0; g < 4; g++)
    (
      name: '$letter${g + 1}',
      standings: [
        for (var p = 0; p < 4; p++) row(first + g * 4 + p, 12 - 3 * p - g),
      ],
    ),
];

void main() {
  group('UefaWcPlayoffs counts', () {
    test('twelve groups, fewer only below four sides a group', () {
      expect(UefaWcPlayoffs.groupCount(53), 12);
      expect(UefaWcPlayoffs.groupCount(51), 12);
      expect(UefaWcPlayoffs.groupCount(40), 10);
    });
    test('paths = 16 less the group winners less the European hosts', () {
      expect(UefaWcPlayoffs.pathCount(berths: 16, groupCount: 12), 4);
      expect(UefaWcPlayoffs.pathCount(berths: 15, groupCount: 12), 3);
      expect(UefaWcPlayoffs.pathCount(berths: 13, groupCount: 12), 1);
      expect(UefaWcPlayoffs.pathCount(berths: 11, groupCount: 12), 0);
      expect(UefaWcPlayoffs.pathCount(berths: 16, groupCount: 8), 4);
    });
    test('pathsFor: Europe on calendar2 only', () {
      expect(
        UefaWcPlayoffs.pathsFor(
          calendar2: true,
          confederation: Confederation.europe,
          hosts: 1,
          groupCount: 12,
        ),
        3,
      );
      expect(
        UefaWcPlayoffs.pathsFor(
          calendar2: false,
          confederation: Confederation.europe,
          hosts: 0,
          groupCount: 12,
        ),
        0,
      );
      expect(
        UefaWcPlayoffs.pathsFor(
          calendar2: true,
          confederation: Confederation.africa,
          hosts: 0,
          groupCount: 9,
        ),
        0,
      );
    });
  });

  group('UefaWcPlayoffs entrants', () {
    final groups = qualifying();
    final winners = {for (final g in groups) g.first.nationId};
    final runnersUp = {for (final g in groups) g[1].nationId};

    test('twelve runners-up and the four best Nations Cup group winners '
        'that neither qualified nor finished runner-up', () {
      final ent = UefaWcPlayoffs.entrants(
        groups: groups,
        // League A's winners are 1000, 1004, ...; 1000 is a group winner of
        // qualifying too (ineligible) and 1004 a runner-up in it.
        ncTables: [...league('A', 1000), ...league('B', 2000)],
        ineligible: {...winners, 1000},
        count: 4,
      );
      expect(ent.runnersUp.toSet(), runnersUp);
      // A1's winner qualified, so League A's other three winners, then the
      // best of League B's.
      expect(ent.nationsCup, [1004, 1008, 1012, 2000]);
    });

    test('a runner-up is never the Nations Cup back door', () {
      final ent = UefaWcPlayoffs.entrants(
        groups: [
          for (final (i, g) in groups.indexed)
            if (i == 0) [g[0], row(1000, 14), g[2], g[3]] else g,
        ],
        ncTables: league('A', 1000),
        ineligible: winners,
        count: 4,
      );
      expect(ent.runnersUp, contains(1000));
      expect(ent.nationsCup, isNot(contains(1000)));
      expect(ent.nationsCup, hasLength(4));
    });

    test('a European host means three paths: the weakest runners-up and '
        'the last back-door side drop out', () {
      final ent = UefaWcPlayoffs.entrants(
        groups: groups,
        ncTables: league('C', 3000),
        ineligible: winners,
        count: 3,
      );
      expect(ent.runnersUp, hasLength(9));
      expect(ent.nationsCup, [3000, 3004, 3008]);
      // The three dropped runners-up are the worst on record.
      final dropped = runnersUp.difference(ent.runnersUp.toSet());
      expect(dropped, hasLength(3));
      for (final d in dropped) {
        final points = groups
            .expand((g) => g)
            .firstWhere((s) => s.nationId == d)
            .points;
        for (final kept in ent.runnersUp) {
          final p = groups
              .expand((g) => g)
              .firstWhere((s) => s.nationId == kept)
              .points;
          expect(p, greaterThanOrEqualTo(points));
        }
      }
    });

    test('too few sides fill down the overall ranking, then the fallback', () {
      final ent = UefaWcPlayoffs.entrants(
        groups: groups,
        ncTables: const [],
        ineligible: winners,
        count: 4,
        fallback: [5000, 5001, 5002, 5003, 5004],
      );
      expect(ent.nationsCup, [5000, 5001, 5002, 5003]);
    });
  });

  group('UefaWcPlayoffs draw', () {
    final ent = (
      runnersUp: [for (var i = 0; i < 12; i++) 100 + i],
      nationsCup: [200, 201, 202, 203],
    );
    // Rank = id: 100 the best runner-up.
    final rank = {for (var i = 0; i < 300; i++) i: i};

    test('pots 1-3 by ranking, pot 4 the Nations Cup sides, one a path', () {
      final paths = UefaWcPlayoffs.draw(
        entrants: ent,
        rankingById: rank,
        rng: SeededRng(7),
      );
      expect(paths.map((p) => p.letter), ['A', 'B', 'C', 'D']);
      final pots = [
        {100, 101, 102, 103},
        {104, 105, 106, 107},
        {108, 109, 110, 111},
        {200, 201, 202, 203},
      ];
      for (var pot = 0; pot < 4; pot++) {
        expect({for (final p in paths) p.seeds[pot]}, pots[pot]);
      }
      // Semis pot 1 v pot 4 and pot 2 v pot 3, the higher seed at home.
      for (final p in paths) {
        expect(EuroPlayoffs.semis(p), [
          (p.seeds[0], p.seeds[3]),
          (p.seeds[1], p.seeds[2]),
        ]);
        expect(p.finalHostSemi, inInclusiveRange(0, 1));
      }
    });

    test('deterministic, and round-trips through its stored slots', () {
      List<PlayoffPath> draw() => UefaWcPlayoffs.draw(
        entrants: ent,
        rankingById: rank,
        rng: SeededRng(7),
      );
      String key(List<PlayoffPath> ps) => [
        for (final p in ps)
          '${p.letter}:${p.seeds.join(',')}:${p.finalHostSemi}',
      ].join(' ');
      expect(key(draw()), key(draw()));
      expect(
        key(EuroPlayoffs.fromSlots(EuroPlayoffs.toSlots(draw()))),
        key(draw()),
      );
    });
  });

  group('IcPlayoffs', () {
    final rank = {for (var i = 0; i < 10; i++) i: i};

    test('two best-ranked seeded into the path finals; semis 3v6, 4v5', () {
      final paths = IcPlayoffs.paths([5, 2, 0, 4, 1, 3], rank);
      expect(paths, [
        (path: '1', seed: 0, semiHome: 2, semiAway: 5),
        (path: '2', seed: 1, semiHome: 3, semiAway: 4),
      ]);
      expect(IcPlayoffs.fromSlots(IcPlayoffs.toSlots(paths)), paths);
    });

    test('any field but six has no paths', () {
      expect(IcPlayoffs.paths([1, 2, 3, 4, 5], rank), isEmpty);
    });

    test('keys and pseudo ids', () {
      expect(IcPlayoffs.placeholderKey('2'), 'IC-2');
      expect(IcPlayoffs.pathOf('IC-2'), '2');
      expect(IcPlayoffs.pathOf('UEFA-B'), isNull);
      expect(WcPlaceholders.keyOfPseudo(IcPlayoffs.pseudoId(1)), 'IC-2');
      expect(WcPlaceholders.keyOfPseudo(UefaWcPlayoffs.pseudoId(2)), 'UEFA-C');
      expect(WcPlaceholders.pseudoOfKey('UEFA-C'), UefaWcPlayoffs.pseudoId(2));
      expect(WcPlaceholders.pseudoOfKey('IC-1'), IcPlayoffs.pseudoId(0));
      expect(WcPlaceholders.keyOfPseudo(17), isNull);
    });
  });

  group('WcPlaceholders draw', () {
    // A 48-team field: 12 + 4 placeholders European (ids 0-11 + UEFA), and
    // the rest of the world, with a realistic spread of confederations.
    final conf = <int, Confederation>{};
    final known = <int>[];
    void add(Confederation c, int n, int from) {
      for (var i = 0; i < n; i++) {
        conf[from + i] = c;
        known.add(from + i);
      }
    }

    add(Confederation.europe, 12, 0);
    add(Confederation.southAmerica, 6, 100);
    add(Confederation.northAmerica, 6, 200); // three hosts among them
    add(Confederation.africa, 9, 300);
    add(Confederation.asia, 8, 400);
    add(Confederation.oceania, 1, 500);
    // The pots, by ranking: hosts and Europe's best; Europe's rest, South
    // America and three Asians; Africa and three Asians; the rest.
    final order = [
      200, 201, 202, for (var i = 0; i < 9; i++) i, //
      9, 10, 11, for (var i = 100; i < 106; i++) i, 400, 401, 402,
      for (var i = 300; i < 309; i++) i, 403, 404, 405,
      406, 407, 500, 203, 204, 205,
    ];
    final rank = {for (final (i, id) in order.indexed) id: i};
    final icPaths = [
      (path: '1', seed: 206, semiHome: 310, semiAway: 501),
      (path: '2', seed: 410, semiHome: 106, semiAway: 207),
    ];
    for (final (id, c) in [
      (206, Confederation.northAmerica),
      (310, Confederation.africa),
      (501, Confederation.oceania),
      (410, Confederation.asia),
      (106, Confederation.southAmerica),
      (207, Confederation.northAmerica),
    ]) {
      conf[id] = c;
    }

    FinalsDraw draw(int seed) => WcPlaceholders.draw(
      known: known,
      uefaPaths: 4,
      icPaths: icPaths,
      rankingById: rank,
      rngSeed: seed,
      hosts: const [200, 201, 202],
      confederationById: conf,
    );

    test('48 slots, every placeholder in pot 4, the caps held', () {
      for (final seed in [1, 2, 3, 42, 4242]) {
        final d = draw(seed);
        expect(d.groups, hasLength(12));
        final slots = WcPlaceholders.toSlots(d);
        expect(slots, hasLength(48));
        final keys = [
          for (final s in slots)
            if (s.placeholderKey != null) s,
        ];
        expect(keys.map((s) => s.placeholderKey).toSet(), {
          'UEFA-A',
          'UEFA-B',
          'UEFA-C',
          'UEFA-D',
          'IC-1',
          'IC-2',
        });
        for (final s in keys) {
          expect(s.position, 3, reason: 'pot 4');
        }
        // Hosts open groups A, B, C.
        expect(d.groups[0].nationIds.first, 200);
        expect(d.groups[1].nationIds.first, 201);
        expect(d.groups[2].nationIds.first, 202);
        for (final g in d.groups) {
          final tally = <Confederation, int>{};
          for (final id in g.nationIds) {
            final c = UefaWcPlayoffs.pathOfPseudo(id) != null
                ? Confederation.europe
                : conf[id];
            if (c != null) tally[c] = (tally[c] ?? 0) + 1;
          }
          // Europe at most two, everyone else one.
          for (final e in tally.entries) {
            expect(
              e.value,
              lessThanOrEqualTo(e.key == Confederation.europe ? 2 : 1),
              reason: 'seed $seed group ${g.name}',
            );
          }
          // An intercontinental placeholder is never with a side of any of
          // its path's confederations.
          for (final (i, p) in icPaths.indexed) {
            if (!g.nationIds.contains(IcPlayoffs.pseudoId(i))) continue;
            final pathConfs = {
              for (final id in IcPlayoffs.members(p)) conf[id],
            };
            for (final id in g.nationIds) {
              if (id < 0) continue;
              expect(
                pathConfs.contains(conf[id]),
                isFalse,
                reason: 'seed $seed: IC-${p.path} with $id in ${g.name}',
              );
            }
          }
        }
      }
    });

    test('deterministic', () {
      expect(
        WcPlaceholders.toSlots(draw(9)),
        WcPlaceholders.toSlots(draw(9)),
      );
    });

    test('exact-slot substitution: each winner where its ball was drawn', () {
      final stored = WcPlaceholders.toSlots(draw(5));
      final winners = {
        'UEFA-A': 12,
        'UEFA-B': 13,
        'UEFA-C': 14,
        'UEFA-D': 15,
        'IC-1': 310,
        'IC-2': 106,
      };
      // Unresolved: nothing to create yet.
      expect(EuroPlayoffs.resolvedDraw(stored, rngSeed: 1).groups, isEmpty);
      final resolved = [
        for (final s in stored)
          s.placeholderKey == null
              ? s
              : (
                  groupName: s.groupName,
                  position: s.position,
                  nationId: null,
                  placeholderKey: s.placeholderKey,
                  resolvedNationId: winners[s.placeholderKey],
                ),
      ];
      final finals = EuroPlayoffs.resolvedDraw(resolved, rngSeed: 1);
      expect(finals.groups, hasLength(12));
      for (final s in resolved) {
        final g = finals.groups.singleWhere((g) => g.name == s.groupName);
        expect(g.nationIds[s.position], EuroPlayoffs.occupant(s));
        expect(g.fixtures, hasLength(6));
      }
    });

    test('a legacy draw (no placeholders) is bit for bit what it was', () {
      final field = [...known, 12, 13, 14, 15, 310, 106];
      final a = WorldCupFinals.drawGroups(
        qualifierIds: field,
        rankingById: rank,
        rngSeed: 77,
        hosts: const [200, 201, 202],
        confederationById: conf,
      );
      final b = WorldCupFinals.drawGroups(
        qualifierIds: field,
        rankingById: rank,
        rngSeed: 77,
        hosts: const [200, 201, 202],
        confederationById: conf,
        anyOfConfederations: const {},
      );
      expect(
        [for (final g in a.groups) g.nationIds],
        [for (final g in b.groups) g.nationIds],
      );
    });
  });

  group('GroupAdvancement with Europe\'s paths', () {
    test('winners direct, no ladder, the best runners-up painted', () {
      final adv = GroupAdvancement.worldCupQualifying(
        Confederation.europe,
        12,
        hosts: 0,
        playoffPaths: 4,
      );
      expect(adv.direct, 1);
      expect(adv.contention, isNull);
      final groups = qualifying();
      expect(
        GroupAdvancement.worldCupPlayoffNations(
          Confederation.europe,
          groups,
          hosts: 0,
          playoffPaths: 4,
        ),
        {for (final g in groups) g[1].nationId},
      );
      // Without paths Europe has no play-off sides, as before.
      expect(
        GroupAdvancement.worldCupPlayoffNations(
          Confederation.europe,
          groups,
          hosts: 0,
        ),
        isEmpty,
      );
    });
  });

  group('UefaWcPlayoffs.onCourseNationsCup', () {
    final cup = [...league('A', 100), ...league('B', 200)];

    test('before qualifying: the best group winners, hosts left out', () {
      expect(
        UefaWcPlayoffs.onCourseNationsCup(
          groups: const [],
          ncTables: cup,
          hosts: const {},
          europeCount: 53,
        ),
        [100, 104, 108, 112],
      );
      expect(
        UefaWcPlayoffs.onCourseNationsCup(
          groups: const [],
          ncTables: cup,
          hosts: const {104},
          europeCount: 53,
        ),
        // A host's place comes out of Europe's: three paths.
        [100, 108, 112],
      );
    });

    test('drawn but unplayed qualifying reads as not started', () {
      final unplayed = [
        for (var g = 0; g < 12; g++)
          [for (var p = 0; p < 4; p++) GroupStanding(g * 10 + p)],
      ];
      expect(
        UefaWcPlayoffs.onCourseNationsCup(
          groups: unplayed,
          ncTables: cup,
          hosts: const {},
          europeCount: 53,
        ),
        [100, 104, 108, 112],
      );
    });

    test('under way: pot 4 as the draw would take it today', () {
      final groups = qualifying();
      expect(
        UefaWcPlayoffs.onCourseNationsCup(
          groups: groups,
          ncTables: cup,
          hosts: const {},
          europeCount: 53,
        ),
        UefaWcPlayoffs.entrants(
          groups: groups,
          ncTables: cup,
          ineligible: {...Qualification.qualifiers(groups, 12)},
          count: 4,
        ).nationsCup,
      );
    });

    test('no cup table, no marks', () {
      expect(
        UefaWcPlayoffs.onCourseNationsCup(
          groups: qualifying(),
          ncTables: const [],
          hosts: const {},
          europeCount: 53,
        ),
        isEmpty,
      );
    });
  });
}
