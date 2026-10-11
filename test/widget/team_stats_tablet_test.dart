import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/domain/services/stats/career_stats.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/active_column_check.dart';
import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool records = true,
  bool played = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (records) fakeTeamStatsOverride(),
      if (played) ..._playedOverrides,
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.teamStats}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

/// A side a few years in: games played, so the header carries its record
/// line, and three years of strength, so the curve is drawn beside it.
/// Neither override awaits, so an invalidated, never-rebuilt element cannot
/// trip riverpod 2.6.1 at teardown.
final List<Override> _playedOverrides = [
  careerStatsProvider(kSeededCareerId).overrideWith(
    (ref) async => const CareerStatsSnapshot(
      played: 24,
      wins: 14,
      draws: 6,
      losses: 4,
      goalsFor: 41,
      goalsAgainst: 19,
    ),
  ),
  teamOverallHistoryProvider(kSeededCareerId).overrideWith(
    (ref) async => const <TeamOverallPoint>[
      (year: 2026, overall: 78),
      (year: 2027, overall: 80),
      (year: 2028, overall: 82),
    ],
  ),
];

DetailTarget? _pane(WidgetTester tester) =>
    tester.widget<DetailPaneHost>(find.byType(DetailPaneHost)).target;

void main() {
  for (final size in kTabletSizes) {
    for (final size in const [Size(1080, 810), Size(1366, 1024)]) {
      testWidgets('the active badge stands clear of the goals at $size', (
        tester,
      ) async {
        await _open(tester, size);
        expectActiveBadgesClear(tester, enL.playerStatGoals);
        await tester.pumpWidget(const SizedBox());
      });
    }

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

  for (final size in kTabletSizes) {
    testWidgets('the record line and the curve both fit, $size', (
      tester,
    ) async {
      await _open(tester, size, played: true);
      expect(tester.takeException(), isNull);
      expect(find.text(enL.statsPlayed.toUpperCase()), findsOneWidget);
      final curve = find.byKey(const Key('team-overall-history'));
      expect(curve, findsOneWidget);
      // Side by side only when each card gets 364: otherwise stacked.
      final md = tester.widget<MasterDetail>(find.byType(MasterDetail));
      final master = tester.getSize(find.byWidget(md.master)).width;
      final played = tester.getRect(find.text(enL.statsPlayed.toUpperCase()));
      if (master >= 2 * 364 + AppSpacing.md) {
        expect(tester.getRect(curve).left, greaterThan(played.right));
      } else {
        expect(tester.getRect(curve).top, greaterThanOrEqualTo(played.bottom));
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('wide enough, the header and the curve sit side by side', (
    tester,
  ) async {
    await _open(tester, const Size(1600, 900), played: true);
    expect(tester.takeException(), isNull);
    final md = tester.widget<MasterDetail>(find.byType(MasterDetail));
    final master = tester.getSize(find.byWidget(md.master)).width;
    expect(master, greaterThanOrEqualTo(2 * 364 + AppSpacing.md));
    final played = tester.getRect(find.text(enL.statsPlayed.toUpperCase()));
    final curve = tester.getRect(find.byKey(const Key('team-overall-history')));
    expect(curve.left, greaterThan(played.right));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the master at its narrowest still fits both, 1024x768', (
    tester,
  ) async {
    await _open(tester, const Size(1024, 768), played: true);
    expect(tester.takeException(), isNull);
    // Drag the divider far past the minimum: it stops at minFraction.
    await tester.drag(
      find.byKey(MasterDetail.dividerKey),
      const Offset(-1000, 0),
    );
    await settle(tester);
    final md = tester.widget<MasterDetail>(find.byType(MasterDetail));
    final whole = tester.getSize(find.byType(MasterDetail)).width;
    final master = tester.getSize(find.byWidget(md.master));
    expect(
      master.width,
      closeTo(whole * md.minFraction, 1),
      reason: 'the divider sits at its minimum',
    );
    expect(tester.takeException(), isNull);
    expect(find.text(enL.statsPlayed.toUpperCase()), findsOneWidget);
    expect(find.byKey(const Key('team-overall-history')), findsOneWidget);
    // Too narrow for two cards side by side: the curve goes under the
    // header's record line instead of squeezing beside it.
    expect(
      tester.getRect(find.byKey(const Key('team-overall-history'))).top,
      greaterThanOrEqualTo(
        tester.getRect(find.text(enL.statsPlayed.toUpperCase())).bottom,
      ),
    );
    await tester.pumpWidget(const SizedBox());
  });

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
