import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// [pack] grown past both off-UI thresholds: [extra] copies of its
/// squads as pools, each player with an id of his own.
WorldPack _big(WorldPack pack, {int extra = 3}) {
  var id = kPackPlayerIdBase;
  return pack.copyWith(
    pools: {
      for (final MapEntry(key: n, value: squad) in pack.squads.entries)
        n: [
          for (var i = 0; i < extra; i++)
            for (final p in squad)
              PackPlayer(
                id: id++,
                name: p.name,
                age: p.age,
                position: p.position,
                attributes: p.attributes,
                potential: p.potential,
                club: p.club,
                clubCountry: p.clubCountry,
              ),
        ],
    },
  );
}

int _players(WorldPack p) => [
  ...p.squads.values,
  ...p.pools.values,
].fold(0, (n, l) => n + l.length);

/// Opening a save on a big world, the nation pick and the editor's list
/// each read and decoded every world they touched, on the UI isolate, every
/// time: the Continue lag, the nation-pick freeze and the editor hang. A
/// world is now decoded once (off the UI isolate when it is big) and
/// checked once while it is unchanged.
void main() {
  test(
    'a pack past the off-UI size reads back whole',
    timeout: const Timeout.factor(6),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final big = _big(
        (await packs.load(
          await c.read(worldPackServiceProvider).createFromDefault('Base'),
        ))!,
      );
      final id = await packs.insert(big.copyWith(uuid: 'big', name: 'Big'), {});
      final read = (await packs.load(id))!;
      expect(_players(read), _players(big));
      expect(read.pools.keys, big.pools.keys);
      expect(read.name, 'Big');
    },
  );

  test(
    'a pack read twice unchanged is decoded once; a save is read afresh',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final id = await c.read(worldPackServiceProvider).createFromDefault('A');

      final first = (await packs.load(id))!;
      expect(identical(await packs.load(id), first), isTrue);
      // Another repository over the same database shares what was decoded.
      expect(
        identical(
          await WorldPackRepository(c.read(appDatabaseProvider)).load(id),
          first,
        ),
        isTrue,
      );

      await packs.save(id, first.copyWith(author: 'Me'));
      final saved = (await packs.load(id))!;
      expect(identical(saved, first), isFalse);
      expect(saved.author, 'Me');

      await packs.delete(id);
      expect(await packs.load(id), isNull);
      // The list reads its columns alone.
      expect(await packs.list(), isEmpty);
    },
  );

  test(
    "a career's world is decoded once and names its nation on the home card",
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      final pack = (await packs.load(packId))!;
      await packs.save(
        packId,
        pack.copyWith(nations: {1: (name: 'Northland', code: '')}),
      );
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: 1,
                    managerName: 'M',
                    rngSeed: 7,
                    worldPackId: packId,
                  ))
              .valueOrNull!;

      final first = (await packs.forCareer(career.id))!.pack;
      expect(
        identical((await packs.forCareer(career.id))!.pack, first),
        isTrue,
      );
      expect(await packs.careerNationNames({career.id: 1}), {
        career.id: 'Northland',
      });
    },
  );
}
