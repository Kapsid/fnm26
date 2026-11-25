import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';

/// "North America's League B has one group with fewer teams, so its winner
/// always has a lower chance" (owner, 1.1.3). Nineteen nations make four
/// groups of four and one of three, and four of the five winners go up. On
/// raw points the three-team group's winner (four matches) could not catch
/// the others (six), so the ladder now compares every winner over the same
/// matches, as every cross-group ladder does.
void main() {
  var nextId = 1;

  /// A group's table from a double round robin in which [score] gives each
  /// match's goals (home, away).
  ({String name, List<GroupStanding> standings}) group(
    String name,
    List<int> ids,
    (int, int) Function(int home, int away) score,
  ) {
    final fixtures = <Fixture>[
      for (final h in ids)
        for (final a in ids)
          if (h != a)
            Fixture(
              id: nextId++,
              careerId: 1,
              competitionId: 1,
              matchday: 1,
              date: DateTime(2030, 9),
              homeNationId: h,
              awayNationId: a,
              homeScore: score(h, a).$1,
              awayScore: score(h, a).$2,
              played: true,
            ),
    ];
    return (name: name, standings: GroupStanding.table(ids, fixtures));
  }

  /// The lower-numbered side wins 1-0, except that the first two draw 1-1.
  (int, int) Function(int, int) fourGroup(List<int> ids) => (h, a) {
    final i = ids.indexOf(h);
    final j = ids.indexOf(a);
    if ({i, j}.containsAll({0, 1})) return (1, 1);
    // The winner beats the bottom two 2-0.
    if (i == 0) return (2, 0);
    if (j == 0) return (0, 2);
    return i < j ? (1, 0) : (0, 1);
  };

  (int, int) Function(int, int) plain(List<int> ids) =>
      (h, a) => ids.indexOf(h) < ids.indexOf(a) ? (1, 0) : (0, 1);

  test('the winner of the three-team group is compared over the same '
      'matches, and goes up', () {
    final tables = [
      for (var g = 0; g < 4; g++)
        () {
          final ids = [for (var p = 0; p < 4; p++) 100 + g * 10 + p];
          return group('A${g + 1}', ids, plain(ids));
        }(),
      for (var g = 0; g < 4; g++)
        () {
          final ids = [for (var p = 0; p < 4; p++) 200 + g * 10 + p];
          return group('B${g + 1}', ids, fourGroup(ids));
        }(),
      () {
        const ids = [300, 301, 302];
        return group('B5', ids, plain(ids));
      }(),
    ];
    // On raw points the three-team winner trails: 12 to 14.
    expect(tables.last.standings.first.points, 12);
    expect(tables[4].standings.first.nationId, 200);
    expect(tables[4].standings.first.points, 14);

    final tiers = {
      for (final t in tables)
        for (final s in t.standings)
          s.nationId: NationsCup.tierOfGroupName(t.name),
    };
    final next = NationsCup.promoteRelegate(
      tiers: tiers,
      groups: NationsCup.ladderGroupsOf(tables),
    );
    // Four places, five winners: the three-team group's perfect record now
    // counts for as much as the others' over the same four matches (8).
    expect(next[300], 0, reason: 'the three-team winner goes up');
    expect([for (var g = 0; g < 4; g++) next[200 + g * 10]], contains(1));
    // Four go up, four come down: the leagues keep their sizes.
    expect(next.values.where((t) => t == 0), hasLength(16));
  });

  test('even groups are compared as they stand', () {
    final tables = [
      for (var g = 0; g < 4; g++)
        () {
          final ids = [for (var p = 0; p < 4; p++) 100 + g * 10 + p];
          return group('A${g + 1}', ids, plain(ids));
        }(),
    ];
    final groups = NationsCup.ladderGroupsOf(tables);
    for (var i = 0; i < 4; i++) {
      expect(groups[i].winner.points, tables[i].standings.first.points);
      expect(groups[i].bottom, same(tables[i].standings.last));
    }
  });
}
