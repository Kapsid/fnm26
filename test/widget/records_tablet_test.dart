import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/active_column_check.dart';
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
    testWidgets('team records with the rival, the boards as a grid, the '
        'pane, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(RecordBookScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final team = tester.getRect(_panel(enL.careerTeamRecords));
      final rival = tester.getRect(_panel(enL.recordsFiercestRival));
      // The 11 inch iPad and smaller have no room for the two side by side
      // with the values whole: the rival goes under the team records.
      expect(rival.top, greaterThan(team.bottom));
      expect(rival.left, team.left);
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

  testWidgets('at 1366 the team records sit beside the rival', (tester) async {
    await _open(tester, const Size(1366, 1024));
    final team = tester.getRect(_panel(enL.careerTeamRecords));
    final rival = tester.getRect(_panel(enL.recordsFiercestRival));
    expect(rival.top, team.top);
    expect(rival.left, greaterThan(team.right));
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in const [
    Size(1024, 768),
    Size(1080, 810),
    Size(1366, 1024),
  ]) {
    testWidgets('the team records are whole and in two aligned columns at '
        '$size', (tester) async {
      await _open(tester, size);
      final panel = _panel(enL.careerTeamRecords);
      final book = fakeRecordBook();
      final win = book.biggestWin!;
      final labels = [
        enL.recordsBestFinish,
        enL.recordsLongestUnbeaten,
        enL.recordsBiggestWin,
      ];
      final values = [
        book.bestFinish,
        enL.recordsMatchesCount(book.longestUnbeaten),
        enL.recordsBiggestWinValue(
          win.gf,
          win.ga,
          book.nations[win.oppId]!.name,
        ),
      ];
      Rect rectOf(String text) => tester.getRect(
        find.descendant(of: panel, matching: find.text(text)),
      );
      for (final t in [for (final l in labels) l.toUpperCase(), ...values]) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(of: panel, matching: find.text(t)),
        );
        expect(paragraph.didExceedMaxLines, isFalse, reason: '$t cut');
      }
      // One left edge for the labels, one for the values, flag or not.
      final labelLefts = {for (final l in labels) rectOf(l.toUpperCase()).left};
      final valueLefts = {for (final v in values) rectOf(v).left};
      expect(labelLefts, hasLength(1));
      expect(valueLefts, hasLength(1));
      expect(valueLefts.single, greaterThan(labelLefts.single));
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final size in const [Size(1080, 810), Size(1366, 1024)]) {
    testWidgets('the active badge stands clear of the caps at $size', (
      tester,
    ) async {
      await _open(tester, size);
      expectActiveBadgesClear(tester, enL.playerStatCaps);
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
