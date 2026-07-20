import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// A nation's authentic first-name / surname pools.
typedef _NamePool = ({List<String> first, List<String> sur});

/// The no-op namer (leaves a player untouched).
Player _identity(Player p) => p;

/// Drift-backed [PlayerRepository].
///
/// The bundled `players.json` carries only placeholder names, so every player's
/// name is (re)assigned from `country_names.json` — the curated per-nation
/// pools. Names are unique within a nation (no two share a first + surname at
/// once) and vary per save, yet stay stable for a given player id.
class DriftPlayerRepository implements PlayerRepository {
  DriftPlayerRepository(this._db);

  final AppDatabase _db;

  static const _namesAsset = 'assets/data/country_names.json';

  /// Per-nation name pools, loaded from the asset once.
  Map<int, _NamePool>? _namePools;

  /// Shuffled first+surname combinations per (nation, save), cached so repeated
  /// lookups don't rebuild the (large) list.
  final Map<(int, int), List<String>> _comboCache = {};

  @override
  Future<List<Player>> byNation(
    int nationId, {
    int agingYears = 0,
    int saveSeed = 0,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) async {
    final seeded = await _seededRows(nationId);
    // `overall` is position-weighted and derived (not a column), so build the
    // aged pool (seeded survivors + newgen intakes) and order in Dart.
    final pool = PlayerLifecycle.poolAt(
      seeded,
      nationId,
      agingYears,
      youthBonusByCycle: youthBonusByCycle,
      careerStartsByPlayer: careerStartsByPlayer,
    )..sort((a, b) => b.overall.compareTo(a.overall));
    final name = await _namerFor(nationId, seeded, saveSeed);
    return [for (final p in pool) _withClub(name(p), saveSeed)];
  }

  /// Attaches the player's (cosmetic) club and its country, derived from their
  /// current overall + id + save seed — layered on like the namer.
  Player _withClub(Player p, int saveSeed) {
    final c = ClubService.clubForSeed(p, saveSeed);
    return p.copyWith(club: c.name, clubCountry: c.country);
  }

  @override
  Future<List<Player>> all() async {
    final rows = await _db.select(_db.players).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Player?> byId(
    int id, {
    int agingYears = 0,
    int saveSeed = 0,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) async {
    if (PlayerLifecycle.isNewgenId(id)) {
      final nationId = PlayerLifecycle.nationIdOf(id);
      final seeded = await _seededRows(nationId);
      final p = PlayerLifecycle.newgenById(
        seeded,
        id,
        agingYears,
        youthBonusByCycle: youthBonusByCycle,
        careerStartsByPlayer: careerStartsByPlayer,
      );
      if (p == null) return null;
      return _withClub((await _namerFor(nationId, seeded, saveSeed))(p), saveSeed);
    }
    final row = await (_db.select(_db.players)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final p = row?.toDomain();
    // Identity lookups resolve a player even once they've retired out of the
    // selectable pool — a retired legend still has a name and a record.
    if (p == null) return null;
    final aged = PlayerLifecycle.withCareerDev(
      PlayerAging.agedYears(p, agingYears),
      careerStartsByPlayer[id] ?? 0,
    );
    final seeded = await _seededRows(p.nationId);
    return _withClub(
      (await _namerFor(p.nationId, seeded, saveSeed))(aged),
      saveSeed,
    );
  }

  /// The nation's base (cycle-0) seeded rows, unaged.
  Future<List<Player>> _seededRows(int nationId) async {
    final rows = await (_db.select(_db.players)
          ..where((t) => t.nationId.equals(nationId)))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  /// Loads the per-nation name pools from the bundled asset (once). Falls back
  /// to an empty map when the asset isn't available (e.g. pure unit tests).
  Future<Map<int, _NamePool>> _pools() async {
    if (_namePools != null) return _namePools!;
    try {
      final raw = jsonDecode(await rootBundle.loadString(_namesAsset))
          as Map<String, Object?>;
      _namePools = {
        for (final e in raw.entries)
          int.parse(e.key): (
            first: ((e.value! as Map)['first'] as List).cast<String>(),
            sur: ((e.value! as Map)['sur'] as List).cast<String>(),
          ),
      };
    } on Object {
      _namePools = {};
    }
    return _namePools!;
  }

  /// Builds a namer that assigns every player of [nationId] a unique name from
  /// the nation's pool. [seeded] gives the nation's stored rows (to rank the
  /// base + fringe players); a 0 [saveSeed] (or a missing pool) leaves names
  /// untouched.
  Future<Player Function(Player)> _namerFor(
    int nationId,
    List<Player> seeded,
    int saveSeed,
  ) async {
    if (saveSeed == 0) return _identity;
    final pool = (await _pools())[nationId];
    if (pool == null || pool.first.isEmpty || pool.sur.isEmpty) {
      return _identity;
    }
    // A save-specific shuffle of every first+surname combination, so each save
    // fields a distinct set drawn from the SAME pool.
    final combos = _comboCache[(nationId, saveSeed)] ??= SeededRng(
      saveSeed ^ (nationId * 0x9E3779B1) ^ 0x5F5E,
    ).shuffled([
      for (final f in pool.first)
        for (final s in pool.sur) '$f $s',
    ]);
    if (combos.isEmpty) return _identity;

    // A stable, distinct index for every player: stored rows (base + fringe)
    // ranked by id, then newgens continuing past them by their sequence — so no
    // two players ever land on the same combination while any save is active.
    final storedIds = [for (final p in seeded) p.id]..sort();
    final rank = {for (var i = 0; i < storedIds.length; i++) storedIds[i]: i};
    final storedCount = storedIds.length;

    Player named(Player p) {
      final index = PlayerLifecycle.isNewgenId(p.id)
          ? storedCount + PlayerLifecycle.newgenSequence(p.id)
          : (rank[p.id] ?? 0);
      return p.copyWith(name: combos[index % combos.length]);
    }

    return named;
  }
}
