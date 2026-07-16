import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// A candidature: one nation standing alone, or two or three bidding jointly.
/// Ordered strongest-first, so the first is the primary host if the bid wins.
typedef HostBid = List<int>;

/// Decides World Cup hosts. The hosting confederation rotates each edition and
/// a strong member is chosen deterministically, so the host of any year is
/// reproducible and the decision can be "revealed" after the previous final.
abstract final class WorldCupHosts {
  /// Confederation rotation order across editions.
  static const List<Confederation> _rotation = [
    Confederation.europe,
    Confederation.southAmerica,
    Confederation.northAmerica,
    Confederation.asia,
    Confederation.africa,
    Confederation.europe,
    Confederation.oceania,
  ];

  /// The confederation hosting the World Cup in [year].
  static Confederation confederationFor(int year) =>
      _rotation[(year ~/ 4) % _rotation.length];

  /// The shortlist of realistic host candidates for [confederation] (its
  /// strongest members), strongest first.
  static List<int> hostCandidates({
    required Confederation confederation,
    required List<Nation> nations,
    int count = _shortlistSize,
  }) {
    final pool = nations.where((n) => n.confederation == confederation).toList()
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
  }) {
    final shortlist = hostCandidates(
      confederation: confederation,
      nations: nations,
      count: count,
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

  /// The bids to host the World Cup in [year].
  static List<HostBid> worldCupBids({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) =>
      hostBids(
        confederation: confederationFor(year),
        nations: nations,
        seed: _wcSeed(year, seed),
      );

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
  /// one nation but is sometimes a joint candidature of two or three (as at
  /// 2002 and 2026). Hosts all auto-qualify and are seeded into the opening
  /// groups.
  static List<int> hostsFor({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final bids = worldCupBids(year: year, nations: nations, seed: seed);
    if (bids.isEmpty) {
      // No members of the hosting confederation: fall back to the world's best
      // rather than nobody.
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

  /// The bids to host [confederation]'s championship in [cycle].
  static List<HostBid> continentalBids({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) =>
      hostBids(
        confederation: confederation,
        nations: nations,
        seed: _contSeed(confederation, cycle, seed),
      );

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
