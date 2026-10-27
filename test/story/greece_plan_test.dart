import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'greece_plan.dart';

/// Marketing: "Can Greece repeat 2004?". Not part of the suite.
///
/// GR_SEEDS=<from>-<to> searches those world seeds and prints each career's
/// European Championship runs. GR_SEED=<n> plans the chosen seed's story into
/// GR_WORK (default build/greece_work); `greece_story_test.dart` takes the
/// shots. CYCLES (default 2) is the cycle whose Euro ends the story.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final env = Platform.environment;
  final cycles = int.parse(env['CYCLES'] ?? '2');
  final range = env['GR_SEEDS'];
  final seed = env['GR_SEED'];
  if (range != null) {
    final parts = range.split('-').map(int.parse).toList();
    for (var s = parts.first; s <= parts.last; s++) {
      test('greece seed $s', () async {
        final out = await playGreece(seed: s, cycles: cycles);
        // ignore: avoid_print
        print(out);
      }, timeout: const Timeout(Duration(minutes: 60)));
    }
    return;
  }
  test(
    'plan the greece story',
    () async {
      final out = await playGreece(
        seed: int.parse(seed!),
        cycles: cycles,
        work: env['GR_WORK'] ?? 'build/greece_work',
      );
      // ignore: avoid_print
      print(out);
    },
    skip: seed == null ? 'set GR_SEED or GR_SEEDS to play Greece' : null,
    timeout: const Timeout(Duration(minutes: 120)),
  );
}
