import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/players/nation_list_screen.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

/// [n] named reserves with pack-made ids, as a fixed pool holds them.
List<PackPlayer> _reserves(List<PackPlayer> squad, int n, {String? name}) {
  final out = <PackPlayer>[];
  for (var i = 0; i < n; i++) {
    final p = SquadEdits.newPlayer(
      [...squad, ...out],
      kPackPlayerIdBase + 1000 + i,
    );
    out.add(SquadEdits.copy(p, name: name ?? 'Reserve ${i + 1}'));
  }
  return out;
}

/// How many nation tiles the list has built.
int _tiles() => find
    .byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith(
            'editorNations.nation.',
          ),
    )
    .evaluate()
    .length;

void main() {
  final cze = nationIdOf('CZE');
  final fra = nationIdOf('FRA');

  group('a reserve moves into the squad', () {
    test('SquadEdits.promote moves him, with one id of the pack\'s own', () {
      final squad = testSquad();
      final pool = _reserves(squad, 3);
      final pack = testPack('P', squads: {cze: squad}).copyWith(
        pools: {cze: pool},
      );
      final next = SquadEdits.promote(pack, cze, const [], pool[1].id)!;
      expect(next.squads[cze], hasLength(squad.length + 1));
      expect(next.pools[cze], hasLength(2));
      final moved = next.squads[cze]!.last;
      expect(moved.name, 'Reserve 2');
      expect(moved.id, greaterThan(kPackPlayerIdBase + pool.length));
      expect(next.pools[cze]!.any((p) => p.name == 'Reserve 2'), isFalse);
      // Nothing else moved, and the result is still a complete pack part.
      expect(PackRules.squadIssues(cze, next.squads[cze]!), isEmpty);
      expect(PackRules.poolIssues(cze, next.pools[cze]!), isEmpty);
    });

    test('a full squad takes no one without a swap, and swaps with one', () {
      final squad = testSquad(gk: 5, def: 14, mid: 14, fwd: 7);
      expect(squad, hasLength(PackRules.squadMax));
      final pool = _reserves(squad, 2);
      final pack = testPack('P', squads: {cze: squad}).copyWith(
        pools: {cze: pool},
      );
      expect(SquadEdits.promote(pack, cze, const [], pool.first.id), isNull);
      // Not in the pool, or a swap-out who is not in the squad: nothing.
      expect(SquadEdits.promote(pack, cze, const [], 999), isNull);
      expect(
        SquadEdits.promote(
          pack,
          cze,
          const [],
          pool.first.id,
          swapOutId: 999,
        ),
        isNull,
      );

      final out = squad.last;
      final next = SquadEdits.promote(
        pack,
        cze,
        const [],
        pool.first.id,
        swapOutId: out.id,
      )!;
      expect(next.squads[cze], hasLength(PackRules.squadMax));
      expect(next.pools[cze], hasLength(pool.length));
      expect(next.squads[cze]!.any((p) => p.id == out.id), isFalse);
      expect(next.squads[cze]!.any((p) => p.name == 'Reserve 1'), isTrue);
      final back = next.pools[cze]!.firstWhere((p) => p.name == out.name);
      expect(PackRules.poolIdInRange(back.id), isTrue);
      // Every id in the nation stays unique.
      final ids = [
        for (final p in [...next.squads[cze]!, ...next.pools[cze]!]) p.id,
      ];
      expect(ids.toSet(), hasLength(ids.length));
      expect(PackRules.issues(next), isEmpty);
    });

    test('a pool still being the generated one is fixed as it was shown', () {
      final squad = testSquad();
      final shown = _reserves(squad, 3);
      final pack = testPack('P', squads: {cze: squad});
      final next = SquadEdits.promote(pack, cze, shown, shown.first.id)!;
      expect(next.pools[cze], hasLength(2));
      expect(next.squads[cze], hasLength(squad.length + 1));
    });

    testWidgets('one tap on a reserve moves him; Undo puts him back', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      final squad = testSquad();
      final pool = _reserves(squad, 3);
      final id = await insertPack(
        tester,
        c,
        testPack('Up', squads: {cze: squad}).copyWith(pools: {cze: pool}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze, pool: true),
      );
      await tester.tap(find.byKey(SquadScreen.promoteKey(pool[1].id)));
      await settle(tester);

      expect(_pack(c, id).squads[cze], hasLength(squad.length + 1));
      expect(_pack(c, id).pools[cze], hasLength(2));
      expect(find.text(enL.editorPromoted('Reserve 2')), findsOneWidget);
      expect(find.byKey(SquadScreen.promoteKey(pool[1].id)), findsNothing);

      await tester.tap(find.text(enL.editorUndo).last);
      await settle(tester);
      expect(_pack(c, id).squads[cze], squad);
      expect(_pack(c, id).pools[cze], pool);
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('with a full squad it asks who goes back to the pool', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      final squad = testSquad(gk: 5, def: 14, mid: 14, fwd: 7);
      final pool = _reserves(squad, 2);
      final id = await insertPack(
        tester,
        c,
        testPack('Full', squads: {cze: squad}).copyWith(pools: {cze: pool}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze, pool: true),
      );
      await tester.tap(find.byKey(SquadScreen.promoteKey(pool.first.id)));
      await settle(tester);
      expect(find.text(enL.editorPromoteFullTitle), findsOneWidget);
      // Nothing moves until someone is picked.
      expect(_pack(c, id).squads[cze], squad);

      final out = squad.first;
      await tester.tap(find.byKey(SquadScreen.swapKey(out.id)));
      await settle(tester);
      final now = _pack(c, id);
      expect(now.squads[cze], hasLength(PackRules.squadMax));
      expect(now.squads[cze]!.any((p) => p.id == out.id), isFalse);
      expect(now.squads[cze]!.any((p) => p.name == 'Reserve 1'), isTrue);
      expect(now.pools[cze], hasLength(pool.length));
      await tester.pump(const Duration(milliseconds: 450));
    });

    testWidgets('the tablet pool list has the same button', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final squad = testSquad();
      final pool = _reserves(squad, 2);
      final id = await insertPack(
        tester,
        c,
        testPack('Tab', squads: {cze: squad}).copyWith(pools: {cze: pool}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSquadLocation(id, cze, pool: true),
        size: const Size(1194, 834),
      );
      await tester.tap(find.byKey(SquadScreen.promoteKey(pool.first.id)));
      await settle(tester);
      expect(_pack(c, id).squads[cze], hasLength(squad.length + 1));
      await tester.pump(const Duration(milliseconds: 450));
    });
  });

  group('only what needs a fix', () {
    testWidgets('the nation list filters to the nations with something to '
        'fix', (tester) async {
      final c = await editorContainer(tester);
      final id = await insertPack(
        tester,
        c,
        testPack(
          'Fix',
          squads: {cze: testSquad(), fra: testSquad(gk: 1)},
        ),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.players, id),
      );
      // Every nation is listed (one screenful of them is built).
      expect(_tiles(), greaterThan(3));

      await tester.tap(find.byKey(NationListScreen.fixFilterKey));
      await tester.pump();
      // Only the nation whose squad has something to fix.
      expect(_tiles(), 1);
      expect(find.byKey(NationListScreen.nationKey(fra)), findsOneWidget);

      await tester.tap(find.byKey(NationListScreen.fixFilterKey));
      await tester.pump();
      expect(_tiles(), greaterThan(3));
    });

    testWidgets('a pack with nothing to fix says so under the filter', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      final id = await insertPack(
        tester,
        c,
        testPack('Clean', squads: {cze: testSquad()}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.players, id),
      );
      await tester.tap(find.byKey(NationListScreen.fixFilterKey));
      await tester.pump();
      expect(find.text(enL.editorNothingToFix), findsOneWidget);
      expect(_tiles(), 0);
    });

    testWidgets('a name section filters to the rows with something to '
        'fix', (tester) async {
      final c = await editorContainer(tester);
      final clubs = ClubService.leagueClubs('cze');
      final bad = clubs.first;
      final fine = clubs[1];
      // A blank name is how a file from elsewhere can break a row.
      final id = await insertPack(
        tester,
        c,
        testPack('Names').copyWith(clubs: {bad: '   ', fine: 'Sokoli'}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.clubs, id),
      );
      // Search narrows the list to the Czech clubs, then the filter to the
      // one with a problem.
      await tester.enterText(
        find.byKey(NameSectionScreen.searchKey),
        'czechia',
      );
      await tester.pump();
      expect(find.byKey(NameSectionScreen.rowKey(bad)), findsOneWidget);
      expect(find.byKey(NameSectionScreen.rowKey(fine)), findsOneWidget);

      await tester.tap(find.byKey(NameSectionScreen.fixFilterKey));
      await tester.pump();
      expect(find.byKey(NameSectionScreen.rowKey(bad)), findsOneWidget);
      expect(find.byKey(NameSectionScreen.rowKey(fine)), findsNothing);

      // Without the search, it is still the only row.
      await tester.enterText(find.byKey(NameSectionScreen.searchKey), '');
      await tester.pump();
      expect(find.byKey(NameSectionScreen.rowKey(bad)), findsOneWidget);
      expect(find.byKey(NameSectionScreen.rowKey(fine)), findsNothing);
    });
  });

  group('the nation list agrees with the pack home', () {
    // Reproduced from the playtest report "it says something needs fixing
    // when nothing does": the Players section of the home counted a nation's
    // pool problems while the nation list showed "Squad ready" for it, so
    // the two screens contradicted each other (and the fix filter, built on
    // the list, hid the very nation the home pointed at).
    testWidgets('a pool problem counts against its nation', (tester) async {
      final c = await editorContainer(tester);
      final squad = testSquad();
      final pool = _reserves(squad, 2, name: '');
      final id = await insertPack(
        tester,
        c,
        testPack('Pool', squads: {cze: squad}).copyWith(pools: {cze: pool}),
      );
      await pumpEditorRoute(
        tester,
        c,
        editorSectionLocation(EditorSection.players, id),
      );
      final editor = c.read(packEditorProvider(id).notifier);
      // The home counts them...
      expect(
        editor.issues.where((i) => i.where.startsWith('pools.$cze')),
        hasLength(2),
      );
      // ...and so does the nation's tile.
      await tester.enterText(find.byKey(NationListScreen.searchKey), 'czech');
      await tester.pump();
      final tile = find.byKey(NationListScreen.nationKey(cze));
      expect(
        find.descendant(of: tile, matching: find.text(enL.editorCountToFix(2))),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile,
          matching: find.text(enL.editorNationSquadReady),
        ),
        findsNothing,
      );
      await tester.tap(find.byKey(NationListScreen.fixFilterKey));
      await tester.pump();
      expect(_tiles(), 1);
      expect(find.byKey(NationListScreen.nationKey(cze)), findsOneWidget);
    });
  });
}
