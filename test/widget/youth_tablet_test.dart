import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.youth}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _levelGrid => find.byType(DataGrid<Prospect>);
Finder get _watchGrid => find.byType(DataGrid<WatchedBoy>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the watchlist first, a level as a grid, the pane, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(YouthScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // Opens on the manager's own (empty) list, the pane waiting.
      expect(find.text(enL.youthWatchEmpty), findsOneWidget);
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      await showTab(tester, YouthLevel.values.length);
      expect(tester.takeException(), isNull);
      expect(tester.widget<DataGrid<Prospect>>(_levelGrid).rows, isNotEmpty);
      expect(
        tester.getCenter(_levelGrid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a picked boy opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, YouthLevel.values.length);
    final boy = tester.widget<DataGrid<Prospect>>(_levelGrid).rows.first;
    await tester.tap(
      find.descendant(of: _levelGrid, matching: find.text(boy.player.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      boy.player.id,
    );
    expect(tester.widget<DataGrid<Prospect>>(_levelGrid).selected, boy);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the bookmark puts him on the watchlist grid', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, YouthLevel.values.length);
    final boy = tester.widget<DataGrid<Prospect>>(_levelGrid).rows.first;
    expect(find.byTooltip(enL.youthWatchUnmark), findsNothing);
    // The grid keeps the pyramid's order: his bookmark is the first.
    await tester.tap(find.byTooltip(enL.youthWatchMark).first);
    await settle(tester);
    // Marked: his bookmark now offers to take him off.
    expect(find.byTooltip(enL.youthWatchUnmark), findsOneWidget);
    await showTab(tester, 0);
    await settle(tester);
    final watched = tester.widget<DataGrid<WatchedBoy>>(_watchGrid).rows;
    expect(watched, hasLength(1));
    expect(watched.single.mark.playerId, boy.player.id);
    expect(watched.single.mark.rating, boy.player.overall);
    await tester.pumpWidget(const SizedBox());
  });
}
