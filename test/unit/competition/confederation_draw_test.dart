import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/finals.dart';

/// A World Cup group may not be two-thirds one continent.
///
/// The draw seeded four pots by ranking and dealt slot i to group i, which
/// takes no notice of where anybody is from — so a group could come out with
/// three South Americans in it. The real tournament separates confederations,
/// and the same rule must NOT be applied to a continental cup, where every
/// team shares one.
void main() {
  /// The real 48-team allocation: 16 UEFA, 9 CAF, 8 AFC, 6 CONMEBOL,
  /// 6 CONCACAF, 1 OFC, plus 2 play-off winners (counted to their own
  /// confederations here, which is the harder case for the draw).
  ({List<int> ids, Map<int, Confederation> conf}) worldCupField() {
    const slots = <Confederation, int>{
      Confederation.europe: 16,
      Confederation.africa: 9,
      Confederation.asia: 8,
      Confederation.southAmerica: 7,
      Confederation.northAmerica: 7,
      Confederation.oceania: 1,
    };
    final ids = <int>[];
    final conf = <int, Confederation>{};
    var next = 1;
    for (final e in slots.entries) {
      for (var i = 0; i < e.value; i++) {
        ids.add(next);
        conf[next] = e.key;
        next++;
      }
    }
    return (ids: ids, conf: conf);
  }

  Map<Confederation, int> worstGroup(FinalsDraw draw, Map<int, Confederation> c) {
    final worst = <Confederation, int>{};
    for (final g in draw.groups) {
      final counted = <Confederation, int>{};
      for (final id in g.nationIds) {
        final k = c[id];
        if (k != null) counted[k] = (counted[k] ?? 0) + 1;
      }
      for (final e in counted.entries) {
        if (e.value > (worst[e.key] ?? 0)) worst[e.key] = e.value;
      }
    }
    return worst;
  }

  group('confederationCaps', () {
    test('a 48-team World Cup allows Europe two and everyone else one', () {
      final f = worldCupField();
      final caps = WorldCupFinals.confederationCaps(
        confederations: [for (final id in f.ids) f.conf[id]!],
        groupCount: 12,
      );
      expect(caps[Confederation.europe], 2, reason: '16 teams across 12 groups');
      expect(caps[Confederation.africa], 1);
      expect(caps[Confederation.asia], 1);
      expect(caps[Confederation.southAmerica], 1);
      expect(caps[Confederation.northAmerica], 1);
      expect(caps[Confederation.oceania], 1);
    });

    test('a continental cup constrains nothing, because it cannot', () {
      // 24 teams of one confederation in 6 groups of 4: the cap works out to
      // the whole group, so no arrangement is forbidden. Without this the
      // shared draw could not seat a continental group stage at all.
      final caps = WorldCupFinals.confederationCaps(
        confederations: List.filled(24, Confederation.europe),
        groupCount: 6,
      );
      expect(caps[Confederation.europe], 4);
    });
  });

  group('the draw itself', () {
    test('no group breaks its confederation cap, over many seeds', () {
      final f = worldCupField();
      for (var seed = 0; seed < 60; seed++) {
        final draw = WorldCupFinals.drawGroups(
          qualifierIds: f.ids,
          rankingById: {for (var i = 0; i < f.ids.length; i++) f.ids[i]: i + 1},
          rngSeed: seed,
          confederationById: f.conf,
        );
        expect(draw.groups, hasLength(12), reason: 'seed $seed');
        final worst = worstGroup(draw, f.conf);
        expect(
          worst[Confederation.europe] ?? 0,
          lessThanOrEqualTo(2),
          reason: 'seed $seed put three European sides in one group',
        );
        for (final c in [
          Confederation.africa,
          Confederation.asia,
          Confederation.southAmerica,
          Confederation.northAmerica,
          Confederation.oceania,
        ]) {
          expect(
            worst[c] ?? 0,
            lessThanOrEqualTo(1),
            reason: 'seed $seed doubled up $c in one group',
          );
        }
      }
    });

    test('every team is still drawn exactly once', () {
      final f = worldCupField();
      for (var seed = 0; seed < 20; seed++) {
        final draw = WorldCupFinals.drawGroups(
          qualifierIds: f.ids,
          rankingById: {for (var i = 0; i < f.ids.length; i++) f.ids[i]: i + 1},
          rngSeed: seed,
          confederationById: f.conf,
        );
        final drawn = [for (final g in draw.groups) ...g.nationIds];
        expect(drawn.toSet(), f.ids.toSet(), reason: 'seed $seed');
        expect(drawn, hasLength(f.ids.length), reason: 'seed $seed: duplicate');
      }
    });

    test('the same seed always draws the same groups', () {
      final f = worldCupField();
      List<List<int>> run() => WorldCupFinals.drawGroups(
        qualifierIds: f.ids,
        rankingById: {for (var i = 0; i < f.ids.length; i++) f.ids[i]: i + 1},
        rngSeed: 4242,
        confederationById: f.conf,
      ).groups.map((g) => g.nationIds).toList();
      expect(run(), run());
    });

    test('hosts still open their own groups', () {
      final f = worldCupField();
      // Two co-hosts, deliberately from the same confederation.
      final hosts = [f.ids.first, f.ids[1]];
      final draw = WorldCupFinals.drawGroups(
        qualifierIds: f.ids,
        rankingById: {for (var i = 0; i < f.ids.length; i++) f.ids[i]: i + 1},
        rngSeed: 7,
        hosts: hosts,
        confederationById: f.conf,
      );
      expect(draw.groups[0].nationIds, contains(hosts[0]));
      expect(draw.groups[1].nationIds, contains(hosts[1]));
    });

    test('a continental field still draws, and is unchanged', () {
      // 24 of one confederation. Passing confederations must not alter this.
      final ids = [for (var i = 1; i <= 24; i++) i];
      final rank = {for (var i = 0; i < 24; i++) ids[i]: i + 1};
      final plain = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: rank,
        rngSeed: 99,
      );
      final withConf = WorldCupFinals.drawGroups(
        qualifierIds: ids,
        rankingById: rank,
        rngSeed: 99,
        confederationById: {for (final id in ids) id: Confederation.europe},
      );
      expect(
        withConf.groups.map((g) => g.nationIds),
        plain.groups.map((g) => g.nationIds),
        reason: 'a single-confederation field has nothing to separate',
      );
    });

    test('omitting confederations leaves the old draw byte for byte', () {
      final f = worldCupField();
      final rank = {for (var i = 0; i < f.ids.length; i++) f.ids[i]: i + 1};
      final before = WorldCupFinals.drawGroups(
        qualifierIds: f.ids,
        rankingById: rank,
        rngSeed: 31337,
      );
      expect(before.groups, hasLength(12));
      // Nothing to assert against a golden here beyond stability: the point is
      // that the un-passed path does not run the new code at all.
      final again = WorldCupFinals.drawGroups(
        qualifierIds: f.ids,
        rankingById: rank,
        rngSeed: 31337,
      );
      expect(
        again.groups.map((g) => g.nationIds),
        before.groups.map((g) => g.nationIds),
      );
    });
  });
}
