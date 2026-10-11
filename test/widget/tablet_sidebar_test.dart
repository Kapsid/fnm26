import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

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
        // One shell, as in the app: the sidebar persists across routes (it
        // owns a GlobalKey, the tour's Squad target, so two at once would
        // clash).
        ShellRoute(
          builder: (context, state, child) => Scaffold(
            body: Row(
              children: [
                TabletSidebar(careerId: 3, location: state.uri),
                Expanded(child: child),
              ],
            ),
          ),
          routes: [
            for (final p in ['/hub', '/messages', '/settings'])
              GoRoute(
                path: p,
                builder: (context, state) => Text('at ${state.uri}'),
              ),
          ],
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

  testWidgets(
    'Main menu, at the bottom by Settings, leaves for the main menu',
    (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.hub}?careerId=${save.careerId}',
        size: kTabletSize,
      );
      final item = find.byKey(TabletSidebar.mainMenuKey);
      expect(item, findsOneWidget);
      expect(
        find.descendant(of: item, matching: find.text(enL.sideMainMenu)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: item, matching: find.byIcon(Icons.home_outlined)),
        findsOneWidget,
      );
      // Below the scrolling destinations, beside Settings.
      final settings = tester.getRect(find.text(enL.homeSettings));
      expect(tester.getRect(item).top, greaterThanOrEqualTo(settings.bottom));

      await tester.tap(item);
      await settle(tester);
      final router = save.container.read(routerProvider);
      expect(router.routeInformationProvider.value.uri.path, Routes.home);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(TabletShell), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
