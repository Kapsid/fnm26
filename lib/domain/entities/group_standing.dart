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
  ///
  /// Ordering: points first, then — among teams level on points — the
  /// head-to-head record between exactly those teams (head-to-head points,
  /// then head-to-head goal difference, then head-to-head goals), as UEFA
  /// resolves a group. Only if that is still level does it fall back to overall
  /// goal difference then overall goals. Teams that never drew level on points
  /// are unaffected, so the common case is unchanged.
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

    // Primary order: points. Within each cluster of teams level on points,
    // resolve by their head-to-head mini-table before overall GD/goals.
    final all = rows.values.toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    final ordered = <GroupStanding>[];
    var i = 0;
    while (i < all.length) {
      var j = i;
      while (j < all.length && all[j].points == all[i].points) {
        j++;
      }
      final cluster = all.sublist(i, j);
      if (cluster.length > 1) _orderByHeadToHead(cluster, fixtures);
      ordered.addAll(cluster);
      i = j;
    }
    return ordered;
  }

  /// Reorders [cluster] (teams level on points) by their head-to-head record —
  /// only the matches played *between* the tied teams count — then falls back
  /// to overall goal difference and goals.
  static void _orderByHeadToHead(
    List<GroupStanding> cluster,
    List<Fixture> fixtures,
  ) {
    final ids = {for (final s in cluster) s.nationId};
    final pts = {for (final s in cluster) s.nationId: 0};
    final gf = {for (final s in cluster) s.nationId: 0};
    final ga = {for (final s in cluster) s.nationId: 0};
    for (final f in fixtures) {
      if (!f.hasResult) continue;
      if (!ids.contains(f.homeNationId) || !ids.contains(f.awayNationId)) {
        continue;
      }
      final hs = f.homeScore!;
      final as = f.awayScore!;
      gf[f.homeNationId] = gf[f.homeNationId]! + hs;
      ga[f.homeNationId] = ga[f.homeNationId]! + as;
      gf[f.awayNationId] = gf[f.awayNationId]! + as;
      ga[f.awayNationId] = ga[f.awayNationId]! + hs;
      if (hs > as) {
        pts[f.homeNationId] = pts[f.homeNationId]! + 3;
      } else if (hs < as) {
        pts[f.awayNationId] = pts[f.awayNationId]! + 3;
      } else {
        pts[f.homeNationId] = pts[f.homeNationId]! + 1;
        pts[f.awayNationId] = pts[f.awayNationId]! + 1;
      }
    }
    cluster.sort((a, b) {
      final byPts = pts[b.nationId]!.compareTo(pts[a.nationId]!);
      if (byPts != 0) return byPts;
      final gdA = gf[a.nationId]! - ga[a.nationId]!;
      final gdB = gf[b.nationId]! - ga[b.nationId]!;
      final byGd = gdB.compareTo(gdA);
      if (byGd != 0) return byGd;
      final byGf = gf[b.nationId]!.compareTo(gf[a.nationId]!);
      if (byGf != 0) return byGf;
      // Still level head-to-head: overall goal difference, then overall goals.
      final byOverallGd = b.goalDifference.compareTo(a.goalDifference);
      if (byOverallGd != 0) return byOverallGd;
      return b.goalsFor.compareTo(a.goalsFor);
    });
  }
}
