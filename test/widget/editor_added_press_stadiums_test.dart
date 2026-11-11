import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

/// The Press and Stadiums sections add reporters and stadiums of the
/// database's own, as the Clubs, Sponsors and Y sections add theirs.
WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(EditorSection s, int id) => editorSectionLocation(s, id);

const _base = kPackAddedIdBase;

Future<void> _pick(WidgetTester tester, String query, String option) async {
  await tester.enterText(find.byKey(AddedItemForm.pickerSearchKey), query);
  await tester.pump();
  await tester.tap(find.byKey(AddedItemForm.optionKey(option)));
  await settle(tester);
}

FilledButton _addButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(AddedItemForm.addKey));

void main() {
  final cze = nationIdOf('CZE');

  group('AddedEdits', () {
    final pack = testPack('Unit');

    test('reporters and stadiums take ids from the one shared range', () {
      var p = AddedEdits.addClub(pack, 'FC Vltava', 'cze');
      p = AddedEdits.addReporter(p, ' Mira Holcova ', 'Vltava Sport');
      p = AddedEdits.addStadium(p, cze, 'Arena Labe', 'Decin', 18000);
      expect(
        p.addedReporters.single,
        const PackAddedReporter(
          id: _base + 1,
          name: 'Mira Holcova',
          outlet: 'Vltava Sport',
        ),
      );
      expect(p.addedStadiums.single.id, _base + 2);
      expect(AddedEdits.nextAddedId(p), _base + 3);
    });

    test('edits keep the nation, and deletes drop the localized paths', () {
      var p = AddedEdits.addReporter(pack, 'Mira', 'Sport');
      p = AddedEdits.addStadium(p, cze, 'Arena Labe', 'Decin', 18000);
      final edited = AddedEdits.editStadium(
        p,
        _base + 1,
        'Arena',
        'Usti',
        9000,
      );
      expect(
        edited.addedStadiums.single,
        PackStadium(
          id: _base + 1,
          nationId: cze,
          name: 'Arena',
          city: 'Usti',
          capacity: 9000,
        ),
      );
      expect(
        AddedEdits.editStadium(edited, _base + 1, 'Arena', 'Usti', 9000),
        same(edited),
      );
      expect(
        AddedEdits.editReporter(
          p,
          _base,
          'Mira',
          'Radio',
        ).addedReporters.single.outlet,
        'Radio',
      );
      p = p.copyWith(
        localized: {
          PackPaths.addedReporter(_base): {'cs': 'Míra'},
          PackPaths.addedReporterOutlet(_base): {'cs': 'Rádio'},
          PackPaths.addedStadium(_base + 1): {'cs': 'Aréna'},
        },
      );
      final gone = AddedEdits.removeStadium(
        AddedEdits.removeReporter(p, _base),
        _base + 1,
      );
      expect(gone.addedReporters, isEmpty);
      expect(gone.addedStadiums, isEmpty);
      expect(gone.localized, isEmpty);
      // The home's Remove goes the same way.
      expect(
        PackEditor.dropUnknown(p, 'addedStadiums.${_base + 1}').addedStadiums,
        isEmpty,
      );
    });

    test('a nation never gets two added stadiums of one name', () {
      final p = AddedEdits.addStadium(pack, cze, 'Arena Labe', 'Decin', 9000);
      expect(AddedEdits.stadiumNameTaken(p, cze, ' ARENA labe'), isTrue);
      expect(
        AddedEdits.stadiumNameTaken(p, cze, 'Arena Labe', id: _base),
        isFalse,
      );
      expect(AddedEdits.stadiumNameTaken(p, cze + 1, 'Arena Labe'), isFalse);
      expect(AddedEdits.seatsOf('18 000'), 18000);
      expect(AddedEdits.seatsOf('lots'), isNull);
    });

    test('the caps hold', () {
      var p = pack;
      for (var i = 0; i < PackRules.addedReportersMax; i++) {
        p = AddedEdits.addReporter(p, 'R$i', 'O');
      }
      expect(AddedEdits.addReporter(p, 'One more', 'O'), same(p));
      expect(AddedEdits.isFull(NameSection.press, p), isTrue);
      expect(AddedEdits.isFull(NameSection.stadiums, p), isFalse);
    });
  });

  testWidgets('add a reporter, edit his outlet, delete him and undo', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Press'));
    await pumpEditorRoute(tester, c, _at(EditorSection.press, id));
    expect(find.text('Added'), findsNothing);
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Mira Holcova');
    await tester.pump();
    // Nothing to add until he has an outlet.
    expect(_addButton(tester).onPressed, isNull);
    await tester.enterText(find.byKey(AddedItemForm.outletKey), 'Vltava');
    await tester.pump();
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedReporters, const [
      PackAddedReporter(id: _base, name: 'Mira Holcova', outlet: 'Vltava'),
    ]);
    expect(find.text('Added'), findsOneWidget);

    final row = find.byKey(
      NameSectionScreen.rowKey(PackPaths.addedReporter(_base)),
    );
    await tester.tap(row);
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.outletKey), 'Radio Labe');
    await tester.pump();
    expect(_pack(c, id).addedReporters.single.outlet, 'Radio Labe');
    // An emptied outlet is refused, and not saved.
    await tester.enterText(find.byKey(AddedItemForm.outletKey), ' ');
    await tester.pump();
    expect(find.text('Fill this in'), findsOneWidget);
    expect(_pack(c, id).addedReporters.single.outlet, 'Radio Labe');
    await tester.enterText(find.byKey(AddedItemForm.outletKey), 'Radio Labe');
    await tester.pump();

    await tester.ensureVisible(find.byKey(AddedItemForm.deleteKey));
    await tester.tap(find.byKey(AddedItemForm.deleteKey));
    await settle(tester);
    expect(_pack(c, id).addedReporters, isEmpty);
    await tester.tap(find.text('Undo').last);
    await settle(tester);
    expect(_pack(c, id).addedReporters.single.outlet, 'Radio Labe');
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('add a stadium to Czechia: its seats are bounded, it joins '
      "Czechia's group, and its name is per language", (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Grounds'));
    await pumpEditorRoute(tester, c, _at(EditorSection.stadiums, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Arena Labe');
    await tester.tap(find.byKey(AddedItemForm.nationKey));
    await settle(tester);
    await _pick(tester, 'czech', '$cze');
    await tester.enterText(find.byKey(AddedItemForm.cityKey), 'Decin');
    await tester.ensureVisible(find.byKey(AddedItemForm.capacityKey));
    await tester.enterText(find.byKey(AddedItemForm.capacityKey), '999');
    await tester.pump();
    expect(_addButton(tester).onPressed, isNull);
    // The range is said as help, and again as the error.
    expect(find.text('1,000 to 150,000 seats'), findsNWidgets(2));
    await tester.enterText(find.byKey(AddedItemForm.capacityKey), '18000');
    await tester.pump();
    expect(find.text('1,000 to 150,000 seats'), findsOneWidget);
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedStadiums, [
      PackStadium(
        id: _base,
        nationId: cze,
        name: 'Arena Labe',
        city: 'Decin',
        capacity: 18000,
      ),
    ]);

    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'labe');
    await tester.pump();
    final row = find.byKey(
      NameSectionScreen.rowKey(PackPaths.addedStadium(_base)),
    );
    expect(row, findsOneWidget);
    expect(
      find.descendant(of: row, matching: find.byKey(AddedItemForm.tagKey)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: row, matching: find.textContaining('18,000')),
      findsOneWidget,
    );

    // A second one of that name in Czechia is refused.
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.tap(find.byKey(AddedItemForm.nationKey));
    await settle(tester);
    await _pick(tester, 'czech', '$cze');
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'arena labe');
    await tester.pump();
    expect(
      find.text('Czechia already has an added stadium of this name.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(editorFormSheetCloseKey));
    await settle(tester);

    // In Czech, the added row edits only its name there.
    await tester.tap(find.byKey(EditorLanguageChip.chipKey));
    await settle(tester);
    await tester.tap(find.byKey(EditorLanguageChip.optionKey('cs')));
    await settle(tester);
    expect(find.byKey(NameSectionScreen.addKey), findsNothing);
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'labe');
    await tester.pump();
    await tester.tap(row);
    await settle(tester);
    expect(find.byKey(AddedItemForm.deleteKey), findsNothing);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Aréna Labe');
    await tester.pump();
    expect(_pack(c, id).localized[PackPaths.addedStadium(_base)], {
      'cs': 'Aréna Labe',
    });
    expect(_pack(c, id).addedStadiums.single.name, 'Arena Labe');
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the forms fit at the largest text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Big'));
    for (final section in [EditorSection.press, EditorSection.stadiums]) {
      await pumpEditorRoute(tester, c, _at(section, id));
      await tester.tap(find.byKey(NameSectionScreen.addKey));
      await settle(tester);
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byKey(AddedItemForm.nameKey), 'X' * 40);
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(editorFormSheetCloseKey));
      await settle(tester);
    }
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render, $size', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(
        tester,
        c,
        testPack('Tablet').copyWith(
          addedReporters: const [
            PackAddedReporter(id: _base, name: 'Mira Holcova', outlet: 'Labe'),
          ],
          addedStadiums: [
            PackStadium(
              id: _base + 1,
              nationId: cze,
              name: 'Arena Labe',
              city: 'Decin',
              capacity: 18000,
            ),
          ],
        ),
      );
      for (final (section, path, query) in [
        (EditorSection.press, PackPaths.addedReporter(_base), 'Mira'),
        (EditorSection.stadiums, PackPaths.addedStadium(_base + 1), 'Labe'),
      ]) {
        await pumpEditorRoute(tester, c, _at(section, id), size: size);
        expect(tester.takeException(), isNull);
        expect(find.byKey(NameSectionScreen.tabletLayoutKey), findsOneWidget);
        await tester.enterText(find.byKey(NameSectionScreen.searchKey), query);
        await tester.pump();
        // The added item edits beside the list.
        await tester.tap(find.byKey(NameSectionScreen.rowKey(path)));
        await settle(tester);
        expect(find.byKey(AddedItemForm.deleteKey), findsOneWidget);
        expect(tester.takeException(), isNull);
        // Deleting it beside the list, then Undo, brings it back.
        await tester.ensureVisible(find.byKey(AddedItemForm.deleteKey));
        await tester.tap(find.byKey(AddedItemForm.deleteKey));
        await settle(tester);
        final p = _pack(c, id);
        expect(
          section == EditorSection.press ? p.addedReporters : p.addedStadiums,
          isEmpty,
        );
        c.read(packEditorProvider(id).notifier).undo();
        await settle(tester);
        // Add opens its form in a dialog.
        await tester.tap(find.byKey(NameSectionScreen.addKey));
        await settle(tester);
        expect(find.byKey(AddedItemForm.addKey), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tapAt(const Offset(4, 4));
        await settle(tester);
      }
      expect(_pack(c, id).addedReporters, hasLength(1));
      expect(_pack(c, id).addedStadiums, hasLength(1));
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}
