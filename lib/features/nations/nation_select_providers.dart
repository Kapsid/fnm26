import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

/// All nations (seeding the database first if needed), ordered by ranking.
final nationsProvider = FutureProvider<List<Nation>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  return ref.watch(nationRepositoryProvider).all();
});

/// The highest-overall ("star") player for each nation, keyed by nation id.
final starPlayersProvider = FutureProvider<Map<int, Player>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final players = await ref.watch(playerRepositoryProvider).all();
  final byNation = <int, Player>{};
  for (final p in players) {
    final current = byNation[p.nationId];
    if (current == null || p.overall > current.overall) {
      byNation[p.nationId] = p;
    }
  }
  return byNation;
});

/// The continental tab currently selected on the nation-select screen.
final selectedConfederationProvider = StateProvider<Confederation>(
  (_) => Confederation.europe,
);

/// The current search query on the nation-select screen.
final nationSearchProvider = StateProvider<String>((_) => '');

/// A nation as it stands before any career exists.
///
/// `overall` is the mean of its best eleven in the seed-free pool, the one
/// every save starts from before its own club minutes move it by a point or
/// two (no save exists yet, so there is no seed to read). `tier` is the
/// fifth of the world that puts it in, 5 the strongest fifth. `best` is its
/// highest-rated player; only his position, age and rating are shown, never
/// his name, because every save names its players afresh.
typedef NationStrength = ({int overall, int tier, Player best});

/// [NationStrength] of every nation with players, by nation id. The tablet's
/// nation pick, new game and out-of-work offers read it; the phone does not.
final FutureProvider<Map<int, NationStrength>> nationStrengthsProvider =
    FutureProvider<Map<int, NationStrength>>((ref) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final nations = await ref.watch(nationRepositoryProvider).all();
      final players = ref.watch(playerRepositoryProvider);
      final overall = <int, int>{};
      final best = <int, Player>{};
      for (final n in nations) {
        // Best first. No save seed: no save exists yet.
        final pool = await players.byNation(n.id);
        if (pool.isEmpty) continue;
        overall[n.id] = squadOverall(pool);
        best[n.id] = pool.first;
      }
      final tiers = strengthTiers(overall);
      return {
        for (final id in overall.keys)
          id: (overall: overall[id]!, tier: tiers[id]!, best: best[id]!),
      };
    });

/// Strength out of five for each nation in [overalls] (nation id to squad
/// overall): which fifth of the field it falls in, 5 for the strongest
/// fifth. Nations level on overall share the tier of the first of them, so
/// two equal sides never read as different strengths.
Map<int, int> strengthTiers(Map<int, int> overalls) {
  final sorted = overalls.values.toList()..sort((a, b) => b.compareTo(a));
  final firstAt = <int, int>{};
  for (var i = 0; i < sorted.length; i++) {
    firstAt.putIfAbsent(sorted[i], () => i);
  }
  return {
    for (final e in overalls.entries)
      e.key: 5 - firstAt[e.value]! * 5 ~/ sorted.length,
  };
}
