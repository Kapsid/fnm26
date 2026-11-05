import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/editor_ui.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';
import '../helpers/test_database.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(NameSection s, int id, {int? nation}) =>
    editorSectionLocation(s.editorSection, id, nationId: nation);

/// Closes the phone's edit sheet.
Future<void> _done(WidgetTester tester) async {
  await tester.tap(find.byKey(NameEditForm.doneKey));
  await settle(tester);
}

void main() {
  final cze = nationIdOf('CZE');

  testWidgets('rename a club and reset it', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Clubs'));
    final club = ClubService.leagueClubs('cze').first;
    await pumpEditorRoute(tester, c, _at(NameSection.clubs, id));
    expect(find.byType(NameSectionScreen), findsOneWidget);

    // The search finds a club by its name, and by its country.
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'czechia');
    await tester.pump();
    expect(find.byKey(NameSectionScreen.rowKey(club)), findsOneWidget);
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);

    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Pražští Sokoli');
    await tester.pump();
    expect(_pack(c, id).clubs, {club: 'Pražští Sokoli'});

    // Typing the game's own name back is no change at all.
    await tester.enterText(find.byKey(NameEditForm.nameKey), club);
    await tester.pump();
    expect(_pack(c, id).clubs, isEmpty);

    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Pražští Sokoli');
    await tester.pump();
    await _done(tester);
    final row = find.byKey(NameSectionScreen.rowKey(club));
    expect(
      find.descendant(of: row, matching: find.text('Pražští Sokoli')),
      findsOneWidget,
    );

    await tester.tap(row);
    await settle(tester);
    await tester.tap(find.byKey(NameEditForm.resetKey));
    await tester.pump();
    expect(_pack(c, id).clubs, isEmpty);
    expect(
      tester
          .widget<TextField>(find.byKey(NameEditForm.nameKey))
          .controller!
          .text,
      club,
    );
    await _done(tester);
    expect(
      find.descendant(of: row, matching: find.text('Pražští Sokoli')),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("renaming Czechia's code to an existing code is refused with a "
      'message', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Codes'));
    await pumpEditorRoute(tester, c, _at(NameSection.nations, id, nation: cze));
    await tester.tap(find.byKey(NameSectionScreen.rowKey('$cze')));
    await settle(tester);

    // Typed in lower case, it comes out in capitals.
    await tester.enterText(find.byKey(NameEditForm.codeKey), 'ger');
    await tester.pump();
    expect(
      tester
          .widget<TextField>(find.byKey(NameEditForm.codeKey))
          .controller!
          .text,
      'GER',
    );
    expect(
      find.text(enL.editorNamesCodeTaken('GER', 'Germany')),
      findsOneWidget,
    );
    expect(_pack(c, id).nations, isEmpty);

    // Too short is refused too.
    await tester.enterText(find.byKey(NameEditForm.codeKey), 'CZ');
    await tester.pump();
    expect(find.text(enL.editorIssueCode), findsOneWidget);
    expect(_pack(c, id).nations, isEmpty);

    // A free code saves, with the name, as one edit.
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Bohemia');
    await tester.pump();
    expect(_pack(c, id).nations, isEmpty, reason: 'code still bad');
    await tester.enterText(find.byKey(NameEditForm.codeKey), 'BOH');
    await tester.pump();
    expect(_pack(c, id).nations, {cze: (name: 'Bohemia', code: 'BOH')});
    // Code alone: the name stays the game's, stored blank so it is still
    // translated.
    await tester.enterText(find.byKey(NameEditForm.nameKey), '');
    await tester.pump();
    expect(_pack(c, id).nations, {cze: (name: '', code: 'BOH')});
    final editor = c.read(packEditorProvider(id).notifier)..undo();
    expect(_pack(c, id).nations, isEmpty);
    expect(editor.canUndo, isFalse);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('competitions list shows Czech names in Czech', (tester) async {
    final cs = lookupAppLocalizations(const Locale('cs'));
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Cups'));
    await pumpEditorRoute(
      tester,
      c,
      _at(NameSection.competitions, id),
      locale: const Locale('cs'),
    );
    final euro = ContinentalCups.byConfederation[Confederation.europe]!.name;
    final row = find.byKey(NameSectionScreen.rowKey(euro));
    expect(
      find.descendant(
        of: row,
        matching: find.text(cs.compEuropeanChampionship),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(NameSectionScreen.rowKey('World Championship')),
        matching: find.text(cs.compWorldCup),
      ),
      findsOneWidget,
    );
    // Said once: a custom name is the same in every language.
    expect(find.text(cs.editorNamesEveryLanguage), findsOneWidget);

    await tester.tap(row);
    await settle(tester);
    await tester.enterText(
      find.byKey(NameEditForm.nameKey),
      'Pohár Hamburgerů',
    );
    await tester.pump();
    expect(_pack(c, id).competitions, {euro: 'Pohár Hamburgerů'});
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('name lists under 20 entries show as missing', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Names'));
    await pumpEditorRoute(
      tester,
      c,
      _at(NameSection.nameLists, id, nation: cze),
    );
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    await tester.tap(row);
    await settle(tester);

    // Commas and new lines both split; blanks and spaces go.
    final first = [for (var i = 0; i < 18; i++) 'First$i'];
    await tester.enterText(
      find.byKey(NameEditForm.firstNamesKey),
      '${first.take(9).join(', ')},,\n  ${first.skip(9).join('\n')}\n',
    );
    await tester.pump();
    await tester.enterText(
      find.byKey(NameEditForm.surnamesKey),
      [for (var i = 0; i < 25; i++) 'Sur$i'].join(', '),
    );
    await tester.pump();
    expect(find.text(enL.editorNamesFirstCount(18, 20)), findsOneWidget);
    expect(find.text(enL.editorNamesSurCount(25, 20)), findsOneWidget);

    // Saved all the same, and the pack says what it lacks.
    final lists = _pack(c, id).nameLists[cze]!;
    expect(lists.first, first);
    expect(lists.sur, hasLength(25));
    final issues = c.read(packEditorProvider(id).notifier).issues;
    expect(
      issues.whereType<BadField>().map((i) => (i.path, i.reason)),
      contains(('nameLists.$cze.first', FieldReason.outOfRange)),
    );

    await _done(tester);
    expect(
      find.descendant(of: row, matching: find.text(enL.editorCountToFix(1))),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("a Y account cannot take another account's name", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Y'));
    final [a, b, ...] = YFeed.namedAccounts;
    await pumpEditorRoute(tester, c, _at(NameSection.yAccounts, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), a);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(a)));
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.nameKey), b);
    await tester.pump();
    expect(find.text(enL.editorNamesTaken), findsOneWidget);
    expect(_pack(c, id).yAccounts, isEmpty);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Fresh Voice');
    await tester.pump();
    expect(_pack(c, id).yAccounts, {a: 'Fresh Voice'});
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a reporter renamed keeps his outlet', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Press'));
    final r = Press.reporters.first;
    await pumpEditorRoute(tester, c, _at(NameSection.press, id));
    await tester.tap(find.byKey(NameSectionScreen.rowKey('${r.index}')));
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Jana Nová');
    await tester.pump();
    expect(_pack(c, id).reporters, {
      r.index: PackReporter(name: 'Jana Nová', outlet: r.outlet),
    });
    await tester.pump(const Duration(milliseconds: 450));
  });

  test("the game's name lists are the whole pool new players are drawn "
      'from', () async {
    final lists = await AssetSeedSource(rootBundle).nameLists();
    final db = createTestDatabase();
    addTearDown(db.close);
    final pool = (await DriftPlayerRepository(db).currentPoolOf(cze))!;
    final raw = lists[cze]!;
    // A nation with extras: the pool is more than the classic lists.
    expect(raw.firstMore.where((n) => !raw.first.contains(n)), isNotEmpty);
    expect(raw.surMore.where((n) => !raw.sur.contains(n)), isNotEmpty);
    final entry = nameGroups(
      NameSection.nameLists,
      enL,
      realNations,
      lists: lists,
    ).single.entries.firstWhere((e) => e.key == '$cze');
    expect(entry.firstNames, pool.first);
    expect(entry.surnames, pool.sur);
    expect(namePoolOf(raw).first, pool.first);
    expect(namePoolOf(raw).sur, pool.sur);
  });

  testWidgets('adding one name keeps the whole pool plus that name', (
    tester,
  ) async {
    late Map<int, NameLists> lists;
    await tester.runAsync(() async {
      lists = await AssetSeedSource(rootBundle).nameLists();
    });
    final pool = namePoolOf(lists[cze]!);
    final c = await editorContainer(
      tester,
      overrides: [editorNameListsProvider.overrideWith((ref) async => lists)],
    );
    final id = await insertPack(tester, c, testPack('Pool'));
    await pumpEditorRoute(
      tester,
      c,
      _at(NameSection.nameLists, id, nation: cze),
    );
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    expect(
      find.descendant(
        of: row,
        matching: find.text(
          enL.editorNamesListCounts(pool.first.length, pool.sur.length),
        ),
      ),
      findsOneWidget,
    );
    await tester.tap(row);
    await settle(tester);
    final field = find.byKey(NameEditForm.firstNamesKey);
    final text = tester.widget<TextField>(field).controller!.text;
    await tester.enterText(field, '$text, Zbyhněv');
    await tester.pump();
    final saved = _pack(c, id).nameLists[cze]!;
    expect(saved.first, [...pool.first, 'Zbyhněv']);
    expect(saved.sur, pool.sur);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('typing the game name over a rename is the reset, and undo '
      'brings the rename back into the open sheet', (tester) async {
    final club = ClubService.leagueClubs('cze').first;
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Back').copyWith(clubs: {club: 'Sokoli'}),
    );
    await pumpEditorRoute(tester, c, _at(NameSection.clubs, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'Sokoli');
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);
    final name = find.byKey(NameEditForm.nameKey);
    expect(tester.widget<TextField>(name).controller!.text, 'Sokoli');

    await tester.enterText(name, club);
    await tester.pump();
    expect(_pack(c, id).clubs, isEmpty);

    // Never lost for good: one undo, and the sheet shows it again.
    c.read(packEditorProvider(id).notifier).undo();
    await tester.pump();
    expect(_pack(c, id).clubs, {club: 'Sokoli'});
    expect(tester.widget<TextField>(name).controller!.text, 'Sokoli');
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a code-only change keeps the English game name in English', (
    tester,
  ) async {
    final en = await editorContainer(tester);
    final id = await insertPack(tester, en, testPack('Code'));
    await pumpEditorRoute(
      tester,
      en,
      _at(NameSection.nations, id, nation: cze),
    );
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    await tester.tap(row);
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.codeKey), 'BOH');
    await tester.pump();
    expect(_pack(en, id).nations, {cze: (name: '', code: 'BOH')});
    await _done(tester);
    for (final text in ['Czechia', 'BOH']) {
      expect(
        find.descendant(of: row, matching: find.text(text)),
        findsOneWidget,
      );
    }
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a code-only change shows the game name in Czech, in Czech', (
    tester,
  ) async {
    final cs = await editorContainer(
      tester,
      overrides: [uiLanguageCodeProvider.overrideWithValue('cs')],
    );
    final csId = await insertPack(
      tester,
      cs,
      testPack('Kód').copyWith(nations: {cze: (name: '', code: 'BOH')}),
    );
    final row = find.byKey(NameSectionScreen.rowKey('$cze'));
    await pumpEditorRoute(
      tester,
      cs,
      _at(NameSection.nations, csId, nation: cze),
      locale: const Locale('cs'),
    );
    final czech = cs
        .read(packEditorProvider(csId).notifier)
        .world
        .firstWhere((n) => n.id == cze)
        .name;
    expect(czech, isNot('Czechia'));
    for (final text in [czech, 'BOH']) {
      expect(
        find.descendant(of: row, matching: find.text(text)),
        findsOneWidget,
      );
    }
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a nation record with nothing in it is no change', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Blank').copyWith(nations: {cze: (name: ' ', code: '')}),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    final tile = find.byKey(PackHomeScreen.sectionKey(EditorSection.nations));
    await tester.scrollUntilVisible(tile, 200);
    expect(
      find.descendant(of: tile, matching: find.text(enL.editorCountChanged(0))),
      findsOneWidget,
    );
    expect(sectionTitle(enL, EditorSection.nations), isNotEmpty);
    await pumpEditorRoute(tester, c, _at(NameSection.nations, id, nation: cze));
    expect(
      find.descendant(
        of: find.byKey(NameSectionScreen.rowKey('$cze')),
        matching: find.text(enL.editorNamesChanged),
      ),
      findsNothing,
    );
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet layouts render, $size', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(tester, c, testPack('Tablet'));
      for (final s in NameSection.values) {
        final location = _at(s, id);
        await pumpEditorRoute(tester, c, location, size: size);
        expect(tester.takeException(), isNull, reason: location);
        expect(
          find.byKey(NameSectionScreen.tabletLayoutKey),
          findsOneWidget,
          reason: location,
        );
      }
      // The tablet edits the picked row beside the list.
      await pumpEditorRoute(
        tester,
        c,
        _at(NameSection.nations, id, nation: cze),
        size: size,
      );
      await tester.tap(find.byKey(NameSectionScreen.rowKey('$cze')));
      await settle(tester);
      expect(find.byKey(NameEditForm.codeKey), findsOneWidget);
      expect(find.byKey(NameEditForm.doneKey), findsNothing);
      await tester.enterText(find.byKey(NameEditForm.nameKey), 'Bohemia');
      await tester.pump();
      expect(_pack(c, id).nations[cze]?.name, 'Bohemia');
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}
