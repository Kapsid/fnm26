import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';

/// The player's own matches (qualifiers + finals), in date order.
class ResultsData {
  const ResultsData({
    required this.fixtures,
    required this.nations,
    required this.playerNationId,
  });

  /// The player's fixtures, chronological.
  final List<Fixture> fixtures;
  final Map<int, Nation> nations;
  final int playerNationId;
}

final AutoDisposeFutureProviderFamily<ResultsData?, int> resultsProvider =
    FutureProvider.autoDispose.family<ResultsData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;

  // Only the player's own matches (qualifiers + any finals games).
  final fixtures = await ref
      .watch(competitionRepositoryProvider)
      .fixturesForNation(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return ResultsData(
    fixtures: fixtures,
    nations: nations,
    playerNationId: career.nationId,
  );
});
