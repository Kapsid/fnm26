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
  /// intercontinental playoff, and finally the [host] (which replaces the
  /// weakest-ranked qualifier if it didn't already make the cut). Shared by the
  /// finals generator and the draw ceremony so both always agree.
  static List<int> selectFinalists({
    required Map<Confederation, List<List<GroupStanding>>> byConfederation,
    required Map<int, int> rankingById,
    required int host,
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
    playoffPool.sort((a, b) => rank(a).compareTo(rank(b)));
    qualifiers.addAll(playoffPool.take(QualificationFormat.playoffBerths));

    if (!qualifiers.contains(host) && qualifiers.isNotEmpty) {
      qualifiers
        ..sort((a, b) => rank(a).compareTo(rank(b)))
        ..removeLast()
        ..add(host);
    }
    return qualifiers;
  }

  /// Draws [qualifierIds] into groups of four. Teams are seeded into four pots
  /// by world ranking, then one team per pot is drawn into each group.
  static FinalsDraw drawGroups({
    required List<int> qualifierIds,
    required Map<int, int> rankingById,
    required int rngSeed,
  }) {
    final rng = SeededRng(rngSeed ^ 0xF1A15);
    final groupCount = qualifierIds.length ~/ 4;
    if (groupCount == 0) return const FinalsDraw(groups: []);

    final seeded = [...qualifierIds]
      ..sort(
        (a, b) => (rankingById[a] ?? 9999).compareTo(rankingById[b] ?? 9999),
      );

    final groups = List.generate(groupCount, (_) => <int>[]);
    for (var pot = 0; pot < 4; pot++) {
      final slice = rng.shuffled(
        seeded.sublist(pot * groupCount, (pot + 1) * groupCount),
      );
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

  /// Round-of-32 pairings for a 48-team finals (12 groups of four). The 12
  /// group winners, 12 runners-up and the eight best third-placed teams are
  /// seeded into one 32-team bracket by cross-group rank; the strongest seed
  /// meets the weakest, and [pairWinners] carries it through to the final.
  static List<(int, int)> roundOf32(List<List<GroupStanding>> groups) {
    final winners = [for (final g in groups) g[0]]..sort(_rank);
    final runners = [for (final g in groups) g[1]]..sort(_rank);
    final thirds = [
      for (final g in groups)
        if (g.length > 2) g[2],
    ]..sort(_rank);
    final seeds = [...winners, ...runners, ...thirds.take(8)];
    final n = seeds.length;
    return [
      for (var i = 0; i * 2 < n; i++)
        (seeds[i].nationId, seeds[n - 1 - i].nationId),
    ];
  }

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
  /// to a (seeded) shootout, modelled as one extra goal for the chosen side.
  static (int, int) resolveTie(int home, int away, SeededRng rng) {
    if (home != away) return (home, away);
    return rng.chance(0.5) ? (home + 1, away) : (home, away + 1);
  }
}
