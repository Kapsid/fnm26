import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/club_strength_picker.dart';
import 'package:fnm/features/editor/names/name_edit_form.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/shared/widgets/club_stars.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

String _at(int id) => editorSectionLocation(EditorSection.clubs, id);

ClubStars _stars(WidgetTester tester, String key) => tester.widget<ClubStars>(
  find.descendant(
    of: find.byKey(NameSectionScreen.rowKey(key)),
    matching: find.byType(ClubStars),
  ),
);

Future<void> _pickCountry(
  WidgetTester tester,
  ProviderContainer c,
  int id,
  String code,
) async {
  await tester.tap(find.byKey(NameSectionScreen.countryFilterKey));
  await settle(tester);
  final nation = c
      .read(packEditorProvider(id).notifier)
      .world
      .firstWhere((n) => n.code.toLowerCase() == code);
  final option = find.byKey(NameSectionScreen.countryOptionKey(nation.code));
  final list = find.descendant(
    of: find.byType(ListView).last,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(option, 200, scrollable: list);
  await tester.tap(option);
  await settle(tester);
}

void main() {
  testWidgets('club rows show their stars, tinted when set by hand', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Stars'));
    final club = ClubService.leagueClubs('cze').last;
    await pumpEditorRoute(tester, c, _at(id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    var s = _stars(tester, club);
    expect(s.stars, 1);
    expect(s.accent, isFalse);

    c
        .read(packEditorProvider(id).notifier)
        .update((p) => NameEdits.withClubStrength(p, club, 4));
    await tester.pump();
    s = _stars(tester, club);
    expect(s.stars, 4);
    expect(s.accent, isTrue);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the strength picker opens under a language tab', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Lang'));
    final club = ClubService.leagueClubs('cze').last;
    c.read(editorLanguageProvider.notifier).state = 'cs';
    await pumpEditorRoute(tester, c, _at(id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);
    expect(find.byType(ClubStrengthPicker), findsOneWidget);
    final star = find.byKey(ClubStrengthPicker.starsKey(5));
    await tester.ensureVisible(star);
    await tester.tap(star);
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.clubStrengths, {club: 5});
    await tester.tap(find.byKey(NameEditForm.doneKey));
    await settle(tester);
    expect(_stars(tester, club).stars, 5);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the country filter narrows the list and combines with search', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Country'));
    await pumpEditorRoute(tester, c, _at(id));
    final cze = ClubService.leagueClubs('cze');
    final and = ClubService.leagueClubs('and');
    await _pickCountry(tester, c, id, 'cze');
    expect(find.byKey(NameSectionScreen.rowKey(cze.first)), findsOneWidget);
    expect(find.byKey(NameSectionScreen.rowKey(and.first)), findsNothing);

    // With a search that no club of the country has: nothing.
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), and.first);
    await tester.pump();
    expect(find.byKey(NameSectionScreen.rowKey(and.first)), findsNothing);
    expect(find.byKey(NameSectionScreen.rowKey(cze.first)), findsNothing);

    // Back to All countries: the search finds Andorra's.
    await tester.tap(find.byKey(NameSectionScreen.countryFilterKey));
    await settle(tester);
    await tester.tap(find.byKey(NameSectionScreen.countryAllKey));
    await settle(tester);
    expect(find.byKey(NameSectionScreen.rowKey(and.first)), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('tablet: the country filter narrows the list', (tester) async {
    final c = await editorContainer(tester, formFactor: FormFactor.tablet);
    final id = await insertPack(tester, c, testPack('TabletCountry'));
    await pumpEditorRoute(tester, c, _at(id), size: kTabletSizes.first);
    await _pickCountry(tester, c, id, 'and');
    final and = ClubService.leagueClubs('and');
    expect(find.byKey(NameSectionScreen.rowKey(and.first)), findsOneWidget);
    expect(
      find.byKey(
        NameSectionScreen.rowKey(ClubService.leagueClubs('cze').first),
      ),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('golden: the clubs list with stars and the country filter', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Golden'));
    await pumpEditorRoute(tester, c, _at(id));
    final club = ClubService.leagueClubs('cze').first;
    c
        .read(packEditorProvider(id).notifier)
        .update((p) => NameEdits.withClubStrength(p, club, 2));
    await _pickCountry(tester, c, id, 'cze');
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/editor_clubs.png'),
    );
    await tester.pump(const Duration(milliseconds: 450));
  });
}
