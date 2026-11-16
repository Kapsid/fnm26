import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/assistant_match.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

/// A friendly left to the assistant: first the sheet (tactics or play),
/// then its result with the scorers.
void main() {
  testWidgets('the sheet offers the tactics before the assistant plays', (
    tester,
  ) async {
    AssistantChoice? picked;
    await tester.pumpApp(
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async =>
                picked = await showModalBottomSheet<AssistantChoice>(
                  context: context,
                  builder: (_) =>
                      const AssistantMatchSheet(opponent: 'Portugal'),
                ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Portugal'), findsOneWidget);
    await tester.tap(find.byKey(AssistantMatchSheet.tacticsKey));
    await tester.pumpAndSettle();
    expect(picked, AssistantChoice.tactics);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AssistantMatchSheet.playKey));
    await tester.pumpAndSettle();
    expect(picked, AssistantChoice.play);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the result: the score and who scored', (tester) async {
    final home = nation(id: 1, name: 'Czechia');
    final away = nation(id: 2, name: 'Portugal');
    final f = Fixture(
      id: 5,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2026, 9, 10),
      homeNationId: 1,
      awayNationId: 2,
      round: 'FRIENDLY',
      homeScore: 2,
      awayScore: 1,
      played: true,
    );
    await tester.pumpApp(
      Scaffold(
        body: AssistantResultDialog(
          result: (
            fixture: f,
            scorers: [
              (name: 'Jan Novák', nationId: 1),
              (name: 'Jan Novák', nationId: 1),
              (name: 'Rui Costa', nationId: 2),
            ],
          ),
          nations: {1: home, 2: away},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(AssistantResultDialog.scoreKey)).data,
      '2 - 1',
    );
    expect(find.text('Jan Novák'), findsNWidgets(2));
    expect(find.text('Rui Costa'), findsOneWidget);
    expect(find.text('Czechia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
