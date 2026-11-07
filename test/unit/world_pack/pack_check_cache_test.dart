import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_status.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
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
    'a big pack decodes and checks off the UI isolate, to the same answer',
    timeout: const Timeout.factor(6),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final base = (await packs.load(
        await c.read(worldPackServiceProvider).createFromDefault('Base'),
      ))!;
      final big = _big(base);
      expect(_players(big), greaterThanOrEqualTo(assessOffUiPlayers));
      final id = await packs.insert(big.copyWith(uuid: 'big', name: 'Big'), {});

      final read = (await packs.load(id))!;
      expect(_players(read), _players(big));
      expect(read.pools.keys, big.pools.keys);

      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      final facts = await c.read(packFactsProvider.future);
      final want = assessPack(read, world, facts: facts);
      final got = await assessPackAsync(read, world, facts: facts);
      expect(got.status, want.status);
      expect(got.issues.length, want.issues.length);
      // Asked again for the same pack, the answer is the one kept.
      expect(
        identical(await assessPackAsync(read, world, facts: facts), got),
        isTrue,
      );
    },
  );
}
