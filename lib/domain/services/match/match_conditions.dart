import 'dart:math';

import 'package:fnm/domain/services/competition/national_stadium_data.dart';

/// A broad climate: the typical match-time temperature (°C) a lowland venue
/// sees in each month, January first, northern hemisphere. A southern nation
/// reads it six months on (see [MatchClimate.temperatureAt]).
///
/// Deliberately coarse: one band per country (with a handful of city
/// exceptions in the few hosts big enough to span several), because all it
/// has to say is "a June final in Doha is hot, a June final in Oslo is not".
enum ClimateBand {
  nordic([0, 1, 4, 10, 16, 20, 22, 21, 16, 10, 5, 1]),
  cool([6, 7, 10, 14, 18, 21, 23, 23, 19, 15, 10, 7]),
  continental([3, 6, 11, 17, 22, 26, 28, 28, 23, 17, 10, 4]),
  subtropical([9, 11, 15, 21, 26, 29, 32, 32, 28, 23, 17, 11]),
  mediterranean([13, 14, 17, 20, 25, 29, 32, 32, 28, 23, 18, 14]),
  arid([16, 18, 23, 28, 33, 37, 39, 39, 35, 29, 22, 17]),
  desert([23, 25, 29, 34, 39, 42, 43, 43, 40, 35, 29, 24]),
  sahel([32, 35, 38, 40, 40, 37, 33, 31, 33, 36, 35, 32]),
  tropical([30, 31, 31, 31, 30, 30, 29, 29, 30, 30, 30, 30]),
  monsoon([25, 28, 33, 37, 39, 37, 33, 32, 32, 31, 28, 25]);

  const ClimateBand(this.monthly);

  /// Typical match-time temperature per month, January first.
  final List<int> monthly;

  /// The hottest month's figure: what a side from this climate is used to.
  int get hottest => monthly.reduce(max);
}

/// Where a match is played, as far as the players' lungs and legs care: the
/// altitude of the ground and the climate of its country.
///
/// Derived entirely from static data (the city a ground stands in and its
/// country), so nothing is stored and every save reads it the same way.
abstract final class MatchClimate {
  /// Below this a ground counts as sea level: nobody's legs notice it.
  static const int altitudeFloor = 1000;

  /// How much cooler the air is per kilometre of altitude (the standard
  /// lapse rate), so La Paz in a tropical country is not a 30°C venue.
  static const double _lapsePerKm = 6.5;

  /// The ground's altitude in metres: the curated figure for its city, or 0
  /// (sea level for all that matters) for anything below [altitudeFloor] or
  /// not listed.
  static int altitudeOf(int nationId, String city) =>
      _altitude[nationId]?[city] ?? 0;

  /// The city a nation's national team plays its home games in.
  ///
  /// Its biggest ground (the first in [nationalStadiumData]) for almost
  /// everybody. A few nations deliberately play up in the mountains instead,
  /// because the thin air is worth more than the extra seats: Ecuador in
  /// Quito, not Guayaquil; Colombia in Bogotá; Ethiopia in Addis Ababa;
  /// Yemen in Sanaa.
  static String? homeCityOf(int nationId) =>
      _homeCity[nationId] ?? nationalStadiumData[nationId]?.first.$1;

  /// The altitude a nation's players are used to: that of its home city.
  /// A side used to 2,850 m barely notices 3,640.
  static int acclimatisedAltitude(int nationId) {
    final city = homeCityOf(nationId);
    return city == null ? 0 : altitudeOf(nationId, city);
  }

  /// The climate of [nationId], or of [city] in it where the country spans
  /// several (the United States, Australia).
  static ClimateBand bandOf(int nationId, {String? city}) =>
      _cityBand[nationId]?[city] ?? _band[nationId] ?? ClimateBand.continental;

  /// Whether [nationId] lies south of the equator outside the tropics, so
  /// its seasons run six months off the northern ones.
  static bool isSouthern(int nationId) => _southern.contains(nationId);

  /// The typical match-time temperature at [city] in [nationId] in [month]
  /// (1-12), corrected for the ground's altitude.
  static int temperatureAt(int nationId, String city, int month) {
    final band = bandOf(nationId, city: city);
    final shifted = isSouthern(nationId) ? (month + 5) % 12 : month - 1;
    final sea = band.monthly[shifted.clamp(0, 11)];
    final alt = altitudeOf(nationId, city);
    return (sea - _lapsePerKm * alt / 1000).round();
  }

  /// The hottest match-time temperature a nation's players are used to at
  /// home: its climate's hottest month.
  ///
  /// Read off the country's lowland climate, not its home ground: Ecuador
  /// plays in Quito but most of its players grew up on the hot coast.
  static int homeHeat(int nationId) =>
      bandOf(nationId, city: homeCityOf(nationId)).hottest;

  /// National teams that play at home somewhere other than their biggest
  /// ground: in each case the real one, up in the mountains.
  static const Map<int, String> _homeCity = {
    60: 'Bogotá', // Colombia
    61: 'Quito', // Ecuador
    119: 'Addis Ababa', // Ethiopia
    200: 'Sanaa', // Yemen
  };

  /// Southern-hemisphere nations with real seasons (the tropical ones have
  /// none worth shifting).
  static const Set<int> _southern = {
    56, 59, 62, 63, 64, // Argentina, Chile, Paraguay, Peru, Uruguay
    104, 118, 127, 137, 146, // Botswana, Eswatini, Lesotho, Namibia, S. Africa
    156, 205, // Australia, New Zealand
  };

  /// Every ground at or above [altitudeFloor], by nation and city. The rest
  /// of the world is sea level as far as the match is concerned.
  static const Map<int, Map<String, int>> _altitude = {
    2: {
      'Andorra la Vella': 1023,
      'Escaldes-Engordany': 1050,
      'Encamp': 1250,
    }, // Andorra
    3: {'Gyumri': 1550, 'Vanadzor': 1350, 'Abovyan': 1400}, // Armenia
    53: {'Konya': 1016, 'Kayseri': 1054, 'Sivas': 1278}, // Türkiye
    56: {'Salta': 1152}, // Argentina
    57: {
      'La Paz': 3640,
      'El Alto': 4150,
      'Cochabamba': 2558,
      'Sucre': 2810,
      'Oruro': 3735,
      'Potosí': 4067,
    }, // Bolivia
    58: {'Brasília': 1172}, // Brazil
    59: {'Calama': 2260}, // Chile
    60: {
      'Bogotá': 2640,
      'Medellín': 1495,
      'Cali': 1018,
      'Manizales': 2160,
      'Pereira': 1411,
      'Ibagué': 1285,
      'Pasto': 2527,
      'Armenia': 1483,
    }, // Colombia
    61: {
      'Quito': 2850,
      'Cuenca': 2560,
      'Ambato': 2577,
      'Loja': 2060,
      'Riobamba': 2754,
      'Ibarra': 2225,
      'Latacunga': 2750,
    }, // Ecuador
    63: {
      'Arequipa': 2335,
      'Cusco': 3399,
      'Huancayo': 3259,
      'Juliaca': 3825,
      'Cajamarca': 2750,
      'Ayacucho': 2761,
      'Huánuco': 1894,
    }, // Peru
    65: {'Mérida': 1630, 'Los Teques': 1169}, // Venezuela
    74: {'Calgary': 1045}, // Canada
    76: {'San José': 1170, 'Cartago': 1435, 'Heredia': 1150}, // Costa Rica
    83: {
      'Guatemala City': 1500,
      'Quetzaltenango': 2330,
      'Mixco': 1700,
      'Villa Nueva': 1330,
      'Cobán': 1316,
    }, // Guatemala
    88: {
      'Mexico City': 2240,
      'Guadalajara': 1566,
      'Puebla': 2135,
      'Toluca': 2660,
      'León': 1815,
      'Querétaro': 1820,
      'Torreón': 1120,
      'San Luis Potosí': 1860,
      'Aguascalientes': 1888,
      'Ciudad Juárez': 1137,
      'Morelia': 1920,
      'Pachuca': 2400,
    }, // Mexico
    99: {'Denver': 1609}, // United States
    101: {'Sétif': 1096, 'Batna': 1040, 'Djelfa': 1140}, // Algeria
    102: {'Huambo': 1700, 'Lubango': 1760, 'Malanje': 1150}, // Angola
    104: {
      'Gaborone': 1010,
      'Francistown': 1000,
      'Molepolole': 1100,
      'Serowe': 1150,
      'Lobatse': 1190,
    }, // Botswana
    106: {
      'Gitega': 1500,
      'Ngozi': 1800,
      'Kayanza': 1900,
      'Muyinga': 1700,
    }, // Burundi
    107: {'Bafoussam': 1450, 'Bamenda': 1250}, // Cameroon
    113: {
      'Lubumbashi': 1208,
      'Bukavu': 1500,
      'Goma': 1500,
      'Likasi': 1300,
    }, // DR Congo
    117: {'Asmara': 2325, 'Keren': 1390, 'Mendefera': 1950}, // Eritrea
    118: {'Mbabane': 1243, 'Nhlangano': 1000}, // Eswatini
    119: {
      'Addis Ababa': 2355,
      'Dire Dawa': 1200,
      'Mekelle': 2084,
      'Adama': 1712,
      'Hawassa': 1708,
      'Bahir Dar': 1800,
      'Gondar': 2133,
      'Jimma': 1780,
    }, // Ethiopia
    123: {'Labé': 1025}, // Guinea
    126: {
      'Nairobi': 1795,
      'Nakuru': 1850,
      'Eldoret': 2100,
      'Kisumu': 1131,
      'Machakos': 1600,
      'Thika': 1630,
      'Kakamega': 1535,
    }, // Kenya
    127: {
      'Maseru': 1600,
      'Teyateyaneng': 1600,
      'Mafeteng': 1600,
      'Hlotse': 1600,
      'Maputsoe': 1550,
      "Mohale's Hoek": 1550,
    }, // Lesotho
    130: {
      'Antananarivo': 1280,
      'Antsirabe': 1500,
      'Fianarantsoa': 1200,
    }, // Madagascar
    131: {
      'Lilongwe': 1050,
      'Blantyre': 1040,
      'Mzuzu': 1250,
      'Kasungu': 1000,
    }, // Malawi
    137: {'Windhoek': 1655, 'Otjiwarongo': 1460, 'Rundu': 1100}, // Namibia
    139: {'Jos': 1238}, // Nigeria
    140: {
      'Kigali': 1567,
      'Butare': 1768,
      'Gisenyi': 1480,
      'Rubavu': 1480,
      'Musanze': 1850,
      'Muhanga': 1850,
    }, // Rwanda
    145: {'Hargeisa': 1334}, // Somalia
    146: {
      'Johannesburg': 1750,
      'Soweto': 1650,
      'Pretoria': 1340,
      'Bloemfontein': 1395,
      'Polokwane': 1310,
      'Rustenburg': 1170,
      'Kimberley': 1200,
      'Potchefstroom': 1350,
      'Welkom': 1340,
    }, // South Africa
    149: {'Arusha': 1400, 'Mbeya': 1700, 'Dodoma': 1120}, // Tanzania
    152: {
      'Kampala': 1190,
      'Mbarara': 1430,
      'Mbale': 1150,
      'Jinja': 1140,
      'Masaka': 1150,
      'Entebbe': 1170,
      'Gulu': 1100,
      'Lira': 1080,
    }, // Uganda
    153: {
      'Lusaka': 1280,
      'Kitwe': 1300,
      'Ndola': 1270,
      'Kabwe': 1180,
      'Chingola': 1350,
      'Mufulira': 1250,
      'Chipata': 1150,
    }, // Zambia
    154: {
      'Harare': 1490,
      'Bulawayo': 1358,
      'Chitungwiza': 1450,
      'Mutare': 1120,
      'Gweru': 1420,
      'Kwekwe': 1210,
      'Kadoma': 1150,
    }, // Zimbabwe
    155: {'Kabul': 1790, 'Kandahar': 1010}, // Afghanistan
    159: {
      'Thimphu': 2330,
      'Paro': 2200,
      'Punakha': 1250,
      'Wangdue Phodrang': 1350,
    }, // Bhutan
    166: {'Shillong': 1525}, // India
    168: {
      'Tehran': 1190,
      'Isfahan': 1574,
      'Karaj': 1312,
      'Shiraz': 1500,
      'Tabriz': 1350,
      'Kermanshah': 1350,
      'Kerman': 1755,
      'Urmia': 1330,
      'Zahedan': 1352,
      'Hamadan': 1850,
      'Arak': 1708,
      'Yazd': 1216,
    }, // Iran
    173: {
      'Osh': 1000,
      'Naryn': 2040,
      'Karakol': 1770,
    }, // Kyrgyzstan
    179: {
      'Ulaanbaatar': 1350,
      'Erdenet': 1300,
      'Mörön': 1280,
      'Khovd': 1400,
    }, // Mongolia
    180: {'Taunggyi': 1436}, // Myanmar
    181: {'Kathmandu': 1400, 'Lalitpur': 1350}, // Nepal
    184: {'Quetta': 1680}, // Pakistan
    188: {
      'Abha': 2270,
      'Taif': 1879,
      'Khamis Mushait': 2000,
      'Najran': 1290,
    }, // Saudi Arabia
    193: {'Istaravshan': 1000}, // Tajikistan
    200: {'Sanaa': 2250, 'Taiz': 1400, 'Ibb': 2050}, // Yemen
    206: {'Mount Hagen': 1677, 'Goroka': 1600}, // Papua New Guinea
  };

  /// Each nation's climate. Anything not listed reads as continental.
  static const Map<int, ClimateBand> _band = {
    // Europe
    1: ClimateBand.mediterranean, 2: ClimateBand.continental, //
    3: ClimateBand.mediterranean, 4: ClimateBand.cool,
    5: ClimateBand.mediterranean, 7: ClimateBand.cool,
    8: ClimateBand.continental, 9: ClimateBand.continental,
    10: ClimateBand.continental, 11: ClimateBand.arid,
    12: ClimateBand.cool, 13: ClimateBand.cool,
    14: ClimateBand.cool, 15: ClimateBand.nordic,
    16: ClimateBand.nordic, 17: ClimateBand.nordic,
    18: ClimateBand.continental, 19: ClimateBand.continental,
    20: ClimateBand.cool, 21: ClimateBand.mediterranean,
    22: ClimateBand.mediterranean, 23: ClimateBand.continental,
    24: ClimateBand.nordic, 25: ClimateBand.mediterranean,
    26: ClimateBand.mediterranean, 27: ClimateBand.continental,
    28: ClimateBand.continental, 29: ClimateBand.nordic,
    30: ClimateBand.cool, 31: ClimateBand.nordic,
    32: ClimateBand.cool, 33: ClimateBand.mediterranean,
    34: ClimateBand.continental, 35: ClimateBand.mediterranean,
    36: ClimateBand.cool, 37: ClimateBand.mediterranean,
    38: ClimateBand.cool, 39: ClimateBand.nordic,
    40: ClimateBand.cool, 41: ClimateBand.mediterranean,
    42: ClimateBand.cool, 43: ClimateBand.continental,
    45: ClimateBand.continental, 46: ClimateBand.cool,
    47: ClimateBand.continental, 48: ClimateBand.cool,
    49: ClimateBand.continental, 50: ClimateBand.mediterranean,
    51: ClimateBand.nordic, 52: ClimateBand.cool,
    53: ClimateBand.mediterranean, 54: ClimateBand.continental,
    55: ClimateBand.cool,
    // South America
    56: ClimateBand.mediterranean, 57: ClimateBand.tropical,
    58: ClimateBand.tropical, 59: ClimateBand.mediterranean,
    60: ClimateBand.tropical, 61: ClimateBand.tropical,
    62: ClimateBand.subtropical, 63: ClimateBand.cool,
    64: ClimateBand.mediterranean, 65: ClimateBand.tropical,
    // North and Central America, the Caribbean
    66: ClimateBand.tropical, 67: ClimateBand.tropical,
    68: ClimateBand.tropical, 69: ClimateBand.tropical,
    70: ClimateBand.tropical, 71: ClimateBand.tropical,
    72: ClimateBand.subtropical, 73: ClimateBand.tropical,
    74: ClimateBand.continental, 75: ClimateBand.tropical,
    76: ClimateBand.tropical, 77: ClimateBand.tropical,
    78: ClimateBand.tropical, 79: ClimateBand.tropical,
    80: ClimateBand.tropical, 81: ClimateBand.tropical,
    82: ClimateBand.tropical, 83: ClimateBand.tropical,
    84: ClimateBand.tropical, 85: ClimateBand.tropical,
    86: ClimateBand.tropical, 87: ClimateBand.tropical,
    88: ClimateBand.arid, 89: ClimateBand.tropical,
    90: ClimateBand.tropical, 91: ClimateBand.tropical,
    92: ClimateBand.tropical, 93: ClimateBand.tropical,
    94: ClimateBand.tropical, 95: ClimateBand.tropical,
    96: ClimateBand.tropical, 97: ClimateBand.tropical,
    98: ClimateBand.tropical, 99: ClimateBand.subtropical,
    100: ClimateBand.tropical,
    // Africa
    101: ClimateBand.mediterranean, 102: ClimateBand.tropical,
    103: ClimateBand.tropical, 104: ClimateBand.subtropical,
    105: ClimateBand.sahel, 106: ClimateBand.tropical,
    107: ClimateBand.tropical, 108: ClimateBand.tropical,
    109: ClimateBand.tropical, 110: ClimateBand.sahel,
    111: ClimateBand.tropical, 112: ClimateBand.tropical,
    113: ClimateBand.tropical, 114: ClimateBand.desert,
    115: ClimateBand.arid, 116: ClimateBand.tropical,
    117: ClimateBand.tropical, 118: ClimateBand.subtropical,
    119: ClimateBand.tropical, 120: ClimateBand.tropical,
    121: ClimateBand.tropical, 122: ClimateBand.tropical,
    123: ClimateBand.tropical, 124: ClimateBand.tropical,
    125: ClimateBand.tropical, 126: ClimateBand.tropical,
    127: ClimateBand.mediterranean, 128: ClimateBand.tropical,
    129: ClimateBand.arid, 130: ClimateBand.tropical,
    131: ClimateBand.tropical, 132: ClimateBand.sahel,
    133: ClimateBand.sahel, 134: ClimateBand.tropical,
    135: ClimateBand.mediterranean, 136: ClimateBand.tropical,
    137: ClimateBand.subtropical, 138: ClimateBand.sahel,
    139: ClimateBand.tropical, 140: ClimateBand.tropical,
    141: ClimateBand.tropical, 142: ClimateBand.tropical,
    143: ClimateBand.tropical, 144: ClimateBand.tropical,
    145: ClimateBand.tropical, 146: ClimateBand.subtropical,
    147: ClimateBand.tropical, 148: ClimateBand.desert,
    149: ClimateBand.tropical, 150: ClimateBand.tropical,
    151: ClimateBand.arid, 152: ClimateBand.tropical,
    153: ClimateBand.tropical, 154: ClimateBand.tropical,
    // Asia
    155: ClimateBand.arid, 156: ClimateBand.subtropical,
    157: ClimateBand.desert, 158: ClimateBand.monsoon,
    159: ClimateBand.monsoon, 160: ClimateBand.tropical,
    161: ClimateBand.tropical, 162: ClimateBand.subtropical,
    163: ClimateBand.subtropical, 164: ClimateBand.tropical,
    165: ClimateBand.subtropical, 166: ClimateBand.monsoon,
    167: ClimateBand.tropical, 168: ClimateBand.arid,
    169: ClimateBand.desert, 170: ClimateBand.subtropical,
    171: ClimateBand.mediterranean, 172: ClimateBand.desert,
    173: ClimateBand.continental, 174: ClimateBand.tropical,
    175: ClimateBand.mediterranean, 176: ClimateBand.subtropical,
    177: ClimateBand.tropical, 178: ClimateBand.tropical,
    179: ClimateBand.cool, 180: ClimateBand.tropical,
    181: ClimateBand.monsoon, 182: ClimateBand.continental,
    183: ClimateBand.desert, 184: ClimateBand.monsoon,
    185: ClimateBand.mediterranean, 186: ClimateBand.tropical,
    187: ClimateBand.desert, 188: ClimateBand.desert,
    189: ClimateBand.tropical, 190: ClimateBand.subtropical,
    191: ClimateBand.tropical, 192: ClimateBand.arid,
    193: ClimateBand.arid, 194: ClimateBand.tropical,
    195: ClimateBand.tropical, 196: ClimateBand.arid,
    197: ClimateBand.desert, 198: ClimateBand.arid,
    199: ClimateBand.subtropical, 200: ClimateBand.arid,
    // Oceania
    201: ClimateBand.tropical, 202: ClimateBand.tropical,
    203: ClimateBand.tropical, 204: ClimateBand.tropical,
    205: ClimateBand.cool, 206: ClimateBand.tropical,
    207: ClimateBand.tropical, 208: ClimateBand.tropical,
    209: ClimateBand.tropical, 210: ClimateBand.tropical,
    211: ClimateBand.tropical, 212: ClimateBand.nordic,
  };

  /// The cities of a big host whose climate is not the country's.
  static const Map<int, Map<String, ClimateBand>> _cityBand = {
    99: {
      'New York': ClimateBand.continental,
      'Chicago': ClimateBand.continental,
      'Seattle': ClimateBand.cool,
      'Boston': ClimateBand.continental,
      'Philadelphia': ClimateBand.continental,
      'San Francisco': ClimateBand.cool,
      'Denver': ClimateBand.continental,
      'Washington': ClimateBand.continental,
      'Minneapolis': ClimateBand.continental,
      'Los Angeles': ClimateBand.mediterranean,
      'Phoenix': ClimateBand.desert,
    }, // United States
    156: {
      'Melbourne': ClimateBand.cool,
      'Hobart': ClimateBand.cool,
      'Launceston': ClimateBand.cool,
      'Geelong': ClimateBand.cool,
      'Adelaide': ClimateBand.mediterranean,
      'Perth': ClimateBand.mediterranean,
      'Townsville': ClimateBand.tropical,
      'Cairns': ClimateBand.tropical,
      'Darwin': ClimateBand.tropical,
    }, // Australia
  };
}

/// The conditions a match is played in and what they cost each side's legs.
///
/// One reading feeds BOTH simulators, so a skipped match and a played one
/// feel the same mountain: the played engine drains each side's energy by
/// [homeDrain] / [awayDrain] (players tire faster and the side fades late),
/// and the background simulator turns the difference into rating points
/// ([strengthEdge]).
///
/// - Altitude hurts a side that is not used to it: the metres above both
///   [MatchClimate.altitudeFloor] and its own home ground. The home side at
///   its own ground is used to it by definition, and so is a visitor from a
///   higher home (Bolivia in Quito).
/// - Heat hurts both sides, the one from a cooler climate more.
///
/// At sea level in temperate weather both drains are exactly 1.0 and the edge
/// exactly 0, so the engine and the world play exactly as they did before.
class MatchConditions {
  const MatchConditions({
    this.altitude = 0,
    this.temperature = 20,
    this.homeAltitudeDrain = 0,
    this.awayAltitudeDrain = 0,
    this.homeHeatDrain = 0,
    this.awayHeatDrain = 0,
  });

  /// Sea level, temperate: changes nothing.
  static const MatchConditions none = MatchConditions();

  /// The ground's altitude (metres; 0 below [MatchClimate.altitudeFloor]).
  final int altitude;

  /// The typical match-time temperature (°C).
  final int temperature;

  /// The extra share of energy each side burns a minute for the thin air
  /// (0 = none) and for the heat.
  final double homeAltitudeDrain;
  final double awayAltitudeDrain;
  final double homeHeatDrain;
  final double awayHeatDrain;

  /// How much faster than normal each side's legs go (1.0 = normal).
  double get homeDrain => 1.0 + homeAltitudeDrain + homeHeatDrain;
  double get awayDrain => 1.0 + awayAltitudeDrain + awayHeatDrain;

  /// From this temperature up the heat costs legs.
  static const int heatFrom = 29;

  /// A climate whose hottest month reaches this is a warm one: its sides are
  /// used to a tropical ground's year-round heat.
  static const int warmClimateFrom = 30;

  /// The altitude drain below which a side is, for the preview, as good as
  /// used to the ground (Andorra's 1,023 m costs a visitor next to nothing).
  static const double notableAltitudeDrain = 0.05;

  /// A ground this high is worth a line even when nobody pays for it ("both
  /// sides are used to it"); below it, a costless altitude says nothing.
  static const int notableAltitude = 1500;

  /// Extra drain per kilometre of altitude a side is not used to.
  static const double altitudeDrainPerKm = 0.40;

  /// Extra drain per degree from [heatFrom] up, for a side from a cool
  /// climate. Warmer climates feel a share of it (see [_heatTolerance]).
  static const double heatDrainPerDegree = 0.025;

  /// Rating points the background simulator charges per unit of extra drain.
  /// Set so an even match in La Paz swings about as much there as it does in
  /// the played engine (see `match_conditions_test.dart`).
  static const double pointsPerDrain = 2.9;

  /// The conditions at [city] in [groundNationId] in [month] (1-12), for
  /// [homeNationId] hosting [awayNationId].
  factory MatchConditions.at({
    required int groundNationId,
    required String city,
    required int month,
    required int homeNationId,
    required int awayNationId,
  }) {
    final altitude = MatchClimate.altitudeOf(groundNationId, city);
    final temperature = MatchClimate.temperatureAt(groundNationId, city, month);
    double thinAir(int nationId) {
      if (altitude < MatchClimate.altitudeFloor) return 0;
      final usedTo = max(
        MatchClimate.altitudeFloor,
        MatchClimate.acclimatisedAltitude(nationId),
      );
      return altitudeDrainPerKm * max(0, altitude - usedTo) / 1000;
    }

    // A tropical ground is warm all year, and a side that is used to warmth
    // does not feel it: only a side from a cool or temperate climate pays
    // there. A seasonal climate keeps the month logic for everybody.
    final tropical =
        MatchClimate.bandOf(groundNationId, city: city) == ClimateBand.tropical;
    double heat(int nationId) {
      final hot = temperature - (heatFrom - 1);
      if (hot <= 0) return 0;
      if (tropical && MatchClimate.homeHeat(nationId) >= warmClimateFrom) {
        return 0;
      }
      return heatDrainPerDegree * hot * _heatTolerance(nationId);
    }

    return MatchConditions(
      altitude: altitude,
      temperature: temperature,
      homeAltitudeDrain: thinAir(homeNationId),
      awayAltitudeDrain: thinAir(awayNationId),
      homeHeatDrain: heat(homeNationId),
      awayHeatDrain: heat(awayNationId),
    );
  }

  /// The share of the heat a side feels: all of it from a cool climate, a
  /// third of it from one that is this hot every summer.
  static double _heatTolerance(int nationId) {
    final usedTo = MatchClimate.homeHeat(nationId);
    if (usedTo >= 35) return 0.35;
    if (usedTo >= 30) return 0.65;
    return 1;
  }

  /// Whether the altitude is high enough to matter at all.
  bool get isHigh => altitude >= MatchClimate.altitudeFloor;

  /// Whether the heat costs anybody's legs.
  bool get isHot => homeHeatDrain > 0 || awayHeatDrain > 0;

  /// Whether the thin air costs the home side / the visitors enough to say.
  bool get homeFeelsAltitude => homeAltitudeDrain >= notableAltitudeDrain;
  bool get awayFeelsAltitude => awayAltitudeDrain >= notableAltitudeDrain;

  /// Whether the altitude is worth a line in the preview: it costs somebody
  /// something, or the ground is genuinely high and both are used to it.
  bool get showsAltitude =>
      homeFeelsAltitude || awayFeelsAltitude || altitude >= notableAltitude;

  /// Whether these conditions change anything at all.
  bool get matters => homeDrain != 1.0 || awayDrain != 1.0;

  /// The home side's edge from the conditions, in rating points, for the
  /// background simulator: the visitors' extra drain less the hosts'.
  double get strengthEdge => pointsPerDrain * (awayDrain - homeDrain);
}
