import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';

/// The finals draw recomputed for the draw ceremony (deterministic — matches
/// the persisted draw because it uses the same qualifiers, rankings and seed).
class FinalsDrawData {
  const FinalsDrawData({required this.draw, required this.nations});

  final FinalsDraw draw;
  final Map<int, Nation> nations;
}

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
  final qualifiers = <int>[];
  for (final entry in grouped.entries) {
    final berths =
        QualificationFormat.forConfederation(entry.key).finalsBerths;
    qualifiers.addAll(Qualification.qualifiers(entry.value, berths));
  }

  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final draw = WorldCupFinals.drawGroups(
    qualifierIds: qualifiers,
    rankingById: {for (final n in nations.values) n.id: n.ranking},
    rngSeed: career.rngSeed,
  );
  if (draw.groups.isEmpty) return null;
  return FinalsDrawData(draw: draw, nations: nations);
});
