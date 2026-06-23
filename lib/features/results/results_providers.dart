import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';

/// All fixtures in a save, grouped by matchday, for the results screen.
class ResultsData {
  const ResultsData({
    required this.byMatchday,
    required this.nations,
    required this.playerNationId,
  });

  /// Matchday number → its fixtures (ascending matchday order via [matchdays]).
  final Map<int, List<Fixture>> byMatchday;
  final Map<int, Nation> nations;
  final int playerNationId;

  List<int> get matchdays => byMatchday.keys.toList()..sort();
}

final AutoDisposeFutureProviderFamily<ResultsData?, int> resultsProvider =
    FutureProvider.autoDispose.family<ResultsData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;

  final fixtures =
      await ref.watch(competitionRepositoryProvider).allFixtures(careerId);
  final byMatchday = <int, List<Fixture>>{};
  for (final f in fixtures) {
    byMatchday.putIfAbsent(f.matchday, () => []).add(f);
  }
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return ResultsData(
    byMatchday: byMatchday,
    nations: nations,
    playerNationId: career.nationId,
  );
});
