import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/shared/widgets/match_result_row.dart';

import '../helpers/pump_app.dart';

/// A two-legged tie's second leg shows the aggregate: on the result row (the
/// round's results, the cup's bracket). The live scoreboard does not show it.
void main() {
  // First leg: 1 at home to 2, 2-0. Second leg: 2 at home to 1, 1-0.
  final first = Fixture(
    id: 1,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 12, 10),
    homeNationId: 1,
    awayNationId: 2,
    homeScore: 2,
    awayScore: 0,
    played: true,
    round: 'XASFL1',
  );
  final second = Fixture(
    id: 2,
    careerId: 1,
    competitionId: 1,
    matchday: 2,
    date: DateTime(2030, 12, 14),
    homeNationId: 2,
    awayNationId: 1,
    homeScore: 1,
    awayScore: 0,
    played: true,
    round: 'XASFL2',
  );
  String code(int id) => 'N$id';

  testWidgets('the result row shows the aggregate and bolds who went through', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: MatchResultRow(
          fixture: second,
          code: code,
          firstLeg: first,
          emphasiseWinner: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    // From the second leg's hosts: 1 + 0 against 0 + 2.
    expect(find.text('agg 1-2'), findsOneWidget);
    // The code beside each flag is bold for the side that went through (the
    // flag draws the code too, in its own weight).
    bool bold(String t) => tester
        .widgetList<Text>(find.text(t))
        .any((w) => w.style?.fontWeight == FontWeight.w700);
    expect(bold('N1'), isTrue);
    expect(bold('N2'), isFalse);
  });

  testWidgets('no first leg, no aggregate', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: MatchResultRow(fixture: second, code: code),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('matchResultRow.aggregate')),
      findsNothing,
    );
  });
}
