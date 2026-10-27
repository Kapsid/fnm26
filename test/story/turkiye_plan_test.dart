import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'turkiye_plan.dart';

/// Marketing: "Can Türkiye be world champion?". Not part of the suite.
///
/// TK_SEEDS=<from>-<to> searches those world seeds and prints each career's
/// World Championship run. TK_SEED=<n> plans the chosen seed's story into
/// TK_WORK (default build/turkiye_work); `turkiye_story_test.dart` takes the
/// shots. CYCLES (default 1) is how many cycles to play.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final env = Platform.environment;
  final cycles = int.parse(env['CYCLES'] ?? '1');
  final range = env['TK_SEEDS'];
  final seed = env['TK_SEED'];
  if (range != null) {
    final parts = range.split('-').map(int.parse).toList();
    for (var s = parts.first; s <= parts.last; s++) {
      test('türkiye seed $s', () async {
        final out = await playTurkiye(seed: s, cycles: cycles);
        // ignore: avoid_print
        print(out);
      }, timeout: const Timeout(Duration(minutes: 60)));
    }
    return;
  }
  test(
    'plan the türkiye story',
    () async {
      final out = await playTurkiye(
        seed: int.parse(seed!),
        cycles: cycles,
        work: env['TK_WORK'] ?? 'build/turkiye_work',
      );
      // ignore: avoid_print
      print(out);
    },
    skip: seed == null ? 'set TK_SEED or TK_SEEDS to play Türkiye' : null,
    timeout: const Timeout(Duration(minutes: 90)),
  );
}
