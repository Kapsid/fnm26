import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/campaign/campaign_grading.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

/// A career's campaign: which one, and whether a settled run has been moved
/// into the manager's save slots.
typedef CampaignTag = ({CampaignDef def, bool moved});

/// careerId -> campaign tag, for every campaign career. One query for the
/// `campaign:` markers plus one for the moved markers. Markers naming an
/// unknown campaign are ignored.
Future<Map<int, CampaignTag>> campaignTags(CompetitionRepository comp) async {
  final marks = await comp.watchedKindsWithPrefix('campaign:');
  if (marks.isEmpty) return const {};
  final moved = {
    for (final r in await comp.watchedKindsWithPrefix(campaignMovedKind))
      if (r.kind == campaignMovedKind) r.careerId,
  };
  final out = <int, CampaignTag>{};
  for (final m in marks) {
    final def = Campaigns.byId(m.kind.substring('campaign:'.length));
    if (def == null) continue;
    out[m.careerId] = (def: def, moved: moved.contains(m.careerId));
  }
  return out;
}

/// The campaign a career belongs to, or null for a normal career.
final AutoDisposeFutureProviderFamily<CampaignTag?, int> campaignOfProvider =
    FutureProvider.autoDispose.family<CampaignTag?, int>((ref, careerId) async {
      final tags = await campaignTags(ref.read(competitionRepositoryProvider));
      return tags[careerId];
    });

/// The campaign a career is playing NOW, or null: a normal career, or a moved
/// run rolled past the campaign's cycles. The twists last for the campaign's
/// length; afterwards a moved run is an ordinary save, so this is the one
/// gate for everything campaign-only (the hub card and tile, the progress,
/// the verdict event). An unmoved run rolls only within the campaign's
/// cycles (see [campaignMayRoll]), so it is always active; a moved run only
/// for the rest of the cycle it was moved in.
///
/// Watches the hub's data for the career's cycle, which every rollover
/// invalidates; nothing the hub's data watches may read this.
final AutoDisposeFutureProviderFamily<CampaignTag?, int>
activeCampaignProvider = FutureProvider.autoDispose.family<CampaignTag?, int>((
  ref,
  careerId,
) async {
  final hub = await ref.watch(hubDataProvider(careerId).future);
  if (hub == null) return null;
  final tag = await ref.watch(campaignOfProvider(careerId).future);
  final cycle = hub.career.cyclePointer;
  if (tag == null || cycle >= tag.def.cycles) return null;
  // A moved run is an ordinary career from the first rollover after the
  // move: its grade went into the record when it was moved, and nothing it
  // plays afterwards (a new nation's games, or its old one's AI results) is
  // the campaign any more.
  if (tag.moved &&
      !await ref
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(careerId, cycle, campaignMovedAtKind)) {
    return null;
  }
  return tag;
});

/// Whether a campaign run in its cycle [cyclePointer] may roll into the next.
/// A moved run is an ordinary save and rolls like one. An unmoved run rolls
/// only into a cycle the campaign still has: at the end of its last cycle it
/// ends in the campaigns list. A one-cycle campaign therefore never rolls
/// unmoved.
bool campaignMayRoll(CampaignTag tag, int cyclePointer) =>
    tag.moved || cyclePointer < tag.def.cycles - 1;

/// Whether [career]'s board is barred from sacking its manager at the end of
/// its current cycle: an active campaign longer than one cycle (the owner's
/// ruling). The board may be as unhappy as it likes, but such a run always
/// goes on to its last cycle, or to its verdict if that comes first. A moved
/// run is shielded only for the rest of the cycle it was moved in; after
/// that it is an ordinary career and the board's patience is the normal one.
/// The one-cycle campaigns and every normal career are never shielded.
///
/// Reads the markers directly rather than [activeCampaignProvider], which
/// watches the hub's data: the rollover verdict that asks this must not.
Future<bool> campaignBarsSacking(
  CompetitionRepository comp,
  Career career,
) async {
  final tag = (await campaignTags(comp))[career.id];
  if (tag == null || tag.def.cycles <= 1) return false;
  final cycle = career.cyclePointer;
  if (cycle >= tag.def.cycles) return false;
  if (!tag.moved) return true;
  return comp.hasWatchedDraw(career.id, cycle, campaignMovedAtKind);
}

/// Whether a career occupies a save slot: normal careers and moved campaigns
/// do; an unmoved campaign run does not.
bool countsAsSave(CampaignTag? tag) => tag == null || tag.moved;

/// Where a campaign run stands against its goal.
///
/// `settled` means the verdict is in (the run may be moved into the saves);
/// `stars` is the grade, 0 until settled, and `stars > 0` is success. The
/// positions are 1-based places in the nation's continental qualifying group
/// (null when it has none); `goalDifferenceGap` is the nation's goal
/// difference minus the rival's there. `ordinal` is the continental finish as
/// [continentalRun] reads it (the best across the cycles played, for a
/// campaign longer than one). `rivalWins` of `rivalMatchesPlayed` meetings
/// with the rival were won (both 0 without a rival); for a
/// [CampaignGoal.beatRivalsThenContinental] they count every meeting with any
/// of the rivals, in any match of any of its cycles, and `rivalsBeaten` names
/// the rivals beaten at least once. `cycleRuns` is the continental run of each
/// cycle played so far, first cycle first, and `worldRuns` the World
/// Championship run of each (read only for a
/// [CampaignGoal.qualifyWorldThenTitles] or a
/// [CampaignGoal.qualifyBothThenTitle], empty for every other goal).
/// `nationsCupRun` is this cycle's Nations Cup (see [campaignNationsCupRun]),
/// read only for a [CampaignGoal.titleTreble] and null for every other goal.
/// `reached` is the grade the run stands at now, settled or not; `stars` only
/// takes it at the verdict.
typedef CampaignProgress = ({
  CampaignDef def,
  bool settled,
  int stars,
  int reached,
  int? myPosition,
  int? rivalPosition,
  int? goalDifferenceGap,
  int ordinal,
  int rivalWins,
  int rivalMatchesPlayed,
  Set<int> rivalsBeaten,
  List<({int ordinal, bool over})> cycleRuns,
  List<({int ordinal, bool over})> worldRuns,
  ({int ordinal, bool over})? nationsCupRun,
});

/// Whether [nationId] won [f]: on the score, or level and through the
/// shootout. A shootout is stored either way (level with the kicks beside it,
/// or the winner a goal clear), and both read as a win here.
bool campaignNationWon(Fixture f, int nationId) {
  if (!f.hasResult) return false;
  final home = f.homeNationId == nationId;
  final mine = home ? f.homeScore! : f.awayScore!;
  final theirs = home ? f.awayScore! : f.homeScore!;
  if (mine != theirs) return mine > theirs;
  if (!f.wentToShootout) return false;
  final myPens = home ? f.homePenalties! : f.awayPenalties!;
  final theirPens = home ? f.awayPenalties! : f.homePenalties!;
  return myPens > theirPens;
}

/// The nation's fixtures across every cycle of [def] played so far, oldest
/// first. In the first cycle that is [current] (the current cycle's own);
/// after it, the all-time list cut to the campaign's span by the cycles'
/// opening dates, as the career history cuts it.
Future<List<Fixture>> campaignSpanFixtures(
  CompetitionRepository comp,
  int careerId,
  CampaignDef def,
  int cyclePointer,
  List<Fixture> current,
) async {
  if (cyclePointer == 0) return current;
  final from = CareerService.cycleOpens(0);
  final to = CareerService.cycleOpens(def.cycles);
  return [
    for (final f in await comp.fixturesForNation(careerId, def.nationId))
      if (!f.date.isBefore(from) && f.date.isBefore(to)) f,
  ];
}

/// A campaign run's progress (careerId), or null for a normal career or a
/// campaign that is over (see [activeCampaignProvider]).
///
/// Derived from recorded tables and runs, so it watches the hub's data first:
/// every simulation step invalidates that, and this re-reads with it rather
/// than serving a table from before the results came in.
final AutoDisposeFutureProviderFamily<CampaignProgress?, int>
campaignProgressProvider = FutureProvider.autoDispose
    .family<CampaignProgress?, int>((ref, careerId) async {
      final hub = await ref.watch(hubDataProvider(careerId).future);
      if (hub == null) return null;
      final tag = await ref.watch(activeCampaignProvider(careerId).future);
      if (tag == null) return null;
      final def = tag.def;
      final cyclePointer = hub.career.cyclePointer;
      final comp = ref.watch(competitionRepositoryProvider);
      final nation = await ref
          .watch(nationRepositoryProvider)
          .byId(def.nationId);
      if (nation == null) return null;
      final conf = nation.confederation;
      final fixtures = await comp.cycleFixturesForNation(
        careerId,
        def.nationId,
      );
      final run = await continentalRun(
        comp: comp,
        careerId: careerId,
        nationId: def.nationId,
        confederation: conf,
        fixtures: fixtures,
      );

      // The qualifying group: the one holding the rival too, for a rivalry.
      final tables = await comp.tournamentGroupTables(
        careerId,
        CompetitionKind.continentalQualifying,
        confederation: conf,
      );
      final rival = def.rivalNationId;
      bool holds(FinalsGroupTable t, int id) =>
          t.standings.any((s) => s.nationId == id);
      final table =
          tables
              .where((t) => holds(t, def.nationId) && holds(t, rival ?? -1))
              .firstOrNull ??
          tables.where((t) => holds(t, def.nationId)).firstOrNull;
      int? positionOf(int? id) {
        if (table == null || id == null) return null;
        final i = table.standings.indexWhere((s) => s.nationId == id);
        return i < 0 ? null : i + 1;
      }

      final myPosition = positionOf(def.nationId);
      final rivalPosition = positionOf(rival);
      int? gdOf(int id) => table?.standings
          .where((s) => s.nationId == id)
          .firstOrNull
          ?.goalDifference;
      final myGd = gdOf(def.nationId);
      final rivalGd = rival == null ? null : gdOf(rival);
      final gdGap = myGd == null || rivalGd == null ? null : myGd - rivalGd;

      // The meetings in the qualifying GROUP (a play-off tie with the rival
      // would not count): the group's double round robin makes them two, and
      // "won both" means every one of them played and won.
      final groupIds = {
        for (final f in fixtures)
          if (f.round == 'CQ' && f.groupId != null) f.groupId,
      };
      final meetings = [
        for (final f in fixtures)
          if (rival != null &&
              f.round == 'CQ' &&
              f.groupId != null &&
              (f.homeNationId == rival || f.awayNationId == rival))
            f,
      ];
      assert(
        groupIds.length <= 1 && meetings.length <= 2,
        'one qualifying group, met twice at most',
      );
      var rivalWins = 0;
      var rivalPlayed = 0;
      for (final f in meetings) {
        if (!f.hasResult) continue;
        rivalPlayed++;
        final home = f.homeNationId == def.nationId;
        final mine = home ? f.homeScore! : f.awayScore!;
        final theirs = home ? f.awayScore! : f.homeScore!;
        if (mine > theirs) rivalWins++;
      }

      // Every cycle's continental run, the current one as read above; an
      // earlier cycle's from its own fixtures (it is long over). The World
      // Championship runs beside them, for the one goal that reads them.
      final readsWorld =
          def.goal == CampaignGoal.qualifyWorldThenTitles ||
          def.goal == CampaignGoal.qualifyBothThenTitle ||
          def.goal == CampaignGoal.titleTreble;
      final cycleRuns = <({int ordinal, bool over})>[];
      final worldRuns = <({int ordinal, bool over})>[];
      // Read once: a century-long campaign has up to 24 past cycles.
      final allTime = cyclePointer == 0
          ? const <Fixture>[]
          : await comp.fixturesForNation(careerId, def.nationId);
      for (var c = 0; c < cyclePointer; c++) {
        final from = CareerService.cycleOpens(c);
        final to = CareerService.cycleOpens(c + 1);
        final pastFixtures = [
          for (final f in allTime)
            if (!f.date.isBefore(from) && f.date.isBefore(to)) f,
        ];
        final past = await continentalRun(
          comp: comp,
          careerId: careerId,
          nationId: def.nationId,
          confederation: conf,
          fixtures: pastFixtures,
        );
        cycleRuns.add((ordinal: past.ordinal, over: true));
        if (readsWorld) {
          worldRuns.add((
            ordinal: worldFinishOrdinal(pastFixtures, def.nationId),
            over: true,
          ));
        }
      }
      cycleRuns.add(run);
      if (readsWorld) {
        worldRuns.add(
          await worldRun(
            comp: comp,
            careerId: careerId,
            nationId: def.nationId,
            fixtures: fixtures,
          ),
        );
      }
      final nationsCupRun = def.goal == CampaignGoal.titleTreble
          ? await campaignNationsCupRun(
              comp: comp,
              careerId: careerId,
              nationId: def.nationId,
              confederation: conf,
              year: CareerService.continentalFinalsYear(cyclePointer),
              fixtures: fixtures,
            )
          : null;
      final bestOrdinal = cycleRuns
          .map((r) => r.ordinal)
          .reduce((a, b) => a > b ? a : b);

      // Every meeting with any of the rivals, friendlies included, across the
      // campaign's cycles.
      final rivalsBeaten = <int>{};
      if (def.rivalNationIds.isNotEmpty) {
        final span = await campaignSpanFixtures(
          comp,
          careerId,
          def,
          cyclePointer,
          fixtures,
        );
        for (final f in span) {
          final opp = f.homeNationId == def.nationId
              ? f.awayNationId
              : f.homeNationId;
          if (!def.rivalNationIds.contains(opp) || !f.hasResult) continue;
          rivalPlayed++;
          if (campaignNationWon(f, def.nationId)) {
            rivalWins++;
            rivalsBeaten.add(opp);
          }
        }
      }

      final aboveRival =
          myPosition != null &&
          rivalPosition != null &&
          myPosition < rivalPosition;
      final reached = switch (def.goal) {
        CampaignGoal.qualifyContinental => starsForFinish(
          run.ordinal,
          def.starThresholds,
        ),
        CampaignGoal.aboveRival => grudgeStars(
          aboveRival: aboveRival,
          qualified: run.ordinal >= 2,
          wonBoth: meetings.isNotEmpty && rivalWins == meetings.length,
        ),
        CampaignGoal.beatRivalsThenContinental => beatRivalsStars(
          beatAll: rivalsBeaten.length == def.rivalNationIds.length,
          bestOrdinal: bestOrdinal,
        ),
        CampaignGoal.qualifyWorldThenTitles => worldThenTitlesStars(
          qualifiedWorld: worldRuns.any((r) => r.ordinal >= 2),
          wonContinental: cycleRuns.any((r) => r.ordinal >= 7),
          wonWorld: worldRuns.any((r) => r.ordinal >= 7),
        ),
        CampaignGoal.qualifyBothThenTitle => qualifyBothThenTitleStars(
          qualifiedContinental: cycleRuns.any((r) => r.ordinal >= 2),
          qualifiedWorld: worldRuns.any((r) => r.ordinal >= 2),
          wonTitle:
              cycleRuns.any((r) => r.ordinal >= 7) ||
              worldRuns.any((r) => r.ordinal >= 7),
        ),
        CampaignGoal.titleTreble => titleTrebleStars(
          wonContinental: cycleRuns.any((r) => r.ordinal >= 7),
          wonWorld: worldRuns.any((r) => r.ordinal >= 7),
          wonNationsCup: (nationsCupRun?.ordinal ?? 0) >= 7,
        ),
      };
      var settled = switch (def.goal) {
        CampaignGoal.qualifyContinental => run.over,
        // Judged when the qualifying group is played out. Finishing below
        // the rival fails it there and then; finishing above waits for the
        // finals field (play-off winners included), which decides the
        // "and qualify" star.
        CampaignGoal.aboveRival =>
          await _groupPlayedOut(comp, careerId, table) &&
              (!aboveRival ||
                  (await comp.fixturesByRound(
                    careerId,
                    'CGROUP',
                    kind: CompetitionKind.continentalFinals,
                    confederation: conf,
                  )).isNotEmpty),
        // Nothing left to improve once the third star is in; otherwise it
        // runs to the end of the campaign's last cycle.
        CampaignGoal.beatRivalsThenContinental => reached == 3,
        // The same: the world title ends it, anything less runs on.
        CampaignGoal.qualifyWorldThenTitles => reached == 3,
        CampaignGoal.qualifyBothThenTitle => reached == 3,
        // Every star needs the continental title first: losing it ends the
        // run there and then. Otherwise it runs to the World Championship,
        // the last title of the cycle (the end-of-cycle rule below).
        CampaignGoal.titleTreble =>
          reached == 3 || (run.over && run.ordinal < 7),
      };
      // A cycle is over. At the end of the campaign's LAST cycle whatever is
      // still open is judged as it stands; at the end of any cycle a manager
      // sacked fails a campaign that had not already reached its verdict. A
      // verdict reached earlier stands. A one-cycle campaign's only cycle is
      // its last, so it is judged here exactly as before. A longer campaign
      // never loses its manager (see [campaignBarsSacking]), so a sacking is
      // not even asked about there.
      var sacked = false;
      if (await comp.worldChampion(careerId) != null) {
        // Finish the Legacy banks its stars as the titles come in: a board
        // that sacks the manager after the European title cannot take that
        // title, and so that star, away.
        final banked = def.goal == CampaignGoal.titleTreble && reached > 0;
        if (!settled && def.cycles <= 1 && !banked) {
          final verdict = await ref.watch(
            rolloverVerdictProvider(careerId).future,
          );
          sacked = verdict?.sacked ?? false;
        }
        if (sacked || cyclePointer >= def.cycles - 1) settled = true;
      }

      return (
        def: def,
        settled: settled,
        stars: !settled || sacked ? 0 : reached,
        reached: reached,
        myPosition: myPosition,
        rivalPosition: rivalPosition,
        goalDifferenceGap: gdGap,
        ordinal: def.cycles > 1 ? bestOrdinal : run.ordinal,
        rivalWins: rivalWins,
        rivalMatchesPlayed: rivalPlayed,
        rivalsBeaten: rivalsBeaten,
        cycleRuns: cycleRuns,
        worldRuns: worldRuns,
        nationsCupRun: nationsCupRun,
      );
    });

/// [nationId]'s Nations Cup in the current cycle, on the board's scale: 7
/// champions (the cup's honour for [year] names it, however it was won), 6
/// runners-up, 5 the finals (a ladder's Finals Four, or any of Africa's
/// knockouts), 4 group winners, 3 top half, 2 clear of the bottom, 1
/// bottom, 0 no group yet. `over` once nothing more can come of it: the cup's
/// honour for [year] is recorded, the nation lost a knockout tie, or its group
/// is played out without the place in the finals a League A group winner
/// earns. A confederation with no Nations Cup has nothing to win: over at 0.
Future<({int ordinal, bool over})> campaignNationsCupRun({
  required CompetitionRepository comp,
  required int careerId,
  required int nationId,
  required Confederation confederation,
  required int year,
  required List<Fixture> fixtures,
}) async {
  final cup = NationsCups.forConfederation(confederation);
  if (cup == null) return (ordinal: 0, over: true);
  final decided = await comp.hasHonour(careerId, cup.name, year);
  // The title, however the cup crowned it: a ladder with a lone League A
  // group winner crowns it outright, with no final to read.
  if (decided) {
    final honour = (await comp.honours(
      careerId,
    )).where((h) => h.competition == cup.name && h.year == year).firstOrNull;
    if (honour != null && honour.champions.contains(nationId)) {
      return (ordinal: 7, over: true);
    }
  }
  for (final f in fixtures) {
    if (f.round != 'NFINAL' || !f.hasResult) continue;
    return (ordinal: campaignNationWon(f, nationId) ? 7 : 6, over: true);
  }
  const knockouts = {'NR16', 'NQF', 'NSF', 'NFINAL'};
  final ties = [
    for (final f in fixtures)
      if (knockouts.contains(f.round)) f,
  ];
  if (ties.isNotEmpty) {
    final out = ties.any((f) => f.hasResult && !campaignNationWon(f, nationId));
    return (ordinal: 5, over: out || decided);
  }
  final tables = await comp.tournamentGroupTables(
    careerId,
    CompetitionKind.nationsLeague,
    confederation: confederation,
  );
  final table = tables
      .where((t) => t.standings.any((s) => s.nationId == nationId))
      .firstOrNull;
  if (table == null) return (ordinal: 0, over: decided);
  final pos = table.standings.indexWhere((s) => s.nationId == nationId) + 1;
  final n = table.standings.length;
  final ordinal = pos == 1
      ? 4
      : pos <= (n + 1) ~/ 2
      ? 3
      : pos < n
      ? 2
      : 1;
  final group = [
    for (final f in fixtures)
      if (f.round == 'NGROUP') f,
  ];
  final groupDone = group.isNotEmpty && group.every((f) => f.hasResult);
  // A ladder's Finals Four is League A's group winners; Africa's knockouts
  // take more than the winners, so only the honour closes its cup.
  final mayGoOn =
      cup.format == NationsCupFormat.zones ||
      (pos == 1 && NationsCup.tierOfGroupName(table.name) == 0);
  return (ordinal: ordinal, over: decided || (groupDone && !mayGoOn));
}

/// Whether every qualifying fixture between the members of [table] has a
/// result. Each member's own fixtures are read, so the whole group is seen,
/// not only the campaign nation's games.
Future<bool> _groupPlayedOut(
  CompetitionRepository comp,
  int careerId,
  FinalsGroupTable? table,
) async {
  if (table == null) return false;
  final members = {for (final s in table.standings) s.nationId};
  var any = false;
  for (final id in members) {
    for (final f in await comp.cycleFixturesForNation(careerId, id)) {
      if (f.round != 'CQ' ||
          !members.contains(f.homeNationId) ||
          !members.contains(f.awayNationId)) {
        continue;
      }
      if (!f.hasResult) return false;
      any = true;
    }
  }
  return any;
}

/// campaign id -> its unmoved run. A moved campaign is an ordinary save and
/// no longer the campaign's run, so starting it again begins a fresh one.
final campaignRunsProvider = FutureProvider.autoDispose<Map<String, Career>>((
  ref,
) async {
  final tags = await campaignTags(ref.read(competitionRepositoryProvider));
  if (tags.isEmpty) return const {};
  final out = <String, Career>{};
  for (final c in await ref.read(careerRepositoryProvider).all()) {
    final tag = tags[c.id];
    if (tag != null && !tag.moved) out[tag.def.id] = c;
  }
  return out;
});

/// How [CampaignService.moveToSaves] ended.
enum CampaignMoveResult {
  moved,
  slotsFull,
  notSettled,
  notAllowed,

  /// The run is Pro-locked (see `saveNeedsPremium`): it is left exactly as it
  /// is, unmoved, until Pro is owned.
  needsPremium,
}

/// Starts, abandons and moves campaign runs, which live outside the save slots
/// until the manager chooses to keep one.
class CampaignService {
  CampaignService(this._ref);

  final Ref _ref;

  /// Starts a fresh run of [def]: its fixed world, no slot taken. Throws
  /// [StateError] when a run already exists (the UI asks Resume or Abandon
  /// first), or when [def] needs Pro and the manager has not got it (the UI
  /// opens the paywall instead of calling this).
  Future<Career> start(CampaignDef def, {required String managerName}) async {
    if (def.needsPro && !_ref.read(premiumUnlockedProvider)) {
      throw StateError('Campaign ${def.id} needs Pro.');
    }
    // The run freezes the stored ranking (see freezeStartingRanks below), so
    // an upgraded database must first have moved to the current one.
    await _ref.read(seedLoaderProvider).ensureSeeded();
    final runs = await _ref.read(campaignRunsProvider.future);
    if (runs.containsKey(def.id)) {
      throw StateError('Campaign ${def.id} already has a run in progress.');
    }
    final result = await _ref
        .read(careerServiceProvider)
        .create(
          nationId: def.nationId,
          managerName: managerName,
          rngSeed: def.rngSeed,
          countsTowardSlots: false,
          // Inside create, before the calendar is drawn: a dormant nation's
          // world must be the one every draw is made from.
          worldMarkers: [
            if (def.dormantNationId case final d?) DormantNations.markerFor(d),
          ],
          // A run starts on the current starting ranking, the same one a
          // new career gets, frozen into the run (its cycle-0 snapshot) so
          // the world its seed was searched on stays its world whatever a
          // later update ships (see campaign_seeds_test). Runs begun on the
          // 1.0.6 ranking keep that one: their snapshot already holds it, or
          // the seed loader freezes it.
          freezeStartingRanks: true,
        );
    final career = result.valueOrNull;
    if (career == null) {
      throw StateError('Could not create the ${def.id} campaign.');
    }
    // No half-made run: a failure after the career exists deletes it again.
    try {
      await _ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(career.id, 0, campaignMarker(def.id));
      if (def.friendlyNationId case final opponent?) {
        await _bookOpeningFriendly(career, opponent);
      }
      if (def.goldenGeneration) {
        // From here every read of the nation's players in this run is the
        // cohort (see GoldenGeneration). The repository keeps only a yes, so
        // the default XI read a moment ago pinned nothing; it is re-picked
        // below.
        await _ref
            .read(competitionRepositoryProvider)
            .markDrawWatched(
              career.id,
              0,
              GoldenGeneration.markerFor(def.nationId),
            );
        await _repickLineup(career, def.nationId);
      }
      final donor = def.donorNationId;
      if (donor != null) {
        final pool = await careerPoolOf(_ref, career, donor);
        // Best first by overall; the sort is stable so ties keep pool order.
        final best = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));
        final repo = _ref.read(careerRepositoryProvider);
        for (final p in best.take(def.transplantCount)) {
          await repo.addNaturalizationOffer(
            careerId: career.id,
            playerId: p.id,
            sourceNationId: donor,
            cycle: 0,
          );
          await repo.setNaturalizationStatus(career.id, p.id, 'accepted');
        }
        // The default XI was picked when the career was created, before the
        // transplant: re-pick it, or the new arrivals start on the bench
        // until the manager thinks to redo the lineup by hand.
        await _repickLineup(career, def.nationId);
      }
    } catch (_) {
      await _ref.read(careerServiceProvider).delete(career.id);
      rethrow;
    }
    _ref
      ..invalidate(savesProvider)
      ..invalidate(campaignRunsProvider);
    return career;
  }

  /// Re-picks the default XI from [nationId]'s pool as it reads now, after a
  /// start-of-run modifier changed who is in it. Written straight to the
  /// repository: nothing reads the run yet, so there is no hub or preview to
  /// refresh.
  Future<void> _repickLineup(Career career, int nationId) async {
    final tactics = _ref.read(tacticsRepositoryProvider);
    final tactic = await tactics.tacticForCareer(career.id);
    if (tactic == null) return;
    final mine = await careerPoolOf(_ref, career, nationId);
    await tactics.saveTactic(
      career.id,
      tactic.copyWith(lineup: bestEleven(tactic.formation, mine)),
    );
  }

  /// Books the campaign's opening home friendly against [opponentId] in the
  /// first free international window of the run's first cycle, through the
  /// ordinary friendlies path, so it is a friendly like any the manager
  /// arranges. Nothing when no window is free.
  Future<void> _bookOpeningFriendly(Career career, int opponentId) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final nations = {
      for (final n
          in await _ref.read(nationRepositoryProvider).forCareer(career.id))
        n.id: n,
    };
    final window = await firstFreeHomeFriendlyWindow(comp, career, nations);
    if (window == null) return;
    await _ref
        .read(friendliesServiceProvider)
        .arrange(
          career.id,
          nationId: career.nationId,
          cycle: career.cyclePointer,
          picks: {window: opponentId},
          allWindows: [window],
        );
  }

  /// Deletes the run and everything it stored, markers included. A settled
  /// run's grade is recorded first: the verdict may never have been
  /// acknowledged, and the stamp must not leave with the save.
  Future<void> abandon(int careerId) async {
    await _recordIfSettled(careerId);
    await _ref.read(careerServiceProvider).delete(careerId);
    _ref.invalidate(campaignRunsProvider);
  }

  /// Moves a settled run into the saves. Refused (nothing changes) while it is
  /// unsettled, when the slots are full, or when the campaign cannot be
  /// continued ([CampaignDef.canContinue]).
  Future<CampaignMoveResult> moveToSaves(int careerId) async {
    // Re-read, not a cached grade: the run may have moved on since.
    _ref.invalidate(campaignProgressProvider(careerId));
    final progress = await _ref.read(
      campaignProgressProvider(careerId).future,
    );
    if (progress == null || !progress.settled) {
      return CampaignMoveResult.notSettled;
    }
    if (!progress.def.canContinue) return CampaignMoveResult.notAllowed;
    // A Pro-locked run is not written to, the moved marker included. Only once
    // the launch entitlement has settled: before that nothing locks.
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career != null &&
        _ref.read(entitlementSettledProvider) &&
        saveNeedsPremium(
          cyclePointer: career.cyclePointer,
          premiumUnlocked: _ref.read(premiumUnlockedProvider),
          proCampaign: progress.def.needsPro,
        )) {
      return CampaignMoveResult.needsPremium;
    }
    final saves = await _ref.read(savesProvider.future);
    if (!canCreateSave(
      existingSaves: saves.length,
      premiumUnlocked: _ref.read(premiumUnlockedProvider),
    )) {
      return CampaignMoveResult.slotsFull;
    }
    // The grade goes into the record now: once moved, the save may be
    // deleted (or rolled past the campaign) before the verdict is seen.
    await _ref
        .read(campaignRecordStoreProvider)
        .record(progress.def.id, progress.stars);
    final comp = _ref.read(competitionRepositoryProvider);
    await comp.markDrawWatched(careerId, 0, campaignMovedKind);
    final cycle = (await _ref.read(careerRepositoryProvider).byId(careerId))
        ?.cyclePointer;
    if (cycle != null) {
      await comp.markDrawWatched(careerId, cycle, campaignMovedAtKind);
    }
    _ref
      ..invalidate(savesProvider)
      ..invalidate(campaignRunsProvider)
      ..invalidate(campaignOfProvider(careerId));
    return CampaignMoveResult.moved;
  }

  /// Records a settled run's grade (the store keeps the best, so recording
  /// it again later is harmless). Nothing for an unsettled run.
  Future<void> _recordIfSettled(int careerId) async {
    _ref.invalidate(campaignProgressProvider(careerId));
    final progress = await _ref.read(
      campaignProgressProvider(careerId).future,
    );
    if (progress == null || !progress.settled) return;
    await _ref
        .read(campaignRecordStoreProvider)
        .record(progress.def.id, progress.stars);
  }

  /// The manager has seen the verdict: the hub stops offering it, and the
  /// grade goes into the campaign's record (which keeps the best). Called by
  /// the verdict screen's Continue. Does nothing for a normal career, or for a
  /// run whose verdict is not in yet (a stray call must not file a failure).
  Future<void> acknowledgeVerdict(int careerId) async {
    final progress = await _ref.read(
      campaignProgressProvider(careerId).future,
    );
    if (progress == null || !progress.settled) return;
    // The record first: a failure before the marker leaves the verdict on
    // offer, and recording again is harmless (the store keeps the best).
    await _ref
        .read(campaignRecordStoreProvider)
        .record(progress.def.id, progress.stars);
    await _ref
        .read(competitionRepositoryProvider)
        .markDrawWatched(careerId, 0, campaignVerdictKind);
    _ref.invalidate(nextEventProvider(careerId));
  }
}

final campaignServiceProvider = Provider<CampaignService>(
  (ref) => CampaignService(ref),
);
