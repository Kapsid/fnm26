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

/// The outcome of a level knockout tie taken to extra time and, if needed, a
/// penalty shootout. [homeScore]/[awayScore] are the score after extra time;
/// the shootout kick lists are empty when extra time settled it.
class KnockoutOutcome {
  const KnockoutOutcome({
    required this.homeScore,
    required this.awayScore,
    required this.afterExtraTime,
    required this.homeKicks,
    required this.awayKicks,
  });

  /// Score after extra time (equal when it went to penalties).
  final int homeScore;
  final int awayScore;

  /// Whether the tie needed extra time (always true here — it is only built
  /// from a level 90-minute score).
  final bool afterExtraTime;

  /// The shootout: one entry per kick taken, true = scored. Empty when extra
  /// time produced a winner.
  final List<bool> homeKicks;
  final List<bool> awayKicks;

  bool get wentToShootout => homeKicks.isNotEmpty || awayKicks.isNotEmpty;

  int get homePens => homeKicks.where((s) => s).length;
  int get awayPens => awayKicks.where((s) => s).length;

  /// Whether the home side won the tie (in extra time or on penalties).
  bool get homeWon => wentToShootout
      ? homePens > awayPens
      : homeScore > awayScore;
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
    int perGroup = 4,
  }) {
    final rng = SeededRng(rngSeed ^ 0xF1A15);
    final groupCount = qualifierIds.length ~/ perGroup;
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
    for (var pot = 0; pot < perGroup; pot++) {
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
    // Which group each standing came from, so two teams out of the same group
    // are never drawn against each other in the first knockout round.
    final groupOf = <GroupStanding, int>{};
    for (var gi = 0; gi < groups.length; gi++) {
      for (final s in groups[gi]) {
        groupOf[s] = gi;
      }
    }
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
    // Strongest-vs-weakest pairs, then repair any that pit two teams from the
    // same group by swapping the weaker side with another tie's — the standard
    // fix real draw seedings use.
    final pairs = [
      for (var i = 0; i * 2 < n; i++) [seeds[i], seeds[n - 1 - i]],
    ];
    for (var p = 0; p < pairs.length; p++) {
      if (groupOf[pairs[p][0]] != groupOf[pairs[p][1]]) continue;
      for (var q = 0; q < pairs.length; q++) {
        if (q == p) continue;
        if (groupOf[pairs[p][0]] != groupOf[pairs[q][1]] &&
            groupOf[pairs[q][0]] != groupOf[pairs[p][1]]) {
          final tmp = pairs[p][1];
          pairs[p][1] = pairs[q][1];
          pairs[q][1] = tmp;
          break;
        }
      }
    }
    return [for (final pr in pairs) (pr[0].nationId, pr[1].nationId)];
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

  /// The Copa América format: two groups of five, the top FOUR of each group
  /// advancing to the quarter-finals (only the last-placed side in each group
  /// goes out). Cross-paired so group winners are kept apart to the final.
  static List<(int, int)> copaQuarters(List<List<GroupStanding>> groups) {
    int p(int g, int pos) => groups[g][pos].nationId;
    // A = group 0, B = group 1; positions 0-3 are 1st-4th.
    return [
      (p(0, 0), p(1, 3)), // A1 v B4
      (p(1, 1), p(0, 2)), // B2 v A3
      (p(1, 0), p(0, 3)), // B1 v A4
      (p(0, 1), p(1, 2)), // A2 v B3
    ];
  }

  /// Pairs consecutive winners (in bracket order) into the next round's ties.
  static List<(int, int)> pairWinners(List<int> winners) => [
        for (var i = 0; i + 1 < winners.length; i += 2)
          (winners[i], winners[i + 1]),
      ];

  /// Resolves a knockout score so there is always a winner. A level game after
  /// 90 goes to extra time and, if still level, a penalty shootout — see
  /// [decideKnockout]. Returns the score to STORE: the after-extra-time score
  /// when ET settled it, or the winner's score nudged by one when a shootout
  /// did (so the stored fixture always shows a winner).
  ///
  /// The tie is tight but the stronger side is favoured — a coin flip made
  /// every knockout a lottery, so [homeStrength]/[awayStrength] tilt both the
  /// extra-time chances and the shootout.
  static (int, int) resolveTie(
    int home,
    int away,
    SeededRng rng, {
    double homeStrength = 1,
    double awayStrength = 1,
  }) {
    if (home != away) return (home, away);
    final o = decideKnockout(
      home,
      away,
      rng,
      homeStrength: homeStrength,
      awayStrength: awayStrength,
    );
    if (!o.wentToShootout) return (o.homeScore, o.awayScore);
    // A shootout: store the winner one goal clear of the after-ET score.
    return o.homeWon
        ? (o.homeScore + 1, o.awayScore)
        : (o.homeScore, o.awayScore + 1);
  }

  /// Plays out a level knockout: extra time (which may produce goals), then a
  /// penalty shootout if still level. Deterministic from [rng]. The full detail
  /// — the after-ET score and, if it went that far, the kick-by-kick shootout —
  /// lets the match screen show the drama rather than just a nudged scoreline.
  static KnockoutOutcome decideKnockout(
    int home,
    int away,
    SeededRng rng, {
    double homeStrength = 1,
    double awayStrength = 1,
  }) {
    final total = homeStrength + awayStrength;
    final homeShare = total <= 0 ? 0.5 : homeStrength / total;

    // Extra time: a handful of half-chances, each falling to a side by strength
    // and converting at a modest rate — so ET decides some ties and the rest go
    // to penalties, as in the real game.
    var h = home;
    var a = away;
    final chances = rng.rangeInt(2, 5);
    for (var i = 0; i < chances; i++) {
      if (!rng.chance(0.22)) continue; // most half-chances come to nothing
      if (rng.chance(homeShare)) {
        h++;
      } else {
        a++;
      }
    }
    if (h != a) {
      return KnockoutOutcome(
        homeScore: h,
        awayScore: a,
        afterExtraTime: true,
        homeKicks: const [],
        awayKicks: const [],
      );
    }

    // Still level — a shootout. Each side's per-kick conversion is tilted by
    // strength (the stronger side, and its keeper, edge it).
    final homeConv = (0.75 + 0.12 * (homeShare - 0.5) * 2).clamp(0.55, 0.9);
    final awayConv = (0.75 + 0.12 * (0.5 - homeShare) * 2).clamp(0.55, 0.9);
    final homeKicks = <bool>[];
    final awayKicks = <bool>[];
    int hs() => homeKicks.where((s) => s).length;
    int as_() => awayKicks.where((s) => s).length;

    // Whether the best-of-five result is already beyond reach — one side leads
    // by more than the other has kicks remaining.
    bool decided() {
      final hRem = 5 - homeKicks.length;
      final aRem = 5 - awayKicks.length;
      return hs() > as_() + aRem || as_() > hs() + hRem;
    }

    // Best of five, home first — stop the moment it is decided.
    for (var round = 0; round < 5; round++) {
      if (decided()) break;
      homeKicks.add(rng.chance(homeConv));
      if (decided()) break;
      awayKicks.add(rng.chance(awayConv));
    }
    // Sudden death: a pair of kicks each round until one side leads.
    while (hs() == as_()) {
      homeKicks.add(rng.chance(homeConv));
      awayKicks.add(rng.chance(awayConv));
    }

    return KnockoutOutcome(
      homeScore: h,
      awayScore: a,
      afterExtraTime: true,
      homeKicks: homeKicks,
      awayKicks: awayKicks,
    );
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

  /// The full intercontinental play-off bracket as a list of ties, for display.
  ///
  /// Rebuilds the same six-team field as [selectFinalists]/[playoffWinners] and
  /// replays it tie-by-tie, so — called with the SAME seed the finalist
  /// selection used — the recorded winners are exactly the two nations that
  /// took the final World Cup places. The two path finals decide those places.
  static List<PlayoffTie> playoffBracket({
    required Map<Confederation, List<List<GroupStanding>>> byConfederation,
    required Map<int, int> rankingById,
    required SeededRng rng,
  }) {
    int rank(int id) => rankingById[id] ?? 9999;
    final pool = <int>[];
    for (final entry in byConfederation.entries) {
      final fmt = QualificationFormat.forConfederation(entry.key);
      if (fmt.playoffEntrants <= 0) continue;
      final direct = Qualification.qualifiers(entry.value, fmt.finalsBerths);
      final withEntrants = Qualification.qualifiers(
        entry.value,
        fmt.finalsBerths + fmt.playoffEntrants,
      );
      pool.addAll(withEntrants.skip(direct.length));
    }
    pool.sort((a, b) => rank(a).compareTo(rank(b)));
    // Mirror playoffWinners' six-team bracket exactly (same tie order, same
    // match function) so the winners match the real finalist selection.
    if (pool.length != 6) return const [];
    final ties = <PlayoffTie>[];
    int add(int a, int b, {required bool isFinal}) {
      // The winner is decided on the SAME rng stream as playoffWinners, so the
      // finals berths shown here match the real selection exactly. A plausible
      // scoreline is then drawn on a SEPARATE, tie-derived stream, so adding it
      // for display never shifts who actually goes through.
      final w = _playoffMatch(a, b, rankingById, rng);
      final loser = w == a ? b : a;
      final (wg, lg) = _playoffScore(w, loser);
      ties.add((
        home: a,
        away: b,
        homeScore: a == w ? wg : lg,
        awayScore: a == w ? lg : wg,
        winner: w,
        isFinal: isFinal,
      ));
      return w;
    }

    final w1 = add(pool[2], pool[5], isFinal: false);
    final w2 = add(pool[3], pool[4], isFinal: false);
    add(pool[0], w1, isFinal: true);
    add(pool[1], w2, isFinal: true);
    return ties;
  }

  /// A plausible decisive scoreline for a play-off tie, as (winnerGoals,
  /// loserGoals), on a stream derived only from the two nations — independent of
  /// the winner-deciding rng, so it's purely cosmetic and deterministic.
  static (int, int) _playoffScore(int winner, int loser) {
    final side = SeededRng((winner * 131) ^ (loser * 17) ^ 0x9E3B);
    final wg = 1 + side.nextInt(3); // 1..3
    final lg = side.nextInt(wg); // 0..wg-1 (winner always ahead)
    return (wg, lg);
  }
}

/// One intercontinental play-off tie for display: the two nations, the
/// scoreline, the winner, and whether it's a path final (whose winner takes a
/// World Cup place).
typedef PlayoffTie = ({
  int home,
  int away,
  int homeScore,
  int awayScore,
  int winner,
  bool isFinal,
});
