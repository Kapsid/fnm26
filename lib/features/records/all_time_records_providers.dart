import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// One all-time leaderboard entry: a player, their nation, the tally, and
/// whether they are still playing (highlighted in the UI).
typedef AllTimeLeader = ({
  int playerId,
  int nationId,
  String name,
  String nationCode,
  String nationName,
  int value,
  bool active,
});

/// The save's global all-time records — the greatest goalscorers and the
/// most-capped players across EVERY nation, not just the one you manage, plus
/// tournament-scoped leaderboards (most World Cup starts, most cups attended).
typedef AllTimeRecords = ({
  List<AllTimeLeader> topScorers,
  List<AllTimeLeader> mostCaps,
  List<AllTimeLeader> mostWcStarts,
  List<AllTimeLeader> mostCupsAttended,
});

final AutoDisposeFutureProviderFamily<AllTimeRecords?, int>
    allTimeRecordsProvider =
    FutureProvider.autoDispose.family<AllTimeRecords?, int>(
        (ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final playerRepo = ref.watch(playerRepositoryProvider);
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final careerDev = await ref.watch(careerDevBonusProvider(careerId).future);
  final nations = <int, Nation>{
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };

  // Cache lookups: a player can top both charts.
  final cache = <int, ({String name, bool active})>{};
  Future<({String name, bool active})> resolve(int id) async {
    final hit = cache[id];
    if (hit != null) return hit;
    final p = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    return cache[id] = (
      name: p?.name ?? 'Unknown',
      active: p != null && p.age < PlayerLifecycle.retirementAge,
    );
  }

  AllTimeLeader lead(int playerId, int nationId, int value,
      ({String name, bool active}) info) {
    final n = nations[nationId];
    return (
      playerId: playerId,
      nationId: nationId,
      name: info.name,
      nationCode: n?.code ?? '??',
      nationName: n?.name ?? 'Unknown',
      value: value,
      active: info.active,
    );
  }

  // Across every competition in the save — the global, all-competitions chart
  // (each cup also has its own cup-specific all-time scorers on its detail).
  final scorersRaw = await comp.allTimeTopScorers(careerId, limit: 40);
  final capsRaw = await comp.allTimeTopAppearances(careerId, limit: 40);
  // Tournament-scoped: most World Cup finals starts, and most distinct
  // tournaments (World Cup + continental finals) attended.
  final wcStartsRaw = await comp.mostTournamentStarts(
    careerId,
    kind: CompetitionKind.worldCupFinals,
    limit: 10,
  );
  final cupsRaw = await comp.mostTournamentsAttended(
    careerId,
    kinds: {
      CompetitionKind.worldCupFinals,
      CompetitionKind.continentalFinals,
    },
    limit: 10,
  );

  final topScorers = <AllTimeLeader>[
    for (final s in scorersRaw)
      lead(s.playerId, s.nationId, s.goals, await resolve(s.playerId)),
  ];
  final mostCaps = <AllTimeLeader>[
    for (final c in capsRaw)
      lead(c.playerId, c.nationId, c.games, await resolve(c.playerId)),
  ];
  final mostWcStarts = <AllTimeLeader>[
    for (final s in wcStartsRaw)
      lead(s.playerId, s.nationId, s.starts, await resolve(s.playerId)),
  ];
  final mostCupsAttended = <AllTimeLeader>[
    for (final c in cupsRaw)
      lead(c.playerId, c.nationId, c.tournaments, await resolve(c.playerId)),
  ];

  return (
    topScorers: topScorers,
    mostCaps: mostCaps,
    mostWcStarts: mostWcStarts,
    mostCupsAttended: mostCupsAttended,
  );
});
