import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/editor/names/club_strength_picker.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/shared/widgets/club_stars.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(int id) => editorSectionLocation(EditorSection.clubs, id);

const _base = kPackAddedIdBase;

/// The stars a club row shows.
int _rowStars(WidgetTester tester, String key) => tester
    .widget<ClubStars>(
      find.descendant(
        of: find.byKey(NameSectionScreen.rowKey(key)),
        matching: find.byType(ClubStars),
      ),
    )
    .stars;

Future<void> _tapChoice(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.tap(find.byKey(key));
  await tester.pump();
}

void main() {
  group('AddedEdits and NameEdits', () {
    final pack = testPack('Unit');

    test('a game club\'s strength is set and cleared', () {
      final p = NameEdits.withClubStrength(pack, 'Man Blue', 2);
      expect(p.clubStrengths, {'Man Blue': 2});
      expect(NameEdits.withClubStrength(p, 'Man Blue', null).clubStrengths, isEmpty);
      expect(
        identical(NameEdits.withClubStrength(p, 'Man Blue', 2), p),
        isTrue,
      );
    });

    test('an added club keeps its strength through a rename', () {
      var p = AddedEdits.addClub(pack, 'FC Vltava', 'cze', strength: 4);
      expect(p.addedClubs.single.strength, 4);
      p = AddedEdits.renameClub(p, _base, 'Vltava United');
      expect(p.addedClubs.single.strength, 4);
      p = AddedEdits.setClubStrength(p, _base, null);
      expect(p.addedClubs.single.strength, isNull);
    });

    test('every country of the game lists its clubs in the editor', () {
      for (final code in ['and', 'cro', 'fij', 'zan', 'cze']) {
        expect(
          ClubService.leagueClubs(code).length,
          greaterThanOrEqualTo(5),
          reason: code,
        );
      }
    });
  });

  testWidgets('a league club\'s strength is set in its form and shown on its '
      'row; Default clears it', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Strength'));
    final club = ClubService.leagueClubs('cze').last; // FC Blšany, 1 star
    await pumpEditorRoute(tester, c, _at(id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    expect(_rowStars(tester, club), 1);

    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);
    expect(find.byType(ClubStrengthPicker), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(ClubStrengthPicker.defaultKey))
          .selected,
      isTrue,
    );
    await _tapChoice(tester, ClubStrengthPicker.starsKey(4));
    expect(_pack(c, id).clubStrengths, {club: 4});
    await _tapChoice(tester, ClubStrengthPicker.defaultKey);
    expect(_pack(c, id).clubStrengths, isEmpty);
    await _tapChoice(tester, ClubStrengthPicker.starsKey(3));
    await tester.tap(find.byKey(NameEditForm.doneKey));
    await settle(tester);
    expect(_rowStars(tester, club), 3);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a new club of the editor\'s gets a strength as it is added, and '
      'keeps it when edited', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Added'));
    await pumpEditorRoute(tester, c, _at(id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'FC Vltava');
    await tester.tap(find.byKey(AddedItemForm.countryKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.pickerSearchKey), 'czech');
    await tester.pump();
    await tester.tap(find.byKey(AddedItemForm.optionKey('cze')));
    await settle(tester);
    await _tapChoice(tester, ClubStrengthPicker.starsKey(5));
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedClubs.single.strength, 5);

    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'vltava');
    await tester.pump();
    final key = PackPaths.addedClub(_base);
    expect(_rowStars(tester, key), 5);
    await tester.tap(find.byKey(NameSectionScreen.rowKey(key)));
    await settle(tester);
    await _tapChoice(tester, ClubStrengthPicker.starsKey(2));
    expect(_pack(c, id).addedClubs.single.strength, 2);
    await _tapChoice(tester, ClubStrengthPicker.defaultKey);
    expect(_pack(c, id).addedClubs.single.strength, isNull);
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet: the strength is set beside the list, $size', (
      tester,
    ) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(tester, c, testPack('Tablet'));
      // A club of a league new in 1.1.x: Andorra's.
      final club = ClubService.leagueClubs('and').first;
      await pumpEditorRoute(tester, c, _at(id), size: size);
      expect(find.byKey(NameSectionScreen.tabletLayoutKey), findsOneWidget);
      await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
      await tester.pump();
      await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
      await settle(tester);
      await _tapChoice(tester, ClubStrengthPicker.starsKey(2));
      expect(_pack(c, id).clubStrengths, {club: 2});
      expect(_rowStars(tester, club), 2);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}
