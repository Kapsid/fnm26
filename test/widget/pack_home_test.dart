import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets("a pack with a 22-man nation shows '1 thing missing' and the "
      'jump opens that nation', (tester) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Short', squads: {cze: testSquad(mid: 7)}),
    );
    await pumpEditorRoute(tester, c, Routes.editor);

    expect(find.text(enL.editorStatusMissing(1)), findsOneWidget);

    await tester.tap(find.byKey(EditorListScreen.editKey(id)));
    await settle(tester);
    expect(find.byType(PackHomeScreen), findsOneWidget);
    expect(find.byKey(PackHomeScreen.notReadyKey), findsOneWidget);

    final issue = find.byKey(PackHomeScreen.issueKey(0));
    expect(
      find.descendant(of: issue, matching: find.text('Czechia')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: issue,
        matching: find.text(enL.editorIssuePlayersShort(1)),
      ),
      findsOneWidget,
    );
    expect(find.byKey(PackHomeScreen.issueKey(1)), findsNothing);

    await tester.ensureVisible(issue);
    await tester.tap(issue);
    await settle(tester);

    // The players section opened on a nation is that nation's squad, pushed
    // over the database home so back returns there.
    final screen = tester.widget<SquadScreen>(find.byType(SquadScreen));
    expect(screen.packId, id);
    expect(screen.nationId, cze);
    expect(find.text('Czechia'), findsWidgets);
    expect(find.text(enL.editorIssuePlayersShort(1)), findsOneWidget);
  });

  testWidgets('undo reverts the last edit', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Before'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    expect(find.byType(PackHomeScreen), findsOneWidget);

    final editor = c.read(packEditorProvider(id).notifier);
    expect(editor.canUndo, isFalse);
    editor
      ..update((p) => p.copyWith(name: 'First'))
      ..update((p) => p.copyWith(name: 'Second'));
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'Second');
    expect(find.text('Second'), findsWidgets);

    // The bar's undo goes back one edit at a time.
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'First');
    editor.undo();
    await tester.pump();
    expect(c.read(packEditorProvider(id)).value!.name, 'Before');
    expect(editor.canUndo, isFalse);

    // Saved as it goes: 400 ms after the last change, it is on disk.
    editor.update((p) => p.copyWith(name: 'Saved'));
    await tester.pump(const Duration(milliseconds: 450));
    late WorldPack? stored;
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        stored = await c.read(worldPackRepositoryProvider).load(id);
      });
      if (stored?.name == 'Saved') break;
      await tester.pump();
    }
    expect(stored!.name, 'Saved');
  });

  /// The pack's name on disk, read without moving fake time on, so a
  /// waiting 400 ms save can never be what put it there.
  Future<String?> storedName(
    WidgetTester tester,
    ProviderContainer c,
    int id,
    String want,
  ) async {
    String? name;
    for (var i = 0; i < 20 && name != want; i++) {
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        name = (await c.read(worldPackRepositoryProvider).load(id))?.name;
      });
    }
    return name;
  }

  testWidgets('going to the background writes the edit at once', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Before'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    c
        .read(packEditorProvider(id).notifier)
        .update(
          (p) => p.copyWith(name: 'Backgrounded'),
        );
    for (final s in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    addTearDown(() {
      for (final s in [
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(s);
      }
    });
    expect(await storedName(tester, c, id, 'Backgrounded'), 'Backgrounded');
  });

  testWidgets('leaving the editor within 400 ms writes the edit', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Before'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    c
        .read(packEditorProvider(id).notifier)
        .update(
          (p) => p.copyWith(name: 'Left quickly'),
        );
    // Every editor screen goes at once, with the app (and the provider
    // scope) still there: only the editor's dispose can save it now. The
    // back button flushes on its own, and a `go` keeps the page mounted
    // through its exit transition, past the 400 ms save.
    await tester.pumpWidget(
      UncontrolledProviderScope(container: c, child: const SizedBox()),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      c.exists(packEditorProvider(id)),
      isFalse,
      reason: 'the editor should be gone before its 400 ms save',
    );
    expect(await storedName(tester, c, id, 'Left quickly'), 'Left quickly');
  });

  testWidgets('undo keeps the last 20 states', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('v0'));
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    final editor = c.read(packEditorProvider(id).notifier);
    for (var i = 1; i <= 25; i++) {
      editor.update((p) => p.copyWith(name: 'v$i'));
    }
    var undone = 0;
    while (editor.canUndo) {
      editor.undo();
      undone++;
    }
    expect(undone, 20);
    expect(c.read(packEditorProvider(id)).value!.name, 'v5');
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render without overflow, home, $size', (
      tester,
    ) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(
        tester,
        c,
        testPack(
          'A long database name that fills the header',
          squads: {
            nationIdOf('CZE'): testSquad(gk: 1, mid: 7),
            nationIdOf('GER'): testSquad(fwd: 1),
          },
        ),
      );
      await pumpEditorRoute(
        tester,
        c,
        '${Routes.editorPack}?id=$id',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(PackHomeScreen.tabletLayoutKey), findsOneWidget);
      for (final s in EditorSection.onHome) {
        expect(find.byKey(PackHomeScreen.sectionKey(s)), findsOneWidget);
      }
      expect(find.byKey(PackHomeScreen.issueKey(0)), findsOneWidget);
    });
  }

  testWidgets('the phone home shows every section', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Phone', squads: {nationIdOf('CZE'): testSquad()}),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    expect(tester.takeException(), isNull);
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    for (final s in EditorSection.onHome) {
      final tile = find.byKey(PackHomeScreen.sectionKey(s));
      await tester.scrollUntilVisible(tile, 200);
      expect(tile, findsOneWidget);
    }
  });

  testWidgets('the pack home has no Nations section and /editor/pack/nations '
      'opens the home', (tester) async {
    expect(EditorSection.values.map((s) => s.name), isNot(contains('nations')));
    expect(EditorSection.onHome, isNot(contains(EditorSection.none)));
    expect(Routes.editorSections, isNot(contains('/editor/pack/nations')));
    expect(EditorSection.ofPath('nations.12.code'), EditorSection.none);
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('No nations'));
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byKey(const Key('packHome.section.nations')), findsNothing);
    expect(
      find.byKey(PackHomeScreen.sectionKey(EditorSection.none)),
      findsNothing,
    );
    expect(find.text(enL.editorSectionNations), findsNothing);
    expect(
      find.text(
        enL.editorSectionsReady(
          EditorSection.onHome.length,
          EditorSection.onHome.length,
        ),
      ),
      findsOneWidget,
    );
    // A link kept from before opens the home.
    await pumpEditorRoute(tester, c, '/editor/pack/nations?id=$id');
    expect(find.byType(NameSectionScreen), findsNothing);
    expect(find.byType(PackHomeScreen), findsOneWidget);
  });

  testWidgets('a pack with a clashing nation code lists it and Remove fixes '
      'it', (tester) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final svk = nationIdOf('SVK');
    // Made before the Nations section went: Czechia took Germany's code (as
    // a later update could give a new nation a pack's code), and Slovakia
    // a code that is not one.
    final id = await insertPack(
      tester,
      c,
      testPack('Old nations').copyWith(
        nations: {
          cze: (name: 'Bohemia', code: 'GER'),
          svk: (name: '', code: 'S1'),
        },
      ),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byKey(PackHomeScreen.notReadyKey), findsOneWidget);
    final first = find.byKey(PackHomeScreen.issueKey(0));
    final second = find.byKey(PackHomeScreen.issueKey(1));
    expect(
      find.descendant(
        of: first,
        matching: find.text(enL.editorIssueCode),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: second,
        matching: find.text(
          enL.editorIssueDuplicateCode(
            'GER',
            ([
              cze,
              nationIdOf('GER'),
            ]..sort()).map((n) => n == cze ? 'Bohemia' : 'Germany').join(', '),
          ),
        ),
      ),
      findsOneWidget,
    );
    // Tapping one goes nowhere: there is no Nations section.
    await tester.tap(first);
    await settle(tester);
    expect(find.byType(PackHomeScreen), findsOneWidget);

    await tester.tap(find.byKey(PackHomeScreen.removeKey(1)));
    await settle(tester);
    expect(_nations(c, id).keys, [svk]);
    await tester.tap(find.byKey(PackHomeScreen.removeKey(0)));
    await settle(tester);
    expect(_nations(c, id), isEmpty);
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    // Each Remove is one undo step.
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await settle(tester);
    expect(_nations(c, id).keys, [svk]);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('500 values in a 29th language leave the pack ready; Remove '
      'all clears them in one undo step', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Klingon').copyWith(
        localized: {
          for (var i = 0; i < 500; i++) 'clubs.Club $i': {'tlh': 'Q$i'},
        },
      ),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    expect(find.byKey(PackHomeScreen.noteKey('tlh')), findsOneWidget);
    expect(
      find.text(enL.editorUnknownLanguageNote('tlh', 500)),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(PackHomeScreen.removeNoteKey('tlh')));
    await tester.tap(find.byKey(PackHomeScreen.removeNoteKey('tlh')));
    await settle(tester);
    expect(c.read(packEditorProvider(id)).value!.localized, isEmpty);
    expect(find.byKey(PackHomeScreen.noteKey('tlh')), findsNothing);

    // One step back brings all 500.
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await settle(tester);
    expect(c.read(packEditorProvider(id)).value!.localized, hasLength(500));
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an unknown trait many players share offers Remove all', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final squad = [
      for (final (i, pl) in testSquad().indexed)
        i < 3
            ? PackPlayer(
                id: pl.id,
                name: pl.name,
                age: pl.age,
                position: pl.position,
                attributes: pl.attributes,
                potential: pl.potential,
                traits: const [],
                unknownTraits: const ['u21Star'],
              )
            : pl,
    ];
    final id = await insertPack(
      tester,
      c,
      testPack('Traits', squads: {cze: squad}),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byKey(PackHomeScreen.attentionKey), findsOneWidget);
    expect(find.text(enL.editorRemoveAllLike(3)), findsNWidgets(3));

    await tester.tap(find.byKey(PackHomeScreen.removeAllKey(0)));
    await settle(tester);
    final players = c.read(packEditorProvider(id)).value!.squads[cze]!;
    expect(players.expand((p) => p.unknownTraits), isEmpty);
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    await tester.tap(find.byKey(PackHomeScreen.undoKey));
    await settle(tester);
    expect(
      c
          .read(packEditorProvider(id))
          .value!
          .squads[cze]!
          .where((p) => p.unknownTraits.isNotEmpty),
      hasLength(3),
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a nation rename still shows in New Game', (tester) async {
    final c = await editorContainer(tester);
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Renamed').copyWith(
        nations: {cze: (name: 'Bohemia', code: '')},
      ),
    );
    await pumpEditorRoute(tester, c, Routes.nations);
    await tester.tap(find.byKey(WorldChip.chipKey));
    await settle(tester);
    final row = find.byKey(WorldChoiceSheet.packKey(id));
    await tester.ensureVisible(row);
    await tester.tap(row);
    await settle(tester);
    expect(c.read(newGameWorldProvider), id);
    c.read(routerProvider).go('${Routes.newGame}?nationId=$cze');
    await settle(tester);
    expect(find.textContaining('Bohemia'), findsWidgets);
    expect(find.text('Czechia'), findsNothing);
  });
}

Map<int, ({String name, String code})> _nations(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!.nations;
