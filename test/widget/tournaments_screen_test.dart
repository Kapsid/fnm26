import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';

import '../helpers/expect_whole.dart';
import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  final nations = {
    1: nation(id: 1, name: 'Spain', confederation: Confederation.europe),
    2: nation(id: 2, name: 'France', confederation: Confederation.europe),
    3: nation(id: 3, name: 'Brazil', confederation: Confederation.southAmerica),
  };

  // The statuses carry their own copy: the provider localises them before the
  // screen ever sees them, so a fixed English string here is what the screen
  // is handed in any locale.
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
    // The two tiles built outside the per-confederation grid, so the width
    // sweep below also measures the Nations Cup's "LEAGUE A" strap and the
    // Clash's long "INTERCONTINENTAL" one. Their status labels are unique so
    // the finders above still match one tile each.
    nationsCup: const TournamentStatus(
      phase: TournamentPhase.live,
      label: 'IN PROGRESS',
      championId: null,
    ),
    continentalClash: const TournamentStatus(
      phase: TournamentPhase.upcoming,
      label: 'NOT YET',
      championId: null,
    ),
    clashInvolvesPlayer: true,
  );

  group('TournamentsScreen', () {
    testWidgets('shows dynamic championship statuses and unlocks tiles', (
      tester,
    ) async {
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

    // The overview held the competition names as English string literals and
    // printed them as they stood, so the one screen that lists every
    // competition was the one place a Czech manager still read "European
    // Championship". The names are CANONICAL — they key the trophy artwork
    // and are compared against stored fixtures — so they stay English in the
    // code and go through competitionLabel on the way to the tile.
    testWidgets('names the competitions, and their zones, in Czech', (
      tester,
    ) async {
      await tester.pumpApp(
        const TournamentsScreen(careerId: 1),
        locale: const Locale('cs'),
        overrides: [
          tournamentsOverviewProvider.overrideWith(
            (ref, careerId) async => overview,
          ),
        ],
      );
      await tester.pumpAndSettle();
      expectLocale(tester, find.byType(TournamentsScreen), 'cs');

      expect(find.text('Evropský šampionát'), findsOneWidget);
      expect(find.text('European Championship'), findsNothing);
      expect(find.text('Mistrovství světa'), findsOneWidget);
      // The zone strap under the tile is copy too, not a constant.
      expect(find.text('EVROPA'), findsOneWidget);
      expect(find.text('SVĚT'), findsOneWidget);
      expect(find.text('EUROPE'), findsNothing);
      expect(find.text('GLOBAL'), findsNothing);
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
            thirdId2: null,
            hostId: null,
            hostIds: <int>[],
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
