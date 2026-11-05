import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/nation_list_screen.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/editor/players/squad_screen.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

String _player(int id, int nation, int player) =>
    '${Routes.editorPlayer}?id=$id&nation=$nation&player=$player';

PackPlayer _find(ProviderContainer c, int id, int nation, int player) => c
    .read(packEditorProvider(id))
    .value!
    .squads[nation]!
    .firstWhere((p) => p.id == player);

/// Moves [slider] as a finger would: start, through each of [via], to
/// [value], end.
void _slide(
  WidgetTester tester,
  Finder slider,
  double value, {
  List<double> via = const [],
}) {
  final s = tester.widget<Slider>(slider);
  s.onChangeStart?.call(s.value);
  for (final v in [...via, value]) {
    s.onChanged!(v);
  }
  s.onChangeEnd?.call(value);
}

void main() {
  final cze = nationIdOf('CZE');
  final ger = nationIdOf('GER');
  // testSquad(): goalkeepers 1-3, defenders 4-10, midfielders 11-18.
  const mid = kPackPlayerIdBase + 11;

  testWidgets('edit name, overall 85, type Athlete: pack stores attributes '
      'whose forPosition is 85', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Edit', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    expect(find.byType(PlayerEditScreen), findsOneWidget);

    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Pavel Nový');
    await tester.pump();
    await tester.ensureVisible(
      find.byKey(PlayerEditForm.typeKey(PlayerType.athlete)),
    );
    await tester.pump();
    await tester.tap(find.byKey(PlayerEditForm.typeKey(PlayerType.athlete)));
    await tester.pump();
    // A real drag passes through many values on its way.
    _slide(
      tester,
      find.byKey(PlayerEditForm.overallKey),
      85,
      via: [for (var v = 61.0; v < 85; v += 4) v],
    );
    await tester.pump();

    final p = _find(c, id, cze, mid);
    expect(p.name, 'Pavel Nový');
    expect(OverallRating.forPosition(p.position, p.attributes), 85);
    expect(
      p.attributes,
      PlayerBuild.attributesFor(PlayerPosition.cm, PlayerType.athlete, 85),
    );
    expect(PlayerBuild.typeOf(p.position, p.attributes), PlayerType.athlete);
    // Raised above his potential of 80: the potential came along.
    expect(p.potential, 85);
    expect(
      find.descendant(
        of: find.byKey(PlayerEditForm.overallNumberKey),
        matching: find.text('85'),
      ),
      findsOneWidget,
    );

    // One drag is one undo step, however many values it passed through.
    final editor = c.read(packEditorProvider(id).notifier)..undo();
    await tester.pump();
    final back = _find(c, id, cze, mid);
    expect(OverallRating.forPosition(back.position, back.attributes), 60);
    // Back to where the drag started (Athlete at 60), not one value back.
    expect(
      back.attributes,
      PlayerBuild.attributesFor(PlayerPosition.cm, PlayerType.athlete, 60),
    );
    expect(back.potential, 80);
    expect(back.name, 'Pavel Nový');
    expect(editor.canUndo, isTrue);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('potential cannot go below overall', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Potential', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    final overall = OverallRating.forPosition(
      PlayerPosition.cm,
      _find(c, id, cze, mid).attributes,
    );

    final slider = find.byKey(PlayerEditForm.potentialKey);
    await tester.ensureVisible(slider);
    expect(tester.widget<Slider>(slider).min, overall);
    expect(tester.widget<Slider>(slider).max, 99);

    _slide(tester, slider, 10);
    await tester.pump();
    expect(_find(c, id, cze, mid).potential, overall);

    _slide(tester, slider, 92);
    await tester.pump();
    expect(_find(c, id, cze, mid).potential, 92);

    // A lower overall leaves the potential alone; the slider floor follows.
    _slide(tester, find.byKey(PlayerEditForm.overallKey), 50);
    await tester.pump();
    expect(_find(c, id, cze, mid).potential, 92);
    expect(tester.widget<Slider>(slider).min, 50);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('add a goalkeeper fixes the missing-goalkeeper issue', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Keepers', squads: {cze: testSquad(gk: 2), ger: testSquad()}),
    );
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorSquad}?id=$id&nation=$cze',
    );
    expect(find.byType(SquadScreen), findsOneWidget);
    expect(find.text(enL.editorIssueGoalkeepers(1)), findsOneWidget);

    final editor = c.read(packEditorProvider(id).notifier);
    bool needsKeeper() => editor.issues.any(
      (i) =>
          i is NeedsPosition &&
          i.nationId == cze &&
          i.category == PositionCategory.goalkeeper,
    );
    expect(needsKeeper(), isTrue);

    await tester.tap(find.byKey(SquadScreen.addKey));
    await tester.pumpAndSettle();

    expect(needsKeeper(), isFalse);
    final squad = c.read(packEditorProvider(id)).value!.squads[cze]!;
    expect(squad, hasLength(23));
    final added = squad.last;
    expect(added.position, PlayerPosition.gk);
    // Unique across the whole pack, not per nation.
    expect(added.id, kPackPlayerIdBase + 24);
    expect(added.age, 24);
    expect(added.potential, greaterThanOrEqualTo(60));
    // The new man opens to be named.
    expect(find.byType(PlayerEditScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('swipe removes a player and the snackbar undoes it', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Swipe', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorSquad}?id=$id&nation=$cze',
    );
    const gk = kPackPlayerIdBase + 1;
    await tester.drag(
      find.byKey(SquadScreen.playerKey(gk)),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(
      c.read(packEditorProvider(id)).value!.squads[cze]!.any((p) => p.id == gk),
      isFalse,
    );
    // Below the minimum is allowed: the squad says what is missing.
    expect(find.text(enL.editorIssueGoalkeepers(1)), findsOneWidget);

    await tester.tap(find.text(enL.editorUndo));
    await tester.pumpAndSettle();
    expect(
      c.read(packEditorProvider(id)).value!.squads[cze]!.any((p) => p.id == gk),
      isTrue,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the Undo of a removal never undoes a later edit', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Stale', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorSquad}?id=$id&nation=$cze',
    );
    const gk = kPackPlayerIdBase + 1;
    const other = kPackPlayerIdBase + 2;
    await tester.drag(
      find.byKey(SquadScreen.playerKey(gk)),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    final action = tester.widget<SnackBarAction>(find.byType(SnackBarAction));

    // Another edit after the removal: the snackbar goes.
    final editor = c.read(packEditorProvider(id).notifier)
      ..update(
        (p) => SquadEdits.replace(
          p,
          cze,
          SquadEdits.copy(_find(c, id, cze, other), name: 'Renamed'),
        ),
      );
    await tester.pumpAndSettle();
    expect(find.byType(SnackBarAction), findsNothing);

    // And its Undo, pressed late, leaves the rename (and the removal) be.
    action.onPressed();
    await tester.pump();
    final squad = c.read(packEditorProvider(id)).value!.squads[cze]!;
    expect(squad.firstWhere((p) => p.id == other).name, 'Renamed');
    expect(squad.any((p) => p.id == gk), isFalse);
    expect(editor.canUndo, isTrue);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('two players with one name get a warning badge, not a block', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final squad = testSquad();
    final twin = squad[1];
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Twins',
        squads: {
          cze: [
            for (final p in squad)
              if (p.id == twin.id)
                SquadEdits.copy(p, name: ' ${squad[0].name.toUpperCase()}')
              else
                p,
          ],
        },
      ),
    );
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorSquad}?id=$id&nation=$cze',
    );
    expect(find.byKey(SquadScreen.duplicateKey(squad[0].id)), findsOneWidget);
    expect(find.byKey(SquadScreen.duplicateKey(twin.id)), findsOneWidget);
    expect(find.byKey(SquadScreen.duplicateKey(squad[2].id)), findsNothing);
    // A warning only: the squad is still ready.
    expect(find.text(enL.editorSquadReady), findsOneWidget);
  });

  testWidgets('search finds a nation by its renamed name', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Renamed',
        squads: {cze: testSquad(), ger: testSquad()},
      ).copyWith(
        nations: {cze: (name: 'Bohemia', code: 'BOH')},
      ),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPlayers}?id=$id');
    expect(find.byType(NationListScreen), findsOneWidget);

    await tester.enterText(find.byKey(NationListScreen.searchKey), 'bohem');
    await settle(tester);
    expect(find.byKey(NationListScreen.nationKey(cze)), findsOneWidget);
    expect(find.text('Bohemia'), findsOneWidget);
    expect(find.byKey(NationListScreen.nationKey(ger)), findsNothing);

    await tester.tap(find.byKey(NationListScreen.nationKey(cze)));
    await settle(tester);
    expect(find.byType(SquadScreen), findsOneWidget);
  });

  test('a new id is one past the highest pack id in any nation', () {
    final pack = testPack(
      'Ids',
      squads: {
        cze: testSquad(),
        ger: [
          ...testSquad(),
          testSquad().first.copyWithId(kPackPlayerIdBase + 500),
        ],
      },
    );
    expect(SquadEdits.nextPlayerId(pack), kPackPlayerIdBase + 501);
    expect(
      SquadEdits.nextPlayerId(testPack('Empty')),
      kPackPlayerIdBase + 1,
    );
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet layouts render, $size', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(
        tester,
        c,
        testPack('Tablet', squads: {cze: testSquad(gk: 2), ger: testSquad()}),
      );
      for (final (location, key) in [
        ('${Routes.editorPlayers}?id=$id', NationListScreen.tabletLayoutKey),
        (
          '${Routes.editorSquad}?id=$id&nation=$cze',
          SquadScreen.tabletLayoutKey,
        ),
        (_player(id, cze, mid), PlayerEditScreen.tabletLayoutKey),
      ]) {
        await pumpEditorRoute(tester, c, location, size: size);
        expect(tester.takeException(), isNull, reason: location);
        expect(find.byKey(key), findsOneWidget, reason: location);
      }
      // The squad's tablet layout edits the picked player beside the list.
      await pumpEditorRoute(
        tester,
        c,
        '${Routes.editorSquad}?id=$id&nation=$cze',
        size: size,
      );
      await tester.tap(
        find.byKey(SquadScreen.playerKey(kPackPlayerIdBase + 1)),
      );
      await settle(tester);
      expect(find.byType(PlayerEditForm), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}

extension on PackPlayer {
  PackPlayer copyWithId(int id) => PackPlayer(
    id: id,
    name: name,
    age: age,
    position: position,
    attributes: attributes,
    potential: potential,
    club: club,
    clubCountry: clubCountry,
  );
}
