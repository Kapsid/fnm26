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
  /// spell is cut short rather than start younger.
  static const int minFirstJobAge = 30;

  /// The shortest earlier spell, in days: one cut to fit is never shorter.
  static const int minPastSpellDays = 180;

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
  /// A drawn name in [realNames] (a real person's) is never given; when
  /// [pools] cannot give one, the nationality's [defaultPools] (the game's
  /// own lists, under a world's) and then England's are drawn from.
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
    Map<String, NamePoolLists> defaultPools = const {},
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

    String nameFor(String code) => drawName(
      code,
      rng,
      pools: pools,
      defaultPools: defaultPools,
      realNames: realNames,
      used: used,
    );

    NationStyle styleFor(String home, String nationality) =>
        drawStyle(home, nationality, rng);

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

    // One or two earlier spells each, at other AI nations. A nation's
    // spells never overlap: each earlier spell is placed in a stretch when
    // nobody was in charge there (before its incumbent arrived and clear of
    // every earlier spell already placed), over before the manager's next
    // job began, and cut short rather than start before he was
    // [minFirstJobAge]. The first always finds room; a second that does
    // not is not drawn.
    final occupied = <int, List<({DateTime from, DateTime to})>>{
      for (final d in drafts)
        if (d.current case final c?)
          c.nationId: [(from: c.from, to: _openEnded)],
    };
    for (final d in drafts) {
      final count = rng.rangeInt(1, 2);
      var cursor = d.current?.from ?? asOf;
      var refRank = d.current == null ? null : rankById[d.current!.nationId];
      final worked = {?d.current?.nationId};
      final floor = DateTime(d.birthYear + minFirstJobAge);
      for (var k = 0; k < count; k++) {
        final gap = rng.nextInt(366);
        final length = rng.rangeInt(365, 4 * 365);
        final why = rng.pick(_pastEnds);
        final extra = rng.rangeInt(1, 2);
        final near = <Nation>[];
        final far = <Nation>[];
        for (final n in ai) {
          if (worked.contains(n.id)) continue;
          final climb =
              refRank == null ||
              (rankById[n.id] ?? refRank) >= refRank - earlierRankReach;
          (climb ? near : far).add(n);
        }
        final order = [...rng.shuffled(near), ...rng.shuffled(far)];
        ({Nation at, DateTime from, DateTime to})? placed;
        // The drawn gap first; with none, if that leaves no room anywhere.
        for (final before in [_daysBefore(cursor, gap), cursor]) {
          for (final n in order) {
            final w = _latestFree(occupied[n.id] ?? const [], floor, before);
            if (w == null) continue;
            final earliest = _daysBefore(w.to, length);
            placed = (
              at: n,
              from: earliest.isBefore(w.from) ? w.from : earliest,
              to: w.to,
            );
            break;
          }
          if (placed != null) break;
        }
        if (placed == null) break;
        final (:at, :from, :to) = placed;
        d.past.add((
          nationId: at.id,
          from: from,
          to: to,
          why: why,
          until: why == SpellEnd.contractEnd
              ? to
              : DateTime(to.year + extra, to.month, to.day),
        ));
        (occupied[at.id] ??= []).add((from: from, to: to));
        worked.add(at.id);
        cursor = from;
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

  /// A fictional name for a manager of nationality [code], drawn on [rng]
  /// and added to [used]: from [pools], then [defaultPools] (the game's own
  /// lists), then England's. A real person's name (in [realNames]) is always
  /// drawn again, from the next pool once one runs dry; a clash with a name
  /// in [used] is drawn again a few times, then kept: a tiny pool is better
  /// repeated than unnamed.
  static String drawName(
    String code,
    SeededRng rng, {
    required Map<String, NamePoolLists> pools,
    required Map<String, NamePoolLists> defaultPools,
    required Set<String> realNames,
    required Set<String> used,
  }) {
    bool usable(NamePoolLists? p) =>
        p != null && p.first.isNotEmpty && p.sur.isNotEmpty;
    final key = code.toUpperCase();
    final stages = <NamePoolLists>[];
    for (final p in [
      pools[key],
      defaultPools[key],
      defaultPools['ENG'],
      pools['ENG'],
    ]) {
      if (usable(p) && !stages.any((q) => identical(q, p))) stages.add(p!);
    }
    if (stages.isEmpty) {
      throw StateError('No name pool for $key and none for ENG');
    }
    late String name;
    for (final pool in stages) {
      for (var i = 0; i < 64; i++) {
        name = ManagerNames.build(pool, rng);
        if (realNames.contains(name)) continue;
        if (i < 8 && used.contains(name)) continue;
        used.add(name);
        return name;
      }
    }
    // Every pool gave only real names: unreachable with England's.
    used.add(name);
    return name;
  }

  /// A style for a manager of [nationality] at a nation coded [home] (empty
  /// for none): his country's own 70% of the time at home, 60% abroad,
  /// otherwise a neighbouring one. Both draws are taken every time.
  static NationStyle drawStyle(
    String home,
    String nationality,
    SeededRng rng,
  ) {
    final domestic = home.toUpperCase() == nationality.toUpperCase();
    final base = NationIdentity.styleOf(nationality);
    final keep = rng.chance(domestic ? 0.70 : 0.60);
    final drift = rng.pick(kNeighbourStyles[base]!);
    return keep ? base : drift;
  }

  /// The weight a nation of [pedigree] has when a manager's country is drawn.
  static int weight(int pedigree) => _weight(pedigree);

  static int _weight(int pedigree) => (6 - pedigree) * (6 - pedigree);

  /// The end an open spell is given while spells are placed.
  static final DateTime _openEnded = DateTime(9999);

  /// The latest stretch after [floor] and up to [before] that none of
  /// [taken] covers and that is at least [minPastSpellDays] long; null when
  /// there is none.
  static ({DateTime from, DateTime to})? _latestFree(
    List<({DateTime from, DateTime to})> taken,
    DateTime floor,
    DateTime before,
  ) {
    final sorted = [...taken]..sort((a, b) => b.from.compareTo(a.from));
    var to = before;
    // Walk the occupied stretches latest first, each free stretch lying
    // between one's end and the start of the one after it.
    for (var i = 0; i <= sorted.length; i++) {
      final DateTime freeFrom;
      if (i == sorted.length) {
        freeFrom = floor;
      } else {
        final t = sorted[i];
        if (!t.from.isBefore(to)) continue;
        if (t.to.isBefore(to)) {
          freeFrom = t.to.isAfter(floor) ? t.to : floor;
        } else {
          // [to] falls inside this stretch: free time ends at its start.
          to = t.from;
          continue;
        }
      }
      if (_daysBetween(freeFrom, to) >= minPastSpellDays) {
        return (from: freeFrom, to: to);
      }
      if (i < sorted.length) to = sorted[i].from;
    }
    return null;
  }

  static int _daysBetween(DateTime a, DateTime b) => DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

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
