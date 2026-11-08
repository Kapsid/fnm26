import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_names.dart';

/// The styles a manager drifts to from a nation's own: two each, the
/// nearest in spirit first.
const Map<NationStyle, List<NationStyle>> kNeighbourStyles = {
  NationStyle.possession: [NationStyle.balanced, NationStyle.flair],
  NationStyle.highPress: [NationStyle.direct, NationStyle.possession],
  NationStyle.defensive: [NationStyle.counter, NationStyle.physical],
  NationStyle.direct: [NationStyle.physical, NationStyle.highPress],
  NationStyle.counter: [NationStyle.defensive, NationStyle.direct],
  NationStyle.flair: [NationStyle.possession, NationStyle.counter],
  NationStyle.physical: [NationStyle.direct, NationStyle.defensive],
  NationStyle.balanced: [NationStyle.possession, NationStyle.counter],
};

/// The managers a career's world starts with: one in charge of every AI
/// nation, each with a backdated spell and a fictional past, and a pool of
/// free ones. Pure and deterministic from the career's seed and the cycle
/// it is seeded in, on a stream of its own (never the world's).
abstract final class ManagerSeeder {
  /// How many managers start out of work.
  static const int freeCount = 60;

  /// The youngest and oldest a seeded manager is on the day he is seeded.
  static const int minAge = 38;
  static const int maxAge = 66;

  /// How far back a seeded incumbent's spell may start, in years.
  static const int maxTenureYears = 6;

  /// The youngest a manager takes his first job at, in years: an earlier
  /// spell that would start younger is not drawn.
  static const int minFirstJobAge = 32;

  /// How far a manager's earlier job may sit above the one after it in the
  /// ranking: careers mostly climb.
  static const int earlierRankReach = 30;

  /// The share of a pedigree's nations run by one of their own.
  static double domesticShare(int pedigree) => pedigree <= 2
      ? 0.85
      : pedigree == 3
      ? 0.70
      : 0.55;

  /// How often a foreign manager comes from a pedigree 1 to 3 nation.
  static const double foreignFromTopShare = 0.90;

  static const List<SpellEnd> _pastEnds = [
    SpellEnd.sacked,
    SpellEnd.resigned,
    SpellEnd.contractEnd,
  ];

  /// The world seeded on [asOf] for a career of [rngSeed] in [seedCycle].
  ///
  /// Every nation in [nations] outside [playerNationIds] gets an incumbent;
  /// [rankById] orders where a manager worked before; [pools] (upper-case
  /// FIFA code) names them; [packManagers] (nation id) renames a nation's
  /// incumbent and sets his nationality, which then decides his style.
  /// A drawn name in [realNames] (a real person's) is never given.
  static ManagerWorld seed({
    required int rngSeed,
    required int seedCycle,
    required DateTime asOf,
    required List<Nation> nations,
    required Map<int, int> rankById,
    required Set<int> playerNationIds,
    required Map<String, NamePoolLists> pools,
    required Map<int, ({String name, String nationality})> packManagers,
    Set<String> realNames = const {},
  }) {
    final rng = SeededRng(varietySeed('mgr:seed:$rngSeed:$seedCycle'));
    final ordered = [...nations]..sort((a, b) => a.id.compareTo(b.id));
    final ai = [
      for (final n in ordered)
        if (!playerNationIds.contains(n.id)) n,
    ];
    int pedigree(String code) => NationIdentity.of(code).pedigree;
    bool hasPool(String code) {
      final p = pools[code.toUpperCase()];
      return p != null && p.first.isNotEmpty && p.sur.isNotEmpty;
    }

    // Nationalities a manager can be drawn with: those that can name him,
    // or every nation should no pool be at hand.
    final namedCodes = [
      for (final n in ordered)
        if (hasPool(n.code)) n,
    ];
    final origins = namedCodes.isEmpty ? ordered : namedCodes;
    final used = <String>{
      for (final e in packManagers.entries)
        if (!playerNationIds.contains(e.key)) e.value.name.trim(),
    };

    String nameFor(String code) {
      final pool = ManagerNames.poolFor(pools, code);
      // A real person's name is always drawn again. A clash with a name
      // already given is drawn again a few times, then kept: a big pool
      // never runs out, and a tiny one is better repeated than unnamed.
      for (var i = 0; i < 64; i++) {
        final name = ManagerNames.build(pool, rng);
        if (realNames.contains(name)) continue;
        if (i < 8 && used.contains(name)) continue;
        used.add(name);
        return name;
      }
      throw StateError('No fictional manager name in the $code pool');
    }

    NationStyle styleFor(String home, String nationality) {
      final domestic = home.toUpperCase() == nationality.toUpperCase();
      final base = NationIdentity.styleOf(nationality);
      // Both drawn every time, so the stream does not hang on the answer.
      final keep = rng.chance(domestic ? 0.70 : 0.60);
      final drift = rng.pick(kNeighbourStyles[base]!);
      return keep ? base : drift;
    }

    String foreignFor(int nationId) {
      final top = rng.chance(foreignFromTopShare);
      final pick = [
        for (final n in origins)
          if (n.id != nationId && (!top || pedigree(n.code) <= 3)) n,
      ];
      final from = pick.isEmpty
          ? [
              for (final n in origins)
                if (n.id != nationId) n,
            ]
          : pick;
      if (from.isEmpty) return '';
      var total = 0;
      for (final n in from) {
        total += _weight(pedigree(n.code));
      }
      var at = rng.nextInt(total);
      for (final n in from) {
        at -= _weight(pedigree(n.code));
        if (at < 0) return n.code.toUpperCase();
      }
      return from.last.code.toUpperCase();
    }

    final drafts = <_Draft>[];
    final startOf = <int, DateTime>{};

    // Every AI nation's incumbent.
    for (final n in ai) {
      final home = n.code.toUpperCase();
      final domestic = rng.chance(domesticShare(pedigree(home)));
      var nationality = domestic ? home : foreignFor(n.id);
      if (nationality.isEmpty) nationality = home;
      // Drawn even when the world names him (and the drawn name kept
      // aside), so a named manager leaves every other draw as it was.
      var name = nameFor(nationality);
      if (packManagers[n.id] case final named?) {
        name = named.name.trim();
        nationality = named.nationality.trim().toUpperCase();
      }
      final style = styleFor(home, nationality);
      final age = rng.rangeInt(minAge, maxAge);
      final from = _daysBefore(asOf, rng.nextInt(maxTenureYears * 365 + 1));
      final years = rng.rangeInt(2, 6);
      var until = DateTime(from.year + years, from.month, from.day);
      final floor = DateTime(asOf.year + 1, asOf.month, asOf.day);
      if (until.isBefore(floor)) until = floor;
      startOf[n.id] = from;
      drafts.add(
        _Draft(
          name: name,
          nationality: nationality,
          birthYear: asOf.year - age,
          style: style,
          current: (nationId: n.id, from: from, until: until),
        ),
      );
    }

    // The free pool: any nationality that can name him.
    for (var i = 0; i < freeCount && origins.isNotEmpty; i++) {
      final nationality = rng.pick(origins).code.toUpperCase();
      final name = nameFor(nationality);
      final style = styleFor('', nationality);
      final age = rng.rangeInt(minAge, maxAge);
      drafts.add(
        _Draft(
          name: name,
          nationality: nationality,
          birthYear: asOf.year - age,
          style: style,
        ),
      );
    }

    // One or two earlier spells each, at other AI nations, each over before
    // the job after it began and before that nation's incumbent arrived.
    for (final d in drafts) {
      final count = rng.rangeInt(1, 2);
      var cursor = d.current?.from ?? asOf;
      var refRank = d.current == null ? null : rankById[d.current!.nationId];
      final worked = {?d.current?.nationId};
      for (var k = 0; k < count; k++) {
        final gap = rng.nextInt(366);
        final length = rng.rangeInt(365, 4 * 365);
        final candidates = [
          for (final n in ai)
            if (!worked.contains(n.id) &&
                (refRank == null ||
                    (rankById[n.id] ?? refRank) >= refRank - earlierRankReach))
              n,
        ];
        final pickFrom = candidates.isEmpty
            ? [
                for (final n in ai)
                  if (!worked.contains(n.id)) n,
              ]
            : candidates;
        final why = rng.pick(_pastEnds);
        final extra = rng.rangeInt(1, 2);
        if (pickFrom.isEmpty) break;
        final at = rng.pick(pickFrom);
        var end = _daysBefore(cursor, gap);
        final arrived = startOf[at.id];
        if (arrived != null && arrived.isBefore(end)) end = arrived;
        final start = _daysBefore(end, length);
        if (start.year - d.birthYear < minFirstJobAge) break;
        d.past.add((
          nationId: at.id,
          from: start,
          to: end,
          why: why,
          until: why == SpellEnd.contractEnd
              ? end
              : DateTime(end.year + extra, end.month, end.day),
        ));
        worked.add(at.id);
        cursor = start;
        refRank = rankById[at.id] ?? refRank;
      }
    }

    // Ids in draft order; spells numbered in date order.
    final managers = <WorldManager>[];
    final unnumbered =
        <
          ({
            int managerId,
            int nationId,
            DateTime from,
            DateTime? to,
            SpellEnd? why,
            DateTime until,
          })
        >[];
    for (var i = 0; i < drafts.length; i++) {
      final d = drafts[i];
      final id = i + 1;
      var entered = d.current?.from ?? asOf;
      for (final p in d.past) {
        if (p.from.isBefore(entered)) entered = p.from;
        unnumbered.add((
          managerId: id,
          nationId: p.nationId,
          from: p.from,
          to: p.to,
          why: p.why,
          until: p.until,
        ));
      }
      if (d.current case final c?) {
        unnumbered.add((
          managerId: id,
          nationId: c.nationId,
          from: c.from,
          to: null,
          why: null,
          until: c.until,
        ));
      }
      managers.add(
        WorldManager(
          managerId: id,
          name: d.name,
          nationality: d.nationality,
          birthYear: d.birthYear,
          style: d.style.name,
          origin: ManagerOrigin.fresh,
          enteredAt: entered,
        ),
      );
    }
    unnumbered.sort((a, b) {
      final byDate = a.from.compareTo(b.from);
      if (byDate != 0) return byDate;
      final byNation = a.nationId.compareTo(b.nationId);
      return byNation != 0 ? byNation : a.managerId.compareTo(b.managerId);
    });
    return ManagerWorld(
      managers: managers,
      spells: [
        for (var i = 0; i < unnumbered.length; i++)
          ManagerSpell(
            spellNo: i + 1,
            managerId: unnumbered[i].managerId,
            nationId: unnumbered[i].nationId,
            fromDate: unnumbered[i].from,
            toDate: unnumbered[i].to,
            endReason: unnumbered[i].why,
            contractUntil: unnumbered[i].until,
          ),
      ],
    );
  }

  static int _weight(int pedigree) => (6 - pedigree) * (6 - pedigree);

  static DateTime _daysBefore(DateTime d, int days) =>
      DateTime(d.year, d.month, d.day - days);
}

class _Draft {
  _Draft({
    required this.name,
    required this.nationality,
    required this.birthYear,
    required this.style,
    this.current,
  });

  final String name;
  final String nationality;
  final int birthYear;
  final NationStyle style;
  final ({int nationId, DateTime from, DateTime until})? current;
  final List<
    ({int nationId, DateTime from, DateTime to, SpellEnd why, DateTime until})
  >
  past = [];
}
