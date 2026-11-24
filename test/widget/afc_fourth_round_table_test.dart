import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/confed_playoffs_view.dart';

import '../helpers/pump_app.dart';

/// Asia's fourth round on the World Championship play-off tab shows its two
/// groups of three as tables, not only their matches.
void main() {
  var id = 0;
  Fixture f(int day, int home, int away, [int? hs, int? as]) => Fixture(
    id: ++id,
    careerId: 1,
    competitionId: 1,
    matchday: day,
    date: DateTime(2029, 10, day),
    homeNationId: home,
    awayNationId: away,
    homeScore: hs,
    awayScore: as,
    played: hs != null,
    round: 'AQ4',
  );
  // Group A: 1, 2, 3. Group B: 4, 5, 6. Two matchdays played, one to come.
  final fixtures = [
    f(8, 1, 3, 2, 0),
    f(8, 4, 6, 1, 1),
    f(11, 2, 3, 1, 0),
    f(11, 5, 6, 0, 2),
    f(14, 1, 2),
    f(14, 4, 5),
  ];

  test('groups are found from who meets whom', () {
    final groups = afcGroupsOf(fixtures);
    expect(
      [for (final g in groups) g.sides.toSet()],
      [
        {1, 2, 3},
        {4, 5, 6},
      ],
    );
  });

  testWidgets('both groups are drawn as tables above the matches', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ConfedPlayoffSteps(
            steps: {Confederation.asia: fixtures},
            code: (id) => 'N$id',
            name: (id) => 'Nation $id',
            playerNationId: 3,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (var n = 1; n <= 6; n++) {
      expect(find.byKey(ValueKey('afcTable.$n')), findsOneWidget);
    }
    expect(find.text('Nation 1'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
