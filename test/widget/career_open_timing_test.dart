import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../helpers/save_fixtures.dart';
import '../story/driver.dart';

/// How long opening the last career takes on the 1.1.0 (37) late-cycle save:
/// the careers list, then the hub and its next event, as Continue does.
/// Printed (and logged as `career-open`), not asserted: a baseline.
void main() {
  testWidgets('opening the last career, timed', (tester) async {
    await tester.runAsync(() async {
      AppLog.debugUse(null);
      final file = await unpackFixture('v110_37', 'late_cycle');
      final db = AppDatabase.forTesting(NativeDatabase(file));
      final c = storyContainer(db);
      final total = Stopwatch()..start();
      final lap = Stopwatch()..start();
      final timings = <String, int>{};
      void mark(String what) {
        timings[what] = lap.elapsedMilliseconds;
        lap.reset();
      }

      await c.read(seedLoaderProvider).ensureSeeded();
      mark('seed');
      final last = (await c.read(savesProvider.future)).first;
      mark('saves');
      final hub = c.listen(hubDataProvider(last.id).future, (_, _) {});
      await hub.read();
      mark('hub');
      final next = c.listen(nextEventProvider(last.id).future, (_, _) {});
      await next.read();
      mark('nextEvent');
      final line =
          'total ${total.elapsedMilliseconds} ms '
          '(${[for (final e in timings.entries) '${e.key} ${e.value}'].join(', ')})';
      AppLog.info('career-open', line);
      // A baseline read off the run, not asserted.
      // ignore: avoid_print
      print('career-open: $line');
      hub.close();
      next.close();
      c.dispose();
      await db.close();
    });
  }, timeout: const Timeout(Duration(minutes: 5)));
}
