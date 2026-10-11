import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, String path, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, '$path?careerId=${save.careerId}', size: size);
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

/// Scrolls every scrollable on screen from top to end a step at a time,
/// failing on any exception a newly built row throws. Returns which of
/// [texts] were drawn along the way.
Future<Set<String>> _scrollEverything(
  WidgetTester tester,
  List<String> texts,
) async {
  final seen = <String>{};
  void look() {
    for (final t in texts) {
      if (find.text(t).evaluate().isNotEmpty) seen.add(t);
    }
  }

  look();
  final scrollables = tester
      .stateList<ScrollableState>(find.byType(Scrollable))
      .toList();
  for (final scrollable in scrollables) {
    final position = scrollable.position;
    if (position.axis != Axis.vertical) continue;
    while (position.pixels < position.maxScrollExtent) {
      position.jumpTo(
        (position.pixels + 200).clamp(0, position.maxScrollExtent),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      look();
    }
  }
  return seen;
}

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

  // A long career (three titles won several times, eight tournaments with
  // long names, two nations) on every page that draws the summary.
  for (final size in kTabletSizes) {
    for (final path in [Routes.careerSummary, Routes.careers, Routes.saves]) {
      testWidgets('a long career fits $path, $size', (tester) async {
        final save = await seedSave(
          tester,
          formFactor: FormFactor.tablet,
          overrides: [fakeCareerSummaryOverride()],
        );
        await pumpRoute(
          tester,
          save,
          path == Routes.saves ? path : '$path?careerId=${save.careerId}',
          size: size,
        );
        expect(tester.takeException(), isNull);
        // The fake is what is drawn, not the fresh save's empty history.
        expect(find.text(enL.careerNoTournamentsYet), findsNothing);
        // The lists are lazy: scroll every one to its end, so each row of
        // the long career is laid out at least once.
        final seen = await _scrollEverything(tester, const [
          'Third place',
          'Group stage',
          'Intercontinental Champions Challenge Trophy 2050',
        ]);
        expect(seen, hasLength(3), reason: 'only $seen were ever drawn');
        await tester.pumpWidget(const SizedBox());
      });
    }
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
