import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/record_book_screen.dart';
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
    overrides: fake ? fakeRecordsOverrides() : const [],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.records}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<RecordLeader>);

/// The panel headed [title] (panel headers are upper case).
Finder _panel(String title) => find
    .ancestor(
      of: find.text(title.toUpperCase()).first,
      matching: find.byType(Panel),
    )
    .first;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('team records beside the rival, the boards as a grid, the '
        'pane, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(RecordBookScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final team = tester.getRect(_panel(enL.careerTeamRecords));
      final rival = tester.getRect(_panel(enL.recordsFiercestRival));
      expect(rival.top, team.top);
      expect(rival.left, greaterThan(team.right));
      expect(find.text(fakeRivalry().rival.name), findsOneWidget);
      expect(
        tester.widget<DataGrid<RecordLeader>>(_grid).rows,
        fakeRecordBook().mostCaps,
      );
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getRect(_grid).right,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a leader opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final leader = fakeRecordBook().mostCaps.first;
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(leader.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      leader.playerId,
    );
    expect(tester.widget<DataGrid<RecordLeader>>(_grid).selected, leader);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the other boards are the other tabs', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester.widget<DataGrid<RecordLeader>>(_grid).rows,
      fakeRecordBook().topScorers,
    );
    await showTab(tester, 2);
    expect(
      tester.widget<DataGrid<RecordLeader>>(_grid).rows,
      fakeRecordBook().topAssists,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a fresh save is told to play some matches', (tester) async {
    final save = await _open(tester, kTabletSize, fake: false);
    expect(find.byKey(RecordBookScreen.tabletLayoutKey), findsOneWidget);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsPlayToWriteHistory(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
