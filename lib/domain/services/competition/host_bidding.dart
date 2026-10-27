import 'dart:math';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

/// Which tournament a host bid is for.
enum HostBidComp {
  /// The World Championship.
  worldChampionship('wc'),

  /// The manager's own continental championship.
  continental('cont');

  const HostBidComp(this.code);

  /// The short code the per-career markers carry.
  final String code;

  static HostBidComp? fromCode(String code) {
    for (final c in values) {
      if (c.code == code) return c;
    }
    return null;
  }
}

/// A bid the manager's federation has lodged to host one edition.
///
/// Stored as a per-career marker in `draws_watched` (row cycle = the edition's
/// cycle), so no schema change was needed and a save that never bid is
/// byte-for-byte what it was:
///
/// `hostBid:<comp>:<editionCycle>:<nationId>:<levels>:<permille>`
///
/// [permille] is the chance the manager was shown when he confirmed, frozen
/// there: what the bar promised is what the draw uses, whatever the stadium
/// data or the ranking does afterwards.
class HostBidMarker {
  const HostBidMarker({
    required this.comp,
    required this.editionCycle,
    required this.nationId,
    required this.levels,
    required this.permille,
  });

  /// Every bid marker starts with this. The result and declined markers use
  /// their own prefixes (`hostBidResult:`, `hostBidDeclined:`), which a LIKE on
  /// `hostBid:%` does not match.
  static const String prefix = 'hostBid:';

  final HostBidComp comp;
  final int editionCycle;
  final int nationId;
  final int levels;
  final int permille;

  /// The euros the bid cost.
  int get invested => levels * HostBidOdds.levelPrice;

  /// The winning chance as a fraction.
  double get chance => permille / 1000;

  String encode() =>
      '$prefix${comp.code}:$editionCycle:$nationId:$levels:$permille';

  /// The marker [kind] names, or null for any other kind (or a garbled one).
  static HostBidMarker? decode(String kind) {
    if (!kind.startsWith(prefix)) return null;
    final parts = kind.substring(prefix.length).split(':');
    if (parts.length != 5) return null;
    final comp = HostBidComp.fromCode(parts[0]);
    final nums = [for (final p in parts.skip(1)) int.tryParse(p)];
    if (comp == null || nums.contains(null)) return null;
    final permille = nums[3]!;
    if (permille <= 0 || permille >= 1000) return null;
    return HostBidMarker(
      comp: comp,
      editionCycle: nums[0]!,
      nationId: nums[1]!,
      levels: nums[2]!,
      permille: permille,
    );
  }

  /// The key the bid is carried under on the bidding `Nation.hostBids`, which
  /// is how the host draw (`WorldCupHosts`) finds it.
  String get nationKey => HostBidding.nationKey(comp, editionCycle);

  /// Every pledge marker starts with this. A pledge is a bid made at the
  /// close of a cycle and not yet paid: the rollover pays it and turns it
  /// into the bid itself (see `HostBidService.settlePledges`). Its prefix
  /// is not [prefix], so neither [decode] nor the nation read sees it, and
  /// the host draw cannot count a bid before it is paid.
  static const String pledgePrefix = 'hostBidPledge:';

  /// This bid as a pledge marker.
  String encodePledge() =>
      '$pledgePrefix${comp.code}:$editionCycle:$nationId:$levels:$permille';

  /// The pledge [kind] names, or null for any other kind.
  static HostBidMarker? decodePledge(String kind) {
    if (!kind.startsWith(pledgePrefix)) return null;
    return decode(prefix + kind.substring(pledgePrefix.length));
  }
}

/// The marker kinds around a bid, other than the bid itself.
abstract final class HostBidding {
  /// `Nation.hostBids` key for an edition: `wc:<cycle>` / `cont:<cycle>`.
  static String nationKey(HostBidComp comp, int editionCycle) =>
      '${comp.code}:$editionCycle';

  /// Stamped when the manager turns the offer down, so it is not asked again.
  ///
  /// [nationId] names the nation that turned it down (the bid is made for
  /// the nation taken into the new cycle, which can change on the rollover
  /// screen). The first 1.0.7 builds wrote it without one, and such a marker
  /// settles the offer for every nation.
  static String declinedKind(
    HostBidComp comp,
    int editionCycle, {
    int? nationId,
  }) =>
      'hostBidDeclined:${comp.code}:$editionCycle'
      '${nationId == null ? '' : ':$nationId'}';

  /// Stamped by the rollover when a pledge cannot be paid (the money no
  /// longer covers it) or no longer applies (the manager took another
  /// nation): nothing is charged, and the offer is not made again.
  static String lapsedKind(HostBidComp comp, int editionCycle) =>
      'hostBidLapsed:${comp.code}:$editionCycle';

  /// Prefix of the outcome markers.
  static const String resultPrefix = 'hostBidResult:';

  /// Stamped once the edition's host is decided. Its presence is what pays the
  /// bonus exactly once. [bonus] is the euros paid: 0 for a loss. A win pays
  /// the career's federation whatever nation it manages by then (bids are
  /// settled before the rollover, which is the only time a manager moves).
  static String resultKind(
    HostBidComp comp,
    int editionCycle, {
    required bool won,
    required int bonus,
  }) =>
      '$resultPrefix${comp.code}:$editionCycle:${won ? 'won' : 'lost'}:$bonus';

  /// Decodes a result marker.
  static ({HostBidComp comp, int editionCycle, bool won, int bonus})?
  decodeResult(String kind) {
    if (!kind.startsWith(resultPrefix)) return null;
    final parts = kind.substring(resultPrefix.length).split(':');
    if (parts.length != 4) return null;
    final comp = HostBidComp.fromCode(parts[0]);
    final cycle = int.tryParse(parts[1]);
    final bonus = int.tryParse(parts[3]);
    if (comp == null || cycle == null || bonus == null) return null;
    return (
      comp: comp,
      editionCycle: cycle,
      won: parts[2] == 'won',
      bonus: bonus,
    );
  }

  /// Prefix of the "grant to assign" marker.
  static const String grantPrefix = 'hostBidGrant:';

  /// Stamped with a won bid's grant when it lands: the hub then offers to
  /// assign it to the departments of the cycle the bid was lodged in (the
  /// edition's cycle less one) at once.
  static String grantOpenKind(HostBidComp comp, int editionCycle, int euros) =>
      '$grantPrefix${comp.code}:$editionCycle:$euros';

  /// The grant a marker carries, or null for any other kind.
  static ({int editionCycle, int euros})? decodeGrantOpen(String kind) {
    if (!kind.startsWith(grantPrefix)) return null;
    final parts = kind.substring(grantPrefix.length).split(':');
    if (parts.length != 3 || HostBidComp.fromCode(parts[0]) == null) {
      return null;
    }
    final cycle = int.tryParse(parts[1]);
    final euros = int.tryParse(parts[2]);
    if (cycle == null || euros == null) return null;
    return (editionCycle: cycle, euros: euros);
  }

  /// Stamped (row cycle = the cycle) once the grant has been assigned.
  static const String grantDoneKind = 'hostBidGrantAssigned';

  /// The month (of the cycle's second calendar year) the bids of the first
  /// 1.0.7 builds were decided: January after the cycle they were lodged in
  /// opened. Only those old bids (lodged at a cycle's opening for the cycle
  /// after) still use it; a bid made today is decided in the rollover.
  static const int decisionMonth = 1;

  /// When an old bid lodged in the cycle that opened in [cycleStartYear] is
  /// decided: 1 January of the following year.
  static DateTime decisionDate(int cycleStartYear) =>
      DateTime(cycleStartYear + 1);
}

/// What a nation's grounds must hold before it may bid to host: so many
/// grounds of at least [minSeats], of which [bigGrounds] hold [bigSeats] or
/// more.
typedef HostingRequirement = ({
  int grounds,
  int minSeats,
  int bigGrounds,
  int bigSeats,
});

/// What a nation's grounds still lack against a [HostingRequirement]: more
/// grounds of the minimum size, and more big ones. Both 0 when it qualifies.
typedef HostingShortfall = ({int grounds, int bigGrounds});

/// The estate a host needs, scaled to the size of each finals as this game
/// plays it. Real federations ask for the same kind of thing (so many
/// stadiums, so many of them big), so the top nations can bid today and the
/// small ones must build first.
///
/// | Tournament                 | Teams | Grounds        | Big grounds |
/// |----------------------------|-------|----------------|-------------|
/// | World Championship         | 48    | 6 of 15k+      | 3 of 30k+   |
/// | European / African / Asian | 24    | 5 of 15k+      | 2 of 20k+   |
/// | North America Cup          | 16    | 3 of 10k+      | 2 of 15k+   |
/// | South America Cup          | 10    | 3 of 10k+      | 2 of 15k+   |
/// | Oceania Cup                | 8     | 2 of 5k+       | 1 of 10k+   |
///
/// Measured on the seed estates (see the test): 14 European, 8 South
/// American, 3 North American, 9 African, 14 Asian and 1 Oceanian nation may
/// bid for the World Championship at the start; for their own championship
/// 20 in Europe, all 10 in South America, 7 in North America, 15 in Africa,
/// 19 in Asia and 5 in Oceania.
abstract final class HostingRequirements {
  /// The smallest ground a finals match is staged in (level 2).
  static const int finalsGround = 15000;

  /// The World Championship: six grounds, three of 30,000+.
  static const HostingRequirement worldChampionship = (
    grounds: 6,
    minSeats: finalsGround,
    bigGrounds: 3,
    bigSeats: 30000,
  );

  /// [confederation]'s own championship.
  static HostingRequirement continental(Confederation confederation) =>
      switch (confederation) {
        Confederation.europe || Confederation.africa || Confederation.asia => (
          grounds: 5,
          minSeats: finalsGround,
          bigGrounds: 2,
          bigSeats: 20000,
        ),
        Confederation.northAmerica || Confederation.southAmerica => (
          grounds: 3,
          minSeats: 10000,
          bigGrounds: 2,
          bigSeats: finalsGround,
        ),
        Confederation.oceania => (
          grounds: 2,
          minSeats: 5000,
          bigGrounds: 1,
          bigSeats: 10000,
        ),
      };

  /// The requirement of [comp] for a nation of [confederation].
  static HostingRequirement of(HostBidComp comp, Confederation confederation) =>
      comp == HostBidComp.worldChampionship
      ? worldChampionship
      : continental(confederation);

  /// What [capacities] (a nation's grounds standing, any order) lack against
  /// [req].
  static HostingShortfall shortfall(
    Iterable<int> capacities,
    HostingRequirement req,
  ) {
    var grounds = 0;
    var big = 0;
    for (final c in capacities) {
      if (c >= req.minSeats) grounds++;
      if (c >= req.bigSeats) big++;
    }
    return (
      grounds: max(0, req.grounds - grounds),
      bigGrounds: max(0, req.bigGrounds - big),
    );
  }

  /// Whether [capacities] meet [req].
  static bool meets(Iterable<int> capacities, HostingRequirement req) {
    final s = shortfall(capacities, req);
    return s.grounds == 0 && s.bigGrounds == 0;
  }
}

/// What a bid of a given size buys.
typedef HostBidQuote = ({
  /// The chance with the smallest bid: the larger of what the nation's size
  /// earns and the chance it already had in the draw.
  double base,

  /// What the money adds on top.
  double invest,

  /// [base] + [invest], never above [cap].
  double total,

  /// The ceiling for this nation, however much it spends.
  double cap,
});

/// The chance model of a host bid. Pure, so the screen and the tests read the
/// same numbers.
///
/// * **Size** comes from the nation's stadiums: the seats of its eight biggest
///   grounds (a continental finals needs about eight), as a fraction of
///   [fullSizeSeats]. Germany, England, Spain, Brazil score about 1, a
///   mid-size nation 0.3 to 0.5, a microstate under 0.05.
/// * **Base** = 2% + 13% x size. Floored at the chance the nation already had
///   in the existing draw, so a bid never makes anyone worse off.
/// * **Cap** = 10% + 55% x size: a microstate tops out near 12%, a mid-size
///   nation near 30%, the very biggest at 65%. A side whose chance in the
///   ordinary draw is already near its size cap may still buy 5 points on
///   top of it. Never above 65%: never certain.
/// * **Investment** closes the gap from base to cap with diminishing returns:
///   `(cap - base) x (1 - e^(-levels / 5))`. The first million moves the bar
///   most; ten levels close 86% of the gap.
abstract final class HostBidOdds {
  /// One level of a bid costs what one level of a department does.
  static const int levelPrice = FederationFinance.investLevelPrice;

  /// The most levels a bid takes. Ten levels (€10M) is the ceiling: the bonus
  /// on a win stays inside about one central grant (see [bonusFor]).
  static const int maxLevels = 10;

  /// Eight grounds' worth of seats that scores a full 1.0 for size.
  static const int fullSizeSeats = 400000;

  /// How many of the biggest grounds count.
  static const int groundsCounted = 8;

  static const double _baseFloor = 0.02;
  static const double _baseSpan = 0.13;
  static const double _capFloor = 0.10;
  static const double _capSpan = 0.55;
  static const double _levelScale = 5;

  /// A nation already well placed in the draw (a strong side with modest
  /// grounds) can still buy this much on top of the chance it had.
  static const double _capRoom = 0.05;

  /// Nobody, however big or however placed, goes past this.
  static const double _capMax = 0.65;

  /// A nation's size score, 0..1, from its stadium list.
  static double sizeScore(List<Venue> stadiums) {
    final seats = [for (final v in stadiums) v.capacity]
      ..sort((a, b) => b.compareTo(a));
    final top = seats.take(groundsCounted).fold<int>(0, (s, c) => s + c);
    return (top / fullSizeSeats).clamp(0.0, 1.0);
  }

  /// The quote for a bid of [levels] (0 shows the base alone) by a nation of
  /// [size] whose chance in the existing draw is [today].
  static HostBidQuote quote({
    required double size,
    required double today,
    required int levels,
  }) {
    final s = size.clamp(0.0, 1.0);
    final cap = min(max(_capFloor + _capSpan * s, today + _capRoom), _capMax);
    final base = min(max(_baseFloor + _baseSpan * s, today), cap);
    final l = levels.clamp(0, maxLevels);
    final invest = (cap - base) * (1 - exp(-l / _levelScale));
    return (base: base, invest: invest, total: base + invest, cap: cap);
  }

  /// The chance a bid stores, in permille: 1..999.
  static int permilleOf(HostBidQuote q) =>
      (q.total * 1000).round().clamp(1, 999);

  /// The one-off funding paid when a bid of [levels] wins: the stake back plus
  /// half again (at least one level more). One level pays €2M, five pay €7M,
  /// ten pay €15M, about one cycle's central grant.
  ///
  /// Why modest: at the chances above a typical mid-size bid (five levels,
  /// about 25%) returns well under its cost on average, so nobody bids for
  /// the money. The bonus softens the stake for the side that wins and
  /// already gains auto-qualification and home crowds.
  static int bonusFor(int levels) {
    final l = levels.clamp(1, maxLevels);
    return (l + max<int>(1, l ~/ 2)) * levelPrice;
  }
}
