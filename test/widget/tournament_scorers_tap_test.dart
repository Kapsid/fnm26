import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';

import '../helpers/pump_app.dart';

/// A scorer on a tournament's chart opens that player's page.
void main() {
  testWidgets('tapping a scorer row reports that player', (tester) async {
    final tapped = <int>[];
    await tester.pumpApp(
      Scaffold(
        body: TournamentScorers(
          scorers: const [
            (playerId: 7, nationId: 1, goals: 5),
            (playerId: 8, nationId: 2, goals: 3),
          ],
          playerNames: const {7: 'Orvald Kestrin', 8: 'Mirek Dolanski'},
          code: (id) => 'N$id',
          onPlayerTap: tapped.add,
        ),
      ),
    );
    await tester.tap(find.text('Mirek Dolanski'));
    await tester.pump();
    await tester.tap(find.text('Orvald Kestrin'));
    await tester.pump();
    expect(tapped, [8, 7]);
  });
}
