@Tags(['slow'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import 'driver.dart';

/// A nation whose fixed pool is emptied in the editor has only its squad
/// (and, as every nation, the youth coming through) to call on. Three
/// cycles on such a pack: call-ups, injuries and finals squads must hold.
/// Every match the nation plays is played with a full squad,
/// and it reaches finals with one.
void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  testWidgets(
    'three cycles with a fixed pool emptied',
    timeout: const Timeout(Duration(minutes: 90)),
    (tester) async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final fra = storyNations.firstWhere((n) => n.code == 'FRA').id;
      final clock = Stopwatch()..start();

      late int careerId;
      await tester.runAsync(() async {
        await c.read(seedLoaderProvider).ensureSeeded();
        final service = c.read(worldPackServiceProvider);
        final packs = c.read(worldPackRepositoryProvider);
        final packId = await service.createFromDefault('Empty pool');
        final pack = (await packs.load(packId))!;
        // The Pool tab with every player removed: a fixed pool of nobody.
        await packs.save(packId, pack.copyWith(pools: {fra: const []}));
        expect((await packs.load(packId))!.pools[fra], isEmpty);
        careerId =
            (await c
                    .read(careerServiceProvider)
                    .create(
                      nationId: fra,
                      managerName: 'M. Urbanczyk',
                      rngSeed: 11,
                      worldPackId: packId,
                    ))
                .valueOrNull!
                .id;
      });

      var matches = 0; // every match he plays, friendlies too
      var finalsMatches = 0;
      var smallest = kMaxSquadSize;
      await tester.runAsync(() async {
        final names = <int, String>{};
        final d = StoryDriver(c, careerId)
          ..afterMatch = (f) async {
            if (f.homeNationId != fra && f.awayNationId != fra) return;
            if (names[f.competitionId] == null) {
              names.addAll(
                await c
                    .read(competitionRepositoryProvider)
                    .competitionNames(careerId),
              );
            }
            final name = names[f.competitionId] ?? '';
            if (name.isEmpty) return;
            final called = await c
                .read(squadRepositoryProvider)
                .callUps(careerId);
            matches++;
            if (called.length < smallest) smallest = called.length;
            if (name == 'World Championship' ||
                name == 'European Championship') {
              finalsMatches++;
            }
          };
        final careers = c.read(careerRepositoryProvider);
        Future<int> cycle() async =>
            (await careers.byId(careerId))!.cyclePointer;
        for (var i = 0; i < 30000 && await cycle() < 3; i++) {
          await d.step();
        }
        expect(await cycle(), 3, reason: 'three cycles played');
      });
      // A record of the run, for whoever wonders why the suite is slow.
      // ignore: avoid_print
      print(
        'empty pool: $matches matches ($finalsMatches at finals), '
        'smallest squad $smallest, ${clock.elapsed.inSeconds}s',
      );
      expect(matches, greaterThan(0));
      expect(smallest, kMaxSquadSize, reason: 'a full squad every match');
      expect(finalsMatches, greaterThan(0), reason: 'France reached finals');
    },
  );
}
