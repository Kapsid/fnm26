import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/services/federation/sponsor_industries.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(EditorSection s, int id) => editorSectionLocation(s, id);

Future<void> _openRow(WidgetTester tester, String key) async {
  await tester.enterText(find.byKey(NameSectionScreen.searchKey), key);
  await tester.pump();
  await tester.tap(find.byKey(NameSectionScreen.rowKey(key)));
  await settle(tester);
}

Future<void> _pick(WidgetTester tester, String query, String option) async {
  await tester.enterText(find.byKey(AddedItemForm.pickerSearchKey), query);
  await tester.pump();
  await tester.tap(find.byKey(AddedItemForm.optionKey(option)));
  await settle(tester);
}

void main() {
  final l = enL;

  testWidgets("a game sponsor's industry is picked, and its own takes the "
      'override away', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Sponsors'));
    await pumpEditorRoute(tester, c, _at(EditorSection.sponsors, id));
    const brand = SponsorBrand.miners;
    await _openRow(tester, brand.name);
    final field = find.byKey(NameEditForm.industryKey);
    expect(
      find.descendant(
        of: field,
        matching: find.text(builtInIndustryLabel(l, brand)),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(field);
    await tester.tap(field);
    await settle(tester);
    final coffee = extraIndustryLabel(l, SponsorIndustry.coffee);
    await _pick(tester, coffee, SponsorIndustry.coffee.id);
    expect(_pack(c, id).sponsorIndustries, {
      brand.name: SponsorIndustry.coffee.id,
    });
    expect(
      find.descendant(of: field, matching: find.text(coffee)),
      findsOneWidget,
    );
    // Undo, like every edit.
    c.read(packEditorProvider(id).notifier).undo();
    await settle(tester);
    expect(_pack(c, id).sponsorIndustries, isEmpty);

    // Back on the brand's own trade: no override at all.
    await tester.ensureVisible(field);
    await tester.tap(field);
    await settle(tester);
    await _pick(tester, coffee, SponsorIndustry.coffee.id);
    await tester.tap(field);
    await settle(tester);
    final own = builtInIndustryLabel(l, brand);
    final option = industryOptions(l).firstWhere((o) => o.label == own);
    await _pick(tester, own, option.brand);
    expect(_pack(c, id).sponsorIndustries, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("a game Y account's handle: checked, saved, cleared", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Y'));
    final [a, b, ...] = YFeed.namedAccounts;
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await _openRow(tester, a);
    final field = find.byKey(NameEditForm.handleKey);
    await tester.ensureVisible(field);

    await tester.enterText(field, 'two words');
    await tester.pump();
    expect(find.text(l.editorHandleBadCharacters), findsOneWidget);
    expect(_pack(c, id).yHandles, isEmpty);

    // Another account's handle, in any case.
    await tester.enterText(
      field,
      YFeed.defaultHandle(b).substring(1).toLowerCase(),
    );
    await tester.pump();
    expect(find.text(l.editorHandleTaken), findsOneWidget);
    expect(_pack(c, id).yHandles, isEmpty);

    await tester.enterText(field, 'Fuck');
    await tester.pump();
    expect(find.text(l.editorNameNotAllowed), findsOneWidget);
    expect(_pack(c, id).yHandles, isEmpty);

    // A leading @ is the field's own, not the handle's.
    await tester.enterText(field, '@Fresh_Voice9');
    await tester.pump();
    expect(_pack(c, id).yHandles, {a: 'Fresh_Voice9'});

    await tester.enterText(field, '');
    await tester.pump();
    expect(_pack(c, id).yHandles, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an added Y account takes a handle when added, and changes it '
      'when edited', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Added Y'));
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Grill Fan');
    final handle = find.byKey(AddedItemForm.handleKey);
    await tester.ensureVisible(handle);
    await tester.enterText(
      handle,
      YFeed.defaultHandle(YFeed.namedAccounts.first).substring(1),
    );
    await tester.pump();
    expect(find.text(l.editorHandleTaken), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byKey(AddedItemForm.addKey)).onPressed,
      isNull,
    );
    await tester.enterText(handle, 'GrillFan');
    await tester.pump();
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    final added = _pack(c, id).addedYAccounts.single;
    expect(added.name, 'Grill Fan');
    expect(added.handle, 'GrillFan');
    expect(added.voice, YVoice.fan);

    // Edited from its row: the handle changes alone, and empty goes back
    // to the one the name gives.
    await tester.tap(
      find.byKey(
        NameSectionScreen.rowKey(NameSection.yAccounts.addedKey(added.id)),
      ),
    );
    await settle(tester);
    await tester.ensureVisible(handle);
    expect(tester.widget<HandleField>(handle).controller.text, 'GrillFan');
    await tester.enterText(handle, 'Grill_2');
    await tester.pump();
    expect(_pack(c, id).addedYAccounts.single.handle, 'Grill_2');
    await tester.enterText(handle, '');
    await tester.pump();
    expect(_pack(c, id).addedYAccounts.single.handle, isNull);
    expect(_pack(c, id).addedYAccounts.single.name, 'Grill Fan');
    await tester.pump(const Duration(milliseconds: 450));
  });
}
