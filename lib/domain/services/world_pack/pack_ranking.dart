import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The starting world ranking of a career on a world pack: the default
/// ranking, moved by how much stronger (or weaker) each nation's squad is in
/// the pack than in the default world.
abstract final class PackRanking {
  /// How many of a squad's best players its strength counts.
  static const int strengthDepth = 18;

  /// Ranking places a nation climbs per point of strength it gains.
  static const int placesPerPoint = 4;

  /// The rounded mean of the best [strengthDepth] of [overalls] (all of them
  /// when there are fewer); 0 for none.
  static int strength(Iterable<int> overalls) {
    final best = [...overalls]..sort((a, b) => b - a);
    final top = best.take(strengthDepth).toList();
    if (top.isEmpty) return 0;
    return (top.reduce((a, b) => a + b) / top.length).round();
  }

  /// [strength] of each of [squads] (a pack's, by nation id).
  static Map<int, int> squadStrengths(Map<int, List<PackPlayer>> squads) => {
    for (final e in squads.entries)
      e.key: strength([
        for (final p in e.value)
          OverallRating.forPosition(p.position, p.attributes),
      ]),
  };

  /// Every nation of [baseRanks] ranked by `-baseRank + 4 * (pack - default)`,
  /// best first, ties broken by base rank.
  ///
  /// A nation either strength map leaves out has gained nothing. Nations
  /// level on both score and base rank share a place, as the base ranking
  /// lets them (Belarus shares Palestine's), and the next takes the place
  /// after: so a pack that changes no strength gives exactly [baseRanks]
  /// back, and distinct base ranks give the places 1..n.
  static Map<int, int> startingRanks({
    required Map<int, int> baseRanks,
    required Map<int, int> defaultStrength,
    required Map<int, int> packStrength,
  }) {
    int score(int id) {
      final base = defaultStrength[id];
      final now = packStrength[id];
      final gain = base == null || now == null ? 0 : now - base;
      return -baseRanks[id]! + placesPerPoint * gain;
    }

    final scored = [for (final id in baseRanks.keys) (id, score(id))]
      ..sort((a, b) {
        final c = b.$2.compareTo(a.$2);
        if (c != 0) return c;
        final r = baseRanks[a.$1]!.compareTo(baseRanks[b.$1]!);
        return r != 0 ? r : a.$1.compareTo(b.$1);
      });
    final out = <int, int>{};
    var place = 0;
    (int, int)? previous;
    for (final e in scored) {
      final shared =
          previous != null &&
          previous.$2 == e.$2 &&
          baseRanks[previous.$1] == baseRanks[e.$1];
      if (!shared) place++;
      out[e.$1] = place;
      previous = e;
    }
    return out;
  }
}
