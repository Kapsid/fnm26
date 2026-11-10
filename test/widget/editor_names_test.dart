import 'dart:async';

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
import 'package:fnm/features/editor/names/added_items.dart'
    show editorFormSheetCloseKey;
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/pack_issue_text.dart';

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

  testWidgets('the name lists sheet can be left with the keyboard up', (
    tester,
  ) async {
    // Owner report: in Czech, editing a nation's name lists on a phone left
    // no way out. With the keyboard up the tall sheet filled the screen: the
    // back arrow and the drag handle went under the status bar and Done
    // under the keyboard.
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Names'));
    await pumpEditorRoute(
      tester,
      c,
      _at(NameSection.nameLists, id, nation: cze),
      locale: const Locale('cs'),
    );
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey('$cze')));
    await settle(tester);
    await tester.showKeyboard(find.byKey(NameEditForm.firstNamesKey));
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await settle(tester);

    final close = find.byKey(editorFormSheetCloseKey);
    expect(close, findsOneWidget);
    final rect = tester.getRect(close);
    expect(rect.top, greaterThanOrEqualTo(47), reason: 'under the status bar');
    expect(rect.bottom, lessThanOrEqualTo(844 - 336), reason: 'under keys');

    // Done scrolls into view above the keys.
    await tester.ensureVisible(find.byKey(NameEditForm.doneKey));
    await settle(tester);
    final done = tester.getRect(find.byKey(NameEditForm.doneKey));
    expect(done.bottom, lessThanOrEqualTo(844 - 336), reason: 'Done hidden');

    // The multi-line keyboard has no key that closes it: a tap outside the
    // field does.
    bool focused() => tester
        .widget<EditableText>(
          find.descendant(
            of: find.byKey(NameEditForm.firstNamesKey),
            matching: find.byType(EditableText),
          ),
        )
        .focusNode
        .hasFocus;
    await tester.ensureVisible(find.byKey(NameEditForm.firstNamesKey));
    await settle(tester);
    await tester.tap(find.byKey(NameEditForm.firstNamesKey));
    await tester.pump();
    expect(focused(), isTrue);
    await tester.tapAt(tester.getTopLeft(close) + const Offset(-60, 10));
    await tester.pump();
    expect(focused(), isFalse);

    await tester.tap(close);
    await settle(tester);
    expect(find.byKey(NameEditForm.firstNamesKey), findsNothing);

    // And the screen's own back arrow leads home.
    tester.view.resetViewInsets();
    await settle(tester);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await settle(tester);
    expect(
      c.read(routerProvider).routerDelegate.currentConfiguration.uri.path,
      Routes.editorPack,
    );
  });

  testWidgets("a league club cannot be renamed onto an added club's name", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final club = ClubService.leagueClubs('cze').first;
    final id = await insertPack(
      tester,
      c,
      testPack('Clash').copyWith(
        addedClubs: const [
          PackClub(id: kPackAddedIdBase, name: 'FC Vltava', country: 'cze'),
        ],
      ),
    );
    await pumpEditorRoute(tester, c, _at(NameSection.clubs, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.nameKey), ' fc vltava');
    await tester.pump();
    expect(find.text(enL.editorNamesTaken), findsOneWidget);
    expect(_pack(c, id).clubs, isEmpty);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'FC Sázava');
    await tester.pump();
    expect(_pack(c, id).clubs, {club: 'FC Sázava'});
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

  /// Picks [code] (null: All languages) from the editor's language chip.
  Future<void> pickLanguage(WidgetTester tester, String? code) async {
    await tester.tap(find.byKey(EditorLanguageChip.chipKey));
    await settle(tester);
    final option = find.byKey(EditorLanguageChip.optionKey(code));
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(EditorLanguageChip.listKey),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(option);
    await settle(tester);
  }

  testWidgets('picking Čeština shows Czech competition names and stores a '
      'cs value only', (tester) async {
    final cs = lookupAppLocalizations(const Locale('cs'));
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Lang'));
    final euro = ContinentalCups.byConfederation[Confederation.europe]!.name;
    await pumpEditorRoute(tester, c, _at(NameSection.competitions, id));
    final row = find.byKey(NameSectionScreen.rowKey(euro));
    expect(
      find.descendant(
        of: row,
        matching: find.text(enL.compEuropeanChampionship),
      ),
      findsOneWidget,
    );

    await pickLanguage(tester, 'cs');
    expect(c.read(editorLanguageProvider), 'cs');
    // The rows speak Czech; the screen around them stays English.
    expect(
      find.descendant(
        of: row,
        matching: find.text(cs.compEuropeanChampionship),
      ),
      findsOneWidget,
    );
    expect(find.text(enL.editorLanguageEditing('Čeština')), findsOneWidget);

    await tester.tap(row);
    await settle(tester);
    final name = find.byKey(NameEditForm.nameKey);
    // Empty: no Czech name of its own yet, the game's shows.
    expect(tester.widget<TextField>(name).controller!.text, isEmpty);
    await tester.enterText(name, 'Pohár Hamburgerů');
    await tester.pump();
    final pack = _pack(c, id);
    expect(pack.competitions, isEmpty);
    expect(pack.localized, {
      PackPaths.competition(euro): {'cs': 'Pohár Hamburgerů'},
    });
    await _done(tester);
    expect(
      find.descendant(of: row, matching: find.text('Pohár Hamburgerů')),
      findsOneWidget,
    );

    // Back on All languages, the main name is still the game's.
    await pickLanguage(tester, null);
    expect(
      find.descendant(
        of: row,
        matching: find.text(enL.compEuropeanChampionship),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: row, matching: find.textContaining('CS')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('clearing the cs value falls back to the main value', (
    tester,
  ) async {
    final club = ClubService.leagueClubs('cze').first;
    final path = PackPaths.club(club);
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Fallback').copyWith(
        clubs: {club: 'Main Club'},
        localized: {
          path: {'cs': 'Hlavní klub', 'de': 'Hauptklub'},
        },
      ),
    );
    c.read(editorLanguageProvider.notifier).state = 'cs';
    await pumpEditorRoute(tester, c, _at(NameSection.clubs, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    final row = find.byKey(NameSectionScreen.rowKey(club));
    expect(
      find.descendant(of: row, matching: find.text('Hlavní klub')),
      findsOneWidget,
    );
    await tester.tap(row);
    await settle(tester);
    final name = find.byKey(NameEditForm.nameKey);
    expect(tester.widget<TextField>(name).controller!.text, 'Hlavní klub');

    // Cleared: Czech has no name of its own; German keeps its.
    await tester.enterText(name, '');
    await tester.pump();
    expect(_pack(c, id).localized, {
      path: {'de': 'Hauptklub'},
    });
    expect(_pack(c, id).clubs, {club: 'Main Club'});
    // Typing the main name is no Czech name either.
    await tester.enterText(name, 'Main Club');
    await tester.pump();
    expect(_pack(c, id).localized, {
      path: {'de': 'Hauptklub'},
    });
    await _done(tester);
    expect(
      find.descendant(of: row, matching: find.text('Main Club')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: row,
        matching: find.textContaining(enL.editorLanguageSame),
      ),
      findsOneWidget,
    );

    // The last language gone, the path goes with it.
    c.read(editorLanguageProvider.notifier).state = 'de';
    await tester.pump();
    await tester.tap(row);
    await settle(tester);
    await tester.tap(find.byKey(NameEditForm.resetKey));
    await tester.pump();
    expect(_pack(c, id).localized, isEmpty);
    expect(_pack(c, id).clubs, {club: 'Main Club'});
    expect(c.read(packEditorProvider(id).notifier).issues, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));
  });

  test('renameIn and resetIn keep localized free of empty paths', () {
    final club = ClubService.leagueClubs('cze').first;
    final e = NameEntry(key: club, original: club, fold: club);
    final r = Press.reporters.first;
    final rep = NameEntry(
      key: '${r.index}',
      original: r.name,
      original2: r.outlet,
      fold: r.name,
    );
    var p = testPack('Unit');
    p = NameEdits.renameIn(NameSection.clubs, p, e, 'cs', ' Sokol ');
    expect(p.localized, {
      PackPaths.club(club): {'cs': 'Sokol'},
    });
    // The game's name typed with no main name is no value.
    p = NameEdits.renameIn(NameSection.clubs, p, e, 'cs', club);
    expect(p.localized, isEmpty);
    // A reporter's outlet alone.
    p = NameEdits.renameIn(NameSection.press, p, rep, 'ja', '', 'Nikkan');
    expect(p.localized, {
      PackPaths.reporterOutlet(r.index): {'ja': 'Nikkan'},
    });
    expect(
      NameEdits.resetIn(NameSection.press, p, rep, 'ja').localized,
      isEmpty,
    );
    // Reset under All languages: the main name and every language go.
    p = NameEdits.renameIn(NameSection.clubs, p, e, 'de', 'Falke');
    p = NameEdits.rename(NameSection.clubs, p, e, 'Sokoli');
    final reset = NameEdits.reset(NameSection.clubs, p, e);
    expect(reset.clubs, isEmpty);
    expect(reset.localized, {
      PackPaths.reporterOutlet(r.index): {'ja': 'Nikkan'},
    });
  });

  testWidgets("the game's language is unchanged after using the picker", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Game lang'));
    await pumpEditorRoute(tester, c, _at(NameSection.sponsors, id));
    expect(c.read(localeProvider), isNull);
    final before = c.read(uiLanguageCodeProvider);
    await pickLanguage(tester, 'de');
    await pickLanguage(tester, 'ja');
    expect(c.read(editorLanguageProvider), 'ja');
    expect(c.read(localeProvider), isNull);
    expect(c.read(uiLanguageCodeProvider), before);
    // The screen itself is still in English.
    expect(find.text(enL.editorSectionSponsors), findsOneWidget);
    // The same pick on the home, and none on the name lists.
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byKey(EditorLanguageChip.chipKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(EditorLanguageChip.chipKey),
        matching: find.text('JA'),
      ),
      findsOneWidget,
    );
    await pumpEditorRoute(tester, c, _at(NameSection.nameLists, id));
    expect(find.byKey(EditorLanguageChip.chipKey), findsNothing);
  });

  testWidgets('a Y account cannot take a name another account shows in '
      'that language', (tester) async {
    final c = await editorContainer(tester);
    final [a, b, ...] = YFeed.namedAccounts;
    final id = await insertPack(
      tester,
      c,
      testPack('Y lang').copyWith(
        localized: {
          PackPaths.yAccount(b): {'cs': 'Pepík'},
        },
      ),
    );
    c.read(editorLanguageProvider.notifier).state = 'cs';
    await pumpEditorRoute(tester, c, _at(NameSection.yAccounts, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), a);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(a)));
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Pepík');
    await tester.pump();
    expect(find.text(enL.editorNamesTaken), findsOneWidget);
    expect(_pack(c, id).localized.keys, [PackPaths.yAccount(b)]);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Pepa');
    await tester.pump();
    expect(_pack(c, id).localized[PackPaths.yAccount(a)], {'cs': 'Pepa'});
    await tester.pump(const Duration(milliseconds: 450));
  });

  test('every issue root opens the section that fixes it', () {
    const added = kPackAddedIdBase + 1;
    final table = <String, EditorSection>{
      'squads.1': EditorSection.players,
      'squads.1.800000001.name': EditorSection.players,
      'pools.1': EditorSection.players,
      'pools.1.800000001.traits': EditorSection.players,
      'nations.1.code': EditorSection.none,
      'clubs.Man Blue': EditorSection.clubs,
      'addedClubs': EditorSection.clubs,
      'addedClubs.$added': EditorSection.clubs,
      'addedClubs.$added.country': EditorSection.clubs,
      'addedClubs.$added.id': EditorSection.clubs,
      'stadiums.1:Praha': EditorSection.stadiums,
      'competitions.Copa': EditorSection.competitions,
      'yAccounts.someone': EditorSection.yAccounts,
      'addedYAccounts': EditorSection.yAccounts,
      'addedYAccounts.$added': EditorSection.yAccounts,
      'reporters.0.outlet': EditorSection.press,
      'nameLists.1.first.3': EditorSection.nameLists,
      'sponsors.Brand': EditorSection.sponsors,
      'addedSponsors': EditorSection.sponsors,
      'addedSponsors.$added': EditorSection.sponsors,
      'addedSponsors.$added.description': EditorSection.sponsors,
      'addedSponsors.$added.industry': EditorSection.sponsors,
      'trophies.x': EditorSection.trophies,
      // A translation sits with the text it translates.
      'localized.clubs.Man Blue.cs': EditorSection.clubs,
      'localized.addedClubs.$added.cs': EditorSection.clubs,
      'localized.stadiums.1:Praha.de': EditorSection.stadiums,
      'localized.competitions.Copa.cs': EditorSection.competitions,
      'localized.yAccounts.someone.cs': EditorSection.yAccounts,
      'localized.addedYAccounts.$added.cs': EditorSection.yAccounts,
      'localized.reporters.0.name.cs': EditorSection.press,
      'localized.sponsors.Brand.cs': EditorSection.sponsors,
      'localized.addedSponsors.$added.description.cs': EditorSection.sponsors,
      // The cap is the whole database's; a path naming nothing has no
      // section either.
      'localized': EditorSection.none,
      'localized.nonsense.cs': EditorSection.none,
      // Nothing the editor knows: the home, never a guess.
      'name': EditorSection.none,
      'somethingNew.3': EditorSection.none,
      '': EditorSection.none,
    };
    for (final MapEntry(:key, :value) in table.entries) {
      expect(EditorSection.ofPath(key), value, reason: key);
    }
    // A name clash opens where the clashing name is edited.
    for (final (path, section) in [
      ('addedClubs.$added', EditorSection.clubs),
      ('yAccounts.someone', EditorSection.yAccounts),
      ('addedYAccounts.$added', EditorSection.yAccounts),
      ('localized.yAccounts.someone.cs', EditorSection.yAccounts),
      ('localized.addedYAccounts.$added.cs', EditorSection.yAccounts),
    ]) {
      expect(
        EditorSection.ofPath(NameClash(path).where),
        section,
        reason: path,
      );
    }
  });

  test("a translation's issue says which language it needs", () {
    final club = ClubService.leagueClubs('cze').first;
    final pack = testPack('Lang issue').copyWith(
      localized: {
        PackPaths.club(club): {'cs': 'x' * 60},
      },
    );
    final issue = PackRules.issues(pack).firstWhere(
      (i) => i.where == 'localized.${PackPaths.club(club)}.cs',
    );
    final text = describePackIssue(enL, issue, pack, const {});
    expect(text.detail, contains('(${languageEndonym('cs')})'));
    expect(text.section, EditorSection.clubs);
  });

  testWidgets('a stale link to the old Nations section opens the home', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Stale nations'));
    await pumpEditorRoute(tester, c, '/editor/pack/nations?id=$id');
    expect(find.byType(PackHomeScreen), findsOneWidget);
    expect(
      c.read(routerProvider).routeInformationProvider.value.uri.toString(),
      editorPackLocation(id),
    );
  });

  testWidgets("leaving the editor forgets the editor's language", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Leave'));
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    await pickLanguage(tester, 'cs');
    // Within the editor it stays.
    c.read(routerProvider).go(_at(NameSection.clubs, id));
    await settle(tester);
    expect(c.read(editorLanguageProvider), 'cs');
    c.read(routerProvider).go(Routes.home);
    await settle(tester);
    expect(c.read(editorLanguageProvider), isNull);
  });

  testWidgets('a route change made while the tree builds forgets the '
      "editor's language after the build, not during it", (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Build'));
    final router = c.read(routerProvider)..go(editorPackLocation(id));
    final trigger = GlobalKey<_GoDuringBuildState>();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) => _GoDuringBuild(
            key: trigger,
            go: () => router.go(Routes.home),
            child: child!,
          ),
        ),
      ),
    );
    await settle(tester);
    c.read(editorLanguageProvider.notifier).state = 'cs';
    await settle(tester);
    expect(find.byKey(EditorLanguageChip.chipKey), findsOneWidget);

    trigger.currentState!.goNow();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(c.read(editorLanguageProvider), isNull);
    expect(find.byType(PackHomeScreen), findsNothing);
    // And back by the Back gesture of a pushed page: the same.
    router.go(editorPackLocation(id));
    await settle(tester);
    c.read(editorLanguageProvider.notifier).state = 'cs';
    unawaited(router.push(_at(NameSection.clubs, id)));
    await settle(tester);
    router.pop();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(c.read(editorLanguageProvider), 'cs');
  });

  for (final code in [null, 'cs', 'fil']) {
    testWidgets('the home app bar fits a 320 dp phone, language $code', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      const name = 'A rather long database name for a small phone';
      final id = await insertPack(tester, c, testPack(name));
      c.read(editorLanguageProvider.notifier).state = code;
      await pumpEditorRoute(
        tester,
        c,
        editorPackLocation(id),
        size: const Size(320, 640),
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(EditorLanguageChip.chipKey), findsOneWidget);
      final title = find.descendant(
        of: find.byType(AppBar),
        matching: find.text(name),
      );
      expect(title, findsOneWidget);
      // Room for a readable part of the name, not a sliver.
      expect(tester.getSize(title).width, greaterThanOrEqualTo(96));
      final bar = tester.getRect(find.byType(AppBar));
      expect(
        bar.contains(tester.getRect(find.byKey(PackHomeScreen.undoKey)).center),
        isTrue,
      );
    });
  }

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
      // The tablet edits the picked row beside the list, in the picked
      // language too.
      final club = ClubService.leagueClubs('cze').first;
      await pumpEditorRoute(tester, c, _at(NameSection.clubs, id), size: size);
      expect(find.byKey(EditorLanguageChip.chipKey), findsOneWidget);
      await pickLanguage(tester, 'cs');
      await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
      await tester.pump();
      await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
      await settle(tester);
      expect(find.byKey(NameEditForm.doneKey), findsNothing);
      await tester.enterText(find.byKey(NameEditForm.nameKey), 'Sokoli');
      await tester.pump();
      expect(_pack(c, id).localized[PackPaths.club(club)], {'cs': 'Sokoli'});
      expect(_pack(c, id).clubs, isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}

/// Calls [go] from inside its own build, once, after [goNow]: a route change
/// made while the tree is building.
class _GoDuringBuild extends StatefulWidget {
  const _GoDuringBuild({required this.go, required this.child, super.key});

  final VoidCallback go;
  final Widget child;

  @override
  State<_GoDuringBuild> createState() => _GoDuringBuildState();
}

class _GoDuringBuildState extends State<_GoDuringBuild> {
  bool _pending = false;

  void goNow() => setState(() => _pending = true);

  @override
  Widget build(BuildContext context) {
    if (_pending) {
      _pending = false;
      widget.go();
    }
    return widget.child;
  }
}
