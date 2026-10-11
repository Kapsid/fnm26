import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool records = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [if (records) fakeTeamStatsOverride()],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.teamStats}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

DetailTarget? _pane(WidgetTester tester) =>
    tester.widget<DetailPaneHost>(find.byType(DetailPaneHost)).target;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the boards as grids beside the player pane, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TeamStatsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final grid = find.byType(DataGrid<TeamStatEntry>);
      expect(grid, findsOneWidget);
      expect(
        tester.widget<DataGrid<TeamStatEntry>>(grid).rows,
        fakeTeamStats().scorers,
      );
      expect(
        tester.getRect(find.byType(DetailPaneHost)).left,
        greaterThan(tester.getRect(grid).right),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a fresh save says so, as on the phone', (tester) async {
    await _open(tester, kTabletSize, records: false);
    expect(find.byKey(TeamStatsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.statsNoGoalsRecorded), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a row opens the player beside the grid', (tester) async {
    await _open(tester, kTabletSize);
    expect(_pane(tester), isNull);
    final first = fakeTeamStats().scorers.first;
    await tester.tap(find.text(fakeTeamStats().names[first.playerId]!).first);
    await settle(tester);
    expect(_pane(tester), PlayerTarget(first.playerId));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('most games, ratings and the career are the other tabs', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester
          .widget<DataGrid<TeamStatEntry>>(find.byType(DataGrid<TeamStatEntry>))
          .rows,
      fakeTeamStats().appearances,
    );
    await showTab(tester, 2);
    await settle(tester);
    expect(
      tester
          .widget<DataGrid<TeamRatingEntry>>(
            find.byType(DataGrid<TeamRatingEntry>),
          )
          .rows,
      fakeTeamStats().ratings,
    );
    await showTab(tester, 3);
    await settle(tester);
    // A fresh save's own record: nothing played yet.
    expect(find.text(enL.statsNoData), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to the Career page', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.careers,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
