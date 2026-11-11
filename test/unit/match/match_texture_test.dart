import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/match/live_rating.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_flow.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/fixtures.dart';

/// Match texture (release 1.2, workstream C): own goals, woodwork and big
/// saves made visible, and the flow of the match.
void main() {
  const engine = MatchEngine();
  final l = AppLocalizationsEn();

  // 600 matches of two good sides, played once and read by several tests.
  final results = [
    for (var i = 0; i < 600; i++)
      engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x7E47, i),
      ),
  ];
  int sideOf(int playerId) => playerId ~/ 100;

  group('own goals', () {
    test('rare: about one goal in thirty, one match in ten or so', () {
      var goals = 0;
      var own = 0;
      var matches = 0;
      for (final r in results) {
        final og = r.events.where((e) => e.ownGoal).length;
        goals += r.events.where((e) => e.type == MatchEventType.goal).length;
        own += og;
        if (og > 0) matches++;
      }
      expect(own / goals, inInclusiveRange(0.015, 0.06));
      expect(matches / results.length, inInclusiveRange(0.03, 0.2));
    });

    test('credited to the side it counted for, named for the defender', () {
      var seen = 0;
      for (final r in results) {
        for (var i = 0; i < r.events.length; i++) {
          final e = r.events[i];
          if (!e.ownGoal) continue;
          seen++;
          expect(e.type, MatchEventType.goal);
          // The man who turned it in plays for the other side.
          expect(sideOf(e.playerId), isNot(e.teamNationId));
          expect(e.assistPlayerId, isNull);
          expect(e.penalty, isFalse);
          // The shot behind it is still the attacker's, and points at it.
          final shot = r.moments.whereType<ShotMoment>().singleWhere(
            (s) => s.goalEventIndex == i,
          );
          expect(shot.teamNationId, e.teamNationId);
          expect(sideOf(shot.shooterId), e.teamNationId);
          expect(shot.outcome, ShotOutcome.goal);
        }
        // The score still counts every goal for the side it counted for.
        final home = r.events
            .where((e) => e.type == MatchEventType.goal && e.teamNationId == 1)
            .length;
        expect(home, r.extraTime?.homeScore ?? r.homeScore);
      }
      expect(seen, greaterThan(0));
    });

    test('never a goal of the man who scored it, and it costs his mark', () {
      final r = results.firstWhere((r) => r.events.any((e) => e.ownGoal));
      final og = r.events.firstWhere((e) => e.ownGoal);
      final tally = MatchTally.of(r.events, r.moments);
      expect(tally.goals[og.playerId], isNull);
      expect(tally.ownGoals[og.playerId], 1);
      final with_ = PerformanceMark.forPlayer(
        category: PositionCategory.defender,
        goals: 0,
        assists: 0,
        booked: false,
        sentOff: false,
        teamScore: 1,
        oppScore: 1,
        ownGoals: 1,
      );
      final without = PerformanceMark.forPlayer(
        category: PositionCategory.defender,
        goals: 0,
        assists: 0,
        booked: false,
        sentOff: false,
        teamScore: 1,
        oppScore: 1,
      );
      expect(without - with_, closeTo(PerformanceMark.ownGoalCost, 1e-9));
    });

    test('stored with the id negated, so every scorer tally leaves it out', () {
      expect(isOwnGoal(-1234), isTrue);
      expect(isOwnGoal(1234), isFalse);
    });

    test('the commentary tells it as an own goal, naming the defender', () {
      final r = results.firstWhere((r) => r.events.any((e) => e.ownGoal));
      final i = r.events.indexWhere((e) => e.ownGoal);
      final shot = r.moments.whereType<ShotMoment>().singleWhere(
        (s) => s.goalEventIndex == i,
      );
      final names = {
        for (final p in [...ratedTeam(1, 78).xi, ...ratedTeam(2, 74).xi])
          p.id: p.name,
      };
      final line = pitchLine(
        l,
        shot,
        names,
        7,
        events: r.events,
        score: (home: 1, away: 0),
      )!;
      final defender = names[r.events[i].playerId]!;
      expect(line, contains(defender));
      expect(
        [
          l.pitchComOwnGoal1(defender),
          l.pitchComOwnGoal2(defender, names[shot.shooterId]!),
          l.pitchComOwnGoal3(defender),
        ].any(line.startsWith),
        isTrue,
      );
    });
  });

  group('woodwork and big saves', () {
    final names = {
      for (final p in [...ratedTeam(1, 78).xi, ...ratedTeam(2, 74).xi])
        p.id: p.name,
    };

    test('every woodwork hit and big save gets a Timeline row', () {
      var rows = 0;
      for (final r in results.take(100)) {
        final chances = timelineChances(
          r,
          names: names,
          momentReached: (_, _) => true,
          opponentOf: (id) => id == 1 ? 2 : 1,
        );
        final shots = r.moments.whereType<ShotMoment>().where(
          (s) =>
              s.origin != ShotOrigin.penalty &&
              (s.outcome == ShotOutcome.woodwork || s.isBigSave),
        );
        // In match order: the shooter's side and name for the woodwork, the
        // keeper's for a save.
        expect(chances, [
          for (final s in shots)
            (
              minute: s.minute,
              stoppage: s.stoppage,
              teamNationId: s.outcome == ShotOutcome.woodwork
                  ? s.teamNationId
                  : (s.teamNationId == 1 ? 2 : 1),
              name:
                  names[s.outcome == ShotOutcome.woodwork
                      ? s.shooterId
                      : s.keeperId]!,
              woodwork: s.outcome == ShotOutcome.woodwork,
            ),
        ]);
        rows += chances.length;
      }
      expect(rows, greaterThan(50));
    });

    test('only what the clock has reached', () {
      final r = results.first;
      final all = timelineChances(
        r,
        names: names,
        momentReached: (_, _) => true,
        opponentOf: (id) => id == 1 ? 2 : 1,
      );
      final firstHalf = timelineChances(
        r,
        names: names,
        momentReached: (m, _) => m <= 45,
        opponentOf: (id) => id == 1 ? 2 : 1,
      );
      expect(firstHalf.every((c) => c.minute <= 45), isTrue);
      expect(firstHalf.length, all.where((c) => c.minute <= 45).length);
    });

    test('a big save has its own commentary', () {
      final shot = results
          .expand((r) => r.moments.whereType<ShotMoment>())
          .firstWhere(
            (s) => s.isBigSave && s.origin == ShotOrigin.openPlay,
          );
      final line = pitchLine(l, shot, names, 3, events: const [])!;
      expect(line, contains(names[shot.keeperId]));
    });
  });

  group('the flow of the match', () {
    test('momentum leans to the side making the chances', () {
      final home = <double>[0];
      final away = <double>[0];
      for (var m = 1; m <= 90; m++) {
        home.add(home.last + (m <= 30 && m.isEven ? 0.1 : 0));
        away.add(away.last + (m > 60 && m.isEven ? 0.1 : 0));
      }
      final mo = MatchFlow.momentum(home, away);
      expect(mo.length, 90);
      expect(mo[19], greaterThan(0.5)); // 20': all the hosts
      expect(mo[49], 0); // 50': nothing happening
      expect(mo[84], lessThan(-0.5)); // 85': all the visitors
      expect(mo.every((v) => v >= -1 && v <= 1), isTrue);
      // Only up to the clock.
      expect(MatchFlow.momentum(home, away, upTo: 40).length, 40);
    });

    test('xG read as of the clock, clamped to the series', () {
      final r = results.first;
      expect(MatchFlow.xgAt(r.homeXgByMinute, 0), 0);
      expect(MatchFlow.xgAt(r.homeXgByMinute, 500), r.homeXg);
      expect(MatchFlow.xgAt(const [], 10), 0);
    });
  });
}
