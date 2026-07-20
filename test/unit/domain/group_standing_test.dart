import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';

Fixture _fx(int home, int away, int hs, int as) => Fixture(
      id: home * 100 + away,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2030),
      homeNationId: home,
      awayNationId: away,
      homeScore: hs,
      awayScore: as,
      played: true,
    );

void main() {
  test('teams level on points are split by their head-to-head result', () {
    // 1 and 2 both finish on the same points and goal difference, but 2 beat 1
    // head-to-head, so 2 must rank above 1 despite equal overall numbers.
    final fixtures = [
      _fx(1, 3, 3, 0), // 1 beats 3
      _fx(2, 3, 3, 0), // 2 beats 3 (same margin)
      _fx(2, 1, 1, 0), // 2 beats 1 head-to-head
      _fx(3, 1, 0, 0), // padding draw, doesn't change the tie
    ];
    final table = GroupStanding.table([1, 2, 3], fixtures);
    expect(table.first.nationId, 2, reason: '2 won the head-to-head');
    expect(table[1].nationId, 1);
  });

  test('head-to-head only applies within a points tie, not across it', () {
    // A clear leader on points stays top even if it lost to a lower team.
    final fixtures = [
      _fx(1, 2, 0, 1), // 2 beat 1
      _fx(1, 3, 5, 0), // 1 hammers 3
      _fx(2, 3, 1, 0), // 2 edges 3
    ];
    final table = GroupStanding.table([1, 2, 3], fixtures);
    // 2 has 6 pts, 1 has 3 pts, 3 has 0 — points win outright.
    expect(table.map((s) => s.nationId).toList(), [2, 1, 3]);
  });

  test('falls back to overall goal difference when head-to-head is level', () {
    // 1 and 2 drew head-to-head and are level on points; 1 has the better
    // overall goal difference, so it ranks first.
    final fixtures = [
      _fx(1, 2, 1, 1), // head-to-head draw
      _fx(1, 3, 4, 0), // 1: big win
      _fx(2, 3, 1, 0), // 2: narrow win
    ];
    final table = GroupStanding.table([1, 2, 3], fixtures);
    expect(table.first.nationId, 1, reason: 'better overall GD');
  });
}
