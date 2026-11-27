import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/euro_qualifying28.dart';

/// A played fixture.
Fixture _f(int home, int away, int hs, int as) => Fixture(
  id: 0,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2027),
  homeNationId: home,
  awayNationId: away,
  homeScore: hs,
  awayScore: as,
  played: true,
);

/// A double round robin in which every side beats every side below it by
/// [margin] goals, so the table is [members] in order.
List<GroupStanding> _pecking(List<int> members, int margin) =>
    GroupStanding.table(members, [
      for (var i = 0; i < members.length; i++)
        for (var j = i + 1; j < members.length; j++) ...[
          _f(members[i], members[j], margin, 0),
          _f(members[j], members[i], 0, margin),
        ],
    ]);

/// Europe's twelve qualifying groups: groups 0-5 of five, 6-11 of four.
/// Group g's sides are 100(g+1) (winner), +1 (runner-up), +2 … and every
/// win in it is by g+1 goals, so across the groups the later group's side
/// at a place ranks better.
List<List<GroupStanding>> _qualifying() => [
  for (var g = 0; g < 12; g++)
    _pecking([
      for (var p = 0; p < (g < 6 ? 5 : 4); p++) 100 * (g + 1) + p,
    ], g + 1),
];

int _id(int group, int place) => 100 * (group + 1) + place;

/// A hand-made Nations Cup row.
GroupStanding _row(int id, int points) => GroupStanding(id)
  ..played = 6
  ..won = points ~/ 3
  ..drawn = points % 3
  ..goalsFor = points;

/// The first Nations Cup: the qualifying sides in the order winners,
/// runners-up, thirds, fourths, fifths (each by group), cut into leagues of
/// sixteen and groups of four (League D one group of the six fifths). Group
/// k of a league scores 12-3p-k at place p.
List<NcTable> _nationsCup() {
  final order = [
    for (var p = 0; p < 5; p++)
      for (var g = 0; g < 12; g++)
        if (p < 4 || g < 6) _id(g, p),
  ];
  final out = <NcTable>[];
  for (var league = 0; league < 3; league++) {
    for (var k = 0; k < 4; k++) {
      final start = league * 16 + k * 4;
      out.add((
        name: '${String.fromCharCode(65 + league)}${k + 1}',
        standings: [
          for (var p = 0; p < 4; p++) _row(order[start + p], 12 - 3 * p - k),
        ],
      ));
    }
  }
  out.add((
    name: 'D1',
    standings: [
      for (var p = 0; p < 6; p++) _row(order[48 + p], 15 - 3 * p),
    ],
  ));
  return out;
}

void main() {
  group('the draw', () {
    test('54 sides: six groups of five and six of four', () {
      expect(Euro28.groupCount(54), 12);
      expect(Euro28.groupSizes(54), [5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4]);
      // An old world without Belarus: five of five.
      expect(Euro28.groupSizes(53).where((s) => s == 5), hasLength(5));
      // A small custom world: groups of four or so.
      expect(Euro28.groupCount(22), 5);
    });

    test('one side of each pot a group, the short pot in the first six', () {
      final order = [for (var i = 1; i <= 54; i++) i];
      for (var seed = 0; seed < 20; seed++) {
        final groups = Euro28.drawGroups(order: order, rng: SeededRng(seed));
        expect(groups.map((g) => g.length), Euro28.groupSizes(54));
        expect({for (final g in groups) ...g}, order.toSet());
        for (final (gi, g) in groups.indexed) {
          // Pot k is order[12k .. 12k+11]: a group's k-th side came from it.
          for (final (k, id) in g.indexed) {
            expect((id - 1) ~/ 12, k, reason: 'group $gi');
          }
        }
      }
    });

    test('the hosts are drawn into different groups', () {
      final order = [for (var i = 1; i <= 54; i++) i];
      // Hosts in pots 1, 2, 3 and 5 (and two in pot 2).
      const hosts = {3, 14, 20, 30, 50};
      for (var seed = 0; seed < 200; seed++) {
        final groups = Euro28.drawGroups(
          order: order,
          rng: SeededRng(seed),
          separate: hosts,
        );
        for (final g in groups) {
          expect(g.where(hosts.contains).length, lessThanOrEqualTo(1));
        }
        expect({for (final g in groups) ...g}, order.toSet());
      }
    });

    test('pots follow the Nations Cup, then the world ranking', () {
      expect(
        Euro28.potOrder(
          field: [1, 2, 3, 4, 5],
          ncRanking: [4, 2, 99, 1],
          fallback: [5, 3, 4],
        ),
        [4, 2, 1, 5, 3],
      );
    });
  });

  group('the runners-up', () {
    test('winners and the eight best runners-up go straight through', () {
      final groups = _qualifying();
      final direct = Euro28.direct(groups);
      expect(direct, hasLength(20));
      expect(direct.take(12).toSet(), {for (var g = 0; g < 12; g++) _id(g, 0)});
      // The runners-up of groups 4-11 (bigger margins) are the best eight.
      expect(direct.skip(12).toSet(), {for (var g = 4; g < 12; g++) _id(g, 1)});
      expect(Euro28.runnersUpThrough(groups), 8);
    });

    test('results against a group of five\'s fifth are discarded', () {
      // Group X (five): its runner-up beat the fifth 9-0 twice and split
      // with the third and fourth: 12 points and +16 in full, 6 points over
      // the comparable six. Group Y (four): its runner-up won four of six,
      // 12 points and +2.
      final x = GroupStanding.table(
        [1, 2, 3, 4, 5],
        [
          _f(1, 2, 1, 0), _f(2, 1, 0, 1), // the winner beats everyone
          _f(1, 3, 1, 0), _f(3, 1, 0, 1),
          _f(1, 4, 1, 0), _f(4, 1, 0, 1),
          _f(1, 5, 1, 0), _f(5, 1, 0, 1),
          _f(2, 3, 1, 0), _f(3, 2, 1, 0),
          _f(2, 4, 1, 0), _f(4, 2, 1, 0),
          _f(2, 5, 9, 0), _f(5, 2, 0, 9),
          _f(3, 4, 0, 0), _f(4, 3, 0, 0),
          _f(3, 5, 0, 0), _f(5, 3, 0, 0),
          _f(4, 5, 0, 0), _f(5, 4, 0, 0),
        ],
      );
      final y = _pecking([11, 12, 13, 14], 1);
      expect(x[1].nationId, 2);
      expect(x.last.nationId, 5);
      // In full, X's runner-up would rank first.
      expect(x[1].points, y[1].points);
      expect(x[1].goalDifference, greaterThan(y[1].goalDifference));
      final ranked = Euro28.runnersUp([x, y]);
      expect(ranked.map((s) => s.nationId), [12, 2]);
      expect(ranked.last.points, 6);
      expect(ranked.last.played, 6);
      // So the group of four's runner-up takes the one place left.
      expect(Euro28.direct([x, y], berths: 3).toSet(), {1, 11, 12});
    });
  });

  group('the host places', () {
    final groups = _qualifying();
    final direct = Euro28.direct(groups);

    Euro28Settled settle(List<int> hosts) => Euro28.settle(
      groups: groups,
      ncTables: _nationsCup(),
      hosts: hosts,
      size: 24,
      rng: SeededRng(7),
    );

    test('no hosts: none held, four places in two-legged ties', () {
      final s = settle(const []);
      expect(s.direct, direct);
      expect(s.hostPlaces, isEmpty);
      expect(s.paths, hasLength(4));
      expect(s.paths.every(EuroPlayoffs.isTie), isTrue);
    });

    test('a host through directly frees its place for the play-offs', () {
      final s = settle([_id(0, 0)]);
      expect(s.hostPlaces, isEmpty);
      expect(s.paths, hasLength(4));
      expect(s.paths.every(EuroPlayoffs.isTie), isTrue);
    });

    test('one host out: one place held, three paths of four', () {
      final host = _id(0, 3); // fourth in group A
      final s = settle([host]);
      expect(s.hostPlaces, [host]);
      expect(s.direct, direct);
      expect(s.paths, hasLength(3));
      expect(s.paths.every((p) => p.seeds.length == 4), isTrue);
      expect(s.entrants, hasLength(12));
      expect(s.entrants, isNot(contains(host)));
    });

    test('two hosts out: both held, two paths of four', () {
      final s = settle([_id(0, 3), _id(0, 4)]);
      expect(s.hostPlaces, [_id(0, 3), _id(0, 4)]);
      expect(s.paths, hasLength(2));
      expect(s.entrants, hasLength(8));
      expect(s.direct.length + s.hostPlaces.length + s.paths.length, 24);
    });

    test('two hosts, one through: one held, three paths', () {
      final s = settle([_id(5, 0), _id(0, 4)]);
      expect(s.hostPlaces, [_id(0, 4)]);
      expect(s.paths, hasLength(3));
    });

    test('more than two hosts out: the two best on the qualifying ranking', () {
      // A third (group I), a fourth and a fifth: the fifth is not covered,
      // and plays the play-offs like anybody else.
      final third = _id(8, 2), fourth = _id(0, 3), fifth = _id(0, 4);
      final held = Euro28.hostPlaces(
        groups: groups,
        hosts: [fifth, fourth, third],
        direct: direct,
      );
      expect(held, [third, fourth]);
      final s = settle([fifth, fourth, third]);
      expect(s.hostPlaces, [third, fourth]);
      expect(s.paths, hasLength(2));
      expect(s.entrants, isNot(contains(third)));
      expect(s.entrants, isNot(contains(fourth)));
    });

    test('a place for every side of the 24', () {
      for (final hosts in [
        const <int>[],
        [_id(0, 3)],
        [_id(0, 3), _id(1, 3)],
        [_id(0, 3), _id(1, 3), _id(2, 3)],
        [_id(0, 0), _id(1, 0)],
      ]) {
        final s = settle(hosts);
        expect(
          s.direct.length + s.hostPlaces.length + s.paths.length,
          24,
          reason: '$hosts',
        );
        final all = [...s.direct, ...s.hostPlaces, ...s.entrants];
        expect(all.toSet(), hasLength(all.length), reason: 'no side twice');
      }
    });
  });

  group('the play-off entrants', () {
    final groups = _qualifying();
    final nc = _nationsCup();
    final runners = [_id(3, 1), _id(2, 1), _id(1, 1), _id(0, 1)];

    test('four places: the other runners-up, then the cup\'s best group '
        'winners not through', () {
      final s = Euro28.settle(
        groups: groups,
        ncTables: nc,
        hosts: const [],
        size: 24,
        rng: SeededRng(1),
      );
      // League B's third and fourth groups' winners (thirds of groups A and
      // E), then League C's best two group winners.
      expect(s.entrants.toSet(), {
        ...runners,
        _id(0, 2),
        _id(4, 2),
        _id(8, 2),
        _id(0, 3),
      });
    });

    test('ties: the runners-up seeded, each at home in the second leg', () {
      final s = Euro28.settle(
        groups: groups,
        ncTables: nc,
        hosts: const [],
        size: 24,
        rng: SeededRng(3),
      );
      expect([for (final t in s.paths) t.seeds.first], runners);
      expect([for (final t in s.paths) t.letter], ['A', 'B', 'C', 'D']);
      expect(
        {for (final t in s.paths) t.seeds.last},
        {
          _id(0, 2),
          _id(4, 2),
          _id(8, 2),
          _id(0, 3),
        },
      );
      final tie = s.paths.first;
      expect(EuroPlayoffs.firstLeg(tie), (tie.seeds[1], tie.seeds[0]));
      expect(EuroPlayoffs.secondLeg(tie), (tie.seeds[0], tie.seeds[1]));
    });

    test('two places: two paths, the runners-up in pots 1 and 2', () {
      final s = Euro28.settle(
        groups: groups,
        ncTables: nc,
        hosts: [_id(0, 3), _id(0, 4)],
        size: 24,
        rng: SeededRng(5),
      );
      expect(s.entrants.toSet(), {
        ...runners,
        _id(0, 2),
        _id(4, 2),
        _id(8, 2),
        // League C's second group's winner is a host on a held place.
        _id(4, 3),
      });
      expect({for (final p in s.paths) p.seeds[0]}, {runners[0], runners[1]});
      expect({for (final p in s.paths) p.seeds[1]}, {runners[2], runners[3]});
      expect({for (final p in s.paths) p.seeds[2]}, {_id(0, 2), _id(4, 2)});
      for (final p in s.paths) {
        // One-leg semis at the higher seed: 1 v 4, 2 v 3.
        expect(EuroPlayoffs.semis(p), [
          (p.seeds[0], p.seeds[3]),
          (p.seeds[1], p.seeds[2]),
        ]);
        expect(p.finalHostSemi, anyOf(0, 1));
      }
    });

    test('three places: three paths of four, twelve sides', () {
      // A runner-up host on a held place: three runners-up, seven cup
      // group winners and League B's two best others.
      final host = _id(0, 1);
      final s = Euro28.settle(
        groups: groups,
        ncTables: nc,
        hosts: [host],
        size: 24,
        rng: SeededRng(9),
      );
      expect(s.hostPlaces, [host]);
      expect(s.paths, hasLength(3));
      final seeded = [
        for (var k = 0; k < 4; k++) {for (final p in s.paths) p.seeds[k]},
      ];
      expect(seeded[0], {_id(3, 1), _id(2, 1), _id(1, 1)});
      expect(seeded[1], {_id(0, 2), _id(4, 2), _id(1, 2)});
      expect(seeded[2], {_id(5, 2), _id(8, 2), _id(0, 3)});
      expect(seeded[3], {_id(4, 3), _id(8, 3), _id(0, 4)});
    });

    test('before qualifying: the cup\'s best, four places kept', () {
      final net = Euro28.onCourseNationsCup(
        groups: const [],
        ncTables: nc,
        hosts: const [],
        size: 24,
      );
      // League A's four group winners: eight entrants less four kept.
      expect(net, {_id(0, 0), _id(4, 0), _id(8, 0), _id(0, 1)});
    });

    test('the stored slots round-trip, ties and paths alike', () {
      for (final hosts in [
        const <int>[],
        [_id(0, 3)],
      ]) {
        final s = Euro28.settle(
          groups: groups,
          ncTables: nc,
          hosts: hosts,
          size: 24,
          rng: SeededRng(11),
        );
        String show(List<PlayoffPath> ps) => [
          for (final p in ps) '${p.letter}:${p.seeds}:${p.finalHostSemi}',
        ].join(' ');
        expect(
          show(EuroPlayoffs.fromSlots(EuroPlayoffs.toSlots(s.paths))),
          show(s.paths),
        );
      }
    });
  });
}
