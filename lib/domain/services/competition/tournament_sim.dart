import 'package:fnm/core/rng/seeded_rng.dart';

/// The outcome of a simulated knockout tournament.
typedef TournamentResult = ({
  int champion,
  int runnerUp,
  int third,
  int finalHome,
  int finalAway,
});

/// A lightweight, deterministic single-elimination tournament simulator used
/// for background competitions (continental cups) that aren't played match by
/// match. Stronger teams win more often; the bracket is standard-seeded so top
/// seeds meet late.
abstract final class TournamentSim {
  /// [seededByStrength] must be ordered strongest-first; [strengthById] gives a
  /// positive strength per team. Returns null if fewer than four teams.
  static TournamentResult? run({
    required List<int> seededByStrength,
    required Map<int, int> strengthById,
    required int seed,
  }) {
    var size = 1;
    while (size * 2 <= seededByStrength.length) {
      size *= 2;
    }
    if (size < 4) return null;

    final teams = seededByStrength.take(size).toList();
    final order = _seedOrder(size); // 1-based seed positions in bracket order
    var round = [for (final s in order) teams[s - 1]];

    final rng = SeededRng(seed ^ 0x70C9);
    var semiLosers = <int>[];
    var finalists = <int>[];
    while (round.length > 1) {
      if (round.length == 2) finalists = [...round];
      final next = <int>[];
      final losers = <int>[];
      for (var i = 0; i < round.length; i += 2) {
        final a = round[i];
        final b = round[i + 1];
        final winner = _winner(a, b, strengthById, rng);
        next.add(winner);
        losers.add(winner == a ? b : a);
      }
      if (round.length == 4) semiLosers = losers;
      round = next;
    }

    final champion = round.first;
    final runnerUp = finalists.firstWhere((t) => t != champion);
    final third = semiLosers.isEmpty
        ? runnerUp
        : _winner(semiLosers.first, semiLosers.last, strengthById, rng);

    // A plausible final scoreline (champion listed first); occasionally level,
    // decided on penalties.
    final home = 1 + rng.nextInt(3);
    final away = rng.nextInt(home + 1); // 0..home — home==away means pens
    return (
      champion: champion,
      runnerUp: runnerUp,
      third: third,
      finalHome: home,
      finalAway: away,
    );
  }

  static int _winner(int a, int b, Map<int, int> strength, SeededRng rng) {
    final sa = (strength[a] ?? 1).clamp(1, 1 << 20);
    final sb = (strength[b] ?? 1).clamp(1, 1 << 20);
    // Square the strengths so the better side is favoured more firmly and
    // knockout upsets stay the exception, matching the played engine's bias.
    final wa = sa * sa;
    final wb = sb * sb;
    return rng.nextDouble() < wa / (wa + wb) ? a : b;
  }

  /// First-round pairings for a [size]-team bracket from [seededByStrength]
  /// (strongest first), standard-seeded so top seeds are kept apart.
  static List<(int, int)> bracketPairs(
    List<int> seededByStrength,
    int size,
  ) {
    final order = _seedOrder(size);
    final teams = seededByStrength.take(size).toList();
    final bracket = [for (final s in order) teams[s - 1]];
    return [
      for (var i = 0; i + 1 < bracket.length; i += 2)
        (bracket[i], bracket[i + 1]),
    ];
  }

  /// Standard tournament seeding order (1-based) so seed 1 meets seed 2 only in
  /// the final, etc. e.g. n=4 → [1,4,3,2].
  static List<int> _seedOrder(int n) {
    var seeds = [1, 2];
    while (seeds.length < n) {
      final m = seeds.length * 2 + 1;
      final next = <int>[];
      for (final s in seeds) {
        next
          ..add(s)
          ..add(m - s);
      }
      seeds = next;
    }
    return seeds;
  }
}
