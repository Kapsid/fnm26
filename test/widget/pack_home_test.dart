import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_section_screen.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets("a pack with a 22-man nation shows '1 thing missing' and the "
      'jump opens that nation', (tester) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Short', squads: {cze: testSquad(mid: 7)}),
    );
    await pumpEditorRoute(tester, c, Routes.editor);

    expect(find.text(enL.editorStatusMissing(1)), findsOneWidget);

    await tester.tap(find.byKey(EditorListScreen.editKey(id)));
    await settle(tester);
    expect(find.byType(PackHomeScreen), findsOneWidget);
    expect(find.byKey(PackHomeScreen.notReadyKey), findsOneWidget);

    final issue = find.byKey(PackHomeScreen.issueKey(0));
    expect(
      find.descendant(of: issue, matching: find.text('Czechia')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: issue,
        matching: find.text(enL.editorIssuePlayersShort(1)),
      ),
      findsOneWidget,
    );
    expect(find.byKey(PackHomeScreen.issueKey(1)), findsNothing);

    await tester.ensureVisible(issue);
    await tester.tap(issue);
    await settle(tester);

    final uri = c.read(routerProvider).routeInformationProvider.value.uri;
    expect(uri.path, Routes.editorPlayers);
    expect(uri.queryParameters['id'], '$id');
    expect(uri.queryParameters['nation'], '$cze');
    final screen = tester.widget<EditorSectionScreen>(
      find.byType(EditorSectionScreen),
    );
    expect(screen.section, EditorSection.players);
    expect(screen.nationId, cze);
    expect(find.text('Czechia'), findsWidgets);
  });

  testWidgets('undo reverts the last edit', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Before'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    expect(find.byType(PackHomeScreen), findsOneWidget);

    final editor = c.read(packEditorProvider(id).notifier);
    expect(editor.canUndo, isFalse);
    editor
      ..update((p) => p.copyWith(name: 'First'))
      ..update((p) => p.copyWith(name: 'Second'));
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'Second');
    expect(find.text('Second'), findsWidgets);

    // The bar's undo goes back one edit at a time.
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'First');
    editor.undo();
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'Before');
    expect(editor.canUndo, isFalse);

    // Saved as it goes: 400 ms after the last change, it is on disk.
    editor.update((p) => p.copyWith(name: 'Saved'));
    await tester.pump(const Duration(milliseconds: 450));
    late WorldPack? stored;
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        stored = await c.read(worldPackRepositoryProvider).load(id);
      });
      if (stored?.name == 'Saved') break;
      await tester.pump();
    }
    expect(stored!.name, 'Saved');
  });

  testWidgets('undo keeps the last 20 states', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('v0'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    final editor = c.read(packEditorProvider(id).notifier);
    for (var i = 1; i <= 25; i++) {
      editor.update((p) => p.copyWith(name: 'v$i'));
    }
    var undone = 0;
    while (editor.canUndo) {
      editor.undo();
      undone++;
    }
    expect(undone, 20);
    expect(c.read(packEditorProvider(id)).value!.name, 'v5');
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render without overflow, home, $size', (
      tester,
    ) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(
        tester,
        c,
        testPack(
          'A long database name that fills the header',
          squads: {
            nationIdOf('CZE'): testSquad(gk: 1, mid: 7),
            nationIdOf('GER'): testSquad(fwd: 1),
          },
        ),
      );
      await pumpEditorRoute(
        tester,
        c,
        '${Routes.editorPack}?id=$id',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(PackHomeScreen.tabletLayoutKey), findsOneWidget);
      for (final s in EditorSection.values) {
        expect(find.byKey(PackHomeScreen.sectionKey(s)), findsOneWidget);
      }
      expect(find.byKey(PackHomeScreen.issueKey(0)), findsOneWidget);
    });
  }

  testWidgets('the phone home shows every section', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Phone', squads: {nationIdOf('CZE'): testSquad()}),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    expect(tester.takeException(), isNull);
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    for (final s in EditorSection.values) {
      final tile = find.byKey(PackHomeScreen.sectionKey(s));
      await tester.scrollUntilVisible(tile, 200);
      expect(tile, findsOneWidget);
    }
  });
}
