import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/nations/nation_now_card.dart';
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
      GoRoute(path: Routes.ranking, builder: (_, _) => const Text('ranking')),
      GoRoute(
        path: Routes.h2hMeetings,
        builder: (_, _) => const Text('meetings'),
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

/// The "now" read with a record against the manager, so the link can be tapped
/// without playing a match first.
NationNow _withRecord(NationNow base, int own, int other) => NationNow(
  rank: 12,
  points: 1500,
  movement: 2,
  baseline: base.baseline,
  confederation: base.confederation,
  form: [],
  next: null,
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
    last: Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2030, 6, 1),
      homeNationId: own,
      awayNationId: other,
      homeScore: 2,
      awayScore: 1,
      played: true,
    ),
  ),
  isPlayerNation: false,
);

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
        height: 1400,
        child: NationView(careerId: save.careerId, nationId: me.id),
      ),
    );
    expect(find.text(me.name), findsOneWidget);
    expect(find.text(enL.nationsHonours), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('NationView leads with the now block', (tester) async {
    final save = await seedSave(tester);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 900,
        child: NationView(careerId: save.careerId, nationId: me.id),
      ),
    );
    final now = tester.getTopLeft(find.byKey(NationNowCard.rankingKey)).dy;
    final honours = tester.getTopLeft(find.text(enL.nationsHonours)).dy;
    expect(now, lessThan(honours));
    expect(find.byKey(NationNowCard.formKey), findsOneWidget);
    expect(find.byKey(NationNowCard.nextKey), findsOneWidget);
    expect(find.byKey(NationNowCard.squadKey), findsOneWidget);
  });

  testWidgets('tapping the ranking opens the world ranking', (tester) async {
    final save = await seedSave(tester);
    final router = await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 900,
        child: NationView(careerId: save.careerId, nationId: save.nationId),
      ),
    );
    await tester.tap(find.byKey(NationNowCard.rankingKey));
    await settle(tester);
    expect(router.state.uri.path, Routes.ranking);
  });

  testWidgets('against-you links to the meetings', (tester) async {
    const base = NationNow(
      rank: null,
      points: null,
      movement: 0,
      baseline: null,
      confederation: Confederation.europe,
      form: [],
      next: null,
      overall: null,
      topPlayers: [],
      againstYou: null,
      isPlayerNation: false,
    );
    final save = await seedSave(
      tester,
      overrides: [
        nationNowProvider.overrideWith(
          (ref, arg) async => _withRecord(base, 1, arg.nationId),
        ),
      ],
    );
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    final router = await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 900,
        child: NationView(careerId: save.careerId, nationId: other.id),
      ),
    );
    await tester.tap(find.byKey(NationNowCard.againstYouKey));
    await settle(tester);
    expect(router.state.uri.path, Routes.h2hMeetings);
    expect(router.state.uri.queryParameters['a'], '${save.nationId}');
    expect(router.state.uri.queryParameters['b'], '${other.id}');
  });

  testWidgets('the now block names confederation, form, competition, overall', (
    tester,
  ) async {
    late Fixture next;
    final save = await seedSave(
      tester,
      overrides: [
        nationNowProvider.overrideWith((ref, arg) async {
          final opp = arg.nationId == 1 ? 2 : 1;
          Fixture fx({String? round, bool played = false}) => Fixture(
            id: 1,
            careerId: arg.careerId,
            competitionId: 1,
            matchday: 1,
            date: DateTime(2030, 6, 1),
            homeNationId: arg.nationId,
            awayNationId: opp,
            homeScore: played ? 3 : null,
            awayScore: played ? 1 : null,
            round: round,
            played: played,
          );
          next = fx(round: 'QF');
          return NationNow(
            rank: 4,
            points: 1700,
            movement: 0,
            baseline: null,
            confederation: Confederation.europe,
            form: [
              (
                fixture: fx(played: true),
                opponentId: opp,
                goalsFor: 3,
                goalsAgainst: 1,
                outcome: 'W',
              ),
            ],
            next: next,
            overall: 83,
            topPlayers: [],
            againstYou: null,
            isPlayerNation: false,
          );
        }),
      ],
    );
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 900,
        child: NationView(careerId: save.careerId, nationId: other.id),
      ),
    );
    expect(
      find.text(confederationLabel(enL, Confederation.europe)),
      findsWidgets,
    );
    expect(find.textContaining('3-1'), findsOneWidget);
    expect(find.text(MatchStage.label(enL, next)), findsOneWidget);
    expect(find.text(enL.nationNowOverall(83)), findsOneWidget);
  });

  testWidgets('own page hides against-you', (tester) async {
    final save = await seedSave(tester);
    await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 900,
        child: NationView(careerId: save.careerId, nationId: save.nationId),
      ),
    );
    expect(find.byKey(NationNowCard.againstYouKey), findsNothing);
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
