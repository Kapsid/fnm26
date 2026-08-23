import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/onboarding/tour_overlay.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/onboarding/tour_steps.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The tour walks you through screens, which means it has to actually move.
///
/// It called context.go() from inside MaterialApp.router's builder — a context
/// that sits ABOVE the Navigator, with no InheritedGoRouter to find. Nothing
/// navigated: every step stayed on the hub, only the steps whose target
/// happened to be on the hub lit up, and the rest was a caption box counting
/// to ten.
void main() {
  testWidgets('each step takes you to that step\'s screen', (tester) async {
    final visited = <String>[];

    GoRoute page(String path) => GoRoute(
      path: path,
      builder: (context, state) {
        visited.add(path);
        return Scaffold(body: Text('screen $path'));
      },
    );

    final router = GoRouter(
      initialLocation: '${Routes.hub}?careerId=1',
      routes: [
        page(Routes.hub),
        page(Routes.budgetSetup),
        page(Routes.tactics),
        page(Routes.callUps),
        page(Routes.careers),
        page(Routes.tournaments),
      ],
    );
    addTearDown(router.dispose);

    final container = ProviderContainer(
      overrides: [routerProvider.overrideWithValue(router)],
    );
    addTearDown(container.dispose);
    container.read(tourCareerProvider.notifier).state = 1;
    container.read(tourStepProvider.notifier).state = 0;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) =>
              TourOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Walk the whole tour, pressing on.
    for (var step = 0; step < kTourSteps.length - 1; step++) {
      expect(
        router.state.uri.path,
        kTourSteps[step].route,
        reason: 'step ${step + 1} should be on ${kTourSteps[step].route}',
      );
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    // The last one.
    expect(router.state.uri.path, kTourSteps.last.route);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Finishing lands back on the hub.
    expect(router.state.uri.path, Routes.hub);
    expect(container.read(tourStepProvider), isNull);

    // And it really did move around, rather than sitting on one screen.
    expect(visited.toSet().length, greaterThan(3), reason: 'visited $visited');
  });

  testWidgets('the career is carried in the query string', (tester) async {
    final router = GoRouter(
      initialLocation: '${Routes.hub}?careerId=7',
      routes: [
        GoRoute(
          path: Routes.hub,
          builder: (context, state) => const Scaffold(body: Text('hub')),
        ),
        GoRoute(
          path: Routes.budgetSetup,
          builder: (context, state) => const Scaffold(body: Text('budget')),
        ),
      ],
    );
    addTearDown(router.dispose);

    final container = ProviderContainer(
      overrides: [routerProvider.overrideWithValue(router)],
    );
    addTearDown(container.dispose);
    container.read(tourCareerProvider.notifier).state = 7;
    // The first budget step.
    container.read(tourStepProvider.notifier).state = kTourSteps.indexWhere(
      (s) => s.route == Routes.budgetSetup,
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) =>
              TourOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(router.state.uri.queryParameters['careerId'], '7');
  });
}
