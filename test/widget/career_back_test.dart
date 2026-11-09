import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Team records is a My Career page: opened from the Career menu (with
/// `go`, so there is nothing to pop), its back arrow returns to that menu,
/// not to the hub.
void main() {
  testWidgets('Team records goes back to My Career, not the hub', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '${Routes.teamStats}?careerId=1',
      routes: [
        GoRoute(
          path: Routes.teamStats,
          builder: (_, _) => const TeamStatsScreen(careerId: 1),
        ),
        GoRoute(
          path: Routes.careers,
          builder: (_, _) => const Scaffold(body: Text('CAREER MENU')),
        ),
        GoRoute(
          path: Routes.hub,
          builder: (_, _) => const Scaffold(body: Text('HUB')),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          teamStatsProvider.overrideWith((ref, id) async => null),
        ],
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('CAREER MENU'), findsOneWidget);
    expect(find.text('HUB'), findsNothing);
  });
}
