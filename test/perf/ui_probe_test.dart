// A local timing probe for the editor's New and the nation pick with a big
// world on the device, not a regression test: run it by hand with
// FNM_PERF_PACK=/path/to/a/big.fnmdb. Skipped otherwise.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';
import '../unit/greenland/greenland_fixtures.dart';

final String? _packPath = Platform.environment['FNM_PERF_PACK'];

/// Pumps until [done], timing it on the wall clock, and the longest frame
/// (a pump and the real time it waited for) on the way.
Future<void> _until(
  WidgetTester tester,
  String label,
  bool Function() done,
) async {
  final clock = Stopwatch()..start();
  var worst = 0;
  while (!done()) {
    if (clock.elapsed > const Duration(minutes: 3)) {
      fail('$label never finished');
    }
    final frame = Stopwatch()..start();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 4)),
    );
    await tester.pump(const Duration(milliseconds: 16));
    final ms = frame.elapsedMilliseconds - 4;
    if (ms > worst) worst = ms;
  }
  // Printed for the person running the probe.
  // ignore: avoid_print
  print(
    'PERF ${label.padRight(40)} ${'${clock.elapsedMilliseconds}'.padLeft(6)}'
    ' ms  worst step ${'$worst'.padLeft(5)} ms',
  );
}

void main() {
  testWidgets(
    'ui probe',
    skip: _packPath == null,
    timeout: const Timeout(Duration(minutes: 30)),
    (tester) async {
      // An in-memory database: one on a background isolate never answers
      // inside a widget test's fake clock. The database work is counted in
      // these times, which the app does off the UI isolate.
      final c = await editorContainer(tester, players: seedPlayers);
      late int realId;
      await tester.runAsync(() async {
        realId = (await c.read(worldPackServiceProvider).importFile(_packPath!))
            .valueOrNull!;
      });

      // The editor's list with the big world on it, then New.
      await pumpEditorRoute(tester, c, Routes.editor);
      await _until(
        tester,
        'editor list shows',
        () =>
            find.byKey(EditorListScreen.editKey(realId)).evaluate().isNotEmpty,
      );
      await tester.tap(find.byKey(EditorListScreen.newKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(EditorListScreen.nameFieldKey), 'New');
      await tester.tap(find.byKey(EditorListScreen.confirmKey));
      await tester.pump();
      await _until(
        tester,
        'editor New done',
        () =>
            find.text('New').evaluate().isNotEmpty &&
            find.byType(CircularProgressIndicator).evaluate().isEmpty,
      );

      // The nation pick on the big world, then switched to Default and back.
      chooseNewGameWorld(c, realId);
      c.read(routerProvider).go(Routes.nations);
      await _until(
        tester,
        'nation pick (big world) shows',
        () =>
            find.byType(NationSelectScreen).evaluate().isNotEmpty &&
            find.byType(CircularProgressIndicator).evaluate().isEmpty &&
            find.byType(ListView).evaluate().isNotEmpty,
      );
      for (var i = 0; i < 3; i++) {
        chooseNewGameWorld(c, null);
        await tester.pump();
        await _until(
          tester,
          'switch to Default #$i',
          () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
        );
        chooseNewGameWorld(c, realId);
        await tester.pump();
        await _until(
          tester,
          'switch to big world #$i',
          () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
        );
      }
      await settle(tester);
    },
  );
}
