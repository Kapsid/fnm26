import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/mid_tier_difficulty.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import '../../helpers/difficulty_lab.dart';

/// The mid-tier difficulty (`MidTierDifficulty`): a mid-table side the
/// manager runs gives up a little, an elite or a minnow side nothing, and the
/// AI-v-AI world is untouched.
///
/// Every cell runs the lab twice on the SAME seeds, the term on and off, so
/// the delta is a paired difference and far steadier than either mean.
///
/// `FNM_DIFF_LAB=1` prints the full before/after table (about eight
/// minutes); `FNM_DIFF_RATINGS=74,68` limits it to those manager ratings.
void main() {
  group('the weight', () {
    test('is zero at both ends of the world and full in the middle', () {
      for (final r in const [40.0, 56.0, 60.0, 84.0, 86.0, 92.0]) {
        expect(MidTierDifficulty.weight(r), 0, reason: '$r');
        expect(MidTierDifficulty.engineFactor(r), 1, reason: '$r');
        expect(MidTierDifficulty.skipPoints(r), 0, reason: '$r');
      }
      for (final r in const [66.0, 70.0, 74.0, 78.0]) {
        expect(MidTierDifficulty.weight(r), 1, reason: '$r');
      }
    });

    test('rises and falls smoothly, with no cliff', () {
      var last = 0.0;
      for (var r = 60.0; r <= 66; r += 0.25) {
        final w = MidTierDifficulty.weight(r);
        expect(w, greaterThanOrEqualTo(last));
        expect(w - last, lessThan(0.07));
        last = w;
      }
      for (var r = 78.0; r <= 84; r += 0.25) {
        final w = MidTierDifficulty.weight(r);
        expect(w, lessThanOrEqualTo(last));
        expect(last - w, lessThan(0.07));
        last = w;
      }
    });
  });

  group('the played seam (match_providers chemistry map)', () {
    const manager = 7;
    const opponent = 8;
    test('carries the term for a mid side, and only for the manager', () {
      for (final familiarity in const [0.0, 0.5, 1.0]) {
        final map = MidTierDifficulty.chemistryByNation(
          managerNationId: manager,
          familiarity: familiarity,
          fieldedRating: 74,
        );
        // The opponent is never a key: the engine plays it at 1.0.
        expect(map.keys, [manager]);
        expect(map.containsKey(opponent), isFalse);
        expect(
          map[manager],
          closeTo(
            TeamChemistry.factor(familiarity) * (1 - MidTierDifficulty.peak),
            1e-12,
          ),
        );
        expect(map[manager], lessThan(TeamChemistry.factor(familiarity)));
      }
    });

    test('is the drilled shape alone for an elite or a minnow side', () {
      for (final rating in const [56.0, 86.0]) {
        final map = MidTierDifficulty.chemistryByNation(
          managerNationId: manager,
          familiarity: 0.6,
          fieldedRating: rating,
        );
        expect(map, {manager: TeamChemistry.factor(0.6)});
      }
    });
  });

  group('the skipped seam (_withManagerTactics strength)', () {
    test('an elite or a minnow side is the plain round, drawing nothing', () {
      for (final rating in const [56.0, 60.0, 84.0, 86.0]) {
        for (var lift = 50.0; lift < 90; lift += 0.37) {
          final rng = SeededRng(lift.hashCode);
          final before = rng.state;
          expect(
            MidTierDifficulty.skippedStrength(
              lift: lift,
              fieldedRating: rating,
              rng: rng,
            ),
            lift.round(),
          );
          expect(rng.state, before);
        }
      }
    });

    test('a mid side loses the term on average, a point at most', () {
      for (final rating in const [62.0, 64.0, 74.0, 81.0]) {
        const lift = 73.4;
        const n = 40000;
        var sum = 0;
        for (var i = 0; i < n; i++) {
          final s = MidTierDifficulty.skippedStrength(
            lift: lift,
            fieldedRating: rating,
            rng: MidTierDifficulty.ditherRng(99, i),
          );
          expect(s, anyOf(73, 72));
          sum += s;
        }
        expect(
          sum / n - lift.round(),
          closeTo(MidTierDifficulty.skipPoints(rating), 0.01),
          reason: 'rating $rating',
        );
      }
    });

    test('is the same every time for the same fixture', () {
      for (var i = 0; i < 200; i++) {
        int once() => MidTierDifficulty.skippedStrength(
          lift: 70.2,
          fieldedRating: 70,
          rng: MidTierDifficulty.ditherRng(4242, i),
        );
        expect(once(), once());
      }
    });
  });

  group('a mid side (74) gives up 0.05 to 0.10 points a match', () {
    const seeds = 2000;
    const mine = 74.0;
    for (final gap in const [-6.0, 0.0, 6.0]) {
      final theirs = mine + gap;
      test('against $theirs', () {
        final p1 = labPlayed(mine: mine, theirs: theirs, seeds: seeds);
        final p0 = labPlayed(
          mine: mine,
          theirs: theirs,
          difficulty: false,
          seeds: seeds,
        );
        final s1 = labSkipped(mine: mine, theirs: theirs, seeds: seeds);
        final s0 = labSkipped(
          mine: mine,
          theirs: theirs,
          difficulty: false,
          seeds: seeds,
        );
        final played = p1.points - p0.points;
        final skipped = s1.points - s0.points;
        final report =
            'v $theirs: played ${fmt(played, signed: true)}, '
            'skipped ${fmt(skipped, signed: true)}';
        // The measured delta is the point of the test; keep it in the log.
        // The lab's report table is its output.
        // ignore: avoid_print
        print(report);
        if (gap >= 0) {
          expect(played, inInclusiveRange(-0.11, -0.05), reason: report);
          expect(skipped, inInclusiveRange(-0.11, -0.04), reason: report);
        } else {
          // A little less against a weaker side, and never nothing.
          expect(played, inInclusiveRange(-0.10, -0.03), reason: report);
          expect(skipped, inInclusiveRange(-0.10, -0.03), reason: report);
        }
        // Played and skipped tell the same story.
        expect((played - skipped).abs(), lessThan(0.05), reason: report);
      }, timeout: const Timeout(Duration(minutes: 5)));
    }
  });

  group('elite and minnow sides are untouched', () {
    for (final mine in const [86.0, 56.0]) {
      test('$mine plays exactly as before, played and skipped', () {
        for (final gap in const [-6.0, 0.0, 6.0]) {
          final theirs = mine + gap;
          expect(
            labPlayed(mine: mine, theirs: theirs, seeds: 150),
            labPlayed(
              mine: mine,
              theirs: theirs,
              difficulty: false,
              seeds: 150,
            ),
          );
          expect(
            labSkipped(mine: mine, theirs: theirs, seeds: 600),
            labSkipped(
              mine: mine,
              theirs: theirs,
              difficulty: false,
              seeds: 600,
            ),
          );
        }
      }, timeout: const Timeout(Duration(minutes: 5)));
    }
  });

  test('background simulator regression pin (not a guard of the term)', () {
    // The AI-v-AI path never reads the term, so this cannot catch it; it
    // pins the lab's pre-change world numbers (3000 seeds) so a change to
    // the background simulator is noticed here. A deliberate recalibration
    // should simply re-pin these.
    expect(
      labWorld(mine: 74, theirs: 68, seeds: 3000).points,
      closeTo(1.85, 0.02),
    );
    expect(
      labWorld(mine: 74, theirs: 74, seeds: 3000).points,
      closeTo(1.38, 0.02),
    );
    expect(
      labWorld(mine: 74, theirs: 80, seeds: 3000).points,
      closeTo(0.84, 0.02),
    );
  });

  test('report', () {
    if (Platform.environment['FNM_DIFF_LAB'] != '1') return;
    const seeds = 3000;
    final only = Platform.environment['FNM_DIFF_RATINGS'];
    final ratings = only == null
        ? const [86.0, 80.0, 74.0, 68.0, 56.0]
        : [for (final r in only.split(',')) double.parse(r)];
    final b = StringBuffer()
      ..writeln(
        '| Mine | Edge | Theirs | World | Played before (vs world) '
        '| Played after (delta) | Skipped before (vs world) '
        '| Skipped after (delta) |',
      )
      ..writeln('|---|---|---|---|---|---|---|---|');
    for (final mine in ratings) {
      for (final edge in const [bareEdge, typicalEdge]) {
        for (final gap in const [-6.0, 0.0, 6.0]) {
          final theirs = mine + gap;
          final world = labWorld(mine: mine, theirs: theirs, seeds: seeds);
          final p0 = labPlayed(
            mine: mine,
            theirs: theirs,
            edge: edge,
            difficulty: false,
            seeds: seeds,
          );
          final p1 = labPlayed(
            mine: mine,
            theirs: theirs,
            edge: edge,
            seeds: seeds,
          );
          final s0 = labSkipped(
            mine: mine,
            theirs: theirs,
            edge: edge,
            difficulty: false,
            seeds: seeds,
          );
          final s1 = labSkipped(
            mine: mine,
            theirs: theirs,
            edge: edge,
            seeds: seeds,
          );
          b.writeln(
            '| $mine | ${edge.name} | $theirs | ${fmt(world.points)} '
            '| ${fmt(p0.points)} (${fmt(p0.points - world.points, signed: true)}) '
            '| ${fmt(p1.points)} (${fmt(p1.points - p0.points, signed: true)}) '
            '| ${fmt(s0.points)} (${fmt(s0.points - world.points, signed: true)}) '
            '| ${fmt(s1.points)} (${fmt(s1.points - s0.points, signed: true)}) |',
          );
        }
      }
    }
    // The lab's report table is its output.
    // ignore: avoid_print
    print(b);
  }, timeout: const Timeout(Duration(minutes: 30)));
}
