import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/app_error_state.dart';

import '../helpers/seeded_save.dart';

/// Every full-screen route, on a real save, at every iPad size: none may
/// report a layout error, land somewhere else, sit on a spinner or show an
/// error. Routes not yet converted (tabletReadyPaths) are drawn through
/// FullScreenPhoneFrame; converted ones never are.
void main() {
  for (final size in kTabletSizes) {
    testWidgets('every full-screen route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepFullScreen(tester, size);
    });
  }
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
    Routes.campaigns: '',
    Routes.campaignBrief: '?id=transplant',
    Routes.campaignVerdict: '?careerId=$id',
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
  // After Stage 6 only the dev-only style gallery is still phone-framed.
  expect(
    Routes.fullScreen.difference(tabletReadyPaths),
    {Routes.gallery},
    reason: 'a full-screen route with no tablet layout',
  );

  /// Routes allowed to keep a spinner as their content (reason beside each).
  final stillLoading = <String>{
    // The style gallery shows a loading button on purpose.
    Routes.gallery,
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
    if (!stillLoading.contains(e.key)) {
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
