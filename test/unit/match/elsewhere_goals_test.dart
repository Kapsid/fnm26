import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';
import 'package:fnm/features/match/match_screen.dart';

/// The goals of the day's other matches as the match screen calls them out:
/// the ones our clock has just passed, each with the score it made and, in
/// a group, the manager's place when it moved.
void main() {
  final day = DateTime(2030, 6, 14);
  Fixture fx(int id, int home, int away, {int? hs, int? as}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 7,
    matchday: 1,
    date: day,
    homeNationId: home,
    awayNationId: away,
    groupId: 3,
    round: 'Q',
    homeScore: hs,
    awayScore: as,
    played: hs != null,
  );

  // Ours: 1 v 2. Elsewhere: 3 v 4, finishing 2-1 (3' home, 50' away,
  // 80' home).
  final ours = fx(1, 1, 2);
  final other = SameDayResult.of(fx(2, 3, 4, hs: 2, as: 1), [
    (nationId: 3, playerId: 31, minute: 80),
    (nationId: 3, playerId: 30, minute: 3),
    (nationId: 4, playerId: 40, minute: 50),
  ]);

  test('goalsBetween: the goals in the window, each with its score', () {
    expect(other.goalsBetween(0, 2), isEmpty);
    expect(other.goalsBetween(0, 3), [
      (minute: 3, home: true, homeScore: 1, awayScore: 0),
    ]);
    expect(other.goalsBetween(3, 90), [
      (minute: 50, home: false, homeScore: 1, awayScore: 1),
      (minute: 80, home: true, homeScore: 2, awayScore: 1),
    ]);
    expect(other.goalsBetween(80, 120), isEmpty);
  });

  test('in a group, the place the manager moved to comes with it', () {
    // Before the day, all level on nothing.
    final group = (members: [1, 2, 3, 4], before: <Fixture>[]);
    // Ours stays goalless.
    final goals = elsewhereGoalsBetween(
      sameDay: [other],
      after: 0,
      upTo: 90,
      ours: ours,
      ourNationId: 1,
      group: group,
      ourScoreAt: (_) => (home: 0, away: 0),
    );
    expect(goals.map((g) => g.minute), [3, 50, 80]);
    // 3': side 3 goes top, so we drop from first to second.
    expect(goals[0].place, (now: 2, was: 1));
    // 50': 1-1, all on a point, but they have scored: we fall to third.
    expect(goals[1].place, (now: 3, was: 2));
    // 80': 2-1, side 4 beaten below us: back up to second.
    expect(goals[2].place, (now: 2, was: 3));
    // Outside a group, no place.
    final cup = elsewhereGoalsBetween(
      sameDay: [other],
      after: 0,
      upTo: 90,
      ours: ours,
      ourNationId: 1,
    );
    expect(cup.every((g) => g.place == null), isTrue);
  });
}
