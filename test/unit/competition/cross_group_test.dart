import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/cross_group.dart';
import 'package:fnm/domain/services/competition/qualification.dart';

/// Builds a played fixture between two nations.
Fixture _f(int home, int away, int hs, int as, {int id = 0}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2027),
  homeNationId: home,
  awayNationId: away,
  homeScore: hs,
  awayScore: as,
  played: true,
);

/// A double round-robin where every team beats everyone ranked below it, so
/// the finishing order is exactly [members] and the results are predictable.
List<Fixture> _pecking(List<int> members) {
  final out = <Fixture>[];
  var id = 0;
  for (var i = 0; i < members.length; i++) {
    for (var j = i + 1; j < members.length; j++) {
      out
        ..add(_f(members[i], members[j], 1, 0, id: id++))
        ..add(_f(members[j], members[i], 0, 1, id: id++));
    }
  }
  return out;
}

void main() {
  group('CrossGroup', () {
    test('leaves even groups untouched', () {
      final a = GroupStanding.table([1, 2, 3], _pecking([1, 2, 3]));
      final b = GroupStanding.table([4, 5, 6], _pecking([4, 5, 6]));
      expect(CrossGroup.isUneven([a, b]), isFalse);
      final adjusted = CrossGroup.comparable([a, b]);
      expect(adjusted[0][0].points, a[0].points);
      expect(adjusted[0][0].played, a[0].played);
      expect(adjusted[1][0].points, b[0].points);
    });

    test('drops results against the bigger group\'s bottom side', () {
      // Group A has six teams, group B five. In A everyone beats everyone
      // below them, so 1 wins all ten (30 pts) and 6 finishes last.
      final a = GroupStanding.table([
        1,
        2,
        3,
        4,
        5,
        6,
      ], _pecking([1, 2, 3, 4, 5, 6]));
      final b = GroupStanding.table([
        11,
        12,
        13,
        14,
        15,
      ], _pecking([11, 12, 13, 14, 15]));

      expect(CrossGroup.isUneven([a, b]), isTrue);
      expect(a[0].points, 30); // 10 games, all won
      expect(b[0].points, 24); // 8 games, all won

      final adjusted = CrossGroup.comparable([a, b]);
      // A's winner loses the two wins over the dropped last-placed side.
      expect(adjusted[0][0].points, 24);
      expect(adjusted[0][0].played, 8);
      // B is already the comparable size, so it is unchanged.
      expect(adjusted[1][0].points, 24);
      expect(adjusted[1][0].played, 8);
      // Group positions never move: the order is still the real one.
      expect(adjusted[0].map((s) => s.nationId), [1, 2, 3, 4, 5, 6]);
    });

    test('third places from uneven groups are ranked over the same games', () {
      final a = GroupStanding.table([
        1,
        2,
        3,
        4,
        5,
        6,
      ], _pecking([1, 2, 3, 4, 5, 6]));
      final b = GroupStanding.table([
        11,
        12,
        13,
        14,
        15,
      ], _pecking([11, 12, 13, 14, 15]));

      // Raw totals flatter the six-team group's third place purely because it
      // played two more games: 18 points from 10 against 12 from 8.
      expect(a[2].points, 18);
      expect(a[2].played, 10);
      expect(b[2].points, 12);
      expect(b[2].played, 8);

      // Once results against A's bottom side are dropped, both third places are
      // judged over the same eight games — which is the whole point: the six
      // team group no longer carries a two-game head start into the ladder.
      final thirds = CrossGroup.tier([a, b], 2);
      expect(thirds.map((s) => s.nationId), containsAll([3, 13]));
      expect(thirds.every((s) => s.played == 8), isTrue);
      expect(thirds.every((s) => s.points == 12), isTrue);
    });

    test('qualification picks tiers on the comparable records', () {
      final a = GroupStanding.table([
        1,
        2,
        3,
        4,
        5,
        6,
      ], _pecking([1, 2, 3, 4, 5, 6]));
      final b = GroupStanding.table([
        11,
        12,
        13,
        14,
        15,
      ], _pecking([11, 12, 13, 14, 15]));

      // Two berths: both group winners, whatever the group sizes.
      expect(Qualification.qualifiers([a, b], 2), containsAll([1, 11]));
      // A third berth goes to the better runner-up over the same eight games.
      final three = Qualification.qualifiers([a, b], 3);
      expect(three.length, 3);
      expect(three.sublist(2).single, anyOf(2, 12));
    });
  });
}
