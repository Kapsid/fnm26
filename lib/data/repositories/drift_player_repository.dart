import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// A nation's authentic first-name / surname pools.
typedef _NamePool = ({
  List<String> first,
  List<String> sur,

  /// Surnames added to the pool AFTER saves existed.
  ///
  /// Kept apart from [sur] on purpose. A name is drawn by index into a
  /// save-seeded shuffle of the whole first x surname cross product, so
  /// growing that product renames every player of the nation in every save
  /// that already exists. These are spliced into a handful of slots instead —
  /// see `_namerFor`.
  List<String> surLate,
});

/// The no-op namer (leaves a player untouched).
Player _identity(Player p) => p;

/// Drift-backed [PlayerRepository].
///
/// The bundled `players.json` carries only placeholder names, so every player's
/// name is (re)assigned from `country_names.json` — the curated per-nation
/// pools. Names are unique within a nation (no two share a first + surname at
/// once) and vary per save, yet stay stable for a given player id.
class DriftPlayerRepository implements PlayerRepository {
  /// [_seed] supplies the per-nation city lists used to name domestic clubs.
  /// It is injected (rather than read straight from the asset bundle here) so
  /// tests can leave it empty — a hot-path asset read stalls widget tests,
  /// which drive their own async clock.
  DriftPlayerRepository(this._db, [this._seed]);

  final AppDatabase _db;
  final SeedSource? _seed;

  static const _namesAsset = 'assets/data/country_names.json';

  /// Per-nation name pools, loaded from the asset once.
  Map<int, _NamePool>? _namePools;

  /// Per-nation city lists (biggest first), loaded once — used to name a
  /// domestic club for a country with no curated league.
  Map<int, List<String>>? _cities;

  /// Nation id → FIFA code, cached; tells the club assignment which country is
  /// "home" for a player.
  Map<int, String>? _codes;

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
    int minAge = 17,
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
      minAge: minAge,
      // Only the manager's own pool feels club minutes; the world simulation
      // passes no seed and is byte-identical to before.
      clubSeed: saveSeed,
    )..sort((a, b) => b.overall.compareTo(a.overall));
    final name = await _namerFor(nationId, seeded, saveSeed);
    final home = await _home(nationId);
    return [
      for (final p in pool)
        _withClub(
          name(p),
          saveSeed,
          homeCode: home.code,
          homeCities: home.cities,
        ),
    ];
  }

  @override
  Future<List<Player>> youthByNation(
    int nationId, {
    int agingYears = 0,
    int saveSeed = 0,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) async {
    final seeded = await _seededRows(nationId);
    // `overall` is position-weighted and derived (not a column), so build the
    // aged pool (seeded survivors + newgen intakes) and order in Dart.
    final pool = PlayerLifecycle.youthPoolAt(
      seeded,
      nationId,
      agingYears,
      youthBonusByCycle: youthBonusByCycle,
      careerStartsByPlayer: careerStartsByPlayer,
      // Only the manager's own pool feels club minutes; the world simulation
      // passes no seed and is byte-identical to before.
      clubSeed: saveSeed,
    )..sort((a, b) => b.overall.compareTo(a.overall));
    final name = await _namerFor(nationId, seeded, saveSeed);
    final home = await _home(nationId);
    return [
      for (final p in pool)
        _withClub(
          name(p),
          saveSeed,
          homeCode: home.code,
          homeCities: home.cities,
        ),
    ];
  }

  /// Attaches the player's (cosmetic) club and its country, derived from their
  /// current overall + id + save seed — layered on like the namer.
  ///
  /// [homeCode] and [homeCities] let the assignment keep most of a nation's
  /// players at home; without them every player would be placed abroad.
  Player _withClub(
    Player p,
    int saveSeed, {
    String homeCode = '',
    List<String> homeCities = const [],
  }) {
    final c = ClubService.clubForSeed(
      p,
      saveSeed,
      homeCode: homeCode,
      homeCities: homeCities,
    );
    return p.copyWith(club: c.name, clubCountry: c.country);
  }

  /// The FIFA code and cities of [nationId] — the "home country" context the
  /// club assignment needs.
  Future<({String code, List<String> cities})> _home(int nationId) async {
    final codes = _codes ??= {
      for (final n in await _db.select(_db.nations).get()) n.id: n.code,
    };
    return (
      // Lower-cased to match the league table's country keys (and the flag
      // asset names), which are all lowercase FIFA codes.
      code: (codes[nationId] ?? '').toLowerCase(),
      cities: (await _cityLists())[nationId] ?? const <String>[],
    );
  }

  /// The per-nation city lists, from the injected seed source (once). Empty
  /// when no source was supplied.
  Future<Map<int, List<String>>> _cityLists() async =>
      _cities ??= await _seed?.cities() ?? const {};

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
        // Same club-minutes weight the nation pool applies — see below.
        clubSeed: saveSeed,
      );
      if (p == null) return null;
      final home = await _home(nationId);
      return _withClub(
        (await _namerFor(nationId, seeded, saveSeed))(p),
        saveSeed,
        homeCode: home.code,
        homeCities: home.cities,
      );
    }
    final row = await (_db.select(
      _db.players,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final p = row?.toDomain();
    // Identity lookups resolve a player even once they've retired out of the
    // selectable pool — a retired legend still has a name and a record.
    if (p == null) return null;
    // The club-minutes weight on his development, identical to the one
    // [byNation] applies through `poolAt` — without it a player looked up by
    // identity developed at a flat rate while the very same player, read out
    // of his nation's pool, developed at his club's. He is one footballer, so
    // he reads one rating: the naturalised player, always resolved here and
    // always listed beside pool-built team-mates, is where that showed.
    final agedOnly = PlayerAging.agedYears(p, agingYears);
    final aged = PlayerLifecycle.withCareerDev(
      agedOnly,
      careerStartsByPlayer[id] ?? 0,
      minutesFactor: PlayerLifecycle.minutesFactorFor(
        agedOnly,
        agingYears,
        saveSeed,
      ),
    );
    final seeded = await _seededRows(p.nationId);
    final home = await _home(p.nationId);
    return _withClub(
      (await _namerFor(p.nationId, seeded, saveSeed))(aged),
      saveSeed,
      homeCode: home.code,
      homeCities: home.cities,
    );
  }

  /// The nation's base (cycle-0) seeded rows, unaged.
  Future<List<Player>> _seededRows(int nationId) async {
    final rows = await (_db.select(
      _db.players,
    )..where((t) => t.nationId.equals(nationId))).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  /// Loads the per-nation name pools from the bundled asset (once). Falls back
  /// to an empty map when the asset isn't available (e.g. pure unit tests).
  Future<Map<int, _NamePool>> _pools() async {
    if (_namePools != null) return _namePools!;
    try {
      final raw =
          jsonDecode(await rootBundle.loadString(_namesAsset))
              as Map<String, Object?>;
      _namePools = {
        for (final e in raw.entries)
          int.parse(e.key): (
            first: ((e.value! as Map)['first'] as List).cast<String>(),
            sur: ((e.value! as Map)['sur'] as List).cast<String>(),
            surLate: (((e.value! as Map)['surLate'] as List?) ?? const [])
                .cast<String>(),
          ),
      };
    } on Object {
      _namePools = {};
    }
    return _namePools!;
  }

  /// The save's shuffled name list, with each late-added surname spliced into
  /// one low slot.
  ///
  /// Appending them would have been simpler and completely pointless: a
  /// nation's cross product runs to a couple of thousand combinations and a
  /// whole career consumes a few hundred, so anything added at the end is
  /// never reached. A name nobody can ever be given is not in the game.
  ///
  /// So they are spliced instead, into slots inside the range a save actually
  /// uses. The cost is honest and small: one existing player per added surname
  /// is renamed, and everybody else keeps the name they had. Which slots is
  /// save-seeded, so two saves of the same nation give the shirt to different
  /// men.
  static List<String> _combosFor(
    _NamePool pool, {
    required int nationId,
    required int saveSeed,
    required int stored,
  }) {
    final combos = SeededRng(saveSeed ^ (nationId * 0x9E3779B1) ^ 0x5F5E)
        .shuffled([
          for (final f in pool.first)
            for (final s in pool.sur) '$f $s',
        ]);
    if (combos.isEmpty || pool.surLate.isEmpty || pool.first.isEmpty) {
      return combos;
    }
    // Inside the range the nation's STORED rows actually occupy, so the name
    // belongs to somebody who exists from the first day of the save rather
    // than to a newgen thirty years out — or, if the span overshot the pool,
    // to nobody at all. A fixed span did exactly that: it was written for the
    // full 23 + 80 pool and silently lost two of the four names on any nation
    // holding fewer rows than the number it guessed.
    final reach = stored < _lateSlotSpan ? stored : _lateSlotSpan;
    final span = combos.length < reach ? combos.length : reach;
    if (span <= 0) return combos;
    final rng = SeededRng(saveSeed ^ (nationId * 0x85EBCA6B) ^ 0x1A7E);
    final taken = <int>{};
    for (final surname in pool.surLate) {
      if (taken.length >= span) break;
      // Two late surnames must not land on the same player, or the second
      // silently replaces the first and one of them is missing again.
      var slot = rng.nextInt(span);
      while (taken.contains(slot)) {
        slot = (slot + 1) % span;
      }
      taken.add(slot);
      combos[slot] = '${pool.first[rng.nextInt(pool.first.length)]} $surname';
    }
    return combos;
  }

  /// The furthest into the shuffle a late surname may be placed, before the
  /// nation's own stored count trims it further. Keeps the name on a
  /// first-team-adjacent player rather than the deepest reserve.
  static const int _lateSlotSpan = 96;

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
    // fields a distinct set drawn from the SAME pool. Built once per (nation,
    // save) — the splice below is part of building it, not something done to
    // it on every read.
    final combos = _comboCache[(nationId, saveSeed)] ??= _combosFor(
      pool,
      nationId: nationId,
      saveSeed: saveSeed,
      stored: seeded.length,
    );
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
