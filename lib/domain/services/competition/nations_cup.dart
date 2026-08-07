import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';

/// One finished league group, as the ladder reads it: which league it belongs
/// to, and the rows of the side that won it and the side that finished last.
///
/// The rows (rather than bare ids) are what let promotion and relegation be
/// compared ACROSS the groups of a league — when a boundary has fewer places
/// than candidates, the best winners go up and the worst bottoms go down.
typedef LadderGroup = ({int tier, GroupStanding winner, GroupStanding bottom});

/// The Nations Cup league ladder: a confederation's nations split into leagues
/// of [leagueSize] (League A = tier 0, League B = tier 1, …). The ladder is
/// seeded from the world ranking for the very first cup, then persisted and
/// only reshuffled by promotion and relegation off each cup's results.
abstract final class NationsCup {
  static const int leagueSize = 16;

  /// The display letter for a tier (0 → 'A', 1 → 'B', …).
  static String leagueLetter(int tier) => String.fromCharCode(65 + tier);

  /// A group's name encodes its league in the first character (e.g. 'B2' is
  /// League B, group 2), so the tier round-trips out of the stored name.
  static int tierOfGroupName(String name) =>
      name.isEmpty ? 0 : name.codeUnitAt(0) - 65;

  /// The lowest league of [confederation]'s ladder — the tier whose bottom
  /// sides stay put, because there is nothing beneath them to drop into (see
  /// [promoteRelegate], which only relegates while `tier < maxTier`).
  ///
  /// Each confederation ladders separately, so only its own nations count: a
  /// deeper ladder elsewhere must not make this one look bottomless. A
  /// confederation too small to fill two leagues has a single league that is
  /// both the top and the bottom.
  static int lowestTier({
    required Map<int, int> tiers,
    required Confederation confederation,
    required Confederation? Function(int nationId) confederationOf,
  }) {
    var lowest = 0;
    for (final entry in tiers.entries) {
      if (confederationOf(entry.key) != confederation) continue;
      if (entry.value > lowest) lowest = entry.value;
    }
    return lowest;
  }

  /// Whether the group named [groupName] sits in [confederation]'s lowest
  /// league, and so has no relegation places.
  static bool isLowestLeague({
    required String groupName,
    required Map<int, int> tiers,
    required Confederation confederation,
    required Confederation? Function(int nationId) confederationOf,
  }) =>
      tierOfGroupName(groupName) >=
      lowestTier(
        tiers: tiers,
        confederation: confederation,
        confederationOf: confederationOf,
      );

  /// Seeds every confederation's nations into leagues by world ranking — used
  /// only for a save's first Nations Cup (and when the manager takes a nation
  /// in a confederation that hasn't laddered yet).
  static Map<int, int> seedTiers(
    List<Nation> nations,
    int Function(Nation) rankOf,
  ) {
    final byConf = <Confederation, List<Nation>>{};
    for (final n in nations) {
      (byConf[n.confederation] ??= []).add(n);
    }
    final tiers = <int, int>{};
    for (final list in byConf.values) {
      final sorted = [...list]..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
      for (var i = 0; i < sorted.length; i++) {
        tiers[sorted[i].id] = i ~/ leagueSize;
      }
    }
    return tiers;
  }

  /// Applies promotion/relegation to [tiers] from a finished cup's group
  /// outcomes, one boundary at a time: as many sides come up from a league as
  /// go down into it, so no league ever grows or shrinks.
  ///
  /// It used to promote every group winner and relegate every group's bottom
  /// side independently, which is only balanced while neighbouring leagues have
  /// the same number of groups. The bottom league never does — it holds the
  /// remainder of the confederation — so League C sent four sides down into a
  /// League D that could only send two back up. Two nations leaked downwards
  /// every cycle: C withered, D swelled, and the ladder drifted apart.
  ///
  /// A boundary now moves `min(groups above, groups below)` sides each way. The
  /// worst of the bottom sides go down and the best of the group winners come
  /// up, compared across the whole league by points, then goal difference, then
  /// goals — so when there are fewer places than candidates it is the table
  /// that decides who takes them.
  static Map<int, int> promoteRelegate({
    required Map<int, int> tiers,
    required List<LadderGroup> groups,
  }) {
    if (groups.isEmpty) return tiers;
    final maxTier = groups.map((g) => g.tier).reduce((a, b) => a > b ? a : b);
    final byTier = <int, List<LadderGroup>>{};
    for (final g in groups) {
      (byTier[g.tier] ??= []).add(g);
    }

    final next = {...tiers};
    for (var tier = 1; tier <= maxTier; tier++) {
      final up = [...?byTier[tier]]
        ..sort((a, b) => _strongerFirst(a.winner, b.winner));
      final down = [...?byTier[tier - 1]]
        ..sort((a, b) => _strongerFirst(b.bottom, a.bottom));
      final places = up.length < down.length ? up.length : down.length;
      for (var i = 0; i < places; i++) {
        next[up[i].winner.nationId] = tier - 1; // promoted
        next[down[i].bottom.nationId] = tier; // relegated
      }
    }
    return next;
  }

  /// Orders two rows best-first: points, then goal difference, then goals.
  static int _strongerFirst(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    return byGd != 0 ? byGd : b.goalsFor.compareTo(a.goalsFor);
  }

  /// Promotion/relegation when only the manager's OWN league ([playerTier]) was
  /// actually played: its group [winners] climb a league and its group
  /// [bottoms] drop, each swapping places with a team from the neighbouring
  /// league chosen by [rankOf] (the weakest of the league above comes down; the
  /// strongest of the league below comes up), so every league keeps its size.
  static Map<int, int> promoteRelegateLeague({
    required Map<int, int> tiers,
    required int playerTier,
    required List<int> winners,
    required List<int> bottoms,
    required int Function(int nationId) rankOf,
  }) {
    final next = {...tiers};
    final maxTier =
        tiers.values.isEmpty ? 0 : tiers.values.reduce((a, b) => a > b ? a : b);

    if (playerTier > 0 && winners.isNotEmpty) {
      // Winners go up; the weakest of the league above drop to fill the spots.
      final above = [
        for (final e in tiers.entries)
          if (e.value == playerTier - 1) e.key,
      ]..sort((a, b) => rankOf(b).compareTo(rankOf(a))); // weakest first
      for (final w in winners) {
        next[w] = playerTier - 1;
      }
      for (final d in above.take(winners.length)) {
        next[d] = playerTier;
      }
    }

    if (playerTier < maxTier && bottoms.isNotEmpty) {
      // Bottoms drop; the strongest of the league below rise to fill.
      final below = [
        for (final e in tiers.entries)
          if (e.value == playerTier + 1) e.key,
      ]..sort((a, b) => rankOf(a).compareTo(rankOf(b))); // strongest first
      for (final b in bottoms) {
        next[b] = playerTier + 1;
      }
      for (final u in below.take(bottoms.length)) {
        next[u] = playerTier;
      }
    }

    return next;
  }
}
