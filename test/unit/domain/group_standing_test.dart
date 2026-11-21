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

  test('two level: their meeting decides, even over a better score', () {
    // The reported group E: NED and TUR on 6, TUR +3, NED +2, NED won 2-1.
    const uzb = 1, ned = 2, crc = 3, tur = 4;
    final fixtures = [
      _fx(uzb, ned, 2, 1),
      _fx(crc, tur, 0, 3),
      _fx(tur, uzb, 2, 1),
      _fx(crc, ned, 0, 2),
      _fx(uzb, crc, 1, 2),
      _fx(tur, ned, 1, 2),
    ];
    final table = GroupStanding.table([uzb, ned, crc, tur], fixtures);
    expect(table.map((s) => s.nationId).take(2), [ned, tur]);
  });

  test('three level: the score decides before their mini-table', () {
    // 1, 2 and 3 all on 6; their meetings go round (each beat one), but by
    // different margins, so the mini-table alone would put 3 first. The
    // overall goal difference puts 1 first.
    final fixtures = [
      _fx(1, 2, 1, 0),
      _fx(2, 3, 1, 0),
      _fx(3, 1, 3, 0),
      _fx(1, 4, 9, 0),
      _fx(2, 4, 2, 0),
      _fx(3, 4, 1, 0),
    ];
    final table = GroupStanding.table([1, 2, 3, 4], fixtures);
    // Overall GD: 1 = +7, 3 = +3, 2 = +2.
    expect(table.map((s) => s.nationId), [1, 3, 2, 4]);
  });

  test(
    'three level, two of them still level on the score: their meeting',
    () {
      // 1, 2, 3 all on 6, going round: 2 beat 1, 3 beat 2, 1 beat 3, each
      // 1-0. Against 4: 1 wins 5-0, 2 and 3 2-0. 1 is +5; 2 and 3 are both
      // +2 with three goals, and 3 beat 2.
      final fixtures = [
        _fx(2, 1, 1, 0),
        _fx(3, 2, 1, 0),
        _fx(1, 3, 1, 0),
        _fx(1, 4, 5, 0),
        _fx(2, 4, 2, 0),
        _fx(3, 4, 2, 0),
      ];
      final table = GroupStanding.table([1, 2, 3, 4], fixtures);
      expect(table.map((s) => s.nationId), [1, 3, 2, 4]);
    },
  );
}
