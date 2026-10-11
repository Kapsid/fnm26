import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:go_router/go_router.dart';

/// Builds a router shaped like the tablet one (in-save pages inside a
/// ShellRoute with its own navigator, full-screen pages on top) and checks
/// that sheets and pushes behave inside it.
void main() {
  final overrides = [
    hubDataProvider(1).overrideWith((ref) async => null),
    unreadMessagesProvider(1).overrideWith((ref) async => 0),
    nextEventProvider(1).overrideWith(
      (ref) async => const HubEvent(
        kind: HubEventKind.advance,
        label: 'Continue',
        icon: Icons.play_arrow_rounded,
      ),
    ),
  ];

  Future<void> pumpRouter(
    WidgetTester tester, {
    required ValueSetter<int?> onPicked,
    // true reproduces the old outer-context pop (must fail the test).
    bool popWithOuterContext = false,
  }) async {
    tester.view.physicalSize = const Size(1194, 834);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/tactics?careerId=1',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              TabletShell(location: state.uri, child: child),
          routes: [
            GoRoute(
              path: '/tactics',
              builder: (context, state) => Scaffold(
                body: Column(
                  children: [
                    const Text('tactics page'),
                    TextButton(
                      onPressed: () async {
                        final v = await showAdaptiveSheet<int>(
                          context: context,
                          builder: (sheetContext) => ListTile(
                            title: const Text('pick seven'),
                            onTap: () => Navigator.of(
                              popWithOuterContext ? context : sheetContext,
                            ).pop(7),
                          ),
                        );
                        onPicked(v);
                      },
                      child: const Text('open sheet'),
                    ),
                    TextButton(
                      onPressed: () => context.push('/full'),
                      child: const Text('open full'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/full',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.pop(),
              child: const Text('full page'),
            ),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a sheet pops with its own context: value returns, page stays', (
    tester,
  ) async {
    int? picked;
    await pumpRouter(tester, onPicked: (v) => picked = v);
    await tester.tap(find.text('open sheet'));
    await tester.pumpAndSettle();
    expect(find.text('pick seven'), findsOneWidget);

    await tester.tap(find.text('pick seven'));
    await tester.pumpAndSettle();
    expect(find.text('pick seven'), findsNothing);
    expect(picked, 7);
    expect(find.text('tactics page'), findsOneWidget);
  });

  testWidgets('a top-level route pushed from the shell pops back to it', (
    tester,
  ) async {
    await pumpRouter(tester, onPicked: (_) {});
    await tester.tap(find.text('open full'));
    await tester.pumpAndSettle();
    expect(find.text('full page'), findsOneWidget);

    await tester.tap(find.text('full page'));
    await tester.pumpAndSettle();
    expect(find.text('full page'), findsNothing);
    expect(find.text('tactics page'), findsOneWidget);
  });
}
