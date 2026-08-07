import 'package:fnm/domain/entities/group_standing.dart';

/// Makes teams from DIFFERENT-SIZED groups comparable to one another.
///
/// Cross-group ladders — the best runners-up, the best third-placed teams — rank
/// nations that never played each other. That is fine while every group is the
/// same size, and unfair the moment they aren't: a team in a group of six plays
/// two more games than a team in a group of five, so it banks more points, more
/// goals and a bigger goal difference for the same quality of football. Ranking
/// them on raw totals rewards being drawn into the bigger group.
///
/// The fix is the real UEFA/FIFA rule: when the groups are uneven, results
/// against the bottom-placed team(s) of the LARGER groups are discarded, so
/// every team in the ladder is judged over the same number of matches. A
/// six-team group drops its last-placed side; the five-team groups count in
/// full; everyone is then compared over eight games.
///
/// Only the cross-group comparison is adjusted. A group's own table — who won
/// it, who finished third — is always the full, real record; a discarded result
/// never changes a nation's position in its own group.
abstract final class CrossGroup {
  /// The number of teams whose results count when comparing across [groups]:
  /// the size of the smallest group. Groups already this size are untouched.
  static int comparableSize(Iterable<List<GroupStanding>> groups) {
    var min = 0;
    for (final g in groups) {
      if (g.isEmpty) continue;
      if (min == 0 || g.length < min) min = g.length;
    }
    return min;
  }

  /// [groups] with every row made comparable: in any group larger than
  /// [comparableSize], results against the teams placed below that cut-off are
  /// stripped from every other row.
  ///
  /// Row ORDER is preserved exactly — position in the group is decided by the
  /// real table, and only the numbers used to compare across groups change.
  /// When every group is the same size this returns the rows unchanged.
  static List<List<GroupStanding>> comparable(
    List<List<GroupStanding>> groups,
  ) {
    final keep = comparableSize(groups);
    if (keep == 0) return groups;
    if (groups.every((g) => g.isEmpty || g.length == keep)) return groups;
    return [
      for (final g in groups)
        if (g.length <= keep)
          g
        else
          () {
            // The teams that only exist because this group is bigger: the ones
            // finishing below the smallest group's last place.
            final drop = {for (final s in g.skip(keep)) s.nationId};
            return [
              for (var i = 0; i < g.length; i++)
                // The dropped teams keep their own full record — they are the
                // bottom of the group and never contest a cross-group ladder.
                if (i < keep) g[i].excluding(drop) else g[i],
            ];
          }(),
    ];
  }

  /// Cross-group ranking of two comparable rows: points, then goal difference,
  /// then goals scored (best first).
  static int rank(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    if (byGd != 0) return byGd;
    return b.goalsFor.compareTo(a.goalsFor);
  }

  /// Every team finishing at [tier] (0 = winners, 1 = runners-up, 2 = thirds)
  /// across [groups], made comparable and ranked best-first.
  static List<GroupStanding> tier(List<List<GroupStanding>> groups, int index) {
    final adjusted = comparable(groups);
    return [
      for (final g in adjusted)
        if (index < g.length) g[index],
    ]..sort(rank);
  }

  /// Whether [groups] are uneven, so a cross-group ladder is being computed on
  /// a reduced set of results. Screens use this to say so rather than leaving
  /// an unexplained points total on the table.
  static bool isUneven(List<List<GroupStanding>> groups) {
    final sizes = {
      for (final g in groups)
        if (g.isNotEmpty) g.length,
    };
    return sizes.length > 1;
  }
}
