import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/pump_app.dart';

/// The New Zealand report, on screen: Oceania's "best group winners" card
/// headed its one green row with "Top 1 advance to the finals play-off", so
/// the best winner read as the one bound for the play-off. The green row now
/// goes to the finals, and the play-off entrant behind it is marked and
/// counted on a line of its own.
void main() {
  final l = AppLocalizationsEn();

  GroupStanding row(int id, int won) => GroupStanding(id)
    ..played = 4
    ..won = won;

  testWidgets('the best winner goes to the finals, the next to the play-off', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: BestThirdsCard(
          thirds: [row(205, 4), row(208, 3)],
          qualifyCount: 1,
          playerNationId: 0,
          code: (_) => 'NZL',
          name: (id) => id == 205 ? 'New Zealand' : 'Solomon Islands',
          title: l.tourContBestWinners,
          destination: l.tourCupDestFinals,
          playoffNations: const {208},
          playoffDestination: l.tourCupDestIntercontPlayoff,
        ),
      ),
    );
    expect(find.text(l.tourThirdsAdvance(1, l.tourCupDestFinals)), findsOne);
    expect(
      find.text(l.tourThirdsNextAdvance(1, l.tourCupDestIntercontPlayoff)),
      findsOne,
    );
    expect(find.textContaining('finals play-off'), findsNothing);
  });

  testWidgets('no play-off line where nobody below the band goes', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: BestThirdsCard(
          thirds: [row(1, 3), row(2, 2), row(3, 1)],
          qualifyCount: 2,
          playerNationId: 0,
          code: (_) => 'ABC',
          name: (id) => 'N$id',
        ),
      ),
    );
    expect(find.textContaining('The next'), findsNothing);
  });
}
