import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

Future<GoRouter> _pump(
  WidgetTester tester,
  SeededSave save,
  Widget Function(BuildContext context) home, {
  Size size = kTabletSize,
}) async {
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
      GoRoute(path: Routes.ranking, builder: (_, _) => const Text('ranking')),
      GoRoute(
        path: Routes.h2hMeetings,
        builder: (_, _) => const Text('meetings'),
      ),
      GoRoute(path: Routes.results, builder: (_, _) => const Text('results')),
    ],
  );
  tester.view.physicalSize = size;
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

/// The "now" read with a record against the manager and a next match, so
/// the page has something in every block without playing a match first.
NationNow _withRecord(int careerId, int own, int other) {
  Fixture fx({String? round, bool played = false}) => Fixture(
    id: 900 + (played ? 1 : 0),
    careerId: careerId,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 6, 1),
    homeNationId: own,
    awayNationId: other,
    homeScore: played ? 2 : null,
    awayScore: played ? 1 : null,
    round: round,
    played: played,
  );
  return NationNow(
    rank: 12,
    points: 1500,
    movement: 2,
    baseline: null,
    confederation: Confederation.europe,
    form: [
      (
        fixture: fx(played: true),
        opponentId: own,
        goalsFor: 1,
        goalsAgainst: 2,
        outcome: 'L',
      ),
    ],
    next: fx(round: 'QF'),
    upcoming: [fx(round: 'QF')],
    overall: 70,
    topPlayers: const [],
    againstYou: (
      record: (
        played: 2,
        winsA: 1,
        draws: 1,
        winsB: 0,
        goalsA: 3,
        goalsB: 2,
        biggestWinMarginA: 1,
        biggestWinMarginB: 0,
      ),
      last: fx(played: true),
    ),
    isPlayerNation: own == other,
  );
}

Widget _view(SeededSave save, int nationId) => SizedBox(
  height: 900,
  child: NationView(careerId: save.careerId, nationId: nationId),
);

void main() {
  testWidgets('NationView shows the nation with its tabs, scrolling by '
      'itself', (tester) async {
    final save = await seedSave(tester);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pump(tester, save, (_) => _view(save, me.id));
    expect(find.text(me.name.toUpperCase()), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.headerKey), findsOneWidget);
    for (final k in NationVitrineScreen.tabKeys) {
      expect(find.byKey(k), findsOneWidget);
    }
    expect(find.byKey(NationVitrineScreen.nextKey), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.medalsKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the ranking opens the world ranking', (tester) async {
    final save = await seedSave(tester);
    final router = await _pump(
      tester,
      save,
      (_) => _view(save, save.nationId),
    );
    await tester.tap(find.byKey(NationVitrineScreen.rankingKey));
    await settle(tester);
    expect(router.state.uri.path, Routes.ranking);
  });

  testWidgets('against-you links to the meetings', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        nationNowProvider.overrideWith(
          (ref, arg) async =>
              _withRecord(arg.careerId, seededNationId, arg.nationId),
        ),
      ],
    );
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    final router = await _pump(tester, save, (_) => _view(save, other.id));
    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[2]));
    await settle(tester);
    expect(find.byKey(NationVitrineScreen.againstYouKey), findsOneWidget);
    expect(find.text(enL.nationNowRecord(1, 1, 0)), findsOneWidget);
    await tester.tap(find.text(enL.nationAllMeetings(2)));
    await settle(tester);
    expect(router.state.uri.path, Routes.h2hMeetings);
    expect(router.state.uri.queryParameters['a'], '${save.nationId}');
    expect(router.state.uri.queryParameters['b'], '${other.id}');
  });

  testWidgets('the overview names the next match: competition and opponent', (
    tester,
  ) async {
    late Fixture next;
    final save = await seedSave(
      tester,
      overrides: [
        nationNowProvider.overrideWith((ref, arg) async {
          final now = _withRecord(arg.careerId, seededNationId, arg.nationId);
          next = now.next!;
          return now;
        }),
      ],
    );
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    await _pump(tester, save, (_) => _view(save, other.id));
    expect(find.text(MatchStage.label(enL, next)), findsOneWidget);
    expect(find.text('70'), findsWidgets);
    expect(find.text('#12'), findsOneWidget);
  });

  testWidgets('own page hides against-you, even with a record to show', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [
        nationNowProvider.overrideWith(
          (ref, arg) async =>
              _withRecord(arg.careerId, seededNationId, arg.nationId),
        ),
      ],
    );
    await _pump(tester, save, (_) => _view(save, save.nationId));
    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[2]));
    await settle(tester);
    expect(find.byKey(NationVitrineScreen.resultsKey), findsOneWidget);
    expect(find.byKey(NationVitrineScreen.againstYouKey), findsNothing);
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
    expect(find.text(other.name.toUpperCase()), findsOneWidget);
    expect(find.text(enL.nationsVitrineTitle.toUpperCase()), findsOneWidget);
    expect(tester.takeException(), isNull);
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
