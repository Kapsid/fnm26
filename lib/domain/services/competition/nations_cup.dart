import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

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
  /// outcomes: each group winner (bar the top league) climbs a league, each
  /// group's bottom side (bar the lowest league) drops one. Balanced 4-up,
  /// 4-down at every boundary, so league sizes stay stable.
  static Map<int, int> promoteRelegate({
    required Map<int, int> tiers,
    required List<({int tier, int winner, int bottom})> groups,
  }) {
    if (groups.isEmpty) return tiers;
    final maxTier = groups.map((g) => g.tier).reduce((a, b) => a > b ? a : b);
    final next = {...tiers};
    for (final g in groups) {
      if (g.tier > 0) next[g.winner] = g.tier - 1; // promoted
      if (g.tier < maxTier) next[g.bottom] = g.tier + 1; // relegated
    }
    return next;
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
