import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

import '../../helpers/test_database.dart';

WorldPack _pack(String name) => WorldPack(
  uuid: 'uuid-$name',
  name: name,
  author: 'Me',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  nations: const {7: (name: 'Testland', code: 'TST')},
  clubs: const {'Old FC': 'New FC'},
  trophies: const {'worldChampionship'},
);

final _png = Uint8List.fromList([137, 80, 78, 71, 1, 2, 3]);

void main() {
  late AppDatabase db;
  late WorldPackRepository repo;

  setUp(() {
    db = createTestDatabase();
    repo = WorldPackRepository(db);
  });

  tearDown(() => db.close());

  Future<int> aCareer() => db
      .into(db.careers)
      .insert(
        CareersCompanion.insert(
          nationId: 1,
          managerName: 'Manager',
          createdAt: DateTime.utc(2030),
          inGameDate: DateTime.utc(2030, 6, 1),
          rngSeed: 7,
        ),
      );

  test('a trophy set with its pack writes both together', () async {
    final id = await repo.insert(_pack('Alpha'), {'worldChampionship': _png});
    final withEurope = _pack('Alpha').copyWith(
      trophies: {'worldChampionship', 'europe'},
    );
    await repo.setTrophy(id, 'europe', _png, pack: withEurope);
    expect((await repo.load(id))!.trophies, {'worldChampionship', 'europe'});
    expect((await repo.trophies(id)).keys, {'worldChampionship', 'europe'});

    await repo.setTrophy(id, 'europe', null, pack: _pack('Alpha'));
    expect((await repo.load(id))!.trophies, {'worldChampionship'});
    expect((await repo.trophies(id)).keys, {'worldChampionship'});
  });

  test('insert, load, save, duplicate, delete round trip', () async {
    final id = await repo.insert(_pack('Alpha'), {'worldChampionship': _png});

    expect(await repo.load(id), _pack('Alpha'));
    expect(await repo.trophies(id), {'worldChampionship': _png});
    final listed = await repo.list();
    expect(listed.map((e) => (e.id, e.name)), [(id, 'Alpha')]);

    final renamed = _pack('Alpha').copyWith(name: 'Beta');
    await repo.save(id, renamed);
    expect(await repo.load(id), renamed);
    expect((await repo.list()).single.name, 'Beta');

    await repo.setTrophy(id, 'continental', _png);
    expect((await repo.trophies(id)).keys, {
      'worldChampionship',
      'continental',
    });
    await repo.setTrophy(id, 'continental', null);
    expect((await repo.trophies(id)).keys, {'worldChampionship'});

    final copyId = await repo.duplicate(id, 'Gamma');
    expect(copyId, isNot(id));
    final copy = (await repo.load(copyId))!;
    expect(copy.name, 'Gamma');
    expect(copy.uuid, isNot(renamed.uuid), reason: 'a copy is its own pack');
    expect(copy.copyWith(name: 'Beta', uuid: renamed.uuid), renamed);
    expect(await repo.trophies(copyId), {'worldChampionship': _png});

    await repo.delete(id);
    expect(await repo.load(id), isNull);
    expect(await repo.trophies(id), isEmpty);
    expect((await repo.list()).map((e) => e.id), [copyId]);
  });

  test(
    'load runs the pack migration, and a newer pack is refused loudly',
    () async {
      final id = await repo.insert(_pack('Alpha'), const {});
      await db.customStatement(
        "UPDATE world_packs SET json = '{\"formatVersion\": 99}' WHERE id = $id",
      );
      // A missing row is null; a row that cannot be read is an error, never a
      // silent "no such pack" that would let the editor overwrite it.
      await expectLater(repo.load(id), throwsFormatException);
      expect(await repo.load(id + 100), isNull);
    },
  );

  test(
    'copyToCareer then delete the pack: forCareer still returns it',
    () async {
      final careerId = await aCareer();
      expect(await repo.forCareer(careerId), isNull, reason: 'default world');

      final packId = await repo.insert(_pack('Alpha'), {
        'worldChampionship': _png,
      });
      await db.transaction(() => repo.copyToCareer(packId, careerId));
      await repo.delete(packId);

      final world = await repo.forCareer(careerId);
      expect(world, isNotNull);
      expect(world!.pack, _pack('Alpha'));
      expect(world.trophies, {'worldChampionship': _png});

      // And the career's copy is its own: editing a new pack touches nothing.
      final otherCareer = await aCareer();
      expect(await repo.forCareer(otherCareer), isNull);
    },
  );

  test('deleting the career deletes its copy of the world', () async {
    final careerId = await aCareer();
    final packId = await repo.insert(_pack('Alpha'), {
      'worldChampionship': _png,
    });
    await db.transaction(() => repo.copyToCareer(packId, careerId));

    await DriftCareerRepository(db).delete(careerId);

    expect(await db.select(db.careerWorlds).get(), isEmpty);
    expect(await db.select(db.careerWorldTrophies).get(), isEmpty);
    expect(await repo.load(packId), isNotNull, reason: 'the pack stays');
  });
}
