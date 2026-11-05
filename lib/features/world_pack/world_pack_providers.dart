import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The save seed of the one fixed name draw every new pack starts from.
///
/// The default world re-draws its players' names per save; a pack stores
/// names, so it takes this one draw (on the pools a career created now
/// reads), the same on every device and every day.
const int kPackDrawSeed = 20261104;

/// The game version a pack made now records.
const String kPackGameVersion = '1.1.0';

/// Players at or above this id are generated fringe (see
/// `PoolGenerator.expand` and the dormant nations' fringe ranges), never the
/// 23 core players `players.json` (or a dormant nation's squad) stores.
const int _firstFringeId = 10000000;

/// One pack as the list of packs shows it.
typedef WorldPackSummary = ({int id, String name, DateTime updatedAt});

final worldPackRepositoryProvider = Provider<WorldPackRepository>(
  (ref) => WorldPackRepository(ref.watch(appDatabaseProvider)),
);

/// The packs on this device, by name.
final worldPacksProvider = FutureProvider<List<WorldPackSummary>>(
  (ref) => ref.watch(worldPackRepositoryProvider).list(),
);

final worldPackServiceProvider = Provider<WorldPackService>(
  (ref) => WorldPackService(
    players: ref.watch(playerRepositoryProvider),
    nations: ref.watch(nationRepositoryProvider),
    packs: ref.watch(worldPackRepositoryProvider),
    onChanged: () => ref.invalidate(worldPacksProvider),
  ),
);

/// Creates, copies and removes world packs.
class WorldPackService {
  WorldPackService({
    required PlayerRepository players,
    required NationRepository nations,
    required WorldPackRepository packs,
    void Function()? onChanged,
  }) : _players = players,
       _nations = nations,
       _packs = packs,
       _onChanged = onChanged ?? _noop;

  final PlayerRepository _players;
  final NationRepository _nations;
  final WorldPackRepository _packs;
  final void Function() _onChanged;

  static void _noop() {}

  /// A new pack named [name] holding the default world a career created now
  /// starts in: the 23 core players of every nation (by id), with names from
  /// the [kPackDrawSeed] draw, their day-one club, attributes and, as
  /// potential, the peak [PlayerLifecycle.peakOverall] gives (never below
  /// the overall he already has). Every override is empty. Returns its id.
  Future<int> createFromDefault(String name) async {
    final id = await _packs.insert(
      WorldPack(
        uuid: _packs.newUuid(),
        name: name,
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: kPackGameVersion,
        squads: await defaultSquads(),
      ),
      const {},
    );
    _onChanged();
    return id;
  }

  /// [PackRanking.strength] of each nation's squad in the default world, as
  /// a new pack stores it ([defaultSquads]): the yardstick a pack's squads
  /// move the starting ranking against.
  Future<Map<int, int>> defaultStrength() async =>
      PackRanking.squadStrengths(await defaultSquads());

  /// The squads [createFromDefault] stores, by nation id.
  Future<Map<int, List<PackPlayer>>> defaultSquads() async {
    final coreIds = <int, List<int>>{};
    for (final p in await _players.all()) {
      if (p.id < _firstFringeId) (coreIds[p.nationId] ??= []).add(p.id);
    }
    final squads = <int, List<PackPlayer>>{};
    for (final nation in await _nations.newCareerWorld()) {
      final pool = {
        for (final p in await _players.byNation(
          nation.id,
          saveSeed: kPackDrawSeed,
          newCareerNames: true,
        ))
          p.id: p,
      };
      final squad = <PackPlayer>[];
      for (final id in (coreIds[nation.id] ?? const <int>[])..sort()) {
        // A veteran the default world retires on day one is not in the
        // pool, but he is one of the stored 23: read him by identity.
        final p =
            pool[id] ??
            await _players.byId(
              id,
              saveSeed: kPackDrawSeed,
              newCareerNames: true,
            );
        if (p == null) continue;
        squad.add(
          PackPlayer(
            id: p.id,
            name: p.name,
            age: p.age,
            position: p.position,
            attributes: p.attributes,
            potential: max(
              p.overall,
              PlayerLifecycle.peakOverall(
                p.id,
                p.position,
                p.attributes,
                p.age,
              ),
            ),
            club: p.club,
            clubCountry: p.clubCountry.isEmpty ? null : p.clubCountry,
          ),
        );
      }
      squads[nation.id] = squad;
    }
    return squads;
  }

  /// Copies pack [id] as a new pack named [name]; returns the copy's id.
  Future<int> duplicate(int id, String name) async {
    final copy = await _packs.duplicate(id, name);
    _onChanged();
    return copy;
  }

  /// Removes pack [id]. Careers started on it keep their own copy.
  Future<void> delete(int id) async {
    await _packs.delete(id);
    _onChanged();
  }
}
