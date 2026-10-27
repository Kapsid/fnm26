import 'dart:math' as math;

import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/stadium_capacity.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

/// One of a nation's national stadiums in one career: a seed ground (one of
/// the static venues every career starts from) or one the federation built,
/// at the size the career's works have left it.
///
/// Its level is not a separate number: it is the capacity band the ground
/// sits in (see [StadiumLevels]). More seats is a higher level, fewer seats a
/// lower one, so a seed ground shows the level its real capacity earns.
class NationalStadium {
  const NationalStadium({
    required this.city,
    required this.name,
    required this.baseCapacity,
    int? capacity,
    this.upgrades = 0,
    this.built = false,
    this.opensCycle,
    String? site,
  }) : capacity = capacity ?? baseCapacity,
       site = site ?? city;

  /// The city the ground stands in: also what a map pins it to.
  final String city;

  /// What the work markers call it: the city, or `<city>#2` for a city's
  /// second ground (London, Lima, Abidjan hold two).
  final String site;
  final String name;

  /// Seats before any work.
  final int baseCapacity;

  /// Seats now, after every enlargement and downsizing.
  final int capacity;

  /// Enlargements done on it (a downsizing does not count): what the
  /// comfort bonus at home games and the reputation read.
  final int upgrades;

  /// Built by the federation in this career (not a seed ground).
  final bool built;

  /// For a built stadium, the cycle it opens in; null for a seed ground.
  final int? opensCycle;

  /// Whether the ground can be played in (and counted) in [cycle].
  bool openIn(int cycle) => opensCycle == null || cycle >= opensCycle!;

  /// Its level, 1..[StadiumLevels.maxLevel]: the band its seats sit in.
  int get level => StadiumLevels.levelOf(capacity);

  /// Its key in the work markers: a city can hold a seed ground AND one the
  /// federation built, so the city alone is not enough.
  StadiumRef get ref => (city: site, built: built);

  Venue get venue => (city: city, stadium: name, capacity: capacity);
}

/// Which stadium a work names. [city] is the ground's site: its city, or
/// `<city>#2` for a city's second ground.
typedef StadiumRef = ({String city, bool built});

/// A stadium's level IS its capacity band. Chosen from what real grounds of
/// each size are:
///
/// | Level | Seats         | Like                                         |
/// |-------|---------------|----------------------------------------------|
/// | 1     | under 15,000  | a small national ground, a provincial club   |
/// | 2     | 15,000-24,999 | a mid-size league ground                     |
/// | 3     | 25,000-39,999 | a big club ground, a smaller finals venue    |
/// | 4     | 40,000-59,999 | a World Championship group venue             |
/// | 5     | 60,000 and up | a national bowl, a final venue               |
///
/// 15,000 is the smallest ground a finals is staged in, 40,000 the World
/// Championship's line, so the bands are also the eligibility steps.
abstract final class StadiumLevels {
  static const int maxLevel = 5;

  /// The lowest seat count of each level, 1-based by index + 1.
  static const List<int> floors = [0, 15000, 25000, 40000, 60000];

  /// The size a ground is built to when a work takes it INTO a level: an
  /// enlargement goes to the next level's figure, a downsizing to the one
  /// below. Each sits inside its band, clear of both edges.
  static const List<int> standard = [10000, 20000, 32000, 48000, 64000];

  /// The level of a ground of [seats].
  static int levelOf(int seats) {
    var level = 1;
    for (var i = 1; i < floors.length; i++) {
      if (seats >= floors[i]) level = i + 1;
    }
    return level;
  }

  /// The lowest seat count of [level].
  static int floorOf(int level) => floors[(level - 1).clamp(0, maxLevel - 1)];

  /// The seats an enlargement of a ground of [seats] leaves it with, or null
  /// at the top level.
  static int? enlargedTo(int seats) {
    final level = levelOf(seats);
    if (level >= maxLevel) return null;
    return math.max(seats, standard[level]);
  }

  /// The seats a downsizing of a ground of [seats] leaves it with, or null at
  /// the bottom level.
  static int? downsizedTo(int seats) {
    final level = levelOf(seats);
    if (level <= 1) return null;
    return math.min(seats, standard[level - 2]);
  }
}

/// A stadium work the federation commissioned: a resize (an enlargement or a
/// downsizing to a new capacity) or a new stadium. Stored as a per-career
/// marker in draws_watched (row cycle = the cycle it was ordered in), so a
/// save without any keeps its static grounds and no schema change is needed.
///
/// `stadiumSize:<nation>:<cycle>:<seats>:<u|d>:<s|n>:<city>`
/// `stadiumBuild:<nation>:<cycle>:<city>`
///
/// The first 1.0.7 builds stored `stadiumUp:<nation>:<cycle>:<level>:<s|n>:
/// <city>`, a +10%-a-level upgrade. Those still read, at the seats they paid
/// for, so a save that bought one keeps what it bought.
///
/// The city is the LAST field, so a city with a colon in its name still
/// round-trips.
class StadiumWork {
  const StadiumWork.resize({
    required this.nationId,
    required this.cycle,
    required this.stadium,
    required int seats,
    required bool enlarge,
  }) : capacity = seats,
       up = enlarge,
       legacyLevel = 0,
       isBuild = false;

  const StadiumWork.build({
    required this.nationId,
    required this.cycle,
    required String city,
  }) : stadium = (city: city, built: true),
       capacity = 0,
       up = true,
       legacyLevel = 0,
       isBuild = true;

  /// A first-build `stadiumUp` marker: the ground at [level] +10% steps.
  const StadiumWork.legacyUpgrade({
    required this.nationId,
    required this.cycle,
    required this.stadium,
    required int level,
  }) : capacity = 0,
       up = true,
       legacyLevel = level,
       isBuild = false;

  final int nationId;

  /// The cycle the work was ordered in.
  final int cycle;
  final StadiumRef stadium;

  /// For a resize, the seats it leaves the ground with.
  final int capacity;

  /// An enlargement (or a build), rather than a downsizing.
  final bool up;

  /// For a legacy upgrade, the level it reached; 0 otherwise.
  final int legacyLevel;
  final bool isBuild;

  bool get isLegacy => legacyLevel > 0;

  static const String resizePrefix = 'stadiumSize:';
  static const String buildPrefix = 'stadiumBuild:';
  static const String legacyUpgradePrefix = 'stadiumUp:';

  String encode() {
    if (isBuild) return '$buildPrefix$nationId:$cycle:${stadium.city}';
    final which = stadium.built ? 'n' : 's';
    if (isLegacy) {
      return '$legacyUpgradePrefix$nationId:$cycle:$legacyLevel:$which:'
          '${stadium.city}';
    }
    return '$resizePrefix$nationId:$cycle:$capacity:${up ? 'u' : 'd'}:'
        '$which:${stadium.city}';
  }

  /// The work [kind] names, or null when it is not a stadium work.
  static StadiumWork? decode(String kind) {
    if (kind.startsWith(buildPrefix)) {
      final parts = kind.substring(buildPrefix.length).split(':');
      if (parts.length < 3) return null;
      final nation = int.tryParse(parts[0]);
      final cycle = int.tryParse(parts[1]);
      final city = parts.sublist(2).join(':');
      if (nation == null || cycle == null || city.isEmpty) return null;
      return StadiumWork.build(nationId: nation, cycle: cycle, city: city);
    }
    if (kind.startsWith(resizePrefix)) {
      final parts = kind.substring(resizePrefix.length).split(':');
      if (parts.length < 6) return null;
      final nation = int.tryParse(parts[0]);
      final cycle = int.tryParse(parts[1]);
      final seats = int.tryParse(parts[2]);
      final dir = parts[3];
      final which = parts[4];
      final city = parts.sublist(5).join(':');
      if (nation == null ||
          cycle == null ||
          seats == null ||
          seats <= 0 ||
          (dir != 'u' && dir != 'd') ||
          (which != 'n' && which != 's') ||
          city.isEmpty) {
        return null;
      }
      return StadiumWork.resize(
        nationId: nation,
        cycle: cycle,
        stadium: (city: city, built: which == 'n'),
        seats: seats,
        enlarge: dir == 'u',
      );
    }
    if (kind.startsWith(legacyUpgradePrefix)) {
      final parts = kind.substring(legacyUpgradePrefix.length).split(':');
      if (parts.length < 5) return null;
      final nation = int.tryParse(parts[0]);
      final cycle = int.tryParse(parts[1]);
      final level = int.tryParse(parts[2]);
      final which = parts[3];
      final city = parts.sublist(4).join(':');
      if (nation == null ||
          cycle == null ||
          level == null ||
          level < 1 ||
          (which != 'n' && which != 's') ||
          city.isEmpty) {
        return null;
      }
      return StadiumWork.legacyUpgrade(
        nationId: nation,
        cycle: cycle,
        stadium: (city: city, built: which == 'n'),
        level: level,
      );
    }
    return null;
  }
}

/// The name the manager gave a stadium the federation built: at the order,
/// or a rename later from its card. Stored as a per-career marker in
/// draws_watched beside the works (row cycle = the cycle it was given in), so
/// no schema change is needed and a career bundle carries it like any other
/// marker. A built ground without one (every save from before names, or one
/// whose manager kept the suggestion) shows [NationalStadiums.newStadiumName].
///
/// `stadiumName:<nation>:<seq>:<city, percent-encoded>:<name>`
///
/// A nation holds at most one built ground per city, so the nation and the
/// city name it. [seq] orders the renames: the highest wins, and it keeps
/// each marker distinct even when a name comes back (A, then B, then A
/// again). The name is the LAST field, so a colon in it still round-trips.
/// Curated and seed grounds keep their names: no marker names them.
class StadiumName {
  const StadiumName({
    required this.nationId,
    required this.seq,
    required this.city,
    required this.name,
  });

  final int nationId;
  final int seq;
  final String city;
  final String name;

  static const String prefix = 'stadiumName:';

  /// The most characters the name field takes ("about 32").
  static const int maxLength = 32;

  /// The most code points a stored name keeps: a safety net under
  /// [maxLength], which the field counts in visible characters (a Thai or
  /// Devanagari letter with its marks, an emoji), so it never clips what the
  /// field allowed.
  static const int maxRunes = 64;

  /// [raw] as it is stored: trimmed, every run of whitespace (a newline, a
  /// tab) one space, held to [maxRunes]. Null when nothing is left, and the
  /// generated name stands. Any script is kept as typed.
  static String? clean(String raw) {
    final one = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (one.isEmpty) return null;
    final runes = one.runes.toList();
    if (runes.length <= maxRunes) return one;
    final cut = String.fromCharCodes(runes.take(maxRunes)).trim();
    return cut.isEmpty ? null : cut;
  }

  String encode() => '$prefix$nationId:$seq:${Uri.encodeComponent(city)}:$name';

  /// The name [kind] gives, or null when it is not a name marker.
  static StadiumName? decode(String kind) {
    if (!kind.startsWith(prefix)) return null;
    final parts = kind.substring(prefix.length).split(':');
    if (parts.length < 4) return null;
    final nation = int.tryParse(parts[0]);
    final seq = int.tryParse(parts[1]);
    final String city;
    try {
      city = Uri.decodeComponent(parts[2]);
      // A hand-edited marker with a broken escape reads as no name.
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return null;
    } on FormatException {
      return null;
    }
    final name = parts.sublist(3).join(':');
    if (nation == null || seq == null || city.isEmpty || name.isEmpty) {
      return null;
    }
    return StadiumName(nationId: nation, seq: seq, city: city, name: name);
  }

  /// The name standing for each of [nationId]'s built grounds, by city: the
  /// latest of [names] (the highest [seq]) for each.
  static Map<String, String> latestFor(
    Iterable<StadiumName> names,
    int nationId,
  ) {
    final best = <String, StadiumName>{};
    for (final n in names) {
      if (n.nationId != nationId) continue;
      final had = best[n.city];
      if (had == null || n.seq > had.seq) best[n.city] = n;
    }
    return {for (final e in best.entries) e.key: e.value.name};
  }
}

/// The national-stadium model: what works cost, what grounds earn, and how a
/// nation's grounds look once a career has worked on them. Pure, so every
/// number lives here and is tested on its own.
///
/// **Income.** Every ground earns a little at each cycle start, from its
/// seats and its level, whether or not anybody has touched it:
/// `sold x yield x (1 + 10% a level above 1) - seats x upkeep`, never below
/// zero. `sold` is the seats a nation's crowds can fill: all of them up to
/// [demandShare] of its biggest real ground, a quarter of each seat beyond.
/// So enlarging a ground the nation can fill pays a little more, and a
/// white elephant (a minnow's ground blown up past its crowds) costs more to
/// run than it takes, which is what a downsizing is for.
///
/// Measured (see the test): a top nation's eight grounds earn €1.3-1.5M a
/// cycle (England 1.52, Spain 1.37, Germany 1.35), under a tenth of the
/// €16M a top standing's grant pays; its national bowl about €0.3M. A
/// mid-size nation's estate earns €0.2-0.7M (Czechia 0.21, Denmark 0.50,
/// Austria 0.67), a microstate's about €20k (Andorra 0.022).
abstract final class NationalStadiums {
  /// The marker prefix every stadium marker shares, for one repository read.
  static const String markerPrefix = 'stadium';

  /// How many seed grounds make up a nation's national stadiums: the eight a
  /// continental finals is played in, the same eight the host-bid size score
  /// reads.
  static const int setSize = 8;

  /// The highest level.
  static const int maxLevel = StadiumLevels.maxLevel;

  /// Euros a sold seat earns over a cycle, at level 1.
  static const double yieldPerSeat = 3.8;

  /// What each level above 1 adds to a seat's yield: hospitality, better
  /// sightlines, bigger events.
  static const double yieldPerLevel = 0.10;

  /// Euros a seat costs to keep over a cycle, sold or not.
  static const double upkeepPerSeat = 1.9;

  /// The crowd a nation fills one ground with, as a multiple of its biggest
  /// real ground.
  static const double demandShare = 1.1;

  /// The share of a seat past that demand that still sells.
  static const double overflowSold = 0.25;

  /// The most one ground earns in a cycle, however vast: "a few hundred
  /// thousand at most". Only a 100,000-plus bowl reaches it.
  static const int maxGroundIncome = 400000;

  /// Euros the income figures are rounded to.
  static const int incomeRounding = 1000;

  /// Points a built stadium counts for on its own (its enlargements add one
  /// each).
  static const int builtPoints = 2;

  /// The most reputation stadium works add (career reputation is 0..100).
  static const int maxReputation = 6;

  /// How much fuller each enlargement makes a ground at home games: newer
  /// seats, better views.
  static const double fillPerUpgrade = 0.02;

  /// The cycles a new stadium takes to build: paid for in cycle c, it opens
  /// at the start of cycle c + 1.
  static const int buildCycles = 1;

  /// The fixed part of an enlargement's price, in budget levels.
  static const int resizeBaseLevels = 2;

  /// What every thousand seats added costs, in euros.
  static const int pricePerThousandSeats = 250000;

  /// What a downsizing refunds: nothing. Taking seats out costs about what
  /// the steel is worth; the gain is the upkeep saved.
  static const int downsizeRefund = 0;

  /// What an enlargement INTO each level is multiplied by, in tenths, by
  /// level (index 0 is level 1, which nothing is enlarged into). The owner's
  /// call: the higher the level, the dearer the step. A ground taken from
  /// level 1 to level 5 one step at a time costs €41M instead of €22M.
  static const List<int> levelCostTenths = [10, 10, 14, 20, 28];

  /// What enlarging a ground of [seats] to the next level costs: €2M plus
  /// €0.25M for every thousand seats added, rounded up to whole millions,
  /// times the target level's [levelCostTenths], rounded up to whole
  /// millions again. Null at the top level. Worked out when the work is
  /// ordered, never stored: the price paid is in the budget, not the marker.
  static int? enlargeCost(int seats) {
    final to = StadiumLevels.enlargedTo(seats);
    if (to == null) return null;
    final extra = ((to - seats) * pricePerThousandSeats / 1000).ceil();
    final base =
        resizeBaseLevels + (extra / FederationFinance.investLevelPrice).ceil();
    final tenths = levelCostTenths[StadiumLevels.levelOf(to) - 1];
    final levels = (base * tenths + 9) ~/ 10;
    return levels * FederationFinance.investLevelPrice;
  }

  /// Seats of a ground of [base] seats at [level] of the first builds'
  /// +10%-a-level upgrade, to the hundred. Only legacy markers use it.
  static int legacyCapacityAt(int base, int level) =>
      (base * (1 + 0.10 * level) / 100).round() * 100;

  /// The real capacity of [nationId]'s biggest ground, the scale of its
  /// crowds.
  static int marketOf(int nationId) => biggestOf(nationId);

  /// [nationId]'s biggest real ground: the curated estate's first, or the
  /// old national-stadium table for a nation it does not list.
  static int biggestOf(int nationId) {
    final curated = nationalStadiumData[nationId];
    if (curated != null && curated.isNotEmpty) return curated.first.$2;
    return nationalStadiumCapacity[nationId] ?? 42000;
  }

  /// What a ground of [seats] earns [nationId] at a cycle start.
  static int groundIncome({required int seats, required int nationId}) {
    final demand = marketOf(nationId) * demandShare;
    final sold = seats <= demand
        ? seats.toDouble()
        : demand + (seats - demand) * overflowSold;
    final level = StadiumLevels.levelOf(seats);
    final gross = sold * yieldPerSeat * (1 + yieldPerLevel * (level - 1));
    final net = gross - seats * upkeepPerSeat;
    if (net <= 0) return 0;
    return math.min(
      maxGroundIncome,
      (net / incomeRounding).round() * incomeRounding,
    );
  }

  /// The most a federation's whole estate earns in a cycle, as a share of
  /// its central grant for that cycle.
  static const double maxGrantShare = 0.10;

  /// [total] held to [maxGrantShare] of [grant] (to the thousand).
  static int cappedToGrant(int total, int grant) {
    final cap =
        (grant * maxGrantShare / incomeRounding).floor() * incomeRounding;
    return total < cap ? total : cap;
  }

  /// What [stadiums] (one nation's, as they stand) earn at a cycle start,
  /// before the grant cap ([cappedToGrant]).
  static int incomeOf(Iterable<NationalStadium> stadiums, int nationId) =>
      stadiums.fold(
        0,
        (sum, s) => sum + groundIncome(seats: s.capacity, nationId: nationId),
      );

  /// Seats a new stadium of [nationId] holds: nine tenths of its biggest real
  /// ground, never under 8,000 (a microstate's new ground is still a proper
  /// one) and never over 90,000.
  static int newCapacity(int nationId) {
    final biggest = biggestOf(nationId);
    final seats = (biggest * 0.9 / 500).round() * 500;
    return seats.clamp(8000, 90000);
  }

  /// What a new stadium of [nationId] costs: €20M, plus €0.25M for every
  /// thousand seats, in whole millions. €22M for a microstate's 8,000, about
  /// €38M for a 73,000-seater.
  static int buildCost(int nationId) {
    final extra = (newCapacity(nationId) / 1000 * 0.25).round();
    return (20 + extra) * FederationFinance.investLevelPrice;
  }

  /// The name a new stadium in [city] takes: a proper name, stored and shown
  /// as it stands like every generated venue name ("Estadio Kastel"), and
  /// never one the static generator can produce, so it cannot read as a
  /// second copy of the city's seed ground.
  static String newStadiumName(String city) => '$city Arena Nova';

  /// Reputation points of [works]: one per enlargement level, [builtPoints]
  /// per stadium built, none for a downsizing.
  static int points(Iterable<StadiumWork> works) => works.fold(
    0,
    (sum, w) =>
        sum +
        (w.isBuild
            ? builtPoints
            : w.isLegacy
            ? 1
            : (w.up ? 1 : 0)),
  );

  /// Reputation points of [works] standing at [atCycle]: a work counts from
  /// the start of the cycle after it was ordered, never the moment it is
  /// ordered. Any nation's works: the standing is the manager's.
  static int reputationPoints(Iterable<StadiumWork> works, int atCycle) =>
      points([
        for (final w in works)
          if (w.cycle + buildCycles <= atCycle) w,
      ]);

  /// The reputation [points] add.
  static int reputationFor(int points) => math.min(maxReputation, points);

  /// The extra share of seats filled at a ground enlarged [upgrades] times.
  static double fillBonus(int upgrades) =>
      math.min(maxLevel, upgrades) * fillPerUpgrade;

  /// [nationId]'s stadiums in a career: the seed grounds ([seed], biggest
  /// first, the static venues) with the works in [works] applied, plus the
  /// stadiums [works] built, under the name [names] gives each (see
  /// [StadiumName]) or the generated one. [works] and [names] may hold other
  /// nations'; only [nationId]'s count. Built stadiums come back whether
  /// open or not (see [NationalStadium.openIn]).
  static List<NationalStadium> forNation({
    required int nationId,
    required List<Venue> seed,
    required Iterable<StadiumWork> works,
    Iterable<StadiumName> names = const [],
  }) {
    final given = StadiumName.latestFor(names, nationId);
    final mine = [
      for (final w in works)
        if (w.nationId == nationId) w,
    ];
    // Legacy +10% upgrades first (the highest level each reached), then the
    // resizes in the order they were ordered: one a cycle per ground, so the
    // cycle orders them.
    final legacy = <StadiumRef, int>{};
    final resizes = <StadiumRef, List<StadiumWork>>{};
    for (final w in mine) {
      if (w.isBuild) continue;
      if (w.isLegacy) {
        legacy[w.stadium] = math.max(legacy[w.stadium] ?? 0, w.legacyLevel);
      } else {
        (resizes[w.stadium] ??= []).add(w);
      }
    }
    NationalStadium shaped({
      required String city,
      required String name,
      required int base,
      required bool built,
      int? opens,
      String? site,
    }) {
      final ref = (city: site ?? city, built: built);
      var seats = base;
      var upgrades = 0;
      final old = legacy[ref] ?? 0;
      if (old > 0) {
        seats = legacyCapacityAt(base, old);
        upgrades = old;
      }
      final list = [...?resizes[ref]];
      // Stable: Dart's sort is not, and two markers of one cycle (which the
      // service never writes) keep the order they were read in.
      final order = [for (var i = 0; i < list.length; i++) i]
        ..sort((a, b) {
          final byCycle = list[a].cycle.compareTo(list[b].cycle);
          return byCycle != 0 ? byCycle : a.compareTo(b);
        });
      for (final i in order) {
        seats = list[i].capacity;
        if (list[i].up) upgrades++;
      }
      return NationalStadium(
        city: city,
        name: name,
        baseCapacity: base,
        capacity: seats,
        upgrades: upgrades,
        built: built,
        opensCycle: opens,
        site: site,
      );
    }

    final seen = <String, int>{};
    return [
      for (final v in seed)
        shaped(
          city: v.city,
          name: v.stadium,
          base: v.capacity,
          built: false,
          site: switch (seen.update(v.city, (n) => n + 1, ifAbsent: () => 1)) {
            1 => v.city,
            final n => '${v.city}#$n',
          },
        ),
      for (final w in mine)
        if (w.isBuild)
          shaped(
            city: w.stadium.city,
            name: given[w.stadium.city] ?? newStadiumName(w.stadium.city),
            base: newCapacity(nationId),
            built: true,
            opens: w.cycle + buildCycles,
          ),
    ];
  }

  /// The grounds actually standing in [cycle], biggest first: what venues,
  /// crowds and the host-bid size score read.
  static List<NationalStadium> openIn(
    List<NationalStadium> stadiums,
    int cycle,
  ) {
    final open = [
      for (final s in stadiums)
        if (s.openIn(cycle)) s,
    ];
    // Stable: equal grounds keep their order (Dart's sort is not), so a
    // nation nobody worked on reads exactly its static list.
    final order = [for (var i = 0; i < open.length; i++) i]
      ..sort((a, b) {
        final bySeats = open[b].capacity.compareTo(open[a].capacity);
        return bySeats != 0 ? bySeats : a.compareTo(b);
      });
    return [for (final i in order) open[i]];
  }

  /// The national set out of [all] (see [forNation]): the [setSize] biggest
  /// seed grounds and every stadium built, in that order.
  static List<NationalStadium> nationalSet(List<NationalStadium> all) => [
    ...all.where((s) => !s.built).take(setSize),
    ...all.where((s) => s.built),
  ];
}
