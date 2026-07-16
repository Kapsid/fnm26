import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  final nations = {
    1: nation(id: 1, name: 'Spain', confederation: Confederation.europe),
    2: nation(id: 2, name: 'France', confederation: Confederation.europe),
    3: nation(id: 3, name: 'Brazil', confederation: Confederation.southAmerica),
  };

  group('TournamentsScreen', () {
    testWidgets('shows dynamic championship statuses and unlocks tiles', (
      tester,
    ) async {
      final overview = TournamentsOverview(
        playerConfederation: Confederation.europe,
        nations: nations,
        nextMatches: const {},
        playerGroup: null,
        worldCupHostId: null,
        statuses: {
          null: const TournamentStatus(
            phase: TournamentPhase.live,
            label: 'QUALIFYING',
            championId: null,
          ),
          Confederation.europe: const TournamentStatus(
            phase: TournamentPhase.decided,
            label: 'CHAMPIONS',
            championId: 1,
          ),
          Confederation.southAmerica: const TournamentStatus(
            phase: TournamentPhase.history,
            label: 'PAST WINNERS',
            championId: null,
          ),
          Confederation.africa: const TournamentStatus(
            phase: TournamentPhase.upcoming,
            label: 'COMING SOON',
            championId: null,
          ),
        },
      );

      await tester.pumpApp(
        const TournamentsScreen(careerId: 1),
        overrides: [
          tournamentsOverviewProvider.overrideWith((ref, careerId) async {
            return overview;
          }),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('European Championship'), findsOneWidget);
      // The decided continental cup surfaces its champion and unlocks.
      expect(find.text('CHAMPIONS'), findsOneWidget);
      expect(find.text('Spain'), findsWidgets);
      // Scroll the lazy list to reach the lower tiles.
      await tester.scrollUntilVisible(find.text('PAST WINNERS'), 300);
      expect(find.text('PAST WINNERS'), findsOneWidget);
      // The upcoming African Championship stays locked (its status shows).
      await tester.scrollUntilVisible(find.text('COMING SOON'), 300);
      expect(find.text('COMING SOON'), findsOneWidget);
    });
  });

  group('ContinentalDetailScreen', () {
    testWidgets('renders the roll of honour for a region', (tester) async {
      final data = ContinentalData(
        name: 'European Championship',
        confederation: Confederation.europe,
        isPlayerRegion: false,
        hostCount: 1,
        qualifyingGroups: const [],
        groups: const [],
        knockout: const [],
        champion: null,
        scorers: const [],
        honours: const [
          (
            year: 2032,
            competition: 'European Championship',
            championId: 1,
            runnerUpId: 2,
            thirdId: null,
            hostId: null,
            finalHomeScore: 2,
            finalAwayScore: 1,
            topScorerName: null,
            topScorerGoals: null,
          ),
        ],
        nations: nations,
        playerNationId: 3,
        playerNames: const {},
      );

      await tester.pumpApp(
        const ContinentalDetailScreen(
          careerId: 1,
          confederation: Confederation.europe,
        ),
        overrides: [
          continentalDetailProvider.overrideWith((ref, key) async => data),
        ],
      );
      await tester.pumpAndSettle();

      // The roll of honour lives on the HISTORY tab.
      await tester.tap(find.text('HISTORY'));
      await tester.pumpAndSettle();
      expect(find.text('MEDAL TABLE'), findsOneWidget);
      expect(find.text('PAST WINNERS'), findsOneWidget);
      expect(find.text('Spain'), findsWidgets);
      expect(find.text('2032'), findsOneWidget);
    });
  });
}
