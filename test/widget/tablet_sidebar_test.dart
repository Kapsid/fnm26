import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('highlights the current destination and navigates on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1194, 834);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/hub?careerId=3',
      routes: [
        for (final p in ['/hub', '/messages', '/settings'])
          GoRoute(
            path: p,
            builder: (context, state) => Scaffold(
              body: Row(
                children: [
                  TabletSidebar(careerId: 3, location: state.uri),
                  Expanded(child: Text('at ${state.uri}')),
                ],
              ),
            ),
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
    await tester.pumpAndSettle();

    // Section headings are drawn in capitals.
    expect(find.text('COMPETITIONS'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sidebar.hub.active')),
      findsOneWidget,
    );

    await tester.tap(find.text('Inbox'));
    await tester.pumpAndSettle();
    expect(find.text('at /messages?careerId=3'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sidebar.inbox.active')),
      findsOneWidget,
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.textContaining('at /settings'), findsOneWidget);
  });
}
