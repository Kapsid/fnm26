// A local timing probe, not a regression test: run it by hand with
// FNM_PERF_PACK=/path/to/a/big.fnmdb to time the paths behind the
// continue-lag, nation-pick and editor bugs. Skipped otherwise.
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_status.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import 'package:drift/native.dart';
import 'package:fnm/data/db/app_database.dart';
import '../unit/greenland/greenland_fixtures.dart';

final String? _packPath = Platform.environment['FNM_PERF_PACK'];

/// Times [f]: wall clock, and the longest stretch the isolate was blocked
/// (a 1 ms ticker's longest gap), which is what a frame would wait for.
Future<T> _time<T>(String label, Future<T> Function() f) async {
  final sw = Stopwatch()..start();
  var last = 0;
  var worst = 0;
  final ticker = Timer.periodic(const Duration(milliseconds: 1), (_) {
    final now = sw.elapsedMilliseconds;
    worst = max(worst, now - last);
    last = now;
  });
  final out = await f();
  ticker.cancel();
  final now = sw.elapsedMilliseconds;
  worst = max(worst, now - last);
  // ignore: avoid_print
  print(
    'PERF ${label.padRight(40)} ${'$now'.padLeft(6)} ms  '
    'blocked ${'$worst'.padLeft(5)} ms',
  );
  return out;
}

void main() {
  test(
    'probe',
    skip: _packPath == null ? 'set FNM_PERF_PACK' : false,
    timeout: const Timeout(Duration(minutes: 20)),
    () async {
      final dir = Directory.systemTemp.createTempSync('fnm_perf');
      addTearDown(() => dir.deleteSync(recursive: true));
      // As the app opens it: on a background isolate.
      final db = AppDatabase.forTesting(
        NativeDatabase.createInBackground(File('${dir.path}/db.sqlite')),
      );
      addTearDown(db.close);
      final c = greenlandContainer(db);
      addTearDown(c.dispose);
      await _time('seed', () => c.read(seedLoaderProvider).ensureSeeded());

      final service = c.read(worldPackServiceProvider);
      final real = await _time(
        'import pack',
        () => service.importFile(_packPath!),
      );
      final realId = real.valueOrNull!;
      await _time(
        'editor New (createFromDefault)',
        () => service.createFromDefault('New'),
      );
      await _time(
        'editorPacksProvider (list)',
        () => c.read(editorPacksProvider.future),
      );
      final repo = c.read(worldPackRepositoryProvider);
      final pack = (await _time('repo.load(real)', () => repo.load(realId)))!;
      await _time('repo.load(real) again', () => repo.load(realId));
      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      final facts = await c.read(packFactsProvider.future);
      await _time(
        'assessPack(real), sync (one editor edit)',
        () async => assessPack(pack, world, facts: facts),
      );
      final picked = await c.read(nationsProvider.future);
      await _time(
        'assessPackAsync(real), nation pick world',
        () => assessPackAsync(pack, picked, facts: facts),
      );
      await _time(
        'assessPackAsync(real), again',
        () => assessPackAsync(pack, picked, facts: facts),
      );
      await _time(
        'appLocalizations',
        () async => c.read(appLocalizationsProvider),
      );
      // ignore: avoid_print
      print(
        'PERF players in pack: ${pack.squads.values.fold<int>(0, (s, l) => s + l.length)} + pools ${pack.pools.values.fold<int>(0, (s, l) => s + l.length)}',
      );

      await _time(
        'worldChoicesProvider',
        () => c.read(worldChoicesProvider.future),
      );
      await _time('nationsProvider', () => c.read(nationsProvider.future));
      await _time(
        'starPlayersProvider',
        () => c.read(starPlayersProvider.future),
      );
      await _time(
        'nationStrengthsProvider',
        () => c.read(nationStrengthsProvider.future),
      );
      final sub = c.listen(newGameStrengthsProvider(realId), (_, _) {});
      await _time(
        'newGameStrengths(real)',
        () => c.read(newGameStrengthsProvider(realId).future),
      );
      sub.close();

      final career = (await _time(
        'create career on real pack',
        () => c
            .read(careerServiceProvider)
            .create(
              nationId: 1,
              managerName: 'M',
              rngSeed: 7,
              worldPackId: realId,
            ),
      )).valueOrNull!;
      final plain =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: 2,
                    managerName: 'M',
                    rngSeed: 8,
                  ))
              .valueOrNull!;

      // The continue tap.
      await _time('savesProvider', () => c.read(savesProvider.future));
      await _time(
        'careerWorldNationNames',
        () => c.read(careerWorldNationNamesProvider.future),
      );
      final sync = c.read(activeWorldSyncProvider);
      await _time('activeWorld prime', sync.prime);
      await _time(
        'activeWorld enter(pack career)',
        () async => sync.enter(career.id),
      );
      await _time('careerWorldNationNames again', () async {
        c.invalidate(careerWorldNationNamesProvider);
        return c.read(careerWorldNationNamesProvider.future);
      });
      // Back to the menus, then the nation pick: everything re-reads.
      await _time('activeWorld follow(null)', () async {
        sync.follow(null);
        await Future<void>.delayed(const Duration(milliseconds: 5));
      });
      final sub2 = c.listen(newGameStrengthsProvider(realId), (_, _) {});
      await _time('nation pick (pack) after career', () async {
        await c.read(newGameNationsProvider(realId).future);
        await c.read(newGameStarPlayersProvider(realId).future);
        return c.read(newGameStrengthsProvider(realId).future);
      });
      sub2.close();
      for (final id in [career.id, plain.id]) {
        final s = c.listen(hubDataProvider(id), (_, _) {});
        await _time('hubData($id)', () => c.read(hubDataProvider(id).future));
        s.close();
      }
    },
  );
}
