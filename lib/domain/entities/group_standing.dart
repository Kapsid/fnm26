import 'package:fnm/domain/entities/fixture.dart';

/// A computed standings row for one nation in a qualifying group. Derived from
/// played fixtures rather than stored, so it can never drift out of sync.
class GroupStanding {
  GroupStanding(this.nationId);

  final int nationId;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  int get goalDifference => goalsFor - goalsAgainst;
  int get points => won * 3 + drawn;

  /// Computes the ordered table for a group from its [members] and [fixtures].
  /// Ordering: points, then goal difference, then goals scored.
  static List<GroupStanding> table(
    List<int> members,
    List<Fixture> fixtures,
  ) {
    final rows = {for (final id in members) id: GroupStanding(id)};

    for (final f in fixtures) {
      if (!f.hasResult) continue;
      final home = rows[f.homeNationId];
      final away = rows[f.awayNationId];
      if (home == null || away == null) continue;
      final hs = f.homeScore!;
      final as = f.awayScore!;
      home
        ..played += 1
        ..goalsFor += hs
        ..goalsAgainst += as;
      away
        ..played += 1
        ..goalsFor += as
        ..goalsAgainst += hs;
      if (hs > as) {
        home.won += 1;
        away.lost += 1;
      } else if (hs < as) {
        away.won += 1;
        home.lost += 1;
      } else {
        home.drawn += 1;
        away.drawn += 1;
      }
    }

    final list = rows.values.toList()
      ..sort((a, b) {
        final byPoints = b.points.compareTo(a.points);
        if (byPoints != 0) return byPoints;
        final byGd = b.goalDifference.compareTo(a.goalDifference);
        if (byGd != 0) return byGd;
        return b.goalsFor.compareTo(a.goalsFor);
      });
    return list;
  }
}
