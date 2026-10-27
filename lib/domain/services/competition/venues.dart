import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/host_cities.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/stadium_capacity.dart';

/// A tournament venue: the `stadium`, its host `city`, and the stadium's
/// `capacity` (seats). Capacity starts from the nation's real biggest ground
/// and tapers down the city list, so the marquee grounds are in the biggest
/// cities and a small country has small ones.
typedef Venue = ({String city, String stadium, int capacity});

/// Generates a host nation's tournament cities and stadiums. Deterministic in
/// the host's id, so a given host always presents the same, stable venues
/// wherever they are shown.
///
/// Real tournaments are played in a country's biggest cities, so venues are the
/// largest cities available (by population) rather than a random handful — with
/// only a small host-specific wobble in the population estimates so different
/// hosts don't all field an identical list.
abstract final class VenueGenerator {
  /// Candidate cities, roughly ordered biggest-first; the index seeds a base
  /// population so the earlier a city sits, the larger it is.
  static const List<String> _cities = [
    'Montara',
    'Kastel',
    'Westport',
    'Belgrave',
    'Ashford',
    'Norwick',
    'Verrano',
    'Granthem',
    'Rosalia',
    'Sundborg',
    'Delmar',
    'Holloway',
    'Ironwood',
    'Queensford',
    'Estburia',
    'Pelmar',
    'Cardona',
    'Lindenau',
    'Ostrava',
    'Fairhaven',
    'Torreón',
    'Ulmarno',
    'Jerova',
    'Ximena',
    'Arcelo',
    'Brenova',
    'Calderis',
    'Dornhaven',
    'Ysolde',
    'Zaltena',
  ];

  static const List<String> _stadiumPrefixes = [
    'Estadio',
    'Arena',
    'Stade',
    'Park',
    'Stadion',
    'Coliseum',
  ];

  static const List<String> _stadiumSuffixes = [
    'Nacional',
    'Olímpico',
    'Central',
    'Grande',
    'Metropolitano',
    'del Rey',
    'Arena',
    'Park',
    'Bowl',
    'Field',
  ];

  /// The [rank]th ground of a nation in [nationalStadiumCapacity], scaled
  /// down from its biggest: each step is about a tenth smaller, so a big
  /// country's eighth city still has a decent stadium and a small one's is a
  /// few thousand seats. Null for a nation not in the table.
  static int? _scaled(int hostId, int rank, SeededRng rng) {
    final biggest = nationalStadiumCapacity[hostId];
    if (biggest == null) return null;
    if (rank == 0) return biggest;
    final wobble = (rng.nextInt(61) - 30) / 1000;
    // The first eight grounds step down a tenth each; a big tournament's
    // extra grounds (ranks 8+) tail off gently from there instead of all
    // landing on the same floor.
    final factor = rank < 8
        ? (1 - rank * 0.1 + wobble).clamp(0.25, 1.0)
        // Starts just under the eighth ground's lowest (0.27) and steps a
        // hundredth at a time, with a wobble too small to break the order.
        : (0.26 - (rank - 8) * 0.01 + wobble / 10).clamp(0.12, 0.26);
    final seats = (biggest * factor / 100).round() * 100;
    return seats.clamp(1000, biggest);
  }

  /// How many grounds a finals of [teams] sides is played in. Bigger fields
  /// play more matches, so they spread over more cities, as the real
  /// tournaments do:
  ///
  /// | teams   | venues |
  /// |---------|--------|
  /// | 48+     | 16     |
  /// | 32..47  | 12     |
  /// | 24..31  | 10     |
  /// | 1..23   | 8      |
  ///
  /// 0 (unknown) falls back to the old flat 8.
  static int countForField(int teams) => switch (teams) {
    >= 48 => 16,
    >= 32 => 12,
    >= 24 => 10,
    _ => 8,
  };

  /// The venues of a tournament shared between [hostIds] (primary first):
  /// [count] grounds in total, split as evenly as possible, with any remainder
  /// going to the earlier hosts.
  ///
  /// Splitting matters: a nation only has a handful of cities, so asking one
  /// host for the whole [count] exhausts the list and leaves nothing for the
  /// co-hosts, which is how a joint tournament ended up showing only one
  /// country's stadiums.
  ///
  /// A host that runs out of cities hands its unused share to the co-hosts that
  /// still have some, so a small partner does not shrink the tournament. A
  /// solo host with fewer cities than [count] simply plays in all it has.
  ///
  /// Returns a list per host, in [hostIds] order, so the caller can label each
  /// country's grounds.
  ///
  /// [estates] replaces a host's static grounds with the ones a career has
  /// made of them (biggest first: enlarged, downsized and newly built), for
  /// the manager's nation when it hosts. A host not listed keeps the static
  /// grounds. Nothing here is stored, so this only ever shapes what is shown
  /// and the crowds of matches still to be played.
  static Map<int, List<Venue>> forHosts({
    required List<int> hostIds,
    Map<int, List<String>> citiesByHost = const {},
    int count = 8,
    Map<int, List<Venue>> estates = const {},
  }) {
    if (hostIds.isEmpty) return const {};
    // How many grounds each host can stage at most.
    final capacity = [
      for (final h in hostIds)
        if (estates[h] case final estate? when estate.isNotEmpty)
          estate.length
        else
          _poolSize(h, citiesByHost[h]),
    ];
    final share = count ~/ hostIds.length;
    final remainder = count % hostIds.length;
    // The earlier (better-ranked) hosts take the spare grounds.
    final take = [
      for (var i = 0; i < hostIds.length; i++)
        (share + (i < remainder ? 1 : 0)).clamp(1, count),
    ];
    // Hand any share a host cannot use to the next host (primary first) that
    // still has cities to spare.
    var spare = 0;
    for (var i = 0; i < take.length; i++) {
      if (take[i] > capacity[i]) {
        spare += take[i] - capacity[i];
        take[i] = capacity[i].clamp(1, count);
      }
    }
    for (var i = 0; spare > 0 && i < take.length; i++) {
      final room = capacity[i] - take[i];
      if (room <= 0) continue;
      final extra = room < spare ? room : spare;
      take[i] += extra;
      spare -= extra;
    }
    return {
      for (var i = 0; i < hostIds.length; i++)
        hostIds[i]: switch (estates[hostIds[i]]) {
          final estate? when estate.isNotEmpty => estate.take(take[i]).toList(),
          _ => forHost(
            hostId: hostIds[i],
            cities: citiesByHost[hostIds[i]],
            count: take[i],
          ),
        },
    };
  }

  /// The most grounds [hostId] can offer: its real cities plus the extra host
  /// cities, or the fictional list when it has no real ones.
  static int _poolSize(int hostId, List<String>? cities) {
    if (cities == null || cities.isEmpty) return _cities.length;
    final pool = _realCities(hostId, cities);
    final curated = _curatedIn(hostId, pool);
    // A city's second ground is a ground more.
    return pool.length +
        curated.length -
        {for (final g in curated) g.$1}.length;
  }

  /// [cities] (biggest first) followed by any extra host cities for [hostId]
  /// that are not already listed. The seed's city list stops at eight, which a
  /// 48-team finals outgrows; the extras live apart from it so the cities that
  /// also seed club names stay exactly as they were.
  static List<String> _realCities(int hostId, List<String> cities) {
    final extras = extraHostCities[hostId];
    if (extras == null) return cities;
    final seen = cities.toSet();
    return [
      ...cities,
      for (final c in extras)
        if (seen.add(c)) c,
    ];
  }

  /// A stable list of [count] venues for the host with [hostId]. When the
  /// host's real [cities] (biggest first) are supplied, tournaments are played
  /// in them; otherwise a fictional-but-plausible set is generated.
  ///
  /// With real cities, the grounds come from the curated estate
  /// ([nationalStadiumData]: the nation's real top grounds, biggest first,
  /// each in its city at its approximate real capacity). Any further city of
  /// the venue pool follows with a smaller ground than the last listed one,
  /// for a finals that needs more grounds than the nation has big ones. Each
  /// ground's name is fixed by its city (and its place among the grounds of
  /// a city with two), so it never moves when the list does.
  static List<Venue> forHost({
    required int hostId,
    List<String>? cities,
    int count = 8,
  }) {
    if (cities != null && cities.isNotEmpty) {
      final pool = _realCities(hostId, cities);
      final curated = _curatedIn(hostId, pool);
      if (curated.isNotEmpty) return _curated(hostId, curated, pool, count);
      final rng = SeededRng((hostId * 0x9E3779B1) ^ 0x5714CE5);
      final n = count.clamp(1, pool.length);
      return [
        for (var i = 0; i < n; i++)
          (
            city: pool[i], // already ordered biggest-first
            stadium: rng.chance(0.5)
                ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} '
                      '${pool[i]}'
                : '${pool[i]} '
                      '${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}',
            // Capacity tapers from the biggest city down, with a little wobble.
            capacity:
                _scaled(hostId, i, rng) ??
                (80000 - i * 6000 + rng.nextInt(3000)).clamp(30000, 85000),
          ),
      ];
    }
    final rng = SeededRng((hostId * 0x9E3779B1) ^ 0x5714CE5);
    // Population (thousands): a biggest-first base from the city's rank, plus a
    // small host-specific wobble so the ordering can shift a little per host
    // without ever turning the choice random.
    final ranked = [
      for (var i = 0; i < _cities.length; i++)
        (
          name: _cities[i],
          pop: (_cities.length - i) * 260 + 400 + rng.nextInt(180) - 90,
        ),
    ]..sort((a, b) => b.pop.compareTo(a.pop));

    final n = count.clamp(1, _cities.length);
    final venues = <Venue>[];
    for (var i = 0; i < n; i++) {
      final city = ranked[i].name;
      // Stadium capacity scales with the city's population (32k … ~85k), so the
      // biggest cities host the largest grounds.
      final capacity =
          _scaled(hostId, i, rng) ??
          (28000 + ranked[i].pop * 6).clamp(32000, 85000);
      final stadium = rng.chance(0.5)
          ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} $city'
          : '$city ${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}';
      venues.add((city: city, stadium: stadium, capacity: capacity));
    }
    return venues;
  }

  /// The curated grounds of [hostId], then the rest of [pool], [count] in
  /// all (at most every ground there is).
  /// The curated grounds of [hostId] whose city is in [pool]: all of them
  /// with the real city lists. A list that lacks the nation's biggest
  /// ground's city is not the real one (a test's, or a fictional set), and
  /// gets the old tapered grounds instead.
  static List<(String, int)> _curatedIn(int hostId, List<String> pool) {
    final curated = nationalStadiumData[hostId];
    if (curated == null || curated.isEmpty) return const [];
    final cities = pool.toSet();
    if (!cities.contains(curated.first.$1)) return const [];
    return [
      for (final g in curated)
        if (cities.contains(g.$1)) g,
    ];
  }

  static List<Venue> _curated(
    int hostId,
    List<(String, int)> curated,
    List<String> pool,
    int count,
  ) {
    final seen = <String, int>{};
    final out = <Venue>[];
    for (final (city, seats) in curated) {
      final nth = seen.update(city, (n) => n + 1, ifAbsent: () => 0);
      out.add((
        city: city,
        stadium: _groundName(hostId, city, nth),
        capacity: seats,
      ));
    }
    var last = curated.last.$2;
    for (final city in pool) {
      if (seen.containsKey(city)) continue;
      // Each a fifth smaller than the one before, never under a few hundred
      // seats and never bigger than it (the list stays biggest first).
      final next = ((last * 0.8) / 100).round() * 100;
      last = next < 300 ? (last < 300 ? last : 300) : next;
      out.add((
        city: city,
        stadium: _groundName(hostId, city, 0),
        capacity: last,
      ));
    }
    final n = count.clamp(1, out.length);
    return out.sublist(0, n);
  }

  /// The name of the [nth] ground (0 = the first) in [city] of [hostId]:
  /// "Estadio Kastel" or "Kastel Nacional", fixed by the city. The grounds
  /// of one city never share a name.
  static String _groundName(int hostId, String city, int nth) {
    var h = hostId * 0x9E3779B1 ^ 0x5714CE5;
    for (final c in city.codeUnits) {
      h = (h * 31 + c) & 0x3FFFFFFF;
    }
    final rng = SeededRng(h);
    final names = <String>[];
    while (names.length <= nth) {
      final name = rng.chance(0.5)
          ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} $city'
          : '$city ${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}';
      if (!names.contains(name)) names.add(name);
    }
    return names[nth];
  }
}
