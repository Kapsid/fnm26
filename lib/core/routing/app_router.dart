import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/achievements/achievements_screen.dart';
import 'package:fnm/features/achievements/challenges_screen.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/careers_screen.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/settings/diagnostics_screen.dart';
import 'package:fnm/features/manager/manager_screen.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/features/squad/training_camp_screen.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/features/dev/style_gallery_screen.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/federation/naturalization_screen.dart';
import 'package:fnm/features/friendlies/friendlies_screen.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/messages/messages_screen.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/features/records/all_time_records_screen.dart';
import 'package:fnm/features/records/h2h_meetings_screen.dart';
import 'package:fnm/features/records/head_to_head_screen.dart';
import 'package:fnm/features/records/legends_screen.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/features/results/results_screen.dart';
import 'package:fnm/features/results/round_results_screen.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/tactics_screen.dart';
import 'package:fnm/features/tournaments/continental_clash_screen.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/continental_draw_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/finals_draw_screen.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart';
import 'package:fnm/features/tournaments/tournament_kickoff_screen.dart';
import 'package:fnm/features/tournaments/host_draw_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/features/tournaments/qualifying_draw_screen.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';
import 'package:go_router/go_router.dart';

/// Named route paths, centralised so navigation call-sites never hard-code
/// string literals.
abstract final class Routes {
  static const home = '/';

  /// National-team selection.
  static const nations = '/nations';
  static const settings = '/settings';

  /// Save-game list.
  static const saves = '/saves';

  /// New-game flow (manager name). Expects `?nationId=`.
  static const newGame = '/new-game';

  /// Starting a career with no job: the bottom of the world comes to you.
  static const startFromBottom = '/start-from-the-bottom';

  /// In-game national hub. Expects `?careerId=`.
  static const hub = '/hub';

  /// Squad & tactics. Expects `?careerId=`.
  static const tactics = '/tactics';

  /// The manager's own page: skills, staff and training. Expects `?careerId=`.
  static const manager = '/manager';

  /// Call-ups (squad selection). Expects `?careerId=`.
  static const callUps = '/call-ups';

  /// Play the next match. Expects `?careerId=`.
  static const match = '/match';

  /// All results & fixtures. Expects `?careerId=`.
  static const results = '/results';

  /// Tournaments overview. Expects `?careerId=`.
  static const tournaments = '/tournaments';

  /// World Championship detail. Expects `?careerId=`.
  static const cup = '/cup';

  /// Continental championship detail. Expects `?careerId=` and `?conf=` (a
  /// [Confederation] enum name).
  static const continental = '/continental';

  /// Continental championship group-draw ceremony. Expects `?careerId=`,
  /// `?conf=`.
  static const continentalDraw = '/continental-draw';

  /// World ranking. Expects `?careerId=`.
  static const ranking = '/ranking';

  /// World Cup finals draw ceremony. Expects `?careerId=`.
  static const finalsDraw = '/finals-draw';
  static const tournamentKickoff = '/tournament-kickoff';

  /// Choosing the squad's base camp for a tournament. Expects `?careerId=`.
  static const trainingCamp = '/training-camp';

  static const intercontinentalPlayoff = '/intercontinental-playoff';

  /// Qualifying group-draw ceremony. Expects `?careerId=` and `?worldCup=`
  /// ('true' for the World Cup qualifying draw, else the continental one).
  static const qualifyingDraw = '/qualifying-draw';

  /// Pre-match preview (review/adjust the lineup, then kick off). Expects
  /// `?careerId=`.
  static const matchPreview = '/match-preview';

  /// Post-match round results, grouped by group. Expects `?careerId=`.
  static const roundResults = '/round-results';

  /// A player's detail card. Expects `?careerId=` and `?playerId=`.
  static const player = '/player';

  /// The player's national-team records / top scorers. Expects `?careerId=`.
  static const teamStats = '/team-stats';

  /// A nation's vitrine (honours, records, ranking history). Expects
  /// `?careerId=` and `?nationId=`.
  static const nationVitrine = '/nation';

  /// The Careers hub (career summary, team records, my matches). Expects
  /// `?careerId=`.
  static const careers = '/careers';

  /// The manager's career summary + trophy cabinet. Expects `?careerId=`.
  static const careerSummary = '/career-summary';

  /// The per-save achievements screen. Expects `?careerId=`.
  static const achievements = '/achievements';

  /// The manager's messages inbox. Expects `?careerId=`.
  static const messages = '/messages';

  /// The manager's cycle-by-cycle career history. Expects `?careerId=`.
  static const managerHistory = '/manager-history';

  /// The host-selection ceremony. Expects `?careerId=` and `?worldCup=`.
  static const hostDraw = '/host-draw';

  /// Arrange friendlies for the current gap. Expects `?careerId=`.
  static const friendlies = '/friendlies';

  /// End-of-cycle event: crowns the champion and starts the next cycle. Expects
  /// `?careerId=`.
  static const cycleRollover = '/cycle-rollover';

  /// Development-only design-system showcase.
  static const gallery = '/gallery';

  /// The on-device error log (Settings → Diagnostics).
  static const diagnostics = '/diagnostics';

  /// The federation finances screen. Expects `?careerId=`.
  static const finances = '/finances';

  /// The board's objectives for the cycle. Expects `?careerId=`.
  static const boardObjectives = '/board-objectives';

  /// The under-21 watchlist. Expects `?careerId=`.
  static const youth = '/youth';

  /// The social feed.
  static const y = '/y';

  /// The forced first-of-cycle budget allocation. Expects `?careerId=`.
  static const budgetSetup = '/budget-setup';

  /// The brutal career-long challenges. Expects `?careerId=`.
  static const challenges = '/challenges';

  /// The nation's all-time record book. Expects `?careerId=`.
  static const records = '/records';
  static const legends = '/legends';

  /// The save's global all-time records across every nation. Expects
  /// `?careerId=`.
  static const allTimeRecords = '/all-time-records';

  /// The head-to-head record explorer between any two nations. Expects
  /// `?careerId=`.
  static const headToHead = '/head-to-head';

  /// Every past meeting between two nations. Expects
  /// `?careerId=&a=&b=`.
  static const h2hMeetings = '/h2h-meetings';

  /// The Nations Cup league standings. Expects `?careerId=`.
  static const nationsCup = '/nations-cup';
  static const nationsCupDraw = '/nations-cup-draw';
  static const naturalization = '/naturalization';

  /// The Continental Clash (champions-of-champions) detail. Expects
  /// `?careerId=`.
  static const continentalClash = '/continental-clash';
}

/// Provides the app's [GoRouter]. Exposed as a provider so routing can later
/// depend on app state (e.g. redirecting based on whether a save exists or the
/// premium entitlement) without a global singleton.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.nations,
        builder: (context, state) => const NationSelectScreen(),
      ),
      GoRoute(
        path: Routes.saves,
        builder: (context, state) => const SavesScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.diagnostics,
        builder: (context, state) => const DiagnosticsScreen(),
      ),
      GoRoute(
        path: Routes.startFromBottom,
        builder: (context, state) => const UnemployedStartScreen(),
      ),
      GoRoute(
        path: Routes.newGame,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['nationId'] ?? '',
              ) ??
              0;
          return NewGameScreen(nationId: id);
        },
      ),
      GoRoute(
        path: Routes.hub,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return HubScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.manager,
        builder: (context, state) => ManagerScreen(
          careerId:
              int.tryParse(state.uri.queryParameters['careerId'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: Routes.tactics,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TacticsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.callUps,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CallUpScreen(
            careerId: id,
            // When launched as a timeline event, these mark the call-up done.
            eventKind: state.uri.queryParameters['event'],
            eventCycle: int.tryParse(
              state.uri.queryParameters['cycle'] ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.matchPreview,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return MatchPreviewScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.match,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return MatchScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.roundResults,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return RoundResultsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.player,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final playerId =
              int.tryParse(
                state.uri.queryParameters['playerId'] ?? '',
              ) ??
              0;
          return PlayerDetailScreen(careerId: id, playerId: playerId);
        },
      ),
      GoRoute(
        path: Routes.teamStats,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TeamStatsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.nationVitrine,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final nationId =
              int.tryParse(
                state.uri.queryParameters['nationId'] ?? '',
              ) ??
              0;
          return NationVitrineScreen(careerId: id, nationId: nationId);
        },
      ),
      GoRoute(
        path: Routes.careers,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CareersScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.careerSummary,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CareerSummaryScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.achievements,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return AchievementsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.challenges,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return ChallengesScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.messages,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return MessagesScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.finances,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return FinancesScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.youth,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return YouthScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.y,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return YScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.boardObjectives,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return BoardObjectivesScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.budgetSetup,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return BudgetSetupScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.records,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return RecordBookScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.legends,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return LegendsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.allTimeRecords,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return AllTimeRecordsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.headToHead,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return HeadToHeadScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.h2hMeetings,
        builder: (context, state) {
          final q = state.uri.queryParameters;
          return H2HMeetingsScreen(
            careerId: int.tryParse(q['careerId'] ?? '') ?? 0,
            nationA: int.tryParse(q['a'] ?? '') ?? 0,
            nationB: int.tryParse(q['b'] ?? '') ?? 0,
          );
        },
      ),
      GoRoute(
        path: Routes.nationsCup,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return NationsCupScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.nationsCupDraw,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return NationsCupDrawScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.naturalization,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return NaturalizationScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.managerHistory,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return ManagerHistoryScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.hostDraw,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final worldCup = state.uri.queryParameters['worldCup'] == 'true';
          return HostDrawScreen(careerId: id, worldCup: worldCup);
        },
      ),
      GoRoute(
        path: Routes.friendlies,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return FriendliesScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.cycleRollover,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CycleRolloverScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.results,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return ResultsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.tournaments,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TournamentsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.cup,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CupDetailScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.continental,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final confName = state.uri.queryParameters['conf'] ?? '';
          final conf = Confederation.values
              .where((c) => c.name == confName)
              .firstOrNull;
          if (conf == null) {
            return CupDetailScreen(careerId: id);
          }
          return ContinentalDetailScreen(careerId: id, confederation: conf);
        },
      ),
      GoRoute(
        path: Routes.continentalClash,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return ContinentalClashScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.continentalDraw,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final confName = state.uri.queryParameters['conf'] ?? '';
          final conf = Confederation.values
              .where((c) => c.name == confName)
              .firstOrNull;
          if (conf == null) return HubScreen(careerId: id);
          return ContinentalDrawScreen(
            careerId: id,
            confederation: conf,
            qualifying: state.uri.queryParameters['stage'] == 'qualifying',
          );
        },
      ),
      GoRoute(
        path: Routes.ranking,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return WorldRankingScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.finalsDraw,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return FinalsDrawScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.tournamentKickoff,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          final confName = state.uri.queryParameters['conf'] ?? '';
          final conf = Confederation.values
              .where((c) => c.name == confName)
              .firstOrNull;
          return TournamentKickoffScreen(careerId: id, conf: conf);
        },
      ),
      GoRoute(
        path: Routes.trainingCamp,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TrainingCampScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.intercontinentalPlayoff,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return IntercontinentalPlayoffScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.qualifyingDraw,
        builder: (context, state) {
          final id =
              int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return QualifyingDrawScreen(
            careerId: id,
            worldCup: state.uri.queryParameters['worldCup'] == 'true',
          );
        },
      ),
      GoRoute(
        path: Routes.gallery,
        builder: (context, state) => const StyleGalleryScreen(),
      ),
    ],
  );
});
