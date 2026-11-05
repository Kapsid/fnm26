import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The `draws_watched` kind (cycle 0) that records the world pack (by
/// [WorldPack.uuid]) a career was started on.
String worldPackMarker(String uuid) => 'world:$uuid';

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

  /// Every pack on the device, by name.
  Future<List<({int id, String name, DateTime updatedAt})>> list() async {
    final rows = await _db.select(_db.worldPacks).get();
    return [
      for (final r in rows) (id: r.id, name: r.name, updatedAt: r.updatedAt),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  /// The pack [id], or null if there is no such pack. A stored pack that
  /// cannot be read throws [FormatException] rather than reading as missing.
  Future<WorldPack?> load(int id) async {
    final row = await (_db.select(
      _db.worldPacks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _decode(row.json);
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
    final rows = await (_db.select(
      _db.careerWorlds,
    )..where((t) => t.careerId.isIn(nationByCareer.keys))).get();
    final out = <int, String>{};
    for (final r in rows) {
      final nationId = nationByCareer[r.careerId];
      if (nationId == null) continue;
      try {
        final name = _decode(r.json).nations[nationId]?.name;
        if (name != null && name.trim().isNotEmpty) out[r.careerId] = name;
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
                json: jsonEncode(p.toJson()),
                updatedAt: _clock(),
              ),
            );
        await _writeTrophies(id, trophies);
        return id;
      });

  /// Overwrites pack [id] with [p]. Trophy images are left as they are.
  Future<void> save(int id, WorldPack p) async {
    await (_db.update(_db.worldPacks)..where((t) => t.id.equals(id))).write(
      WorldPacksCompanion(
        uuid: Value(p.uuid),
        name: Value(p.name),
        json: Value(jsonEncode(p.toJson())),
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
    await _db
        .into(_db.careerWorlds)
        .insertOnConflictUpdate(
          CareerWorldsCompanion.insert(
            careerId: Value(careerId),
            packName: pack.name,
            json: jsonEncode(pack.toJson()),
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
    final row = await (_db.select(
      _db.careerWorlds,
    )..where((t) => t.careerId.equals(careerId))).getSingleOrNull();
    if (row == null) return null;
    final images = await (_db.select(
      _db.careerWorldTrophies,
    )..where((t) => t.careerId.equals(careerId))).get();
    return (
      pack: _decode(row.json),
      trophies: {for (final r in images) r.key: r.png},
    );
  }

  /// The sponsors career [careerId]'s world added, with that world's uuid;
  /// none (and no uuid) for the default world.
  ///
  /// Read wherever the sponsor round is (the hub, the finances, the cycle's
  /// close), so it is cheap on a repeat: a career's copy is written once,
  /// at its start, so the length of the stored JSON (read alone, no trophy
  /// images) is checked against the copy last decoded, and only a different
  /// one is read and decoded again. A world that cannot be read throws.
  Future<({String? world, List<PackSponsor> sponsors})> addedSponsorsFor(
    int careerId,
  ) async {
    final length = _db.careerWorlds.json.length;
    final q = _db.selectOnly(_db.careerWorlds)
      ..addColumns([length])
      ..where(_db.careerWorlds.careerId.equals(careerId));
    final n = (await q.getSingleOrNull())?.read(length);
    if (n == null) return (world: null, sponsors: const <PackSponsor>[]);
    final hit = _addedSponsors[careerId];
    if (hit != null && hit.length == n) return hit.value;
    final json =
        await (_db.selectOnly(_db.careerWorlds)
              ..addColumns([_db.careerWorlds.json])
              ..where(_db.careerWorlds.careerId.equals(careerId)))
            .map((r) => r.read(_db.careerWorlds.json)!)
            .getSingle();
    final pack = _decode(json);
    final value = (
      world: pack.uuid,
      sponsors: List<PackSponsor>.unmodifiable(pack.addedSponsors),
    );
    _addedSponsors[careerId] = (length: n, value: value);
    return value;
  }

  final Map<
    int,
    ({int length, ({String? world, List<PackSponsor> sponsors}) value})
  >
  _addedSponsors = {};

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
