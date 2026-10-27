import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';

/// The world of one career: every nation it was generated from, ordered by
/// ranking (see `NationRepository.forCareer`). For a normal career this is
/// exactly the base world; a career that includes a dormant nation sees it
/// in place of the nation it replaces. Anything inside a career that lists
/// or looks up nations reads this, never `nationsProvider`.
final AutoDisposeFutureProviderFamily<List<Nation>, int> careerNationsProvider =
    FutureProvider.autoDispose.family<List<Nation>, int>(
      (ref, careerId) =>
          ref.watch(nationRepositoryProvider).forCareer(careerId),
    );

/// [careerNationsProvider] as an id lookup.
final AutoDisposeFutureProviderFamily<Map<int, Nation>, int>
careerNationsByIdProvider = FutureProvider.autoDispose
    .family<Map<int, Nation>, int>((ref, careerId) async {
      final nations = await ref.watch(careerNationsProvider(careerId).future);
      return {for (final n in nations) n.id: n};
    });

/// Every stored nation, dormant ones included, by id. A dictionary for
/// screens outside any one career (the saves list); never a world.
final knownNationsByIdProvider = FutureProvider<Map<int, Nation>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final nations = await ref.watch(nationRepositoryProvider).everyKnown();
  return {for (final n in nations) n.id: n};
});
