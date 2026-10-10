import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:go_router/go_router.dart';

import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('nothing picked: the placeholder', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: DetailPaneHost(careerId: 1, target: null)),
    );
    expect(find.text(enL.panePickPlayer), findsOneWidget);
  });

  testWidgets('a player: his card, and a way to his full page', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: SizedBox(
              width: 340,
              child: DetailPaneHost(
                careerId: save.careerId,
                target: PlayerTarget(playerId),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/player',
          builder: (_, state) =>
              Text('player page ${state.uri.queryParameters['playerId']}'),
        ),
      ],
    );
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await settle(tester);
    expect(find.byType(PlayerView), findsOneWidget);
    expect(find.text(name), findsOneWidget);
    expect(find.text(enL.playerTitle.toUpperCase()), findsOneWidget);

    await tester.tap(find.byKey(DetailPaneHost.fullProfileKey));
    await tester.pumpAndSettle();
    expect(find.text('player page $playerId'), findsOneWidget);
  });

  group('openPlayer', () {
    Future<GoRouter> pump(WidgetTester tester, Widget page) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(body: page),
          ),
          GoRoute(
            path: '/player',
            builder: (_, state) => Text('routed ${state.uri}'),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      return router;
    }

    testWidgets('with a pane above, the pane shows him', (tester) async {
      final pane = DetailPaneController();
      addTearDown(pane.dispose);
      await pump(
        tester,
        DetailPaneScope(
          controller: pane,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => openPlayer(context, careerId: 1, playerId: 7),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(pane.value, const PlayerTarget(7));
      expect(find.textContaining('routed'), findsNothing);
    });

    testWidgets('without one, his page opens as before', (tester) async {
      await pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => openPlayer(context, careerId: 1, playerId: 7),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('routed /player?careerId=1&playerId=7'), findsOneWidget);
    });
  });

  // Stage 3 carry-over. One pane, its target switched from a player to a
  // nation (a ranking row after a squad row): the player's card goes, the
  // nation's record comes, under the nation's heading.
  testWidgets('a nation replaces a player in the same pane', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
    });
    final target = ValueNotifier<DetailTarget?>(PlayerTarget(playerId));
    addTearDown(target.dispose);
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 360,
              child: ValueListenableBuilder<DetailTarget?>(
                valueListenable: target,
                builder: (_, t, _) =>
                    DetailPaneHost(careerId: save.careerId, target: t),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(find.byType(PlayerView), findsOneWidget);
    target.value = NationTarget(save.nationId);
    await settle(tester);
    expect(find.byType(PlayerView), findsNothing);
    expect(
      tester.widget<NationView>(find.byType(NationView)).nationId,
      save.nationId,
    );
    expect(find.text(enL.nationsVitrineTitle.toUpperCase()), findsOneWidget);
    target.value = null;
    await settle(tester);
    expect(find.text(enL.panePickPlayer), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
