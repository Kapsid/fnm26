import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// The manager's nation's legends: an all-time XI and a hall of fame, ranked
/// across every cycle in the save.
typedef LegendsView = ({
  String nationName,
  List<RankedLegend> allTimeXi,
  List<RankedLegend> hallOfFame,
});

final AutoDisposeFutureProviderFamily<LegendsView?, int> legendsProvider =
    FutureProvider.autoDispose.family<LegendsView?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final playerRepo = ref.watch(playerRepositoryProvider);
  final nationId = career.nationId;
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };

  // Candidate pool: long-servers, prolific scorers and top creators — the
  // players any legends table is drawn from.
  final caps = await comp.nationTopAppearances(careerId, nationId, limit: 60);
  final scorers = await comp.nationTopScorers(careerId, nationId, limit: 40);
  final assisters = await comp.nationTopAssists(careerId, nationId, limit: 30);
  final ids = <int>{
    ...caps.map((c) => c.playerId),
    ...scorers.map((s) => s.playerId),
    ...assisters.map((a) => a.playerId),
  };
  if (ids.isEmpty) {
    return (
      nationName: nations[nationId]?.name ?? 'Your nation',
      allTimeXi: const <RankedLegend>[],
      hallOfFame: const <RankedLegend>[],
    );
  }

  final stats = <LegendStat>[];
  for (final id in ids) {
    final career0 = await comp.playerCareerStats(careerId, id);
    if (career0 == null || career0.caps < 3) continue; // needs a real record
    final player = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
    );
    if (player == null) continue;
    stats.add((
      playerId: id,
      name: player.name,
      position: player.position,
      caps: career0.caps,
      goals: career0.goals,
      assists: career0.assists,
      motm: career0.motm,
      avgRating: career0.avgRating,
    ));
  }

  final ranked = Legends.rank(stats);
  return (
    nationName: nations[nationId]?.name ?? 'Your nation',
    allTimeXi: Legends.allTimeXi(ranked),
    hallOfFame: ranked.take(20).toList(),
  );
});
