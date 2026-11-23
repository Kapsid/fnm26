import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/confed_playoffs.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';

/// The tester's report: Asia's qualifying tables on calendar2 painted both
/// the group winners and the runners-up orange, while the ladder under them
/// painted the best six winners green. The tables now read the same ladder:
/// the best six winners are on course for the finals (green), the last two
/// winners and the four best runners-up for the fourth round (yellow), and
/// the other runners-up are only still in it (orange).
void main() {
  GroupStanding row(int id, int won) => GroupStanding(id)
    ..played = 3
    ..won = won
    ..lost = 3 - won
    ..goalsFor = won
    ..goalsAgainst = 3 - won;

  // Eight groups of four: group g's winner (id g*10) won 3 games with g
  // goals more for the earlier groups, its runner-up (g*10+1) won 2.
  final groups = [
    for (var g = 0; g < 8; g++)
      [
        row(g * 10, 3)..goalsFor = 10 - g,
        row(g * 10 + 1, 2)..goalsFor = 10 - g,
        row(g * 10 + 2, 1),
        row(g * 10 + 3, 0),
      ],
  ];

  test('the best six winners are on course for the finals', () {
    final direct = GroupAdvancement.worldCupDirectNations(
      Confederation.asia,
      groups,
      hosts: 0,
      confedSteps: true,
    );
    expect(direct, {0, 10, 20, 30, 40, 50});
  });

  test('the fourth round takes the last two winners and best four seconds', () {
    final step = GroupAdvancement.worldCupPlayoffNations(
      Confederation.asia,
      groups,
      hosts: 0,
      confedSteps: true,
    );
    expect(step, {60, 70, 1, 11, 21, 31});
    expect(
      ConfedPlayoffs.entrants(Confederation.asia, groups, hosts: 0).toSet(),
      step,
    );
  });

  test('without the step every winner goes and the ladder is unchanged', () {
    final direct = GroupAdvancement.worldCupDirectNations(
      Confederation.asia,
      groups,
      hosts: 0,
    );
    expect(direct, {for (var g = 0; g < 8; g++) g * 10});
    expect(
      GroupAdvancement.worldCupHasStep(Confederation.asia, hosts: 0),
      isFalse,
    );
  });

  test('a host takes a place: seven winners go, the eighth is in play', () {
    final direct = GroupAdvancement.worldCupDirectNations(
      Confederation.asia,
      groups,
      hosts: 1,
    );
    expect(direct, {0, 10, 20, 30, 40, 50, 60});
  });
}
