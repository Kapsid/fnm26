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
/// A first fix (bend only when both sides are committed) held against a
/// neutral side but not against a committed leader (a favourite taking the
/// game to you): +12-14pp and nothing extra conceded. Hence the four cells.
///
/// Each cell: the manager's side at 80 on the neutral 4-3-3, the opponent in
/// the given posture and AI-managed as in a live match, 4000 seeds both ways
/// round; where the manager is one down at 60', staying neutral is compared
/// with switching live to all-out (see `runChase`). Figures at the fix
/// (2026-10-17), not losing / extra for / extra against: neutral 80 +5.5pp
/// +0.22 +0.35; dominant 80 +5.2pp +0.23 +0.28; gegenPress 80 +4.5pp +0.21
/// +0.26; dominant 86 +3.6pp +0.18 +0.32. Base 1574f85: +5.2 / +7.9 / +7.3 /
/// +4.3pp.
///
/// Set FNM_LAB=1 to print the cells.
void main() {
  for (final (name, opponent, rating) in const [
    ('neutral 80', neutralOpponent, 80.0),
    ('dominant 80', dominantOpponent, 80.0),
    ('gegenPress 80', gegenPressOpponent, 80.0),
    ('dominant 86', dominantOpponent, 86.0),
  ]) {
    test('chasing a game costs what it earns: $name', () {
      final s = runChase(
        seeds: 4000,
        chaseMinute: 60,
        opponent: opponent,
        opponentRating: rating,
      );
      final report = '$name: ${chaseReport(s)}';
      if (Platform.environment['FNM_LAB'] == '1') {
        // The figures are the point of the lab run.
        // ignore: avoid_print
        print(report);
      }
      expect(s.matches, greaterThan(1500), reason: 'too few chase cases');
      final scored = s.chaseGfAfter - s.stayGfAfter;
      final conceded = s.chaseGaAfter - s.stayGaAfter;
      expect(scored, greaterThan(0), reason: 'chasing must still create');
      expect(
        conceded,
        greaterThanOrEqualTo(scored * 0.8),
        reason: 'chasing must cost at the back: $report',
      );
      expect(
        s.chaseNotLose - s.stayNotLose,
        lessThanOrEqualTo(0.09),
        reason: 'chasing must not be a free comeback: $report',
      );
    }, timeout: const Timeout(Duration(minutes: 5)));
  }
}
