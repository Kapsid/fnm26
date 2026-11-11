import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/match_baseline.dart';
import '../../helpers/match_goldens.dart';

/// Task 6 of the pitch view: the box score and the player ratings read the
/// match the engine recorded. Shots and xG are the sums of the recorded shots;
/// a missed or saved penalty costs the taker, and a penalty save lifts the
/// keeper. The Timeline reads events only, so it keeps its rows.
void main() {
  const engine = MatchEngine();

  final matches = <MatchResult>[
    for (var i = 0; i < 300; i++)
      engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x6A71, i),
      ),
    for (var i = 0; i < 60; i++)
      engine.play(
        home: ratedTeam(1, 75),
        away: ratedTeam(2, 75),
        rng: SeededRng.forFixture(0x6A72, i),
        neutralVenue: true,
        extraTimeIfLevel: true,
      ),
  ];

  test('totals equal moment sums', () {
    for (final r in matches) {
      final shots = r.moments.whereType<ShotMoment>().toList();
      for (final (nation, total, xg, shotSeries, xgSeries) in [
        (1, r.homeShots, r.homeXg, r.homeShotsByMinute, r.homeXgByMinute),
        (2, r.awayShots, r.awayXg, r.awayShotsByMinute, r.awayXgByMinute),
      ]) {
        final mine = shots.where((s) => s.teamNationId == nation).toList();
        expect(mine.length, total, reason: 'shots of $nation');
        expect(
          mine.fold<double>(0, (a, s) => a + s.xg),
          closeTo(xg, 1e-6),
          reason: 'xG of $nation',
        );
        expect(shotSeries.last, total);
        expect(xgSeries.last, closeTo(xg, 1e-6));
        for (var m = 1; m < shotSeries.length; m++) {
          final inMinute = mine.where((s) => s.minute == m);
          expect(
            inMinute.length,
            shotSeries[m] - shotSeries[m - 1],
            reason: 'shots of $nation in minute $m',
          );
          expect(
            inMinute.fold<double>(0, (a, s) => a + s.xg),
            closeTo(xgSeries[m] - xgSeries[m - 1], 1e-6),
            reason: 'xG of $nation in minute $m',
          );
        }
      }
    }
  });

  test("missed penalty lowers the taker's rating; save lifts the keeper", () {
    // Every player is on the fixtures' 4-3-3, so a player's category comes
    // from his id: nation * 100 + slot.
    PositionCategory categoryOf(int id) =>
        Formation.f433.positions[id % 100].category;

    var misses = 0, saves = 0;
    for (final r in matches) {
      final pens = r.moments
          .whereType<ShotMoment>()
          .where((s) => s.origin == ShotOrigin.penalty)
          .toList();
      final missedBy = <int, int>{};
      final savedBy = <int, int>{};
      for (final s in pens) {
        if (s.outcome == ShotOutcome.goal) continue;
        missedBy.update(s.shooterId, (v) => v + 1, ifAbsent: () => 1);
        misses++;
        if (s.outcome == ShotOutcome.saved && s.keeperId != null) {
          savedBy.update(s.keeperId!, (v) => v + 1, ifAbsent: () => 1);
          saves++;
        }
      }
      final goals = <int, int>{};
      final ownGoals = <int, int>{};
      final assists = <int, int>{};
      final yellows = <int>{};
      final reds = <int>{};
      for (final e in r.events) {
        switch (e.type) {
          case MatchEventType.goal when e.ownGoal:
            ownGoals.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
          case MatchEventType.goal:
            goals.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
            if (e.assistPlayerId case final a?) {
              assists.update(a, (v) => v + 1, ifAbsent: () => 1);
            }
          case MatchEventType.yellowCard:
            yellows.add(e.playerId);
          case MatchEventType.redCard:
            reds.add(e.playerId);
          case MatchEventType.substitution:
          case MatchEventType.injury:
            break;
        }
      }
      final home = r.extraTime?.homeScore ?? r.homeScore;
      final away = r.extraTime?.awayScore ?? r.awayScore;
      for (final p in r.ratings) {
        double mark({int missed = 0, int saved = 0}) =>
            PerformanceMark.forPlayer(
              category: categoryOf(p.playerId),
              goals: goals[p.playerId] ?? 0,
              assists: assists[p.playerId] ?? 0,
              booked: yellows.contains(p.playerId),
              sentOff: reds.contains(p.playerId),
              teamScore: p.teamNationId == 1 ? home : away,
              oppScore: p.teamNationId == 1 ? away : home,
              penaltiesMissed: missed,
              penaltiesSaved: saved,
              ownGoals: ownGoals[p.playerId] ?? 0,
            );
        final missed = missedBy[p.playerId] ?? 0;
        final saved = savedBy[p.playerId] ?? 0;
        expect(p.rating, mark(missed: missed, saved: saved));
        if (missed + saved == 0) {
          expect(p.rating, mark(), reason: 'no penalty, no change');
        }
      }
    }
    expect(misses, greaterThan(5), reason: 'the sample holds missed pens');
    expect(saves, greaterThan(3), reason: 'the sample holds penalty saves');
  });

  test('the penalty adjustments are -0.4 a miss and +0.5 a save', () {
    double mark(PositionCategory c, {int missed = 0, int saved = 0}) =>
        PerformanceMark.forPlayer(
          category: c,
          goals: 0,
          assists: 0,
          booked: false,
          sentOff: false,
          teamScore: 0,
          oppScore: 0,
          penaltiesMissed: missed,
          penaltiesSaved: saved,
        );
    expect(mark(PositionCategory.forward), 6.5);
    expect(mark(PositionCategory.forward, missed: 1), 6.1);
    expect(mark(PositionCategory.forward, missed: 2), 5.7);
    expect(mark(PositionCategory.goalkeeper), 7.0);
    expect(mark(PositionCategory.goalkeeper, saved: 1), 7.5);
  });

  test('timeline shows the same rows as before for a match without '
      'penalties', () {
    // The Timeline reads [MatchResult.events] only. A match with no penalty
    // kick must have the very events the stored golden pinned, and a missed
    // penalty must add no event at all.
    final golden = loadMatchBaseline()['golden'] as List;
    var checked = 0;
    for (var i = 0; i < goldenMatches; i++) {
      final r = engine.play(
        home: ratedTeam(1, goldenPair.$1),
        away: ratedTeam(2, goldenPair.$2),
        rng: SeededRng.forFixture(goldenSeed, i),
      );
      final hasPenalty = r.moments.whereType<ShotMoment>().any(
        (s) => s.origin == ShotOrigin.penalty,
      );
      if (hasPenalty) continue;
      checked++;
      expect(
        goldenMatch(i)['events'],
        (golden[i] as Map)['events'],
        reason: 'golden match $i timeline rows',
      );
    }
    expect(checked, greaterThan(100));
    for (final r in matches) {
      final goalShots = r.moments.whereType<ShotMoment>().where(
        (s) => s.outcome == ShotOutcome.goal,
      );
      expect(
        r.events.where((e) => e.type == MatchEventType.goal).length,
        goalShots.length,
      );
    }
  });
}
