import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The budget screen replaces the stack, so with no leading control and no
/// swipe back a manager who opened it to look at the numbers could not leave
/// without spending the money.
void main() {
  testWidgets('there is a way out that does not spend the budget', (
    tester,
  ) async {
    var wentBack = false;
    final router = GoRouter(
      initialLocation: '/budget',
      routes: [
        GoRoute(
          path: '/budget',
          builder: (context, state) => const BudgetSetupScreen(careerId: 1),
        ),
        GoRoute(
          path: '/hub',
          builder: (context, state) {
            wentBack = true;
            return const Scaffold(body: Text('hub'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    final back = find.byIcon(Icons.arrow_back);
    expect(back, findsOneWidget, reason: 'the screen must not be a trap');

    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(wentBack, isTrue, reason: 'back should return to the hub');
  });
}
