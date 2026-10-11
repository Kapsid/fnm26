import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

Future<GoRouter> _pump(
  WidgetTester tester,
  SeededSave save,
  Widget Function(BuildContext context) home,
) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(body: Builder(builder: home)),
      ),
      GoRoute(
        path: '/nation',
        builder: (_, state) =>
            Text('nation page ${state.uri.queryParameters['nationId']}'),
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
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await settle(tester);
  return router;
}

void main() {
  testWidgets('NationView shows the nation, scrolling by itself', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 500,
        child: NationView(careerId: save.careerId, nationId: me.id),
      ),
    );
    expect(find.text(me.name), findsOneWidget);
    expect(find.text(enL.nationsHonours), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a nation in the pane, with a way to its full page', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    final router = await _pump(
      tester,
      save,
      (_) => SizedBox(
        width: 380,
        child: DetailPaneHost(
          careerId: save.careerId,
          target: NationTarget(other.id),
        ),
      ),
    );
    expect(find.byType(NationView), findsOneWidget);
    expect(find.text(other.name), findsOneWidget);
    expect(find.text(enL.nationsVitrineTitle.toUpperCase()), findsOneWidget);
    await tester.tap(find.byKey(DetailPaneHost.fullProfileKey));
    await settle(tester);
    expect(find.text('nation page ${other.id}'), findsOneWidget);
    expect(router.state.uri.queryParameters['careerId'], '${save.careerId}');
  });

  testWidgets('openNation fills the pane when there is one', (tester) async {
    final save = await seedSave(tester);
    final pane = DetailPaneController();
    addTearDown(pane.dispose);
    await _pump(
      tester,
      save,
      (_) => DetailPaneScope(
        controller: pane,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                openNation(context, careerId: save.careerId, nationId: 7),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    expect(pane.value, const NationTarget(7));
  });

  testWidgets('and routes to the vitrine when there is none', (tester) async {
    final save = await seedSave(tester);
    await _pump(
      tester,
      save,
      (context) => TextButton(
        onPressed: () =>
            openNation(context, careerId: save.careerId, nationId: 7),
        child: const Text('open'),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    expect(find.text('nation page 7'), findsOneWidget);
  });

  test('targets compare by id', () {
    expect(const NationTarget(3), const NationTarget(3));
    expect(const NationTarget(3) == const PlayerTarget(3), isFalse);
  });
}
