import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/round_robin.dart';

/// A finals group draw: four nations plus their single round-robin fixtures.
class FinalsGroupDraw {
  const FinalsGroupDraw({
    required this.name,
    required this.nationIds,
    required this.fixtures,
  });

  final String name;
  final List<int> nationIds;

  /// `(matchday, homeNationId, awayNationId)` per group game.
  final List<(int, int, int)> fixtures;
}

/// The full World Cup finals group-stage draw.
class FinalsDraw {
  const FinalsDraw({required this.groups});
  final List<FinalsGroupDraw> groups;
}

/// World Cup finals: a pot-based group draw (by world ranking) and the knockout
/// bracket helpers. Pure and deterministic.
abstract final class WorldCupFinals {
  static const groupNames = [
    'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'I', 'J', 'K', 'L', //
  ];

  /// Knockout round labels in progression order.
  static const r32 = 'R32';
  static const r16 = 'R16';
  static const qf = 'QF';
  static const sf = 'SF';
  static const third = '3RD';
  static const finalRound = 'FINAL';

  /// Selects the 48 World Cup finalists from every confederation's qualifying
  /// tables: direct berths per confederation, then the two best entrants of the
  /// intercontinental playoff, and finally every host in [hosts] (each replaces
  /// the weakest-ranked qualifier it isn't already among). Shared by the finals
  /// generator and the draw ceremony so both always agree.
  static List<int> selectFinalists({
    required Map<Confederation, List<List<GroupStanding>>> byConfederation,
    required Map<int, int> rankingById,
    required List<int> hosts,
    SeededRng? playoffRng,
  }) {
    int rank(int id) => rankingById[id] ?? 9999;
    final qualifiers = <int>[];
    final playoffPool = <int>[];
    for (final entry in byConfederation.entries) {
      final fmt = QualificationFormat.forConfederation(entry.key);
      final direct = Qualification.qualifiers(entry.value, fmt.finalsBerths);
      qualifiers.addAll(direct);
      if (fmt.playoffEntrants > 0) {
        final withEntrants = Qualification.qualifiers(
          entry.value,
          fmt.finalsBerths + fmt.playoffEntrants,
        );
        playoffPool.addAll(withEntrants.skip(direct.length));
      }
    }
    // The two remaining places go through the intercontinental play-off: an
    // actually-simulated mini-bracket (strength-weighted) when an rng is given,
    // rather than simply handing them to the two best-ranked entrants.
    playoffPool.sort((a, b) => rank(a).compareTo(rank(b)));
    qualifiers.addAll(
      playoffRng == null
          ? playoffPool.take(QualificationFormat.playoffBerths)
          : playoffWinners(playoffPool, rankingById, playoffRng),
    );

    // Every host auto-qualifies, each replacing the weakest non-host qualifier.
    final missing = hosts.where((h) => !qualifiers.contains(h)).toList();
    if (missing.isNotEmpty && qualifiers.isNotEmpty) {
      qualifiers.sort((a, b) => rank(a).compareTo(rank(b)));
      for (final h in missing) {
        for (var i = qualifiers.length - 1; i >= 0; i--) {
          if (!hosts.contains(qualifiers[i])) {
            qualifiers.removeAt(i);
            break;
          }
        }
        qualifiers.add(h);
      }
    }
    return qualifiers;
  }

  /// Draws [qualifierIds] into groups of four. Teams are seeded into four pots
  /// by world ranking, then one team per pot is drawn into each group. Each
  /// [hosts] entry (when it is one of the qualifiers) is a top seed placed into
  /// its own opening group (host 0 → Group A, host 1 → Group B, …), as at a
  /// real finals with co-hosts.
  static FinalsDraw drawGroups({
    required List<int> qualifierIds,
    required Map<int, int> rankingById,
    required int rngSeed,
    List<int> hosts = const [],
  }) {
    final rng = SeededRng(rngSeed ^ 0xF1A15);
    final groupCount = qualifierIds.length ~/ 4;
    if (groupCount == 0) return const FinalsDraw(groups: []);

    final seeded = [...qualifierIds]
      ..sort(
        (a, b) => (rankingById[a] ?? 9999).compareTo(rankingById[b] ?? 9999),
      );
    // Hosts are top seeds (pot 1) regardless of ranking — one per group,
    // and never more than there are groups.
    final activeHosts = [
      for (final h in hosts)
        if (seeded.contains(h)) h,
    ].take(groupCount).toList();
    for (final h in activeHosts.reversed) {
      seeded
        ..remove(h)
        ..insert(0, h);
    }

    final groups = List.generate(groupCount, (_) => <int>[]);
    for (var pot = 0; pot < 4; pot++) {
      final slice = [
        ...rng.shuffled(
          seeded.sublist(pot * groupCount, (pot + 1) * groupCount),
        ),
      ];
      // Force each host into its own opening group within pot 1 (host k → k).
      if (pot == 0) {
        for (var k = 0; k < activeHosts.length; k++) {
          final hi = slice.indexOf(activeHosts[k]);
          if (hi >= 0 && hi != k) {
            final tmp = slice[k];
            slice[k] = slice[hi];
            slice[hi] = tmp;
          }
        }
      }
      for (var i = 0; i < groupCount; i++) {
        groups[i].add(slice[i]);
      }
    }

    final result = <FinalsGroupDraw>[];
    for (var gi = 0; gi < groupCount; gi++) {
      final rounds = singleRoundRobin(groups[gi], rng: rng);
      final fixtures = <(int, int, int)>[];
      for (var r = 0; r < rounds.length; r++) {
        for (final (home, away) in rounds[r]) {
          fixtures.add((r + 1, home, away));
        }
      }
      result.add(
        FinalsGroupDraw(
          name: groupNames[gi],
          nationIds: groups[gi],
          fixtures: fixtures,
        ),
      );
    }
    return FinalsDraw(groups: result);
  }

  /// Cross-group ranking of standings: points, then goal difference, then goals
  /// scored (best first).
  static int _rank(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    if (byGd != 0) return byGd;
    return b.goalsFor.compareTo(a.goalsFor);
  }

  /// Seeds the group winners, runners-up and the [bestThirds] best third-placed
  /// teams into one bracket by cross-group rank, pairing the strongest seed
  /// with the weakest. Models the modern formats that advance the best
  /// third-placed teams: a 48-team World Cup (12 groups, 8 thirds → 32) and a
  /// 24-team European Championship (6 groups, 4 thirds → 16). [pairWinners]
  /// carries the bracket through to the final.
  static List<(int, int)> knockoutWithThirds(
    List<List<GroupStanding>> groups,
    int bestThirds,
  ) {
    final winners = [for (final g in groups) g[0]]..sort(_rank);
    final runners = [
      for (final g in groups)
        if (g.length > 1) g[1],
    ]..sort(_rank);
    final thirds = [
      for (final g in groups)
        if (g.length > 2) g[2],
    ]..sort(_rank);
    final seeds = [...winners, ...runners, ...thirds.take(bestThirds)];
    final n = seeds.length;
    return [
      for (var i = 0; i * 2 < n; i++)
        (seeds[i].nationId, seeds[n - 1 - i].nationId),
    ];
  }

  /// Round-of-32 pairings for a 48-team finals (12 groups of four): the 24
  /// group qualifiers plus the eight best third-placed teams.
  static List<(int, int)> roundOf32(List<List<GroupStanding>> groups) =>
      knockoutWithThirds(groups, 8);

  /// The best third-placed teams that reach the knockout for a groups-of-four
  /// finals: 8 for a 48-team World Cup (12 groups), 4 for a 24-team continental
  /// (6 groups), otherwise none (top two only).
  static int bestThirdsFor(int groupCount) => switch (groupCount) {
        12 => 8,
        6 => 4,
        _ => 0,
      };

  /// Round-of-16 pairings from the finals group tables (ordered A…H): each
  /// group winner meets a runner-up from another group, halves kept apart.
  static List<(int, int)> roundOf16(List<List<GroupStanding>> groups) {
    int w(int i) => groups[i][0].nationId;
    int r(int i) => groups[i][1].nationId;
    return [
      (w(0), r(1)),
      (w(2), r(3)),
      (w(4), r(5)),
      (w(6), r(7)),
      (w(1), r(0)),
      (w(3), r(2)),
      (w(5), r(4)),
      (w(7), r(6)),
    ];
  }

  /// First knockout-round pairings for a continental finals with 2 or 4 groups:
  /// each group winner meets a runner-up from another group, halves kept apart.
  /// Four groups → quarter-finals (8 teams); two groups → semi-finals (4).
  static List<(int, int)> knockoutFromGroups(List<List<GroupStanding>> groups) {
    int w(int i) => groups[i][0].nationId;
    int r(int i) => groups[i][1].nationId;
    if (groups.length == 4) {
      return [(w(0), r(1)), (w(2), r(3)), (w(1), r(0)), (w(3), r(2))];
    }
    if (groups.length == 2) {
      return [(w(0), r(1)), (w(1), r(0))];
    }
    return [
      for (var i = 0; i + 1 < groups.length; i += 2) (w(i), r(i + 1)),
    ];
  }

  /// Pairs consecutive winners (in bracket order) into the next round's ties.
  static List<(int, int)> pairWinners(List<int> winners) => [
        for (var i = 0; i + 1 < winners.length; i += 2)
          (winners[i], winners[i + 1]),
      ];

  /// Resolves a knockout score so there is always a winner: a level game goes
  /// to a (seeded) shootout, modelled as one extra goal for the winning side.
  ///
  /// The shootout is tight but the stronger side is favoured — a coin flip made
  /// every knockout a lottery, so [homeStrength]/[awayStrength] tilt it (a big
  /// gap wins ~80% of shootouts, a small one only slightly better than even).
  static (int, int) resolveTie(
    int home,
    int away,
    SeededRng rng, {
    double homeStrength = 1,
    double awayStrength = 1,
  }) {
    if (home != away) return (home, away);
    final total = homeStrength + awayStrength;
    final homeWin = total <= 0
        ? 0.5
        : (0.5 + 0.35 * (homeStrength - awayStrength) / total).clamp(0.2, 0.8);
    return rng.chance(homeWin) ? (home + 1, away) : (home, away + 1);
  }

  /// The intercontinental play-off winners ([QualificationFormat.playoffBerths]
  /// places). The entrants are seeded by ranking; in the standard six-team
  /// field the top two get byes to the path finals while the other four contest
  /// two semis, and each semi winner meets a seed for a World Cup place. Each
  /// tie is a strength-weighted, deterministic single match.
  static List<int> playoffWinners(
    List<int> pool,
    Map<int, int> rankingById,
    SeededRng rng,
  ) {
    const berths = QualificationFormat.playoffBerths;
    if (pool.length <= berths) return pool;
    int r(int id) => rankingById[id] ?? 9999;
    final seeds = [...pool]..sort((a, b) => r(a).compareTo(r(b)));
    if (seeds.length == 6) {
      final w1 = _playoffMatch(seeds[2], seeds[5], rankingById, rng);
      final w2 = _playoffMatch(seeds[3], seeds[4], rankingById, rng);
      return [
        _playoffMatch(seeds[0], w1, rankingById, rng),
        _playoffMatch(seeds[1], w2, rankingById, rng),
      ];
    }
    // Uncommon field size — take the best-ranked to fill the berths.
    return seeds.take(berths).toList();
  }

  /// One play-off tie: the stronger (lower-ranked) side is favoured, but a
  /// single knockout always leaves room for a surprise.
  static int _playoffMatch(
    int a,
    int b,
    Map<int, int> rankingById,
    SeededRng rng,
  ) {
    final ra = rankingById[a] ?? 9999;
    final rb = rankingById[b] ?? 9999;
    final winA = (0.5 + (rb - ra) * 0.006).clamp(0.2, 0.8);
    return rng.chance(winA) ? a : b;
  }
}
