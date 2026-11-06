import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_language.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

String _at(EditorSection s, int id) => editorSectionLocation(s, id);

const _base = kPackAddedIdBase;

PackPlayer _pl(int id, {String? club, String? country}) => PackPlayer(
  id: kPackPlayerIdBase + id,
  name: 'Player $id',
  age: 25,
  position: PlayerPosition.cm,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 80,
  club: club,
  clubCountry: country,
);

/// Picks [option] in an open search picker, searching for [query].
Future<void> _pick(WidgetTester tester, String query, String option) async {
  await tester.enterText(find.byKey(AddedItemForm.pickerSearchKey), query);
  await tester.pump();
  await tester.tap(find.byKey(AddedItemForm.optionKey(option)));
  await settle(tester);
}

void main() {
  final cze = nationIdOf('CZE');

  group('AddedEdits', () {
    final pack = testPack('Unit');

    test('ids start at the reserved base and run past every kind', () {
      expect(AddedEdits.nextAddedId(pack), _base);
      final p = AddedEdits.addY(
        AddedEdits.addSponsor(
          AddedEdits.addClub(pack, 'FC Vltava', 'cze'),
          'Brew',
          SponsorDeal.marketing,
          SponsorBrand.values.first.name,
          '',
        ),
        'Nobody',
        YVoice.fan,
        null,
      );
      expect(p.addedClubs.single.id, _base);
      expect(p.addedSponsors.single.id, _base + 1);
      expect(p.addedYAccounts.single.id, _base + 2);
      expect(AddedEdits.nextAddedId(p), _base + 3);
    });

    test('renaming an added club moves its players in squads and pools; '
        'deleting it puts them on Auto', () {
      var p = AddedEdits.addClub(pack, 'FC Vltava', 'cze');
      p = p.copyWith(
        squads: {
          cze: [
            _pl(1, club: 'FC Vltava', country: 'cze'),
            // The same name in another country is another club.
            _pl(2, club: 'FC Vltava', country: 'svk'),
            _pl(3, club: 'Sparta', country: 'cze'),
          ],
        },
        pools: {
          cze: [_pl(4, club: 'FC Vltava', country: 'cze')],
        },
        localized: {
          PackPaths.addedClub(_base): {'cs': 'Vltava'},
        },
      );
      final renamed = AddedEdits.renameClub(p, _base, 'Vltava United');
      expect(renamed.addedClubs.single.name, 'Vltava United');
      expect(renamed.squads[cze]!.map((x) => x.club), [
        'Vltava United',
        'FC Vltava',
        'Sparta',
      ]);
      expect(renamed.pools[cze]!.single.club, 'Vltava United');
      expect(renamed.pools[cze]!.single.clubCountry, 'cze');

      for (final gone in [
        AddedEdits.removeClub(renamed, _base),
        // The home's Remove goes the same way.
        PackEditor.dropUnknown(renamed, 'addedClubs.$_base'),
      ]) {
        expect(gone.addedClubs, isEmpty);
        expect(gone.localized, isEmpty);
        expect(gone.squads[cze]![0].club, isNull);
        expect(gone.squads[cze]![0].clubCountry, isNull);
        expect(gone.squads[cze]![1].club, 'FC Vltava');
        expect(gone.squads[cze]![2].club, 'Sparta');
        expect(gone.pools[cze]!.single.club, isNull);
      }
    });

    test('an added club cannot take a name the game renames by', () {
      final league = ClubService.leagueClubs('eng').first;
      final p = pack.copyWith(clubs: {league: 'Somebody'});
      // The rename map would rename the added club too.
      expect(
        AddedEdits.clubNameProblem(p, league, 'cze', const {}),
        AddedNameProblem.gameClub,
      );
      // A name a club of the country has is taken; another country's is not
      // (unless the game renames by it).
      final czech = ClubService.leagueClubs('cze').first;
      expect(
        AddedEdits.clubNameProblem(pack, czech.toUpperCase(), 'cze', const {}),
        AddedNameProblem.taken,
      );
      expect(
        AddedEdits.clubNameProblem(pack, 'FC Vltava', 'cze', const {}),
        isNull,
      );
      final one = AddedEdits.addClub(pack, 'FC Vltava', 'cze');
      expect(
        AddedEdits.clubNameProblem(one, ' fc vltava ', 'cze', const {}),
        AddedNameProblem.taken,
      );
      // Its own name is fine for itself.
      expect(
        AddedEdits.clubNameProblem(
          one,
          'FC Vltava',
          'cze',
          const {},
          id: _base,
        ),
        isNull,
      );
      // A city side of a country without a league is taken there.
      expect(
        AddedEdits.clubNameProblem(pack, 'Tirana City', 'alb', const {
          'alb': ['Tirana'],
        }),
        AddedNameProblem.taken,
      );
    });

    test('each remove drops its localized paths', () {
      var p = AddedEdits.addSponsor(
        pack,
        'Brew',
        SponsorDeal.marketing,
        SponsorBrand.values.first.name,
        'A line',
      );
      p = AddedEdits.addY(p, 'Nobody', YVoice.fan, cze);
      p = p.copyWith(
        localized: {
          PackPaths.addedSponsor(_base): {'cs': 'Pivo'},
          PackPaths.addedSponsorDescription(_base): {'cs': 'Řádek'},
          PackPaths.addedY(_base + 1): {'cs': 'Nikdo'},
          PackPaths.club('Sparta'): {'cs': 'Sparťani'},
        },
      );
      final q = AddedEdits.removeY(
        AddedEdits.removeSponsor(p, _base),
        _base + 1,
      );
      expect(q.addedSponsors, isEmpty);
      expect(q.addedYAccounts, isEmpty);
      expect(q.localized.keys, [PackPaths.club('Sparta')]);
    });

    test('the caps hold', () {
      var p = pack;
      for (var i = 0; i < PackRules.addedSponsorsMax; i++) {
        p = AddedEdits.addSponsor(
          p,
          'S$i',
          SponsorDeal.risky,
          SponsorBrand.values.first.name,
          '',
        );
      }
      expect(
        AddedEdits.addSponsor(
          p,
          'One more',
          SponsorDeal.risky,
          SponsorBrand.values.first.name,
          '',
        ),
        same(p),
      );
      expect(AddedEdits.isFull(NameSection.sponsors, p), isTrue);
      expect(AddedEdits.isFull(NameSection.clubs, p), isFalse);
    });
  });

  testWidgets('add a club to Czechia and pick it for a Czech player', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final squad = testSquad();
    final id = await insertPack(
      tester,
      c,
      testPack('Clubs', squads: {cze: squad}),
    );
    await pumpEditorRoute(tester, c, _at(EditorSection.clubs, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    // Nothing to add until it has a name and a country.
    expect(
      tester.widget<FilledButton>(find.byKey(AddedItemForm.addKey)).onPressed,
      isNull,
    );
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'FC Vltava');
    await tester.tap(find.byKey(AddedItemForm.countryKey));
    await settle(tester);
    await _pick(tester, 'czech', 'cze');
    // Czechia has a league: no warning.
    expect(find.byKey(AddedItemForm.noLeagueKey), findsNothing);
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedClubs, [
      const PackClub(id: _base, name: 'FC Vltava', country: 'cze'),
    ]);
    // It shows in Czechia's group, tagged as added.
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'vltava');
    await tester.pump();
    final row = find.byKey(
      NameSectionScreen.rowKey(PackPaths.addedClub(_base)),
    );
    expect(row, findsOneWidget);
    expect(
      find.descendant(of: row, matching: find.byKey(AddedItemForm.tagKey)),
      findsOneWidget,
    );
    final player = squad.first;
    await pumpEditorRoute(
      tester,
      c,
      editorPlayerLocation(id, cze, player.id),
    );
    await tester.ensureVisible(find.byKey(PlayerEditForm.clubKey));
    await tester.pump();
    await tester.tap(find.byKey(PlayerEditForm.clubKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(PlayerEditForm.clubSearchKey), 'Vltava');
    await tester.pump();
    await tester.tap(
      find.byKey(PlayerEditForm.clubOptionKey('FC Vltava', country: 'cze')),
    );
    await tester.pumpAndSettle();
    final stored = _pack(c, id).squads[cze]!.first;
    expect((stored.club, stored.clubCountry), ('FC Vltava', 'cze'));
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets(
    "renaming that club moves the player with it; deleting it puts him on "
    'Auto',
    (tester) async {
      final c = await editorContainer(tester);
      final squad = [
        for (final (i, p) in testSquad().indexed)
          i == 0
              ? PackPlayer(
                  id: p.id,
                  name: p.name,
                  age: p.age,
                  position: p.position,
                  attributes: p.attributes,
                  potential: p.potential,
                  club: 'FC Vltava',
                  clubCountry: 'cze',
                )
              : p,
      ];
      final id = await insertPack(
        tester,
        c,
        testPack('Move', squads: {cze: squad}).copyWith(
          addedClubs: const [
            PackClub(id: _base, name: 'FC Vltava', country: 'cze'),
          ],
        ),
      );
      await pumpEditorRoute(tester, c, _at(EditorSection.clubs, id));
      await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'vltava');
      await tester.pump();
      final row = find.byKey(
        NameSectionScreen.rowKey(PackPaths.addedClub(_base)),
      );
      await tester.tap(row);
      await settle(tester);
      // Said before a delete: he plays here.
      expect(find.byKey(AddedItemForm.playersHereKey), findsOneWidget);
      await tester.enterText(
        find.byKey(AddedItemForm.nameKey),
        'Vltava United',
      );
      await tester.pump();
      expect(_pack(c, id).addedClubs.single.name, 'Vltava United');
      expect(_pack(c, id).squads[cze]!.first.club, 'Vltava United');

      // A name Czechia's league has is refused, and nothing moves.
      final czech = ClubService.leagueClubs('cze').first;
      await tester.enterText(find.byKey(AddedItemForm.nameKey), czech);
      await tester.pump();
      expect(_pack(c, id).addedClubs.single.name, 'Vltava United');
      expect(find.text('Czechia already has a club of this name.'), findsOne);
      await tester.enterText(
        find.byKey(AddedItemForm.nameKey),
        'Vltava United',
      );
      await tester.pump();

      await tester.ensureVisible(find.byKey(AddedItemForm.deleteKey));
      await tester.tap(find.byKey(AddedItemForm.deleteKey));
      await settle(tester);
      expect(_pack(c, id).addedClubs, isEmpty);
      final back = _pack(c, id).squads[cze]!.first;
      expect((back.club, back.clubCountry), (null, null));
      // Undo brings the club and his place at it back.
      await tester.tap(find.text('Undo').last);
      await settle(tester);
      expect(_pack(c, id).addedClubs.single.name, 'Vltava United');
      expect(_pack(c, id).squads[cze]!.first.club, 'Vltava United');
      await tester.pump(const Duration(milliseconds: 450));
    },
  );

  testWidgets('add a club to a country without a league shows a new country '
      'group', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Lonely'));
    await pumpEditorRoute(tester, c, _at(EditorSection.clubs, id));
    final world = c.read(packEditorProvider(id).notifier).world;
    final lone = world.firstWhere(
      (n) => ClubService.leagueClubs(n.code).isEmpty,
    );
    final code = lone.code.toLowerCase();
    // The country's heading in the list (the search field holds its name
    // too).
    final heading = find.descendant(
      of: find.byType(CustomScrollView),
      matching: find.text(lone.name),
    );
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), lone.name);
    await tester.pump();
    expect(heading, findsNothing);

    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Lone Stars');
    await tester.tap(find.byKey(AddedItemForm.countryKey));
    await settle(tester);
    await _pick(tester, lone.name, code);
    final cities =
        c.read(packEditorProvider(id).notifier).countryCities[code] ?? [];
    expect(
      find.byKey(AddedItemForm.noLeagueKey),
      cities.isEmpty ? findsOneWidget : findsNothing,
    );
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedClubs.single.country, code);
    // The add cleared the search; searching again finds the new group.
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), lone.name);
    await tester.pump();
    expect(heading, findsOneWidget);
    expect(
      find.byKey(NameSectionScreen.rowKey(PackPaths.addedClub(_base))),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("add a sponsor with no description stores '' and lists it "
      'under Added', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Sponsors'));
    await pumpEditorRoute(tester, c, _at(EditorSection.sponsors, id));
    expect(find.text('Added'), findsNothing);
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Brewmasters');
    await tester.tap(find.byKey(AddedItemForm.dealKey(SponsorDeal.bigPayer)));
    await tester.pump();
    await tester.ensureVisible(find.byKey(AddedItemForm.industryKey));
    await tester.tap(find.byKey(AddedItemForm.industryKey));
    await settle(tester);
    // Each industry once, by its words: the first brand of a label is the
    // one stored.
    final brand = SponsorBrand.values.first;
    final label = sponsorIndustryLabel(
      lookupAppLocalizations(const Locale('en')),
      brand,
    );
    await _pick(tester, label, brand.name);
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedSponsors, [
      PackSponsor(
        id: _base,
        name: 'Brewmasters',
        deal: SponsorDeal.bigPayer,
        industry: brand.name,
      ),
    ]);
    expect(_pack(c, id).addedSponsors.single.description, '');
    expect(find.text('Added'), findsOneWidget);
    expect(
      find.byKey(NameSectionScreen.rowKey(PackPaths.addedSponsor(_base))),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an added Y account named TheOldStopper is refused', (
    tester,
  ) async {
    expect(YFeed.namedAccounts, contains('TheOldStopper'));
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Y'));
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'theoldstopper');
    await tester.pump();
    expect(find.text('Another account already has this name.'), findsOne);
    expect(
      tester.widget<FilledButton>(find.byKey(AddedItemForm.addKey)).onPressed,
      isNull,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an added Y account may not show a name another account '
      'shows in a language', (tester) async {
    final c = await editorContainer(tester);
    final first = YFeed.namedAccounts.first;
    final id = await insertPack(
      tester,
      c,
      testPack('YL').copyWith(
        localized: {
          PackPaths.yAccount(first): {'cs': 'PanFotbal'},
        },
      ),
    );
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'PanFotbal');
    await tester.pump();
    expect(find.text('Another account already has this name.'), findsOne);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'PaniFotbal');
    await tester.pump();
    expect(find.text('Another account already has this name.'), findsNothing);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('add a Y meme account for Czechia stores voice meme and '
      'nationId', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Meme'));
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'KnedlikMemes');
    await tester.tap(find.byKey(AddedItemForm.voiceKey(YVoice.meme)));
    await tester.pump();
    await tester.ensureVisible(find.byKey(AddedItemForm.nationKey));
    await tester.tap(find.byKey(AddedItemForm.nationKey));
    await settle(tester);
    await _pick(tester, 'czech', '$cze');
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(_pack(c, id).addedYAccounts, [
      PackYAccount(
        id: _base,
        name: 'KnedlikMemes',
        voice: YVoice.meme,
        nationId: cze,
      ),
    ]);

    // In a language, an added row edits only its name there.
    await tester.tap(find.byKey(EditorLanguageChip.chipKey));
    await settle(tester);
    await tester.tap(find.byKey(EditorLanguageChip.optionKey('cs')));
    await settle(tester);
    expect(find.byKey(NameSectionScreen.addKey), findsNothing);
    await tester.tap(
      find.byKey(NameSectionScreen.rowKey(PackPaths.addedY(_base))),
    );
    await settle(tester);
    expect(find.byKey(AddedItemForm.deleteKey), findsNothing);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'KnedlíkMémy');
    await tester.pump();
    expect(_pack(c, id).localized[PackPaths.addedY(_base)], {
      'cs': 'KnedlíkMémy',
    });
    expect(_pack(c, id).addedYAccounts.single.name, 'KnedlikMemes');
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("an added sponsor's name and description in Czech", (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('SponsorCs').copyWith(
        addedSponsors: [
          PackSponsor(
            id: _base,
            name: 'Brewmasters',
            deal: SponsorDeal.marketing,
            industry: SponsorBrand.values.first.name,
            description: 'Beer for everyone.',
          ),
        ],
      ),
    );
    await pumpEditorRoute(tester, c, _at(EditorSection.sponsors, id));
    await tester.tap(find.byKey(EditorLanguageChip.chipKey));
    await settle(tester);
    await tester.tap(find.byKey(EditorLanguageChip.optionKey('cs')));
    await settle(tester);
    await tester.tap(
      find.byKey(NameSectionScreen.rowKey(PackPaths.addedSponsor(_base))),
    );
    await settle(tester);
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Pivovarníci');
    await tester.enterText(
      find.byKey(NameEditForm.outletKey),
      'Pivo pro všechny.',
    );
    await tester.pump();
    final p = _pack(c, id);
    expect(p.localized[PackPaths.addedSponsor(_base)], {'cs': 'Pivovarníci'});
    expect(p.localized[PackPaths.addedSponsorDescription(_base)], {
      'cs': 'Pivo pro všechny.',
    });
    expect(p.addedSponsors.single.description, 'Beer for everyone.');
    // Deleting the sponsor takes its names in every language.
    expect(
      AddedEdits.removeSponsor(p, _base).localized,
      isEmpty,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets("an imported added club named like another country's renamed "
      'club is flagged, opens, and is fixed by a rename or Remove', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final english = ClubService.leagueClubs('eng').first;
    final squad = testSquad();
    final first = squad.first;
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Clash',
        squads: {
          cze: [
            SquadEdits.withClub(first, english, 'cze'),
            ...squad.skip(1),
          ],
        },
      ).copyWith(
        clubs: {english: 'Renamed Lions'},
        addedClubs: [PackClub(id: _base, name: english, country: 'cze')],
      ),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    final editor = c.read(packEditorProvider(id).notifier);
    expect(
      editor.issues.whereType<NameClash>().map((i) => i.path),
      ['addedClubs.$_base'],
    );
    expect(editor.needsAttention, isTrue);
    expect(find.byKey(PackHomeScreen.attentionKey), findsOneWidget);
    // The editor shows the added club under its own name, not the rename.
    expect(
      clubLabel(
        lookupAppLocalizations(const Locale('en')),
        _pack(c, id),
        _pack(c, id).squads[cze]!.first,
      ),
      english,
    );

    // A rename fixes it, and the player moves with it.
    editor.update((p) => AddedEdits.renameClub(p, _base, 'FC Vltava'));
    expect(editor.needsAttention, isFalse);
    expect(_pack(c, id).squads[cze]!.first.club, 'FC Vltava');
    editor.undo();
    await tester.pump();
    expect(editor.needsAttention, isTrue);

    // So does the home's Remove, which puts him on Auto.
    final index = editor.issues.indexWhere((i) => i is NameClash);
    await tester.tap(find.byKey(PackHomeScreen.removeKey(index)));
    await settle(tester);
    expect(_pack(c, id).addedClubs, isEmpty);
    expect(_pack(c, id).squads[cze]!.first.club, isNull);
    expect(editor.needsAttention, isFalse);
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('after an add on the phone the search goes, so the new item '
      'shows', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Search'));
    await pumpEditorRoute(tester, c, _at(EditorSection.yAccounts, id));
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), 'zzz');
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.addKey));
    await settle(tester);
    await tester.enterText(find.byKey(AddedItemForm.nameKey), 'Knedlik');
    await tester.pump();
    await tester.ensureVisible(find.byKey(AddedItemForm.addKey));
    await tester.tap(find.byKey(AddedItemForm.addKey));
    await settle(tester);
    expect(
      tester
          .widget<TextField>(find.byKey(NameSectionScreen.searchKey))
          .controller!
          .text,
      isEmpty,
    );
    expect(
      find.byKey(NameSectionScreen.rowKey(PackPaths.addedY(_base))),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('the home counts added items in their sections', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Home').copyWith(
        addedClubs: const [
          PackClub(id: _base, name: 'FC Vltava', country: 'cze'),
          PackClub(id: _base + 1, name: 'FC Labe', country: 'cze'),
        ],
      ),
    );
    await pumpEditorRoute(tester, c, editorPackLocation(id));
    expect(find.byType(PackHomeScreen), findsOneWidget);
    expect(find.text('2 added'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
  });

  for (final size in kTabletSizes) {
    testWidgets('tablet sizes render, $size', (tester) async {
      final c = await editorContainer(tester, formFactor: FormFactor.tablet);
      final id = await insertPack(
        tester,
        c,
        testPack('Tablet').copyWith(
          addedClubs: const [
            PackClub(id: _base, name: 'FC Vltava', country: 'cze'),
          ],
          addedSponsors: [
            PackSponsor(
              id: _base + 1,
              name: 'Brewmasters',
              deal: SponsorDeal.marketing,
              industry: SponsorBrand.values.first.name,
            ),
          ],
          addedYAccounts: const [
            PackYAccount(id: _base + 2, name: 'Knedlik', voice: YVoice.fan),
          ],
        ),
      );
      for (final (section, path) in [
        (EditorSection.clubs, PackPaths.addedClub(_base)),
        (EditorSection.sponsors, PackPaths.addedSponsor(_base + 1)),
        (EditorSection.yAccounts, PackPaths.addedY(_base + 2)),
      ]) {
        await pumpEditorRoute(tester, c, _at(section, id), size: size);
        expect(tester.takeException(), isNull);
        expect(find.byKey(NameSectionScreen.tabletLayoutKey), findsOneWidget);
        await tester.enterText(
          find.byKey(NameSectionScreen.searchKey),
          switch (section) {
            EditorSection.clubs => 'Vltava',
            EditorSection.sponsors => 'Brew',
            _ => 'Knedlik',
          },
        );
        await tester.pump();
        // The added item edits beside the list.
        await tester.tap(find.byKey(NameSectionScreen.rowKey(path)));
        await settle(tester);
        expect(find.byKey(AddedItemForm.deleteKey), findsOneWidget);
        expect(tester.takeException(), isNull);
        // Add opens its form in a dialog.
        await tester.tap(find.byKey(NameSectionScreen.addKey));
        await settle(tester);
        expect(find.byKey(AddedItemForm.addKey), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tapAt(const Offset(4, 4));
        await settle(tester);
      }
      await tester.pump(const Duration(milliseconds: 450));
    });
  }
}
