import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// A seeded container with career 1, a default career moved onto a world
/// that renames nation 1. Nothing has told the sync about it yet.
Future<(ProviderContainer, int)> _careerOnWorld() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await c
              .read(careerServiceProvider)
              .create(nationId: 1, managerName: 'M', rngSeed: 7))
          .valueOrNull!;
  final packs = c.read(worldPackRepositoryProvider);
  final packId = await packs.insert(
    const WorldPack(
      uuid: 'sync',
      name: 'Sync',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      nations: {1: (name: 'Renamed', code: 'RNM')},
    ),
    const {},
  );
  await packs.copyToCareer(packId, career.id);
  return (c, career.id);
}

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  test('a career entered while start-up is still listing the worlds waits '
      'for the list', () async {
    final (c, careerId) = await _careerOnWorld();
    final sync = c.read(activeWorldSyncProvider);
    final priming = sync.prime();
    // Entered before the list is in: it must wait for it, not decide the
    // career is a default one.
    final entering = sync.enter(careerId);
    expect(entering, isNotNull);
    await entering;
    await priming;
    expect(c.read(activeWorldProvider).nationName(1), 'Renamed');
  });

  test('a route followed while start-up is still listing the worlds waits '
      'for the list', () async {
    final (c, careerId) = await _careerOnWorld();
    final sync = c.read(activeWorldSyncProvider);
    final priming = sync.prime();
    sync.follow(careerId);
    await priming;
    // The follow's load runs after the list, in its own microtask.
    for (var i = 0; i < 20; i++) {
      await Future<void>.delayed(Duration.zero);
      if (!c.read(activeWorldProvider).isDefault) break;
    }
    expect(c.read(activeWorldProvider).nationName(1), 'Renamed');
  });

  test(
    'a failed start-up list is read again when a career is entered',
    () async {
      final (c0, careerId) = await _careerOnWorld();
      var calls = 0;
      final db = c0.read(appDatabaseProvider);
      final c = ProviderContainer(
        parent: c0,
        overrides: [
          activeWorldSyncProvider.overrideWith(
            (ref) => ActiveWorldSync(
              ref,
              listCareers: () async {
                calls++;
                if (calls == 1) throw StateError('database busy');
                final rows = await db.select(db.careerWorlds).get();
                return rows.map((r) => r.careerId);
              },
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      final sync = c.read(activeWorldSyncProvider);
      final errors = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      addTearDown(() => FlutterError.onError = previous);

      await sync.prime();
      expect(errors, hasLength(1));
      // The first career entered lists the worlds again and waits for it.
      final entering = sync.enter(careerId);
      expect(entering, isNotNull);
      await entering;
      expect(calls, 2);
      expect(c0.read(activeWorldProvider).nationName(1), 'Renamed');
    },
  );

  test(
    'a failed start-up list is read again when a route is followed',
    () async {
      final (c0, careerId) = await _careerOnWorld();
      var calls = 0;
      final db = c0.read(appDatabaseProvider);
      final c = ProviderContainer(
        parent: c0,
        overrides: [
          activeWorldSyncProvider.overrideWith(
            (ref) => ActiveWorldSync(
              ref,
              listCareers: () async {
                calls++;
                if (calls == 1) throw StateError('database busy');
                final rows = await db.select(db.careerWorlds).get();
                return rows.map((r) => r.careerId);
              },
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      final sync = c.read(activeWorldSyncProvider);
      final previous = FlutterError.onError;
      FlutterError.onError = (_) {};
      addTearDown(() => FlutterError.onError = previous);

      await sync.prime();
      sync.follow(careerId);
      for (var i = 0; i < 50; i++) {
        await Future<void>.delayed(Duration.zero);
        if (!c0.read(activeWorldProvider).isDefault) break;
      }
      expect(calls, 2);
      expect(c0.read(activeWorldProvider).nationName(1), 'Renamed');
    },
  );
}
