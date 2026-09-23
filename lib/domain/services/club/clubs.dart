import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// A club a player is attached to: a fictional name and the FIFA code of the
/// country whose league it plays in (so a flag can be shown next to it).
typedef ClubSide = ({String name, String country});

/// Where a player is in his contract clock: which deal he is on (every club
/// draw is salted with it) and the age he signed it at.
typedef ClubContract = ({int index, int since});

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
/// Every name here is a FICTIONAL parody — an affectionate nod to a real club
/// via its city + colour, its nickname, or a light pun (Man Blue, Madrid White,
/// Rio Flamingos) — never the club's actual registered name, wordmark or crest,
/// so it stays familiar yet trademark-safe.
abstract final class ClubService {
  /// The club a player is at right now, with its country (for the flag).
  static ClubSide clubFor(Player p) => clubForSeed(p, 0);

  /// [clubFor] with an explicit save seed, so each save spreads players across
  /// clubs a little differently while staying stable for a given player.
  ///
  /// [homeCode] is the FIFA code of the player's own country and [homeCities]
  /// its cities (biggest first). Given those, most players are placed at a club
  /// AT HOME, exactly as a real national pool looks: a weaker nation's squad is
  /// mostly domestic with a handful of exports, while a strong nation's stars
  /// are spread across the elite leagues. Without them the old behaviour
  /// applies — a purely rating-driven league pick, which is why even minnows
  /// fielded eleven foreign-based players and nobody ever played at home.
  static ClubSide clubForSeed(
    Player p,
    int saveSeed, {
    String homeCode = '',
    List<String> homeCities = const [],
  }) {
    // Which contract he is on. Every draw below is salted with it, so the club
    // is settled once and then STANDS until the deal runs out — see
    // [contractIndex].
    final contract = contractAt(p.id, p.age);
    final deal = contract.index;
    final level = clubLevel(p.overall, p.age, signedAt: contract.since);
    final h = _hash(p.id ^ (saveSeed * 0x9E3779B1) ^ (deal * 0x2545F491));
    final band = standingBand(level);
    // The home/abroad draw runs on its OWN mix of the id. Reusing `h ~/ 7` for
    // it drew a mean percentile of 61 rather than 50 across every squad
    // measured, so every retention figure came out well under target — the
    // clubs were right and the dice were loaded.
    final stayRoll =
        _hash(p.id * 0x27D4EB2D ^ saveSeed ^ (deal * 0x9E3779B9)) % 100;
    // The boy floor is read off the age he SIGNED at, not the age he is: a
    // seventeen-year-old on a three-year academy deal leaves when it runs out,
    // not on his nineteenth birthday. Reading it live emptied every academy in
    // the world in the same season.
    if (homeCode.isNotEmpty &&
        _staysHome(level, contract.since, homeCode, stayRoll)) {
      final home = _homeClub(homeCode, homeCities, h, band);
      if (home != null) return home;
    }
    // Where an export lands. The elite leagues buy DEPTH, not just stars: a
    // 74-rated international is far more often a big-five squad man than the
    // best player at a tier-three club, which is why a Nigeria or a Senegal
    // reads as a list of Premier League and Serie A sides. Matching the
    // destination to the player's own tier put nine tenths of Nigeria's squad
    // outside the big five; the destination now steps UP from it more often
    // than not.
    // A step DOWN is the money move that keeps the top end from being a clean
    // sweep of the big five — the Saudi or Turkish contract, the season in
    // Portugal.
    final step = switch (_hash(
          p.id * 0x85EBCA6B ^ saveSeed ^ (deal * 0x165667B1),
        ) %
        100) {
      < 12 => -1,
      < 50 => 0,
      < 80 => 1,
      _ => 2,
    };
    final tier = (_tierFor(level) - step).clamp(1, 5);
    final leagues = _byTier[tier] ?? _byTier[5]!;
    // Never "move abroad" into the player's own league by the foreign path —
    // that would be a domestic club dressed up as a transfer.
    final abroad = leagues.where((l) => l.country != homeCode).toList();
    final pool = abroad.isEmpty ? leagues : abroad;
    final league = pool[h % pool.length];
    final club = league.clubs[(h ~/ pool.length + band) % league.clubs.length];
    return (name: club, country: league.country);
  }

  /// The rating a club is picked off: the live overall with the PREDICTABLE
  /// part of the age curve taken back out (see [PlayerAging.peakOffset]).
  ///
  /// The live overall was the wrong number to hang a club on, and it showed:
  /// a teenager gains a couple of points a year as the youth markdown comes
  /// off, a veteran loses a couple as his legs go, and either crosses a
  /// five-point band often enough that the history card read as a transfer
  /// every single season. Nobody's career looks like that. Detrending for age
  /// leaves the part of a rating that is about the FOOTBALLER, which barely
  /// moves — so a move now means he genuinely stepped up or fell away.
  ///
  /// Only [_ageBlend] of the offset is taken out, not all of it: a seventeen
  /// year old placed at the club his projected peak deserves would skip the
  /// climb entirely, and the climb is half the story. The part that is left in
  /// is frozen at [signedAt] — the age he signed his current deal — so the
  /// climb happens BETWEEN contracts, in steps, rather than a little every
  /// season. Without that freeze the leftover trend was still enough to walk a
  /// player across a standing band mid-contract about one season in seven.
  static int clubLevel(int overall, int age, {int? signedAt}) =>
      (overall +
              PlayerAging.peakOffset(age) -
              PlayerAging.peakOffset(signedAt ?? age) * (1 - _ageBlend))
          .round()
          .clamp(20, 99);

  /// How much of the age curve [clubLevel] takes out. Under 1 on purpose — a
  /// prospect is placed ABOVE what he is today and still has ground to make up.
  static const double _ageBlend = 0.80;

  /// Where a player is in his transfer clock at [age]: which deal he is on and
  /// the age he signed it at.
  ///
  /// A footballer signs for a few years and then stays put; he does not
  /// renegotiate his life every August because his rating ticked over. Salting
  /// every club draw with this index is what turns the club from a running
  /// function of the rating into a DECISION taken at a point in time and then
  /// left alone.
  ///
  /// Deals run [_minContractYears]–[_maxContractYears] seasons, and a few end
  /// early: the bid nobody expected, the fallout, the relegation. That is the
  /// unscheduled transfer, and it has to be decided INSIDE this walk rather
  /// than sprung on a single season, or the move would un-happen the next year.
  static ClubContract contractAt(int playerId, int age) {
    var index = 0;
    var deal = 0;
    var start = _firstContractAge;
    while (start < age) {
      final span =
          _minContractYears +
          _hash(playerId * 0x1B873593 ^ deal * 0x2545F491) %
              (_maxContractYears - _minContractYears + 1);
      var end = start + span;
      for (var year = start + 1; year < end; year++) {
        if (_hash(playerId * 0x27220A95 ^ year * 0x9E3779B1) % 100 <
            _surpriseMovePercent) {
          end = year;
          break;
        }
      }
      if (end > age) break;
      start = end;
      deal++;
      // Most footballers sign again where they already are. Without this every
      // expiry was a transfer and a career came out as eight clubs; with it a
      // career reads as the three to six a real one does.
      if (_hash(playerId * 0x7FEB352D ^ deal * 0x846CA68B) % 100 >=
          _renewalPercent) {
        index++;
      }
    }
    return (index: index, since: age < _firstContractAge ? age : start);
  }

  /// The age a player signs his first professional deal. Below it he is at his
  /// academy and the boy floor in [_staysHome] keeps him there anyway.
  static const int _firstContractAge = 17;

  /// How long a deal runs, in seasons.
  static const int _minContractYears = 2;
  static const int _maxContractYears = 4;

  /// The chance, per season of a running contract, that it ends early anyway.
  static const int _surpriseMovePercent = 6;

  /// The chance that an expiring deal is simply signed again at the same club.
  static const int _renewalPercent = 50;

  /// A player's standing WITHIN their league, in [standingBandWidth]-point
  /// bands.
  ///
  /// The league tier alone decided the club, and its bands are six wide and
  /// bottom out at 5 — so a player from a nation whose whole pool sits under 66
  /// was locked in tier 5 for life and could NEVER change club, which is why
  /// the transfer window was empty year after year for every side but the
  /// giants. Standing shifts the club pick inside the league too, so a genuine
  /// step up (or a fade) earns a move at any level, while a point of aging
  /// noise still doesn't.
  static int standingBand(int overall) => overall ~/ standingBandWidth;

  /// How many rating points a standing band spans. Sized against how fast a
  /// player's overall actually moves (about a point a year): a five-point band
  /// means roughly a fifth of the pool changes club in a given year, which is
  /// what keeps the transfer window down to a headline or two.
  static const int standingBandWidth = 5;

  /// Whether this player is based in their own country.
  ///
  /// Retention is DATA, not a formula off the league tier ([homeRetention]).
  /// The old version derived it from how far a player had "outgrown" his home
  /// league, which gets the real world badly wrong in both directions: France
  /// is a top-tier league that exports nearly its whole national team (the
  /// model kept 91% of them at home against a real 20%), while Mexico, Iraq and
  /// China are mid-tier leagues that keep almost everyone (the model sent them
  /// abroad). No tier ordering can express both, because retention is about a
  /// league's money and pull, not its playing standard.
  ///
  /// A player's own quality still tilts it a little: the very best of any
  /// nation are courted hardest, so they leave more often than their
  /// team-mates.
  static bool _staysHome(int overall, int age, String homeCode, int roll) {
    final listed = homeRetention[homeCode];
    final percent = listed != null
        // The measured figure, pulled down for a player ABOVE the level it was
        // measured at — the elite leagues come for a country's best. One-sided
        // on purpose: a squad player being worse than his captain is no reason
        // for MORE of the squad to be home-based than really is.
        ? listed - (overall - _retentionAnchor).clamp(0, 99) * _listedTilt
        // No figure for this country: keep it on quality alone. A minnow's
        // players have nowhere better to go and stay put; an unlisted nation
        // that produces a genuine star sees him leave.
        : _unlistedRetention - (overall - _unlistedAnchor) * _unlistedTilt;
    // A boy is at his home club. Academies keep their own until they are men,
    // and a fifteen-year-old moving abroad is the rare exception that gets
    // written about — not the norm the rating-driven curve above would produce
    // for a talented kid from a small country. The step at nineteen is gentle
    // on purpose: the alternative is a cliff on a birthday.
    final floor = age <= 16
        ? 94
        : age <= 18
        ? 85
        : 0;
    final withFloor = percent < floor ? floor.toDouble() : percent;
    return roll < withFloor.round().clamp(3, 96);
  }

  /// The rating a [homeRetention] figure is anchored at — roughly a
  /// first-choice international — and how much the share falls per rating point
  /// above it. Deliberately gentle: the measured figure should survive.
  static const double _retentionAnchor = 78;

  /// Raised from 0.7 to 1.1 with the fee ceiling. The measured retention
  /// figures are right for a country's pool as a whole and were too flat at
  /// the top of it: the elite leagues come hardest for a country's very best,
  /// so a player well above the level the figure was measured at should leave
  /// noticeably more often than his team-mates. Still gentle enough that the
  /// measured figure survives for the bulk of a squad, which is the point of
  /// having measured it.
  static const double _listedTilt = 1.1;

  /// The fallback curve for a country with no measured figure: a high base at
  /// [_unlistedAnchor] falling away steeply with quality, so an unlisted minnow
  /// keeps its squad while an unlisted talent factory exports it.
  static const double _unlistedRetention = 88;
  static const double _unlistedAnchor = 66;
  static const double _unlistedTilt = 3;

  /// The share (%) of a country's internationals who play in its OWN league,
  /// read off real 2024-25 squads. This is the single most visible thing about
  /// a national pool: England's is almost entirely home-based, France's almost
  /// entirely abroad, and no amount of league-strength maths gets both right.
  ///
  /// Countries absent from this table fall back to the quality curve in
  /// [_staysHome]; the flag on a club comes from the league's country, so a
  /// listed country needs no curated league of its own (Iraq or Qatar get a
  /// generated domestic side — see [_homeClub]).
  static const homeRetention = <String, int>{
    // --- The big five: their own league IS the destination -----------------
    'eng': 92, 'ita': 85, 'esp': 72, 'ger': 70,
    // …except France, which develops for export.
    'fra': 20,
    // --- Money leagues that keep everyone ----------------------------------
    'ksa': 96, 'chn': 96, 'qat': 94, 'uae': 92, 'ind': 95, 'vie': 92,
    'tha': 85,
    // --- Strong domestic pull, mid standard --------------------------------
    // Mexico is the borderline one: Liga MX still supplies most of a squad, but
    // this generation exports enough (Milan, West Ham, Fulham, Genoa, AEK) that
    // it is nearer three-fifths than four. Iraq reads domestic but isn't — its
    // internationals are spread across the Gulf leagues, which are abroad here.
    'mex': 62, 'tur': 65, 'rsa': 70, 'irq': 48, 'bol': 68, 'rou': 60,
    'isr': 60, 'jor': 58, 'uzb': 55, 'hun': 55, 'bul': 55, 'per': 50,
    'egy': 45, 'gre': 45, 'cze': 45, 'chi': 45, 'crc': 45, 'hon': 48,
    'irn': 48, 'ukr': 40, 'usa': 38, 'pol': 35, 'tun': 35, 'par': 32,
    // --- Exporters ---------------------------------------------------------
    'ned': 28, 'por': 25, 'sco': 25, 'kor': 25, 'aut': 25, 'ecu': 30,
    'uru': 25, 'svk': 25, 'syr': 25, 'bra': 20, 'col': 20, 'sui': 20,
    'aus': 25, 'svn': 20, 'nzl': 15, 'jpn': 18, 'ven': 18, 'fin': 18,
    'bel': 15, 'nir': 18, 'arg': 12, 'swe': 14, 'den': 12, 'srb': 12,
    'cod': 15, 'can': 12, 'nor': 10, 'jam': 8, 'mar': 8, 'alg': 8,
    'irl': 10, 'isl': 6, 'wal': 6, 'cro': 5, 'gha': 5, 'civ': 5,
    'sen': 3, 'nga': 3, 'cmr': 3, 'mli': 3,
  };

  /// A club in the player's own country: one of the curated names where the
  /// country has a modelled league, otherwise a generated domestic side named
  /// for one of its cities. Null when neither is available.
  static ClubSide? _homeClub(
    String code,
    List<String> cities,
    int hash,
    int band,
  ) {
    for (final l in _leagues) {
      if (l.country != code) continue;
      return (name: l.clubs[(hash + band) % l.clubs.length], country: code);
    }
    if (cities.isEmpty) return null;
    // Bias toward the bigger cities (listed first) — a country's clubs cluster
    // in its largest cities rather than spreading evenly over every town.
    final span = cities.length <= 3
        ? cities.length
        : (cities.length * 2 + 2) ~/ 3;
    final city = cities[(hash ~/ 3 + band) % span];
    final suffix = _domesticSuffixes[(hash ~/ 11) % _domesticSuffixes.length];
    return (name: '$city $suffix', country: code);
  }

  /// Generic club-name suffixes for countries with no curated league. Kept
  /// plain and descriptive (never a real club's registered name) so a generated
  /// domestic side reads as a club without impersonating one.
  static const List<String> _domesticSuffixes = [
    'City',
    'United',
    'FC',
    'Athletic',
    'Sporting',
    'Rovers',
    'Union',
    'Dynamo',
    'Olympic',
    'Wanderers',
    'Rangers',
    'Stars',
  ];

  /// Overall → league tier (1 elite … 5 lower). Bands are six wide so a player
  /// only changes tier (and so club) on a real step up or down, not on aging
  /// noise. Public so player development can weight growth by league strength.
  /// The strength tier of the league [country] plays in (1 = elite … 5 =
  /// lower), or the lowest tier for a country with no curated league — a
  /// generated domestic side is a domestic side.
  static int tierOfCountry(String country) =>
      _tierByCountry[country.toLowerCase()] ?? 5;

  static final Map<String, int> _tierByCountry = {
    for (final l in _leagues) l.country: l.tier,
  };

  /// The most a move INTO a league of this tier can plausibly be worth.
  ///
  /// Fees used to be the player's book value times a premium, with no
  /// reference at all to who was paying — so a 90-rated player moving to
  /// Romania was announced at thirty million euros, which is the arithmetic
  /// working exactly as written and nothing like a transfer. What a player is
  /// worth and what a league can pay are two different numbers, and the
  /// smaller one is the fee.
  static int feeCeilingForTier(int tier) => switch (tier) {
    1 => 120000000,
    2 => 45000000,
    3 => 15000000,
    4 => 5000000,
    _ => 2000000,
  };

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

  /// The per-country club database. Every name is a FICTIONAL parody built to
  /// EVOKE a real club without ever using its actual name, badge or wordmark —
  /// typically city + colour (Man Blue, Madrid White), a nickname turned
  /// descriptor (Gladbach Foals, Nantes Canaries), or a gentle pun (West Salami,
  /// Aston Vanilla). Familiar at a glance, trademark-safe on the page.
  static const List<_League> _leagues = [
    // ---- Tier 1: the elite leagues ----------------------------------------
    _League('eng', 1, [
      'Man Blue',
      'Man Red',
      'Mersey Red',
      'Mersey Blue',
      'North London Red',
      'Chelston Blue',
      'White Hart United',
      'Tyneside Magpies',
      'West Salami',
      'Aston Vanilla',
      'Elland Whites',
      'Wolverton Wanderers',
      'Brighton Seagulls',
      'Palace Eagles',
      'Forest Reds',
      'Brentside Bees',
      'Solent Saints',
      'Foxton City',
    ]),
    _League('esp', 1, [
      'Madrid White',
      'FC Catalunya',
      'Madrid Red',
      'Seville Red',
      'Bat City FC',
      'Yellow Submarine FC',
      'Basque Lions',
      'San Sebastián Blue',
      'Seville Green',
      'Vigo Sky Blue',
      'Girona Red-White',
      'Vallecas Lightning',
      'Getafe Blue',
      'Pamplona Red',
      'Catalan Parrots',
      'Balearic Red',
      'Vitoria Blue-White',
      'Cádiz Coast',
    ]),
    _League('ita', 1, [
      'Turin Stripes',
      'Milan Blue',
      'Milan Red',
      'Naples Blue',
      'Rome Wolves',
      'Rome Eagles',
      'Florence Purple',
      'Turin Bulls',
      'Bergamo Black-Blue',
      'Bologna Red-Blue',
      'Udine Black-White',
      'Genoa Griffins',
      'Genoa Blue-Ring',
      'Sassuolo Green-Black',
      'Sardinia Red-Blue',
      'Verona Mastiffs',
      'Monza Red-White',
      'Como Lake FC',
    ]),
    _League('ger', 1, [
      'Munich Red',
      'Dortmund Yellow',
      'Saxony Bulls',
      'Frankfurt Eagles',
      'Wolf City FC',
      'Gladbach Foals',
      'Rhine Red-Black',
      'Swabia White-Red',
      'Bremen Green-White',
      'Hanseatic Diamond',
      'Berlin Iron',
      'Berlin Blue-White',
      'Black Forest FC',
      'Cologne Billy Goats',
      'Mainz Carnival',
      'Fugger City FC',
      'Bochum Blue-White',
      'Heidenheim Red-Blue',
    ]),
    _League('fra', 1, [
      'Paris Blue',
      'Marseille White',
      'Lyon Lions',
      'Monte Carlo FC',
      'Lille Mastiffs',
      'Saint-Green',
      'Nantes Canaries',
      'Nice Eagles',
      'Lens Blood-Gold',
      'Brittany Red',
      'Reims Red-White',
      'Alsace Blue-White',
      'Montpellier Orange-Blue',
      'Toulouse Violets',
      'Gironde Navy',
      'Angers Black-White',
      'Brest Pirates',
      'Burgundy Navy',
    ]),

    // ---- Tier 2: strong leagues -------------------------------------------
    _League('por', 2, [
      'Lisbon Eagles',
      'Porto Dragons',
      'Lisbon Green',
      'Minho Red',
      'Guimarães White-Black',
      'Porto Chequers',
      'Barcelos Red',
      'Famalicão Blue-White',
      'Rio Ave Green-White',
      'Estoril Coast',
    ]),
    _League('ned', 2, [
      'Amsterdam Red-White',
      'Eindhoven Bulbs',
      'Rotterdam Legion',
      'Alkmaar Cheese',
      'Enschede Red',
      'Utrecht Domtower FC',
      'Arnhem Yellow-Black',
      'Frisian Hearts',
      'Groningen Green-White',
      'Nijmegen Red',
    ]),
    _League('bra', 2, [
      'Rio Flamingos',
      'Palm Trees FC',
      'São Paulo Black-White',
      'Tricolor Paulista',
      'Santos Fish',
      'Porto Alegre Blue-Black',
      'Porto Alegre Red',
      'Rio Lone Star',
      'Belo Horizonte Roosters',
      'Minas Foxes',
      'Rio Green-Maroon',
      'Rio Cross',
      'Salvador Blue-Red',
      'Fortaleza Lions',
    ]),
    _League('arg', 2, [
      'Boca Blue-Gold',
      'Millionaires FC',
      'Avellaneda Sky-Blue',
      'Avellaneda Red',
      'Cyclone FC',
      'La Plata Students',
      'Liniers Fortress FC',
      'Rosario Blue-Yellow',
      'Rosario Lepers',
      'La Plata Wolves',
      'Lanús Garnet',
    ]),
    _League('ksa', 2, [
      'Riyadh Crescent',
      'Riyadh Victory',
      'Jeddah Tigers',
      'Jeddah Green',
      'Riyadh White',
      'Dammam Coast',
      'Al Ahsa Purple',
      'Buraidah Orange',
      'Majmaah United',
      'Gulf Coast FC',
    ]),
    _League('usa', 2, [
      'Hollywood Galaxy',
      'Miami Pink',
      'Atlanta Peaches',
      'Emerald City FC',
      'Portland Lumberjacks',
      'New York Bulls',
      'Manhattan Sky Blue',
      'Columbus Yellow',
      'Cincinnati Orange-Blue',
      'Philadelphia Snakes',
      'Nashville Gold',
      'Austin Verde',
    ]),
    _League('tur', 2, [
      'Istanbul Lions',
      'Kadıköy Canaries',
      'Bosphorus Eagles',
      'Black Sea Storm',
      'Istanbul Orange-Navy',
      'Anatolia United',
      'Adana Navy',
      'Konya Green-White',
      'Antalya Coast',
      'Sivas Red-White',
    ]),
    _League('bel', 2, [
      'Brussels Purple',
      'Bruges Blue-Black',
      'Limburg Smurfs',
      'Liège Red',
      'Ghent Buffalos',
      'Antwerp Red-White',
      'Brussels Yellow-Blue',
      'Mechelen Red-Yellow',
      'Charleroi Zebras',
      'Bruges Green',
    ]),
    _League('mex', 2, [
      'Mexico Eagles',
      'Guadalajara Goats',
      'Blue Cross FC',
      'Mexico Pumas',
      'Monterrey Tigers',
      'Monterrey Striped',
      'Toluca Red Devils',
      'Torreón Warriors',
      'León Emeralds',
      'Pachuca Gophers',
      'Tijuana Hounds',
    ]),

    // ---- Tier 3: solid leagues --------------------------------------------
    _League('sco', 3, [
      'Glasgow Green',
      'Glasgow Blue',
      'Granite City FC',
      'Edinburgh Maroon',
      'Edinburgh Green',
      'Tayside Tangerines',
      'Ayrshire Blue-White',
      'Lanarkshire Steel',
    ]),
    _League('gre', 3, [
      'Piraeus Red-White',
      'Athens Shamrock',
      'Athens Eagles',
      'Thessaloniki Black-White',
      'Thessaloniki Yellow',
      'Volos Argonauts',
      'Agrinio Green',
      'Crete Black-White',
    ]),
    _League('jpn', 3, [
      'Saitama Red',
      'Kashima Deer',
      'Yokohama Sailors',
      'Osaka Blue-Black',
      'Kobe Crimson',
      'Nagoya Whales',
      'Osaka Cherry',
      'Hiroshima Arrows',
    ]),
    _League('kor', 3, [
      'Jeonju Motors',
      'Ulsan Tigers',
      'Seoul Red-Black',
      'Pohang Steel',
      'Suwon Blue Wings',
      'Daegu Sky Blue',
      'Incheon Blue',
      'Gangwon Orange',
    ]),
    _League('sui', 3, [
      'Basel Red-Blue',
      'Bern Young Lads',
      'Zürich Blue-White',
      'Geneva Purple',
      'Ticino Black-White',
      'St. Gallen Green-White',
      'Lucerne Blue-White',
      'Zürich Hoppers',
    ]),
    _League('aut', 3, [
      'Salzburg Bulls',
      'Vienna Green-White',
      'Vienna Violets',
      'Graz Storm',
      'Linz Black-White',
      'Wolfsberg White-Black',
      'Tyrol Green',
      'Hartberg Blue',
    ]),
    _League('col', 3, [
      'Medellín Green',
      'Bogotá Blue',
      'Cali Red',
      'Barranquilla Sharks',
      'Cali Green-White',
      'Bogotá Cardinals',
      'Manizales White',
      'Ibagué Gold',
    ]),

    // ---- Tier 4/5: lower leagues (broad base) -----------------------------
    _League('egy', 4, [
      'Cairo Red',
      'Cairo White Knights',
      'Giza Pyramids FC',
      'Ismailia Yellow',
      'Port Said Green',
      'Cairo Ceramic',
    ]),
    _League('rsa', 4, [
      'Soweto Chiefs',
      'Soweto Pirates',
      'Pretoria Brazilians',
      'Tshwane United',
      'Stellenbosch Wine',
      'Limpopo United',
    ]),
    _League('mar', 4, [
      'Casablanca Green',
      'Casablanca Red',
      'Rabat Army FC',
      'Berkane Orange',
      'Rabat Sky Blue',
      'Fès Maroon',
    ]),
    _League('nga', 4, [
      'Aba Elephants',
      'Port Harcourt United',
      'Kano Pillars',
      'Enugu Antelopes',
      'Jos Plateau FC',
      'Sagamu Stars',
    ]),
    _League('aus', 4, [
      'Melbourne Navy',
      'Melbourne Sky Blue',
      'Harbour Sky Blue',
      'Parramatta Wanderers',
      'Adelaide Red',
      'Gosford Mariners',
    ]),
    _League('chn', 5, [
      'Shanghai Harbour Red',
      'Shanghai Blue',
      'Beijing Green',
      'Canton Red',
      'Shandong Orange',
      'Chengdu Phoenix',
    ]),
    _League('ecu', 5, [
      'Guayaquil Yellow',
      'Quito White',
      'Guayaquil Electric',
      'Sangolquí Valley FC',
      'Quito Red-Yellow',
      'Manta Dolphins',
    ]),
    _League('par', 5, [
      'Asunción White',
      'Asunción Red-Blue',
      'Asunción Black-White',
      'Asunción Yellow-Black',
      'Asunción Tricolor',
      'Luque Blue-White',
    ]),
    _League('nor', 5, [
      'Arctic Gold',
      'Molde Blue',
      'Trondheim White',
      'Bergen Red',
      'Stavanger Vikings',
      'Lillestrøm Yellow',
    ]),
    _League('swe', 5, [
      'Malmö Sky Blue',
      'Stockholm Black-Gold',
      'Söder Green',
      'Stockholm Blue-Stripes',
      'Gothenburg Angels',
      'Borås Yellow-Black',
    ]),
    _League('den', 5, [
      'Copenhagen White-Blue',
      'Brøndby Yellow',
      'Jutland Black-Red',
      'Aarhus White-Blue',
      'Farum Tigers',
      'Silkeborg Green',
    ]),
  ];
}
