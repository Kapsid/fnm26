// A local timing probe for the continue tap, not a regression test. With
// FNM_PERF_SAVE=/path/to/file.sqlite it plays a career into its second cycle
// (once, kept at that path) and then times what opening it reads, provider
// by provider, on a database opened as the app opens it. Skipped otherwise.
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../story/driver.dart';
import '../unit/greenland/greenland_fixtures.dart';

final String? _savePath = Platform.environment['FNM_PERF_SAVE'];

/// Times [f]: wall clock, and the longest stretch the isolate was blocked.
Future<T> _time<T>(String label, Future<T> Function() f) async {
  final sw = Stopwatch()..start();
  var last = 0;
  var worst = 0;
  var total = 0;
  final ticker = Timer.periodic(const Duration(milliseconds: 1), (_) {
    final now = sw.elapsedMilliseconds;
    worst = max(worst, now - last);
    if (now - last > 4) total += now - last;
    last = now;
  });
  final out = await f();
  ticker.cancel();
  final now = sw.elapsedMilliseconds;
  worst = max(worst, now - last);
  // Printed for the person running the probe.
  // ignore: avoid_print
  print(
    'PERF ${label.padRight(40)} ${'$now'.padLeft(6)} ms  '
    'blocked max ${'$worst'.padLeft(5)} ms, sum ${'$total'.padLeft(5)} ms',
  );
  return out;
}

/// Reads every provider in [ps] at once, kept alive until all are in, as
/// a screen watching them all would.
Future<void> _readAll(
  ProviderContainer c,
  List<AutoDisposeFutureProvider<Object?>> ps,
) async {
  final clock = Stopwatch()..start();
  final subs = [for (final p in ps) c.listen(p.future, (_, _) {})];
  try {
    await Future.wait([
      for (final (i, s) in subs.indexed)
        s.read().then((v) {
          // The hub's own data: what its body waits for.
          if (identical(ps[i].from, hubDataProvider)) {
            // Printed for the person running the probe.
            // ignore: avoid_print
            print('PERF   hubData in after ${clock.elapsedMilliseconds} ms');
          }
          return v;
        }),
    ]);
  } finally {
    for (final s in subs) {
      s.close();
    }
  }
}

final String? _packPath = Platform.environment['FNM_PERF_PACK'];

void main() {
  test(
    'continue probe',
    skip: _savePath == null ? 'set FNM_PERF_SAVE' : false,
    timeout: const Timeout(Duration(minutes: 60)),
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final file = File(_savePath!);
      if (!file.existsSync()) {
        final db = AppDatabase.forTesting(NativeDatabase(file));
        final c = greenlandContainer(db);
        await c.read(seedLoaderProvider).ensureSeeded();
        final packId = _packPath == null
            ? null
            : (await c.read(worldPackServiceProvider).importFile(_packPath!))
                  .valueOrNull;
        final career =
            (await c
                    .read(careerServiceProvider)
                    .create(
                      nationId: england,
                      managerName: 'M',
                      rngSeed: 11,
                      worldPackId: packId,
                    ))
                .valueOrNull!;
        final d = StoryDriver(c, career.id);
        var rollovers = 0;
        var steps = 0;
        while (rollovers < 2 && steps < 4000) {
          if (!await d.step(stopAtRollover: true)) {
            rollovers++;
            if (rollovers < 2) await d.step();
          }
          steps++;
        }
        // ignore: avoid_print
        print('PERF built save in $steps steps');
        c.dispose();
        await db.close();
      }

      for (var round = 0; round < 6; round++) {
        // Rounds 3 on read as the hub now does: its own data first, the
        // badges and the body's cards once it is in.
        final hubFirst = round >= 3;
        final db = AppDatabase.forTesting(
          NativeDatabase.createInBackground(file),
        );
        final c = greenlandContainer(db);
        await c.read(seedLoaderProvider).ensureSeeded();
        final saves = await c.read(savesProvider.future);
        final id = saves.first.id;
        await _time(
          'ROUND $round home card world names',
          () => c.read(careerWorldNationNamesProvider.future),
        );
        await _time('ROUND $round open (hubFirst $hubFirst)', () async {
          await c.read(activeWorldSyncProvider).prime();
          await c.read(activeWorldSyncProvider).enter(id);
          await c.read(careerServiceProvider).markPlayed(id);
          final first = [
            careerProLockedProvider(id),
            hubDataProvider(id),
            wcHostThemeProvider(id),
            continentalHostThemeProvider(id),
          ];
          final keep = [
            if (hubFirst)
              for (final p in first) c.listen(p.future, (_, _) {}),
          ];
          if (hubFirst) await _readAll(c, first);
          await _readAll(c, [
            if (!hubFirst) ...first,
            unreadMessagesProvider(id),
            yUnreadCountProvider(id),
            nextEventProvider(id),
            satisfactionProvider(id),
            federationFundsProvider(id),
            federationBuildingsProvider(id),
            moraleProvider(id),
            cycleObjectivesProvider(id),
          ]);
          for (final s in keep) {
            s.close();
          }
        });
        c.dispose();
        await db.close();
      }
    },
  );
}
