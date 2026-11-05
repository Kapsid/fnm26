import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

/// A cycle's sponsor round: the three offers, and what was done about them.
typedef SponsorRound = ({
  int cycle,

  /// The year the cycle opens in: the round's key (see [Sponsors.roundYear]).
  int year,
  List<SponsorOffer> offers,

  /// The deal signed this cycle, or null (none yet, or turned down).
  SponsorOffer? chosen,

  /// Whether the round is settled: an offer signed or every one declined.
  bool decided,
});

/// [career]'s sponsor round for [cycle] (its current one by default), or null
/// where there is none: an unmoved campaign run (a challenge is played on the
/// money it was set, as it gets no host bids either) or a career whose nation
/// cannot be found.
///
/// Derived from the save's seed, the cycle, the nation and its world place at
/// the cycle's START (the frozen seed ranking, or the career's starting
/// ranking in cycle 0), so it reads the same on every visit. Only the choice
/// is stored, as a marker on the cycle (see [Sponsors]).
///
/// A save of the first, season-by-season build that answered any season of
/// the cycle has answered it: never asked twice. Its deal is read back off
/// the press row signing left (every deal has one, as every deal costs the
/// board or the room).
///
/// The brands are the game's own plus the sponsors the career's OWN copy of
/// its world added ([careerSponsorsOf]): never the world on screen, since
/// the offers move money, and never the pack on the device, which may have
/// been edited or deleted since.
///
/// The nation is the one the career holds now: the rollover changes nation
/// before the cycle that follows, so for the current cycle it is always the
/// right one. A past cycle is read the way its income is (see
/// `FederationService.incomeForCycle`).
Future<SponsorRound?> sponsorRoundOf({
  required CompetitionRepository comp,
  required NationRepository nations,
  required SeedRankingRepository seedRanks,
  required CareerRepository careers,
  required WorldPackRepository worlds,
  required Career career,
  int? cycle,
}) async {
  final c = cycle ?? career.cyclePointer;
  final year = Sponsors.roundYear(c);
  final tag = (await campaignTags(comp))[career.id];
  if (tag != null && !tag.moved) return null;
  final world = await nations.forCareer(career.id);
  final me = world.where((n) => n.id == career.nationId).firstOrNull;
  if (me == null) return null;
  final rank = (await seedRanks.forCycle(career.id, c))[me.id] ?? me.ranking;
  final extra = await careerSponsorsOf(worlds, career.id);
  final offers = Sponsors.offersFor(
    seed: career.rngSeed,
    cycle: c,
    nationCode: me.code,
    worldRank: rank,
    extra: extra,
  );
  SponsorOffer? chosen;
  var decided = false;
  for (final o in offers) {
    if (await comp.hasWatchedDraw(
      career.id,
      c,
      Sponsors.chosenKind(year, o.index),
    )) {
      chosen = o;
      decided = true;
      break;
    }
  }
  if (!decided) {
    decided = await comp.hasWatchedDraw(
      career.id,
      c,
      Sponsors.declinedKind(year),
    );
  }
  if (!decided) {
    for (final kind in Sponsors.legacySettlingKinds(c)) {
      if (await comp.hasWatchedDraw(career.id, c, kind)) {
        decided = true;
        break;
      }
    }
  }
  if (decided && chosen == null) {
    // A season's deal of the first build, signed after the cycle's round was
    // declined or in a later season: the press row names it.
    for (final a in await careers.pressAnswers(career.id, cycle: c)) {
      final brand = Sponsors.brandOfPressKey(a.questionKey, extra: extra);
      if (brand == null) continue;
      chosen = Sponsors.offerOf(
        brand,
        rank,
        index: offers.indexWhere((o) => o.brand == brand),
      );
      break;
    }
  }
  return (
    cycle: c,
    year: year,
    offers: offers,
    chosen: chosen,
    decided: decided,
  );
}

/// The sponsors career [careerId]'s own world added, as offered alongside
/// the game's brands; none for a default-world career.
///
/// For the money (the round, signing, the cycle's income): a world that
/// cannot be read throws, since guessing would point a signed marker at
/// another brand. Display reads take [careerSponsorsForDisplay].
Future<List<Sponsor>> careerSponsorsOf(
  WorldPackRepository worlds,
  int careerId,
) async {
  final added = await worlds.addedSponsorsFor(careerId);
  return [
    for (final s in added.sponsors) Sponsor.added(s, world: added.world),
  ];
}

/// [careerSponsorsOf] for what only DISPLAYS a sponsor (the Y feed's
/// sponsor story): a world that cannot be read is reported and reads as
/// adding none, so the feed still builds.
Future<List<Sponsor>> careerSponsorsForDisplay(
  WorldPackRepository worlds,
  int careerId,
) async {
  try {
    return await careerSponsorsOf(worlds, careerId);
  } on Object catch (e, st) {
    _report(e, st, 'reading the sponsors of career $careerId for display');
    return const [];
  }
}

void _report(Object e, StackTrace st, String doing) => FlutterError.reportError(
  FlutterErrorDetails(
    exception: e,
    stack: st,
    library: 'sponsor',
    context: ErrorDescription(doing),
  ),
);

/// The Commercial / PR euros the sponsor signed in [cycle] paid for: the
/// department pays back at the cycle's close.
Future<int> sponsorMarketingEuros({
  required CompetitionRepository comp,
  required NationRepository nations,
  required SeedRankingRepository seedRanks,
  required CareerRepository careers,
  required WorldPackRepository worlds,
  required Career career,
  required int cycle,
}) async {
  final round = await sponsorRoundOf(
    comp: comp,
    nations: nations,
    seedRanks: seedRanks,
    careers: careers,
    worlds: worlds,
    career: career,
    cycle: cycle,
  );
  return round?.chosen?.marketingEuros ?? 0;
}

/// The current cycle's sponsor round, for the sponsor screen, the hub stop,
/// the finances card and the end-of-cycle summary.
///
/// Watches the hub's data, which every step of the world and every decision
/// invalidates: a derived read never notices a write it did not make.
/// Nothing the hub's data watches may read this.
final AutoDisposeFutureProviderFamily<SponsorRound?, int> sponsorRoundProvider =
    FutureProvider.autoDispose.family<SponsorRound?, int>((
      ref,
      careerId,
    ) async {
      await ref.watch(hubDataProvider(careerId).future);
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      try {
        return await sponsorRoundOf(
          comp: ref.watch(competitionRepositoryProvider),
          nations: ref.watch(nationRepositoryProvider),
          seedRanks: ref.watch(seedRankingRepositoryProvider),
          careers: ref.watch(careerRepositoryProvider),
          worlds: ref.watch(worldPackRepositoryProvider),
          career: career,
        );
      } on Object catch (e, st) {
        // Loudly: a round read on a guess could sign another brand. The
        // screens show their error state (the hub's button retries, the
        // sponsor screen offers a retry and the way out).
        _report(e, st, 'reading the sponsor round of career $careerId');
        rethrow;
      }
    });

/// Signs or turns down a cycle's sponsor offers.
class SponsorService {
  SponsorService(this._ref);

  final Ref _ref;

  /// Signs [offer] for [careerId]'s current cycle. Returns whether it was
  /// signed: never twice in a cycle, never an offer the round does not hold.
  ///
  /// The marker, the money and the press row land together in one
  /// transaction, so a retry finds the marker and pays nothing twice.
  Future<bool> sign(int careerId, SponsorOffer offer) =>
      _ref.read(appDatabaseProvider).transaction(() async {
        final careers = _ref.read(careerRepositoryProvider);
        final comp = _ref.read(competitionRepositoryProvider);
        final career = await careers.byId(careerId);
        if (career == null) return false;
        final round = await _round(career);
        if (round == null || round.decided) return false;
        if (!round.offers.contains(offer)) return false;
        await comp.markDrawWatched(
          careerId,
          round.cycle,
          Sponsors.chosenKind(round.year, offer.index),
        );
        if (offer.euros > 0) {
          await careers.setBudget(careerId, career.budget + offer.euros);
        }
        // What the board and the dressing room make of it: through the press
        // effect, which both already read, until the cycle's close (see
        // `pressEffectProvider`).
        if (offer.morale != 0 || offer.board != 0) {
          await careers.recordPressAnswer(
            careerId: careerId,
            cycle: round.cycle,
            questionKey: Sponsors.pressKey(round.year, offer.brand),
            tone: Sponsors.pressTone,
            moraleDelta: offer.morale,
            boardDelta: offer.board,
            answeredAt: career.inGameDate,
          );
        }
        return true;
      });

  /// Turns every offer down for [careerId]'s current cycle. Nothing else
  /// happens: no money, no press. Returns whether it settled the round.
  Future<bool> decline(int careerId) =>
      _ref.read(appDatabaseProvider).transaction(() async {
        final career = await _ref.read(careerRepositoryProvider).byId(careerId);
        if (career == null) return false;
        final round = await _round(career);
        if (round == null || round.decided) return false;
        await _ref
            .read(competitionRepositoryProvider)
            .markDrawWatched(
              careerId,
              round.cycle,
              Sponsors.declinedKind(round.year),
            );
        return true;
      });

  /// A round still open when the world is moved on is turned down: moving on
  /// is the manager's answer, as it is for a Player of the Year ceremony.
  /// Not while a finals the manager is watching is live: the round waits for
  /// it (see [sponsorWaitsForFinals]), so its steps are no answer.
  Future<bool> settleUnanswered(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return false;
    final me = await _ref.read(nationRepositoryProvider).byId(career.nationId);
    if (await sponsorWaitsForFinals(
      _ref.read(competitionRepositoryProvider),
      careerId,
      confederation: me?.confederation,
      today: career.inGameDate,
    )) {
      return false;
    }
    return decline(careerId);
  }

  Future<SponsorRound?> _round(Career career) => sponsorRoundOf(
    comp: _ref.read(competitionRepositoryProvider),
    nations: _ref.read(nationRepositoryProvider),
    seedRanks: _ref.read(seedRankingRepositoryProvider),
    careers: _ref.read(careerRepositoryProvider),
    worlds: _ref.read(worldPackRepositoryProvider),
    career: career,
  );
}

final Provider<SponsorService> sponsorServiceProvider =
    Provider<SponsorService>(SponsorService.new);

/// Whether the cycle's sponsor round waits: a World Championship finals,
/// the manager's own continental finals, or his confederation's Nations Cup
/// finals (due within [nationsCupWindow] of [today]) is under way. Those are
/// watched round by round from the hub, and a deal to sign in the middle of
/// them would jump the queue (and a step to watch them would read as turning
/// it down). The round is offered once the tournament is over.
Future<bool> sponsorWaitsForFinals(
  CompetitionRepository comp,
  int careerId, {
  Confederation? confederation,
  DateTime? today,
}) async {
  if (await comp.hasFinals(careerId)) return true;
  if (await comp.hasLiveContinentalFinals(
    careerId,
    confederation: confederation,
  )) {
    return true;
  }
  final ncConf = NationsCups.ofManager(confederation);
  if (ncConf == null || today == null) return false;
  final nc = await comp.earliestUnplayedNationsCupFinalsDate(
    careerId,
    confederation: ncConf,
  );
  return nc != null && !nc.isAfter(today.add(nationsCupWindow));
}

/// How close a Nations Cup finals must be for the sponsor round to wait.
const Duration nationsCupWindow = Duration(days: 14);
