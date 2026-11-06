import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/enums.dart';

/// How the groundsman mowed the grass. Fixed per ground (see [forStadium]),
/// so a venue always looks the same.
enum MowingPattern {
  stripes,
  wideBands,
  checkerboard,
  diagonal,
  circles;

  static MowingPattern forStadium(String stadium) =>
      values[varietySeed('mowing:$stadium') % values.length];
}

/// How a ground's goals are built. Every style keeps the true goal mouth
/// (`PitchDims.goalHalfWidth`, `PitchDims.crossbarHeight`); only the net
/// and its supports behind the line differ.
enum GoalStyle {
  /// A deep box net held up by tall stanchions at the back: South America,
  /// and the Italian, Spanish and Mexican grounds.
  boxNet,

  /// The European net, its roof sloping from the bar down to the ground.
  sloped,

  /// The classic square net: a near-vertical back on short stanchions.
  square,

  /// An older, smaller ground's goal: a shallow net pegged to a ground bar.
  oldGround;

  /// Grounds under this capacity mostly have the [oldGround] goal.
  static const int smallGround = 12000;

  static const Map<String, GoalStyle> _byCountry = {
    'ITA': boxNet,
    'ESP': boxNet,
    'POR': boxNet,
    'MEX': boxNet,
    'CRC': boxNet,
    'ENG': square,
    'SCO': square,
    'WAL': square,
    'NIR': square,
    'IRL': square,
    'USA': square,
    'CAN': square,
  };

  /// The style at [stadium] in the country [groundCode] (of
  /// [confederation]) seating [capacity]: the same ground always gets the
  /// same goals.
  static GoalStyle forGround({
    required String stadium,
    required String groundCode,
    required Confederation confederation,
    required int capacity,
  }) {
    final h = varietySeed('goal:$stadium');
    if (capacity < smallGround && h % 10 < 7) return oldGround;
    final country = _byCountry[groundCode.toUpperCase()];
    if (country != null) return country;
    final (main, other) = switch (confederation) {
      Confederation.southAmerica => (boxNet, square),
      Confederation.europe => (sloped, square),
      Confederation.northAmerica => (square, boxNet),
      Confederation.africa => (square, sloped),
      Confederation.asia => (sloped, square),
      Confederation.oceania => (square, sloped),
    };
    return (h ~/ 10) % 10 < 8 ? main : other;
  }
}

/// What stands behind the far stand when no landmark does, or under one.
enum Terrain {
  mountains,
  sea,
  desert,
  hills,
  city;

  static const Set<String> _mountains = {
    'BOL',
    'PER',
    'ECU',
    'COL',
    'CHI',
    'SUI',
    'AUT',
    'AND',
    'LIE',
    'NEP',
    'BHU',
    'ARM',
    'GEO',
    'KGZ',
    'TJK',
    'AFG',
    'MNE',
    'BIH',
    'MKD',
    'LES',
    'ETH',
    'RWA',
    'BDI',
    'SVN',
    'KVX',
    'MNG',
    'GUA',
    'HON',
    'IRN',
  };
  static const Set<String> _sea = {
    'FRO',
    'ISL',
    'MLT',
    'CYP',
    'GIB',
    'GRL',
    'MDV',
    'SEY',
    'MRI',
    'CPV',
    'COM',
    'STP',
    'ZAN',
    'DJI',
    'SOM',
    'FIJ',
    'SAM',
    'TGA',
    'VAN',
    'SOL',
    'ASA',
    'COK',
    'TAH',
    'NCL',
    'GUM',
    'PNG',
    'TLS',
    'BRU',
    'SGP',
    'HKG',
    'MAC',
    'NZL',
    'BRB',
    'BAH',
    'BER',
    'CAY',
    'AIA',
    'ATG',
    'VGB',
    'VIR',
    'DMA',
    'GRN',
    'LCA',
    'VIN',
    'SKN',
    'MSR',
    'TCA',
    'ARU',
    'CUW',
    'JAM',
    'TRI',
    'PUR',
    'CUB',
    'DOM',
    'HAI',
    'URU',
    'MON',
    'SRI',
    'PHI',
  };
  static const Set<String> _desert = {
    'QAT',
    'UAE',
    'KSA',
    'KUW',
    'BHR',
    'OMA',
    'YEM',
    'IRQ',
    'JOR',
    'EGY',
    'LBY',
    'MTN',
    'NIG',
    'MLI',
    'CHA',
    'SDN',
    'TKM',
  };

  /// The backdrop for a ground in the country [groundCode]: its landscape
  /// where it has a telling one, otherwise hills behind a small ground and
  /// a city behind a big one.
  static Terrain forGround({
    required String groundCode,
    required int capacity,
  }) {
    final c = groundCode.toUpperCase();
    if (_mountains.contains(c)) return mountains;
    if (_sea.contains(c)) return sea;
    if (_desert.contains(c)) return desert;
    return capacity < 25000 ? hills : city;
  }
}
