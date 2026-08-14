import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';

/// Decides WHAT a nation produces: the mix of positions in the players it
/// generates, both for the fringe of the seeded pool and for every newgen
/// intake after it.
///
/// Every nation used to be filled from one hard-coded cycle of positions, so
/// every country in the world produced the same shape of footballer in the same
/// order — a squad built for a 4-3-3 or a 4-4-2 and nothing else. Two nations
/// were indistinguishable below the first team, and formations that ask for
/// something unusual (three at the back, two wing-backs, a diamond) were always
/// staffed by players out of position.
///
/// Now each nation has a footballing school: a deterministic tilt on the base
/// depth chart that makes it a country of wingers, of centre-halves, of
/// midfielders, of wing-backs. The tilt is real but bounded — every nation
/// still produces every position, so no formation is ever unplayable, and the
/// draw is deterministic in the nation's id like the rest of the derived world.
abstract final class DepthChart {
  /// The positions in the order they are laid out on a depth chart, back to
  /// front. Also the order they are interleaved in, so a nation's generated
  /// players alternate through the chart rather than arriving in blocks.
  static const List<PlayerPosition> _order = [
    PlayerPosition.gk,
    PlayerPosition.rb,
    PlayerPosition.cb,
    PlayerPosition.lb,
    PlayerPosition.dm,
    PlayerPosition.cm,
    PlayerPosition.am,
    PlayerPosition.rm,
    PlayerPosition.lm,
    PlayerPosition.rw,
    PlayerPosition.lw,
    PlayerPosition.st,
  ];

  /// The share of a pool each position takes in a neutral, balanced country
  /// (parts per hundred). Modelled on a real national pool: centre-halves,
  /// central midfielders and strikers are the deep positions, the flanks and
  /// the specialist roles are thinner.
  static const Map<PlayerPosition, int> _baseShare = {
    PlayerPosition.gk: 7,
    PlayerPosition.rb: 7,
    PlayerPosition.cb: 15,
    PlayerPosition.lb: 7,
    PlayerPosition.dm: 8,
    PlayerPosition.cm: 13,
    PlayerPosition.am: 8,
    PlayerPosition.rm: 5,
    PlayerPosition.lm: 5,
    PlayerPosition.rw: 6,
    PlayerPosition.lw: 6,
    PlayerPosition.st: 13,
  };

  /// The footballing schools, as deltas on [_baseShare]. Each sums to zero, so
  /// a school moves a nation's production around without making it deeper or
  /// shallower than anyone else.
  static const List<Map<PlayerPosition, int>> _schools = [
    // Balanced — no tilt at all. A country that produces a bit of everything.
    <PlayerPosition, int>{},
    // Wingers: inverted, direct forwards on both flanks, fewer runners inside.
    {
      PlayerPosition.rw: 5,
      PlayerPosition.lw: 5,
      PlayerPosition.rm: -3,
      PlayerPosition.lm: -3,
      PlayerPosition.am: -2,
      PlayerPosition.st: -2,
    },
    // Old-fashioned wide midfields and a front two.
    {
      PlayerPosition.rm: 5,
      PlayerPosition.lm: 5,
      PlayerPosition.st: 3,
      PlayerPosition.rw: -4,
      PlayerPosition.lw: -4,
      PlayerPosition.am: -5,
    },
    // A strong spine: centre-halves, a holder and a centre-forward.
    {
      PlayerPosition.cb: 5,
      PlayerPosition.dm: 5,
      PlayerPosition.st: 2,
      PlayerPosition.rm: -3,
      PlayerPosition.lm: -3,
      PlayerPosition.rw: -3,
      PlayerPosition.lw: -3,
    },
    // Front-foot football: forwards and creators, thin at the back.
    {
      PlayerPosition.st: 5,
      PlayerPosition.am: 5,
      PlayerPosition.cb: -4,
      PlayerPosition.dm: -3,
      PlayerPosition.rb: -2,
      PlayerPosition.lb: -1,
    },
    // Defensive: deep and hard to beat, short of a finisher.
    {
      PlayerPosition.cb: 6,
      PlayerPosition.rb: 3,
      PlayerPosition.lb: 3,
      PlayerPosition.dm: 3,
      PlayerPosition.st: -6,
      PlayerPosition.am: -5,
      PlayerPosition.rw: -2,
      PlayerPosition.lw: -2,
    },
    // Possession: midfielders everywhere, no natural number nine.
    {
      PlayerPosition.cm: 6,
      PlayerPosition.am: 4,
      PlayerPosition.dm: 2,
      PlayerPosition.st: -5,
      PlayerPosition.rm: -3,
      PlayerPosition.lm: -2,
      PlayerPosition.rw: -1,
      PlayerPosition.lw: -1,
    },
    // Wing-backs: the country that plays three at the back.
    {
      PlayerPosition.rb: 5,
      PlayerPosition.lb: 5,
      PlayerPosition.cb: 2,
      PlayerPosition.rm: -3,
      PlayerPosition.lm: -3,
      PlayerPosition.am: -3,
      PlayerPosition.st: -3,
    },
  ];

  /// The school [nationId] belongs to — stable for the life of a save, so a
  /// nation's identity holds across every intake it ever produces.
  static int schoolOf(int nationId) => _hash(nationId) % _schools.length;

  /// [count] positions for [nationId]'s generated players, in the order they
  /// should be created.
  ///
  /// The order matters: callers grade quality by index (the first players
  /// generated are the best of the fringe, the last are reserves), so the
  /// positions are interleaved rather than grouped — every position has players
  /// at the top of the chart and players at the bottom, instead of a nation
  /// whose entire good fringe happens to be goalkeepers.
  ///
  /// [salt] separates independent draws for the same nation (each newgen intake
  /// passes its cycle), so successive generations of the same country vary
  /// around its school rather than repeating one list.
  static List<PlayerPosition> forNation({
    required int nationId,
    required int count,
    int salt = 0,
  }) {
    if (count <= 0) return const [];
    final rng = SeededRng(
      (nationId * 0x9E3779B1) ^ (salt * 0x85EBCA77) ^ 0x5F3D2C11,
    );
    final school =
        _schools[_hash(nationId ^ (salt * 0x2545F491)) % _schools.length];

    // The nation's weights: its school's chart, plus a small wobble so two
    // countries of the same school still differ.
    final weights = <PlayerPosition, int>{
      for (final p in _order)
        p: (_baseShare[p]! + (school[p] ?? 0) + rng.nextInt(5) - 2).clamp(
          2,
          40,
        ),
    };

    final counts = _allocate(weights, count);
    _applyFloors(counts, count);
    return _interleave(counts, nationId);
  }

  /// Splits [count] places across [weights] by largest remainder, so the totals
  /// always add up exactly however the weights fall.
  static Map<PlayerPosition, int> _allocate(
    Map<PlayerPosition, int> weights,
    int count,
  ) {
    final total = weights.values.fold(0, (s, w) => s + w);
    final counts = <PlayerPosition, int>{};
    final remainders = <(PlayerPosition, double)>[];
    var used = 0;
    for (final p in _order) {
      final exact = count * weights[p]! / total;
      final whole = exact.floor();
      counts[p] = whole;
      used += whole;
      remainders.add((p, exact - whole));
    }
    remainders.sort((a, b) => b.$2.compareTo(a.$2));
    for (var i = 0; used < count; i++) {
      final p = remainders[i % remainders.length].$1;
      counts[p] = counts[p]! + 1;
      used++;
    }
    return counts;
  }

  /// Guarantees cover everywhere: enough goalkeepers to field one and have
  /// spares, and at least one of every outfield position once the pool is big
  /// enough to hold one. Without this a hard tilt could leave a nation unable
  /// to field a shape without an emergency keeper, which is exactly what the
  /// school system is meant to avoid. Places are taken from the deepest
  /// position, so a floor never empties another slot.
  static void _applyFloors(Map<PlayerPosition, int> counts, int count) {
    void raiseTo(PlayerPosition p, int floor) {
      while (counts[p]! < floor) {
        final donor = _order
            .where((q) => q != p)
            .reduce((a, b) => counts[a]! >= counts[b]! ? a : b);
        if (counts[donor]! <= 1) return; // nothing left to give
        counts[donor] = counts[donor]! - 1;
        counts[p] = counts[p]! + 1;
      }
    }

    raiseTo(PlayerPosition.gk, (count / 14).ceil().clamp(1, 8));
    if (count < _order.length) return;
    for (final p in _order) {
      raiseTo(p, 1);
    }
  }

  /// Lays the allocation out back-to-front, one position at a time, so quality
  /// (which the callers taper by index) is spread evenly across the chart. The
  /// starting position rotates per nation so it isn't always a goalkeeper who
  /// is generated first.
  static List<PlayerPosition> _interleave(
    Map<PlayerPosition, int> counts,
    int nationId,
  ) {
    final left = {...counts};
    final out = <PlayerPosition>[];
    final start = _hash(nationId ^ 0x51ED) % _order.length;
    var total = left.values.fold(0, (s, n) => s + n);
    var i = 0;
    while (total > 0) {
      final p = _order[(start + i) % _order.length];
      if (left[p]! > 0) {
        out.add(p);
        left[p] = left[p]! - 1;
        total--;
      }
      i++;
    }
    return out;
  }

  /// A stable non-negative avalanche hash.
  static int _hash(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }
}
