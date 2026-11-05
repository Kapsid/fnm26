import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('menu shows Editor and opens the list', (tester) async {
    final c = await editorContainer(tester);
    await pumpEditorRoute(tester, c, Routes.home);

    final editor = find.byKey(HomeScreen.editorKey);
    expect(editor, findsOneWidget);
    expect(
      find.descendant(of: editor, matching: find.text(enL.homeEditor)),
      findsOneWidget,
    );
    await tester.tap(editor);
    await settle(tester);

    expect(find.byType(EditorListScreen), findsOneWidget);
    expect(
      c.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.editor,
    );
    // No database yet: the list says what one is and how to make one.
    expect(find.byKey(EditorListScreen.emptyKey), findsOneWidget);
    expect(find.byKey(EditorListScreen.newKey), findsOneWidget);
    expect(find.byKey(EditorListScreen.importKey), findsOneWidget);
  });

  testWidgets(
    'New makes a complete pack',
    timeout: const Timeout.factor(6),
    (tester) async {
      final c = await editorContainer(tester);
      await pumpEditorRoute(tester, c, Routes.editor);

      await tester.tap(find.byKey(EditorListScreen.newKey));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(EditorListScreen.nameFieldKey),
        'My World 2027',
      );
      await tester.tap(find.byKey(EditorListScreen.confirmKey));
      await tester.pump();

      // A new database is the whole default world: it is ready at once.
      await pumpUntilFound(tester, find.text(enL.editorStatusReady));
      expect(find.text('My World 2027'), findsOneWidget);

      late List<WorldPackSummary> packs;
      late bool complete;
      await tester.runAsync(() async {
        packs = await c.read(worldPackRepositoryProvider).list();
        final pack = await c
            .read(worldPackRepositoryProvider)
            .load(packs.single.id);
        final world = await c.read(nationRepositoryProvider).newCareerWorld();
        complete = PackRules.isComplete(
          pack!,
          baseCodes: {for (final n in world) n.id: n.code},
        );
        expect(pack.squads.keys.toSet(), {for (final n in world) n.id});
      });
      expect(packs.single.name, 'My World 2027');
      expect(complete, isTrue);
    },
  );

  testWidgets('deleting asks first', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Keep me'));
    await pumpEditorRoute(tester, c, Routes.editor);
    expect(find.text('Keep me'), findsOneWidget);

    Future<void> askToDelete() async {
      await tester.tap(find.byKey(EditorListScreen.moreKey(id)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(enL.editorDelete).last);
      await tester.pumpAndSettle();
    }

    await askToDelete();
    // A question, not a deletion.
    expect(find.text(enL.editorDeleteTitle), findsOneWidget);
    await tester.tap(find.text(enL.editorCancel));
    await settle(tester);
    expect(find.text('Keep me'), findsOneWidget);
    late int left;
    await tester.runAsync(() async {
      left = (await c.read(worldPackRepositoryProvider).list()).length;
    });
    expect(left, 1);

    await askToDelete();
    await tester.tap(find.byKey(EditorListScreen.confirmKey));
    await settle(tester);
    await tester.runAsync(() async {
      left = (await c.read(worldPackRepositoryProvider).list()).length;
    });
    expect(left, 0);
    expect(find.text('Keep me'), findsNothing);
    expect(find.byKey(EditorListScreen.emptyKey), findsOneWidget);
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render without overflow, list, $size', (
      tester,
    ) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      await insertPack(
        tester,
        c,
        testPack(
          'Ready one',
          squads: {
            nationIdOf('CZE'): testSquad(),
          },
        ),
      );
      await insertPack(
        tester,
        c,
        testPack(
          'Short one',
          squads: {
            nationIdOf('CZE'): testSquad(mid: 7),
          },
        ),
      );
      await pumpEditorRoute(tester, c, Routes.editor, size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(EditorListScreen.tabletLayoutKey), findsOneWidget);
      expect(find.text(enL.editorStatusReady), findsOneWidget);
      expect(find.text(enL.editorStatusMissing(1)), findsOneWidget);
    });
  }
}
