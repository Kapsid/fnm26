import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import 'driver.dart';

/// Objectives lab: plays one full cycle as each nation of a spread across the
/// world ranking and prints the board's briefs, how each went, and the
/// verdict. Not part of the suite: without LAB_SEEDS it plays nothing, so a
/// plain `flutter test` does not sit through dozens of autopilot careers.
/// LAB_SEEDS=1,2 picks the worlds.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final raw = Platform.environment['LAB_SEEDS'];
  if (raw == null || raw.isEmpty) {
    test('objectives lab', () {}, skip: 'set LAB_SEEDS to run the lab');
    return;
  }
  final seeds = raw
      .split(',')
      .map(int.parse)
      .toList();
  final step = int.parse(Platform.environment['LAB_STEP'] ?? '8');
  final picks = [
    for (final n in storyNations)
      if (n.ranking % step == 0 || n.ranking <= 3) n,
  ]..sort((a, b) => a.ranking.compareTo(b.ranking));

  for (final seed in seeds) {
    for (final n in picks) {
      test('seed $seed ${n.name}', () async {
        final c = storyContainer();
        addTearDown(c.dispose);
        final d = await StoryDriver.start(c, seed, nationId: n.id);
        var steps = 0;
        while (await d.step(stopAtRollover: true)) {
          if (++steps > 4000) throw StateError('runaway');
        }
        final objectives = await c.read(
          cycleObjectivesProvider(d.careerId).future,
        );
        final sat = await c.read(satisfactionProvider(d.careerId).future);
        final verdict = await c.read(
          rolloverVerdictProvider(d.careerId).future,
        );
        final parts = [
          for (final o in objectives)
            '${o.tier.name}:${o.target}/${o.actual}${o.met ? '+' : '-'}',
        ];
        // ignore: avoid_print
        print(
          'LAB seed=$seed rank=${n.ranking} conf=${n.confederation.name} '
          '${n.name} | ${parts.join(' ')} | sat=$sat '
          'sacked=${verdict?.sacked}',
        );
      }, timeout: const Timeout(Duration(minutes: 10)));
    }
  }
}
