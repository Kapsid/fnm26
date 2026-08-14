import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/shared/widgets/match_result_row.dart';

import '../helpers/pump_app.dart';

/// The shared result row. A knockout settled on penalties carries an explicit
/// shootout score, shown as a "pens X-Y" tag under the scoreline.
void main() {
  Fixture level(String? round) => Fixture(
    id: 1,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2029, 3, 6),
    homeNationId: 1,
    awayNationId: 2,
    homeScore: 1,
    awayScore: 1,
    played: true,
    round: round,
  );

  /// A knockout won on penalties: the stored score shows a winner, and the
  /// shootout score is carried in the penalty columns.
  Fixture shootout(String round) => Fixture(
    id: 1,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2029, 3, 6),
    homeNationId: 1,
    awayNationId: 2,
    homeScore: 2,
    awayScore: 1,
    played: true,
    round: round,
    afterExtraTime: true,
    homePenalties: 4,
    awayPenalties: 3,
  );

  String code(int id) => 'N$id';

  Future<void> pump(WidgetTester tester, Fixture f) async {
    await tester.pumpApp(
      Scaffold(
        body: MatchResultRow(fixture: f, code: code),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a drawn continental qualifier is not a shootout', (
    tester,
  ) async {
    // Regression: 'CQ' isn't a group code, so a check that inferred knockout by
    // excluding 'GROUP' rendered "1 - 1 p" on an ordinary drawn qualifier.
    await pump(tester, level('CQ'));
    expect(find.text('1 - 1'), findsOneWidget);
    expect(find.text('1 - 1 p'), findsNothing);
  });

  testWidgets('a drawn friendly is not a shootout', (tester) async {
    await pump(tester, level('FRIENDLY'));
    expect(find.text('1 - 1'), findsOneWidget);
  });

  testWidgets('a drawn group game is not a shootout', (tester) async {
    for (final round in ['GROUP', 'CGROUP', 'NGROUP']) {
      await pump(tester, level(round));
      expect(find.text('1 - 1'), findsOneWidget, reason: round);
      expect(find.text('1 - 1 p'), findsNothing, reason: round);
    }
  });

  testWidgets('a drawn World Cup qualifier is not a shootout', (tester) async {
    // Qualifying fixtures carry no round code.
    await pump(tester, level(null));
    expect(find.text('1 - 1'), findsOneWidget);
  });

  testWidgets('a knockout settled on penalties shows the shootout score', (
    tester,
  ) async {
    for (final round in ['SF', 'CFINAL', 'NSF', '3RD']) {
      await pump(tester, shootout(round));
      expect(find.text('2 - 1'), findsOneWidget, reason: round);
      expect(find.text('pens 4-3'), findsOneWidget, reason: round);
    }
  });

  testWidgets('a drawn group game bolds neither side', (tester) async {
    // The same flag poisoned `drawn`, so emphasiseWinner bolded the home side
    // of a draw.
    await tester.pumpApp(
      Scaffold(
        body: MatchResultRow(
          fixture: level('CQ'),
          code: code,
          emphasiseWinner: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    // FlagDisc also renders the code as its fallback text, so assert on the
    // claim itself: neither side is emphasised.
    final weights = tester
        .widgetList<Text>(find.byType(Text))
        .where((t) => t.data == 'N1' || t.data == 'N2')
        .map((t) => t.style?.fontWeight);
    expect(
      weights,
      isNot(contains(FontWeight.w700)),
      reason: 'nobody won a drawn game',
    );
  });
}
