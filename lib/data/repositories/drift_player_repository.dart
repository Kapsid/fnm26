import 'dart:convert';

import 'package:drift/drift.dart'
    show BooleanExpressionOperators, StringExpressionOperators;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/intl_retirement_cache.dart';
import 'package:fnm/data/repositories/mappers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/frozen_name_pools.dart';
import 'package:fnm/data/seed/mononyms.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart' show YouthLevel;
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/manager/stints.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/international_retirement.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

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

/// Which generation of the name pools a career reads, oldest first.
///
/// Names are derived on every read, so a career keeps the generation it was
/// created on: [legacy] without `namePoolsV3Kind`, [v3] with it but without
/// `namePoolsV4Kind`, [v4] with both but without `namePoolsV5Kind`, [v5]
/// with all three.
enum _PoolEra {
  /// Every pool cut to the lengths it first shipped with.
  legacy,

  /// Every pool in full, with Greenland's lists as they stood before its
  /// surnames were reworked.
  v3,

  /// The lists as 1.0.8 shipped them: Croatia's without Kovačić.
  v4,

  /// The current lists.
  v5;

  bool atLeast(_PoolEra other) => index >= other.index;
}

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

  /// The classic pools per older [_PoolEra] ([_namePools] is the current
  /// one), built once.
  final Map<_PoolEra, Map<int, _NamePool>> _olderNamePools = {};

  /// Per-nation richer pools (the classic ones plus the extras), built once
  /// per [_PoolEra].
  final Map<_PoolEra, Map<int, _NamePool>> _richNamePools = {};

  /// Classic lists a career without [namePoolsV4Kind] reads in place of the
  /// asset's: the nation's pools as they stood before names in them were
  /// replaced (appending is handled by [legacyPoolLengths]). Frozen.
  static const Map<int, ({List<String> first, List<String> sur})> _v3Pools = {
    DormantNations.greenlandId: (
      first: greenlandFirstNamesV3,
      sur: greenlandSurnamesV3,
    ),
  };

  /// The `country_names_more.json` extras a career without
  /// [namePoolsV4Kind] reads in place of the file's, for the reason
  /// [_v3Pools] gives. Frozen.
  static const Map<int, ({List<String> firstMore, List<String> surMore})>
  _v3Extras = {
    DormantNations.greenlandId: (
      firstMore: greenlandFirstMoreV3,
      surMore: greenlandSurMoreV3,
    ),
  };

  /// Classic lists a career without [namePoolsV5Kind] reads in place of the
  /// asset's: the nation's pools as 1.0.8 shipped them. Frozen.
  static const Map<int, ({List<String> first, List<String> sur})> _v4Pools = {
    10: (first: croatiaFirstNamesV4, sur: croatiaSurnamesV4),
    // 1.0.9 gave Turkmenistan, Kyrgyzstan and Tajikistan first names of
    // their own (they shared one Uzbek/Kazakh list) and Turkmenistan the
    // international spelling (-yev/-ov, not Turkmen Latin -ýew/-ow).
    196: (first: turkmenistanFirstNamesV4, sur: turkmenistanSurnamesV4),
    173: (first: kyrgyzstanFirstNamesV4, sur: kyrgyzstanSurnamesV4),
    193: (first: tajikistanFirstNamesV4, sur: tajikistanSurnamesV4),
    // And Uzbekistan's, Kazakhstan's and Afghanistan's lost the surnames
    // (and Afghanistan some first names) that pointed at real internationals.
    198: (first: uzbekistanFirstNamesV4, sur: uzbekistanSurnamesV4),
    27: (first: kazakhstanFirstNamesV4, sur: kazakhstanSurnamesV4),
    155: (first: afghanistanFirstNamesV4, sur: afghanistanSurnamesV4),
    // Chinese Taipei's first names gained Chi-ming and Chi-chang (a
    // Taiwanese player's suggestion).
    163: (first: chineseTaipeiFirstNamesV4, sur: chineseTaipeiSurnamesV4),
  };

  /// The `country_names_more.json` extras a career without
  /// [namePoolsV5Kind] reads in place of the file's, for the reason
  /// [_v4Pools] gives. Frozen.
  static const Map<int, ({List<String> firstMore, List<String> surMore})>
  _v4Extras = {
    196: (firstMore: turkmenistanFirstMoreV4, surMore: turkmenistanSurMoreV4),
  };

  /// How many first names and surnames a nation's classic pool held before
  /// names were appended to it. A career without [namePoolsV3Kind] reads
  /// only these, so a save that already had the nation renames nobody. Add a
  /// nation here, with its old lengths, whenever its pool is lengthened.
  static final Map<int, ({int first, int sur})> legacyPoolLengths = {
    DormantNations.greenlandId: (
      first: greenlandFringeFirstNames.length,
      sur: greenlandFringeSurnames.length,
    ),
  };

  /// Careers known to carry [namePoolsV2Kind]. Only the yes is kept: a mark
  /// is never taken away and a career id is never reused, so a yes cannot go
  /// stale, while a no could if anything read a career's players before its
  /// mark landed. An unmarked career is simply asked again (one small query).
  final Set<int> _richCareers = {};

  /// Each career's [_PoolEra], once settled (see [_poolEra]): unlike
  /// [_richCareers], an older era is kept too, but only once it is final,
  /// so it cannot go stale.
  final Map<int, _PoolEra> _careerEras = {};

  /// A cycle-0 mark the career service writes right AFTER [namePoolsV3Kind]
  /// and [namePoolsV4Kind] when it creates a career (the value of
  /// `briefRulesV2Kind`, which lives in the hub layer). A career that
  /// carries it but not one of those will never get it, so its era is
  /// final. A test pins the value and the order.
  static const fullPoolsSettledKind = 'briefRules2';

  /// Per-nation city lists (biggest first), loaded once — used to name a
  /// domestic club for a country with no curated league.
  Map<int, List<String>>? _cities;

  /// Nation id → FIFA code, cached; tells the club assignment which country is
  /// "home" for a player.
  Map<int, String>? _codes;

  /// Shuffled first+surname combinations per (nation, save), cached so repeated
  /// lookups don't rebuild the (large) list.
  final Map<(int, int, _PoolEra), List<String>> _comboCache = {};

  /// The richer pools' names per (nation, save), for a career marked
  /// [namePoolsV2Kind] — a permutation, not a list (see [_PermutedNames]).
  final Map<(int, int, _PoolEra), _PermutedNames> _richCache = {};

  /// Per (nation, save, rich pools, pool era): the indices of the
  /// combinations a guarded dormant nation may use (see `_namerFor`).
  final Map<(int, int, bool, _PoolEra), List<int>> _allowedCache = {};

  @override
  Future<List<Player>> byNation(
    int nationId, {
    int agingYears = 0,
    int saveSeed = 0,
    int? careerId,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
    int minAge = PlayerLifecycle.seniorMinAge,
    bool includeIntlRetired = false,
    bool newCareerNames = false,
  }) async {
    final world = await _worldFor(careerId);
    // A career on a custom world develops its players by that world's
    // potentials (see [WorldZone]); every read runs in its zone.
    if (!WorldZone.runs(world?.zone)) {
      return WorldZone.runFor(
        world?.zone,
        () => byNation(
          nationId,
          agingYears: agingYears,
          saveSeed: saveSeed,
          careerId: careerId,
          youthBonusByCycle: youthBonusByCycle,
          careerStartsByPlayer: careerStartsByPlayer,
          minAge: minAge,
          includeIntlRetired: includeIntlRetired,
          newCareerNames: newCareerNames,
        ),
      );
    }
    final seeded = await _seededRowsFor(careerId, nationId);
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
    // Veterans who announced their international retirement in this career
    // are not selectable for the years they stay retired (see
    // [InternationalRetirement]). Every save-bound read passes the career, so
    // the manager's screens, the AI's selection and the world simulation all
    // agree on who is gone.
    final selectable = careerId == null || includeIntlRetired
        ? pool
        : InternationalRetirement.filterPool(
            pool,
            await internationalRetirements(careerId),
            agingYears,
          );
    final name = await _namerFor(
      nationId,
      seeded,
      saveSeed,
      careerId,
      newCareerNames: newCareerNames,
    );
    final home = await _home(nationId);
    return [
      for (final p in selectable)
        _withClub(
          name(p),
          saveSeed,
          homeCode: home.code,
          homeCities: home.cities,
          world: world,
        ),
    ];
  }

  @override
  Future<Map<int, IntlRetirement>> internationalRetirements(int careerId) =>
      IntlRetirementCache.of(
        _db,
      ).all(careerId, () => _decodeRetirements(careerId));

  @override
  Future<Map<int, Map<int, IntlRetirement>>> internationalRetirementsByNation(
    int careerId,
  ) => IntlRetirementCache.of(
    _db,
  ).byNation(careerId, () => _decodeRetirements(careerId));

  /// Reads and decodes every retirement marker of [careerId]; behind the
  /// [IntlRetirementCache], so a pool read does this once per change.
  Future<Map<int, IntlRetirement>> _decodeRetirements(int careerId) async {
    final rows =
        await (_db.select(_db.drawsWatched)..where(
              (t) =>
                  t.careerId.equals(careerId) &
                  (t.kind.like('${InternationalRetirement.retiredPrefix}%') |
                      t.kind.like(
                        '${InternationalRetirement.comebackPrefix}%',
                      )),
            ))
            .get();
    return InternationalRetirement.decodeRows([
      for (final r in rows) (kind: r.kind, cycle: r.cycle),
    ]);
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
    final world = await _worldFor(careerId);
    if (!WorldZone.runs(world?.zone)) {
      return WorldZone.runFor(
        world?.zone,
        () => youthByNation(
          nationId,
          agingYears: agingYears,
          saveSeed: saveSeed,
          careerId: careerId,
          youthBonusByCycle: youthBonusByCycle,
          careerStartsByPlayer: careerStartsByPlayer,
        ),
      );
    }
    final seeded = await _seededRowsFor(careerId, nationId);
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
          world: world,
        ),
    ];
  }

  /// Attaches the player's (cosmetic) club and its country, derived from their
  /// current overall + id + save seed — layered on like the namer.
  ///
  /// [homeCode] and [homeCities] let the assignment keep most of a nation's
  /// players at home; without them every player would be placed abroad.
  ///
  /// In a career on a custom [world], a pack player is at the club the pack
  /// gives him for as long as the contract he is on at his day-one age runs
  /// ([ClubService.contractAt]); from his first move on the normal clock
  /// carries him. Every club, his and everybody else's, then reads under the
  /// world's club names ([ClubService.renamed]).
  Player _withClub(
    Player p,
    int saveSeed, {
    String homeCode = '',
    List<String> homeCities = const [],
    _CareerWorld? world,
  }) {
    var c = ClubService.clubForSeed(
      p,
      saveSeed,
      homeCode: homeCode,
      homeCities: homeCities,
    );
    if (world != null) {
      final dayOne = world.packPlayer(p.id);
      if (dayOne != null &&
          dayOne.club != null &&
          ClubService.contractAt(p.id, p.age).index ==
              ClubService.contractAt(p.id, dayOne.age).index) {
        c = (name: dayOne.club!, country: dayOne.clubCountry ?? '');
      }
      c = ClubService.renamed(c, world.pack.clubs);
    }
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
    bool newCareerNames = false,
  }) async {
    final world = await _worldFor(careerId);
    if (!WorldZone.runs(world?.zone)) {
      return WorldZone.runFor(
        world?.zone,
        () => byId(
          id,
          agingYears: agingYears,
          saveSeed: saveSeed,
          careerId: careerId,
          youthBonusByCycle: youthBonusByCycle,
          careerStartsByPlayer: careerStartsByPlayer,
          newCareerNames: newCareerNames,
        ),
      );
    }
    final p = await _byIdAsBorn(
      id,
      agingYears: agingYears,
      saveSeed: saveSeed,
      careerId: careerId,
      youthBonusByCycle: youthBonusByCycle,
      careerStartsByPlayer: careerStartsByPlayer,
      newCareerNames: newCareerNames,
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
    bool newCareerNames = false,
  }) async {
    final world = await _worldFor(careerId);
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
      final seeded = await _seededRowsFor(careerId, nationId);
      final home = await _home(nationId);
      return _withClub(
        (await _namerFor(
          nationId,
          seeded,
          saveSeed,
          careerId,
          newCareerNames: newCareerNames,
        ))(p),
        saveSeed,
        homeCode: home.code,
        homeCities: home.cities,
        world: world,
      );
    }
    if (PlayerLifecycle.isNewgenId(id)) {
      final nationId = PlayerLifecycle.nationIdOf(id);
      final seeded = await _seededRowsFor(careerId, nationId);
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
        (await _namerFor(
          nationId,
          seeded,
          saveSeed,
          careerId,
          newCareerNames: newCareerNames,
        ))(p),
        saveSeed,
        homeCode: home.code,
        homeCities: home.cities,
        world: world,
      );
    }
    // A career on a custom world reads its core players from the world: an
    // edited one as edited, an added one (no stored row) at all.
    var p = world?.player(id);
    if (p == null) {
      final row = await (_db.select(
        _db.players,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      p = row?.toDomain();
      // A core player the world removed is not in it, by id or otherwise.
      if (p != null &&
          world != null &&
          p.id < PoolGenerator.firstFringeId &&
          world.coreOf(p.nationId) != null) {
        return null;
      }
    }
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
    final seeded = await _seededRowsFor(careerId, p.nationId);
    final home = await _home(p.nationId);
    return _withClub(
      (await _namerFor(
        p.nationId,
        seeded,
        saveSeed,
        careerId,
        newCareerNames: newCareerNames,
      ))(aged),
      saveSeed,
      homeCode: home.code,
      homeCities: home.cities,
      world: world,
    );
  }

  /// The nation's base (cycle-0) seeded rows, unaged.
  Future<List<Player>> _seededRows(int nationId) async {
    final rows = await (_db.select(
      _db.players,
    )..where((t) => t.nationId.equals(nationId))).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  /// The base rows [careerId] reads for [nationId]: [_seededRows], except
  /// that a career on a custom world whose world has a squad for the nation
  /// reads that squad in place of the stored core rows. The fringe rows stay,
  /// so the pool around the squad is the one the default world has.
  Future<List<Player>> _seededRowsFor(int? careerId, int nationId) async {
    final rows = await _seededRows(nationId);
    final core = (await _worldFor(careerId))?.coreOf(nationId);
    if (core == null) return rows;
    return [
      ...core,
      for (final p in rows)
        if (p.id >= PoolGenerator.firstFringeId) p,
    ];
  }

  /// Each career's custom world (null for the default one), read once. A
  /// career's world is copied in with the career, in the same transaction,
  /// and never changes after, so neither answer can go stale (a career id is
  /// never reused).
  final Map<int, Future<_CareerWorld?>> _worlds = {};

  /// The custom world [careerId] was started on, or null for the default
  /// world (and for no career at all).
  Future<_CareerWorld?> _worldFor(int? careerId) {
    if (careerId == null) return Future.value();
    return _worlds[careerId] ??= () async {
      try {
        final stored = await WorldPackRepository(_db).forCareer(careerId);
        return stored == null ? null : _CareerWorld(stored.pack);
      } on Object {
        // Not kept: the next read asks again.
        _worlds.remove(careerId)?.ignore();
        rethrow;
      }
    }();
  }

  /// Loads the per-nation name pools from the bundled asset (once). Falls back
  /// to an empty map when the asset isn't available (e.g. pure unit tests).
  ///
  /// Before [_PoolEra.v5], a nation in [_v4Pools] reads its frozen lists;
  /// before [_PoolEra.v4], a nation in [_v3Pools] does too; before
  /// [_PoolEra.v3], a nation in [legacyPoolLengths] is also cut to the
  /// lengths it first shipped with.
  Future<Map<int, _NamePool>> _pools({_PoolEra era = _PoolEra.v5}) async {
    if (era != _PoolEra.v5) {
      if (_olderNamePools[era] case final cached?) return cached;
      final v4 = _olderNamePools[_PoolEra.v4] ??= _frozen(
        await _pools(),
        _v4Pools,
      );
      if (era == _PoolEra.v4) return v4;
      final v3 = _olderNamePools[_PoolEra.v3] ??= _frozen(v4, _v3Pools);
      return _olderNamePools[era] = era == _PoolEra.legacy ? _legacy(v3) : v3;
    }
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

  /// [pools] with every nation in [frozen] on its frozen lists.
  static Map<int, _NamePool> _frozen(
    Map<int, _NamePool> pools,
    Map<int, ({List<String> first, List<String> sur})> frozen,
  ) => {
    for (final MapEntry(key: id, value: pool) in pools.entries)
      id: switch (frozen[id]) {
        null => pool,
        final f => (first: f.first, sur: f.sur, surLate: pool.surLate),
      },
  };

  /// [pools] with every nation in [legacyPoolLengths] cut to its old lengths.
  static Map<int, _NamePool> _legacy(Map<int, _NamePool> pools) => {
    for (final MapEntry(key: id, value: pool) in pools.entries)
      id: switch (legacyPoolLengths[id]) {
        null => pool,
        final n => (
          first: pool.first.take(n.first).toList(),
          sur: pool.sur.take(n.sur).toList(),
          surLate: pool.surLate,
        ),
      },
  };

  /// The richer pools: each nation's classic lists with its extras from
  /// `country_names_more.json` added, for a career marked [namePoolsV2Kind].
  ///
  /// The late surnames join the cross product like any other here. They were
  /// spliced into a few slots only so as not to rename players of saves that
  /// already existed, and a career on these pools is new: nobody in it has a
  /// name to lose. A nation the extras file does not cover still reads its
  /// classic names, with the late ones folded in.
  ///
  /// Before [_PoolEra.v4], a nation in [_v3Extras] reads its frozen extras;
  /// before [_PoolEra.v5], one in [_v4Extras] does.
  Future<Map<int, _NamePool>> _richPools({_PoolEra era = _PoolEra.v5}) async {
    if (_richNamePools[era] case final cached?) return cached;
    final base = await _pools(era: era);
    var more = const <String, Object?>{};
    try {
      more =
          jsonDecode(await rootBundle.loadString(_moreNamesAsset))
              as Map<String, Object?>;
    } on Object {
      // No extras bundled (pure unit tests): the classic names alone.
    }
    List<String> extra(int nationId, String key) {
      if (!era.atLeast(_PoolEra.v4)) {
        if (_v3Extras[nationId] case final v3?) {
          return key == 'firstMore' ? v3.firstMore : v3.surMore;
        }
      }
      if (!era.atLeast(_PoolEra.v5)) {
        if (_v4Extras[nationId] case final v4?) {
          return key == 'firstMore' ? v4.firstMore : v4.surMore;
        }
      }
      return (((more['$nationId'] as Map?)?[key] as List?) ?? const [])
          .cast<String>();
    }

    return _richNamePools[era] = {
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
  Future<bool> _readsRichPools(int? careerId) =>
      _carriesMark(careerId, namePoolsV2Kind, _richCareers);

  /// Which [_PoolEra] [careerId] reads (see [namePoolsV3Kind] and
  /// [namePoolsV4Kind]).
  ///
  /// Asked only for a nation whose names the answer can change (see
  /// [_poolEraMatters]), so other nations pay nothing. [_PoolEra.v4] is
  /// cached at once; an older era only when [fullPoolsSettledKind] shows the
  /// career's creation has already passed the point where the marks are
  /// written: an era read mid-create, before a mark lands, is not kept.
  Future<_PoolEra> _poolEra(int? careerId) async {
    if (careerId == null) return _PoolEra.legacy;
    if (_careerEras[careerId] case final known?) return known;
    final kinds =
        await (_db.selectOnly(_db.drawsWatched)
              ..addColumns([_db.drawsWatched.kind])
              ..where(
                _db.drawsWatched.careerId.equals(careerId) &
                    _db.drawsWatched.cycle.equals(0) &
                    _db.drawsWatched.kind.isIn(const [
                      namePoolsV3Kind,
                      namePoolsV4Kind,
                      namePoolsV5Kind,
                      fullPoolsSettledKind,
                    ]),
              ))
            .map((r) => r.read(_db.drawsWatched.kind))
            .get();
    if (kinds.contains(namePoolsV5Kind)) {
      return _careerEras[careerId] = _PoolEra.v5;
    }
    final era = kinds.contains(namePoolsV4Kind)
        ? _PoolEra.v4
        : kinds.contains(namePoolsV3Kind)
        ? _PoolEra.v3
        : _PoolEra.legacy;
    if (kinds.contains(fullPoolsSettledKind)) _careerEras[careerId] = era;
    return era;
  }

  /// Whether the pool era can change [nationId]'s names: its pool was
  /// lengthened or had names replaced, or it has an era-only guard.
  static bool _poolEraMatters(int nationId) =>
      legacyPoolLengths.containsKey(nationId) ||
      _v3Pools.containsKey(nationId) ||
      _v4Pools.containsKey(nationId) ||
      _v4Extras.containsKey(nationId) ||
      guardedNamesPoolsV5ByNation.containsKey(nationId) ||
      mononymsByNation.containsKey(nationId) ||
      _v3Extras.containsKey(nationId) ||
      guardedNamesFullPoolsByNation.containsKey(nationId) ||
      guardedNamesPoolsV4ByNation.containsKey(nationId);

  /// Whether [careerId] carries the cycle-0 mark [kind]; a yes is kept in
  /// [yes] (see [_richCareers] for why only the yes).
  Future<bool> _carriesMark(int? careerId, String kind, Set<int> yes) async {
    if (careerId == null) return false;
    if (yes.contains(careerId)) return true;
    final row =
        await (_db.select(_db.drawsWatched)
              ..where(
                (t) =>
                    t.careerId.equals(careerId) &
                    t.cycle.equals(0) &
                    t.kind.equals(kind),
              )
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return false;
    yes.add(careerId);
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

  /// Builds the namer for [nationId]'s players in [careerId]: the default
  /// world's ([_poolNamerFor]), unless the career is on a custom world.
  ///
  /// There a player of the world's squads is called exactly what the world
  /// calls him, never re-drawn. Everybody else (fringe, newgens) is drawn as
  /// in the default world, from the world's own name lists for the nation
  /// when it has them ([_listNamer]) and from the normal pools otherwise.
  Future<Player Function(Player)> _namerFor(
    int nationId,
    List<Player> seeded,
    int saveSeed,
    int? careerId, {
    bool newCareerNames = false,
  }) async {
    final world = await _worldFor(careerId);
    if (world == null) {
      return _poolNamerFor(
        nationId,
        seeded,
        saveSeed,
        careerId,
        newCareerNames: newCareerNames,
      );
    }
    final lists = world.pack.nameLists[nationId];
    final drawn =
        lists != null && lists.first.isNotEmpty && lists.sur.isNotEmpty
        ? _listNamer(lists, nationId, seeded, saveSeed)
        : await _poolNamerFor(nationId, seeded, saveSeed, careerId);
    Player named(Player p) => switch (world.packPlayer(p.id)) {
      null => drawn(p),
      final fixed => p.copyWith(name: fixed.name),
    };
    return named;
  }

  /// A namer drawing from a custom world's [lists] for [nationId], the way
  /// the richer pools are drawn ([_PermutedNames]): a save-seeded shuffle of
  /// the first x surname product, indexed as [_poolNamerFor] indexes it.
  static Player Function(Player) _listNamer(
    PackNameLists lists,
    int nationId,
    List<Player> seeded,
    int saveSeed,
  ) {
    if (saveSeed == 0) return _identity;
    final names = _PermutedNames(
      {...lists.first}.toList(),
      {...lists.sur}.toList(),
      saveSeed ^ (nationId * 0x9E3779B1) ^ 0x5F5E,
    );
    final storedIds = [for (final p in seeded) p.id]..sort();
    final rank = {for (var i = 0; i < storedIds.length; i++) storedIds[i]: i};
    return (p) {
      final index = PlayerLifecycle.isNewgenId(p.id)
          ? storedIds.length + PlayerLifecycle.newgenSequence(p.id)
          : (rank[p.id] ?? 0);
      return p.copyWith(name: names(index % names.length));
    };
  }

  /// Builds a namer that assigns every player of [nationId] a unique name from
  /// the nation's pool. [seeded] gives the nation's stored rows (to rank the
  /// base + fringe players); a 0 [saveSeed] (or a missing pool) leaves names
  /// untouched. [careerId] picks the pools (see [namePoolsV2Kind]); with
  /// none, [newCareerNames] picks the ones a career created now reads.
  Future<Player Function(Player)> _poolNamerFor(
    int nationId,
    List<Player> seeded,
    int saveSeed,
    int? careerId, {
    bool newCareerNames = false,
  }) async {
    if (saveSeed == 0) return _identity;
    final current = careerId == null && newCareerNames;
    final rich = current || await _readsRichPools(careerId);
    final era = !_poolEraMatters(nationId)
        ? _PoolEra.legacy
        : current
        ? _PoolEra.v5
        : await _poolEra(careerId);
    final pool = (await (rich
        ? _richPools(era: era)
        : _pools(era: era)))[nationId];
    if (pool == null || pool.first.isEmpty || pool.sur.isEmpty) {
      return _identity;
    }
    // A save-specific shuffle of every first+surname combination, so each save
    // fields a distinct set drawn from the SAME pool. The classic one is built
    // once per (nation, save) — the splice below is part of building it, not
    // something done to it on every read. The richer one is never built at
    // all: see [_PermutedNames].
    String Function(int) nameAt;
    int length;
    if (rich) {
      final names = _richCache[(nationId, saveSeed, era)] ??= _PermutedNames(
        pool.first,
        pool.sur,
        saveSeed ^ (nationId * 0x9E3779B1) ^ 0x5F5E,
      );
      nameAt = names.call;
      length = names.length;
    } else {
      // Spliced over the nation's STORED rows, never [seeded]: in a career
      // on a custom world [seeded] carries that world's squad, and this
      // cache is shared by every career of the same seed.
      final key = (nationId, saveSeed, era);
      final combos =
          _comboCache[key] ??
          (_comboCache[key] = _combosFor(
            pool,
            nationId: nationId,
            saveSeed: saveSeed,
            stored: (await _seededRows(nationId)).length,
          ));
      nameAt = (i) => combos[i];
      length = combos.length;
    }
    if (length == 0) return _identity;

    // A dormant nation with a real-name guard (see guardedNamesByNation)
    // reads only the combinations off the guard: built once per (nation,
    // save, pools), then index i maps to the i-th allowed one, so names stay
    // distinct. Only dormant nations pay for the scan, and no ordinary
    // nation's names, in any save, move. A career on the full pools also
    // steps over guardedNamesFullPoolsByNation, and one on the current pools
    // over guardedNamesPoolsV4ByNation too: names an older career could
    // already be given, so guarding them there would move its names.
    final dormant = DormantNations.ids.contains(nationId);
    final guard = dormant ? guardedNamesByNation[nationId] : null;
    final fullGuard = dormant && era != _PoolEra.legacy
        ? guardedNamesFullPoolsByNation[nationId]
        : null;
    final v4Guard = dormant && era.atLeast(_PoolEra.v4)
        ? guardedNamesPoolsV4ByNation[nationId]
        : null;
    // From the 1.0.9 pools on, any nation listed (Croatia, for Mateo
    // Kovačić) steps over its guard too: only that era could produce the
    // name, so no older career's names move, and an unlisted nation pays
    // nothing.
    final v5Guard = era.atLeast(_PoolEra.v5)
        ? guardedNamesPoolsV5ByNation[nationId]
        : null;
    if (guard != null ||
        fullGuard != null ||
        v4Guard != null ||
        v5Guard != null) {
      final raw = nameAt;
      bool guarded(String name) =>
          (guard?.contains(name) ?? false) ||
          (fullGuard?.contains(name) ?? false) ||
          (v4Guard?.contains(name) ?? false) ||
          (v5Guard?.contains(name) ?? false);
      final allowed = _allowedCache[(nationId, saveSeed, rich, era)] ??= [
        for (var k = 0; k < length; k++)
          if (!guarded(raw(k))) k,
      ];
      if (allowed.isEmpty) return _identity;
      nameAt = (i) => raw(allowed[i % allowed.length]);
      length = allowed.length;
    }

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
        for (
          var tries = 0;
          realFinlandInternationals.contains(name) && tries < 1000;
          tries++
        ) {
          name = nameAt(j++ % length);
        }
        out[g.id] = name;
      }
      return out;
    }

    // From the 1.0.9 pools on, one player in `every` of a nation that goes
    // by single names (Brazil) gets one. Which indices is save-seeded; the
    // k-th such index takes the k-th mononym, so no two share one while the
    // list lasts, and past its end they fall back to a full name.
    final mono = era.atLeast(_PoolEra.v5) ? mononymsByNation[nationId] : null;
    final monoPhase = mono == null
        ? 0
        : (saveSeed ^ nationId).abs() % mono.every;
    String? mononymAt(int index) {
      if (mono == null || index % mono.every != monoPhase) return null;
      final k = index ~/ mono.every;
      return k < mono.names.length ? mono.names[k] : null;
    }

    Player named(Player p) {
      if (GoldenGeneration.isGoldenId(p.id)) {
        final name = (golden ??= goldenNames())[p.id];
        if (name != null) return p.copyWith(name: name);
      }
      final index = PlayerLifecycle.isNewgenId(p.id)
          ? storedCount + PlayerLifecycle.newgenSequence(p.id)
          : (rank[p.id] ?? 0);
      return p.copyWith(name: mononymAt(index) ?? nameAt(index % length));
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

/// A career's custom world, with its squads indexed for the repository's
/// reads.
class _CareerWorld {
  _CareerWorld(this.pack)
    : _byId = {
        for (final MapEntry(key: nationId, value: squad) in pack.squads.entries)
          for (final p in squad) p.id: (nationId: nationId, player: p),
      };

  final WorldPack pack;
  final Map<int, ({int nationId, PackPlayer player})> _byId;

  /// The world's potentials, for the [WorldZone] every read runs in. One
  /// object per world, so a read already in its zone is recognised.
  late final WorldZoneData zone = WorldZoneData.of(pack);

  /// Each nation's squad as base rows, built on first read.
  final Map<int, List<Player>> _core = {};

  /// The world's squad player [id], as the world gives him.
  PackPlayer? packPlayer(int id) => _byId[id]?.player;

  /// [packPlayer] as a base (unaged) row.
  Player? player(int id) {
    final entry = _byId[id];
    if (entry == null) return null;
    return coreOf(entry.nationId)!.firstWhere((p) => p.id == id);
  }

  /// [nationId]'s squad as base rows, or null when the world has none for
  /// it (the stored core rows then stand).
  ///
  /// A world stores a player as he is on day one, and a young player is
  /// shown marked down ([PlayerAging.packYouthDiscount]) from the row the age
  /// curve reads. So the markdown is added back here: read through the
  /// curve he is exactly the world's player on day one, and he grows out of
  /// it as a stored youngster does.
  List<Player>? coreOf(int nationId) {
    final squad = pack.squads[nationId];
    if (squad == null) return null;
    PlayerAttributes base(PackPlayer p) {
      final d = PlayerAging.packYouthDiscount(p.age);
      if (d == 0) return p.attributes;
      return PlayerAttributes(
        physical: p.attributes.physical + d,
        technical: p.attributes.technical + d,
        stamina: p.attributes.stamina + d,
      );
    }

    return _core[nationId] ??= List.unmodifiable([
      for (final p in squad)
        Player(
          id: p.id,
          nationId: nationId,
          name: p.name,
          age: p.age,
          position: p.position,
          attributes: base(p),
          club: p.club ?? 'Free agent',
          clubCountry: p.clubCountry ?? '',
        ),
    ]);
  }
}
