import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';

import '../helpers/pump_app.dart';

/// A tournament's roll of honour.
///
/// For a competition simulated in the background, these cards are the only
/// result the manager ever sees — so they must carry the whole podium, not just
/// the winner.
void main() {
  const names = {
    1: 'Spain',
    2: 'France',
    3: 'Brazil',
    4: 'Japan',
    5: 'Morocco',
  };
  String name(int id) => names[id] ?? 'Unknown';
  String code(int id) => 'N$id';

  Honour honour({
    int year = 2028,
    int champion = 1,
    int runnerUp = 2,
    int? third = 3,
    int? host = 4,
    int? homeScore = 2,
    int? awayScore = 1,
  }) =>
      (
        year: year,
        competition: 'European Championship',
        championId: champion,
        runnerUpId: runnerUp,
        thirdId: third,
        hostId: host,
        finalHomeScore: homeScore,
        finalAwayScore: awayScore,
        topScorerName: null,
        topScorerGoals: null,
      );

  testWidgets('an edition names the whole podium, not just the winner',
      (tester) async {
    await tester.pumpApp(
      TournamentHistory(honours: [honour()], name: name, code: code),
    );
    await tester.pumpAndSettle();

    expect(find.text('2028'), findsOneWidget);
    expect(find.text('Host: Japan'), findsOneWidget);
    // Champion, runner-up AND third all named — the runner-up used to be an
    // unlabelled flag and third place was not shown at all.
    expect(find.text('Spain'), findsWidgets);
    expect(find.text('France'), findsWidgets);
    expect(find.text('Brazil'), findsWidgets);
    expect(find.text('2–1'), findsOneWidget);
  });

  testWidgets('a level final reads as penalties', (tester) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: [honour(homeScore: 1, awayScore: 1)],
        name: name,
        code: code,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1–1 (pens)'), findsOneWidget);
  });

  testWidgets('an edition without a third place still renders', (tester) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: [honour(third: null)],
        name: name,
        code: code,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Spain'), findsWidgets);
    expect(find.text('Brazil'), findsNothing);
  });

  testWidgets('the medal table counts golds, silvers and bronzes',
      (tester) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: [
          honour(year: 2028, champion: 1, runnerUp: 2, third: 3),
          honour(year: 2024, champion: 1, runnerUp: 3, third: 2),
        ],
        name: name,
        code: code,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MEDAL TABLE'), findsOneWidget);
    expect(find.text('🥇2'), findsOneWidget, reason: 'Spain won both');
  });

  testWidgets('no honours reads as an empty state', (tester) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: const [],
        name: name,
        code: code,
        emptyMessage: 'Nothing yet.',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nothing yet.'), findsOneWidget);
  });
}
