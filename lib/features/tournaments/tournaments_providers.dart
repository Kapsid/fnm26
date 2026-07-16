import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';

/// Where a championship stands for the current save, used to label and unlock
/// its tile on the tournaments overview.
enum TournamentPhase {
  /// Being contested right now (qualifying/finals/knockout under way).
  live,

  /// Decided this cycle — a champion is known.
  decided,

  /// Not running this cycle, but past editions exist to browse.
  history,

  /// No data yet for this save.
  upcoming,
}

/// The live status of one championship tile.
class TournamentStatus {
  const TournamentStatus({
    required this.phase,
    required this.label,
    required this.championId,
  });

  final TournamentPhase phase;
  final String label;
  final int? championId;

  bool get available => phase != TournamentPhase.upcoming;
}

/// Overview status for every championship: keyed by confederation, with the
/// `null` key holding the global World Championship.
class TournamentsOverview {
  const TournamentsOverview({
    required this.statuses,
    required this.nations,
    required this.playerConfederation,
    required this.nextMatches,
    required this.playerGroup,
    required this.worldCupHostId,
    this.nationsCup,
    this.nationsCupLeague = 'A',
    this.continentalClash,
  });

  final Map<Confederation?, TournamentStatus> statuses;
  final Map<int, Nation> nations;
  final Confederation? playerConfederation;

  /// The Nations Cup (with the manager's current league letter) and the
  /// Continental Clash statuses — competitions outside the per-confederation
  /// grid.
  final TournamentStatus? nationsCup;
  final String nationsCupLeague;
  final TournamentStatus? continentalClash;

  /// The host nation of this cycle's World Cup (deterministic from the start).
  final int? worldCupHostId;

  /// The player's next fixture in each competition (World Cup under the `null`
  /// key, their continental cup under their confederation), so tiles can show
  /// "up next" progress.
  final Map<Confederation?, Fixture?> nextMatches;

  /// The player's current group table (qualifying/finals), used to show their
  /// live position on the matching tile.
  final GroupTable? playerGroup;
}

final AutoDisposeFutureProviderFamily<TournamentsOverview?, int>
    tournamentsOverviewProvider =
    FutureProvider.autoDispose.family<TournamentsOverview?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final playerConf = nations[career.nationId]?.confederation;
  final honours = await comp.honours(careerId);
  final honourComps = {for (final h in honours) h.competition};

  final statuses = <Confederation?, TournamentStatus>{};

  // Which competition is actually being contested now, driven by what has been
  // played and the player's next fixture — so a tile is "live" only when its
  // matches are current, not from the cycle's first day (when the Nations Cup
  // and World Cup are still months away but the Euro qualifiers are on).
  const wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
  const contFinalsRounds = {'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'};
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);
  final upcoming = fixtures.where((f) => !f.played).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  final next = upcoming.isEmpty ? null : upcoming.first;
  bool anyPlayed(bool Function(String? round, int? groupId) test) =>
      fixtures.any((f) => f.hasResult && test(f.round, f.groupId));
  // A World Cup qualifier is a group game with no round label; continental
  // qualifiers use 'CQ'.
  final wcStarted = anyPlayed((r, g) =>
      (r == null && g != null) || wcFinalsRounds.contains(r));
  final contStarted =
      anyPlayed((r, _) => r == 'CQ' || contFinalsRounds.contains(r));
  final nextIsWc = next != null &&
      ((next.round == null && next.groupId != null) ||
          wcFinalsRounds.contains(next.round));
  final nextIsCont = next != null &&
      (next.round == 'CQ' || contFinalsRounds.contains(next.round));

  // World Championship.
  final worldChampion = await comp.worldChampion(careerId);
  final hasFinals = await comp.hasFinals(careerId);
  final wcLive = hasFinals || wcStarted || nextIsWc;
  final wcHasHistory = honourComps.contains('World Championship');
  statuses[null] = TournamentStatus(
    phase: worldChampion != null
        ? TournamentPhase.decided
        : wcLive
            ? TournamentPhase.live
            : wcHasHistory
                ? TournamentPhase.history
                : TournamentPhase.upcoming,
    label: worldChampion != null
        ? 'CHAMPIONS'
        : wcLive
            ? (hasFinals ? 'FINALS' : 'QUALIFYING')
            : wcHasHistory
                ? 'PAST WINNERS'
                : 'UPCOMING',
    championId: worldChampion,
  );

  // The player's continental championship is played in detail this cycle;
  // others are decided in the background and live on in History.
  final hasContinental =
      await comp.hasTournament(careerId, CompetitionKind.continentalFinals);
  int? continentalChampion;
  if (hasContinental) {
    final finalTie = await comp.fixturesByRound(
      careerId,
      'CFINAL',
      kind: CompetitionKind.continentalFinals,
    );
    if (finalTie.isNotEmpty && finalTie.first.hasResult) {
      final f = finalTie.first;
      continentalChampion =
          f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
    }
  }

  for (final entry in ContinentalCups.byConfederation.entries) {
    final conf = entry.key;
    final name = entry.value.name;
    final isPlayerConf = conf == playerConf;
    // Live through the player's whole continental campaign — qualifying as well
    // as the finals — not only once the finals tournament exists.
    final liveThisCycle =
        isPlayerConf && (hasContinental || contStarted || nextIsCont);
    final hasHistory = honourComps.contains(name);

    final TournamentPhase phase;
    final String label;
    int? champion;
    if (liveThisCycle) {
      phase = continentalChampion != null
          ? TournamentPhase.decided
          : TournamentPhase.live;
      label = continentalChampion != null
          ? 'CHAMPIONS'
          : hasContinental
              ? 'IN PROGRESS'
              : 'QUALIFYING';
      champion = continentalChampion;
    } else if (hasHistory) {
      phase = TournamentPhase.history;
      label = 'PAST WINNERS';
    } else {
      phase = TournamentPhase.upcoming;
      label = 'COMING SOON';
    }
    statuses[conf] = TournamentStatus(
      phase: phase,
      label: label,
      championId: champion,
    );
  }

  // The player's next fixture in each competition, for "up next" on the tiles.
  final now = career.inGameDate;
  Fixture? nextWhere(bool Function(String? round) match) {
    final upcoming =
        fixtures.where((f) => !f.played && match(f.round)).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    for (final f in upcoming) {
      if (!f.date.isBefore(now)) return f;
    }
    return upcoming.isEmpty ? null : upcoming.first;
  }

  const wcRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
  final nextMatches = <Confederation?, Fixture?>{
    // World Cup: qualifying (round null) or any finals round.
    null: nextWhere((r) => r == null || wcRounds.contains(r)),
  };
  // The player's continental cup: any 'C'-prefixed round.
  if (playerConf != null) {
    nextMatches[playerConf] = nextWhere((r) => r != null && r.startsWith('C'));
  }

  final playerGroup = await comp.groupTableForNation(careerId, career.nationId);
  final worldCupHostId = WorldCupHosts.hostFor(
    year: CareerService.worldCupYear(career.cyclePointer),
    nations: nations.values.toList(),
    seed: career.rngSeed,
  );

  // Nations Cup: the manager's own league. It only becomes "live" once its
  // group games actually start (after the continental finals) — before then
  // it's upcoming ("after the Euro"), not in progress.
  final ncTiers = await ref.watch(careerRepositoryProvider).nationsCupTiers(
        careerId,
      );
  final ncLeague = String.fromCharCode(65 + (ncTiers[career.nationId] ?? 0));
  TournamentStatus? nationsCup;
  if (await comp.hasTournament(careerId, CompetitionKind.nationsLeague)) {
    final ncGroupFx = await comp.fixturesByRound(
      careerId,
      'NGROUP',
      kind: CompetitionKind.nationsLeague,
    );
    final started = ncGroupFx.any((f) => f.hasResult);
    final champ = await _knockoutWinner(comp, careerId, 'NFINAL',
        CompetitionKind.nationsLeague);
    // Before this cycle's cup starts (it follows the Euro), browse past winners
    // — mirroring how the World Cup and continental tiles read out of season.
    nationsCup = TournamentStatus(
      phase: champ != null
          ? TournamentPhase.decided
          : started
              ? TournamentPhase.live
              : TournamentPhase.history,
      label: champ != null
          ? 'CHAMPIONS'
          : started
              ? 'LEAGUE $ncLeague'
              : 'PAST WINNERS',
      championId: champ,
    );
  }

  // Continental Clash (Finalissima): the champions-of-champions one-off.
  TournamentStatus? continentalClash;
  if (await comp.hasTournament(careerId, CompetitionKind.finalissima)) {
    final champ = await _knockoutWinner(comp, careerId, 'FFINAL',
        CompetitionKind.finalissima);
    continentalClash = TournamentStatus(
      phase: champ != null ? TournamentPhase.decided : TournamentPhase.live,
      label: champ != null ? 'DECIDED' : 'IN PROGRESS',
      championId: champ,
    );
  }

  return TournamentsOverview(
    statuses: statuses,
    nations: nations,
    playerConfederation: playerConf,
    nextMatches: nextMatches,
    playerGroup: playerGroup,
    worldCupHostId: worldCupHostId,
    nationsCup: nationsCup,
    nationsCupLeague: ncLeague,
    continentalClash: continentalClash,
  );
});

/// The winner of a single-fixture [round] once it's played, else null.
Future<int?> _knockoutWinner(
  CompetitionRepository comp,
  int careerId,
  String round,
  CompetitionKind kind,
) async {
  final fx = await comp.fixturesByRound(careerId, round, kind: kind);
  if (fx.isEmpty || !fx.first.hasResult) return null;
  final f = fx.first;
  return f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
}
