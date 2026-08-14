import 'package:fnm/core/rng/seeded_rng.dart';

/// A scheduled pairing within a matchday: `[homeNationId, awayNationId]`.
typedef Pairing = (int home, int away);

/// Generates a **double round-robin** schedule (everyone plays everyone twice,
/// home and away) using the circle method. Returns a list of matchdays, each a
/// list of [Pairing]s. Round count is `2*(n-1)` for even `n`, `2*n` for odd
/// `n` (a bye sits one team out per round in each half).
///
/// Deterministic: the initial ordering is shuffled with [rng], so the same seed
/// always yields the same fixtures.
List<List<Pairing>> doubleRoundRobin(
  List<int> teamIds, {
  required SeededRng rng,
}) {
  final first = _singleRoundRobin(rng.shuffled(teamIds));
  // Second leg mirrors the first with home/away reversed.
  final second = [
    for (final round in first) [for (final (h, a) in round) (a, h)],
  ];
  return [...first, ...second];
}

/// Generates a **single round-robin** (everyone plays everyone once) using the
/// circle method. Used for the World Cup finals group stage.
List<List<Pairing>> singleRoundRobin(
  List<int> teamIds, {
  required SeededRng rng,
}) => _singleRoundRobin(rng.shuffled(teamIds));

const int _bye = -1;

List<List<Pairing>> _singleRoundRobin(List<int> teams) {
  final arr = [...teams];
  if (arr.length.isOdd) arr.add(_bye);
  final n = arr.length;
  final half = n ~/ 2;
  final rounds = <List<Pairing>>[];

  var ring = [...arr];
  for (var r = 0; r < n - 1; r++) {
    final pairs = <Pairing>[];
    for (var i = 0; i < half; i++) {
      final a = ring[i];
      final b = ring[n - 1 - i];
      if (a == _bye || b == _bye) continue;
      // Alternate home/away by round so it isn't always the same side.
      pairs.add(r.isEven ? (a, b) : (b, a));
    }
    rounds.add(pairs);

    // Rotate clockwise, keeping the first element fixed.
    final fixed = ring[0];
    final rest = ring.sublist(1);
    rest.insert(0, rest.removeLast());
    ring = [fixed, ...rest];
  }
  return rounds;
}
