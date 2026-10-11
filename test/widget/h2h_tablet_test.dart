import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/records/h2h_meetings_screen.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/head_to_head_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fakeH2hOverrides(),
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.headToHead}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _ledger => find.byType(DataGrid<MyH2HLine>);

H2hMeetingsView _pair(WidgetTester tester) =>
    tester.widget<H2hMeetingsView>(find.byType(H2hMeetingsView));

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

/// Picks [name] through the picker dialog the [slot] text opens.
Future<void> _pickThroughDialog(
  WidgetTester tester,
  String slot,
  String name,
) async {
  await tester.tap(find.text(slot));
  await settle(tester);
  expect(find.byType(Dialog), findsOneWidget);
  await tester.enterText(
    find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
    name,
  );
  await tester.pump();
  // The row, not the search field: that holds the typed name too.
  await tester.tap(
    find
        .descendant(
          of: find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(ListTile),
          ),
          matching: find.text(name),
        )
        .first,
  );
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the slots and the ledger, the pane waiting, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // Home is the manager's nation; away is still to pick.
      expect(find.text(enL.recordsSelect), findsOneWidget);
      expect(tester.widget<DataGrid<MyH2HLine>>(_ledger).rows, fakeLedger());
      expect(find.text(enL.h2hPickOpponent), findsOneWidget);
      expect(
        tester.getCenter(_ledger).dx,
        lessThan(tester.getCenter(find.text(enL.h2hPickOpponent)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('an opponent from the ledger opens the pairing beside it', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    final line = fakeLedger().first;
    await tester.tap(
      find.descendant(of: _ledger, matching: find.text(line.opponentName)),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_pair(tester).nationA, save.nationId);
    expect(_pair(tester).nationB, line.opponentId);
    // The record above the meetings, without the link to the meetings.
    expect(find.text(enL.recordsCodeWins(me.code)), findsOneWidget);
    expect(find.text(enL.recordsSeeAllMeetings), findsNothing);
    expect(find.text('2–0'), findsOneWidget);
    expect(tester.widget<DataGrid<MyH2HLine>>(_ledger).selected, line);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the picker dialog closes itself, not the page (Review Focus '
      '5)', (tester) async {
    final save = await _open(tester, kTabletSize);
    final other = realNationsById[fakeLedger()[1].opponentId]!;
    await _pickThroughDialog(tester, enL.recordsSelect, other.name);
    expect(find.byType(Dialog), findsNothing);
    expect(_path(save), Routes.headToHead);
    expect(_pair(tester).nationB, other.id);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the same nation twice asks for two different ones', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pickThroughDialog(tester, enL.recordsSelect, me.name);
    expect(find.byType(H2hMeetingsView), findsNothing);
    expect(find.text(enL.recordsPickTwoDifferent), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the pairing (Review Focus 4)', (tester) async {
    await _open(tester, kTabletSize);
    final line = fakeLedger().first;
    await tester.tap(
      find.descendant(of: _ledger, matching: find.text(line.opponentName)),
    );
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsNothing);
    // The phone's record of the same pairing, with its link.
    expect(find.text(enL.recordsSeeAllMeetings), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsOneWidget);
    expect(_pair(tester).nationB, line.opponentId);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('every meeting on a page of its own', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: fakeH2hOverrides(),
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await pumpRoute(
      tester,
      save,
      '${Routes.h2hMeetings}?careerId=${save.careerId}'
      '&a=${me.id}&b=${rivalNation.id}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(H2HMeetingsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    expect(
      find.text(enL.recordsVersus(me.name, rivalNation.name)),
      findsOneWidget,
    );
    expect(find.text('2–0'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
