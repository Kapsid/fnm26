import 'package:fnm/core/rng/seeded_rng.dart';

/// A tournament venue: the `stadium` and the `city` that hosts it.
typedef Venue = ({String city, String stadium});

/// Generates a host nation's tournament cities and stadiums. Deterministic in
/// the host's id, so a given host always presents the same, stable venues
/// wherever they are shown.
abstract final class VenueGenerator {
  static const List<String> _cities = [
    'Ashford', 'Belgrave', 'Cardona', 'Delmar', 'Estburia', 'Fairhaven',
    'Granthem', 'Holloway', 'Ironwood', 'Jerova', 'Kastel', 'Lindenau',
    'Montara', 'Norwick', 'Ostrava', 'Pelmar', 'Queensford', 'Rosalia',
    'Sundborg', 'Torreón', 'Ulmarno', 'Verrano', 'Westport', 'Ximena',
    'Ysolde', 'Zaltena', 'Arcelo', 'Brenova', 'Calderis', 'Dornhaven',
  ];

  static const List<String> _stadiumPrefixes = [
    'Estadio', 'Arena', 'Stade', 'Park', 'Stadion', 'Coliseum',
  ];

  static const List<String> _stadiumSuffixes = [
    'Nacional', 'Olímpico', 'Central', 'Grande', 'Metropolitano', 'del Rey',
    'Arena', 'Park', 'Bowl', 'Field',
  ];

  /// A stable list of [count] distinct venues for the host with [hostId].
  static List<Venue> forHost({required int hostId, int count = 8}) {
    final rng = SeededRng((hostId * 0x9E3779B1) ^ 0x5714CE5);
    final cities = [..._cities];
    final venues = <Venue>[];
    final n = count.clamp(1, cities.length);
    for (var i = 0; i < n; i++) {
      final city = cities.removeAt(rng.nextInt(cities.length));
      // Half named after the city, half a prefix + evocative suffix.
      final stadium = rng.chance(0.5)
          ? '${_stadiumPrefixes[rng.nextInt(_stadiumPrefixes.length)]} $city'
          : '$city ${_stadiumSuffixes[rng.nextInt(_stadiumSuffixes.length)]}';
      venues.add((city: city, stadium: stadium));
    }
    return venues;
  }
}
