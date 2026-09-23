import 'package:fnm/core/rng/seeded_rng.dart';

/// A tournament venue: the `stadium`, its host `city`, and the stadium's
/// `capacity` (seats). Capacity tracks the city's size, so the marquee grounds
/// are in the biggest cities.
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

  /// The venues of a tournament shared between [hostIds] (primary first):
  /// [count] grounds in total, split as evenly as possible, with any remainder
  /// going to the earlier hosts.
  ///
  /// Splitting matters: a nation only has a handful of cities, so asking one
  /// host for the whole [count] exhausts the list and leaves nothing for the
  /// co-hosts — which is how a joint tournament ended up showing only one
  /// country's stadiums.
  ///
  /// Returns a list per host, in [hostIds] order, so the caller can label each
  /// country's grounds.
  static Map<int, List<Venue>> forHosts({
    required List<int> hostIds,
    Map<int, List<String>> citiesByHost = const {},
    int count = 8,
  }) {
    if (hostIds.isEmpty) return const {};
    final share = count ~/ hostIds.length;
    final remainder = count % hostIds.length;
    return {
      for (var i = 0; i < hostIds.length; i++)
        hostIds[i]: forHost(
          hostId: hostIds[i],
          cities: citiesByHost[hostIds[i]],
          // The earlier (better-ranked) hosts take the spare grounds.
          count: (share + (i < remainder ? 1 : 0)).clamp(1, count),
        ),
    };
  }

  /// A stable list of [count] venues for the host with [hostId]. When the
  /// host's real [cities] (biggest first) are supplied, tournaments are played
  /// in them; otherwise a fictional-but-plausible set is generated.
  static List<Venue> forHost({
    required int hostId,
    List<String>? cities,
    int count = 8,
  }) {
    final rng = SeededRng((hostId * 0x9E3779B1) ^ 0x5714CE5);

    if (cities != null && cities.isNotEmpty) {
      final n = count.clamp(1, cities.length);
      return [
        for (var i = 0; i < n; i++)
          (
            city: cities[i], // already ordered biggest-first
            stadium: rng.chance(0.5)
                ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} '
                      '${cities[i]}'
                : '${cities[i]} '
                      '${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}',
            // Capacity tapers from the biggest city down, with a little wobble.
            capacity: (80000 - i * 6000 + rng.nextInt(3000)).clamp(
              30000,
              85000,
            ),
          ),
      ];
    }
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
      final capacity = (28000 + ranked[i].pop * 6).clamp(32000, 85000);
      final stadium = rng.chance(0.5)
          ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} $city'
          : '$city ${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}';
      venues.add((city: city, stadium: stadium, capacity: capacity));
    }
    return venues;
  }
}
