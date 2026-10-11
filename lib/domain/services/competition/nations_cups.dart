import 'dart:math';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';

/// How a confederation's Nations Cup is organised.
enum NationsCupFormat { ladder, zones }

/// The four geographic zones of the African Nations Cup.
enum AfricaZone { north, west, east, centralSouthern }

/// A cup's stored (canonical) name and its format.
typedef NationsCupInfo = ({String name, NationsCupFormat format});

/// The registry of confederation Nations Cups. Names are stored competition
/// identifiers, translated at display like every other competition name.
abstract final class NationsCups {
  static const String europe = 'Nations Cup';
  static const String northAmerica = 'North America Nations Cup';
  static const String africa = 'African Nations Cup';
  static const List<String> allNames = [europe, northAmerica, africa];
  static const List<Confederation> confederations = [
    Confederation.europe,
    Confederation.northAmerica,
    Confederation.africa,
  ];

  static NationsCupInfo? forConfederation(Confederation c) {
    switch (c) {
      case Confederation.europe:
        return (name: europe, format: NationsCupFormat.ladder);
      case Confederation.northAmerica:
        return (name: northAmerica, format: NationsCupFormat.ladder);
      case Confederation.africa:
        return (name: africa, format: NationsCupFormat.zones);
      case Confederation.asia:
      case Confederation.southAmerica:
      case Confederation.oceania:
        return null;
    }
  }

  /// The confederation whose cup a manager from [c] plays in and is judged on,
  /// or null when his confederation has none. There is no fallback: an Asian
  /// manager's hub, board and draws carry no Nations Cup at all, as before the
  /// other cups existed.
  static Confederation? ofManager(Confederation? c) =>
      c != null && forConfederation(c) != null ? c : null;

  static bool isNationsCup(String competitionName) =>
      allNames.contains(competitionName.trim());

  /// FIFA code to zone for the 54 African nations.
  static const Map<String, AfricaZone> africaZoneByCode = {
    'ALG': AfricaZone.north,
    'EGY': AfricaZone.north,
    'LBY': AfricaZone.north,
    'MAR': AfricaZone.north,
    'MTN': AfricaZone.north,
    'TUN': AfricaZone.north,
    'BEN': AfricaZone.west,
    'BFA': AfricaZone.west,
    'CHA': AfricaZone.west,
    'CIV': AfricaZone.west,
    'CPV': AfricaZone.west,
    'GAM': AfricaZone.west,
    'GHA': AfricaZone.west,
    'GNB': AfricaZone.west,
    'GUI': AfricaZone.west,
    'LBR': AfricaZone.west,
    'MLI': AfricaZone.west,
    'NGA': AfricaZone.west,
    'NIG': AfricaZone.west,
    'SEN': AfricaZone.west,
    'SLE': AfricaZone.west,
    'TOG': AfricaZone.west,
    'BDI': AfricaZone.east,
    'COM': AfricaZone.east,
    'DJI': AfricaZone.east,
    'ERI': AfricaZone.east,
    'ETH': AfricaZone.east,
    'KEN': AfricaZone.east,
    'MAD': AfricaZone.east,
    'MRI': AfricaZone.east,
    'MWI': AfricaZone.east,
    'RWA': AfricaZone.east,
    'SDN': AfricaZone.east,
    'SEY': AfricaZone.east,
    'SOM': AfricaZone.east,
    'SSD': AfricaZone.east,
    'TAN': AfricaZone.east,
    'UGA': AfricaZone.east,
    'ANG': AfricaZone.centralSouthern,
    'BOT': AfricaZone.centralSouthern,
    'CGO': AfricaZone.centralSouthern,
    'CMR': AfricaZone.centralSouthern,
    'COD': AfricaZone.centralSouthern,
    'CTA': AfricaZone.centralSouthern,
    'EQG': AfricaZone.centralSouthern,
    'GAB': AfricaZone.centralSouthern,
    'LES': AfricaZone.centralSouthern,
    'MOZ': AfricaZone.centralSouthern,
    'NAM': AfricaZone.centralSouthern,
    'RSA': AfricaZone.centralSouthern,
    'STP': AfricaZone.centralSouthern,
    'SWZ': AfricaZone.centralSouthern,
    'ZAM': AfricaZone.centralSouthern,
    'ZIM': AfricaZone.centralSouthern,
  };

  /// Group-name prefix per zone.
  static String zonePrefix(AfricaZone z) => switch (z) {
    AfricaZone.north => 'N',
    AfricaZone.west => 'W',
    AfricaZone.east => 'E',
    AfricaZone.centralSouthern => 'S',
  };

  static AfricaZone? zoneOfGroupName(String groupName) {
    if (groupName.isEmpty) return null;
    final p = groupName[0];
    for (final z in AfricaZone.values) {
      if (zonePrefix(z) == p) return z;
    }
    return null;
  }

  /// Groups for one zone from nations ranked best-first: 16 become 4 groups of
  /// 4, 6 become 2 groups of 3. Pot k is the k-th slice of the ranking, and
  /// each group takes one nation per pot, shuffled deterministically by [seed].
  static List<List<int>> zoneGroups(List<int> rankedIds, int seed) {
    final groupCount = rankedIds.length <= 6 ? 2 : 4;
    final rng = Random(seed);
    final groups = List.generate(groupCount, (_) => <int>[]);
    for (var start = 0; start < rankedIds.length; start += groupCount) {
      final pot = rankedIds.sublist(
        start,
        min(start + groupCount, rankedIds.length),
      )..shuffle(rng);
      for (var i = 0; i < pot.length; i++) {
        groups[i].add(pot[i]);
      }
    }
    return groups;
  }

  /// How many runners-up join the 14 group winners in the Round of 16.
  static const int runnersUpThrough = 2;

  /// The African cup's knockout field from its zone groups (each group's
  /// standings, best first): every group winner, and every runner-up, each
  /// ranked best-first across groups. The [runnersUpThrough] best runners-up
  /// complete the Round of 16.
  ///
  /// The North's groups of three make the groups uneven, so the comparison
  /// drops results against each bigger group's bottom side ([CrossGroup]),
  /// then breaks a dead heat on world ranking ([rankOf], lower is better).
  static ({List<GroupStanding> winners, List<GroupStanding> runnersUp})
  knockoutField(List<List<GroupStanding>> groups, int Function(int) rankOf) {
    final adjusted = CrossGroup.comparable(groups);
    int order(GroupStanding a, GroupStanding b) {
      final byTable = CrossGroup.rank(a, b);
      if (byTable != 0) return byTable;
      return rankOf(a.nationId).compareTo(rankOf(b.nationId));
    }

    return (
      winners: [
        for (final g in adjusted)
          if (g.isNotEmpty) g[0],
      ]..sort(order),
      runnersUp: [
        for (final g in adjusted)
          if (g.length > 1) g[1],
      ]..sort(order),
    );
  }

  /// Round of 16 pairs (home, away) from the qualifiers seeded best-first
  /// (the ranked group winners, then the qualifying runners-up), in bracket
  /// order: consecutive ties meet in the quarter-finals, so seeds 1 and 2 can
  /// only meet in the final. A runner-up is never paired with the winner of
  /// its own group ([groupOf] gives a nation's group) when a swap avoids it.
  static List<(int, int)> roundOf16Pairs(
    List<int> seeded,
    String? Function(int) groupOf,
  ) {
    assert(seeded.length == 16);
    final s = [...seeded];
    // Seeds 15 and 16 are the runners-up; seed 1 meets 16, seed 2 meets 15.
    if (groupOf(s[0]) == groupOf(s[15]) || groupOf(s[1]) == groupOf(s[14])) {
      final t = s[15];
      s[15] = s[14];
      s[14] = t;
    }
    (int, int) tie(int a, int b) => (s[a - 1], s[b - 1]);
    return [
      tie(1, 16),
      tie(8, 9),
      tie(4, 13),
      tie(5, 12),
      tie(2, 15),
      tie(7, 10),
      tie(3, 14),
      tie(6, 11),
    ];
  }
}
