import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/repositories/seed_ranking_repository.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// Draw-watched marker kind (per career, per cycle) recording that this
/// cycle's World Cup field is cut with the hosts' places taken out of their
/// own confederations' allocations (see [WorldCupFinals.hostBerths]).
///
/// Before 1.0.7 a host instead replaced the weakest-ranked qualifier in the
/// whole world, which was nearly always a small confederation's group winner
/// (the reported case: Palestine won its Asian group and did not go). A cycle
/// whose play-off or finals draw was already made under that rule must keep
/// reading it, or the bracket and qualifying tables would contradict the
/// tournament actually being played. Every other cycle, including one still in
/// qualifying when the save is opened in 1.0.7, is repaired: nothing about the
/// qualifying ladder is stored, so the right cut is simply computed from here
/// on.
const wcHostBerthsKind = 'wcHostBerths';

/// The places each confederation gives up to this cycle's World Cup hosts, or
/// an empty map for a cycle still on the old rule (see [wcHostBerthsKind]).
///
/// [lock] stamps the marker when the new rule applies. The play-off and the
/// finals draw pass it, just before they write the snapshots that would
/// otherwise mark the cycle as an old one.
Future<Map<Confederation, int>> resolveWorldCupHostBerths({
  required CompetitionRepository comp,
  required SeedRankingRepository seedRanks,
  required Career career,
  required Map<int, Nation> nations,
  required Map<Confederation, List<List<GroupStanding>>> byConfederation,
  bool lock = false,
}) async {
  final careerId = career.id;
  final cycle = career.cyclePointer;
  if (!await comp.hasWatchedDraw(careerId, cycle, wcHostBerthsKind)) {
    // Already decided under the old rule: the play-off was seeded, or the
    // finals were drawn, before this cycle knew about host places.
    final decided =
        (await seedRanks.forCycle(
          careerId,
          drawSeedCycle(cycle, drawSlotWorldCupPlayoff),
        )).isNotEmpty ||
        (await seedRanks.forCycle(
          careerId,
          drawSeedCycle(cycle, drawSlotWorldCupFinals),
        )).isNotEmpty ||
        (await comp.finalsGroupTables(careerId)).isNotEmpty;
    if (decided) return const {};
    if (lock) await comp.markDrawWatched(careerId, cycle, wcHostBerthsKind);
  }
  final hosts = WorldCupHosts.hostsFor(
    year: CareerService.worldCupYear(cycle),
    nations: nations.values.toList(),
    seed: career.rngSeed,
  );
  return WorldCupFinals.hostBerths(
    hosts: hosts,
    confederationOf: (id) => nations[id]?.confederation,
    byConfederation: byConfederation,
  );
}

/// [resolveWorldCupHostBerths] for a screen's provider: the qualifying
/// tables, the play-off bracket and the hub all cut the ladder with it.
///
/// A plain read rather than a provider of its own on purpose: the hosts change
/// with the cycle, and a cached family would go on answering for the last one
/// that was.
Future<Map<Confederation, int>> worldCupHostBerthsFor(
  Ref ref,
  int careerId,
) async {
  final career = await ref.read(careerRepositoryProvider).byId(careerId);
  if (career == null) return const {};
  final comp = ref.read(competitionRepositoryProvider);
  final nations = {
    for (final n
        in await ref.read(nationRepositoryProvider).forCareer(careerId))
      n.id: n,
  };
  final grouped = <Confederation, List<List<GroupStanding>>>{};
  for (final t in await comp.allGroupTablesByConfederation(careerId)) {
    (grouped[t.confederation] ??= []).add(t.standings);
  }
  return resolveWorldCupHostBerths(
    comp: comp,
    seedRanks: ref.read(seedRankingRepositoryProvider),
    career: career,
    nations: nations,
    byConfederation: grouped,
  );
}
