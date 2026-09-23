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
      nickname: 'Die Mannschaft',
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
    'SRB': (nickname: 'Orlovi', style: NationStyle.physical, pedigree: 3),
    'POL': (
      nickname: 'Biało-czerwoni',
      style: NationStyle.counter,
      pedigree: 3,
    ),
    'CZE': (nickname: 'Národní tým', style: NationStyle.direct, pedigree: 3),
    'TUR': (nickname: 'Ay-Yıldızlılar', style: NationStyle.direct, pedigree: 3),
    'GRE': (nickname: 'Galanolefki', style: NationStyle.defensive, pedigree: 3),
    'SCO': (nickname: 'Tartan Army', style: NationStyle.direct, pedigree: 3),
    'IRL': (nickname: 'Boys in Green', style: NationStyle.direct, pedigree: 4),
    'WAL': (nickname: 'The Dragons', style: NationStyle.counter, pedigree: 4),

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
    'QAT': (nickname: 'The Maroon', style: NationStyle.possession, pedigree: 4),
    'AUS': (nickname: 'Socceroos', style: NationStyle.direct, pedigree: 3),
  };
}
