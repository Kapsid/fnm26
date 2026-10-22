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
/// (PhoneWidthFrame). The full-screen routes are swept in
/// tablet_full_screen_sweep_test.dart, so the two run in parallel.
void main() {
  for (final size in kTabletSizes) {
    testWidgets('every shell route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepShell(tester, size);
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
          careerId: save.career.id,
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
    Routes.injuryCover: '',
    Routes.schedule: '',
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
  // Stage 6 converted the last in-shell screen, and
  // shell_frame_transition_test (a tablet page leaving for a phone-framed
  // one) was retired with it. ShellPhoneFrame stays as the fallback for a
  // future route, but none may ship without a tablet layout: that is what
  // keeps the retired test's bug unreachable.
  expect(
    [
      for (final p in extra.keys)
        if (!tabletReadyPaths.contains(p)) p,
    ],
    isEmpty,
    reason: 'an in-shell route with no tablet layout',
  );

  /// Tablet layouts that legitimately keep an AppBar (reason beside each).
  final appBarAllowed = <String>{};

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
    // A tablet layout carries its title and back arrow in the tablet header
    // (TabletPage); a Material app bar would mean the phone layout was drawn.
    expect(
      find.byType(AppBar),
      appBarAllowed.contains(path) ? findsWidgets : findsNothing,
      reason: 'an AppBar on a tablet layout: $location',
    );
  }

  // Unmount, so no screen's timers outlive the test.
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}
