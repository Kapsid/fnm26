import 'dart:convert';

import 'package:drift/drift.dart' show BooleanExpressionOperators;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart' show YouthLevel;
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/manager/stints.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
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

  /// The extra names a career marked [namePoolsV2Kind] draws from as well.
  static const _moreNamesAsset = 'assets/data/country_names_more.json';

  /// Per-nation name pools, loaded from the asset once.
  Map<int, _NamePool>? _namePools;

  /// Per-nation richer pools (the classic ones plus the extras), built once.
  Map<int, _NamePool>? _richNamePools;

  /// Careers known to carry [namePoolsV2Kind]. Only the yes is kept: a mark
  /// is never taken away and a career id is never reused, so a yes cannot go
  /// stale, while a no could if anything read a career's players before its
  /// mark landed. An unmarked career is simply asked again (one small query).
  final Set<int> _richCareers = {};

  /// Per-nation city lists (biggest first), loaded once — used to name a
  /// domestic club for a country with no curated league.
  Map<int, List<String>>? _cities;

  /// Nation id → FIFA code, cached; tells the club assignment which country is
  /// "home" for a player.
  Map<int, String>? _codes;

  /// Shuffled first+surname combinations per (nation, save), cached so repeated
  /// lookups don't rebuild the (large) list.
  final Map<(int, int), List<String>> _comboCache = {};

  /// The richer pools' names per (nation, save), for a career marked
  /// [namePoolsV2Kind] — a permutation, not a list (see [_PermutedNames]).
  final Map<(int, int), _PermutedNames> _richCache = {};

  @override
  Future<List<Player>> byNation(
    int nationId, {
    int agingYears = 0,
    int saveSeed = 0,
    int? careerId,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
    int minAge = PlayerLifecycle.seniorMinAge,
  }) async {
    final seeded = await _seededRows(nationId);
    // `overall` is position-weighted and derived (not a column), so build the
    // aged pool (seeded survivors + newgen intakes) and order in Dart. A
    // career marked with this nation's golden generation reads the cohort in
    // place of the seeded players (see [GoldenGeneration]).
    final build = await _hasGoldenGeneration(careerId, nationId)
        ? GoldenGeneration.poolAt
        : PlayerLifecycle.poolAt;
    final pool = build(
      seeded,
      nationId,
      agingYears,
      youthBonusByCycle: youthBonusByCycle,
      careerStartsByPlayer: careerStartsByPlayer,
      minAge: minAge,
      // The save seed weights development by club minutes, but only for a
      // player with career starts (withCareerDev leaves one with none as he
      // is), so a save's day one carries the seed-free ratings. Save-bound
      // callers pass it, the world simulation included; zero means no club
      // effect.
      clubSeed: saveSeed,
    )..sort((a, b) => b.overall.compareTo(a.overall));
    final name = await _namerFor(nationId, seeded, saveSeed, careerId);
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
    int? careerId,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) async {
    final seeded = await _seededRows(nationId);
    // `overall` is position-weighted and derived (not a column), so build the
    // aged pool (seeded survivors + newgen intakes) and order in Dart.
    final List<Player> pool;
    if (await _hasGoldenGeneration(careerId, nationId)) {
      // The golden generation's pyramid: the same band [youthPoolAt] cuts.
      pool = [
        for (final p in GoldenGeneration.poolAt(
          seeded,
          nationId,
          agingYears,
          youthBonusByCycle: youthBonusByCycle,
          careerStartsByPlayer: careerStartsByPlayer,
          minAge: PlayerLifecycle.intakeAge,
          clubSeed: saveSeed,
        ))
          if (p.age <= YouthLevel.u21.maxAge) p,
      ];
    } else {
      pool = PlayerLifecycle.youthPoolAt(
        seeded,
        nationId,
        agingYears,
        youthBonusByCycle: youthBonusByCycle,
        careerStartsByPlayer: careerStartsByPlayer,
        // The save seed weights development by club minutes, but only for a
        // player with career starts (withCareerDev leaves one with none as he
        // is), so a save's day one carries the seed-free ratings. Save-bound
        // callers pass it, the world simulation included; zero means no club
        // effect.
        clubSeed: saveSeed,
      );
    }
    pool.sort((a, b) => b.overall.compareTo(a.overall));
    final name = await _namerFor(nationId, seeded, saveSeed, careerId);
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
    int? careerId,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) async {
    final p = await _byIdAsBorn(
      id,
      agingYears: agingYears,
      saveSeed: saveSeed,
      careerId: careerId,
      youthBonusByCycle: youthBonusByCycle,
      careerStartsByPlayer: careerStartsByPlayer,
    );
    if (p == null || careerId == null) return p;
    final into = await _naturalizedInto(careerId, id);
    return into == null ? p : p.copyWith(nationId: into);
  }

  /// The nation [playerId] switched to in [careerId], or null if he never
  /// naturalised there.
  ///
  /// The pools already moved a naturalised man (see `careerPoolOf`), but
  /// every card, list and record that looked him up by id got him back as he
  /// was seeded: the player page flew his old flag for the rest of the save.
  /// So the identity read re-homes him here, once, for every caller. Only his
  /// nation moves: name, club and rating stay his own, and the facts logged
  /// before the switch keep the nation they were logged under.
  ///
  /// The nation is the one the manager was in charge of in the offer's cycle,
  /// exactly as `naturalizationsInto` reads it, so a man naturalised for a
  /// federation the manager has since left stays with that federation.
  Future<int?> _naturalizedInto(int careerId, int playerId) async {
    final link =
        await (_db.select(_db.naturalizedPlayers)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  t.playerId.equals(playerId) &
                  t.status.equals('accepted'),
            ))
            .getSingleOrNull();
    if (link == null) return null;
    final career = await (_db.select(
      _db.careers,
    )..where((t) => t.id.equals(careerId))).getSingleOrNull();
    if (career == null) return null;
    final stints = await (_db.select(
      _db.careerStints,
    )..where((t) => t.careerId.equals(careerId))).get();
    return Stints.nationAt(
      {for (final s in stints) s.cycle: s.nationId},
      link.cycle,
      career.nationId,
    );
  }

  /// [byId] before any naturalisation: the player as his nation seeded him.
  Future<Player?> _byIdAsBorn(
    int id, {
    required int agingYears,
    required int saveSeed,
    required int? careerId,
    required Map<int, double> youthBonusByCycle,
    required Map<int, int> careerStartsByPlayer,
  }) async {
    if (GoldenGeneration.isGoldenId(id)) {
      // A cohort member is resolved from his id alone, like a newgen: only a
      // marked career ever fields him, so no marker is needed to name him.
      final nationId = GoldenGeneration.nationOf(id);
      final p = GoldenGeneration.byId(
        id,
        agingYears,
        careerStartsByPlayer: careerStartsByPlayer,
        clubSeed: saveSeed,
      );
      if (p == null) return null;
      final seeded = await _seededRows(nationId);
      final home = await _home(nationId);
      return _withClub(
        (await _namerFor(nationId, seeded, saveSeed, careerId))(p),
        saveSeed,
        homeCode: home.code,
        homeCities: home.cities,
      );
    }
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
        (await _namerFor(nationId, seeded, saveSeed, careerId))(p),
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
      (await _namerFor(p.nationId, seeded, saveSeed, careerId))(aged),
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

  /// The richer pools: each nation's classic lists with its extras from
  /// `country_names_more.json` added, for a career marked [namePoolsV2Kind].
  ///
  /// The late surnames join the cross product like any other here. They were
  /// spliced into a few slots only so as not to rename players of saves that
  /// already existed, and a career on these pools is new: nobody in it has a
  /// name to lose. A nation the extras file does not cover still reads its
  /// classic names, with the late ones folded in.
  Future<Map<int, _NamePool>> _richPools() async {
    if (_richNamePools != null) return _richNamePools!;
    final base = await _pools();
    var more = const <String, Object?>{};
    try {
      more =
          jsonDecode(await rootBundle.loadString(_moreNamesAsset))
              as Map<String, Object?>;
    } on Object {
      // No extras bundled (pure unit tests): the classic names alone.
    }
    List<String> extra(int nationId, String key) =>
        (((more['$nationId'] as Map?)?[key] as List?) ?? const [])
            .cast<String>();
    return _richNamePools = {
      for (final MapEntry(key: id, value: pool) in base.entries)
        id: (
          first: {...pool.first, ...extra(id, 'firstMore')}.toList(),
          sur: {
            ...pool.sur,
            ...pool.surLate,
            ...extra(id, 'surMore'),
          }.toList(),
          surLate: const <String>[],
        ),
    };
  }

  /// Whether [careerId] reads the richer pools (see [namePoolsV2Kind]).
  Future<bool> _readsRichPools(int? careerId) async {
    if (careerId == null) return false;
    if (_richCareers.contains(careerId)) return true;
    final row =
        await (_db.select(_db.drawsWatched)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(0) &
                    t.kind.equals(namePoolsV2Kind),
              )
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return false;
    _richCareers.add(careerId);
    return true;
  }

  /// Careers known to carry a golden generation, per nation (see
  /// [GoldenGeneration.markerFor]). Only the yes is kept, for the reason
  /// [_richCareers] gives: the campaign writes the mark right after creating
  /// the career, and a read in between must not pin a no.
  final Set<(int, int)> _goldenCareers = {};

  /// Whether [careerId] reads [nationId]'s golden generation. Asked only for
  /// a nation that has one, so no other read pays for the query.
  Future<bool> _hasGoldenGeneration(int? careerId, int nationId) async {
    if (careerId == null || !GoldenGeneration.hasCohort(nationId)) {
      return false;
    }
    if (_goldenCareers.contains((careerId, nationId))) return true;
    final row =
        await (_db.select(_db.drawsWatched)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(0) &
                    t.kind.equals(GoldenGeneration.markerFor(nationId)),
              )
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return false;
    _goldenCareers.add((careerId, nationId));
    return true;
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

  /// Where a golden generation's names start, past the nation's stored rows:
  /// beyond the newgen sequence of any save shorter than a century.
  static const int _goldenNameOffset = 1000;

  /// Builds a namer that assigns every player of [nationId] a unique name from
  /// the nation's pool. [seeded] gives the nation's stored rows (to rank the
  /// base + fringe players); a 0 [saveSeed] (or a missing pool) leaves names
  /// untouched. [careerId] picks the pools (see [namePoolsV2Kind]).
  Future<Player Function(Player)> _namerFor(
    int nationId,
    List<Player> seeded,
    int saveSeed,
    int? careerId,
  ) async {
    if (saveSeed == 0) return _identity;
    final rich = await _readsRichPools(careerId);
    final pool = (await (rich ? _richPools() : _pools()))[nationId];
    if (pool == null || pool.first.isEmpty || pool.sur.isEmpty) {
      return _identity;
    }
    // A save-specific shuffle of every first+surname combination, so each save
    // fields a distinct set drawn from the SAME pool. The classic one is built
    // once per (nation, save) — the splice below is part of building it, not
    // something done to it on every read. The richer one is never built at
    // all: see [_PermutedNames].
    final String Function(int) nameAt;
    final int length;
    if (rich) {
      final names = _richCache[(nationId, saveSeed)] ??= _PermutedNames(
        pool.first,
        pool.sur,
        saveSeed ^ (nationId * 0x9E3779B1) ^ 0x5F5E,
      );
      nameAt = names.call;
      length = names.length;
    } else {
      final combos = _comboCache[(nationId, saveSeed)] ??= _combosFor(
        pool,
        nationId: nationId,
        saveSeed: saveSeed,
        stored: seeded.length,
      );
      nameAt = (i) => combos[i];
      length = combos.length;
    }
    if (length == 0) return _identity;

    // A stable, distinct index for every player: stored rows (base + fringe)
    // ranked by id, then newgens continuing past them by their sequence — so no
    // two players ever land on the same combination while any save is active.
    final storedIds = [for (final p in seeded) p.id]..sort();
    final rank = {for (var i = 0; i < storedIds.length; i++) storedIds[i]: i};
    final storedCount = storedIds.length;

    // A golden generation's names: the cohort in order, from a start past
    // every newgen a save could reach (seven a year), so it shares no name
    // with anybody of its nation. A name that would be a real international's
    // is stepped over, and the members after it move down one, so the
    // cohort stays distinct. Built on the first member read.
    Map<int, String>? golden;
    Map<int, String> goldenNames() {
      final out = <int, String>{};
      var j = storedCount + _goldenNameOffset;
      for (final g in GoldenGeneration.cohort(nationId)) {
        var name = nameAt(j++ % length);
        // Bounded: the list is a few dozen names in a pool of thousands.
        for (var tries = 0;
            realFinlandInternationals.contains(name) && tries < 1000;
            tries++) {
          name = nameAt(j++ % length);
        }
        out[g.id] = name;
      }
      return out;
    }

    Player named(Player p) {
      if (GoldenGeneration.isGoldenId(p.id)) {
        final name = (golden ??= goldenNames())[p.id];
        if (name != null) return p.copyWith(name: name);
      }
      final index = PlayerLifecycle.isNewgenId(p.id)
          ? storedCount + PlayerLifecycle.newgenSequence(p.id)
          : (rank[p.id] ?? 0);
      return p.copyWith(name: nameAt(index % length));
    }

    return named;
  }
}

/// A save-seeded shuffle of a nation's first x surname cross product that is
/// never written out.
///
/// The richer pools run to about a hundred first names by a hundred and
/// twenty surnames, twelve thousand combinations a nation, and a world
/// simulation step touches every nation: listing them all, as the classic
/// pools do, held some two and a half million strings (measured at roughly
/// 90MB and 200ms on the first pass) to name the few hundred men a nation
/// actually fields. So the k-th name is computed instead: a small Feistel
/// network over the next power of four up from the product is a bijection
/// there, and walking it again until the value falls inside the product (the
/// "cycle walk") keeps it a bijection on the product itself. Distinct indices
/// still give distinct names, which is all the namer relies on.
class _PermutedNames {
  _PermutedNames(this._first, this._sur, int seed)
    : length = _first.length * _sur.length {
    final bits = (length - 1).bitLength;
    _half = bits < 2 ? 1 : (bits + 1) >> 1;
    _halfMask = (1 << _half) - 1;
    final rng = SeededRng(seed);
    _keys = [for (var i = 0; i < _rounds; i++) rng.nextInt(1 << 30)];
  }

  final List<String> _first;
  final List<String> _sur;

  /// How many names there are: every first name with every surname.
  final int length;

  static const int _rounds = 4;
  late final int _half;
  late final int _halfMask;
  late final List<int> _keys;

  /// The name at [index] (in `0 <= index < length`).
  String call(int index) {
    var x = index;
    do {
      x = _permute(x);
    } while (x >= length);
    return '${_first[x ~/ _sur.length]} ${_sur[x % _sur.length]}';
  }

  int _permute(int x) {
    var left = x >> _half;
    var right = x & _halfMask;
    for (final key in _keys) {
      final mixed = (((right ^ key) * 0x9E3779B1) & 0xFFFFFFFF) >> 7;
      final next = left ^ (mixed & _halfMask);
      left = right;
      right = next;
    }
    return (left << _half) | right;
  }
}
