import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// A save on a tablet's saves list, and (when [second]) a second one on the
/// rival nation, whose id comes back with it.
Future<(SeededSave, int?)> _open(
  WidgetTester tester,
  Size size, {
  bool second = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [fakeTransferOverride()],
  );
  final secondId = second ? await addSecondSave(tester, save) : null;
  await pumpRoute(tester, save, Routes.saves, size: size);
  return (save, secondId);
}

Finder get _grid => find.byType(DataGrid<Career>);

/// Whose career the pane is showing.
int _paneId(WidgetTester tester) =>
    tester.widget<CareerSummaryView>(find.byType(CareerSummaryView)).careerId;

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<Career?> _career(WidgetTester tester, SeededSave save, int id) async {
  Career? career;
  await tester.runAsync(() async {
    career = await save.container.read(careerRepositoryProvider).byId(id);
  });
  return career;
}

Future<List<Career>> _all(WidgetTester tester, SeededSave save) async {
  var all = <Career>[];
  await tester.runAsync(() async {
    all = await save.container.read(careerRepositoryProvider).all();
  });
  return all;
}

/// Picks the first-made save (the manager's own nation) in the table.
///
/// [addSecondSave] stamps the second save as played more recently, so it
/// lists first and is the one the pane opens on before any pick. Picking the
/// OTHER one is what proves the pane, and every action under it, follows the
/// pick rather than the list's first row.
Future<void> _pickFirstMade(
  WidgetTester tester,
  SeededSave save,
  int second,
) async {
  expect(_paneId(tester), second, reason: 'the list opens on its first row');
  await tester.tap(
    find.descendant(
      of: _grid,
      matching: find.text(realNationsById[seededNationId]!.name),
    ),
  );
  await settle(tester);
  expect(_paneId(tester), save.careerId);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the table beside the picked save, $size', (tester) async {
      final (save, _) = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(tester.widget<DataGrid<Career>>(_grid).rows, hasLength(1));
      // The only save is open beside the table, with its three actions.
      expect(_paneId(tester), save.careerId);
      expect(
        tester.getRect(_grid).right,
        lessThan(tester.getRect(find.byType(CareerSummaryView)).left),
      );
      expect(find.byKey(SavesScreen.continueKey), findsOneWidget);
      expect(find.byKey(SavesScreen.exportKey), findsOneWidget);
      expect(find.byKey(SavesScreen.deleteKey), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue opens the picked save and stamps only it (Review '
      'Focus 2)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickFirstMade(tester, save, second!);
    // Both were stamped in the past by addSecondSave, so the stamp Continue
    // writes (now) is a change on the save it opens.
    final pickedBefore = (await _career(
      tester,
      save,
      save.careerId,
    ))!.lastPlayedAt;
    final otherBefore = (await _career(tester, save, second))!.lastPlayedAt;
    expect(pickedBefore, isNotNull);
    expect(otherBefore, isNotNull);
    await tester.tap(find.byKey(SavesScreen.continueKey));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    expect(
      (await _career(tester, save, save.careerId))!.lastPlayedAt,
      isNot(pickedBefore),
    );
    expect((await _career(tester, save, second))!.lastPlayedAt, otherBefore);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('re-picking the save listed first sends Continue to it (Review '
      'Focus 2)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    // Away from the first row and back: the pick follows the LAST tap, not
    // the first, nor the first-made save.
    await _pickFirstMade(tester, save, second!);
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(rivalNation.name)),
    );
    await settle(tester);
    expect(_paneId(tester), second);
    final secondBefore = (await _career(tester, save, second))!.lastPlayedAt;
    final firstBefore = (await _career(
      tester,
      save,
      save.careerId,
    ))!.lastPlayedAt;
    expect(secondBefore, isNotNull);
    expect(firstBefore, isNotNull);
    await tester.tap(find.byKey(SavesScreen.continueKey));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '$second');
    expect(
      (await _career(tester, save, second))!.lastPlayedAt,
      isNot(secondBefore),
    );
    expect(
      (await _career(tester, save, save.careerId))!.lastPlayedAt,
      firstBefore,
    );
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in kTabletSizes) {
    testWidgets('a free tier with both slots taken, $size', (tester) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [fakeTransferOverride()],
      );
      await addSecondSave(tester, save);
      // seedSave unlocks premium so a second save can be made; lock it again
      // (it is a StateProvider, as the premium gate test sets it).
      final premium = save.container.read(premiumUnlockedProvider.notifier);
      expect(premium.state, isTrue);
      premium.state = false;
      await pumpRoute(tester, save, Routes.saves, size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
      expect(
        find.text(enL.careerSlotsCount(2, kFreeSaveSlots)),
        findsOneWidget,
      );
      expect(find.text(enL.careerSlotsUnlockMore), findsOneWidget);
      expect(find.text(enL.careerSlotsKeepNote), findsOneWidget);
      expect(find.text(enL.careerImport), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('no saves at all, $size', (tester) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [fakeTransferOverride()],
      );
      final careers = save.container.read(careerRepositoryProvider);
      await tester.runAsync(() async {
        expect(await careers.all(), hasLength(1));
        await careers.delete(save.careerId);
        expect(await careers.all(), isEmpty);
      });
      await pumpRoute(tester, save, Routes.saves, size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(DataGrid<Career>), findsNothing);
      // Once in the table's place, once in the pane's.
      expect(find.text(enL.careerNoSavesYet), findsNWidgets(2));
      expect(find.byType(CareerSummaryView), findsNothing);
      expect(find.byKey(SavesScreen.continueKey), findsNothing);
      expect(find.byKey(SavesScreen.exportKey), findsNothing);
      expect(find.byKey(SavesScreen.deleteKey), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('deleting the picked save leaves the other one open (Review '
      'Focus 2 and 5)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickFirstMade(tester, save, second!);
    expect(
      {for (final c in await _all(tester, save)) c.id},
      {
        save.careerId,
        second,
      },
    );
    final transfer =
        save.container.read(careerTransferServiceProvider)
            as FakeCareerTransfer;
    expect(transfer.removed, isEmpty);
    await tester.tap(find.byKey(SavesScreen.deleteKey));
    await settle(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(enL.careerDelete),
      ),
    );
    await settle(tester);
    // The dialog closed itself; the page is still the saves list.
    expect(find.byType(AlertDialog), findsNothing);
    expect(_uri(save).path, Routes.saves);
    expect([for (final c in await _all(tester, save)) c.id], [second]);
    expect(transfer.removed, [save.careerId]);
    // The deleted save is gone from the table AND the pane, which falls back
    // to the save that is left.
    expect(tester.widget<DataGrid<Career>>(_grid).rows, hasLength(1));
    expect(_paneId(tester), second);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('export writes the picked save and points the share sheet at '
      'its button (Review Focus 2 and 3)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickFirstMade(tester, save, second!);
    const channel = MethodChannel('dev.fluttercommunity.plus/share');
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      return 'dev.fluttercommunity.plus/share/unavailable';
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    final transfer =
        save.container.read(careerTransferServiceProvider)
            as FakeCareerTransfer;
    expect(transfer.exported, isEmpty);
    final button = tester.getRect(find.byKey(SavesScreen.exportKey));
    await tester.tap(find.byKey(SavesScreen.exportKey));
    await settle(tester);
    expect(transfer.exported, [save.careerId]);
    expect(calls, hasLength(1));
    final args = calls.single.arguments as Map<Object?, Object?>;
    expect(
      Rect.fromLTWH(
        args['originX']! as double,
        args['originY']! as double,
        args['originWidth']! as double,
        args['originHeight']! as double,
      ),
      button,
    );
    expect(find.text(enL.careerShareFailed), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the pick (Review Focus 4)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickFirstMade(tester, save, second!);
    // Under 1000 wide: the phone list, both saves.
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(SavesScreen.tabletLayoutKey), findsNothing);
    expect(find.byType(SaveTile), findsNWidgets(2));
    // Back over 1000: the pane is still on the pick, not the first row.
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
    expect(_paneId(tester), save.careerId);
    // And down and up once more: the pick survives every crossing.
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(SavesScreen.tabletLayoutKey), findsNothing);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(_paneId(tester), save.careerId);
    await tester.pumpWidget(const SizedBox());
  });
}
