/// A nation's footballing IDENTITY — a recognizable playing [NationStyle], a
/// [nickname], and a [pedigree] tier — as a *derived* layer (like the club and
/// name layers), keyed by FIFA code. Nothing is stored; a nation not in the
/// curated map falls back to a balanced, nickname-less identity.
///
/// The style is not just flavour: it feeds the AI opponent's tactics, so a
/// national team lines up with a recognizable character (Italy sit deep, the
/// Netherlands press high, Brazil play with flair) instead of every side
/// behaving the same for its rating.
library;

import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';

/// A national team's characteristic way of playing.
enum NationStyle {
  possession,
  highPress,
  defensive,
  direct,
  counter,
  flair,
  physical,
  balanced,
}

/// A nation's derived identity: an optional [nickname], a playing [style], and a
/// [pedigree] tier (1 = historic elite … 5 = minnow).
typedef NationIdentityData = ({
  String? nickname,
  NationStyle style,
  int pedigree,
});

abstract final class NationIdentity {
  /// The identity for a FIFA [code] (case-insensitive), or a balanced default.
  static NationIdentityData of(String code) =>
      _byCode[code.toUpperCase()] ?? _default;

  static NationStyle styleOf(String code) => of(code).style;
  static String? nicknameOf(String code) => of(code).nickname;

  /// The nickname to SHOW for [nation] in [languageCode]: null when it has
  /// none, or when a custom world pack renamed it (the real nickname would
  /// then sit on a different team). Shown only while the name is the default.
  static String? nicknameFor(Nation nation, String languageCode) {
    final nick = nicknameOf(nation.code);
    if (nick == null) return null;
    if (ActiveWorld.current.nationName(nation.id) != null) return null;
    final english = nation.englishName.isEmpty
        ? nation.name
        : nation.englishName;
    final shown = NationNames.display(nation.code, english, languageCode);
    return nation.name == shown ? nick : null;
  }

  static const NationIdentityData _default = (
    nickname: null,
    style: NationStyle.balanced,
    pedigree: 3,
  );

  static const Map<String, NationIdentityData> _byCode = {
    // ---- Europe -----------------------------------------------------------
    'ENG': (nickname: 'Three Lions', style: NationStyle.direct, pedigree: 1),
    'FRA': (nickname: 'Les Bleus', style: NationStyle.balanced, pedigree: 1),
    'ESP': (nickname: 'La Roja', style: NationStyle.possession, pedigree: 1),
    'GER': (
      nickname: 'Die Nationalelf',
      style: NationStyle.highPress,
      pedigree: 1,
    ),
    'ITA': (nickname: 'Azzurri', style: NationStyle.defensive, pedigree: 1),
    'NED': (nickname: 'Oranje', style: NationStyle.highPress, pedigree: 1),
    'POR': (
      nickname: 'Seleção das Quinas',
      style: NationStyle.possession,
      pedigree: 1,
    ),
    'BEL': (nickname: 'Red Devils', style: NationStyle.direct, pedigree: 2),
    'CRO': (nickname: 'Vatreni', style: NationStyle.possession, pedigree: 2),
    'SUI': (nickname: 'Nati', style: NationStyle.defensive, pedigree: 3),
    'SWE': (nickname: 'Blågult', style: NationStyle.direct, pedigree: 3),
    'DEN': (
      nickname: 'Danish Dynamite',
      style: NationStyle.highPress,
      pedigree: 3,
    ),
    'NOR': (nickname: 'Løvene', style: NationStyle.direct, pedigree: 3),
    'AUT': (nickname: 'Das Team', style: NationStyle.highPress, pedigree: 3),
    'SRB': (nickname: 'Beli Orlovi', style: NationStyle.physical, pedigree: 3),
    'POL': (
      nickname: 'Biało-czerwoni',
      style: NationStyle.counter,
      pedigree: 3,
    ),
    'CZE': (nickname: 'Nároďák', style: NationStyle.direct, pedigree: 3),
    'TUR': (nickname: 'Ay Yıldızlılar', style: NationStyle.direct, pedigree: 3),
    'GRE': (nickname: 'Ethniki', style: NationStyle.defensive, pedigree: 3),
    'SCO': (
      nickname: 'Tartan Terriers',
      style: NationStyle.direct,
      pedigree: 3,
    ),
    'IRL': (nickname: 'Boys in Green', style: NationStyle.direct, pedigree: 4),
    'WAL': (nickname: 'The Dragons', style: NationStyle.counter, pedigree: 4),
    // Greenland, a dormant nation (see DormantNations).
    'GRL': (nickname: null, style: NationStyle.direct, pedigree: 5),
    // Belarus, a dormant nation (see DormantNations): never at a finals.
    'BLR': (nickname: null, style: NationStyle.defensive, pedigree: 5),

    // ---- South America ----------------------------------------------------
    'BRA': (nickname: 'Seleção', style: NationStyle.flair, pedigree: 1),
    'ARG': (
      nickname: 'La Albiceleste',
      style: NationStyle.possession,
      pedigree: 1,
    ),
    'URU': (nickname: 'La Celeste', style: NationStyle.defensive, pedigree: 2),
    'COL': (nickname: 'Los Cafeteros', style: NationStyle.flair, pedigree: 3),
    'CHI': (nickname: 'La Roja', style: NationStyle.highPress, pedigree: 3),
    'PER': (
      nickname: 'La Blanquirroja',
      style: NationStyle.possession,
      pedigree: 3,
    ),
    'ECU': (nickname: 'La Tri', style: NationStyle.physical, pedigree: 3),
    'PAR': (
      nickname: 'La Albirroja',
      style: NationStyle.defensive,
      pedigree: 3,
    ),

    // ---- North America ----------------------------------------------------
    'MEX': (nickname: 'El Tri', style: NationStyle.counter, pedigree: 2),
    'USA': (
      nickname: 'Stars and Stripes',
      style: NationStyle.direct,
      pedigree: 3,
    ),

    // ---- Africa -----------------------------------------------------------
    'SEN': (
      nickname: 'Lions of Teranga',
      style: NationStyle.physical,
      pedigree: 3,
    ),
    'MAR': (nickname: 'Atlas Lions', style: NationStyle.counter, pedigree: 2),
    'NGA': (nickname: 'Super Eagles', style: NationStyle.direct, pedigree: 3),
    'GHA': (nickname: 'Black Stars', style: NationStyle.physical, pedigree: 3),
    'CIV': (
      nickname: 'Les Éléphants',
      style: NationStyle.physical,
      pedigree: 3,
    ),
    'CMR': (
      nickname: 'Indomitable Lions',
      style: NationStyle.physical,
      pedigree: 3,
    ),
    'EGY': (nickname: 'The Pharaohs', style: NationStyle.counter, pedigree: 3),
    'ALG': (nickname: 'Les Fennecs', style: NationStyle.flair, pedigree: 3),
    'TUN': (
      nickname: 'Eagles of Carthage',
      style: NationStyle.defensive,
      pedigree: 3,
    ),
    'RSA': (nickname: 'Bafana Bafana', style: NationStyle.flair, pedigree: 4),
    // Zanzibar, a dormant nation (see DormantNations).
    'ZAN': (
      nickname: 'Zanzibar Heroes',
      style: NationStyle.direct,
      pedigree: 5,
    ),

    // ---- Asia & Oceania ---------------------------------------------------
    'JPN': (
      nickname: 'Samurai Blue',
      style: NationStyle.possession,
      pedigree: 3,
    ),
    'KOR': (
      nickname: 'Taegeuk Warriors',
      style: NationStyle.highPress,
      pedigree: 3,
    ),
    'IRN': (nickname: 'Team Melli', style: NationStyle.defensive, pedigree: 3),
    'KSA': (
      nickname: 'The Green Falcons',
      style: NationStyle.possession,
      pedigree: 3,
    ),
    'QAT': (
      nickname: 'The Maroons',
      style: NationStyle.possession,
      pedigree: 4,
    ),
    'AUS': (nickname: 'Socceroos', style: NationStyle.direct, pedigree: 3),
    // ---- Further nicknames (default style; common descriptive names) ----
    'CAN': (nickname: 'Les Rouges', style: NationStyle.balanced, pedigree: 3),
    'CRC': (nickname: 'Los Ticos', style: NationStyle.balanced, pedigree: 3),
    'CUB': (
      nickname: 'Los Leones del Caribe',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CUW': (nickname: 'Blue Stars', style: NationStyle.balanced, pedigree: 3),
    'SLV': (nickname: 'La Selecta', style: NationStyle.balanced, pedigree: 3),
    'GRN': (nickname: 'Spice Boyz', style: NationStyle.balanced, pedigree: 3),
    'GUA': (nickname: 'Los Chapines', style: NationStyle.balanced, pedigree: 3),
    'GUY': (
      nickname: 'Golden Jaguars',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'HAI': (
      nickname: 'Les Grenadiers',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'HON': (
      nickname: 'Los Catrachos',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'JAM': (nickname: 'Reggae Boyz', style: NationStyle.balanced, pedigree: 3),
    'NCA': (
      nickname: 'Los Pinoleros',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'PAN': (
      nickname: 'La Marea Roja',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'SKN': (nickname: 'Sugar Boys', style: NationStyle.balanced, pedigree: 3),
    'VIN': (nickname: 'Vincy Heat', style: NationStyle.balanced, pedigree: 3),
    'SUR': (nickname: 'De Natio', style: NationStyle.balanced, pedigree: 3),
    'TRI': (
      nickname: 'Soca Warriors',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'BER': (
      nickname: 'Gombey Warriors',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'ATG': (nickname: 'Wadadi Boyz', style: NationStyle.balanced, pedigree: 3),
    'ALB': (nickname: 'Kuqezinjtë', style: NationStyle.balanced, pedigree: 3),
    'BIH': (nickname: 'Zmajevi', style: NationStyle.balanced, pedigree: 3),
    'BUL': (nickname: 'The Lions', style: NationStyle.balanced, pedigree: 3),
    'EST': (nickname: 'Sinisärgid', style: NationStyle.balanced, pedigree: 3),
    'FIN': (nickname: 'Huuhkajat', style: NationStyle.balanced, pedigree: 3),
    'ISL': (
      nickname: 'Strákarnir okkar',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'LUX': (nickname: 'Roud Léiwen', style: NationStyle.balanced, pedigree: 3),
    'MNE': (
      nickname: 'Hrabri Sokoli',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'NIR': (
      nickname: 'Norn Iron',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'ROU': (nickname: 'Tricolorii', style: NationStyle.balanced, pedigree: 3),
    'SVN': (nickname: 'Zmajčeki', style: NationStyle.balanced, pedigree: 3),
    'UKR': (
      nickname: 'Blue and Yellows',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'BOL': (nickname: 'La Verde', style: NationStyle.balanced, pedigree: 3),
    'VEN': (nickname: 'La Vinotinto', style: NationStyle.balanced, pedigree: 3),
    'ANG': (
      nickname: 'Palancas Negras',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'BEN': (
      nickname: 'Les Écureuils',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'BOT': (nickname: 'Zebras', style: NationStyle.balanced, pedigree: 3),
    'BFA': (nickname: 'Les Étalons', style: NationStyle.balanced, pedigree: 3),
    'BDI': (
      nickname: 'Les Hirondelles',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CPV': (
      nickname: 'Tubarões Azuis',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CTA': (nickname: 'Les Fauves', style: NationStyle.balanced, pedigree: 3),
    'CHA': (nickname: 'Les Sao', style: NationStyle.balanced, pedigree: 3),
    'COM': (
      nickname: 'Les Cœlacanthes',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CGO': (
      nickname: 'Diables Rouges',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'COD': (nickname: 'Les Léopards', style: NationStyle.balanced, pedigree: 3),
    'EQG': (
      nickname: 'Nzalang Nacional',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'SWZ': (
      nickname: 'Sihlangu Semnikati',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'ETH': (nickname: 'Walyas', style: NationStyle.balanced, pedigree: 3),
    'GAB': (
      nickname: 'Les Panthères',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'GAM': (nickname: 'Scorpions', style: NationStyle.balanced, pedigree: 3),
    'GUI': (
      nickname: 'Syli National',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'GNB': (nickname: 'Djurtus', style: NationStyle.balanced, pedigree: 3),
    'KEN': (
      nickname: 'Harambee Stars',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'LES': (nickname: 'Likuena', style: NationStyle.balanced, pedigree: 3),
    'LBR': (nickname: 'Lone Stars', style: NationStyle.balanced, pedigree: 3),
    'LBY': (
      nickname: 'Mediterranean Knights',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'MAD': (nickname: 'Barea', style: NationStyle.balanced, pedigree: 3),
    'MWI': (nickname: 'The Flames', style: NationStyle.balanced, pedigree: 3),
    'MLI': (nickname: 'Les Aigles', style: NationStyle.balanced, pedigree: 3),
    'MTN': (
      nickname: 'Mourabitounes',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'MOZ': (nickname: 'Mambas', style: NationStyle.balanced, pedigree: 3),
    'NAM': (
      nickname: 'Brave Warriors',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'NIG': (nickname: 'Le Mena', style: NationStyle.balanced, pedigree: 3),
    'RWA': (nickname: 'Amavubi', style: NationStyle.balanced, pedigree: 3),
    'SLE': (nickname: 'Leone Stars', style: NationStyle.balanced, pedigree: 3),
    'SSD': (nickname: 'Bright Stars', style: NationStyle.balanced, pedigree: 3),
    'SDN': (
      nickname: 'Sagour al-Jedian',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'TAN': (nickname: 'Taifa Stars', style: NationStyle.balanced, pedigree: 3),
    'TOG': (
      nickname: 'Les Éperviers',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'UGA': (nickname: 'Cranes', style: NationStyle.balanced, pedigree: 3),
    'ZAM': (nickname: 'Chipolopolo', style: NationStyle.balanced, pedigree: 3),
    'BAN': (
      nickname: 'Bengal Tigers',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CAM': (
      nickname: 'Angkor Warriors',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'CHN': (nickname: 'Dragon Team', style: NationStyle.balanced, pedigree: 3),
    'IND': (nickname: 'Blue Tigers', style: NationStyle.balanced, pedigree: 3),
    'IDN': (nickname: 'Garuda', style: NationStyle.balanced, pedigree: 3),
    'IRQ': (
      nickname: 'Usood Al-Rafidain',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'JOR': (nickname: 'Al-Nashama', style: NationStyle.balanced, pedigree: 3),
    'KUW': (nickname: 'Al-Azraq', style: NationStyle.balanced, pedigree: 3),
    'KGZ': (
      nickname: 'White Falcons',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'LIB': (nickname: 'The Cedars', style: NationStyle.balanced, pedigree: 3),
    'MAS': (
      nickname: 'Harimau Malaya',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'PRK': (nickname: 'Chollima', style: NationStyle.balanced, pedigree: 3),
    'PHI': (nickname: 'Azkals', style: NationStyle.balanced, pedigree: 3),
    'THA': (
      nickname: 'War Elephants',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'UAE': (nickname: 'Al-Abyad', style: NationStyle.balanced, pedigree: 3),
    'UZB': (nickname: 'White Wolves', style: NationStyle.balanced, pedigree: 3),
    'VIE': (
      nickname: 'Golden Star Warriors',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
    'FIJ': (nickname: 'Bula Boys', style: NationStyle.balanced, pedigree: 3),
    'NCL': (nickname: 'Les Cagous', style: NationStyle.balanced, pedigree: 3),
    'NZL': (nickname: 'All Whites', style: NationStyle.balanced, pedigree: 3),
    'PNG': (nickname: 'Kapuls', style: NationStyle.balanced, pedigree: 3),
    'SOL': (nickname: 'Bonitos', style: NationStyle.balanced, pedigree: 3),
    'TAH': (nickname: 'Toa Aito', style: NationStyle.balanced, pedigree: 3),
    'VAN': (
      nickname: 'The Men in Black and Gold',
      style: NationStyle.balanced,
      pedigree: 3,
    ),
  };

  /// Every code in the curated table (a guard test checks they are real).
  static Iterable<String> get curatedCodes => _byCode.keys;

  /// How many nations carry a nickname.
  static int get nicknameCount =>
      _byCode.values.where((d) => d.nickname != null).length;
}
