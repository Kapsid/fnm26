import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/services/world_managers/manager_entrants.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
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

int _id(String code) => seedNations.firstWhere((n) => n.code == code).id;

void main() {
  test(
    "a career on a pack renaming Czechia's manager shows that name on day "
    'one, and later hires use pack name lists',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final cze = _id('CZE');
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      // Fictional lists of the pack's own for Czechia.
      final first = [
        for (var i = 0; i < 20; i++) 'Zdeslav${'abcdefghijklmnopqrst'[i]}',
      ];
      final sur = [
        for (var i = 0; i < 20; i++) 'Vrbovsky${'abcdefghijklmnopqrst'[i]}',
      ];
      await packs.save(
        packId,
        (await packs.load(packId))!.copyWith(
          managers: {cze: (name: 'Ota Brnák', nationality: 'SVK')},
          nameLists: {cze: PackNameLists(first: first, sur: sur)},
        ),
      );

      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: _id('ENG'),
                    managerName: 'M',
                    rngSeed: 7,
                    worldPackId: packId,
                  ))
              .valueOrNull!;

      // Day one: the pack's man is in charge of Czechia.
      await c.read(worldManagerServiceProvider).ensureSeeded(career.id);
      final world = await c
          .read(worldManagerRepositoryProvider)
          .load(career.id);
      final spell = world.currentAt(cze)!;
      final incumbent = world.managers.firstWhere(
        (m) => m.managerId == spell.managerId,
      );
      expect(incumbent.name, 'Ota Brnák');
      expect(incumbent.nationality, 'SVK');

      // Later hires: Czech newcomers (the entrants a hire draws from, here
      // drawn among Czechs alone) are named from the pack's lists.
      final nations = [
        for (final n
            in await c.read(nationRepositoryProvider).forCareer(career.id))
          if (n.id == cze) n,
      ];
      final players = c.read(playerRepositoryProvider);
      final entrants = ManagerEntrants.build(
        rngSeed: career.rngSeed,
        cycle: 1,
        date: DateTime(2030, 8),
        count: 30,
        firstId: 100000,
        nations: nations,
        pools: await players.namePoolsFor(career.id),
        defaultPools: await players.namePoolsFor(career.id, worldLists: false),
        exPlayers: const [],
      );
      final czech = [
        for (final m in entrants)
          if (m.nationality == 'CZE' && m.origin == ManagerOrigin.fresh) m,
      ];
      expect(czech, isNotEmpty);
      for (final m in czech) {
        final parts = m.name.split(' ');
        expect(first, contains(parts.first), reason: m.name);
        expect(sur, contains(parts.sublist(1).join(' ')), reason: m.name);
      }
    },
  );
}
