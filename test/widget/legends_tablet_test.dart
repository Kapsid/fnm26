import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/legends_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fake ? [fakeLegendsOverride()] : const [],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.legends}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<RankedLegend>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the hall of fame as a grid, the pane beside it, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(
        tester.widget<DataGrid<RankedLegend>>(_grid).rows,
        fakeLegends().hallOfFame,
      );
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a legend opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final first = fakeLegends().hallOfFame.first;
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(first.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      first.playerId,
    );
    expect(tester.widget<DataGrid<RankedLegend>>(_grid).selected, first);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the all-time XI is the second tab', (tester) async {
    final save = await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester.widget<DataGrid<RankedLegend>>(_grid).rows,
      fakeLegends().allTimeXi,
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsGreatestSide(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a fresh save has no legends yet', (tester) async {
    final save = await _open(tester, kTabletSize, fake: false);
    expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
