import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/qualification.dart';

/// The New Zealand report: NZ and the Solomon Islands each won an Oceania
/// qualifying group, NZ on the better record, and the Solomon Islands went to
/// the intercontinental play-off.
///
/// That is the format working: Oceania has ONE direct place and ONE play-off
/// entrant, so the better group winner goes straight to the finals and the
/// other one to the play-off. These pin it, on groups of unequal size (Oceania
/// plays a six and a five), where the comparison drops the big group's results
/// against its bottom side so both winners are judged over the same games.
void main() {
  const nz = 205;
  const solomon = 208;

  var nextId = 0;
  Fixture fx(int home, int away, int hs, int as) => Fixture(
    id: nextId++,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2029),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: true,
  );

  /// A single round robin: [leader]'s results are given against each rival
  /// in order, every other game is a 0-0 draw.
  List<GroupStanding> group(
    int leader,
    List<int> rivals,
    List<(int, int)> leaderScores,
  ) {
    final fixtures = <Fixture>[
      for (var i = 0; i < rivals.length; i++)
        fx(leader, rivals[i], leaderScores[i].$1, leaderScores[i].$2),
      for (var i = 0; i < rivals.length; i++)
        for (var j = i + 1; j < rivals.length; j++)
          fx(rivals[i], rivals[j], 0, 0),
    ];
    return GroupStanding.table([leader, ...rivals], fixtures);
  }

  Set<int> playoff(List<List<GroupStanding>> groups) =>
      GroupAdvancement.worldCupPlayoffNations(
        Confederation.oceania,
        groups,
        hosts: 0,
      );

  List<int> pool(List<List<GroupStanding>> groups) =>
      WorldCupFinals.playoffPoolFor(
        byConfederation: {Confederation.oceania: groups},
        rankingById: const {},
        hostBerths: const {},
      );

  test('the better group winner goes to the finals, the other to the '
      'play-off (NZ in the group of six)', () {
    // NZ wins all five: 12 points over the four comparable games.
    final a = group(nz, [301, 302, 303, 304, 305], const [
      (2, 0),
      (2, 0),
      (2, 0),
      (2, 0),
      (2, 0),
    ]);
    // Solomon: three wins and a draw, 10 points over four.
    final b = group(solomon, [401, 402, 403, 404], const [
      (1, 0),
      (1, 0),
      (1, 0),
      (0, 0),
    ]);
    expect(a.first.nationId, nz);
    expect(b.first.nationId, solomon);
    for (final groups in [
      [a, b],
      [b, a], // group order must not matter
    ]) {
      expect(Qualification.qualifiers(groups, 1), [nz]);
      expect(playoff(groups), {solomon});
      expect(pool(groups), [solomon]);
    }
  });

  test('the better winner goes direct with NZ in the group of five', () {
    final a = group(nz, [401, 402, 403, 404], const [
      (3, 0),
      (3, 0),
      (2, 0),
      (1, 0),
    ]);
    final b = group(solomon, [301, 302, 303, 304, 305], const [
      (1, 0),
      (1, 0),
      (1, 0),
      (0, 0),
      (0, 0),
    ]);
    expect(Qualification.qualifiers([b, a], 1), [nz]);
    expect(playoff([b, a]), {solomon});
  });

  test('level on comparable points, goal difference decides', () {
    final a = group(nz, [301, 302, 303, 304, 305], const [
      (4, 0),
      (3, 0),
      (1, 0),
      (0, 0),
      (2, 0),
    ]);
    final b = group(solomon, [401, 402, 403, 404], const [
      (1, 0),
      (1, 0),
      (1, 0),
      (0, 0),
    ]);
    expect(Qualification.qualifiers([b, a], 1), [nz]);
    expect(playoff([b, a]), {solomon});
  });

  test('a big-group winner is judged without its games against the bottom '
      'side', () {
    // NZ's raw record (11 points from five) beats Solomon's 9 from four, but
    // 5 of it came from the sixth-placed side the smaller group has no match
    // for. Over the same four games NZ has 8, Solomon 9: Solomon goes direct.
    final a = group(nz, [301, 302, 303, 304, 305], const [
      (1, 0),
      (1, 0),
      (0, 0),
      (0, 0),
      (5, 0),
    ]);
    // Make 305 the clear bottom side of NZ's group.
    final b = group(solomon, [401, 402, 403, 404], const [
      (1, 0),
      (1, 0),
      (1, 0),
      (0, 1),
    ]);
    expect(a.first.nationId, nz);
    expect(a.first.points, 11);
    expect(Qualification.qualifiers([a, b], 1), [solomon]);
    expect(playoff([a, b]), {nz});
  });
}
