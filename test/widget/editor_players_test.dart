import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/nation_list_screen.dart';
import 'package:fnm/features/editor/players/player_advanced.dart';
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

  for (final code in ['de', 'fi', 'hu']) {
    testWidgets('the player screen fits a 390 px phone in $code', (
      tester,
    ) async {
      final c = await editorContainer(tester);
      final id = await insertPack(
        tester,
        c,
        testPack('Fit', squads: {cze: testSquad()}),
      );
      await pumpEditorRoute(
        tester,
        c,
        _player(id, cze, mid),
        size: const Size(390, 844),
        locale: Locale(code),
      );
      expect(find.byType(PlayerEditScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

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

  testWidgets('Delete removes the player and Undo brings him back', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Delete', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    bool here() => c
        .read(packEditorProvider(id))
        .value!
        .squads[cze]!
        .any((p) => p.id == mid);

    await tester.tap(find.byKey(PlayerEditScreen.menuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PlayerEditScreen.deleteKey));
    await tester.pumpAndSettle();
    expect(here(), isFalse);
    // Back on the squad, which says so, with Undo.
    expect(find.byType(SquadScreen), findsOneWidget);
    expect(find.text(enL.editorSquadRemoved('Player 11')), findsOneWidget);

    await tester.tap(find.text(enL.editorUndo));
    await tester.pumpAndSettle();
    expect(here(), isTrue);
    expect(find.text(enL.editorSquadRemoved('Player 11')), findsNothing);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('Advanced: physical 90 updates the live overall and the '
      "pack's attributes", (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Advanced', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    // Closed at first: the quick way is Overall and type.
    expect(find.byKey(PlayerAdvanced.physicalKey), findsNothing);
    await tester.ensureVisible(find.byKey(PlayerAdvanced.toggleKey));
    await tester.pump();
    await tester.tap(find.byKey(PlayerAdvanced.toggleKey));
    await tester.pumpAndSettle();
    final slider = find.byKey(PlayerAdvanced.physicalKey);
    expect(slider, findsOneWidget);
    expect(tester.widget<Slider>(slider).min, 1);
    expect(tester.widget<Slider>(slider).max, 99);

    _slide(tester, slider, 90, via: [70, 80, 85]);
    await tester.pump();

    const a = PlayerAttributes(physical: 90, technical: 60, stamina: 60);
    final p = _find(c, id, cze, mid);
    expect(p.attributes, a);
    final overall = OverallRating.forPosition(PlayerPosition.cm, a);
    expect(overall, greaterThan(60));
    expect(p.potential, greaterThanOrEqualTo(overall));
    expect(
      find.descendant(
        of: find.byKey(PlayerAdvanced.overallKey),
        matching: find.text('$overall'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(PlayerEditForm.overallNumberKey),
        matching: find.text('$overall'),
      ),
      findsOneWidget,
    );
    final type = PlayerBuild.typeOf(PlayerPosition.cm, a);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(PlayerEditForm.typeKey(type)))
          .selected,
      isTrue,
    );

    // One drag, one undo step.
    c.read(packEditorProvider(id).notifier).undo();
    await tester.pump();
    expect(
      _find(c, id, cze, mid).attributes,
      const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('picking leader and setPiece stores both; a third is refused; '
      'Random stores null', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Traits', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    List<PlayerTrait>? traits() => _find(c, id, cze, mid).traits;
    Future<void> tap(Key key) async {
      await tester.ensureVisible(find.byKey(key));
      await tester.pump();
      await tester.tap(find.byKey(key));
      await tester.pump();
    }

    expect(traits(), isNull);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(PlayerEditForm.randomTraitsKey))
          .selected,
      isTrue,
    );
    await tap(PlayerEditForm.traitKey(PlayerTrait.leader));
    await tap(PlayerEditForm.traitKey(PlayerTrait.setPiece));
    expect(traits(), [PlayerTrait.leader, PlayerTrait.setPiece]);

    await tap(PlayerEditForm.traitKey(PlayerTrait.hothead));
    expect(traits(), [PlayerTrait.leader, PlayerTrait.setPiece]);
    expect(
      find.text(enL.editorPlayerTraitsMax(PlayerTraits.maxTraits)),
      findsOneWidget,
    );

    // Deselecting both leaves "No traits", which is not Random.
    await tap(PlayerEditForm.traitKey(PlayerTrait.leader));
    await tap(PlayerEditForm.traitKey(PlayerTrait.setPiece));
    expect(traits(), isEmpty);
    expect(find.text(enL.editorPlayerTraitsNone), findsOneWidget);

    await tap(PlayerEditForm.randomTraitsKey);
    expect(traits(), isNull);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a trait this game does not know is shown and can be removed', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final squad = testSquad();
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Unknown trait',
        squads: {
          cze: [
            for (final p in squad)
              if (p.id == mid)
                PackPlayer.fromJson({
                  ...p.toJson(),
                  'traits': ['leader', 'flyingHeader'],
                })
              else
                p,
          ],
        },
      ),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    final chip = find.byKey(PlayerEditForm.unknownTraitKey('flyingHeader'));
    await tester.ensureVisible(chip);
    await tester.pump();
    expect(
      find.text(enL.editorPlayerTraitUnknown('flyingHeader')),
      findsOneWidget,
    );
    // Two already: a known one cannot be added beside it.
    await tester.tap(find.byKey(PlayerEditForm.traitKey(PlayerTrait.pacey)));
    await tester.pump();
    expect(_find(c, id, cze, mid).traits, [PlayerTrait.leader]);

    await tester.tap(
      find.descendant(of: chip, matching: find.byIcon(Icons.close)),
    );
    await tester.pump();
    final p = _find(c, id, cze, mid);
    expect(p.unknownTraits, isEmpty);
    expect(p.traits, [PlayerTrait.leader]);
    expect(chip, findsNothing);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('Random drops unknown traits and says so, with Undo', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final squad = testSquad();
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Random unknown',
        squads: {
          cze: [
            for (final p in squad)
              if (p.id == mid)
                PackPlayer.fromJson({
                  ...p.toJson(),
                  'traits': ['leader', 'flyingHeader'],
                })
              else
                p,
          ],
        },
      ),
    );
    await pumpEditorRoute(tester, c, _player(id, cze, mid));
    final random = find.byKey(PlayerEditForm.randomTraitsKey);
    await tester.ensureVisible(random);
    await tester.pump();
    await tester.tap(random);
    await tester.pumpAndSettle();
    expect(_find(c, id, cze, mid).traits, isNull);
    expect(_find(c, id, cze, mid).unknownTraits, isEmpty);
    final said = find.text(enL.editorPlayerTraitsUnknownDropped(1));
    expect(said, findsOneWidget);

    await tester.tap(find.text(enL.editorUndo).last);
    await tester.pumpAndSettle();
    final back = _find(c, id, cze, mid);
    expect(back.traits, [PlayerTrait.leader]);
    expect(back.unknownTraits, ['flyingHeader']);
    expect(said, findsNothing);

    // A pick with nothing unknown goes to Random without a word.
    await tester.tap(
      find.descendant(
        of: find.byKey(PlayerEditForm.unknownTraitKey('flyingHeader')),
        matching: find.byIcon(Icons.close),
      ),
    );
    await tester.pump();
    await tester.tap(random);
    await tester.pumpAndSettle();
    expect(_find(c, id, cze, mid).traits, isNull);
    expect(said, findsNothing);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the player app bar fits a 320 dp phone', (tester) async {
    final c = await editorContainer(tester);
    const name = 'Bartholomew Wojciechowski-Konstantinopoulos';
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Narrow',
        squads: {
          cze: [
            for (final p in testSquad())
              p.id == mid ? SquadEdits.copy(p, name: name) : p,
          ],
        },
      ),
    );
    await pumpEditorRoute(
      tester,
      c,
      _player(id, cze, mid),
      size: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    final bar = find.byType(AppBar);
    final title = find.descendant(of: bar, matching: find.text(name));
    expect(title, findsOneWidget);
    // Room for a readable part of the name, not a sliver.
    expect(tester.getSize(title).width, greaterThanOrEqualTo(96));
    final barRect = tester.getRect(bar);
    for (final key in [PlayerEditScreen.undoKey, PlayerEditScreen.menuKey]) {
      final r = tester.getRect(find.byKey(key));
      expect(barRect.contains(r.center), isTrue, reason: '$key');
      expect(r.right, lessThanOrEqualTo(320));
    }
    final back = tester.getRect(
      find.descendant(of: bar, matching: find.byIcon(Icons.arrow_back)),
    );
    expect(back.left, greaterThanOrEqualTo(0));
    final titleRect = tester.getRect(title);
    expect(titleRect.left, greaterThanOrEqualTo(back.right));
    expect(
      titleRect.right,
      lessThanOrEqualTo(
        tester.getRect(find.byKey(PlayerEditScreen.undoKey)).left,
      ),
    );
  });

  testWidgets(
    "club search 'Madrid' finds Spain's clubs under a Spain header for a "
    'Czech player',
    (tester) async {
      final c = await editorContainer(tester);
      // A country whose league is new in 1.1.x (every country has one).
      const lone = 'and';
      final id = await insertPack(
        tester,
        c,
        testPack('Clubs', squads: {cze: testSquad()}).copyWith(
          clubs: {'Madrid Red': 'Madrid Rojiblancos'},
          addedClubs: [
            const PackClub(
              id: kPackAddedIdBase + 1,
              name: 'Brno Sokol',
              country: 'cze',
            ),
            PackClub(
              id: kPackAddedIdBase + 2,
              name: 'Lonely Stars',
              country: lone,
            ),
          ],
        ),
      );
      await pumpEditorRoute(tester, c, _player(id, cze, mid));
      await tester.ensureVisible(find.byKey(PlayerEditForm.clubKey));
      await tester.pump();
      await tester.tap(find.byKey(PlayerEditForm.clubKey));
      await tester.pumpAndSettle();

      // His own country first, right under the choices on top, and its
      // added club with it.
      final czech = find.byKey(PlayerEditForm.clubCountryKey('cze'));
      expect(czech, findsOneWidget);
      expect(
        tester.getTopLeft(czech).dy,
        lessThan(
          tester
              .getTopLeft(
                find.byKey(
                  PlayerEditForm.clubOptionKey(
                    ClubService.leagueClubs('cze').first,
                    country: 'cze',
                  ),
                ),
              )
              .dy,
        ),
      );
      await tester.enterText(find.byKey(PlayerEditForm.clubSearchKey), 'Brno');
      await tester.pump();
      expect(czech, findsOneWidget);
      expect(
        find.byKey(PlayerEditForm.clubOptionKey('Brno Sokol', country: 'cze')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(PlayerEditForm.clubSearchKey),
        'Madrid',
      );
      await tester.pump();
      final spain = find.byKey(PlayerEditForm.clubCountryKey('esp'));
      expect(spain, findsOneWidget);
      expect(
        find.descendant(of: spain, matching: find.text('Spain')),
        findsOneWidget,
      );
      expect(find.byKey(PlayerEditForm.clubCountryKey('cze')), findsNothing);
      expect(find.text('Madrid White'), findsOneWidget);
      // Under the database's name for it.
      expect(find.text('Madrid Rojiblancos'), findsOneWidget);
      expect(find.text('Madrid Red'), findsNothing);

      // A country's name finds its clubs, a league-less country's added
      // ones included.
      await tester.enterText(
        find.byKey(PlayerEditForm.clubSearchKey),
        'Lonely',
      );
      await tester.pump();
      expect(find.byKey(PlayerEditForm.clubCountryKey(lone)), findsOneWidget);
      await tester.enterText(find.byKey(PlayerEditForm.clubSearchKey), 'spain');
      await tester.pump();
      // 'spain' is in no club's name: the country's name found them all.
      expect(
        find.byKey(
          PlayerEditForm.clubOptionKey(
            ClubService.leagueClubs('esp')[3],
            country: 'esp',
          ),
        ),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(PlayerEditForm.clubSearchKey),
        'Madrid',
      );
      await tester.pump();
      await tester.tap(
        find.byKey(
          PlayerEditForm.clubOptionKey('Madrid White', country: 'esp'),
        ),
      );
      await tester.pumpAndSettle();
      final p = _find(c, id, cze, mid);
      expect(p.club, 'Madrid White');
      expect(p.clubCountry, 'esp');
      await tester.pump(const Duration(milliseconds: 450));
    },
  );

  test('nextPlayerId skips ids used in pools', () {
    final pool = [
      for (final p in testSquad().take(3)) p.copyWithId(p.id + 900),
    ];
    final pack = testPack(
      'Pool ids',
      squads: {cze: testSquad()},
    ).copyWith(pools: {ger: pool});
    final next = SquadEdits.nextPlayerId(pack);
    expect(next, kPackPlayerIdBase + 904);
    final used = {
      for (final s in [...pack.squads.values, ...pack.pools.values])
        for (final p in s) p.id,
    };
    expect(used.contains(next), isFalse);
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
      // Advanced opens beside the list too, and Delete is in the header.
      await tester.ensureVisible(find.byKey(PlayerAdvanced.toggleKey));
      await tester.pump();
      await tester.tap(find.byKey(PlayerAdvanced.toggleKey));
      await settle(tester);
      expect(find.byKey(PlayerAdvanced.staminaKey), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(SquadScreen.menuKey));
      await settle(tester);
      await tester.tap(find.byKey(SquadScreen.deleteKey));
      await settle(tester);
      expect(
        c
            .read(packEditorProvider(id))
            .value!
            .squads[cze]!
            .any((p) => p.id == kPackPlayerIdBase + 1),
        isFalse,
      );
      expect(find.byType(PlayerEditForm), findsNothing);
      // The player page's header has it as well.
      await pumpEditorRoute(tester, c, _player(id, cze, mid), size: size);
      await tester.tap(find.byKey(PlayerEditScreen.menuKey));
      await settle(tester);
      expect(find.byKey(PlayerEditScreen.deleteKey), findsOneWidget);
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
