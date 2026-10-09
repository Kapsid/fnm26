import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/app_error_state.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

/// Every route, on a real save, at every iPad size: none may report a layout
/// error, land somewhere else, sit on a spinner or show an error. In the
/// shell, screens without a tablet layout yet are drawn at phone width
/// (PhoneWidthFrame). Full screen, they are drawn through FullScreenPhoneFrame,
/// and a converted one (in tabletReadyPaths) never is.
void main() {
  for (final size in kTabletSizes) {
    testWidgets('every shell route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepShell(tester, size);
    });
    testWidgets('every full-screen route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepFullScreen(tester, size);
    });
  }
}

Future<void> _sweepShell(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  final id = save.careerId;
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
  final me = save.nations.firstWhere((n) => n.id == save.nationId);
  final other = save.nations.firstWhere((n) => n.id != save.nationId);

  /// Each in-shell path, and the extra query it needs to show something.
  final extra = <String, String>{
    Routes.hub: '',
    Routes.manager: '',
    Routes.tactics: '',
    Routes.callUps: '',
    Routes.matchPreview: '',
    Routes.roundResults: '',
    Routes.player: '&playerId=$playerId',
    Routes.teamStats: '',
    Routes.nationVitrine: '&nationId=${other.id}',
    Routes.careers: '',
    Routes.careerSummary: '',
    Routes.achievements: '',
    Routes.challenges: '',
    Routes.messages: '',
    Routes.finances: '',
    Routes.youth: '',
    Routes.y: '',
    Routes.boardObjectives: '',
    Routes.budgetSetup: '',
    Routes.records: '',
    Routes.legends: '',
    Routes.allTimeRecords: '',
    Routes.headToHead: '',
    Routes.h2hMeetings: '&a=${me.id}&b=${other.id}',
    Routes.nationsCup: '',
    Routes.naturalization: '',
    Routes.managerHistory: '',
    Routes.friendlies: '',
    Routes.results: '',
    Routes.tournaments: '',
    Routes.cup: '',
    Routes.continental: '&conf=${me.confederation.name}',
    Routes.continentalClash: '',
    Routes.ranking: '',
    Routes.trainingCamp: '',
    Routes.intercontinentalPlayoff: '',
  };

  // The list above must be the shell's routes, all of them: a route added
  // later without a line here fails this, rather than going unswept.
  final shell = save.container
      .read(routerProvider)
      .configuration
      .routes
      .whereType<ShellRoute>()
      .single;
  expect(extra.keys.toSet(), {
    for (final r in shell.routes.whereType<GoRoute>()) r.path,
  });

  /// Routes allowed to keep an ambient spinner (reason beside each).
  final stillLoading = <String>{};

  final locations = [
    for (final e in extra.entries) '${e.key}?careerId=$id${e.value}',
    // Squad is the tactics screen on its fourth tab.
    '${Routes.tactics}?careerId=$id&tab=3',
  ];

  await pumpRoute(tester, save, locations.first, size: size);
  final router = save.container.read(routerProvider);
  for (final location in locations) {
    final path = Uri.parse(location).path;
    router.go(location);
    await settle(tester, allowSpinner: stillLoading.contains(path));
    expect(tester.takeException(), isNull, reason: location);
    // It really rendered: no silent redirect, no endless spinner, no error.
    expect(
      router.routeInformationProvider.value.uri.path,
      path,
      reason: 'redirected: $location',
    );
    if (!stillLoading.contains(path)) {
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'stuck loading: $location',
      );
    }
    expect(
      find.byType(AppErrorState),
      findsNothing,
      reason: 'error state: $location',
    );
    // A converted screen gets the whole content area; any other is framed.
    expect(
      find.byType(PhoneWidthFrame),
      tabletReadyPaths.contains(path) ? findsNothing : findsOneWidget,
      reason: 'frame: $location',
    );
  }

  // Unmount, so no screen's timers outlive the test.
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

Future<void> _sweepFullScreen(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  final id = save.careerId;
  final me = save.nations.firstWhere((n) => n.id == save.nationId);

  /// Each full-screen path and the query it needs. The draws that write to
  /// the save (a watched qualifying draw) come last.
  final locations = <String, String>{
    Routes.home: '',
    Routes.nations: '',
    Routes.saves: '',
    Routes.settings: '',
    Routes.diagnostics: '',
    Routes.startFromBottom: '',
    Routes.newGame: '?nationId=${me.id}',
    Routes.gallery: '',
    Routes.hostDraw: '?careerId=$id',
    Routes.finalsDraw: '?careerId=$id',
    Routes.continentalDraw: '?careerId=$id&conf=${me.confederation.name}',
    Routes.nationsCupDraw: '?careerId=$id',
    Routes.tournamentKickoff: '?careerId=$id',
    Routes.cycleRollover: '?careerId=$id',
    Routes.qualifyingDraw: '?careerId=$id',
  };

  /// Full-screen routes swept elsewhere (reason beside each).
  const elsewhere = {
    // Needs its pre-simulated preview warmed first: match_tablet_test.
    Routes.match,
  };

  // Every full-screen route is either swept here or named above.
  expect({...locations.keys, ...elsewhere}, Routes.fullScreen);

  /// Routes allowed to keep a spinner as their content (reason beside each).
  final stillLoading = <String>{
    // The style gallery shows a loading button on purpose.
    Routes.gallery,
    // Loads only after ~0.5 s of FAKE time, which settle's zero-length pumps
    // never advance; it clears on settle's final 500 ms pump (checked below).
    Routes.hostDraw,
  };

  await pumpRoute(tester, save, '${Routes.hub}?careerId=$id', size: size);
  final router = save.container.read(routerProvider);
  for (final e in locations.entries) {
    final location = '${e.key}${e.value}';
    router.go(location);
    await settle(tester, allowSpinner: stillLoading.contains(e.key));
    expect(tester.takeException(), isNull, reason: location);
    expect(
      router.routeInformationProvider.value.uri.path,
      e.key,
      reason: 'redirected: $location',
    );
    expect(
      find.byType(AppErrorState),
      findsNothing,
      reason: 'error state: $location',
    );
    if (e.key != Routes.gallery) {
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'stuck loading: $location',
      );
    }
    expect(
      find.byType(FullScreenPhoneFrame),
      tabletReadyPaths.contains(e.key) ? findsNothing : findsOneWidget,
      reason: 'frame: $location',
    );
  }

  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}
