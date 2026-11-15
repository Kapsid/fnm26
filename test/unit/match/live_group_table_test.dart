import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';
import 'package:fnm/features/match/live_group_table.dart';

/// The live table: earlier results, the day's other match at its score on
/// our clock, ours as it stands, and who moved since kick-off.
void main() {
  Fixture fx(int id, int h, int a, {int? hs, int? as, int day = 1}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2029, 3, day),
    homeNationId: h,
    awayNationId: a,
    groupId: 9,
    homeScore: hs,
    awayScore: as,
    played: hs != null,
  );

  final before = [fx(1, 1, 2, hs: 1, as: 0), fx(2, 3, 4, hs: 2, as: 0)];
  // Today: 4 v 1 elsewhere (4 score at 20' and 70'), ours 2 v 3.
  final other = SameDayResult.of(fx(3, 4, 1, hs: 2, as: 0, day: 8), [
    (nationId: 4, playerId: 1, minute: 20),
    (nationId: 4, playerId: 2, minute: 70),
  ]);
  final ours = fx(4, 2, 3, day: 8);

  test('the other match counts its goals on our clock', () {
    expect(other.scoreAtMinute(10), (home: 0, away: 0));
    expect(other.scoreAtMinute(30), (home: 1, away: 0));
    expect(other.scoreAtMinute(90), (home: 2, away: 0));
  });

  test('the table at a minute, and who moved', () {
    final t = LiveGroupTable.compute(
      members: const [1, 2, 3, 4],
      before: before,
      sameDay: [other],
      ours: ours,
      ourScore: (home: 1, away: 0),
      minute: 75,
      fullTime: false,
    );
    // 4 beat 1 (2-0), 2 lead 3: 1, 2, 3 and 4 on three points each.
    expect(t.now.map((s) => s.points), everyElement(3));
    expect(t.now.every((s) => s.played == 2), isTrue);
    // Before the day: 3 (GD +2) top, then 1, then 2 and 4.
    expect(t.placeBefore[3], 0);
    expect(t.placeBefore[1], 1);
  });

  test('before kick-off ours does not count', () {
    final t = LiveGroupTable.compute(
      members: const [1, 2, 3, 4],
      before: before,
      sameDay: [other],
      ours: ours,
      ourScore: null,
      minute: 0,
      fullTime: false,
    );
    expect(t.now.where((s) => s.played == 2), isEmpty);
  });
}
