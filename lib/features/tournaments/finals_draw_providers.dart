import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The finals draw recomputed for the draw ceremony. It reuses the exact same
/// finalist selection, seed and ranking as the season service so the ceremony
/// always matches the persisted draw.
class FinalsDrawData {
  const FinalsDrawData({
    required this.draw,
    required this.nations,
    required this.playerNationId,
    required this.potByNation,
    required this.cycle,
    required this.alreadyWatched,
  });

  final FinalsDraw draw;
  final Map<int, Nation> nations;

  /// The player's nation, highlighted throughout the ceremony.
  final int playerNationId;

  /// Seeding pot (1-4) for each qualifier, so the pots can be shown pre-draw.
  final Map<int, int> potByNation;

  /// The cycle this draw belongs to (for recording that it has been watched).
  final int cycle;

  /// Whether the ceremony has already played once (then it is not re-animated).
  final bool alreadyWatched;
}

/// The draw-kind key recording that the World Cup finals draw was watched.
const worldCupDrawKind = 'worldCupFinals';

final AutoDisposeFutureProviderFamily<FinalsDrawData?, int>
finalsDrawProvider =
    FutureProvider.autoDispose.family<FinalsDrawData?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  if (!await comp.allQualifyingPlayed(careerId)) return null;

  final byConfederation = await comp.allGroupTablesByConfederation(careerId);
  final grouped = <Confederation, List<List<GroupStanding>>>{};
  for (final t in byConfederation) {
    (grouped[t.confederation] ??= []).add(t.standings);
  }

  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  // The pots use the live ranking snapshotted when the finals draw was
  // generated (post-qualifying), so the ceremony reproduces the real pots.
  final rankingById = await ref.watch(
    seedRankByIdProvider((
      careerId: careerId,
      cycle: drawSeedCycle(career.cyclePointer, drawSlotWorldCupFinals),
    )).future,
  );
  final year = CareerService.worldCupYear(career.cyclePointer);
  final hosts = WorldCupHosts.hostsFor(
    year: year,
    nations: nations.values.toList(),
    seed: career.rngSeed,
  );

  final qualifiers = WorldCupFinals.selectFinalists(
    byConfederation: grouped,
    rankingById: rankingById,
    hosts: hosts,
    playoffRng: SeededRng(
      career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0,
    ),
  );
  final draw = WorldCupFinals.drawGroups(
    qualifierIds: qualifiers,
    rankingById: rankingById,
    rngSeed: career.rngSeed ^ (career.cyclePointer * 0x2D31),
    hosts: hosts,
  );
  if (draw.groups.isEmpty) return null;

  // Reconstruct the seeding pots (top-ranked → pot 1) for the pre-draw view,
  // mirroring drawGroups exactly: every host is forced to the top of pot 1 so
  // the pots shown match where teams are actually drawn.
  final groupCount = qualifiers.length ~/ 4;
  final seeded = [...qualifiers]..sort(
      (a, b) => (rankingById[a] ?? 9999).compareTo(rankingById[b] ?? 9999),
    );
  final activeHosts = [
    for (final h in hosts)
      if (seeded.contains(h)) h,
  ].take(groupCount).toList();
  for (final h in activeHosts.reversed) {
    seeded
      ..remove(h)
      ..insert(0, h);
  }
  final potByNation = {
    for (var i = 0; i < seeded.length; i++) seeded[i]: (i ~/ groupCount) + 1,
  };

  final alreadyWatched = await comp.hasWatchedDraw(
    careerId,
    career.cyclePointer,
    worldCupDrawKind,
  );

  return FinalsDrawData(
    draw: draw,
    nations: nations,
    playerNationId: career.nationId,
    potByNation: potByNation,
    cycle: career.cyclePointer,
    alreadyWatched: alreadyWatched,
  );
});
