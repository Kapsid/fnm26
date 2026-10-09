import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/shared/widgets/app_error_state.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

/// Every screen inside the tablet shell, on a real save, at iPad size: none
/// may report a layout error. Screens without a tablet layout yet are drawn
/// at phone width (PhoneWidthFrame); this proves that holds for every one of
/// them, and keeps holding as later tasks convert them.
void main() {
  testWidgets('every shell route lays out on a tablet', (tester) async {
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
    expect(
      extra.keys.toSet(),
      {for (final r in shell.routes.whereType<GoRoute>()) r.path},
    );

    /// Routes allowed to keep an ambient spinner (reason beside each).
    final stillLoading = <String>{};

    final locations = [
      for (final e in extra.entries) '${e.key}?careerId=$id${e.value}',
      // Squad is the tactics screen on its fourth tab.
      '${Routes.tactics}?careerId=$id&tab=3',
    ];

    await pumpRoute(tester, save, locations.first, size: kTabletSize);
    final router = save.container.read(routerProvider);
    for (final location in locations) {
      router.go(location);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: location);
      // It really rendered: no silent redirect, no endless spinner, no error.
      final path = Uri.parse(location).path;
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
    }

    // Unmount, so no screen's timers outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
