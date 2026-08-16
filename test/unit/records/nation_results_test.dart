import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/stats/nation_results.dart';

/// The records section used to decide "which matches count" in five places and
/// reach different answers: the fiercest-rival card dropped friendlies while
/// the head-to-head screen kept them, so one pairing read P4 on one screen and
/// P5 on the next. One decomposition now serves them all.
void main() {
  var nextId = 1;
  Fixture played(
    int home,
    int away,
    int hs, {
    required int as,
    String? round,
    int day = 1,
  }) => Fixture(
    id: nextId++,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 1, day),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: true,
    round: round,
  );

  test('a nation sees its own side of a match, home or away', () {
    final results = nationResults([
      played(1, 2, 3, as: 0),
      played(2, 1, 1, as: 2, day: 2),
    ], 1);

    expect(results, hasLength(2));
    expect(results.first.scored, 3);
    expect(results.first.conceded, 0);
    expect(results.last.scored, 2);
    expect(results.last.conceded, 1);
    expect(results.every((r) => r.opponentId == 2), isTrue);
  });

  test('a friendly is a result like any other', () {
    // The rule, stated once: everything played counts. A screen that wants
    // only competitive matches filters this list itself.
    final results = nationResults([
      played(1, 2, 1, as: 0, round: 'FRIENDLY'),
      played(1, 3, 2, as: 1),
    ], 1);
    expect(results, hasLength(2));
  });

  test('unplayed fixtures and other nations are not results', () {
    final results = nationResults([
      Fixture(
        id: 99,
        careerId: 1,
        competitionId: 1,
        matchday: 1,
        date: DateTime(2030, 5),
        homeNationId: 1,
        awayNationId: 2,
      ),
      played(4, 5, 1, as: 0),
    ], 1);
    expect(results, isEmpty);
  });

  group('opponentLedger', () {
    test('tallies every opponent from the nation\'s side', () {
      final ledger = opponentLedger(
        nationResults([
          played(1, 2, 3, as: 0),
          played(2, 1, 1, as: 1, day: 2),
          played(1, 2, 0, as: 2, day: 3),
          played(1, 3, 4, as: 0, day: 4),
        ], 1),
      );

      final two = ledger[2]!;
      expect(two.played, 3);
      expect(two.wins, 1);
      expect(two.draws, 1);
      expect(two.losses, 1);
      expect(two.goalsFor, 4);
      expect(two.goalsAgainst, 3);
      expect(ledger[3]!.played, 1);
    });

    test('the ledger and a single pairing agree', () {
      // The bug this guards: two ways of counting the same fixtures.
      final fixtures = [
        played(1, 2, 1, as: 0, round: 'FRIENDLY'),
        played(1, 2, 2, as: 2, day: 2),
        played(2, 1, 3, as: 0, day: 3),
      ];
      final ledger = opponentLedger(nationResults(fixtures, 1))[2]!;
      expect(ledger.played, 3);
      expect(ledger.wins, 1);
      expect(ledger.draws, 1);
      expect(ledger.losses, 1);
    });
  });

  group('biggestWinOf', () {
    test('is the biggest margin', () {
      final best = biggestWinOf(
        nationResults([
          played(1, 2, 2, as: 0),
          played(1, 3, 5, as: 2, day: 2),
        ], 1),
      );
      expect(best!.scored, 5);
    });

    test('breaks a tie on goals scored', () {
      final best = biggestWinOf(
        nationResults([
          played(1, 2, 2, as: 0),
          played(1, 3, 4, as: 2, day: 2),
        ], 1),
      );
      expect(best!.scored, 4, reason: 'same margin, more goals');
    });

    test('a nation that has never won has no best win', () {
      expect(
        biggestWinOf(nationResults([played(1, 2, 0, as: 1)], 1)),
        isNull,
      );
    });
  });

  group('longestUnbeatenOf', () {
    test('counts wins and draws, and a defeat ends it', () {
      final results = nationResults([
        played(1, 2, 1, as: 0),
        played(1, 3, 1, as: 1, day: 2),
        played(1, 4, 2, as: 0, day: 3),
        played(1, 5, 0, as: 1, day: 4),
        played(1, 6, 1, as: 0, day: 5),
      ], 1);
      expect(longestUnbeatenOf(results), 3);
    });

    test('a nation that has never lost is unbeaten throughout', () {
      final results = nationResults([
        played(1, 2, 1, as: 0),
        played(1, 3, 1, as: 1, day: 2),
      ], 1);
      expect(longestUnbeatenOf(results), 2);
    });

    test('no matches is no run', () {
      expect(longestUnbeatenOf(const []), 0);
    });
  });
}
