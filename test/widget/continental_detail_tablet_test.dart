import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('qualifying groups in columns, the cup named, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.continental}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(ContinentalDetailScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(
        tester
            .widget<ContinentalDetailView>(find.byType(ContinentalDetailView))
            .confederation,
        Confederation.europe,
      );

      late ContinentalData data;
      await tester.runAsync(() async {
        final sub = save.container.listen(
          continentalDetailProvider((
            careerId: save.careerId,
            confederation: Confederation.europe,
          )).future,
          (_, _) {},
        );
        data = (await sub.read())!;
        sub.close();
      });
      // The manager's group first, the next beside it.
      final groups = data.qualifyingGroups;
      final mine = groups.firstWhere(
        (g) => g.standings.any((s) => s.nationId == save.nationId),
      );
      final next = groups.firstWhere((g) => g.name != mine.name);
      final a = tester.getRect(
        find.text(enL.tourContGroupHeading(mine.name)).hitTestable(),
      );
      final b = tester.getRect(
        find.text(enL.tourContGroupHeading(next.name)).hitTestable(),
      );
      expect(a.top, b.top);
      expect(b.left, greaterThan(a.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  Future<void> openCup(
    WidgetTester tester,
    Confederation conf,
    Size size,
  ) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        continentalDetailProvider((
          careerId: kSeededCareerId,
          confederation: conf,
        )).overrideWith(
          (ref) async =>
              fakeContinentalData(seededNationId, confederation: conf),
        ),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continental}?careerId=${save.careerId}&conf=${conf.name}',
      size: size,
    );
  }

  int tabIndex(WidgetTester tester) =>
      DefaultTabController.of(tester.element(find.byType(TabBarView))).index;

  for (final size in kTabletSizes) {
    testWidgets('a played cup opens on its bracket, finals in columns, $size', (
      tester,
    ) async {
      await openCup(tester, Confederation.europe, size);
      expect(tester.takeException(), isNull);
      // Summary, Qualifying, Finals, Bracket: the bracket is tab 3.
      expect(tabIndex(tester), 3);
      expect(
        tester.widget<TournamentBracket>(find.byType(TournamentBracket)).wide,
        isTrue,
      );
      await showTab(tester, 2);
      expect(tester.takeException(), isNull);
      final a = tester.getRect(
        find.text(enL.tourContGroupHeading('A')).hitTestable(),
      );
      final b = tester.getRect(
        find.text(enL.tourContGroupHeading('B')).hitTestable(),
      );
      expect(a.top, b.top);
      expect(b.left, greaterThan(a.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a cup with no qualifying has seven tabs', (tester) async {
    await openCup(tester, Confederation.southAmerica, kTabletSize);
    expect(tester.takeException(), isNull);
    expect(tester.widget<TabBar>(find.byType(TabBar)).tabs, hasLength(7));
    expect(find.text(enL.tourContTabQualifying), findsNothing);
    // Not the manager's region, and played: it opens on its bracket, which
    // is tab 2 once there is no qualifying tab.
    expect(tabIndex(tester), 2);
    expect(find.byType(TournamentBracket), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
