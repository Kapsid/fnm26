import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';

import '../helpers/pump_app.dart';

/// A shared edition's history row names every co-host, not just the primary.
///
/// The row used to read `Honour.hostId` alone, so a three-way co-hosted
/// tournament (USA/Canada/Mexico, say) showed only the first name in the
/// history list, even though `Honour.hostIds` had all three all along.
void main() {
  const names = {10: 'Spain', 11: 'Portugal', 12: 'Morocco'};
  const codes = {10: 'ESP', 11: 'POR', 12: 'MAR'};
  String name(int id) => names[id] ?? 'Unknown';
  String code(int id) => codes[id] ?? '??';

  Honour honour({List<int> hostIds = const [10, 11, 12]}) => (
    year: 2026,
    competition: 'World Championship',
    championId: 1,
    runnerUpId: 2,
    thirdId: null,
    thirdId2: null,
    hostId: hostIds.isEmpty ? null : hostIds.first,
    hostIds: hostIds,
    finalHomeScore: 2,
    finalAwayScore: 1,
    topScorerName: null,
    topScorerGoals: null,
  );

  testWidgets('a three-way co-host renders every host as a code', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHistory(honours: [honour()], name: name, code: code),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ESP'), findsOneWidget);
    expect(find.textContaining('POR'), findsOneWidget);
    expect(find.textContaining('MAR'), findsOneWidget);
  });

  testWidgets('a single host still renders by name, not a bare code', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: [
          honour(hostIds: const [10]),
        ],
        name: name,
        code: code,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Host: Spain'), findsOneWidget);
    expect(find.textContaining('ESP'), findsNothing);
  });
}
