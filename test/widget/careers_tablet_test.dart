import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/careers_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.careers}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the menu beside the career summary, $size', (tester) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CareersScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      // The page is a sidebar destination: nothing to go back to.
      expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
      // The tour's Career step still finds its line (Review Focus 7).
      expect(find.byKey(TourKeys.careerHistory), findsOneWidget);
      final summary = find.byType(CareerSummaryView);
      expect(
        tester.widget<CareerSummaryView>(summary).careerId,
        save.careerId,
      );
      expect(
        tester.getRect(find.byKey(TourKeys.careerHistory)).right,
        lessThan(tester.getRect(summary).left),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("every line goes where the phone's does (Review Focus 7)", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    final lines = {
      enL.careerManagerCareer: Routes.managerHistory,
      enL.careerSummaryTitle: Routes.careerSummary,
      enL.careerAchievements: Routes.achievements,
      enL.careerChallenges: Routes.challenges,
      enL.careerTeamRecords: Routes.teamStats,
      enL.careerMyMatches: Routes.results,
    };
    for (final e in lines.entries) {
      router.go('${Routes.careers}?careerId=${save.careerId}');
      await settle(tester);
      await tester.tap(
        find
            .descendant(
              of: find.byKey(CareersScreen.tabletLayoutKey),
              matching: find.text(e.key),
            )
            .first,
      );
      await settle(tester);
      expect(_path(save), e.value, reason: e.key);
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the summary's link opens its full page", (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.panelViewAll));
    await settle(tester);
    expect(_path(save), Routes.careerSummary);
    await tester.pumpWidget(const SizedBox());
  });
}
