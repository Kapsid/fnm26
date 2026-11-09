import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';
import 'package:fnm/shared/tablet/screen_header.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';
import '../unit/greenland/greenland_fixtures.dart' show seedPlayers;

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

/// The path of the page the router shows.
String _path(ProviderContainer c) =>
    c.read(routerProvider).routeInformationProvider.value.uri.path;

/// Registers the Fill missing players scenario for one layout. Each layout runs in its own
/// file (editor_fill_phone_test.dart, editor_fill_tablet_test.dart): a second
/// database-backed pool read after this one stalls the test process.
void fillScenario({required bool tablet}) {
  final cze = nationIdOf('CZE');
  testWidgets(
    'completes a short squad in one undoable edit, '
    '${tablet ? 'tablet' : 'phone'}',
    (tester) async {
      final c = await editorContainer(
        tester,
        players: seedPlayers,
        formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
      );
      final short = testSquad(gk: 1, def: 4, mid: 5, fwd: 2);
      final id = await insertPack(
        tester,
        c,
        testPack('Fill', squads: {cze: short}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze),
        size: tablet ? kTabletSizes.first : kPhoneSize,
      );
      // The pool the players come from is read behind the screen.
      await tester.runAsync(
        () => c.read(
          editorGeneratedPoolProvider((packId: id, nationId: cze)).future,
        ),
      );
      await settle(tester);

      final button = find.byKey(SquadScreen.fillKey);
      expect(button, findsOneWidget);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await settle(tester);

      final squad = _pack(c, id).squads[cze]!;
      expect(squad.length, greaterThanOrEqualTo(PackRules.squadMin));
      expect(squad.length, lessThanOrEqualTo(PackRules.squadMax));
      expect(SquadEdits.missingCount(squad), 0);
      expect(
        PackRules.squadIssues(
          cze,
          squad,
        ).whereType<NeedsPosition>().toList(),
        isEmpty,
      );
      // Generated names, not blanks; the originals are untouched.
      expect(squad.every((p) => p.name.trim().isNotEmpty), isTrue);
      expect(
        squad.take(short.length).map((p) => p.id),
        short.map((p) => p.id),
      );
      // Nothing left to fill: the button is gone.
      expect(find.byKey(SquadScreen.fillKey), findsNothing);

      // One undo gives the squad (and the pool) back.
      c.read(packEditorProvider(id).notifier).undo();
      await settle(tester);
      expect(_pack(c, id).squads[cze], short);
      expect(_pack(c, id).pools, isEmpty);
      await tester.runAsync(
        () => c.read(
          editorGeneratedPoolProvider((packId: id, nationId: cze)).future,
        ),
      );
      await settle(tester);
      expect(find.byKey(SquadScreen.fillKey), findsOneWidget);
      expect(tester.takeException(), isNull);
      // The editor's save debounce runs out before the test ends.
      await tester.pump(const Duration(milliseconds: 450));
      // Let the database finish what the edits started before it closes.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
    },
  );
}

void main() {
  final cze = nationIdOf('CZE');

  group('Fill missing players', () {
    test('missingCount is the larger of the size and the position gaps', () {
      expect(SquadEdits.missingCount(testSquad()), 0);
      expect(SquadEdits.missingCount(testSquad(gk: 1)), 2);
      expect(SquadEdits.missingCount(const []), PackRules.squadMin);
      expect(SquadEdits.missingCount(testSquad(gk: 0)), 3);
    });

    testWidgets('a complete squad shows no button', (tester) async {
      final c = await editorContainer(tester, players: seedPlayers);
      final id = await insertPack(
        tester,
        c,
        testPack('Full', squads: {cze: testSquad()}),
      );
      await pumpEditorRoute(tester, c, editorSquadLocation(id, cze));
      expect(find.byKey(SquadScreen.summaryKey), findsOneWidget);
      expect(find.byKey(SquadScreen.fillKey), findsNothing);
    });
  });

  group('a way back from the name pages to the players pages', () {
    Finder backButton({required bool tablet}) => tablet
        ? find.byKey(TabletScreenHeader.backKey)
        : find.descendant(
            of: find.byType(AppBar),
            matching: find.byIcon(Icons.arrow_back),
          );

    for (final tablet in [false, true]) {
      testWidgets(tablet ? 'tablet' : 'phone', (tester) async {
        final c = await editorContainer(
          tester,
          players: seedPlayers,
          formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
        );
        final id = await insertPack(
          tester,
          c,
          testPack('Back', squads: {cze: testSquad(gk: 1)}),
        );
        final size = tablet ? kTabletSizes.first : kPhoneSize;
        final back = backButton(tablet: tablet);
        await pumpEditorRoute(
          tester,
          c,
          editorSectionLocation(EditorSection.nameLists, id, nationId: cze),
          size: size,
        );
        expect(_path(c), Routes.editorNameLists);
        expect(back, findsOneWidget);
        await tester.tap(back);
        await settle(tester);
        expect(_path(c), Routes.editorPack);

        await pumpEditorRoute(
          tester,
          c,
          editorSquadLocation(id, cze),
          size: size,
        );
        expect(_path(c), Routes.editorSquad);
        expect(back, findsOneWidget);
        await tester.tap(back);
        await settle(tester);
        expect(_path(c), Routes.editorPlayers);
        expect(back, findsOneWidget);
        await tester.tap(back);
        await settle(tester);
        expect(_path(c), Routes.editorPack);
      });
    }

    for (final tablet in [false, true]) {
      testWidgets(
        'an issue opens its squad above the database home, '
        '${tablet ? 'tablet' : 'phone'}',
        (tester) async {
          final c = await editorContainer(
            tester,
            players: seedPlayers,
            formFactor: tablet ? FormFactor.tablet : FormFactor.phone,
          );
          final id = await insertPack(
            tester,
            c,
            testPack('Issue', squads: {cze: testSquad(gk: 1)}),
          );
          await pumpEditorRoute(
            tester,
            c,
            editorPackLocation(id),
            size: tablet ? kTabletSizes.first : kPhoneSize,
          );
          final issue = find.byKey(PackHomeScreen.issueKey(0));
          await tester.ensureVisible(issue);
          await tester.tap(issue);
          await settle(tester);
          expect(find.byKey(SquadScreen.summaryKey), findsOneWidget);
          // Back is the page it came from, not another list.
          await tester.tap(backButton(tablet: tablet));
          await settle(tester);
          expect(find.byKey(PackHomeScreen.undoKey), findsOneWidget);
          expect(find.byKey(SquadScreen.summaryKey), findsNothing);
        },
      );
    }
  });
}
