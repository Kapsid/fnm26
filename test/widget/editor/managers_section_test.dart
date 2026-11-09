import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/editor_app.dart';
import '../../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(int id, {int? nation}) => editorSectionLocation(
  EditorSection.managers,
  id,
  nationId: nation,
);

void main() {
  final cze = nationIdOf('CZE');
  final en = lookupAppLocalizations(const Locale('en'));

  testWidgets("editing Czechia's manager saves to pack.managers", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Managers'));
    await pumpEditorRoute(tester, c, _at(id));
    expect(find.byType(NameSectionScreen), findsOneWidget);

    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'czechia');
    await tester.pump();
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    expect(row, findsOneWidget);
    // Nobody named yet: the game picks him when a career starts.
    expect(
      find.descendant(of: row, matching: find.text(en.editorManagersHint)),
      findsOneWidget,
    );

    await tester.tap(row);
    await settle(tester);
    await tester.enterText(
      find.byKey(NameEditForm.managerNameKey),
      'Ota Brnák',
    );
    await tester.pump();
    // His nationality starts as the nation's own.
    expect(_pack(c, id).managers, {
      cze: (name: 'Ota Brnák', nationality: 'CZE'),
    });

    // Another nationality, picked from the game's nations.
    tester
        .widget<DropdownButtonFormField<String>>(
          find.byKey(NameEditForm.managerNationalityKey),
        )
        .onChanged!('SVK');
    await tester.pump();
    expect(_pack(c, id).managers, {
      cze: (name: 'Ota Brnák', nationality: 'SVK'),
    });

    // A name the game cannot show is refused, and not saved (the field
    // stops a long one at 40 characters).
    await tester.enterText(
      find.byKey(NameEditForm.managerNameKey),
      'Ota\u0007Brnák',
    );
    await tester.pump();
    expect(_pack(c, id).managers[cze]!.name, 'Ota Brnák');

    await tester.enterText(
      find.byKey(NameEditForm.managerNameKey),
      'Ota Brnák',
    );
    await tester.pump();
    await tester.tap(find.byKey(NameEditForm.doneKey));
    await settle(tester);
    expect(
      find.descendant(of: row, matching: find.textContaining('Ota Brnák')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('clearing the row removes it', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Managers').copyWith(
        managers: {cze: (name: 'Ota Brnák', nationality: 'CZE')},
      ),
    );
    // Opened on Czechia (a jump from the home): its row is picked.
    await pumpEditorRoute(tester, c, _at(id, nation: cze));
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    await tester.tap(row);
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.managerNameKey), '');
    await tester.pump();
    expect(_pack(c, id).managers, isEmpty);

    // Reset clears it too.
    await tester.enterText(find.byKey(NameEditForm.managerNameKey), 'Lew Ward');
    await tester.pump();
    expect(_pack(c, id).managers.keys, [cze]);
    await tester.tap(find.byKey(NameEditForm.resetKey));
    await tester.pump();
    expect(_pack(c, id).managers, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the tablet edits the picked manager beside the list', (
    tester,
  ) async {
    final c = await editorContainer(tester, formFactor: FormFactor.tablet);
    final id = await insertPack(tester, c, testPack('Managers'));
    await pumpEditorRoute(tester, c, _at(id, nation: cze), size: kTabletSize);
    expect(find.byKey(NameSectionScreen.tabletLayoutKey), findsOneWidget);
    // Opened on Czechia: picked, its form beside the list.
    expect(find.byKey(NameEditForm.managerNameKey), findsOneWidget);
    expect(find.byKey(NameEditForm.doneKey), findsNothing);
    await tester.enterText(find.byKey(NameEditForm.managerNameKey), 'Lew Ward');
    await tester.pump();
    expect(_pack(c, id).managers, {
      cze: (name: 'Lew Ward', nationality: 'CZE'),
    });
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 450));
  });
}
