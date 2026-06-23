import 'package:fnm/domain/entities/group_standing.dart';

/// Selects which nations qualify from a confederation's group stage.
///
/// Each group's standings are already ordered best-first. Teams are taken in
/// tiers — all group winners first (ranked against each other), then all
/// runners-up, and so on — until `berths` are filled. This generalises both
/// single-league confederations (one group → take the top N) and multi-group
/// confederations (winners + best runners-up).
abstract final class Qualification {
  static List<int> qualifiers(
    List<List<GroupStanding>> groups,
    int berths,
  ) {
    final result = <int>[];
    final maxLen = groups.fold(0, (m, g) => g.length > m ? g.length : m);
    for (var tier = 0; tier < maxLen && result.length < berths; tier++) {
      final atTier = [
        for (final g in groups)
          if (tier < g.length) g[tier],
      ]..sort(_compare);
      for (final s in atTier) {
        if (result.length < berths) result.add(s.nationId);
      }
    }
    return result;
  }

  /// Cross-group ranking: points, then goal difference, then goals scored.
  static int _compare(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    if (byGd != 0) return byGd;
    return b.goalsFor.compareTo(a.goalsFor);
  }
}
