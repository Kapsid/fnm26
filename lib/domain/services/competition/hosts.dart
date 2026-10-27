import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/nation/nation_geography.dart';

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
    final pool =
        nations
            .where(
              (n) =>
                  n.confederation == confederation && !exclude.contains(n.id),
            )
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
  /// A joint bid pairs geographic neighbours: 95% of the time a co-host shares
  /// the primary's subregion (Spain + Portugal, USA + Canada + Mexico), and
  /// only ~5% of joint bids reach for a partner from further afield.
  static List<HostBid> hostBids({
    required Confederation confederation,
    required List<Nation> nations,
    required int seed,
    int count = _shortlistSize,
    Set<int> exclude = const {},
  }) {
    final ranked =
        nations
            .where(
              (n) =>
                  n.confederation == confederation && !exclude.contains(n.id),
            )
            .toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    if (ranked.isEmpty) return const [];
    return _bidsFrom(ranked, count, seed);
  }

  /// The candidatures for a ranking-sorted eligible [ranked] pool: the joint
  /// and solo bids of its strongest [count] members, plus — now and again —
  /// one outsider standing alone at the bottom of the ballot.
  static List<HostBid> _bidsFrom(List<Nation> ranked, int count, int seed) {
    final shortlist = ranked.take(count).toList();
    if (shortlist.isEmpty) return const [];
    final bids = _bidsFromShortlist(shortlist, SeededRng(seed ^ 0x81D5));
    final outsider = _outsider(ranked, count, SeededRng(seed ^ 0x0DDBA11));
    if (outsider != null) bids.add([outsider.id]);
    return bids;
  }

  /// An unfancied country putting its hand up, or null (the usual answer).
  ///
  /// The candidate field used to be exactly the top twelve, so every bidding
  /// round the manager ever saw was the same dozen heavyweights and the race
  /// had no texture. A real one occasionally has an outsider stand — Qatar and
  /// Morocco were not on anybody's list either.
  ///
  /// It stands ALONE, and its bid goes last: the weighted draw hands the final
  /// bid the smallest share of any, so an outsider is a name on the ballot far
  /// more often than it is a winner, and it never dilutes a joint candidature
  /// between genuine neighbours.
  static Nation? _outsider(List<Nation> ranked, int count, SeededRng rng) {
    if (ranked.length <= count) return null;
    if (rng.nextDouble() >= _outsiderChance) return null;
    final end = (count + _outsiderDepth).clamp(count, ranked.length);
    final tail = ranked.sublist(count, end);
    return tail.isEmpty ? null : tail[rng.nextInt(tail.length)];
  }

  /// The subregion of a nation, falling back to its confederation when it has
  /// no finer geographic tag.
  static String _subregion(Nation n) =>
      NationGeography.subregionFor(n.code, n.confederation.name);

  /// Forms the solo and joint candidatures from a ranking-sorted [shortlist].
  /// The primary is always the strongest remaining nation; when a co-host roll
  /// fires, its partner(s) are drawn as geographic neighbours 95% of the time
  /// (same subregion, nearest-ranked), else a nearest-ranked partner of any
  /// origin. Deterministic in [rng].
  static List<HostBid> _bidsFromShortlist(
    List<Nation> shortlist,
    SeededRng rng,
  ) {
    final remaining = [...shortlist];
    final bids = <HostBid>[];
    while (remaining.isNotEmpty) {
      final primary = remaining.removeAt(0);
      final bid = <int>[primary.id];
      final roll = rng.nextDouble();
      if (roll < _coHostChance && remaining.isNotEmpty) {
        final want = roll < _tripleHostChance ? 2 : 1;
        // 95% of joint bids are between neighbours; the rest reach further.
        final neighboursOnly = rng.nextDouble() < _neighbourChance;
        final sub = _subregion(primary);
        for (var k = 0; k < want && remaining.isNotEmpty; k++) {
          Nation? partner;
          if (neighboursOnly) {
            for (final c in remaining) {
              if (_subregion(c) == sub) {
                partner = c;
                break;
              }
            }
            // No neighbour on the shortlist → don't force a distant co-host.
            if (partner == null) break;
          } else {
            partner = remaining.first; // nearest-ranked, any origin
          }
          remaining.remove(partner);
          bid.add(partner.id);
        }
      }
      bids.add(bid);
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

  /// Salt for the second roll a lodged bid gets (see [_decide]).
  static const int _bidRollSalt = 0xB1D5EED;

  /// The bid the manager's federation lodged for the edition [key] names, read
  /// off the nation carrying it (see `Nation.hostBids`), or null — always null
  /// outside a career that bid, so every draw below is then exactly the draw
  /// it always was.
  static ({int nationId, double chance})? _lodged(
    List<Nation> nations,
    String key,
  ) {
    for (final n in nations) {
      final p = n.hostBids[key];
      if (p != null && p > 0 && p < 1000) {
        return (nationId: n.id, chance: p / 1000);
      }
    }
    return null;
  }

  /// [nationId]'s share of the triangular draw over [bids] (see [_pickBid]):
  /// the weight of the bid that names it over the total, or 0 when it is not
  /// on the ballot.
  static double _shareOf(List<HostBid> bids, int nationId) {
    final n = bids.length;
    if (n == 0) return 0;
    final total = n * (n + 1) / 2;
    for (var i = 0; i < n; i++) {
      if (bids[i].contains(nationId)) return (n - i) / total;
    }
    return 0;
  }

  /// The winner of [bids] once a [lodged] bid is counted.
  ///
  /// The ordinary draw runs first, untouched. If it already names the bidder,
  /// that stands. Otherwise a second, independent roll hands the edition to
  /// the bidder with probability `(chance - p0) / (1 - p0)`, where `p0` is the
  /// bidder's share of the ordinary draw — so its chance overall is exactly
  /// the stored `chance`, and in every world where the bid loses the host is
  /// the very one the draw would have named without it. A bid can only ever
  /// raise the bidder's weight; it never reshuffles the others.
  ///
  /// A bidder not on the ballot stands alone; one already in a joint
  /// candidature wins with its partners.
  static HostBid _decide(
    List<HostBid> bids,
    int seed,
    ({int nationId, double chance})? lodged, {
    required bool eligible,
  }) {
    final drawn = _pickBid(bids, seed);
    if (lodged == null || !eligible) return drawn;
    final id = lodged.nationId;
    if (drawn.contains(id)) return drawn;
    final p0 = _shareOf(bids, id);
    if (lodged.chance <= p0 || p0 >= 1) return drawn;
    final q = (lodged.chance - p0) / (1 - p0);
    if (SeededRng(seed ^ _bidRollSalt).nextDouble() >= q) return drawn;
    for (final b in bids) {
      if (b.contains(id)) return b;
    }
    return [id];
  }

  /// [bids] as the ceremony shows them: with an eligible bidder that is not on
  /// the ballot added at the bottom, standing alone.
  static List<HostBid> _withLodged(
    List<HostBid> bids,
    ({int nationId, double chance})? lodged, {
    required bool eligible,
  }) {
    if (lodged == null || !eligible) return bids;
    if (bids.any((b) => b.contains(lodged.nationId))) return bids;
    return [
      ...bids,
      [lodged.nationId],
    ];
  }

  /// The edition cycle of the World Cup in [year], or null for a year that is
  /// not one.
  static int? _wcCycleOf(int year) {
    final d = year - _firstWcYear;
    return d < 0 || d % 4 != 0 ? null : d ~/ 4;
  }

  /// The bid lodged for the World Cup in [year], if any.
  static ({int nationId, double chance})? _lodgedWc(
    int year,
    List<Nation> nations,
  ) {
    final c = _wcCycleOf(year);
    if (c == null) return null;
    return _lodged(
      nations,
      HostBidding.nationKey(HostBidComp.worldChampionship, c),
    );
  }

  /// Whether [nationId] may stand for the World Cup under the two exclusions.
  static bool _wcEligible(
    int nationId,
    List<Nation> nations,
    Confederation? barred,
    Set<int> recent,
  ) {
    if (recent.contains(nationId)) return false;
    for (final n in nations) {
      if (n.id == nationId) return n.confederation != barred;
    }
    return false;
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
    final lodged = _lodgedWc(year, nations);
    return _withLodged(
      _worldCupBidsFor(
        year: year,
        nations: nations,
        seed: seed,
        barredConfederation: ex.barred,
        excludeIds: ex.recent,
      ),
      lodged,
      eligible:
          lodged != null &&
          _wcEligible(lodged.nationId, nations, ex.barred, ex.recent),
    );
  }

  /// Where [nationId] stands in the World Cup host race of [year] before any
  /// bid: whether it may stand at all (not of the previous host's
  /// confederation, not one of the last three hosts) and its chance in the
  /// ordinary draw (0 when it is not on the ballot).
  ///
  /// When it may not, [barredConfederation] is its confederation if that
  /// hosted the previous edition, and [recentHost] says it hosted one of the
  /// last three: what the bid card tells the manager.
  static ({
    bool eligible,
    double today,
    Confederation? barredConfederation,
    bool recentHost,
  })
  worldCupBidStanding({
    required int year,
    required List<Nation> nations,
    required int seed,
    required int nationId,
  }) {
    final ex = _wcExclusions(year, nations, seed);
    final eligible = _wcEligible(nationId, nations, ex.barred, ex.recent);
    if (!eligible) {
      Confederation? mine;
      for (final n in nations) {
        if (n.id == nationId) mine = n.confederation;
      }
      return (
        eligible: false,
        today: 0,
        barredConfederation: mine != null && mine == ex.barred ? mine : null,
        recentHost: ex.recent.contains(nationId),
      );
    }
    final bids = _worldCupBidsFor(
      year: year,
      nations: nations,
      seed: seed,
      barredConfederation: ex.barred,
      excludeIds: ex.recent,
    );
    return (
      eligible: true,
      today: _shareOf(bids, nationId),
      barredConfederation: null,
      recentHost: false,
    );
  }

  /// The candidate bids for [year] given the two exclusions. The eligible pool
  /// is every nation not in [barredConfederation] and not in [excludeIds],
  /// ranked; joint bids pair geographic neighbours (same subregion) 95% of the
  /// time — a cross-continent joint bid stays a rare exception.
  static List<HostBid> _worldCupBidsFor({
    required int year,
    required List<Nation> nations,
    required int seed,
    required Confederation? barredConfederation,
    required Set<int> excludeIds,
  }) {
    final ranked =
        nations
            .where(
              (n) =>
                  n.confederation != barredConfederation &&
                  !excludeIds.contains(n.id),
            )
            .toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    if (ranked.isEmpty) return const [];
    return _bidsFrom(ranked, _shortlistSize, _wcSeed(year, seed));
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
    final barred = prior.isEmpty ? null : byId[prior.last.first]?.confederation;
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
      final barred = winners.isEmpty
          ? null
          : byId[winners.last.first]?.confederation;
      final recent = <int>{for (final w in winners.reversed.take(3)) ...w};
      final bids = _worldCupBidsFor(
        year: y,
        nations: nations,
        seed: seed,
        barredConfederation: barred,
        excludeIds: recent,
      );
      final lodged = _lodgedWc(y, nations);
      winners.add(
        _decide(
          bids,
          _wcSeed(y, seed),
          lodged,
          eligible:
              lodged != null &&
              _wcEligible(lodged.nationId, nations, barred, recent),
        ),
      );
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
    final ex = _wcExclusions(year, nations, seed);
    final bids = _worldCupBidsFor(
      year: year,
      nations: nations,
      seed: seed,
      barredConfederation: ex.barred,
      excludeIds: ex.recent,
    );
    if (bids.isEmpty) {
      // Everyone somehow excluded: fall back to the world's best rather than
      // nobody.
      final all = [...nations]..sort((a, b) => a.ranking.compareTo(b.ranking));
      return all.isEmpty ? const [] : [all.first.id];
    }
    final lodged = _lodgedWc(year, nations);
    return _decide(
      bids,
      _wcSeed(year, seed),
      lodged,
      eligible:
          lodged != null &&
          _wcEligible(lodged.nationId, nations, ex.barred, ex.recent),
    );
  }

  /// The World Cup host ids for [year] as a set — hosts auto-qualify and sit
  /// out qualifying (playing only friendlies in those windows), so they are
  /// excluded from every confederation's qualifying pool.
  static Set<int> worldCupHostIds({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) => hostsFor(year: year, nations: nations, seed: seed).toSet();

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
  }) {
    final exclude = _recentContinentalHosts(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
    );
    final lodged = _lodgedCont(cycle, nations);
    return _withLodged(
      _continentalBids(
        confederation: confederation,
        cycle: cycle,
        seed: seed,
        nations: nations,
        exclude: exclude,
      ),
      lodged,
      eligible:
          lodged != null &&
          _contEligible(lodged.nationId, nations, confederation, exclude),
    );
  }

  /// Where [nationId] stands in [confederation]'s host race of [cycle] before
  /// any bid: whether it may stand (a member, not one of the last three
  /// hosts) and its chance in the ordinary draw (0 when not on the ballot).
  /// [recentHost] says it is barred for having hosted one of the last three.
  static ({bool eligible, double today, bool recentHost})
  continentalBidStanding({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
    required int nationId,
  }) {
    final exclude = _recentContinentalHosts(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
    );
    if (!_contEligible(nationId, nations, confederation, exclude)) {
      return (
        eligible: false,
        today: 0,
        recentHost: exclude.contains(nationId),
      );
    }
    final bids = _continentalBids(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
      exclude: exclude,
    );
    return (eligible: true, today: _shareOf(bids, nationId), recentHost: false);
  }

  /// The bid lodged for the continental championship of [cycle], if any. Each
  /// career bids only for its own confederation's, so the nation carrying it
  /// says which.
  static ({int nationId, double chance})? _lodgedCont(
    int cycle,
    List<Nation> nations,
  ) => _lodged(nations, HostBidding.nationKey(HostBidComp.continental, cycle));

  /// Whether [nationId] may stand for [confederation]'s championship.
  static bool _contEligible(
    int nationId,
    List<Nation> nations,
    Confederation confederation,
    Set<int> exclude,
  ) {
    if (exclude.contains(nationId)) return false;
    for (final n in nations) {
      if (n.id == nationId) return n.confederation == confederation;
    }
    return false;
  }

  static List<HostBid> _continentalBids({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
    required Set<int> exclude,
  }) => hostBids(
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
      if (bids.isEmpty) continue;
      // A bid that WON that edition bars its winner like any host; the naive
      // pick could miss it. One that lost changes nothing here.
      final lodged = _lodgedCont(c, nations);
      if (lodged != null) {
        final real = continentalHostsFor(
          confederation: confederation,
          cycle: c,
          seed: seed,
          nations: nations,
        );
        if (real.contains(lodged.nationId)) {
          recent.addAll(real);
          continue;
        }
      }
      recent.addAll(_pickBid(bids, _contSeed(confederation, c, seed)));
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

  /// The nations actually drawn into [confederation]'s continental qualifying:
  /// every member except that cycle's hosts, who auto-qualify and play
  /// friendlies through the qualifying windows.
  ///
  /// ONE definition, shared by the calendar that stores the draw and by every
  /// screen that recomputes it for display. They were written out separately
  /// and drifted: the ceremony dropped only [continentalHostFor] — the primary
  /// host — while the calendar dropped all of [continentalHostsFor]. Roughly a
  /// third of editions are co-hosted, so on those the manager watched a draw of
  /// a field that had never been drawn, and the groups it produced disagreed
  /// with the ones actually played.
  static List<Nation> continentalQualifiers({
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
    ).toSet();
    return [
      for (final n in nations)
        if (n.confederation == confederation && !hosts.contains(n.id)) n,
    ];
  }

  /// Every host of a continental championship — the winning bid, occasionally a
  /// joint one (as at Euro 2000/2008/2012).
  static List<int> continentalHostsFor({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) {
    final exclude = _recentContinentalHosts(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
    );
    final bids = _continentalBids(
      confederation: confederation,
      cycle: cycle,
      seed: seed,
      nations: nations,
      exclude: exclude,
    );
    if (bids.isEmpty) return const [];
    final lodged = _lodgedCont(cycle, nations);
    return _decide(
      bids,
      _contSeed(confederation, cycle, seed),
      lodged,
      eligible:
          lodged != null &&
          _contEligible(lodged.nationId, nations, confederation, exclude),
    );
  }

  /// The chance an edition is co-hosted at all, and the chance it is shared
  /// three ways. A solo host is still the normal case, but joint candidatures
  /// are a real part of the modern game (2002, 2026, Euro 2000/2008/2012/2020),
  /// and at 15% they turned up so seldom that most careers never saw one.
  ///
  /// One roll drives both, so [_tripleHostChance] is a subset of
  /// [_coHostChance] — they must stay ordered.
  static const double _coHostChance = 0.32;
  static const double _tripleHostChance = 0.08;

  /// When an edition is co-hosted, the chance the partner is a geographic
  /// neighbour (same subregion) rather than a nation from further afield.
  ///
  /// Raised from 0.95 after a tester was shown England and Portugal bidding
  /// together and asked why. The pairing was not a fault: they sit in
  /// different subregions (britishIsles and iberia), so it was the distant
  /// roll working as written, and the subregion table covers all 209 nations
  /// with no gap that could invent a false neighbour. It simply came up too
  /// often to read as the exception it is meant to be.
  static const double _neighbourChance = 0.97;

  /// How many of a confederation's strongest members make the host shortlist —
  /// both the weighted draw pool and the candidates shown in the ceremony.
  static const int _shortlistSize = 12;

  /// How often an outsider joins the candidate field, and how far past the
  /// shortlist it may be drawn from. See [_outsider].
  static const double _outsiderChance = 0.18;
  static const int _outsiderDepth = 30;

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
