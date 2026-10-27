import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Nations stored in every database but part of no world by default.
///
/// A dormant nation exists only in a career whose world includes it: such a
/// career carries [markerFor] in `draws_watched` (cycle 0), and its world is
/// the base world with the nation in [replaces] swapped out for the dormant
/// one (see `NationRepository.forCareer`). Every other career, and every
/// screen outside a career, never sees it, so a normal world is unchanged.
abstract final class DormantNations {
  /// Greenland. 6 and 44 are retired ids old saves may still reference, so
  /// the next free id is used rather than a gap.
  static const int greenlandId = 212;

  static const Nation greenland = Nation(
    id: greenlandId,
    name: 'Greenland',
    code: 'GRL',
    confederation: Confederation.europe,
    ranking: 209,
    primaryColor: '#C8102E',
  );

  static const List<Nation> all = [greenland];

  static const Set<int> ids = {greenlandId};

  /// The nation each dormant nation stands in for when its world is active.
  static const Map<int, int> replaces = {greenlandId: 45}; // San Marino

  /// The `draws_watched` kind (cycle 0) that makes [nationId] part of a
  /// career's world.
  static String markerFor(int nationId) => 'dormantNation:$nationId';

  /// The prefix every dormant marker shares.
  static const String markerPrefix = 'dormantNation:';

  /// The dormant nation a marker names, or null for any other kind.
  static int? fromMarker(String kind) {
    if (!kind.startsWith(markerPrefix)) return null;
    final id = int.tryParse(kind.substring(markerPrefix.length));
    return id != null && ids.contains(id) ? id : null;
  }

  /// The world of a career holding [active] dormant nations: [base] (the
  /// ranking-ordered base world) minus each replaced nation, plus each
  /// dormant one, re-sorted by ranking. A dormant nation whose replaced
  /// nation is missing from [base] is left out, so the count never changes.
  /// Returns [base] itself when nothing is swapped, so a normal career's
  /// world is the very same list.
  static List<Nation> worldFrom(
    List<Nation> base,
    Set<int> active, {
    required Nation Function(int id) dormant,
  }) {
    if (active.isEmpty) return base;
    // A dormant nation comes in only in place of a nation the base world
    // has, so a world never grows: team counts, pots and slots stay put.
    final present = {for (final n in base) n.id};
    final swapped = {
      for (final d in active)
        if (replaces[d] case final r? when present.contains(r)) d,
    };
    if (swapped.isEmpty) return base;
    final dropped = {for (final d in swapped) replaces[d]!};
    final out = [
      for (final n in base)
        if (!dropped.contains(n.id) && !ids.contains(n.id)) n,
      for (final d in swapped) dormant(d),
    ];
    // Stable: the base list is already ranking-ordered, so only the inserted
    // dormant rows move.
    final indexed = [for (var i = 0; i < out.length; i++) (i, out[i])]
      ..sort((a, b) {
        final c = a.$2.ranking.compareTo(b.$2.ranking);
        return c != 0 ? c : a.$1.compareTo(b.$1);
      });
    return [for (final e in indexed) e.$2];
  }
}
