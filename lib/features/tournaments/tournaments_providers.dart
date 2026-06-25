import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';

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
  });

  final Map<Confederation?, TournamentStatus> statuses;
  final Map<int, Nation> nations;
  final Confederation? playerConfederation;
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

  return TournamentsOverview(
    statuses: statuses,
    nations: nations,
    playerConfederation: playerConf,
  );
});
