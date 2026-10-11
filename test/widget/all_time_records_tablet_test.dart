import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/all_time_records_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [fakeAllTimeOverride()],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.allTimeRecords}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<AllTimeLeader>);

List<AllTimeLeader> _rows(WidgetTester tester) =>
    tester.widget<DataGrid<AllTimeLeader>>(_grid).rows;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the search over the boards, the pane beside them, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
      expect(_rows(tester), fakeAllTimeRecords().topScorers);
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a player opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final top = fakeAllTimeRecords().topScorers.first;
    await tester.tap(find.descendant(of: _grid, matching: find.text(top.name)));
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      top.playerId,
    );
    expect(tester.widget<DataGrid<AllTimeLeader>>(_grid).selected, top);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the search filters every board', (tester) async {
    await _open(tester, kTabletSize);
    final nation = fieldOf(seededNationId, 4)[1];
    await tester.enterText(find.byType(TextField), nation.name);
    await tester.pump();
    expect(_rows(tester), hasLength(2));
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await showTab(tester, 1);
    expect(_rows(tester), hasLength(2));
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(_grid, findsNothing);
    expect(find.text(enL.recordsNoMatches), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the search (Review Focus 4)', (tester) async {
    await _open(tester, kTabletSize);
    final nation = fieldOf(seededNationId, 4)[1];
    await tester.enterText(find.byType(TextField), nation.name);
    await tester.pump();
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsNothing);
    expect(find.widgetWithText(TextField, nation.name), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.widgetWithText(TextField, nation.name), findsOneWidget);
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
