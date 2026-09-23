import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/stats/career_stats.dart';

ManagerMatch m(
  int gf,
  int ga, {
  int day = 1,
  int nationId = 1,
  bool competitive = true,
  bool home = true,
  bool neutral = false,
  bool wonShootout = false,
  bool lostShootout = false,
  bool trailed = false,
}) => (
  date: DateTime(2030, 1, day),
  nationId: nationId,
  goalsFor: gf,
  goalsAgainst: ga,
  competitive: competitive,
  home: home,
  neutral: neutral,
  wonShootout: wonShootout,
  lostShootout: lostShootout,
  trailed: trailed,
);

PlayerMatchLine line(
  int goals, {
  int playerId = 1,
  int assists = 0,
  double rating = 6.5,
  bool motm = false,
  int yellows = 0,
  int reds = 0,
}) => (
  playerId: playerId,
  goals: goals,
  assists: assists,
  rating: rating,
  motm: motm,
  yellows: yellows,
  reds: reds,
);

void main() {
  group('record & goals', () {
    test('tallies W/D/L, goals and derived rates', () {
      final s = CareerStats.compute([
        m(3, 0, day: 1),
        m(1, 1, day: 2),
        m(0, 2, day: 3),
        m(2, 1, day: 4),
      ], const []);
      expect(s.played, 4);
      expect(s.wins, 2);
      expect(s.draws, 1);
      expect(s.losses, 1);
      expect(s.goalsFor, 6);
      expect(s.goalsAgainst, 4);
      expect(s.goalDifference, 2);
      expect(s.winRate, 0.5);
      expect(s.goalsPerGame, 1.5);
      expect(s.cleanSheets, 1);
      expect(s.failedToScore, 1);
    });

    test('an empty career is all zeroes, no divide-by-zero', () {
      final s = CareerStats.compute(const [], const []);
      expect(s.played, 0);
      expect(s.winRate, 0);
      expect(s.goalsPerGame, 0);
    });
  });

  group('shootouts count as advancing, not W/L on the scoreline', () {
    test('a shootout win is a win; a shootout loss is a loss', () {
      final s = CareerStats.compute([
        m(1, 1, day: 1, wonShootout: true),
        m(2, 2, day: 2, lostShootout: true),
      ], const []);
      expect(s.wins, 1);
      expect(s.losses, 1);
      expect(s.draws, 0);
      expect(s.shootoutsWon, 1);
      expect(s.shootoutsLost, 1);
    });
  });

  group('extremes', () {
    test('biggest win, heaviest defeat and most goals', () {
      final s = CareerStats.compute([
        m(5, 0, day: 1),
        m(1, 4, day: 2),
        m(7, 3, day: 3),
      ], const []);
      expect(s.biggestWinMargin, 5);
      expect(s.heaviestDefeatMargin, 3);
      expect(s.mostGoalsInAGame, 7);
    });
  });

  group('streaks', () {
    test('longest win/unbeaten/winless and current runs', () {
      // W W W L D W W  (chronological)
      final s = CareerStats.compute([
        m(1, 0, day: 1),
        m(1, 0, day: 2),
        m(1, 0, day: 3),
        m(0, 1, day: 4),
        m(1, 1, day: 5),
        m(2, 0, day: 6),
        m(2, 0, day: 7),
      ], const []);
      expect(s.longestWinStreak, 3);
      expect(s.longestUnbeatenRun, 3, reason: 'W W W then L breaks it');
      expect(s.currentWinStreak, 2, reason: 'ends on W W');
      expect(s.currentUnbeatenRun, 3, reason: 'D W W at the tail');
    });

    test('clean-sheet and scoring streaks', () {
      final s = CareerStats.compute([
        m(2, 0, day: 1),
        m(1, 0, day: 2),
        m(0, 0, day: 3),
        m(3, 1, day: 4),
      ], const []);
      expect(s.longestCleanSheetStreak, 3, reason: 'GA 0,0,0');
      expect(
        s.longestScoringStreak,
        2,
        reason: 'scored, scored, blank, scored',
      );
    });

    test('order does not matter — input is sorted by date', () {
      final ordered = [m(1, 0, day: 1), m(1, 0, day: 2), m(0, 1, day: 3)];
      final shuffled = [ordered[2], ordered[0], ordered[1]];
      expect(
        CareerStats.compute(shuffled, const []).longestWinStreak,
        CareerStats.compute(ordered, const []).longestWinStreak,
      );
    });
  });

  group('comebacks', () {
    test('a win after trailing is a comeback; a comfortable win is not', () {
      final s = CareerStats.compute([
        m(2, 1, day: 1, trailed: true),
        m(3, 0, day: 2, trailed: false),
        m(1, 1, day: 3, trailed: true), // drew from behind — not a comeback win
      ], const []);
      expect(s.comebackWins, 1);
    });
  });

  group('home / away / neutral splits', () {
    test('routes each result to the right venue bucket', () {
      final s = CareerStats.compute([
        m(1, 0, day: 1, home: true),
        m(0, 1, day: 2, home: false),
        m(2, 2, day: 3, neutral: true),
        m(3, 0, day: 4, neutral: true),
      ], const []);
      expect(s.homeWins, 1);
      expect(s.awayLosses, 1);
      expect(s.neutralDraws, 1);
      expect(s.neutralWins, 1);
    });
  });

  group('player feats', () {
    test('hat-tricks, braces, MOTMs, cards and best rating', () {
      final s = CareerStats.compute(const [], [
        line(3, rating: 9.4, motm: true),
        line(2, rating: 7.8),
        line(1, rating: 7.0, assists: 2, yellows: 1),
        line(0, rating: 8.9, motm: true, reds: 1),
      ]);
      expect(s.hatTricks, 1);
      expect(s.braces, 1);
      expect(s.playerMotms, 2);
      expect(s.playerAssists, 2);
      expect(s.playerYellows, 1);
      expect(s.playerReds, 1);
      expect(s.bestPlayerRating, 9.4);
    });
  });
}
