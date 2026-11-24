import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/world_managers/manager_windows.dart';

import '../../helpers/fixtures.dart';

/// A regional cup's (or a qualifying league's) games carry no round. They
/// used to match the null "final round" of every non-finals kind and file a
/// continental championship as settled once per game, so a manager's score
/// for one cycle came out in the hundreds and every reputation hit 100.
void main() {
  Fixture played(int id, int comp, DateTime date, {String? round}) => Fixture(
    id: id,
    careerId: 1,
    competitionId: comp,
    matchday: id,
    date: date,
    homeNationId: 1,
    awayNationId: 2,
    homeScore: 1,
    awayScore: 0,
    played: true,
    round: round,
  );

  test("only a finals tournament's own final settles it, once", () {
    final windows = ManagerWindows(
      nations: [
        nation(id: 1, name: 'One', confederation: Confederation.asia),
        nation(id: 2, name: 'Two', confederation: Confederation.asia),
      ],
      baseline: const {1: 50, 2: 60},
      competitions: const {
        1: (
          kind: CompetitionKind.regionalCup,
          confederation: Confederation.asia,
        ),
        2: (
          kind: CompetitionKind.continentalFinals,
          confederation: Confederation.asia,
        ),
      },
      fixtures: [
        // A regional cup's games, no round at all.
        for (var i = 0; i < 12; i++) played(i, 1, DateTime(2029, 10, i + 1)),
        // The Asian championship: a group game and its final.
        played(20, 2, DateTime(2028, 6, 20), round: 'GROUP'),
        played(21, 2, DateTime(2028, 7, 10), round: 'CFINAL'),
      ],
    );
    expect(windows.decided.map((t) => t.key), ['cont:ASIA:2028']);
    expect(windows.decided.single.finalOn, DateTime(2028, 7, 10));
  });
}
