import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The `draws_watched` kind (cycle 0) that records the world pack (by
/// [WorldPack.uuid]) a career was started on.
String worldPackMarker(String uuid) => 'world:$uuid';

/// What a career's world added that is read outside its player reads.
typedef _Added = ({
  String? world,
  List<PackSponsor> sponsors,
  List<PackYAccount> yAccounts,
  Map<int, ({String name, String nationality})> managers,
});

/// The custom databases (world packs) on this device, and the copy a career
/// takes of one.
///
/// A pack is stored as its JSON document plus one PNG row per custom trophy.
/// Starting a career on a pack copies both into the career's own tables
/// ([copyToCareer]); from then on the career reads only [forCareer], so the
/// pack can be edited or deleted without touching any save.
///
/// The database does not enforce its foreign keys (see
/// `DriftCareerRepository.delete`), so child rows are removed by hand.
class WorldPackRepository {
  WorldPackRepository(this._db, {DateTime Function()? clock, Random? random})
    : _clock = clock ?? DateTime.now,
      _random = random ?? Random.secure();

  final AppDatabase _db;
  final DateTime Function() _clock;
  final Random _random;

  /// Every pack on the device, by name. Reads the columns it lists alone:
  /// no pack's JSON is read.
  Future<List<({int id, String name, DateTime updatedAt})>> list() async {
    final t = _db.worldPacks;
    final q = _db.selectOnly(t)..addColumns([t.id, t.name, t.updatedAt]);
    return [
      for (final r in await q.get())
        (
          id: r.read(t.id)!,
          name: r.read(t.name)!,
          updatedAt: r.read(t.updatedAt)!,
        ),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  /// The pack [id], or null if there is no such pack. A stored pack that
  /// cannot be read throws [FormatException] rather than reading as missing.
  ///
  /// A pack read before and unchanged since (same stamp and length) is
  /// handed back as it was decoded: a big one takes a good part of a second
  /// to decode on a phone, and the nation pick, New Game's world chip and
  /// the editor's list all read every pack. The pack is shared, so it is
  /// never changed in place (nothing does: every edit is a
  /// [WorldPack.copyWith]).
  Future<WorldPack?> load(int id) async {
    final t = _db.worldPacks;
    final length = t.json.length;
    final stamp =
        await (_db.selectOnly(t)
              ..addColumns([t.updatedAt, length])
              ..where(t.id.equals(id)))
            .getSingleOrNull();
    if (stamp == null) {
      _cache.packs.remove(id);
      return null;
    }
    final key = (
      updatedAt: stamp.read(t.updatedAt)!,
      length: stamp.read(length)!,
    );
    final hit = _cache.packs[id];
    if (hit != null && hit.key == key) return hit.pack;
    final json =
        await (_db.selectOnly(t)
              ..addColumns([t.json])
              ..where(t.id.equals(id)))
            .map((r) => r.read(t.json)!)
            .getSingleOrNull();
    if (json == null) return null;
    final pack = await _decodeOffUi(json);
    _cache.packs[id] = (key: key, pack: pack);
    return pack;
  }

  /// The uuid of pack [id], or null if there is no such pack. Reads the
  /// column alone: no pack is decoded.
  Future<String?> uuidOf(int id) async {
    final q = _db.selectOnly(_db.worldPacks)
      ..addColumns([_db.worldPacks.uuid])
      ..where(_db.worldPacks.id.equals(id));
    return (await q.getSingleOrNull())?.read(_db.worldPacks.uuid);
  }

  /// The pack name each career on a custom world was started on, by career
  /// id; a default-world career is not in it. Reads the name column alone.
  Future<Map<int, String>> careerWorldNames() async {
    final q = _db.selectOnly(_db.careerWorlds)
      ..addColumns([_db.careerWorlds.careerId, _db.careerWorlds.packName]);
    return {
      for (final r in await q.get())
        r.read(_db.careerWorlds.careerId)!: r.read(_db.careerWorlds.packName)!,
    };
  }

  /// The name its world gives each career's nation, by career id, for the
  /// careers in [nationByCareer] (career id to its nation) whose world
  /// renamed that nation. A world that cannot be read names nothing.
  Future<Map<int, String>> careerNationNames(
    Map<int, int> nationByCareer,
  ) async {
    final t = _db.careerWorlds;
    final q = _db.selectOnly(t)
      ..addColumns([t.careerId])
      ..where(t.careerId.isIn(nationByCareer.keys));
    final out = <int, String>{};
    for (final r in await q.get()) {
      final careerId = r.read(t.careerId)!;
      final nationId = nationByCareer[careerId];
      if (nationId == null) continue;
      try {
        final name = (await _careerPack(careerId))?.nations[nationId]?.name;
        if (name != null && name.trim().isNotEmpty) out[careerId] = name;
      } on FormatException {
        // Shown under the default name; the career's own reads report it.
      }
    }
    return out;
  }

  /// Stores [p] as a new pack with its [trophies], and returns its id.
  Future<int> insert(WorldPack p, Map<String, Uint8List> trophies) =>
      _db.transaction(() async {
        final id = await _db
            .into(_db.worldPacks)
            .insert(
              WorldPacksCompanion.insert(
                uuid: p.uuid,
                name: p.name,
                json: jsonEncode(p.asWritten.toJson()),
                updatedAt: _clock(),
              ),
            );
        await _writeTrophies(id, trophies);
        return id;
      });

  /// Overwrites pack [id] with [p]. Trophy images are left as they are.
  Future<void> save(int id, WorldPack p) async {
    _cache.packs.remove(id);
    await (_db.update(_db.worldPacks)..where((t) => t.id.equals(id))).write(
      WorldPacksCompanion(
        uuid: Value(p.uuid),
        name: Value(p.name),
        json: Value(jsonEncode(p.asWritten.toJson())),
        updatedAt: Value(_clock()),
      ),
    );
  }

  /// Sets (or, with a null [png], removes) the image for trophy [key].
  ///
  /// With [pack], also overwrites the pack with it in the same transaction,
  /// so the stored [WorldPack.trophies] and the image rows change together.
  Future<void> setTrophy(
    int id,
    String key,
    Uint8List? png, {
    WorldPack? pack,
  }) => _db.transaction(() async {
    if (pack != null) await save(id, pack);
    if (png == null) {
      await (_db.delete(
        _db.worldPackTrophies,
      )..where((t) => t.packId.equals(id) & t.key.equals(key))).go();
    } else {
      await _db
          .into(_db.worldPackTrophies)
          .insertOnConflictUpdate(
            WorldPackTrophiesCompanion.insert(
              packId: id,
              key: key,
              png: png,
            ),
          );
    }
    await _touch(id);
  });

  /// The custom trophy images of pack [id], by key.
  Future<Map<String, Uint8List>> trophies(int id) async {
    final rows = await (_db.select(
      _db.worldPackTrophies,
    )..where((t) => t.packId.equals(id))).get();
    return {for (final r in rows) r.key: r.png};
  }

  /// Removes pack [id] and its images. Careers started on it keep their copy.
  Future<void> delete(int id) => _db.transaction(() async {
    _cache.packs.remove(id);
    await (_db.delete(
      _db.worldPackTrophies,
    )..where((t) => t.packId.equals(id))).go();
    await (_db.delete(_db.worldPacks)..where((t) => t.id.equals(id))).go();
  });

  /// Copies pack [id] (with its images) as a new pack named [newName], with a
  /// fresh uuid so the two are never mistaken for one another. Returns the
  /// copy's id.
  Future<int> duplicate(int id, String newName) => _db.transaction(() async {
    final pack = await load(id);
    if (pack == null) throw StateError('No world pack $id');
    return insert(
      pack.copyWith(uuid: newUuid(), name: newName),
      await trophies(id),
    );
  });

  /// Gives career [careerId] its own copy of pack [packId]: the (migrated)
  /// JSON and every trophy image.
  ///
  /// Opens no transaction of its own: it is meant to run inside the one that
  /// creates the career, so a career never exists without its world.
  Future<void> copyToCareer(int packId, int careerId) async {
    final pack = await load(packId);
    if (pack == null) throw StateError('No world pack $packId');
    _cache.careers.remove(careerId);
    await _db
        .into(_db.careerWorlds)
        .insertOnConflictUpdate(
          CareerWorldsCompanion.insert(
            careerId: Value(careerId),
            packName: pack.name,
            json: jsonEncode(pack.asWritten.toJson()),
          ),
        );
    await (_db.delete(
      _db.careerWorldTrophies,
    )..where((t) => t.careerId.equals(careerId))).go();
    for (final e in (await trophies(packId)).entries) {
      await _db
          .into(_db.careerWorldTrophies)
          .insert(
            CareerWorldTrophiesCompanion.insert(
              careerId: careerId,
              key: e.key,
              png: e.value,
            ),
          );
    }
  }

  /// The world career [careerId] was started on, or null for the default
  /// world.
  Future<({WorldPack pack, Map<String, Uint8List> trophies})?> forCareer(
    int careerId,
  ) async {
    final pack = await _careerPack(careerId);
    if (pack == null) return null;
    final images = await (_db.select(
      _db.careerWorldTrophies,
    )..where((t) => t.careerId.equals(careerId))).get();
    return (pack: pack, trophies: {for (final r in images) r.key: r.png});
  }

  /// Career [careerId]'s copy of its world, decoded; null for a career on
  /// the default world. A career's copy is written once, when it starts, so
  /// a copy decoded before is handed back while the stored one still has
  /// the same name and length (read alone: no JSON crosses for that).
  /// Opening a save on a big world read and decoded it three times over
  /// before the hub could show (the home card, the world the screens are
  /// named in, the player reads), each time on the UI isolate.
  Future<WorldPack?> _careerPack(int careerId) async {
    final t = _db.careerWorlds;
    final length = t.json.length;
    final stamp =
        await (_db.selectOnly(t)
              ..addColumns([t.packName, length])
              ..where(t.careerId.equals(careerId)))
            .getSingleOrNull();
    if (stamp == null) {
      _cache.careers.remove(careerId);
      return null;
    }
    final key = (name: stamp.read(t.packName)!, length: stamp.read(length)!);
    final hit = _cache.careers[careerId];
    if (hit != null && hit.key == key) return hit.pack;
    final json =
        await (_db.selectOnly(t)
              ..addColumns([t.json])
              ..where(t.careerId.equals(careerId)))
            .map((r) => r.read(t.json)!)
            .getSingleOrNull();
    if (json == null) return null;
    final pack = await _decodeOffUi(json);
    _cache.careers[careerId] = (key: key, pack: pack);
    return pack;
  }

  /// The sponsors career [careerId]'s world added, with that world's uuid;
  /// none (and no uuid) for the default world. See [_addedFor] for the cost;
  /// a world that cannot be read throws.
  Future<({String? world, List<PackSponsor> sponsors})> addedSponsorsFor(
    int careerId,
  ) async {
    final added = await _addedFor(careerId);
    return (world: added.world, sponsors: added.sponsors);
  }

  /// The Y accounts career [careerId]'s world added, every nation's; none
  /// for the default world. See [_addedFor]; a world that cannot be read
  /// throws.
  Future<List<PackYAccount>> addedYAccountsFor(int careerId) async =>
      (await _addedFor(careerId)).yAccounts;

  /// [addedYAccountsFor], with that world's uuid (null for the default
  /// world): what a per-language name of an added account is looked up by
  /// (`ActiveWorld.addedYName`).
  Future<({String? world, List<PackYAccount> yAccounts})> addedYFor(
    int careerId,
  ) async {
    final added = await _addedFor(careerId);
    return (world: added.world, yAccounts: added.yAccounts);
  }

  /// The day-one managers career [careerId]'s world names, by nation id;
  /// none for the default world. See [_addedFor]; a world that cannot be
  /// read throws.
  Future<Map<int, ({String name, String nationality})>> managersFor(
    int careerId,
  ) async => (await _addedFor(careerId)).managers;

  /// What career [careerId]'s world added that the career reads outside its
  /// player reads: its sponsors, Y accounts and day-one managers, with the
  /// world's uuid.
  ///
  /// Read wherever the sponsor round is (the hub, the finances, the cycle's
  /// close) and on every Y feed build, so it is cheap on a repeat: a
  /// career's copy is written once, at its start, so the length of the
  /// stored JSON (read alone, no trophy images) is checked against the copy
  /// last decoded, and only a different one is read and decoded again. A
  /// world that cannot be read throws.
  Future<_Added> _addedFor(int careerId) async {
    final pack = await _careerPack(careerId);
    if (pack == null) return _none;
    final hit = _added[careerId];
    if (hit != null && identical(hit.pack, pack)) return hit.value;
    final value = (
      world: pack.uuid,
      sponsors: List<PackSponsor>.unmodifiable(pack.addedSponsors),
      yAccounts: List<PackYAccount>.unmodifiable(pack.addedYAccounts),
      managers: Map<int, ({String name, String nationality})>.unmodifiable(
        pack.managers,
      ),
    );
    _added[careerId] = (pack: pack, value: value);
    return value;
  }

  static const _Added _none = (
    world: null,
    sponsors: <PackSponsor>[],
    yAccounts: <PackYAccount>[],
    managers: <int, ({String name, String nationality})>{},
  );

  final Map<int, ({WorldPack pack, _Added value})> _added = {};

  /// The decoded packs of [_db], shared by every repository over it (the
  /// player repository makes its own).
  _PackCache get _cache => _caches[_db] ??= _PackCache();
  static final Expando<_PackCache> _caches = Expando('world pack cache');

  /// Stored JSON from this long up is decoded on a background isolate:
  /// a real-names world (25,000 players, about 5 MB) took 150 ms on a
  /// desktop and far longer on a phone, every frame of it lost. A smaller
  /// one (the game's own world as a new pack is under 1 MB) decodes in
  /// less time than an isolate takes to start.
  static const int offUiDecodeChars = 1 << 20;

  static Future<WorldPack> _decodeOffUi(String json) =>
      json.length < offUiDecodeChars
      ? Future.value(_decode(json))
      : Isolate.run(() => _decode(json), debugName: 'world pack decode');

  static WorldPack _decode(String json) {
    final raw = jsonDecode(json);
    if (raw is! Map<String, Object?>) {
      throw const FormatException('A stored world pack is not an object');
    }
    return WorldPack.fromJson(WorldPack.migrate(raw));
  }

  Future<void> _writeTrophies(int id, Map<String, Uint8List> trophies) async {
    for (final e in trophies.entries) {
      await _db
          .into(_db.worldPackTrophies)
          .insert(
            WorldPackTrophiesCompanion.insert(
              packId: id,
              key: e.key,
              png: e.value,
            ),
          );
    }
  }

  Future<void> _touch(int id) async {
    await (_db.update(_db.worldPacks)..where((t) => t.id.equals(id))).write(
      WorldPacksCompanion(updatedAt: Value(_clock())),
    );
  }

  /// A random (version 4) UUID, for a new pack or a copy.
  String newUuid() {
    final b = List<int>.generate(16, (_) => _random.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    final hex = [for (final x in b) x.toRadixString(16).padLeft(2, '0')];
    return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-'
        '${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-'
        '${hex.sublist(10).join()}';
  }
}

/// See [WorldPackRepository._cache]: each pack (by id) and each career's
/// copy (by career id) as last decoded, with what it was read under.
class _PackCache {
  final Map<int, ({({DateTime updatedAt, int length}) key, WorldPack pack})>
  packs = {};
  final Map<int, ({({String name, int length}) key, WorldPack pack})> careers =
      {};
}
