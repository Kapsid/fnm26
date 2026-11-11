import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/pack_name_dialog.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  /// The pack's name on disk, read with real time for the database.
  Future<String?> storedName(
    WidgetTester tester,
    ProviderContainer c,
    int id,
    String want,
  ) async {
    String? name;
    for (var i = 0; i < 20 && name != want; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        name = (await c.read(worldPackRepositoryProvider).load(id))?.name;
      });
    }
    return name;
  }

  TextButton confirm(WidgetTester tester) =>
      tester.widget<TextButton>(find.byKey(PackNameDialog.confirmKey));

  testWidgets('Rename on the home checks the name, renames, saves and undoes', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Before'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');

    await tester.tap(find.byKey(PackHomeScreen.renameKey));
    await tester.pumpAndSettle();
    expect(find.text(enL.editorRenameTitle), findsOneWidget);
    final field = find.byKey(PackNameDialog.fieldKey);
    expect(tester.widget<TextField>(field).controller!.text, 'Before');

    // The rules every editor name keeps: not empty, not too long...
    await tester.enterText(field, '   ');
    await tester.pump();
    expect(find.text(enL.editorNameEmpty), findsOneWidget);
    expect(confirm(tester).onPressed, isNull);
    // (The field itself stops at PackRules.nameMax characters.)
    expect(tester.widget<TextField>(field).maxLength, PackRules.nameMax);

    // ...and no word the game does not show.
    await tester.enterText(field, 'Fuck Face');
    await tester.pump();
    expect(find.text(enL.editorNameNotAllowed), findsOneWidget);
    expect(confirm(tester).onPressed, isNull);

    await tester.enterText(field, '  World of Tomorrow  ');
    await tester.pump();
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(PackNameDialog), findsNothing);
    expect(c.read(packEditorProvider(id)).value!.name, 'World of Tomorrow');
    expect(find.text('World of Tomorrow'), findsWidgets);
    expect(
      await storedName(tester, c, id, 'World of Tomorrow'),
      'World of Tomorrow',
    );

    // One undoable edit, like every other.
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'Before');
    expect(await storedName(tester, c, id, 'Before'), 'Before');
  });

  testWidgets('cancelling Rename, or keeping the name, is no edit', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Same'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    final editor = c.read(packEditorProvider(id).notifier);

    await tester.tap(find.byKey(PackHomeScreen.renameKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorCancel));
    await tester.pumpAndSettle();
    expect(editor.canUndo, isFalse);

    await tester.tap(find.byKey(PackHomeScreen.renameKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await tester.pumpAndSettle();
    expect(editor.canUndo, isFalse);
    expect(c.read(packEditorProvider(id)).value!.name, 'Same');
  });

  testWidgets('a database named with a word the game does not show: its '
      'entry on the home opens Rename', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Fuck Face'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    final issues = c.read(packEditorProvider(id).notifier).issues;
    final index = issues.indexWhere((i) => i.where == 'name');
    expect(index, isNonNegative);
    // Masked wherever it shows.
    expect(find.text('Fuck Face'), findsNothing);

    final row = find.byKey(PackHomeScreen.issueKey(index));
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(find.byType(PackNameDialog), findsOneWidget);
    await tester.enterText(find.byKey(PackNameDialog.fieldKey), 'Fair Play');
    await tester.pump();
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await tester.pumpAndSettle();
    expect(c.read(packEditorProvider(id)).value!.name, 'Fair Play');
    expect(
      c
          .read(packEditorProvider(id).notifier)
          .issues
          .where(
            (i) => i.where == 'name',
          ),
      isEmpty,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the tablet home renames too', (tester) async {
    final c = await editorContainer(tester, formFactor: FormFactor.tablet);
    final id = await insertPack(tester, c, testPack('Tablet'));
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorPack}?id=$id',
      size: kTabletSizes.first,
    );
    expect(find.byKey(PackHomeScreen.tabletLayoutKey), findsOneWidget);
    await tester.tap(find.byKey(PackHomeScreen.renameKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(PackNameDialog.fieldKey), 'Big Screen');
    await tester.pump();
    await tester.tap(find.byKey(PackNameDialog.confirmKey));
    await tester.pumpAndSettle();
    expect(c.read(packEditorProvider(id)).value!.name, 'Big Screen');
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 450));
  });
}
