import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

/// A season's sponsor round: the three offers, and what was done about them.
typedef SponsorRound = ({
  int cycle,

  /// The season (September to August) it belongs to, named by the year it
  /// opens in.
  int season,
  List<SponsorOffer> offers,

  /// The offer signed this season, or null (none yet, or turned down).
  SponsorOffer? chosen,

  /// Whether the round is settled: an offer signed or every one declined.
  bool decided,
});

/// The first season of [cycle]: the year it opens in.
int firstSponsorSeason(int cycle) => CareerService.cycleStart.year + 4 * cycle;

/// The season [career] is in now.
int currentSponsorSeason(Career career) => Sponsors.seasonOf(
  career.inGameDate,
  firstSponsorSeason(career.cyclePointer),
);

/// The season's label as a manager reads it: "2026/27".
String sponsorSeasonLabel(int season) =>
    '$season/${((season + 1) % 100).toString().padLeft(2, '0')}';

/// [career]'s sponsor round for [season] of [cycle] (its current ones by
/// default), or null where there is none: an unmoved campaign run (a
/// challenge is played on the money it was set, as it gets no host bids
/// either) or a career whose nation cannot be found.
///
/// Derived from the save's seed, the season, the nation and its world place
/// at the cycle's START (the frozen seed ranking, or the career's starting
/// ranking in cycle 0), so it reads the same on every visit. Only the choice
/// is stored, as a marker on the cycle (see [Sponsors]).
///
/// The nation is the one the career holds now: the rollover changes nation
/// before the cycle that follows, so for the current cycle it is always the
/// right one. A past cycle is read the way its income is (see
/// `FederationService.incomeForCycle`).
Future<SponsorRound?> sponsorRoundOf({
  required CompetitionRepository comp,
  required NationRepository nations,
  required SeedRankingRepository seedRanks,
  required Career career,
  int? cycle,
  int? season,
}) async {
  final c = cycle ?? career.cyclePointer;
  final s = season ?? currentSponsorSeason(career);
  final tag = (await campaignTags(comp))[career.id];
  if (tag != null && !tag.moved) return null;
  final world = await nations.forCareer(career.id);
  final me = world.where((n) => n.id == career.nationId).firstOrNull;
  if (me == null) return null;
  final frozen = await seedRanks.forCycle(career.id, c);
  final offers = Sponsors.offersFor(
    seed: career.rngSeed,
    season: s,
    nationCode: me.code,
    worldRank: frozen[me.id] ?? me.ranking,
  );
  SponsorOffer? chosen;
  var decided = false;
  for (final o in offers) {
    if (await comp.hasWatchedDraw(
      career.id,
      c,
      Sponsors.chosenKind(s, o.index),
    )) {
      chosen = o;
      decided = true;
      break;
    }
  }
  if (!decided) {
    decided = await comp.hasWatchedDraw(career.id, c, Sponsors.declinedKind(s));
  }
  return (
    cycle: c,
    season: s,
    offers: offers,
    chosen: chosen,
    decided: decided,
  );
}

/// The Commercial / PR euros the sponsors signed in [cycle] paid for, all of
/// its seasons together: the department pays back at the cycle's close.
Future<int> sponsorMarketingEuros({
  required CompetitionRepository comp,
  required NationRepository nations,
  required SeedRankingRepository seedRanks,
  required Career career,
  required int cycle,
}) async {
  var euros = 0;
  final first = firstSponsorSeason(cycle);
  for (var s = first; s < first + 4; s++) {
    final round = await sponsorRoundOf(
      comp: comp,
      nations: nations,
      seedRanks: seedRanks,
      career: career,
      cycle: cycle,
      season: s,
    );
    euros += round?.chosen?.marketingEuros ?? 0;
  }
  return euros;
}

/// The current season's sponsor round, for the sponsor screen, the hub stop
/// and the finances card.
///
/// Watches the hub's data, which every step of the world and every decision
/// invalidates: a derived read never notices a write it did not make, and the
/// season turns with the clock. Nothing the hub's data watches may read this.
final AutoDisposeFutureProviderFamily<SponsorRound?, int> sponsorRoundProvider =
    FutureProvider.autoDispose.family<SponsorRound?, int>((
      ref,
      careerId,
    ) async {
      await ref.watch(hubDataProvider(careerId).future);
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      return sponsorRoundOf(
        comp: ref.watch(competitionRepositoryProvider),
        nations: ref.watch(nationRepositoryProvider),
        seedRanks: ref.watch(seedRankingRepositoryProvider),
        career: career,
      );
    });

/// Signs or turns down a season's sponsor offers.
class SponsorService {
  SponsorService(this._ref);

  final Ref _ref;

  /// Signs [offer] for [careerId]'s current season. Returns whether it was
  /// signed: never twice in a season, never an offer the round does not hold.
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
          Sponsors.chosenKind(round.season, offer.index),
        );
        if (offer.euros > 0) {
          await careers.setBudget(careerId, career.budget + offer.euros);
        }
        // What the board and the dressing room make of it: through the press
        // effect, which both already read, for this season only (see
        // `pressEffectProvider`).
        if (offer.morale != 0 || offer.board != 0) {
          await careers.recordPressAnswer(
            careerId: careerId,
            cycle: round.cycle,
            questionKey: Sponsors.pressKey(round.season, offer.brand),
            tone: Sponsors.pressTone,
            moraleDelta: offer.morale,
            boardDelta: offer.board,
            answeredAt: career.inGameDate,
          );
        }
        return true;
      });

  /// Turns every offer down for [careerId]'s current season. Nothing else
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
              Sponsors.declinedKind(round.season),
            );
        return true;
      });

  /// A round still open when the world is moved on is turned down: moving on
  /// is the manager's answer, as it is for a Player of the Year ceremony.
  Future<bool> settleUnanswered(int careerId) => decline(careerId);

  Future<SponsorRound?> _round(Career career) => sponsorRoundOf(
    comp: _ref.read(competitionRepositoryProvider),
    nations: _ref.read(nationRepositoryProvider),
    seedRanks: _ref.read(seedRankingRepositoryProvider),
    career: career,
  );
}

final Provider<SponsorService> sponsorServiceProvider =
    Provider<SponsorService>(SponsorService.new);
