import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Nations stored in every database but part of no world by default.
///
/// A dormant nation exists only in a career whose world includes it: such a
/// career carries [markerFor] in `draws_watched` (cycle 0), and its world is
/// the base world with the nation in [replaces] swapped out for the dormant
/// one, or with an [additions] nation simply added (see
/// `NationRepository.forCareer`). Every other career never sees it, so a
/// world without the marker is unchanged.
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

  /// Zanzibar, the second dormant nation: the next free id after Greenland.
  static const int zanzibarId = 213;

  /// Zanzibar starts where Chad, the nation it stands in for, stands on the
  /// starting ranking (181st), near the bottom of Africa. Its colours are the
  /// flag's: the blue band over the green.
  static const Nation zanzibar = Nation(
    id: zanzibarId,
    name: 'Zanzibar',
    code: 'ZAN',
    confederation: Confederation.africa,
    ranking: 181,
    primaryColor: '#00A3DD',
    secondaryColor: '#1EB53A',
  );

  /// Belarus, back from 1.0.9 in careers created from then on (see
  /// [forNewCareers]). 6 is the id it had before it was removed: nothing
  /// references it since (its players, 601 to 623, were pruned with it).
  static const int belarusId = 6;

  /// Belarus sits 96th on FIFA's table, straight after Palestine (95th, the
  /// game's 94th with Russia left out), so it shares Palestine's place
  /// rather than pushing every nation below down one. It has no tie inside
  /// Europe. Its colours are the flag's red over green.
  static const Nation belarus = Nation(
    id: belarusId,
    name: 'Belarus',
    code: 'BLR',
    confederation: Confederation.europe,
    ranking: 94,
    primaryColor: '#CE1720',
    secondaryColor: '#007C30',
  );

  static const List<Nation> all = [greenland, zanzibar, belarus];

  static const Set<int> ids = {greenlandId, zanzibarId, belarusId};

  /// Dormant nations that join a world without standing in for anyone: the
  /// world grows by one (Europe's 53 become 54).
  static const Set<int> additions = {belarusId};

  /// The dormant nations every ordinary career created from 1.0.9 on
  /// includes (`CareerService.create`). A campaign run never does (its seed
  /// was searched on the world without them), and a career created earlier
  /// never gains them: its marker is written at creation only.
  static const Set<int> forNewCareers = {belarusId};

  /// The nation each dormant nation stands in for when its world is active.
  static const Map<int, int> replaces = {
    greenlandId: 45, // San Marino
    zanzibarId: 110, // Chad
  };

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
  /// nation is missing from [base] is left out, so a swap never changes the
  /// count; an [additions] nation always comes in, one more nation.
  /// Returns [base] itself when nothing changes, so a normal career's world
  /// is the very same list.
  static List<Nation> worldFrom(
    List<Nation> base,
    Set<int> active, {
    required Nation Function(int id) dormant,
  }) {
    if (active.isEmpty) return base;
    // A replacing dormant nation comes in only in place of a nation the base
    // world has, so a swap never grows a world: team counts, pots and slots
    // stay put. An addition is the one way a world grows.
    final present = {for (final n in base) n.id};
    final swapped = {
      for (final d in active)
        if (replaces[d] case final r? when present.contains(r))
          d
        else if (additions.contains(d) && !present.contains(d))
          d,
    };
    if (swapped.isEmpty) return base;
    final dropped = {
      for (final d in swapped) ?replaces[d],
    };
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
