import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_profanity.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

/// Every nation a career created now can take (seeding the database first if
/// needed), ordered by ranking: the new-career world (see
/// `NationRepository.newCareerWorld`).
final nationsProvider = FutureProvider<List<Nation>>((ref) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  return ref.watch(nationRepositoryProvider).newCareerWorld();
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
/// `overall` is the mean of its best eleven in the seed-free pool (no save
/// exists yet, so there is no seed to read). A save's day one carries these
/// same world-sim ratings: its seed only renames the players and gives them
/// clubs, and club minutes weigh only career starts, of which there are none
/// yet. So this is the number the save opens on. `tier` is the
/// fifth of the world that puts it in, 5 the strongest fifth. `best` is its
/// highest-rated player; only his position, age and rating are shown, never
/// his name, because every save names its players afresh.
typedef NationStrength = ({int overall, int tier, Player best});

/// Every nation of the new-career world with its day-one pool (best first,
/// no save seed: no save exists yet), by nation id.
final FutureProvider<Map<int, List<Player>>> _dayOnePoolsProvider =
    FutureProvider<Map<int, List<Player>>>((ref) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final nations = await ref
          .watch(nationRepositoryProvider)
          .newCareerWorld();
      final players = ref.watch(playerRepositoryProvider);
      return {for (final n in nations) n.id: await players.byNation(n.id)};
    });

/// [NationStrength] of every nation with players, by nation id. The tablet's
/// nation pick, new game and out-of-work offers read it; the phone does not.
final FutureProvider<Map<int, NationStrength>> nationStrengthsProvider =
    FutureProvider<Map<int, NationStrength>>(
      (ref) async => _strengthsOf(await ref.watch(_dayOnePoolsProvider.future)),
    );

/// [NationStrength] of each pool in [pools] that has players: each pool is
/// best first.
Map<int, NationStrength> _strengthsOf(Map<int, List<Player>> pools) {
  final overall = <int, int>{};
  final best = <int, Player>{};
  for (final e in pools.entries) {
    if (e.value.isEmpty) continue;
    overall[e.key] = squadOverall(e.value);
    best[e.key] = e.value.first;
  }
  final tiers = strengthTiers(overall);
  return {
    for (final id in overall.keys)
      id: (overall: overall[id]!, tier: tiers[id]!, best: best[id]!),
  };
}

/// The nation pick as world pack [packId] has it: what a career started on
/// that pack opens on.
typedef _PackPick = ({
  List<Nation> nations,
  Map<int, NationStrength> strengths,
});

/// [_PackPick] of pack [packId]; null when the pack is gone or cannot be
/// read (the pick then shows the game's own world, and Start refuses it).
///
/// Its nations carry the pack's names and the starting ranks a career on it
/// is given ([PackRanking.startingRanks], as `CareerService.create` works
/// them out), ordered by them. Its strengths read each nation's pack squad
/// and fixed pool on day one (exactly as the editor left them), with the
/// game's own core, fringe and youth for whatever the pack leaves alone, as
/// the career's pools do. The flag stays the real
/// nation's: a pack's code is a label, never the key for the flag.
///
/// AutoDispose and following [worldPacksProvider], which every pack write
/// invalidates: an edit made since is seen.
final AutoDisposeFutureProviderFamily<_PackPick?, int> _packPickProvider =
    FutureProvider.autoDispose.family<_PackPick?, int>((ref, packId) async {
      await ref.watch(worldPacksProvider.future);
      final base = await ref.watch(nationsProvider.future);
      final WorldPack? pack;
      try {
        // As the career will show it: a name the game does not show masked.
        final stored = await ref
            .watch(worldPackRepositoryProvider)
            .load(packId);
        pack = stored == null ? null : maskedForPlay(stored);
      } on FormatException {
        return null;
      }
      if (pack == null) return null;
      final ranks = PackRanking.startingRanks(
        baseRanks: {for (final n in base) n.id: n.ranking},
        defaultStrength: await ref
            .watch(worldPackServiceProvider)
            .defaultStrength(),
        packStrength: PackRanking.squadStrengths(pack.squads),
      );
      final order = {for (var i = 0; i < base.length; i++) base[i].id: i};
      final nations =
          [
            for (final n in base)
              n.copyWith(
                name:
                    ActiveWorld.textOrNull(pack.nations[n.id]?.name) ?? n.name,
                ranking: ranks[n.id] ?? n.ranking,
              ),
          ]..sort((a, b) {
            final c = a.ranking.compareTo(b.ranking);
            return c != 0 ? c : order[a.id]!.compareTo(order[b.id]!);
          });

      final pools = await ref.watch(_dayOnePoolsProvider.future);
      Player dayOne(int nationId, PackPlayer p) => Player(
        id: p.id,
        nationId: nationId,
        name: p.name,
        age: p.age,
        position: p.position,
        attributes: p.attributes,
        club: p.club ?? ClubService.freeAgent,
        clubCountry: p.clubCountry ?? '',
      );
      final packPools = <int, List<Player>>{
        for (final MapEntry(key: n, value: game) in pools.entries)
          n: switch ((pack.squads[n], pack.pools[n])) {
            (null, null) => game,
            (final squad, final pool) => [
              // The pack's squad, or the game's core where it has none.
              if (squad != null)
                for (final p in squad) dayOne(n, p)
              else
                for (final p in game)
                  if (p.id < PoolGenerator.firstFringeId) p,
              // The pack's fixed pool in place of the game's fringe (as
              // the pool reads, from seventeen), or the game's fringe where
              // it fixes none. The game's youth intakes come up either way.
              if (pool != null) ...[
                for (final p in pool)
                  if (p.age >= PlayerLifecycle.seniorMinAge) dayOne(n, p),
                for (final p in game)
                  if (PlayerLifecycle.isNewgenId(p.id)) p,
              ] else
                for (final p in game)
                  if (p.id >= PoolGenerator.firstFringeId) p,
            ]..sort((a, b) => b.overall.compareTo(a.overall)),
          },
      };
      return (nations: nations, strengths: _strengthsOf(packPools));
    });

/// The nations the nation pick lists for world [packId] (null: the game's
/// own, exactly [nationsProvider]), ordered by ranking. The pick, its
/// search, Random team, From the bottom, the preview and New Game all read
/// this, keyed on `newGameWorldProvider`, so the chip changes all of them.
final AutoDisposeFutureProviderFamily<List<Nation>, int?>
newGameNationsProvider = FutureProvider.autoDispose.family<List<Nation>, int?>(
  (ref, packId) async {
    if (packId != null) {
      final pick = await ref.watch(_packPickProvider(packId).future);
      if (pick != null) return pick.nations;
    }
    return ref.watch(nationsProvider.future);
  },
);

/// [nationStrengthsProvider] for world [packId] (null: exactly it).
final AutoDisposeFutureProviderFamily<Map<int, NationStrength>, int?>
newGameStrengthsProvider = FutureProvider.autoDispose
    .family<Map<int, NationStrength>, int?>((ref, packId) async {
      if (packId != null) {
        final pick = await ref.watch(_packPickProvider(packId).future);
        if (pick != null) return pick.strengths;
      }
      return ref.watch(nationStrengthsProvider.future);
    });

/// [starPlayersProvider] for world [packId] (null: exactly it): on a pack,
/// each nation's best player as its pool reads on day one.
final AutoDisposeFutureProviderFamily<Map<int, Player>, int?>
newGameStarPlayersProvider = FutureProvider.autoDispose
    .family<Map<int, Player>, int?>((ref, packId) async {
      if (packId != null) {
        final pick = await ref.watch(_packPickProvider(packId).future);
        if (pick != null) {
          return {for (final e in pick.strengths.entries) e.key: e.value.best};
        }
      }
      return ref.watch(starPlayersProvider.future);
    });

/// Nation [nationId] as New Game shows it for world [packId] (null: the
/// game's own, exactly `nationByIdProvider`).
final AutoDisposeFutureProviderFamily<Nation?, (int?, int)>
newGameNationProvider = FutureProvider.autoDispose.family<Nation?, (int?, int)>(
  (ref, key) async {
    final (packId, nationId) = key;
    if (packId != null) {
      final nations = await ref.watch(newGameNationsProvider(packId).future);
      for (final n in nations) {
        if (n.id == nationId) return n;
      }
    }
    await ref.watch(seedLoaderProvider).ensureSeeded();
    return ref.watch(nationRepositoryProvider).byId(nationId);
  },
);

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
