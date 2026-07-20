import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// A candidature: one nation standing alone, or two or three bidding jointly.
/// Ordered strongest-first, so the first is the primary host if the bid wins.
typedef HostBid = List<int>;

/// Decides World Cup hosts. Any nation may bid EXCEPT the previous edition's
/// host confederation (so the same continent never hosts twice in a row) and
/// anyone who hosted one of the last three editions; the winner is a strong
/// nation drawn deterministically, so the host of any year is reproducible and
/// can be "revealed" after the previous final.
abstract final class WorldCupHosts {
  /// The first World Cup edition the game manages (cycle 0). Editions step by 4
  /// years; the host chain is computed forward from here.
  static const int _firstWcYear = 2030;

  /// The shortlist of realistic host candidates for [confederation] (its
  /// strongest members), strongest first. Nations in [exclude] — the recent
  /// hosts of this competition — are dropped, so a country can't host again so
  /// soon after its last turn.
  static List<int> hostCandidates({
    required Confederation confederation,
    required List<Nation> nations,
    int count = _shortlistSize,
    Set<int> exclude = const {},
  }) {
    final pool = nations
        .where((n) => n.confederation == confederation && !exclude.contains(n.id))
        .toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));
    return pool.take(count).map((n) => n.id).toList();
  }

  /// The bids on the table for [confederation]: its strongest members, some of
  /// them standing jointly. Each bid is one nation, or two or three bidding
  /// together. Strongest bid first.
  ///
  /// Bids are formed *before* the winner is drawn — the draw picks a bid, not a
  /// nation. That ordering is the point: co-hosts used to be drawn separately
  /// afterwards, so a joint candidature could not be shown in the candidacy
  /// list, only revealed with the result.
  ///
  /// Neighbours in the ranking bid together, which is how it tends to go: a
  /// joint bid is two comparable neighbours, not a superpower adopting a
  /// minnow.
  static List<HostBid> hostBids({
    required Confederation confederation,
    required List<Nation> nations,
    required int seed,
    int count = _shortlistSize,
    Set<int> exclude = const {},
  }) {
    final shortlist = hostCandidates(
      confederation: confederation,
      nations: nations,
      count: count,
      exclude: exclude,
    );
    if (shortlist.isEmpty) return const [];

    final rng = SeededRng(seed ^ 0x81D5);
    final bids = <HostBid>[];
    var i = 0;
    while (i < shortlist.length) {
      final roll = rng.nextDouble();
      var size = 1;
      if (roll < _coHostChance && i + 1 < shortlist.length) size = 2;
      if (roll < _tripleHostChance && i + 2 < shortlist.length) size = 3;
      bids.add(shortlist.sublist(i, i + size));
      i += size;
    }
    return bids;
  }

  /// Draws a winner from [bids], favouring the stronger ones.
  ///
  /// Linear (triangular) weights: the strongest bid is weighted `n`, the next
  /// `n-1`, … so a heavyweight is favoured but genuine surprises happen — a far
  /// more open race than a square law, which makes a big nation almost a lock.
  static HostBid _pickBid(List<HostBid> bids, int seed) {
    if (bids.isEmpty) return const [];
    final rng = SeededRng(seed);
    final n = bids.length;
    final weights = [for (var i = 0; i < n; i++) n - i];
    final total = weights.fold<int>(0, (s, w) => s + w).toDouble();
    var roll = rng.nextDouble() * total;
    for (var i = 0; i < n; i++) {
      roll -= weights[i];
      if (roll <= 0) return bids[i];
    }
    return bids.first;
  }

  /// The seed stream for the World Cup host draw of [year].
  static int _wcSeed(int year, int seed) => seed ^ (year * 0x51ED);

  /// The bids to host the World Cup in [year]: the strongest nations from ANY
  /// confederation EXCEPT the previous edition's host confederation, minus any
  /// nation that hosted one of the last three editions — grouped into solo or
  /// joint (co-host) candidatures, strongest first. Deterministic.
  static List<HostBid> worldCupBids({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final ex = _wcExclusions(year, nations, seed);
    return _worldCupBidsFor(
      year: year,
      nations: nations,
      seed: seed,
      barredConfederation: ex.barred,
      excludeIds: ex.recent,
    );
  }

  /// The candidate bids for [year] given the two exclusions. The eligible pool
  /// is every nation not in [barredConfederation] and not in [excludeIds],
  /// ranked; joint bids pair ranking-adjacent neighbours of the SAME
  /// confederation (a cross-continent joint bid isn't realistic).
  static List<HostBid> _worldCupBidsFor({
    required int year,
    required List<Nation> nations,
    required int seed,
    required Confederation? barredConfederation,
    required Set<int> excludeIds,
  }) {
    final shortlist = (nations
            .where((n) =>
                n.confederation != barredConfederation &&
                !excludeIds.contains(n.id))
            .toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking)))
        .take(_shortlistSize)
        .toList();
    if (shortlist.isEmpty) return const [];

    final rng = SeededRng(_wcSeed(year, seed) ^ 0x81D5);
    final bids = <HostBid>[];
    var i = 0;
    while (i < shortlist.length) {
      final roll = rng.nextDouble();
      final conf = shortlist[i].confederation;
      var size = 1;
      if (roll < _coHostChance &&
          i + 1 < shortlist.length &&
          shortlist[i + 1].confederation == conf) {
        size = 2;
        if (roll < _tripleHostChance &&
            i + 2 < shortlist.length &&
            shortlist[i + 2].confederation == conf) {
          size = 3;
        }
      }
      bids.add([for (final n in shortlist.sublist(i, i + size)) n.id]);
      i += size;
    }
    return bids;
  }

  /// The two exclusions for [year], derived from the deterministic host chain up
  /// to the previous edition: the previous host's confederation, and every
  /// nation that hosted one of the last three editions.
  static ({Confederation? barred, Set<int> recent}) _wcExclusions(
    int year,
    List<Nation> nations,
    int seed,
  ) {
    final prior = _wcHostChain(year - 4, nations, seed);
    final byId = {for (final n in nations) n.id: n};
    final barred =
        prior.isEmpty ? null : byId[prior.last.first]?.confederation;
    final recent = <int>{for (final w in prior.reversed.take(3)) ...w};
    return (barred: barred, recent: recent);
  }

  /// Every World Cup host decision from [_firstWcYear] up to and including
  /// [upto], each computed from the editions before it — so the "not the last
  /// host's confederation, no last-three-hosts nation" rule is applied
  /// consistently without unbounded recursion. Linear in the number of editions.
  static List<HostBid> _wcHostChain(int upto, List<Nation> nations, int seed) {
    final byId = {for (final n in nations) n.id: n};
    final winners = <HostBid>[];
    for (var y = _firstWcYear; y <= upto; y += 4) {
      final barred =
          winners.isEmpty ? null : byId[winners.last.first]?.confederation;
      final recent = <int>{for (final w in winners.reversed.take(3)) ...w};
      final bids = _worldCupBidsFor(
        year: y,
        nations: nations,
        seed: seed,
        barredConfederation: barred,
        excludeIds: recent,
      );
      winners.add(_pickBid(bids, _wcSeed(y, seed)));
    }
    return winners;
  }

  /// The primary host nation id for the World Cup in [year] — the first name on
  /// the winning bid.
  static int hostFor({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final hosts = hostsFor(year: year, nations: nations, seed: seed);
    return hosts.isEmpty ? 0 : hosts.first;
  }

  /// Every host of the World Cup in [year] — the winning bid, which is usually
  /// one nation but is sometimes a joint candidature of two or three. Hosts all
  /// auto-qualify and are seeded into the opening groups.
  static List<int> hostsFor({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final bids = worldCupBids(year: year, nations: nations, seed: seed);
    if (bids.isEmpty) {
      // Everyone somehow excluded: fall back to the world's best rather than
      // nobody.
      final all = [...nations]..sort((a, b) => a.ranking.compareTo(b.ranking));
      return all.isEmpty ? const [] : [all.first.id];
    }
    return _pickBid(bids, _wcSeed(year, seed));
  }

  /// The World Cup host ids for [year] as a set — hosts auto-qualify and sit
  /// out qualifying (playing only friendlies in those windows), so they are
  /// excluded from every confederation's qualifying pool.
  static Set<int> worldCupHostIds({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) =>
      hostsFor(year: year, nations: nations, seed: seed).toSet();

  /// The seed stream for a continental host draw.
  static int _contSeed(Confederation confederation, int cycle, int seed) =>
      seed ^ (cycle * 0x2C9F) ^ (confederation.index * 0x51ED) ^ 0xC047;

  /// The bids to host [confederation]'s championship in [cycle], dropping the
  /// recent hosts (the last three editions) so a country can't host again so
  /// soon.
  static List<HostBid> continentalBids({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) =>
      _continentalBids(
        confederation: confederation,
        cycle: cycle,
        seed: seed,
        nations: nations,
        exclude: _recentContinentalHosts(
          confederation: confederation,
          cycle: cycle,
          seed: seed,
          nations: nations,
        ),
      );

  static List<HostBid> _continentalBids({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
    required Set<int> exclude,
  }) =>
      hostBids(
        confederation: confederation,
        nations: nations,
        seed: _contSeed(confederation, cycle, seed),
        exclude: exclude,
      );

  /// The nations that hosted this confederation's championship in the previous
  /// three cycles (naive picks, computed without the exclusion to avoid
  /// recursion) — barred from the current edition.
  static Set<int> _recentContinentalHosts({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
    int editions = 3,
  }) {
    final recent = <int>{};
    for (var i = 1; i <= editions; i++) {
      final c = cycle - i;
      if (c < 0) break;
      final bids = _continentalBids(
        confederation: confederation,
        cycle: c,
        seed: seed,
        nations: nations,
        exclude: const {},
      );
      if (bids.isNotEmpty) {
        recent.addAll(_pickBid(bids, _contSeed(confederation, c, seed)));
      }
    }
    return recent;
  }

  /// The primary host of a continental championship for a confederation in a
  /// given [cycle], derived deterministically (like the World Cup host) so it
  /// can be re-computed anywhere without being stored.
  static int continentalHostFor({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) {
    final hosts = continentalHostsFor(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
    );
    return hosts.isEmpty ? 0 : hosts.first;
  }

  /// Every host of a continental championship — the winning bid, occasionally a
  /// joint one (as at Euro 2000/2008/2012).
  static List<int> continentalHostsFor({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) {
    final bids = continentalBids(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
    );
    if (bids.isEmpty) return const [];
    return _pickBid(bids, _contSeed(confederation, cycle, seed));
  }

  /// The chance an edition is co-hosted at all, and the chance it is shared
  /// three ways. Co-hosting is the exception: a solo host is the normal case,
  /// a joint bid a talking point, and a triple bid rare.
  ///
  /// One roll drives both, so [_tripleHostChance] is a subset of
  /// [_coHostChance] — they must stay ordered.
  static const double _coHostChance = 0.15;
  static const double _tripleHostChance = 0.04;

  /// How many of a confederation's strongest members make the host shortlist —
  /// both the weighted draw pool and the candidates shown in the ceremony.
  static const int _shortlistSize = 12;

  /// Picks a single host from [confederation] — the primary name on the
  /// winning bid. Falls back to the strongest nation overall if the
  /// confederation has no members. Deterministic for a given [seed].
  ///
  /// Draws through [hostBids] rather than picking a nation directly, so this
  /// can never name a different winner from [hostsFor].
  static int hostFromConfederation({
    required Confederation confederation,
    required List<Nation> nations,
    required int seed,
  }) {
    final bids = hostBids(
      confederation: confederation,
      nations: nations,
      seed: seed,
    );
    if (bids.isEmpty) {
      final all = [...nations]..sort((a, b) => a.ranking.compareTo(b.ranking));
      return all.isEmpty ? 0 : all.first.id;
    }
    return _pickBid(bids, seed).first;
  }
}
