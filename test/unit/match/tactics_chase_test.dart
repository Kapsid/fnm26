import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/chase_lab.dart';

/// Going all-out when a goal down must cost what it earns.
///
/// The scoreline bend in the engine (`MatchEngine._scorelineOpenness`) used to
/// double the trailing side's chance rate and cut the leader's to 0.7 whoever
/// had opened the game, so a manager who went all-out at 60' a goal down
/// conceded only 0.10 more after it while scoring 0.38 more, and turned 14pp
/// more of those matches into draws or wins (+5.3pp before the tactics impact
/// build, at 1574f85). The spec wants bold plans to be "crazier at both ends".
///
/// The cell: equal 80v80 sides, both neutral, the opponent AI-managed as in a
/// live match, 4000 seeds both ways round; where the manager is one down at
/// 60', staying neutral is compared with switching live to all-out (see
/// `runChase`). Figures at the fix (2026-10-17, 1705 chase cases): not
/// losing 22.5% -> 27.9% (+5.5pp), goals after 60' for +0.22 and against
/// +0.35. Before the fix the same cell conceded +0.10 against +0.37 scored.
///
/// Set FNM_LAB=1 to print the 60' and 75' cells.
void main() {
  test('chasing a game costs what it earns', () {
    final s = runChase(seeds: 4000, chaseMinute: 60);
    if (Platform.environment['FNM_LAB'] == '1') {
      // ignore: avoid_print
      print("60': ${chaseReport(s)}");
      // ignore: avoid_print
      print("75': ${chaseReport(runChase(seeds: 4000, chaseMinute: 75))}");
    }
    expect(s.matches, greaterThan(1500), reason: 'too few chase cases');
    final scored = s.chaseGfAfter - s.stayGfAfter;
    final conceded = s.chaseGaAfter - s.stayGaAfter;
    expect(scored, greaterThan(0), reason: 'chasing must still create');
    expect(
      conceded,
      greaterThanOrEqualTo(scored * 0.8),
      reason: 'chasing must cost at the back: ${chaseReport(s)}',
    );
    expect(
      s.chaseNotLose - s.stayNotLose,
      lessThanOrEqualTo(0.09),
      reason: 'chasing must not be a free comeback: ${chaseReport(s)}',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
