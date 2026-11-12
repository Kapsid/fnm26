import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/editor_region_filter.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/players/nation_list_screen.dart';
import 'package:fnm/features/editor/players/nation_ranking.dart';
import 'package:fnm/features/editor/trophy_section_screen.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

final _en = AppLocalizationsEn();

Finder _chip(Confederation? c) =>
    find.byKey(EditorRegionChips.chipKey(c == null ? null : EditorRegion(c)));

Future<void> _tapChip(WidgetTester tester, Finder chip) async {
  await tester.ensureVisible(chip);
  await tester.pump();
  await tester.tap(chip);
  await tester.pump();
}

void main() {
  group('region filter', () {
    testWidgets('narrows the clubs by their nation, and holds across '
        'sections', (tester) async {
      final c = await editorContainer(tester);
      final id = await insertPack(tester, c, testPack('Regions'));
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.clubs, id),
      );
      final cze = ClubService.leagueClubs('cze').first;
      await tester.enterText(find.byKey(NameSectionScreen.searchKey), cze);
      await tester.pump();
      expect(find.byKey(NameSectionScreen.rowKey(cze)), findsOneWidget);

      await _tapChip(tester, _chip(Confederation.africa));
      expect(find.byKey(NameSectionScreen.rowKey(cze)), findsNothing);
      expect(
        c.read(editorRegionProvider),
        const EditorRegion(Confederation.africa),
      );

      await _tapChip(tester, _chip(Confederation.europe));
      expect(find.byKey(NameSectionScreen.rowKey(cze)), findsOneWidget);

      // The same filter on the nations: Europe's only.
      await pumpEditorRoute(tester, c, '${Routes.editorPlayers}?id=$id');
      expect(
        find.byKey(NationListScreen.nationKey(nationIdOf('CZE'))),
        findsOneWidget,
      );
      expect(
        find.byKey(NationListScreen.nationKey(nationIdOf('BRA'))),
        findsNothing,
      );
      await _tapChip(tester, _chip(null));
      expect(c.read(editorRegionProvider), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('competitions: a continent, or Worldwide for the rest', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      final id = await insertPack(tester, c, testPack('Comps'));
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.competitions, id),
      );
      const world = 'World Championship';
      const clash = 'Continental Clash';
      final worldwide = find.byKey(
        EditorRegionChips.chipKey(EditorRegion.worldwide),
      );
      expect(worldwide, findsOneWidget);

      await _tapChip(tester, worldwide);
      expect(find.byKey(NameSectionScreen.rowKey(world)), findsOneWidget);
      expect(find.byKey(NameSectionScreen.rowKey(clash)), findsOneWidget);

      await _tapChip(tester, _chip(Confederation.asia));
      expect(find.byKey(NameSectionScreen.rowKey(world)), findsNothing);
      expect(find.text(_en.confAsia), findsWidgets);
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('press: nothing belongs to a continent', (tester) async {
      final c = await editorContainer(tester);
      final id = await insertPack(tester, c, testPack('Press'));
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.press, id),
      );
      await _tapChip(tester, _chip(Confederation.europe));
      expect(find.text(_en.editorRegionNone), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('trophies: a continent shows its own', (tester) async {
      final c = await editorContainer(tester);
      final id = await insertPack(tester, c, testPack('Cups'));
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.trophies, id),
      );
      expect(find.byKey(TrophySectionScreen.tileKey('world')), findsOneWidget);
      await _tapChip(tester, _chip(Confederation.asia));
      expect(find.byKey(TrophySectionScreen.tileKey('asia')), findsOneWidget);
      expect(find.byKey(TrophySectionScreen.tileKey('world')), findsNothing);
      expect(find.byKey(TrophySectionScreen.tileKey('europe')), findsNothing);
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('tablet: the chips wrap beside the list', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(tester, c, testPack('TabletRegions'));
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.stadiums, id),
        size: kTabletSizes.first,
      );
      expect(find.byType(Wrap), findsWidgets);
      await _tapChip(tester, _chip(Confederation.oceania));
      expect(
        c.read(editorRegionProvider),
        const EditorRegion(Confederation.oceania),
      );
      await tester.pump(const Duration(milliseconds: 450));
    });
  });

  group('world ranking', () {
    Future<void> setPlace(WidgetTester tester, String text) async {
      await tester.tap(find.byKey(NationRankingTile.tileKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(NationRankingTile.fieldKey), text);
      await tester.tap(find.byKey(NationRankingTile.saveKey));
      await tester.pumpAndSettle();
    }

    for (final tablet in [false, true]) {
      testWidgets('is set and cleared on the squad screen '
          '(${tablet ? 'tablet' : 'phone'})', (tester) async {
        final c = await editorContainer(
          tester,
          formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
        );
        final cze = nationIdOf('CZE');
        final id = await insertPack(
          tester,
          c,
          testPack('Rank', squads: {cze: testSquad()}),
        );
        await pumpEditorRoute(
          tester,
          c,
          editorSquadLocation(id, cze),
          size: tablet ? kTabletSizes.first : kPhoneSize,
        );
        expect(find.byKey(NationRankingTile.tileKey), findsOneWidget);

        // Out of range: refused in the dialog, nothing stored.
        final max = c.read(packEditorProvider(id).notifier).world.length;
        await tester.tap(find.byKey(NationRankingTile.tileKey));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(NationRankingTile.fieldKey),
          '${max + 1}',
        );
        await tester.tap(find.byKey(NationRankingTile.saveKey));
        await tester.pumpAndSettle();
        expect(find.text(_en.editorIssueRanking(1, max)), findsOneWidget);
        await tester.tap(find.text(_en.editorCancel));
        await tester.pumpAndSettle();
        expect(c.read(packEditorProvider(id)).value!.rankings, isEmpty);

        await setPlace(tester, '3');
        expect(c.read(packEditorProvider(id)).value!.rankings, {cze: 3});
        expect(find.text(_en.editorRankingPlace(3)), findsOneWidget);

        // Undo takes it back, as any edit.
        c.read(packEditorProvider(id).notifier).undo();
        await tester.pump();
        expect(c.read(packEditorProvider(id)).value!.rankings, isEmpty);

        await setPlace(tester, '7');
        await tester.tap(find.byKey(NationRankingTile.tileKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(NationRankingTile.autoKey));
        await tester.pumpAndSettle();
        expect(c.read(packEditorProvider(id)).value!.rankings, isEmpty);
        await tester.pump(const Duration(milliseconds: 450));
      });
    }
  });
}
