import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/achievements/achievements.dart'
    show worldCupHonourName;
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// THE seam for a nation's stadiums in a career: every ground it could stage
/// a tournament in, biggest first.
///
/// The static data (the seed cities, the extra host cities, and the
/// capacities tapered from the national stadium; see [VenueGenerator]) with
/// whatever the career has done to them: upgraded grounds hold more, and a
/// stadium the federation built joins the list once it opens (see
/// [careerStadiumsFor]). A nation nobody worked on, which is every AI
/// nation, keeps exactly the static list. [HostBidOdds.sizeScore] reads only
/// what this returns, so the host-bid chance follows the works.
///
/// [atCycle] reads them as they will stand in that cycle (a stadium under
/// construction counts once it opens); the current cycle by default.
Future<List<Venue>> nationStadiumsFor(
  Ref ref,
  int careerId,
  int nationId, {
  int? atCycle,
}) async => [
  for (final s in await careerStadiumsFor(
    ref,
    careerId,
    nationId,
    atCycle: atCycle,
  ))
    s.venue,
];

/// [nationStadiumsFor] as a provider, for screens.
final AutoDisposeFutureProviderFamily<
  List<Venue>,
  ({int careerId, int nationId})
>
nationStadiumsProvider = FutureProvider.autoDispose
    .family<List<Venue>, ({int careerId, int nationId})>(
      (ref, arg) => nationStadiumsFor(ref, arg.careerId, arg.nationId),
    );

/// A bid the manager may lodge now: one edition of one tournament.
class HostBidOffer {
  const HostBidOffer({
    required this.careerId,
    required this.comp,
    required this.editionCycle,
    required this.year,
    required this.nation,
    required this.size,
    required this.today,
    required this.freeFunds,
  });

  final int careerId;
  final HostBidComp comp;

  /// The cycle the edition belongs to: the one about to begin (the current
  /// cycle + 1, offered once the current one is over), whose hosts nothing
  /// has used yet. The rollover settles the bid before it builds that
  /// cycle's calendar.
  final int editionCycle;

  /// The edition's year (the finals' summer).
  final int year;

  /// The bidding nation: the one the manager takes into the new cycle.
  final Nation nation;

  /// [HostBidOdds.sizeScore] of its stadiums.
  final double size;

  /// Its chance in the ordinary draw, before any bid.
  final double today;

  /// What the federation will have free once the rollover has banked the
  /// closing cycle (see [rolloverMoney]), less the wages owed and any bid
  /// already pledged.
  final int freeFunds;

  /// The most levels the funds and the model allow.
  int get maxLevels {
    final affordable = freeFunds ~/ HostBidOdds.levelPrice;
    return affordable < HostBidOdds.maxLevels
        ? affordable
        : HostBidOdds.maxLevels;
  }

  HostBidQuote quote(int levels) =>
      HostBidOdds.quote(size: size, today: today, levels: levels);

  /// The canonical stored competition name, for the news.
  String get storedName => _storedName(comp, nation.confederation);
}

/// Where one tournament's bid stands for a career: what its next edition
/// needs, what the nation lacks, and the offer itself once the window is open.
class HostBidStatus {
  const HostBidStatus({
    required this.comp,
    required this.editionCycle,
    required this.year,
    required this.nation,
    required this.requirement,
    required this.shortfall,
    required this.barredConfederation,
    required this.recentHost,
    required this.lodged,
    required this.declined,
    required this.windowOpen,
    required this.offer,
  });

  final HostBidComp comp;
  final int editionCycle;
  final int year;

  /// The nation that would bid.
  final Nation nation;

  /// What the edition asks of a host's grounds.
  final HostingRequirement requirement;

  /// What the nation's grounds lack against [requirement].
  final HostingShortfall shortfall;

  /// The nation's confederation, when it hosted the previous World
  /// Championship (the rotation bars it). Always null for a continental bid.
  final Confederation? barredConfederation;

  /// It hosted one of the last three editions.
  final bool recentHost;

  /// A bid for this edition is already in (pledged, paid or decided).
  final bool lodged;

  /// The offer was turned down.
  final bool declined;

  /// The cycle is over and the bid can be made now (before the rollover).
  final bool windowOpen;

  /// The bid open now, or null.
  final HostBidOffer? offer;

  /// The grounds are big enough.
  bool get estateOk => shortfall.grounds == 0 && shortfall.bigGrounds == 0;

  /// No rotation rule bars the nation.
  bool get rulesOk => barredConfederation == null && !recentHost;

  /// The nation may bid for this edition.
  bool get eligible => estateOk && rulesOk;
}

/// The canonical STORED (English) name of [comp], an identifier the news
/// carries and `competitionLabel` translates when it is read; never printed
/// as it stands.
String _storedName(HostBidComp comp, Confederation confederation) {
  if (comp == HostBidComp.worldChampionship) return worldCupHonourName;
  return ContinentalCups.byConfederation[confederation]?.name ??
      _continentalFallback;
}

/// The stored generic name `competitionLabel` knows, for a confederation with
/// no championship of its own (there is none today).
const String _continentalFallback = 'Continental Championship';

/// Whether [kinds] (one career's host-bid markers) already settle [nationId]'s
/// [comp] offer for [editionCycle]: a bid of that nation lodged or pledged,
/// the offer turned down by it (or by an old marker that names no nation),
/// or a pledge that lapsed.
///
/// Per nation: the bid is made for the nation the manager takes into the new
/// cycle, which he may change on the rollover screen, and a pledge made for
/// one nation must not read as "lodged" on another's card.
bool _settled(
  List<String> kinds,
  HostBidComp comp,
  int editionCycle,
  int nationId,
) {
  if (kinds.contains(HostBidding.declinedKind(comp, editionCycle)) ||
      kinds.contains(
        HostBidding.declinedKind(comp, editionCycle, nationId: nationId),
      ) ||
      kinds.contains(HostBidding.lapsedKind(comp, editionCycle))) {
    return true;
  }
  return _lodged(kinds, comp, editionCycle, nationId);
}

/// Whether [nationId] has a bid for [comp]'s [editionCycle] in: paid, or
/// pledged.
bool _lodged(
  List<String> kinds,
  HostBidComp comp,
  int editionCycle,
  int nationId,
) {
  for (final k in kinds) {
    final m = HostBidMarker.decode(k) ?? HostBidMarker.decodePledge(k);
    if (m != null &&
        m.comp == comp &&
        m.editionCycle == editionCycle &&
        m.nationId == nationId) {
      return true;
    }
  }
  return false;
}

/// Whether [nationId] turned [comp]'s [editionCycle] offer down (an old
/// marker naming no nation counts for every nation).
bool _declined(
  List<String> kinds,
  HostBidComp comp,
  int editionCycle,
  int nationId,
) =>
    kinds.contains(HostBidding.declinedKind(comp, editionCycle)) ||
    kinds.contains(
      HostBidding.declinedKind(comp, editionCycle, nationId: nationId),
    );

/// The euros [nationId] has pledged for [editionCycle] and not yet paid. A
/// pledge for another nation is not counted: it lapses at the rollover.
int _pledged(List<String> kinds, int editionCycle, int nationId) {
  var euros = 0;
  for (final k in kinds) {
    final m = HostBidMarker.decodePledge(k);
    if (m != null && m.editionCycle == editionCycle && m.nationId == nationId) {
      euros += m.invested;
    }
  }
  return euros;
}

/// Every host-bid marker kind [careerId] carries (bids, pledges, results,
/// declines).
Future<List<String>> hostBidKinds(
  CompetitionRepository comp,
  int careerId,
) async => [
  for (final r in await comp.watchedKindsWithPrefix('hostBid'))
    if (r.careerId == careerId) r.kind,
];

/// The money the rollover banks for [career], worked out as the rollover
/// does it (it calls this): the closing cycle's income with the manager's
/// negotiating bonus, less the staff wages, plus what the stadiums of the
/// nation managed through it earn at the new cycle's start.
///
/// [balance] is what the new cycle opens with before any bid or
/// investment; [wages] the bill that will be owed again; [stadiumIncome]
/// the stadiums' part of [balance].
Future<({int balance, int wages, int stadiumIncome})> rolloverMoney(
  Ref ref,
  Career career,
) async {
  final income = await ref
      .read(federationServiceProvider)
      .incomeForCycle(career.id, career.cyclePointer);
  final negotiated =
      ((income.grant + income.prize + income.commercial) *
              ManagerSkills.incomeBonus(career.skillNegotiation))
          .round();
  final wages = Staff.totalCost({
    StaffRole.assistant: career.staffAssistant,
    StaffRole.scout: career.staffScout,
    StaffRole.fitnessCoach: career.staffFitnessCoach,
  });
  var balance = career.budget + negotiated - wages;
  if (balance < 0) balance = 0;
  final stadiumIncome = await ref
      .read(nationalStadiumServiceProvider)
      .incomeAt(career.id, career.nationId, career.cyclePointer + 1);
  return (
    balance: balance + stadiumIncome,
    wages: wages,
    stadiumIncome: stadiumIncome,
  );
}

/// [rolloverMoney] for [careerId]'s current state, for the rollover screen.
final AutoDisposeFutureProviderFamily<
  ({int balance, int wages, int stadiumIncome})?,
  int
>
rolloverMoneyProvider = FutureProvider.autoDispose
    .family<({int balance, int wages, int stadiumIncome})?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      return rolloverMoney(ref, career);
    });

/// Which career, and which nation's bid: the nation the manager takes into
/// the next cycle (an offer picked at the rollover), or null for the one he
/// manages now.
typedef HostBidArg = ({int careerId, int? nationId});

/// Where each bid stands for a career, continental first: the editions of
/// the cycle after the current one.
///
/// The window is the close of a cycle: once its World Championship is
/// decided, on the rollover screen, before the new cycle is built. The bid
/// is for the cycle about to begin, and the rollover settles it before
/// anything reads that cycle's hosts (see `SeasonRollover`). Earlier in the
/// cycle the same statuses say what the nation must fix before the window
/// opens (grounds, the rotation), which is what the budget screen shows.
///
/// Empty in a campaign run (hosting skips qualifying, so a bid would buy the
/// campaign's "qualify" stars outright) and in a free save that cannot roll
/// on; a run moved into the saves is an ordinary career.
final AutoDisposeFutureProviderFamily<List<HostBidStatus>, HostBidArg>
hostBidStatusProvider = FutureProvider.autoDispose
    .family<List<HostBidStatus>, HostBidArg>((ref, arg) async {
      final careerId = arg.careerId;
      final careers = ref.watch(careerRepositoryProvider);
      final comp = ref.watch(competitionRepositoryProvider);
      final career = await careers.byId(careerId);
      if (career == null) return const [];
      final cycle = career.cyclePointer;
      if (trialExhausted(
        cyclePointer: cycle,
        premiumUnlocked: ref.watch(premiumUnlockedProvider),
      )) {
        return const [];
      }
      final tag = (await campaignTags(comp))[careerId];
      if (tag != null && !tag.moved) return const [];
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      final nationId = arg.nationId ?? career.nationId;
      Nation? me;
      for (final n in nations) {
        if (n.id == nationId) me = n;
      }
      if (me == null) return const [];
      final windowOpen = await comp.worldChampion(careerId) != null;
      final kinds = await hostBidKinds(comp, careerId);
      // The grounds as they will stand for the edition: a stadium ordered
      // this cycle opens at the start of the next, in time for its finals.
      final edition = cycle + 1;
      final stadiums = await nationalSetFor(
        ref,
        careerId,
        me.id,
        atCycle: edition,
      );
      final seats = [for (final s in stadiums) s.capacity];
      final size = HostBidOdds.sizeScore(
        await nationStadiumsFor(ref, careerId, me.id, atCycle: edition),
      );
      var funds = 0;
      if (windowOpen) {
        final money = await rolloverMoney(ref, career);
        funds = money.balance - money.wages - _pledged(kinds, edition, me.id);
        if (funds < 0) funds = 0;
      }
      final statuses = <HostBidStatus>[];

      HostBidStatus status({
        required HostBidComp c,
        required int year,
        required ({bool eligible, double today}) standing,
        Confederation? barred,
        required bool recent,
      }) {
        final req = HostingRequirements.of(c, me!.confederation);
        final short = HostingRequirements.shortfall(seats, req);
        final lodged = _lodged(kinds, c, edition, me.id);
        final settled = _settled(kinds, c, edition, me.id);
        final ok =
            short.grounds == 0 && short.bigGrounds == 0 && standing.eligible;
        return HostBidStatus(
          comp: c,
          editionCycle: edition,
          year: year,
          nation: me,
          requirement: req,
          shortfall: short,
          barredConfederation: barred,
          recentHost: recent,
          lodged: lodged,
          declined: _declined(kinds, c, edition, me.id),
          windowOpen: windowOpen,
          offer: windowOpen && ok && !settled && funds >= HostBidOdds.levelPrice
              ? HostBidOffer(
                  careerId: careerId,
                  comp: c,
                  editionCycle: edition,
                  year: year,
                  nation: me,
                  size: size,
                  today: standing.today,
                  freeFunds: funds,
                )
              : null,
        );
      }

      if (ContinentalCups.byConfederation[me.confederation] != null) {
        final standing = WorldCupHosts.continentalBidStanding(
          confederation: me.confederation,
          cycle: edition,
          seed: career.rngSeed,
          nations: nations,
          nationId: me.id,
        );
        statuses.add(
          status(
            c: HostBidComp.continental,
            year: CareerService.continentalFinalsYear(edition),
            standing: (eligible: standing.eligible, today: standing.today),
            recent: standing.recentHost,
          ),
        );
      }
      final year = CareerService.worldCupYear(edition);
      final wc = WorldCupHosts.worldCupBidStanding(
        year: year,
        nations: nations,
        seed: career.rngSeed,
        nationId: me.id,
      );
      statuses.add(
        status(
          c: HostBidComp.worldChampionship,
          year: year,
          standing: (eligible: wc.eligible, today: wc.today),
          barred: wc.barredConfederation,
          recent: wc.recentHost,
        ),
      );
      return statuses;
    });

/// The bids open to a career right now, continental first: the open offers
/// of [hostBidStatusProvider].
final AutoDisposeFutureProviderFamily<List<HostBidOffer>, HostBidArg>
hostBidOffersProvider = FutureProvider.autoDispose
    .family<List<HostBidOffer>, HostBidArg>((ref, arg) async {
      final statuses = await ref.watch(hostBidStatusProvider(arg).future);
      return [
        for (final s in statuses)
          if (s.offer != null) s.offer!,
      ];
    });

/// The offer for one tournament, for the bid screen (null once settled).
final AutoDisposeFutureProviderFamily<
  HostBidOffer?,
  ({int careerId, int? nationId, HostBidComp comp})
>
hostBidOfferProvider = FutureProvider.autoDispose
    .family<HostBidOffer?, ({int careerId, int? nationId, HostBidComp comp})>((
      ref,
      arg,
    ) async {
      final offers = await ref.watch(
        hostBidOffersProvider((
          careerId: arg.careerId,
          nationId: arg.nationId,
        )).future,
      );
      for (final o in offers) {
        if (o.comp == arg.comp) return o;
      }
      return null;
    });

/// The tournament [offer] is for, written for the manager.
String hostBidCompLabel(AppLocalizations l, HostBidOffer offer) =>
    switch (offer.comp) {
      HostBidComp.worldChampionship => l.compWorldCup,
      HostBidComp.continental => continentalCupLabel(
        l,
        offer.nation.confederation,
      ),
    };

/// Where the hub sends the manager for [offer].
String hostBidRoute(HostBidOffer offer) =>
    '${Routes.hostBid}?careerId=${offer.careerId}&comp=${offer.comp.code}'
    '&nation=${offer.nation.id}';

/// Lodging, declining and deciding host bids.
class HostBidService {
  HostBidService(this._ref);

  final Ref _ref;

  /// Pledges [offer] at [levels]. Nothing is paid yet: the rollover pays the
  /// pledge out of the money it banks and turns it into the bid itself, in
  /// the same transaction (see [settlePledges]), then decides it before it
  /// builds the new cycle. The marker freezes the chance shown.
  ///
  /// The rules are read again INSIDE the transaction: the cycle is still
  /// over and not yet rolled, the offer is still open (a double tap never
  /// pledges twice), and every pledge together fits what the federation will
  /// have free after the rollover (balance, income and stadium income, less
  /// the wages), so the rollover can always pay.
  Future<bool> place(HostBidOffer offer, int levels) async {
    if (levels < 1 || levels > offer.maxLevels) return false;
    final careers = _ref.read(careerRepositoryProvider);
    final comp = _ref.read(competitionRepositoryProvider);
    final careerId = offer.careerId;
    final cost = levels * HostBidOdds.levelPrice;
    final marker = HostBidMarker(
      comp: offer.comp,
      editionCycle: offer.editionCycle,
      nationId: offer.nation.id,
      levels: levels,
      permille: HostBidOdds.permilleOf(offer.quote(levels)),
    );
    final before = await careers.byId(careerId);
    if (before == null) return false;
    final money = await rolloverMoney(_ref, before);
    var pledged = false;
    await _ref.read(appDatabaseProvider).transaction(() async {
      final career = await careers.byId(careerId);
      if (career == null) return;
      if (career.cyclePointer != before.cyclePointer ||
          career.budget != before.budget) {
        return;
      }
      if (offer.editionCycle != career.cyclePointer + 1) return;
      if (await comp.worldChampion(careerId) == null) return;
      final kinds = await hostBidKinds(comp, careerId);
      if (_settled(kinds, offer.comp, offer.editionCycle, offer.nation.id)) {
        return;
      }
      final free =
          money.balance -
          money.wages -
          _pledged(kinds, offer.editionCycle, offer.nation.id);
      if (free < cost) return;
      await comp.markDrawWatched(
        careerId,
        offer.editionCycle,
        marker.encodePledge(),
      );
      pledged = true;
    });
    _invalidate(careerId);
    return pledged;
  }

  /// Turns [offer] down; it is not asked again.
  Future<void> decline(HostBidOffer offer) async {
    await _ref
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          offer.careerId,
          offer.editionCycle,
          HostBidding.declinedKind(
            offer.comp,
            offer.editionCycle,
            nationId: offer.nation.id,
          ),
        );
    _invalidate(offer.careerId);
  }

  /// Pays the pledges for [editionCycle] out of [budget] (the balance the
  /// rollover has just banked) and lodges each as the bid the host draw
  /// reads. Called INSIDE the rollover's banking transaction, which its
  /// `cycleBanked` marker runs once, so a pledge is paid exactly once.
  ///
  /// A pledge stands only for [nationId], the nation the manager takes into
  /// the new cycle: one made for a nation he then left lapses unpaid, as
  /// does one the money no longer covers (the staff changed after it was
  /// made). A lapsed pledge leaves a `hostBidLapsed` marker, so the offer is
  /// not made again. Returns the balance left.
  Future<int> settlePledges(
    int careerId, {
    required int editionCycle,
    required int nationId,
    required int budget,
    required int wages,
    required int year,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final kinds = await hostBidKinds(comp, careerId);
    final pledges = [
      for (final k in kinds)
        if (HostBidMarker.decodePledge(k) case final m?
            when m.editionCycle == editionCycle)
          m,
    ]..sort((a, b) => a.comp.index.compareTo(b.comp.index));
    if (pledges.isEmpty) return budget;
    final nations = {
      for (final n
          in await _ref.read(nationRepositoryProvider).forCareer(careerId))
        n.id: n,
    };
    final l = _ref.read(appLocalizationsProvider);
    var left = budget;
    for (final p in pledges) {
      // A bid already paid for this edition (an old save's) stands alone.
      final paid = kinds.any((k) {
        final m = HostBidMarker.decode(k);
        return m != null && m.comp == p.comp && m.editionCycle == editionCycle;
      });
      final otherNation = paid || p.nationId != nationId;
      if (otherNation || left - wages < p.invested) {
        await comp.markDrawWatched(
          careerId,
          editionCycle,
          HostBidding.lapsedKind(p.comp, editionCycle),
        );
        // Said, so a manager who pledged never believes a bid stands that
        // does not. Nothing was charged.
        final bidder = nations[p.nationId];
        final compPart = MsgComp(
          _storedName(
            p.comp,
            bidder?.confederation ?? Confederation.europe,
          ),
        );
        final editionYear = p.comp == HostBidComp.worldChampionship
            ? CareerService.worldCupYear(editionCycle)
            : CareerService.continentalFinalsYear(editionCycle);
        await comp.addTextMessage(
          l: l,
          careerId: careerId,
          dedupKey: 'hostBidLapsed:${p.comp.code}:$editionCycle:${p.nationId}',
          category: 'draw',
          title: MsgText(MsgKey.hostBidLapsedTitle, [compPart, editionYear]),
          body: otherNation
              ? MsgText(MsgKey.hostBidLapsedBodyNation, [
                  bidder?.name ?? l.msgAHostNation,
                ])
              : const MsgText(MsgKey.hostBidLapsedBodyFunds),
          year: year,
        );
        continue;
      }
      await comp.markDrawWatched(careerId, editionCycle, p.encode());
      left -= p.invested;
    }
    return left;
  }

  void _invalidate(int careerId) {
    _ref
      ..invalidate(hostBidStatusProvider)
      ..invalidate(hostBidOffersProvider)
      ..invalidate(hostBidOfferProvider)
      ..invalidate(federationFundsProvider(careerId))
      ..invalidate(financeViewProvider(careerId))
      // The world now carries the bid (or its outcome): anything holding the
      // career's nations must read them again.
      ..invalidate(careerNationsProvider(careerId))
      ..invalidate(careerNationsByIdProvider(careerId))
      ..invalidate(hostBidGrantProvider(careerId))
      // The stadium page shows the same free funds.
      ..invalidate(nationalStadiumsViewProvider(careerId));
  }

  /// Decides every bid of [careerId] that is due and not yet decided: once
  /// the in-game date reaches [HostBidding.decisionDate] of the cycle the bid
  /// was lodged in, or unconditionally when [atRollover] (the cycle is ending,
  /// so nothing may be left hanging). Returns whether anything was decided.
  ///
  /// The outcome is NOT drawn here: the host of the edition is whatever the
  /// host draw says (`WorldCupHosts`, which reads the bid off the nation), so
  /// the news, the ceremony and the calendar can never disagree. This only
  /// files the news and pays the grant, exactly once (the result marker).
  Future<bool> resolveDue(int careerId, {bool atRollover = false}) {
    // One at a time: a call that arrives while another is deciding waits for
    // it, then finds the bid settled (see the transaction in [_decide]).
    final run = _resolving.then(
      (_) => _resolveDue(careerId, atRollover: atRollover),
    );
    _resolving = run.then((_) {}, onError: (_) {});
    return run;
  }

  Future<void> _resolving = Future<void>.value();

  Future<bool> _resolveDue(int careerId, {bool atRollover = false}) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final kinds = await hostBidKinds(comp, careerId);
    final bids = [for (final k in kinds) ?HostBidMarker.decode(k)];
    if (bids.isEmpty) return false;
    final careers = _ref.read(careerRepositoryProvider);
    final career = await careers.byId(careerId);
    if (career == null) return false;
    final decided = <(HostBidComp, int)>{
      for (final k in kinds)
        if (HostBidding.decodeResult(k) case final r?) (r.comp, r.editionCycle),
    };
    final due = [
      for (final b in bids)
        if (!decided.contains((b.comp, b.editionCycle)) &&
            b.editionCycle <= career.cyclePointer + 1 &&
            (atRollover || _isDue(career, b)))
          b,
    ];
    if (due.isEmpty) return false;
    final nations = await _ref
        .read(nationRepositoryProvider)
        .forCareer(careerId);
    final l = _ref.read(appLocalizationsProvider);
    for (final b in due) {
      await _decide(comp, l, careerId, b, nations, atRollover: atRollover);
    }
    _invalidate(careerId);
    return true;
  }

  /// Whether [bid]'s decision date has come. Only an old bid (lodged at the
  /// opening of cycle c, for edition c + 1, by the first 1.0.7 builds) is
  /// decided early, in January after cycle c opened, as it was promised. A
  /// bid made today is a pledge until the rollover, which lodges and decides
  /// it in one go.
  static bool _isDue(Career career, HostBidMarker bid) {
    final lodgedIn = bid.editionCycle - 1;
    if (lodgedIn < career.cyclePointer) return true;
    final opens = CareerService.cycleOpens(lodgedIn);
    return !career.inGameDate.isBefore(HostBidding.decisionDate(opens.year));
  }

  Future<void> _decide(
    CompetitionRepository comp,
    AppLocalizations l,
    int careerId,
    HostBidMarker bid,
    List<Nation> nations, {
    required bool atRollover,
  }) async {
    Nation? bidder;
    for (final n in nations) {
      if (n.id == bid.nationId) bidder = n;
    }
    if (bidder == null) return;
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final List<int> hosts;
    final int year;
    switch (bid.comp) {
      case HostBidComp.worldChampionship:
        year = CareerService.worldCupYear(bid.editionCycle);
        hosts = WorldCupHosts.hostsFor(
          year: year,
          nations: nations,
          seed: career.rngSeed,
        );
      case HostBidComp.continental:
        year = CareerService.continentalFinalsYear(bid.editionCycle);
        hosts = WorldCupHosts.continentalHostsFor(
          confederation: bidder.confederation,
          cycle: bid.editionCycle,
          seed: career.rngSeed,
          nations: nations,
        );
    }
    final won = hosts.contains(bid.nationId);
    final bonus = won ? HostBidOdds.bonusFor(bid.levels) : 0;
    final resultKind = HostBidding.resultKind(
      bid.comp,
      bid.editionCycle,
      won: won,
      bonus: bonus,
    );
    // The result marker, the grant and the grant's "to assign" marker land
    // together or not at all, and the marker is re-checked INSIDE the
    // transaction: two overlapping calls can both have read "undecided", but
    // only the first to commit pays.
    var paid = false;
    await _ref.read(appDatabaseProvider).transaction(() async {
      if (await comp.hasWatchedDraw(careerId, bid.editionCycle, resultKind)) {
        return;
      }
      await comp.markDrawWatched(careerId, bid.editionCycle, resultKind);
      if (bonus > 0) {
        final careers = _ref.read(careerRepositoryProvider);
        final fresh = await careers.byId(careerId);
        if (fresh == null) return;
        await careers.setBudget(careerId, fresh.budget + bonus);
        await comp.markDrawWatched(
          careerId,
          fresh.cyclePointer,
          HostBidding.grantOpenKind(bid.comp, bid.editionCycle, bonus),
        );
      }
      paid = true;
    });
    if (!paid) return;
    final byId = {for (final n in nations) n.id: n};
    final hostNames = [
      for (final h in hosts) byId[h]?.name ?? l.msgAHostNation,
    ].join(' & ');
    final compPart = MsgComp(_storedName(bid.comp, bidder.confederation));
    await comp.addTextMessage(
      l: l,
      careerId: careerId,
      dedupKey: 'hostBid:${bid.comp.code}:${bid.editionCycle}',
      category: 'draw',
      title: won
          ? MsgText(MsgKey.hostBidWonTitle, [compPart, year])
          : MsgText(MsgKey.hostBidLostTitle, [compPart, year]),
      body: won
          ? MsgText(
              // Decided in the rollover, the grant is in the money the new
              // budget splits; an old bid decided in January opened the
              // hub's grant event instead.
              atRollover ? MsgKey.hostBidWonBodyBudget : MsgKey.hostBidWonBody,
              [formatEuros(bonus)],
            )
          : MsgText(MsgKey.hostBidLostBody, [hostNames]),
      year: career.inGameDate.year,
    );
  }
}

final Provider<HostBidService> hostBidServiceProvider =
    Provider<HostBidService>(HostBidService.new);

/// A won bid's grant still waiting to be assigned this cycle: its euros, and
/// the cycle's allocation it adds to. Null when there is none. The grant is
/// in the balance from the moment it lands; this only says it has not been
/// put to work yet (see the budget screen's grant mode).
typedef HostBidGrant = ({int amount, int cycle});

final AutoDisposeFutureProviderFamily<HostBidGrant?, int>
hostBidGrantProvider = FutureProvider.autoDispose.family<HostBidGrant?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final cycle = career.cyclePointer;
  if (await comp.hasWatchedDraw(careerId, cycle, HostBidding.grantDoneKind)) {
    return null;
  }
  var amount = 0;
  for (final r in await comp.watchedKindsWithPrefix(HostBidding.grantPrefix)) {
    if (r.careerId != careerId) continue;
    final g = HostBidding.decodeGrantOpen(r.kind);
    // A bid lodged in this cycle (its edition is the next one). A grant
    // that landed at the rollover is simply in the bank for the next budget.
    if (g != null && g.editionCycle == cycle + 1) amount += g.euros;
  }
  if (amount <= 0) return null;
  return (amount: amount, cycle: cycle);
});
