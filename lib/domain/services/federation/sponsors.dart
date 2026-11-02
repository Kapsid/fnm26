import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:freezed_annotation/freezed_annotation.dart' show immutable;

/// The shape of a sponsor's deal: what it pays and what it costs. Every shape
/// costs something (the board, the dressing room, or both), so signing is a
/// trade-off and never a free gift.
enum SponsorDeal {
  /// The most money there is, and the board, the room and the press all
  /// against it. One to a round.
  risky,

  /// Half as much again as a plain deal; the board would rather not be seen
  /// with it.
  bigPayer,

  /// A modest fee the players love; the board finds it tacky.
  crowdPleaser,

  /// The board loves it; it pays little and the players find it dull.
  familyFriendly,

  /// No cash: it pays for extra Commercial / PR levels for the cycle, and
  /// drags the players to photo shoots.
  marketing,
}

/// The fictional brands that queue up to sponsor the federation, each with a
/// trade and a one-line character (their words live with the copy:
/// `sponsorBrandName`, `sponsorIndustryLabel`, `sponsorFlavour` in
/// core/util/sponsor_label.dart). None is a real company; a few are parodies.
///
/// The enum NAME is the canonical id, stored in a press row (see
/// [Sponsors.pressKey]). The owner's Czech originals read as themselves in
/// Czech and are translated elsewhere: Veselé Hamburgery (Happy Burgers),
/// Agroprd (Agrofart), Havíři (The Miners), Hexagon, and, for Czechia only,
/// Starobahno beer (Oldmire) and Můra petrol stations (Moth).
enum SponsorBrand {
  // Dubious: the most money, the board, the room and the press all against it.
  agrofart(SponsorDeal.risky),
  betBadger(SponsorDeal.risky),
  coinGoblin(SponsorDeal.risky),
  easyPeasy(SponsorDeal.risky),
  vaporia(SponsorDeal.risky),
  goldenFleece(SponsorDeal.risky),

  // Big payers the board would rather not be seen with.
  miners(SponsorDeal.bigPayer),
  moth(SponsorDeal.bigPayer, czechOnly: true),
  sludgeco(SponsorDeal.bigPayer),
  skyloom(SponsorDeal.bigPayer),
  arvella(SponsorDeal.bigPayer),
  cheapoMax(SponsorDeal.bigPayer),
  brickhaven(SponsorDeal.bigPayer),

  // The players love them; the board finds them tacky.
  happyBurgers(SponsorDeal.crowdPleaser),
  oldSwamp(SponsorDeal.crowdPleaser, czechOnly: true),
  buzzhorn(SponsorDeal.crowdPleaser),
  steamy(SponsorDeal.crowdPleaser),
  pixelRage(SponsorDeal.crowdPleaser),
  glitterbox(SponsorDeal.crowdPleaser),

  // The board loves them; they pay little and the players find them dull.
  milkwell(SponsorDeal.familyFriendly),
  herringKing(SponsorDeal.familyFriendly),
  umbrello(SponsorDeal.familyFriendly),
  tidyTeeth(SponsorDeal.familyFriendly),
  woollySocks(SponsorDeal.familyFriendly),
  stackabloc(SponsorDeal.familyFriendly),
  polarPenguin(SponsorDeal.familyFriendly),

  // They fund Commercial / PR and drag the players to photo shoots.
  hexagon(SponsorDeal.marketing),
  velocell(SponsorDeal.marketing),
  parcelion(SponsorDeal.marketing),
  gridwell(SponsorDeal.marketing),
  crownstone(SponsorDeal.marketing),
  clickbait(SponsorDeal.marketing);

  const SponsorBrand(this.deal, {this.czechOnly = false});

  final SponsorDeal deal;

  /// Offered to Czechia only (the owner's Czech in-jokes).
  final bool czechOnly;

  bool get risky => deal == SponsorDeal.risky;

  /// The brand with canonical id [name], or null.
  static SponsorBrand? byName(String name) {
    for (final b in values) {
      if (b.name == name) return b;
    }
    return null;
  }
}

/// One offer of a cycle's sponsor round, with everything it does.
@immutable
class SponsorOffer {
  const SponsorOffer({
    required this.index,
    required this.brand,
    this.euros = 0,
    this.levels = 0,
    this.board = 0,
    this.morale = 0,
  });

  /// Its place in the round: what the marker stores.
  final int index;
  final SponsorBrand brand;

  /// The cash paid on signing: the whole cycle's money, at once.
  final int euros;

  /// The Commercial / PR levels it pays for in the cycle (a marketing deal).
  final int levels;

  /// Board confidence and dressing-room morale for the rest of the cycle, in
  /// points.
  final int board;
  final int morale;

  SponsorDeal get deal => brand.deal;
  bool get risky => brand.risky;

  /// The euros the Commercial / PR department reads on top of its own money.
  int get marketingEuros => levels * FederationFinance.investLevelPrice;

  /// What it costs: a deal always takes something from the board or the
  /// dressing room.
  bool get hasCost => board < 0 || morale < 0;

  @override
  bool operator ==(Object other) =>
      other is SponsorOffer &&
      other.index == index &&
      other.brand == brand &&
      other.euros == euros &&
      other.levels == levels &&
      other.board == board &&
      other.morale == morale;

  @override
  int get hashCode => Object.hash(index, brand, euros, levels, board, morale);

  @override
  String toString() =>
      'SponsorOffer($index, ${brand.name}, €$euros, +$levels lv, '
      'board $board, morale $morale)';
}

/// The general sponsor: once a CYCLE, at its opening (just before the
/// budget), three brands offer a deal each. One may be signed, or none, and
/// the deal runs to the cycle's close.
///
/// The offers are DERIVED from the save's seed, the cycle, the nation and its
/// world place at the cycle's start, so they read the same on every visit and
/// after a restore. Only the choice is stored, as a `draws_watched` marker
/// ([chosenKind] / [declinedKind]); a cycle without one simply had no
/// sponsor, which is every cycle played before this existed.
///
/// A round is keyed by the YEAR its cycle opens in ([roundYear]): 2026, 2030,
/// and so on. The first build offered a round every season (September to
/// August, keyed by the season's year); a save that answered any season of
/// a cycle has answered that cycle ([legacySettlingKinds]).
abstract final class Sponsors {
  /// The marker and press-key prefix.
  static const String prefix = 'sponsor:';

  /// Three offers a cycle.
  static const int offerCount = 3;

  /// The year the game's first cycle opens in.
  static const int firstEverYear = 2026;

  /// The year [cycle] opens in: the key of its round.
  static int roundYear(int cycle) => firstEverYear + 4 * cycle;

  /// The marker for having signed the offer at [index] in the round of
  /// [year] (see [roundYear]).
  static String chosenKind(int year, int index) => '$prefix$year:$index';

  /// The marker for having turned every offer of [year]'s round down.
  static String declinedKind(int year) => '$prefix$year:none';

  /// Every marker that settles a round.
  static List<String> settlingKinds(int year) => [
    for (var i = 0; i < offerCount; i++) chosenKind(year, i),
    declinedKind(year),
  ];

  /// The markers the first, season-by-season build left for the three later
  /// seasons of [cycle]: any one of them means the cycle was answered.
  static List<String> legacySettlingKinds(int cycle) => [
    for (var y = roundYear(cycle) + 1; y < roundYear(cycle) + 4; y++)
      ...settlingKinds(y),
  ];

  /// The press-answer key a signed deal writes its board and morale effect
  /// under: `sponsor:<year>:<brand>`. Stored on its cycle, it counts for that
  /// cycle and ends at its close.
  static String pressKey(int year, SponsorBrand brand) =>
      '$prefix$year:${brand.name}';

  /// The brand named in a [pressKey], or null for any other key.
  static SponsorBrand? brandOfPressKey(String key) {
    final parts = key.split(':');
    if (!key.startsWith(prefix) || parts.length != 3) return null;
    return SponsorBrand.byName(parts[2]);
  }

  /// The tone column of a sponsor's press row.
  static const String pressTone = 'sponsor';

  // --- Sizes ----------------------------------------------------------------

  /// A plain deal's cash at the bottom of the world and at the top of it,
  /// for the whole cycle (two and a half seasons' worth of the first,
  /// season-by-season build). A sweetener, not a second central grant
  /// (€9M to €19M a cycle).
  static const int minMoney = 2500000;
  static const int maxMoney = 10000000;

  /// What a deal's cash is rounded to.
  static const int rounding = 500000;

  /// The place [baseEuros] treats as the bottom of the world.
  static const int bottomRank = 209;

  /// The size of a plain deal for a nation at [worldRank]: €2.5M at the
  /// bottom of the world rising to €10M at the top, priced by ranking
  /// POINTS (the world table is not a straight line, see
  /// [Elo.seedFromRanking]).
  static int baseEuros(int worldRank) {
    final top = Elo.seedFromRanking(1);
    final bottom = Elo.seedFromRanking(bottomRank);
    final s = ((Elo.seedFromRanking(worldRank) - bottom) / (top - bottom))
        .clamp(0.0, 1.0);
    return _round(minMoney + (maxMoney - minMoney) * s);
  }

  static int _round(num euros) => (euros / rounding).round() * rounding;

  /// What [brand]'s deal gives a nation at [worldRank] for the cycle (index
  /// 0; see [offersFor]). The cash is paid at signing; the board and the
  /// room feel it until the cycle's close.
  ///
  /// * risky: twice a plain deal and €2.5M on top (€7.5M to €22.5M); board
  ///   −3, morale −2, and the press mock it on Y;
  /// * bigPayer: one and a half times (€4M to €15M); board −2;
  /// * crowdPleaser: three quarters (€2M to €7.5M); morale +2, board −1;
  /// * familyFriendly: half (€1.5M to €5M); board +2, morale −1;
  /// * marketing: no cash, one Commercial / PR level per million of a plain
  ///   deal plus two (5 to 12 levels, paid back 1.6 times at the cycle's
  ///   close); morale −1.
  static SponsorOffer offerOf(
    SponsorBrand brand,
    int worldRank, {
    int index = 0,
  }) {
    final base = baseEuros(worldRank);
    return switch (brand.deal) {
      SponsorDeal.risky => SponsorOffer(
        index: index,
        brand: brand,
        euros: _round(base * 2 + 2500000),
        board: -3,
        morale: -2,
      ),
      SponsorDeal.bigPayer => SponsorOffer(
        index: index,
        brand: brand,
        euros: _round(base * 1.5),
        board: -2,
      ),
      SponsorDeal.crowdPleaser => SponsorOffer(
        index: index,
        brand: brand,
        euros: _round(base * 0.75).clamp(rounding, maxMoney),
        board: -1,
        morale: 2,
      ),
      SponsorDeal.familyFriendly => SponsorOffer(
        index: index,
        brand: brand,
        euros: _round(base * 0.5).clamp(rounding, maxMoney),
        board: 2,
        morale: -1,
      ),
      SponsorDeal.marketing => SponsorOffer(
        index: index,
        brand: brand,
        levels: (base ~/ FederationFinance.investLevelPrice + 2).clamp(5, 12),
        morale: -1,
      ),
    };
  }

  /// The three brands of [cycle]'s round for the save seeded [seed]: one
  /// risky and two plain ones of different shapes, never a brand offered the
  /// cycle before where the pool has another. Worked out cycle by cycle from
  /// the game's first, so "the cycle before" is always the one this same
  /// rule produced. [czech] puts Czechia's own brands in the pool.
  static List<SponsorBrand> brandsFor({
    required int seed,
    required int cycle,
    required bool czech,
  }) {
    final pool = [
      for (final b in SponsorBrand.values)
        if (!b.czechOnly || czech) b,
    ];
    var last = const <SponsorBrand>{};
    var picks = const <SponsorBrand>[];
    for (var c = 0; c <= cycle; c++) {
      // Seeded by the round's year, as the first build seeded its seasons:
      // the first cycle's round is the brands that build offered first.
      final y = roundYear(c);
      final rng = SeededRng(seed ^ ((y + 1) * 0x5BD1E995) ^ 0x5905C0);
      final fresh = [
        for (final b in pool)
          if (!last.contains(b)) b,
      ];
      final shapes = rng.shuffled([
        for (final d in SponsorDeal.values)
          if (d != SponsorDeal.risky) d,
      ]);
      SponsorBrand pick(SponsorDeal d) {
        final options = fresh.where((b) => b.deal == d).toList();
        return rng.pick(
          options.isEmpty ? pool.where((b) => b.deal == d).toList() : options,
        );
      }

      final risky = pick(SponsorDeal.risky);
      final plain = [pick(shapes[0]), pick(shapes[1])];
      // The risky one takes a seeded place among the three.
      picks = [...plain]..insert(rng.nextInt(offerCount), risky);
      last = picks.toSet();
    }
    return picks;
  }

  /// The round offered to a nation ([nationCode], so the Czech brands find
  /// Czechia) in [cycle] of the save seeded [seed], sized by its [worldRank]
  /// at the cycle's start.
  static List<SponsorOffer> offersFor({
    required int seed,
    required int cycle,
    required String nationCode,
    required int worldRank,
  }) {
    final brands = brandsFor(
      seed: seed,
      cycle: cycle,
      czech: nationCode == 'CZE',
    );
    return [
      for (var i = 0; i < brands.length; i++)
        offerOf(brands[i], worldRank, index: i),
    ];
  }
}
