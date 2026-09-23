import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';

/// Selects which nations qualify from a confederation's group stage.
///
/// Each group's standings are already ordered best-first. Teams are taken in
/// tiers — all group winners first (ranked against each other), then all
/// runners-up, and so on — until `berths` are filled. This generalises both
/// single-league confederations (one group → take the top N) and multi-group
/// confederations (winners + best runners-up).
///
/// When the groups are UNEVEN, the tiers are ranked on comparable records (see
/// [CrossGroup]): results against the bottom team(s) of the larger groups are
/// discarded, so a runner-up from a six-team group isn't preferred over one
/// from a five-team group purely for having played two more matches.
abstract final class Qualification {
  static List<int> qualifiers(
    List<List<GroupStanding>> groups,
    int berths,
  ) {
    final adjusted = CrossGroup.comparable(groups);
    final result = <int>[];
    final maxLen = adjusted.fold(0, (m, g) => g.length > m ? g.length : m);
    for (var tier = 0; tier < maxLen && result.length < berths; tier++) {
      final atTier = [
        for (final g in adjusted)
          if (tier < g.length) g[tier],
      ]..sort(CrossGroup.rank);
      for (final s in atTier) {
        if (result.length < berths) result.add(s.nationId);
      }
    }
    return result;
  }
}
