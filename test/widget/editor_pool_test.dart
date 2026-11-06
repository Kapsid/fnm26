import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';
import '../unit/greenland/greenland_fixtures.dart' show seedPlayers;

/// Nation [nation]'s generated pool, as the editor shows an untouched one.
Future<List<PackPlayer>> _generated(
  WidgetTester tester,
  ProviderContainer c,
  WorldPack pack,
  int nation,
) async {
  late List<PackPlayer> out;
  await tester.runAsync(() async {
    out = await c.read(worldPackServiceProvider).generatedPool(nation, pack);
  });
  return out;
}

/// What [editorPoolProvider] gives for [nation]'s pool in pack [id].
Future<List<PackPlayer>> _shown(
  WidgetTester tester,
  ProviderContainer c,
  int id,
  int nation,
) async {
  final key = (packId: id, nationId: nation);
  final sub = c.listen(editorPoolProvider(key), (_, _) {});
  late List<PackPlayer> out;
  await tester.runAsync(() async {
    out = await c.read(editorPoolProvider(key).future);
  });
  sub.close();
  return out;
}

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

void main() {
  final cze = nationIdOf('CZE');

  testWidgets('Pool tab shows the generated pool with the banner', (
    tester,
  ) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final pack = testPack('Pool', squads: {cze: testSquad()});
    final id = await insertPack(tester, c, pack);
    final generated = await _generated(tester, c, pack, cze);
    expect(generated, isNotEmpty);

    await pumpEditorRoute(tester, c, editorSquadLocation(id, cze));
    expect(find.byKey(SquadScreen.poolTabKey), findsOneWidget);
    await tester.tap(find.text(enL.editorTabPool));
    await settle(tester);

    expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
    expect(find.text(enL.editorPoolGenerated), findsOneWidget);
    expect(find.byKey(SquadScreen.poolResetKey), findsNothing);
    // Listed as the squad is: keepers first, the strongest first.
    final first = SquadEdits.sorted(generated).first;
    expect(find.byKey(SquadScreen.poolPlayerKey(first.id)), findsOneWidget);
    expect(find.text(first.name), findsOneWidget);
    // Looking changes nothing.
    expect(_pack(c, id).pools, isEmpty);
    expect(await _shown(tester, c, id, cze), generated);

    // Search by name, and by position.
    final last = SquadEdits.sorted(generated).last;
    await tester.enterText(find.byKey(SquadScreen.poolSearchKey), last.name);
    await tester.pump();
    expect(find.byKey(SquadScreen.poolPlayerKey(last.id)), findsOneWidget);
    await tester.enterText(find.byKey(SquadScreen.poolSearchKey), '');
    await tester.pump();
    final keeper = generated.firstWhere(
      (p) => p.position.category == PositionCategory.goalkeeper,
    );
    final forward = SquadEdits.sorted(
      generated,
    ).firstWhere((p) => p.position.category == PositionCategory.forward);
    final fwd = find.byKey(SquadScreen.poolFilterKey(PositionCategory.forward));
    await tester.ensureVisible(fwd);
    await tester.pump();
    await tester.tap(fwd);
    await tester.pump();
    expect(find.byKey(SquadScreen.poolPlayerKey(forward.id)), findsOneWidget);
    expect(find.byKey(SquadScreen.poolPlayerKey(keeper.id)), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a link with tab=pool opens on the Pool tab', (tester) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final id = await insertPack(
      tester,
      c,
      testPack('Link', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, editorSquadLocation(id, cze, pool: true));
    expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
    expect(
      editorSectionLocation(
        EditorSection.players,
        id,
        nationId: cze,
        pool: true,
      ),
      editorSquadLocation(id, cze, pool: true),
    );
    expect(
      editorPlayerLocation(id, cze, 5, pool: true),
      '${Routes.editorPlayer}?id=$id&nation=$cze&player=5&pool=1',
    );
  });

  testWidgets('renaming one pool player fixes the whole pool exactly as '
      'shown', (tester) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final pack = testPack('Rename', squads: {cze: testSquad()});
    final id = await insertPack(tester, c, pack);
    final generated = await _generated(tester, c, pack, cze);
    final him = generated[generated.length ~/ 2];

    await pumpEditorRoute(
      tester,
      c,
      editorPlayerLocation(id, cze, him.id, pool: true),
    );
    expect(find.byType(PlayerEditForm), findsOneWidget);
    expect(find.text(him.name), findsWidgets);
    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Jan Nový');
    await tester.pump();

    final pool = _pack(c, id).pools[cze]!;
    expect(pool, [
      for (final p in generated)
        p.id == him.id ? SquadEdits.copy(p, name: 'Jan Nový') : p,
    ]);
    expect(await _shown(tester, c, id, cze), pool);
    // The squad is not touched.
    expect(_pack(c, id).squads[cze], testSquad());
    expect(
      c
          .read(packEditorProvider(id).notifier)
          .issues
          .where(
            (i) => i.where.startsWith('pools'),
          ),
      isEmpty,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('deleting from an untouched pool then Undo leaves the pool '
      'untouched (pools has no key)', (tester) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final pack = testPack('Undo', squads: {cze: testSquad()});
    final id = await insertPack(tester, c, pack);
    final generated = await _generated(tester, c, pack, cze);
    final first = SquadEdits.sorted(generated).first;

    await pumpEditorRoute(tester, c, editorSquadLocation(id, cze, pool: true));
    await tester.drag(
      find.byKey(SquadScreen.poolPlayerKey(first.id)),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    final fixed = _pack(c, id).pools[cze]!;
    expect(fixed.length, generated.length - 1);
    expect(fixed.any((p) => p.id == first.id), isFalse);
    expect(find.byKey(SquadScreen.poolFixedKey), findsOneWidget);
    expect(
      find.text(enL.editorPoolRemoved(first.name)),
      findsOneWidget,
    );

    await tester.tap(find.text(enL.editorUndo).last);
    await tester.pumpAndSettle();
    expect(_pack(c, id).pools.containsKey(cze), isFalse);
    expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
    expect(find.byKey(SquadScreen.poolPlayerKey(first.id)), findsOneWidget);

    // The player page's Delete, and the app bar's Undo, do the same.
    await pumpEditorRoute(
      tester,
      c,
      editorPlayerLocation(id, cze, first.id, pool: true),
    );
    await tester.tap(find.byKey(PlayerEditScreen.menuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PlayerEditScreen.deleteKey));
    await settle(tester);
    expect(_pack(c, id).pools[cze]!.length, generated.length - 1);
    c.read(packEditorProvider(id).notifier).undo();
    await settle(tester);
    expect(_pack(c, id).pools.containsKey(cze), isFalse);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('add a pool player gives an id >= kPackPlayerIdBase', (
    tester,
  ) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final pack = testPack('Add', squads: {cze: testSquad()});
    final id = await insertPack(tester, c, pack);
    final generated = await _generated(tester, c, pack, cze);

    await pumpEditorRoute(tester, c, editorSquadLocation(id, cze, pool: true));
    await tester.tap(find.byKey(SquadScreen.addKey));
    await settle(tester);

    final pool = _pack(c, id).pools[cze]!;
    expect(pool.length, generated.length + 1);
    // Everyone shown is kept exactly, and the new one is pack-made, past
    // every pack-made id of the squad.
    expect(pool.sublist(0, generated.length), generated);
    final added = pool.last;
    expect(added.id, greaterThanOrEqualTo(kPackPlayerIdBase));
    expect(added.id, kPackPlayerIdBase + testSquad().length + 1);
    expect(added.name, isEmpty);
    // The squad's player page opens on him, a pool player.
    expect(find.byType(PlayerEditScreen), findsOneWidget);
    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Petr Malý');
    await tester.pump();
    expect(_pack(c, id).pools[cze]!.last.name, 'Petr Malý');
    expect(_pack(c, id).squads[cze], testSquad());
    await tester.pump(const Duration(milliseconds: 450));
  });

  test('a full pool takes no one more', () {
    final pool = [
      for (var i = 0; i < PackRules.poolMax; i++)
        PackPlayer(
          id: kPackPlayerIdBase + 100 + i,
          name: 'P $i',
          age: 22,
          position: PlayerPosition.cm,
          attributes: const PlayerAttributes(
            physical: 50,
            technical: 50,
            stamina: 50,
          ),
          potential: 60,
        ),
    ];
    final pack = testPack('Full').copyWith(pools: {7: pool});
    expect(SquadEdits.poolAdd(pack, 7, const []), isNull);
    // An edit that changes nothing fixes nothing.
    final empty = testPack('Empty');
    expect(
      identical(
        SquadEdits.poolRemove(empty, 7, pool, kPackPlayerIdBase + 99999),
        empty,
      ),
      isTrue,
    );
  });

  testWidgets('Back to generated removes the fixed pool', (tester) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final base = testPack('Reset', squads: {cze: testSquad()});
    final generated = await _generated(tester, c, base, cze);
    final id = await insertPack(
      tester,
      c,
      base.copyWith(pools: {cze: generated.sublist(1)}),
    );

    await pumpEditorRoute(tester, c, editorSquadLocation(id, cze, pool: true));
    expect(find.byKey(SquadScreen.poolFixedKey), findsOneWidget);
    expect(find.byKey(SquadScreen.poolGeneratedKey), findsNothing);
    // Cancel keeps it.
    await tester.tap(find.byKey(SquadScreen.poolResetKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(enL.editorCancel));
    await tester.pumpAndSettle();
    expect(_pack(c, id).pools.containsKey(cze), isTrue);

    await tester.tap(find.byKey(SquadScreen.poolResetKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SquadScreen.poolResetConfirmKey));
    await settle(tester);
    expect(_pack(c, id).pools.containsKey(cze), isFalse);
    expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
    expect(
      find.byKey(
        SquadScreen.poolPlayerKey(SquadEdits.sorted(generated).first.id),
      ),
      findsOneWidget,
    );
    // One Undo brings the fixed pool back.
    c.read(packEditorProvider(id).notifier).undo();
    await settle(tester);
    expect(_pack(c, id).pools[cze], generated.sublist(1));
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a pool issue on the home opens the Pool tab', (tester) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final base = testPack('Issue', squads: {cze: testSquad()});
    final generated = await _generated(tester, c, base, cze);
    final id = await insertPack(
      tester,
      c,
      base.copyWith(
        pools: {
          cze: [
            SquadEdits.copy(generated.first, name: ''),
            ...generated.skip(1),
          ],
        },
      ),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    await tester.tap(find.text(enL.editorIssuePlayerNoName).first);
    await settle(tester);
    expect(find.byType(SquadScreen), findsOneWidget);
    expect(find.byKey(SquadScreen.poolFixedKey), findsOneWidget);
    // The Pool tab says what is wrong too.
    expect(find.text(enL.editorIssuePlayerNoName), findsOneWidget);
  });

  testWidgets('picked traits on a pool player are stored in the pool', (
    tester,
  ) async {
    final c = await editorContainer(tester, players: seedPlayers);
    final pack = testPack('Traits', squads: {cze: testSquad()});
    final id = await insertPack(tester, c, pack);
    final generated = await _generated(tester, c, pack, cze);
    final him = generated.first;
    await pumpEditorRoute(
      tester,
      c,
      editorPlayerLocation(id, cze, him.id, pool: true),
    );
    final chip = find.byKey(PlayerEditForm.traitKey(PlayerTrait.leader));
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pump();
    final stored = _pack(c, id).pools[cze]!.firstWhere((p) => p.id == him.id);
    expect(stored.traits, [PlayerTrait.leader]);
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render, $size', (tester) async {
      final c = await editorContainer(
        tester,
        formFactor: FormFactor.tablet,
        players: seedPlayers,
      );
      final pack = testPack('Tablet', squads: {cze: testSquad()});
      final id = await insertPack(tester, c, pack);
      final generated = await _generated(tester, c, pack, cze);
      final first = SquadEdits.sorted(generated).first;

      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze, pool: true),
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(SquadScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
      // The picked pool player is edited beside the list.
      await tester.tap(find.byKey(SquadScreen.poolPlayerKey(first.id)));
      await settle(tester);
      expect(find.byType(PlayerEditForm), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Tablet Man');
      await tester.pump();
      expect(
        _pack(c, id).pools[cze]!.firstWhere((p) => p.id == first.id).name,
        'Tablet Man',
      );
      expect(find.byKey(SquadScreen.poolFixedKey), findsOneWidget);
      // Delete in the header, and the player page itself.
      await tester.tap(find.byKey(SquadScreen.menuKey));
      await settle(tester);
      await tester.tap(find.byKey(SquadScreen.deleteKey));
      await settle(tester);
      expect(
        _pack(c, id).pools[cze]!.any((p) => p.id == first.id),
        isFalse,
      );
      expect(find.byType(PlayerEditForm), findsNothing);
      final other = generated.firstWhere((p) => p.id != first.id);
      await pumpEditorRoute(
        tester,
        c,
        editorPlayerLocation(id, cze, other.id, pool: true),
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(PlayerEditScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PlayerEditForm), findsOneWidget);
      // Back on the squad tab, the squad is as it was.
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze),
        size: size,
      );
      expect(
        find.byKey(SquadScreen.playerKey(kPackPlayerIdBase + 1)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }

  for (final size in [const Size(320, 640), const Size(390, 844)]) {
    testWidgets('the pool tab fits a ${size.width} dp phone', (tester) async {
      final c = await editorContainer(tester, players: seedPlayers);
      final id = await insertPack(
        tester,
        c,
        testPack('Phone', squads: {cze: testSquad()}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze, pool: true),
        size: size,
        locale: const Locale('cs'),
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(SquadScreen.poolGeneratedKey), findsOneWidget);
    });
  }
}
