import 'package:fnm/domain/services/nation/dormant_nations.dart';

/// The starting world ranking every build up to 1.0.6 shipped with
/// (`assets/data/nations.json` before 1.0.7 moved it to FIFA's ranking in
/// force on 1 October 2026), as nation id to world position. Frozen.
///
/// A career begun on it keeps it: when the seed loader finds a database's
/// stored ranking out of date, it first freezes that stored ranking into
/// every career already there (see `SeedLoader`), and a career bundle
/// exported without its own frozen ranking (schema
/// [lastSchemaWithoutStartingRanks] or older) is given it on import (see
/// `CareerBundle.import`). Never edit it: a save's draws were made on it.
const Map<int, int> legacySeedRanking = {
  1: 61, // Albania
  2: 176, // Andorra
  3: 89, // Armenia
  4: 21, // Austria
  5: 97, // Azerbaijan
  7: 9, // Belgium
  8: 48, // Bosnia and Herzegovina
  9: 72, // Bulgaria
  10: 12, // Croatia
  11: 105, // Cyprus
  12: 36, // Czechia
  13: 15, // Denmark
  14: 4, // England
  15: 125, // Estonia
  16: 168, // Faroe Islands
  17: 62, // Finland
  18: 3, // France
  19: 74, // Georgia
  20: 7, // Germany
  21: 179, // Gibraltar
  22: 49, // Greece
  23: 45, // Hungary
  24: 76, // Iceland
  25: 71, // Israel
  26: 10, // Italy
  27: 118, // Kazakhstan
  28: 82, // Kosovo
  29: 139, // Latvia
  30: 187, // Liechtenstein
  31: 140, // Lithuania
  32: 111, // Luxembourg
  33: 154, // Malta
  34: 128, // Moldova
  35: 83, // Montenegro
  36: 8, // Netherlands
  37: 78, // North Macedonia
  38: 84, // Northern Ireland
  39: 32, // Norway
  40: 33, // Poland
  41: 5, // Portugal
  42: 66, // Republic of Ireland
  43: 57, // Romania
  45: 203, // San Marino
  46: 47, // Scotland
  47: 30, // Serbia
  48: 58, // Slovakia
  49: 59, // Slovenia
  50: 6, // Spain
  51: 37, // Sweden
  52: 23, // Switzerland
  53: 34, // Türkiye
  54: 39, // Ukraine
  55: 52, // Wales
  56: 1, // Argentina
  57: 98, // Bolivia
  58: 2, // Brazil
  59: 43, // Chile
  60: 11, // Colombia
  61: 41, // Ecuador
  62: 56, // Paraguay
  63: 50, // Peru
  64: 14, // Uruguay
  65: 69, // Venezuela
  66: 191, // Anguilla
  67: 147, // Antigua and Barbuda
  68: 172, // Aruba
  69: 177, // Bahamas
  70: 153, // Barbados
  71: 159, // Belize
  72: 148, // Bermuda
  73: 197, // British Virgin Islands
  74: 26, // Canada
  75: 193, // Cayman Islands
  76: 40, // Costa Rica
  77: 116, // Cuba
  78: 87, // Curaçao
  79: 185, // Dominica
  80: 106, // Dominican Republic
  81: 107, // El Salvador
  82: 162, // Grenada
  83: 101, // Guatemala
  84: 149, // Guyana
  85: 81, // Haiti
  86: 75, // Honduras
  87: 55, // Jamaica
  88: 17, // Mexico
  89: 202, // Montserrat
  90: 145, // Nicaragua
  91: 65, // Panama
  92: 164, // Puerto Rico
  93: 165, // Saint Kitts and Nevis
  94: 182, // Saint Lucia
  95: 175, // St Vincent and the Grenadines
  96: 92, // Suriname
  97: 85, // Trinidad and Tobago
  98: 208, // Turks and Caicos Islands
  99: 24, // United States
  100: 206, // US Virgin Islands
  101: 25, // Algeria
  102: 79, // Angola
  103: 86, // Benin
  104: 132, // Botswana
  105: 53, // Burkina Faso
  106: 133, // Burundi
  107: 35, // Cameroon
  108: 73, // Cape Verde
  109: 143, // Central African Republic
  110: 167, // Chad
  111: 134, // Comoros
  112: 99, // Congo
  113: 44, // DR Congo
  114: 184, // Djibouti
  115: 27, // Egypt
  116: 117, // Equatorial Guinea
  117: 178, // Eritrea
  118: 161, // Eswatini
  119: 135, // Ethiopia
  120: 80, // Gabon
  121: 100, // Gambia
  122: 31, // Ghana
  123: 63, // Guinea
  124: 91, // Guinea-Bissau
  125: 28, // Ivory Coast
  126: 109, // Kenya
  127: 169, // Lesotho
  128: 127, // Liberia
  129: 119, // Libya
  130: 120, // Madagascar
  131: 150, // Malawi
  132: 46, // Mali
  133: 112, // Mauritania
  134: 181, // Mauritius
  135: 13, // Morocco
  136: 122, // Mozambique
  137: 129, // Namibia
  138: 141, // Niger
  139: 29, // Nigeria
  140: 142, // Rwanda
  141: 196, // São Tomé and Príncipe
  142: 18, // Senegal
  143: 199, // Seychelles
  144: 123, // Sierra Leone
  145: 195, // Somalia
  146: 67, // South Africa
  147: 183, // South Sudan
  148: 130, // Sudan
  149: 124, // Tanzania
  150: 104, // Togo
  151: 38, // Tunisia
  152: 114, // Uganda
  153: 96, // Zambia
  154: 115, // Zimbabwe
  155: 158, // Afghanistan
  156: 20, // Australia
  157: 90, // Bahrain
  158: 166, // Bangladesh
  159: 200, // Bhutan
  160: 192, // Brunei
  161: 160, // Cambodia
  162: 70, // China PR
  163: 173, // Chinese Taipei
  164: 198, // Guam
  165: 137, // Hong Kong
  166: 102, // India
  167: 108, // Indonesia
  168: 22, // Iran
  169: 54, // Iraq
  170: 16, // Japan
  171: 77, // Jordan
  172: 126, // Kuwait
  173: 138, // Kyrgyzstan
  174: 186, // Laos
  175: 110, // Lebanon
  176: 201, // Macau
  177: 121, // Malaysia
  178: 180, // Maldives
  179: 188, // Mongolia
  180: 155, // Myanmar
  181: 170, // Nepal
  182: 103, // North Korea
  183: 88, // Oman
  184: 174, // Pakistan
  185: 113, // Palestine
  186: 146, // Philippines
  187: 51, // Qatar
  188: 42, // Saudi Arabia
  189: 151, // Singapore
  190: 19, // South Korea
  191: 189, // Sri Lanka
  192: 93, // Syria
  193: 131, // Tajikistan
  194: 94, // Thailand
  195: 204, // Timor-Leste
  196: 157, // Turkmenistan
  197: 68, // United Arab Emirates
  198: 60, // Uzbekistan
  199: 95, // Vietnam
  200: 171, // Yemen
  201: 209, // American Samoa
  202: 207, // Cook Islands
  203: 136, // Fiji
  204: 144, // New Caledonia
  205: 64, // New Zealand
  206: 163, // Papua New Guinea
  207: 194, // Samoa
  208: 152, // Solomon Islands
  209: 156, // Tahiti
  210: 205, // Tonga
  211: 190, // Vanuatu
};

/// Greenland's rank in a [legacySeedRanking] world. That ranking has 209
/// nations and its 209th is American Samoa, so Greenland sat just below it.
/// The current ranking puts San Marino last, and Greenland takes its 209.
const int legacyGreenlandRank = 210;

/// The newest schema version whose career bundles may lack a cycle-0 seed
/// ranking: 1.0.6's, and early 1.0.7 builds' (schema 51), all on
/// [legacySeedRanking]. From this build on every export carries one.
const int lastSchemaWithoutStartingRanks = 51;

/// [base] (nation id to rank for the base world) as the world of a career
/// whose cycle-0 watched kinds are [kinds]: each dormant nation a kind names
/// (see `DormantNations.markerFor`) stands in for the nation it replaces, on
/// its own rank ([dormantRank], `DormantNations`' own when null). The one
/// place both frozen-ranking writers (`SeedLoader` on an update,
/// `CareerBundle.import` for an old bundle) build a career's world, so both
/// freeze the same nations a career's `forCareer` world holds.
Map<int, int> careerWorldRanks(
  Map<int, int> base,
  Iterable<String> kinds, {
  int? Function(int dormantId)? dormantRank,
}) {
  final world = Map.of(base);
  for (final kind in kinds) {
    final d = DormantNations.fromMarker(kind);
    final replaced = d == null ? null : DormantNations.replaces[d];
    if (d == null || replaced == null) continue;
    if (world.remove(replaced) == null) continue;
    final own =
        dormantRank?.call(d) ??
        DormantNations.all.where((n) => n.id == d).firstOrNull?.ranking;
    if (own != null) world[d] = own;
  }
  return world;
}
