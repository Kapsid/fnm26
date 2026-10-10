import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, String path, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, '$path?careerId=${save.careerId}', size: size);
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the summary: the record left, the tournaments right, $size', (
      tester,
    ) async {
      await _open(tester, Routes.careerSummary, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CareerSummaryScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // The cabinet heading is in the left column; the history is a panel.
      final cabinet = tester.getRect(find.text(enL.careerTrophyCabinet));
      final history = tester.getRect(
        find.text(enL.careerTournamentHistory.toUpperCase()),
      );
      expect(history.left, greaterThan(cabinet.right));
      expect(find.text(enL.careerNoTournamentsYet), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets("the manager's career: the totals left, the cycles right, "
        '$size', (tester) async {
      await _open(tester, Routes.managerHistory, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ManagerHistoryScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final cabinet = tester.getRect(find.text(enL.careerTrophyCabinet));
      final cycles = tester.getRect(find.text(enL.careerCycleByCycle));
      expect(cycles.left, greaterThan(cabinet.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('both go back to the Career page', (tester) async {
    final save = await _open(tester, Routes.careerSummary, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.careers);
    save.container
        .read(routerProvider)
        .go('${Routes.managerHistory}?careerId=${save.careerId}');
    await settle(tester);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.careers);
    await tester.pumpWidget(const SizedBox());
  });
}
