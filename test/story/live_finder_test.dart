import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';

import 'driver.dart';

/// Marketing: plays live-engine England careers and prints the story beats.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final from = int.parse(Platform.environment['SEED_FROM'] ?? '1');
  final count = int.parse(Platform.environment['SEED_COUNT'] ?? '1');
  final cycles = int.parse(Platform.environment['CYCLES'] ?? '2');
  for (var s = from; s < from + count; s++) {
    test('seed $s', () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, s);
      final out = StringBuffer('=== SEED $s\n');
      d.afterMatch = (f) async => out.writeln(describe(f));
      if (Platform.environment['SYNC_NEWS'] == '1') {
        d.afterMatch = (f) async {
          out.writeln(describe(f));
          await c.read(messageServiceProvider).sync(d.careerId);
        };
      }
      if (Platform.environment['EXTRA_PREVIEW'] == '1') {
        d.beforeMatch = (p) async {
          for (var i = 0; i < 2; i++) {
            final ui = storyContainer(c.read(appDatabaseProvider));
            final sub = ui.listen(matchPreviewProvider(d.careerId).future, (_, _) {});
            await sub.read();
            sub.close();
            ui.dispose();
          }
        };
      }
      if (Platform.environment['READ_NEWS'] == '1') {
        d.beforeMatch = (p) async =>
            c.read(competitionRepositoryProvider).markMessagesRead(d.careerId);
      }
      for (var cy = 0; cy < cycles; cy++) {
        var steps = 0;
        while (await d.step(stopAtRollover: true)) {
          if (++steps > 3000) throw StateError('runaway');
        }
        final honours = await c.read(competitionRepositoryProvider).honours(d.careerId);
        for (final h in honours.where((h) => h.year >= 2026 + cy * 4 && h.year <= 2030 + cy * 4)) {
          final tag = h.championId == england ? ' <<< ENGLAND' : (h.runnerUpId == england ? ' (eng runner-up)' : '');
          if (tag.isNotEmpty || h.competition.contains('World')) {
            out.writeln('   honour ${h.year} ${h.competition}: ${nationById[h.championId]?.name}$tag');
          }
        }
        out.writeln('-- end cycle ${cy + 1}');
        if (cy + 1 < cycles) {
          final e = await d.nextEvent();
          expect(e.kind, HubEventKind.cycleRollover);
          await d.step();
        }
      }
      // ignore: avoid_print
      print(out);
    }, timeout: const Timeout(Duration(minutes: 30)));
  }
}
