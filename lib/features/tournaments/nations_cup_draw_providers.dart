import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';

/// Watched-draw key for the Nations Cup group draw (one per cycle).
const nationsCupDrawKind = 'nationsCupDraw';

/// One drawn Nations Cup group for the ceremony: its name and the nations in
/// it, ordered by pot (strongest first, so pot 1 is the seeds).
typedef NcDrawGroup = ({String name, List<int> nationIds});

/// The Nations Cup group draw recomputed for the ceremony. It reads the already
/// persisted groups of the manager's own league and orders each by world
/// ranking into pots, so the shared draw ceremony can reveal them pot by pot.
class NationsCupDrawData {
  const NationsCupDrawData({
    required this.leagueLetter,
    required this.groups,
    required this.nations,
    required this.playerNationId,
    required this.cycle,
    required this.alreadyWatched,
  });

  final String leagueLetter;
  final List<NcDrawGroup> groups;
  final Map<int, Nation> nations;
  final int playerNationId;
  final int cycle;
  final bool alreadyWatched;
}

final AutoDisposeFutureProviderFamily<NationsCupDrawData?, int>
    nationsCupDrawProvider =
    FutureProvider.autoDispose.family<NationsCupDrawData?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final tables = await comp.tournamentGroupTables(
    careerId,
    CompetitionKind.nationsLeague,
  );
  if (tables.isEmpty) return null;

  final tiers =
      await ref.watch(careerRepositoryProvider).nationsCupTiers(careerId);
  final playerTier = tiers[career.nationId] ?? 0;
  final letter = NationsCup.leagueLetter(playerTier);

  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  int rank(int id) => nations[id]?.ranking ?? 9999;

  // Only the manager's own league, its groups in order.
  final leagueTables = [
    for (final t in tables)
      if (t.name.isNotEmpty && t.name[0] == letter) t,
  ]..sort((a, b) => a.name.compareTo(b.name));
  if (leagueTables.isEmpty) return null;

  final groups = <NcDrawGroup>[
    for (final t in leagueTables)
      (
        name: t.name,
        // Order each group by ranking so pot 1 shows the seeds, pot 4 the
        // lowest-ranked — a plausible pot draw of the already-decided groups.
        nationIds: [
          for (final s in t.standings) s.nationId,
        ]..sort((a, b) => rank(a).compareTo(rank(b))),
      ),
  ];

  final alreadyWatched = await comp.hasWatchedDraw(
    careerId,
    career.cyclePointer,
    nationsCupDrawKind,
  );

  return NationsCupDrawData(
    leagueLetter: letter,
    groups: groups,
    nations: nations,
    playerNationId: career.nationId,
    cycle: career.cyclePointer,
    alreadyWatched: alreadyWatched,
  );
});
