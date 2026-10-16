import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/tactics_lab.dart';

/// The tactics lab. Always-on: a cheap sanity check that the harness returns a
/// coherent result. Opt-in: the full report, which is slow (every plan x three
/// opponent strengths x 2000 seeds x both ways round) and exists to be pasted
/// into `docs/superpowers/specs/2026-10-16-tactics-lab-results.md`:
///
///     FNM_LAB=1 flutter test test/unit/match/tactics_lab_test.dart
void main() {
  test('a lab cell reports results that add up', () {
    final s = runCell(
      manager: labPlans.first,
      managerRating: 80,
      opponentRating: 80,
      aiCounters: false,
      seeds: 50,
    );
    expect(s.win + s.draw + s.loss, closeTo(1, 1e-9));
    expect(s.total, closeTo(s.gf + s.ga, 1e-9));
  });

  test(
    'lab report',
    () {
      const opponents = {
        'equal 80v80': 80.0,
        'stronger 80v86': 86.0,
        'weaker 80v74': 74.0,
      };
      opponents.forEach((label, opponentRating) {
        final rows = <String, LabStats>{
          for (final plan in labPlans)
            plan.name: runCell(
              manager: plan,
              managerRating: 80,
              opponentRating: opponentRating,
              aiCounters: false,
              seeds: 2000,
            ),
        };
        // The report IS the output: it is read off the terminal and pasted.
        // ignore: avoid_print
        print('\n### $label\n\n${labTable(rows)}');
      });
    },
    timeout: const Timeout(Duration(minutes: 60)),
    skip: Platform.environment['FNM_LAB'] == null ? 'set FNM_LAB=1' : false,
  );
}
