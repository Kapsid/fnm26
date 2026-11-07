import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_ranking.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/pack_status.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// The save seed of the one fixed name draw every new pack starts from.
///
/// The default world re-draws its players' names per save; a pack stores
/// names, so it takes this one draw (on the pools a career created now
/// reads), the same on every device and every day.
const int kPackDrawSeed = 20261104;

/// The game version a pack made now records.
const String kPackGameVersion = '1.1.0';

/// One pack as the list of packs shows it.
typedef WorldPackSummary = ({int id, String name, DateTime updatedAt});

final worldPackRepositoryProvider = Provider<WorldPackRepository>(
  (ref) => WorldPackRepository(ref.watch(appDatabaseProvider)),
);

/// The custom world career `careerId` runs on, as the [WorldZone] its
/// player reads need; null for a default career.
///
/// For the few reads OUTSIDE the player repository that ask the development
/// code about a player by id (the prospect star reads): the repository runs
/// its own reads in the zone, these run theirs in [WorldZone.runFor] with
/// this. A career's world never changes, so it is read once.
final FutureProviderFamily<WorldZoneData?, int> careerWorldZoneProvider =
    FutureProvider.family<WorldZoneData?, int>((
      ref,
      careerId,
    ) async {
      final stored = await ref
          .watch(worldPackRepositoryProvider)
          .forCareer(careerId);
      return stored == null ? null : WorldZoneData.of(stored.pack);
    });

/// Keeps [activeWorldProvider] on the world of the career whose screen is
/// open. See [enterActiveWorld] and [syncActiveWorld].
final activeWorldSyncProvider = Provider<ActiveWorldSync>(ActiveWorldSync.new);

int? _careerIdOf(Uri location) {
  final raw = location.queryParameters['careerId'];
  return raw == null ? null : int.tryParse(raw);
}

/// For the router's redirect: before a route into a career known to run on
/// a custom world builds, loads that world into [activeWorldProvider], so
/// the career's screens are built on its names from their first frame and
/// nothing they read is thrown away and read again when the world lands.
///
/// Null (nothing to wait for) for every other route, a default career's
/// included: their navigation stays exactly as synchronous as it was.
Future<void>? enterActiveWorld(Ref ref, Uri location) =>
    ref.read(activeWorldSyncProvider).enter(_careerIdOf(location));

/// For the router's delegate, which hears every change of route (a pop back
/// into a save included, which no redirect sees): leaving every career for
/// the menus drops the world; coming back into one reloads it.
///
/// [stack] is the delegate's whole configuration: the career is the topmost
/// route in it that names one, so a menu pushed over a career's screen (the
/// settings from the hub) keeps that career's world, and a career's screen
/// pushed over a menu has it.
void syncActiveWorld(Ref ref, RouteMatchList stack) =>
    ref.read(activeWorldSyncProvider).follow(careerIdOfStack(stack));

/// The career of the topmost route in [stack] that names one, or null when
/// none does (only menus are open).
///
/// [RouteMatchList.uri] is the location the stack was built from by `go`;
/// every route PUSHED onto it sits in an [ImperativeRouteMatch] with a
/// location of its own, possibly inside a shell.
int? careerIdOfStack(RouteMatchList stack) {
  int? found = _careerIdOf(stack.uri);
  void walk(List<RouteMatchBase> matches) {
    for (final m in matches) {
      if (m is ImperativeRouteMatch) {
        final id = _careerIdOf(m.matches.uri);
        if (id != null) found = id;
        walk(m.matches.matches);
      } else if (m is ShellRouteMatch) {
        walk(m.matches);
      }
    }
  }

  walk(stack.matches);
  return found;
}

/// The bookkeeping behind [enterActiveWorld] and [syncActiveWorld].
///
/// Which careers run on a custom world is learnt once at start-up ([prime])
/// and told as each one is created or brought onto the device ([noteWorld]).
/// Only those careers' worlds are ever read: every other career is a default
/// one, and entering it touches nothing (no database read, no wait), so
/// default careers navigate exactly as before.
///
/// [activeWorldProvider] is only ever written after an await or in a
/// microtask, never inside the router's own call, which can come in the
/// middle of a build. A world that loads after the manager has already left
/// its career is dropped.
class ActiveWorldSync {
  ActiveWorldSync(this._ref, {Future<Iterable<int>> Function()? listCareers})
    : _listCareers = listCareers;

  final Ref _ref;

  /// Reads the ids of the careers on a custom world; the database when null.
  /// A test hands in one that fails.
  final Future<Iterable<int>> Function()? _listCareers;

  /// Whether the last [prime] failed: the first career entered or followed
  /// after it lists the worlds again, rather than taking every career for a
  /// default one until the app restarts.
  bool _primeFailed = false;

  /// Careers known to run on a custom world.
  final Set<int> _withWorld = {};

  /// The career whose world is loaded or loading; null on the menus.
  int? _careerId;

  /// The load [enter] is waiting for, while it runs.
  Future<void>? _entering;

  /// [prime]'s read, while it runs. Nothing decides whether a career has a
  /// world until it is in: a save opened in the first moments after start-up
  /// would otherwise be taken for a default one.
  Future<void>? _priming;

  /// Learns which careers on this device run on a custom world.
  Future<void> prime() {
    late final Future<void> priming;
    priming = _listWorldCareers().whenComplete(() {
      if (identical(_priming, priming)) _priming = null;
    });
    return _priming = priming;
  }

  Future<void> _listWorldCareers() async {
    try {
      final ids = await (_listCareers ?? _storedWorldCareers)();
      _withWorld.addAll(ids);
      _primeFailed = false;
    } on Object catch (e, st) {
      _primeFailed = true;
      _report(e, st, 'listing the careers on a custom world');
    }
  }

  Future<Iterable<int>> _storedWorldCareers() async {
    final db = _ref.read(appDatabaseProvider);
    // The ids alone: each row also holds its world's whole JSON (megabytes
    // for a big one), and this runs at start-up, ahead of the first save
    // opened.
    final t = db.careerWorlds;
    final rows = await (db.selectOnly(t)..addColumns([t.careerId])).get();
    return rows.map((r) => r.read(t.careerId)!);
  }

  /// Lists the worlds again if the last [prime] failed and none is running.
  void _retryPrime() {
    if (_primeFailed && _priming == null) unawaited(prime());
  }

  /// Career [careerId] runs on a custom world: it has just been created on
  /// one, or brought onto this device with one.
  void noteWorld(int careerId) => _withWorld.add(careerId);

  /// Enters career [careerId]'s world; null [careerId] (a route outside any
  /// career) is left to [follow]. Returns the load to wait for, if any: a
  /// known world career's, or (while [prime] still runs) the list itself.
  Future<void>? enter(int? careerId) {
    if (careerId == null) return null;
    if (careerId == _careerId) return _entering;
    _careerId = careerId;
    _retryPrime();
    if (_priming == null && !_withWorld.contains(careerId)) {
      _entering = null;
      scheduleMicrotask(() => _switchTo(careerId));
      return null;
    }
    late final Future<void> entering;
    entering = _switchTo(careerId).whenComplete(() {
      if (identical(_entering, entering)) _entering = null;
    });
    return _entering = entering;
  }

  /// Follows the routes into career [careerId] (null: out of every career).
  void follow(int? careerId) {
    if (careerId == _careerId) return;
    _careerId = careerId;
    if (careerId != null) _retryPrime();
    _entering = null;
    scheduleMicrotask(() => _switchTo(careerId));
  }

  /// Sets the world of career [careerId] (null: none), if the routes are
  /// still in it once it is read. Reads only a career known to have one,
  /// once the start-up list is in.
  Future<void> _switchTo(int? careerId) async {
    if (_careerId != careerId) return;
    if (careerId != null) await _priming;
    final world = careerId != null && _withWorld.contains(careerId)
        ? await _load(careerId)
        : null;
    if (_careerId == careerId) _set(world ?? ActiveWorld.none);
  }

  void _set(ActiveWorld world) {
    final controller = _ref.read(activeWorldProvider.notifier);
    if (!identical(controller.state, world)) controller.state = world;
  }

  Future<ActiveWorld?> _load(int careerId) async {
    try {
      final stored = await _ref
          .read(worldPackRepositoryProvider)
          .forCareer(careerId);
      if (stored == null) return null;
      final db = _ref.read(appDatabaseProvider);
      final rows = await db.select(db.nations).get();
      return ActiveWorld(
        stored.pack,
        trophies: stored.trophies,
        realCodes: {for (final r in rows) r.id: r.code},
      );
    } on Object catch (e, st) {
      // A world that cannot be read shows the default names rather than
      // nothing at all; the career's own reads report the damage.
      _report(e, st, 'loading the world of career $careerId');
      return null;
    }
  }

  static void _report(Object e, StackTrace st, String doing) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'world pack',
          context: ErrorDescription(doing),
        ),
      );
}

/// What a pack is checked against besides the nations ([PackFacts]), read
/// afresh from [players] and [seed]. Call it in the zone that awaits it (a
/// widget test's fake async never completes a future made elsewhere).
Future<PackFacts> readPackFacts(
  PlayerRepository players,
  SeedSource seed,
) async => (
  fringeRanges: await players.fringeRanges(),
  cities: await seed.cities(),
);

/// [readPackFacts] for the providers that list packs. Seed data: read once.
final FutureProvider<PackFacts> packFactsProvider = FutureProvider<PackFacts>(
  (ref) => readPackFacts(
    ref.watch(playerRepositoryProvider),
    ref.watch(seedSourceProvider),
  ),
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
    // The default world in Settings never names a pack that is gone.
    onDeleted: (uuid) => ref.read(defaultWorldProvider.notifier).clearIf(uuid),
  ),
);

/// Creates, copies and removes world packs.
class WorldPackService {
  WorldPackService({
    required PlayerRepository players,
    required NationRepository nations,
    required WorldPackRepository packs,
    void Function()? onChanged,
    Future<void> Function(String uuid)? onDeleted,
    int maxFileBytes = PackCodec.maxFileBytes,
  }) : _maxFileBytes = maxFileBytes,
       _players = players,
       _nations = nations,
       _packs = packs,
       _onChanged = onChanged ?? _noop,
       _onDeleted = onDeleted;

  /// The largest file [export] writes: [PackCodec.maxFileBytes], the cap
  /// every device reads to (smaller only in tests).
  final int _maxFileBytes;
  final PlayerRepository _players;
  final NationRepository _nations;
  final WorldPackRepository _packs;
  final void Function() _onChanged;

  /// Told the uuid of each pack [delete] removes.
  final Future<void> Function(String uuid)? _onDeleted;

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
  ///
  /// Read from the stored core rows, with no name draw (a name moves no
  /// rating, and on day one a core player's rating is his stored one), and
  /// kept for the life of this service: it depends only on the build and
  /// its seed rows. A read that fails is not kept.
  Future<Map<int, int>> defaultStrength() =>
      _defaultStrength ??= _readDefaultStrength().catchError((
        Object e,
        StackTrace st,
      ) {
        _defaultStrength = null;
        Error.throwWithStackTrace(e, st);
      });

  Future<Map<int, int>>? _defaultStrength;

  Future<Map<int, int>> _readDefaultStrength() async {
    final overalls = <int, List<int>>{};
    for (final p in await _players.coreRatings()) {
      (overalls[p.nationId] ??= []).add(p.overall);
    }
    return {
      for (final nation in await _nations.newCareerWorld())
        nation.id: PackRanking.strength(overalls[nation.id] ?? const []),
    };
  }

  /// The squads [createFromDefault] stores, by nation id: each nation's
  /// stored core players as a career created now meets them, a veteran the
  /// default world retires on day one included (he is one of the stored 23).
  Future<Map<int, List<PackPlayer>>> defaultSquads() async {
    final squads = <int, List<PackPlayer>>{};
    for (final nation in await _nations.newCareerWorld()) {
      final core = await _players.coreAsBorn(
        nation.id,
        saveSeed: kPackDrawSeed,
        newCareerNames: true,
      );
      squads[nation.id] = [
        for (final p in core.sortedBy<num>((p) => p.id)) _packPlayerOf(p),
      ];
    }
    return squads;
  }

  /// Nation [nationId]'s generated pool as [pack] shows it before the pool
  /// is fixed: the stored fringe on day one, named in the [kPackDrawSeed]
  /// draw from [pack]'s name lists for the nation (the game's pools when it
  /// has none), at their day-one clubs, with potential as [defaultSquads]
  /// gives it and traits left on Random. Nothing else in [pack], its squad
  /// least of all, moves it. Fixing a pool stores exactly this.
  Future<List<PackPlayer>> generatedPool(int nationId, WorldPack pack) async {
    final fringe = await _players.fringeAsBorn(
      nationId,
      saveSeed: kPackDrawSeed,
      nameLists: pack.nameLists[nationId],
    );
    return [for (final p in fringe) _packPlayerOf(p)];
  }

  /// [p] as a pack stores him: potential the peak
  /// [PlayerLifecycle.peakOverall] gives, never below the overall he already
  /// has; traits left on Random.
  static PackPlayer _packPlayerOf(Player p) => PackPlayer(
    id: p.id,
    name: p.name,
    age: p.age,
    position: p.position,
    attributes: p.attributes,
    potential: max(
      p.overall,
      PlayerLifecycle.peakOverall(p.id, p.position, p.attributes, p.age),
    ),
    club: p.club,
    clubCountry: p.clubCountry.isEmpty ? null : p.clubCountry,
  );

  /// Copies pack [id] as a new pack named [name]; returns the copy's id.
  Future<int> duplicate(int id, String name) async {
    final copy = await _packs.duplicate(id, name);
    _onChanged();
    return copy;
  }

  /// Writes pack [id] to `<name>.fnmdb` in [into] (the temporary directory
  /// when null) and returns the file; the UI hands it to the share sheet.
  ///
  /// The size is measured first: a file over the cap every device reads to
  /// would be refused everywhere, so instead of writing one this throws
  /// [PackTooBigToShare] and the editor says so.
  Future<File> export(int id, {Directory? into}) async {
    final pack = await _packs.load(id);
    if (pack == null) throw StateError('No world pack $id');
    final bytes = PackCodec.encode(pack, await _packs.trophies(id));
    if (bytes.length > _maxFileBytes) throw PackTooBigToShare(bytes.length);
    final dir = into ?? await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        '${PackCodec.fileStem(pack.name)}.${PackCodec.extension}',
      ),
    );
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Reads the `.fnmdb` file at [path] as a new pack with a new uuid; a name
  /// already taken becomes "Name (2)", "Name (3)" and so on. Nothing is
  /// written unless every check passes. The failure's code is the
  /// [PackRejection] name.
  Future<Result<int>> importFile(String path) async {
    final Uint8List bytes;
    try {
      final file = File(path);
      if (await file.length() > PackCodec.maxFileBytes) {
        return Result.failure(
          Failure('Too big', code: PackRejection.tooBig.name),
        );
      }
      bytes = await file.readAsBytes();
    } on Object catch (e) {
      return Result.failure(
        Failure('Unreadable', code: PackRejection.notAPack.name, cause: e),
      );
    }
    final world = await _nations.newCareerWorld();
    final decoded = await PackCodec.decode(
      bytes,
      baseCodes: {for (final n in world) n.id: n.code},
    );
    switch (decoded) {
      case PackRejected(:final reason):
        return Result.failure(Failure('Refused', code: reason.name));
      case PackDecoded(:final pack, :final trophies):
        final taken = {for (final e in await _packs.list()) e.name};
        var name = pack.name;
        for (var n = 2; taken.contains(name); n++) {
          final suffix = ' ($n)';
          final base = PackRules.fitName(
            pack.name,
            max: PackRules.nameMax - PackRules.nameLength(suffix),
          );
          name = '$base$suffix';
        }
        final id = await _packs.insert(
          pack.copyWith(uuid: _packs.newUuid(), name: name),
          trophies,
        );
        _onChanged();
        return Result.success(id);
    }
  }

  /// Removes pack [id]. Careers started on it keep their own copy. If it was
  /// the default world in Settings, Default is again.
  Future<void> delete(int id) async {
    final uuid = await _packs.uuidOf(id);
    await _packs.delete(id);
    if (uuid != null) await _onDeleted?.call(uuid);
    _onChanged();
  }
}
