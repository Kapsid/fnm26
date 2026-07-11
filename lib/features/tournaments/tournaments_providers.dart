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
  });

  final Map<Confederation?, TournamentStatus> statuses;
  final Map<int, Nation> nations;
  final Confederation? playerConfederation;

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

  // World Championship (always available).
  final worldChampion = await comp.worldChampion(careerId);
  final hasFinals = await comp.hasFinals(careerId);
  statuses[null] = TournamentStatus(
    phase: worldChampion != null
        ? TournamentPhase.decided
        : TournamentPhase.live,
    label: worldChampion != null
        ? 'CHAMPIONS'
        : hasFinals
            ? 'FINALS'
            : 'QUALIFYING',
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
    final liveThisCycle = isPlayerConf && hasContinental;
    final hasHistory = honourComps.contains(name);

    final TournamentPhase phase;
    final String label;
    int? champion;
    if (liveThisCycle) {
      phase = continentalChampion != null
          ? TournamentPhase.decided
          : TournamentPhase.live;
      label = continentalChampion != null ? 'CHAMPIONS' : 'IN PROGRESS';
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
  final fixtures = await comp.fixturesForNation(careerId, career.nationId);
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

  return TournamentsOverview(
    statuses: statuses,
    nations: nations,
    playerConfederation: playerConf,
    nextMatches: nextMatches,
    playerGroup: playerGroup,
    worldCupHostId: worldCupHostId,
  );
});
