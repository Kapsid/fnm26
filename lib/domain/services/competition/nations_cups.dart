import 'dart:math';

import 'package:fnm/domain/entities/enums.dart';

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

  /// The cup a manager from [c] follows: his own, or Europe's when his
  /// confederation has none (the one cup every manager followed before).
  static Confederation followedBy(Confederation c) =>
      forConfederation(c) != null ? c : Confederation.europe;

  /// The confederation whose cup a manager from [c] plays in and is judged on,
  /// or null when his confederation has none. Unlike [followedBy] there is no
  /// fallback: an Asian manager's hub, board and draws carry no Nations Cup at
  /// all, as before the other cups existed.
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

  /// Quarter-final pairs (home, away) of the Finals Eight from each zone's two
  /// qualifiers, best first: W1 v E2, E1 v S2, S1 v N2, N1 v W2.
  static List<(int, int)> finalsEightPairs(
    Map<AfricaZone, List<int>> bestTwoByZone,
  ) {
    int pick(AfricaZone z, int i) => bestTwoByZone[z]![i];
    return [
      (pick(AfricaZone.west, 0), pick(AfricaZone.east, 1)),
      (pick(AfricaZone.east, 0), pick(AfricaZone.centralSouthern, 1)),
      (pick(AfricaZone.centralSouthern, 0), pick(AfricaZone.north, 1)),
      (pick(AfricaZone.north, 0), pick(AfricaZone.west, 1)),
    ];
  }
}
