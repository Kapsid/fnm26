import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _andorra = 2;

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// [pack] with every player of [nationId] at 90 in every attribute.
WorldPack _allNineties(WorldPack pack, int nationId) => pack.copyWith(
  squads: {
    ...pack.squads,
    nationId: [
      for (final p in pack.squads[nationId]!)
        PackPlayer(
          id: p.id,
          name: p.name,
          age: p.age,
          position: p.position,
          attributes: const PlayerAttributes(
            physical: 90,
            technical: 90,
            stamina: 90,
          ),
          potential: 95,
          club: p.club,
          clubCountry: p.clubCountry,
        ),
    ],
  },
);

void main() {
  test(
    'an untouched pack gives exactly the base ranks',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
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

      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      expect(
        await c.read(seedRankingRepositoryProvider).forCycle(career.id, 0),
        {for (final n in world) n.id: n.ranking},
      );
    },
  );

  test(
    'Andorra at 90 overall climbs into the top 10',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      await packs.save(packId, _allNineties((await packs.load(packId))!, 2));

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

      final ranks = await c
          .read(seedRankingRepositoryProvider)
          .forCycle(career.id, 0);
      expect(ranks[_andorra], lessThanOrEqualTo(10));
      // The career's own world reads the same ranking.
      final nations = await c
          .read(nationRepositoryProvider)
          .forCareer(career.id);
      expect(
        nations.firstWhere((n) => n.id == _andorra).ranking,
        ranks[_andorra],
      );
    },
  );

  test(
    'a career keeps its world after the pack is edited and deleted',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      final original = (await packs.load(packId))!;
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

      await packs.save(packId, _allNineties(original, _andorra));
      await c.read(worldPackServiceProvider).delete(packId);

      final kept = await packs.forCareer(career.id);
      expect(kept, isNotNull);
      expect(kept!.pack.uuid, original.uuid);
      expect(kept.pack.squads, original.squads);
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(career.id, 0, 'world:${original.uuid}'),
        isTrue,
      );
    },
  );

  test(
    "career on a pack, then the pack is edited and deleted, the career's "
    'squads are unchanged',
    skip: 'needs Task 7 (player repo reads the career world)',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      final original = (await packs.load(packId))!;
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
      final players = c.read(playerRepositoryProvider);
      Future<Map<int, (String, PlayerAttributes)>> squad() async => {
        for (final p in await players.byNation(
          _andorra,
          saveSeed: career.rngSeed,
          careerId: career.id,
        ))
          if (p.id < 10000000) p.id: (p.name, p.attributes),
      };
      final before = await squad();
      expect(before, isNotEmpty);
      for (final p in original.squads[_andorra]!) {
        if (before[p.id] case final got?) {
          expect(got, (p.name, p.attributes), reason: 'player ${p.id}');
        }
      }

      await packs.save(packId, _allNineties(original, _andorra));
      await c.read(worldPackServiceProvider).delete(packId);

      expect(await squad(), before);
    },
  );

  test('a default career has no world', () async {
    final c = await _world();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: 1, managerName: 'M', rngSeed: 7))
            .valueOrNull!;
    expect(
      await c.read(worldPackRepositoryProvider).forCareer(career.id),
      isNull,
    );
    expect(
      await c
          .read(competitionRepositoryProvider)
          .watchedKindsWithPrefix(
            'world:',
          ),
      isEmpty,
    );
  });

  test(
    'campaigns never get a world',
    timeout: const Timeout.factor(4),
    () async {
      final c = await _world();
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('Mine');
      final run = await c
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me');
      expect(
        await c.read(worldPackRepositoryProvider).forCareer(run.id),
        isNull,
      );
      expect(
        await c
            .read(competitionRepositoryProvider)
            .watchedKindsWithPrefix(
              'world:',
            ),
        isEmpty,
      );
      // A run cannot be handed one either: it plays the world its seed was
      // searched on.
      await expectLater(
        c
            .read(careerServiceProvider)
            .create(
              nationId: 1,
              managerName: 'M',
              countsTowardSlots: false,
              worldPackId: packId,
            ),
        throwsArgumentError,
      );
    },
  );
}
