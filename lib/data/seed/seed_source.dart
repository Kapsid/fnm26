import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Supplies the initial reference data (nations + players) used to populate the
/// database on first run.
///
/// Abstracted so the seeding logic can be unit-tested with an in-memory source,
/// independent of asset/IO loading.
abstract interface class SeedSource {
  /// The nations to seed.
  Future<List<Nation>> nations();

  /// The players to seed.
  Future<List<Player>> players();
}

/// A [SeedSource] that reads bundled JSON assets.
class AssetSeedSource implements SeedSource {
  AssetSeedSource(this._bundle);

  final AssetBundle _bundle;

  static const _nationsAsset = 'assets/data/nations.json';
  static const _playersAsset = 'assets/data/players.json';
  static const _namesAsset = 'assets/data/country_names.json';

  @override
  Future<List<Nation>> nations() async {
    final raw = await _bundle.loadString(_nationsAsset);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList(growable: false);
  }

  @override
  Future<List<Player>> players() async {
    final raw = await _bundle.loadString(_playersAsset);
    final list = jsonDecode(raw) as List<dynamic>;
    final base =
        list.map((e) => Player.fromJson(e as Map<String, Object?>)).toList();
    // Per-nation name pools for culturally-plausible generated players.
    final namesRaw = jsonDecode(await _bundle.loadString(_namesAsset))
        as Map<String, Object?>;
    final namesByNation = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    // Assign clubs and pad each nation into a deeper, scoutable pool.
    return PoolGenerator.expand(base, namesByNation: namesByNation);
  }
}

/// A trivial in-memory [SeedSource], primarily for tests.
class InMemorySeedSource implements SeedSource {
  InMemorySeedSource({required this.nationList, required this.playerList});

  final List<Nation> nationList;
  final List<Player> playerList;

  @override
  Future<List<Nation>> nations() async => nationList;

  @override
  Future<List<Player>> players() async => playerList;
}
