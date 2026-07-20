import 'package:fnm/domain/entities/player.dart';

/// A club a player is attached to: a fictional name and the FIFA code of the
/// country whose league it plays in (so a flag can be shown next to it).
typedef ClubSide = ({String name, String country});

/// One country's league: the FIFA [country] code (for the flag), a strength
/// [tier] (1 = elite, 5 = lower), and its fictional club names.
class _League {
  const _League(this.country, this.tier, this.clubs);
  final String country;
  final int tier;
  final List<String> clubs;
}

/// Assigns every player a CLUB — purely cosmetic flavour, derived (never stored)
/// so it costs nothing and stays in step with the procedural player pool.
///
/// The club is a deterministic function of the player's id, their CURRENT
/// overall, and the save seed. Overall picks a league TIER (a star lands in an
/// elite league, a journeyman in a lesser one), so the distribution is roughly
/// realistic; the id+seed then pick the specific league and club. Because the
/// tier follows the overall, a player who develops (or declines) across a cycle
/// naturally changes club — which is exactly what the transfer window reports.
///
/// Every name here is FICTIONAL — city/region + a generic footballing
/// descriptor — so no real club's name or crest is used.
abstract final class ClubService {
  /// The club a player is at right now, with its country (for the flag).
  static ClubSide clubFor(Player p) => clubForSeed(p, 0);

  /// [clubFor] with an explicit save seed, so each save spreads players across
  /// clubs a little differently while staying stable for a given player.
  static ClubSide clubForSeed(Player p, int saveSeed) {
    final tier = _tierFor(p.overall);
    final leagues = _byTier[tier] ?? _byTier[5]!;
    final h = _hash(p.id ^ (saveSeed * 0x9E3779B1));
    final league = leagues[h % leagues.length];
    final club = league.clubs[(h ~/ leagues.length) % league.clubs.length];
    return (name: club, country: league.country);
  }

  /// Overall → league tier (1 elite … 5 lower). Bands are six wide so a player
  /// only changes tier (and so club) on a real step up or down, not on aging
  /// noise. Public so player development can weight growth by league strength.
  static int tierForOverall(int overall) {
    if (overall >= 84) return 1;
    if (overall >= 78) return 2;
    if (overall >= 72) return 3;
    if (overall >= 66) return 4;
    return 5;
  }

  static int _tierFor(int overall) => tierForOverall(overall);

  /// A stable non-negative hash (avalanche mix) for spreading picks.
  static int _hash(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }

  /// Leagues grouped by tier. Tier 1 = the elite five; tiers descend from there.
  static final Map<int, List<_League>> _byTier = () {
    final byTier = <int, List<_League>>{};
    for (final l in _leagues) {
      (byTier[l.tier] ??= []).add(l);
    }
    return byTier;
  }();

  /// The per-country club database. Every name is FICTIONAL and deliberately
  /// generic — a neutral geography (a region, river or feature of that country)
  /// plus a plain footballing suffix (FC / United / SC / City). NO real club
  /// name, badge or nickname (e.g. "Blancos", "Nerazzurri") is used, so nothing
  /// here can trip a trademark.
  static const List<_League> _leagues = [
    // ---- Tier 1: the elite leagues ----------------------------------------
    _League('eng', 1, [
      'Camden Town', 'Wessex United', 'Pennine Rovers', 'Thameside FC',
      'Kingsway City', 'Northgate Athletic', 'Riverside Town',
      'Harbourside United', 'Moorland FC', 'Sterling City',
    ]),
    _League('esp', 1, [
      'Meseta CF', 'Ebro United', 'Costa Brava FC', 'Cantábrico SC',
      'Guadalquivir CF', 'Duero United', 'Mediterráneo FC',
      'Sierra Nevada CF', 'Baleares SC', 'Aragón United',
    ]),
    _League('ita', 1, [
      'Piedmont United', 'Lombardia FC', 'Tevere SC', 'Campania United',
      'Toscana FC', 'Liguria SC', 'Veneto United', 'Emilia FC',
      'Adriatico SC', 'Apennine United',
    ]),
    _League('ger', 1, [
      'Rheinland SV', 'Westphalia FC', 'Bavaria United', 'Saxony SV',
      'Hanseatic FC', 'Swabia United', 'Baden SV', 'Franconia FC',
      'Ruhrgebiet United', 'Elbe SV',
    ]),
    _League('fra', 1, [
      'Île-de-France FC', 'Provence United', 'Rhône SC', 'Occitanie FC',
      'Brittany United', 'Normandy FC', 'Alsace SC', 'Aquitaine United',
      'Loire FC', 'Riviera SC',
    ]),

    // ---- Tier 2: strong leagues -------------------------------------------
    _League('por', 2, [
      'Douro FC', 'Minho United', 'Algarve SC', 'Tejo United',
      'Beira SC', 'Serra FC',
    ]),
    _League('ned', 2, [
      'Randstad FC', 'Holland United', 'Zeeland SC', 'Gelderland FC',
      'Brabant United', 'Friesland SC',
    ]),
    _League('bra', 2, [
      'Guanabara FC', 'Paulista United', 'Mineiro SC', 'Sulista FC',
      'Nordeste United', 'Amazônia SC', 'Pantanal FC', 'Litoral United',
    ]),
    _League('arg', 2, [
      'Plata United', 'Pampa FC', 'Litoral SC', 'Cuyo United',
      'Patagonia FC', 'Serrano SC',
    ]),
    _League('ksa', 2, [
      'Riyadh United', 'Jeddah FC', 'Eastern SC', 'Najd United',
      'Hejaz FC', 'Asir SC',
    ]),
    _League('usa', 2, [
      'Empire City FC', 'Bay Area United', 'Sun Coast SC', 'Great Lakes FC',
      'Capital United', 'Cascadia SC',
    ]),
    _League('tur', 2, [
      'Boğaziçi FC', 'Anatolia United', 'Marmara SC', 'Ege FC',
      'Karadeniz United', 'Başkent SC',
    ]),
    _League('bel', 2, [
      'Flanders FC', 'Wallonia United', 'Meuse SC', 'Kempen FC',
      'Ardennes United', 'Scheldt SC',
    ]),
    _League('mex', 2, [
      'Capital FC', 'Jalisco United', 'Nuevo León SC', 'Bajío FC',
      'Golfo United', 'Pacífico SC',
    ]),

    // ---- Tier 3: solid leagues --------------------------------------------
    _League('sco', 3, [
      'Clyde FC', 'Lothian United', 'Tayside SC', 'Grampian FC',
      'Highland United',
    ]),
    _League('gre', 3, [
      'Attica FC', 'Aegean SC', 'Macedonia FC', 'Peloponnese SC',
      'Crete United',
    ]),
    _League('jpn', 3, [
      'Kanto FC', 'Kansai United', 'Chubu SC', 'Tohoku FC', 'Kyushu United',
    ]),
    _League('kor', 3, [
      'Han River FC', 'Gyeonggi United', 'Yeongnam SC', 'Honam FC',
      'Taebaek United',
    ]),
    _League('sui', 3, [
      'Léman FC', 'Alpine United', 'Ticino SC', 'Aargau FC', 'Jura United',
    ]),
    _League('aut', 3, [
      'Danube FC', 'Tyrol United', 'Styria SC', 'Carinthia FC',
      'Salzach United',
    ]),
    _League('col', 3, [
      'Andina FC', 'Caribe United', 'Pacífica SC', 'Llanos FC',
    ]),

    // ---- Tier 4/5: lower leagues (broad base) -----------------------------
    _League('egy', 4, [
      'Nile FC', 'Cairo United', 'Delta SC', 'Alexandria Coast',
    ]),
    _League('rsa', 4, [
      'Highveld FC', 'Cape United', 'Coastal SC', 'Pretoria Town',
    ]),
    _League('mar', 4, [
      'Atlas FC', 'Casablanca United', 'Rabat SC', 'Souss Coast',
    ]),
    _League('nga', 4, [
      'Lagos United', 'Niger FC', 'Benue SC', 'Kano Town',
    ]),
    _League('aus', 4, [
      'Harbour City FC', 'Victoria United', 'Western SC', 'Sunshine FC',
    ]),
    _League('chn', 5, [
      'Yangtze FC', 'Capital United', 'Pearl River SC', 'Northern FC',
    ]),
    _League('ecu', 5, [
      'Andes FC', 'Coastal United', 'Sierra SC',
    ]),
    _League('par', 5, [
      'Paraná FC', 'Chaco United', 'Central Valley SC',
    ]),
    _League('nor', 5, [
      'Fjord FC', 'Nordland United', 'Vestland SC',
    ]),
    _League('swe', 5, [
      'Svealand FC', 'Götaland United', 'Norrland SC',
    ]),
    _League('den', 5, [
      'Zealand FC', 'Jutland United', 'Funen SC',
    ]),
  ];
}
