import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/dev/style_gallery_screen.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/features/results/results_screen.dart';
import 'package:fnm/features/tactics/tactics_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';
import 'package:go_router/go_router.dart';

/// Named route paths, centralised so navigation call-sites never hard-code
/// string literals.
abstract final class Routes {
  static const home = '/';

  /// National-team selection.
  static const nations = '/nations';

  /// Save-game list.
  static const saves = '/saves';

  /// New-game flow (manager name). Expects `?nationId=`.
  static const newGame = '/new-game';

  /// In-game national hub. Expects `?careerId=`.
  static const hub = '/hub';

  /// Squad & tactics. Expects `?careerId=`.
  static const tactics = '/tactics';

  /// Play the next match. Expects `?careerId=`.
  static const match = '/match';

  /// All results & fixtures. Expects `?careerId=`.
  static const results = '/results';

  /// Tournaments overview. Expects `?careerId=`.
  static const tournaments = '/tournaments';

  /// World Championship detail. Expects `?careerId=`.
  static const cup = '/cup';

  /// World ranking. Expects `?careerId=`.
  static const ranking = '/ranking';

  /// Development-only design-system showcase.
  static const gallery = '/gallery';
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
        path: Routes.newGame,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['nationId'] ?? '',
              ) ??
              0;
          return NewGameScreen(nationId: id);
        },
      ),
      GoRoute(
        path: Routes.hub,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return HubScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.tactics,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TacticsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.match,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return MatchScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.results,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return ResultsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.tournaments,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return TournamentsScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.cup,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return CupDetailScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.ranking,
        builder: (context, state) {
          final id = int.tryParse(
                state.uri.queryParameters['careerId'] ?? '',
              ) ??
              0;
          return WorldRankingScreen(careerId: id);
        },
      ),
      GoRoute(
        path: Routes.gallery,
        builder: (context, state) => const StyleGalleryScreen(),
      ),
    ],
  );
});
