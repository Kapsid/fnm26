import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/names/name_section_screen.dart';
import 'package:fnm/features/editor/names/name_sections.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/editor/players/player_edit_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/editor_app.dart';
import '../helpers/seeded_save.dart';

WorldPack _pack(ProviderContainer c, int id) =>
    c.read(packEditorProvider(id)).value!;

void main() {
  final cze = nationIdOf('CZE');
  final en = lookupAppLocalizations(const Locale('en'));
  // testSquad(): goalkeepers 1-3, defenders 4-10, midfielders 11-18.
  const mid = kPackPlayerIdBase + 11;

  testWidgets('a club renamed to a slur shows the error and is not saved', (
    tester,
  ) async {
    final c = await editorContainer(tester);
    final id = await insertPack(tester, c, testPack('Clubs'));
    final club = ClubService.leagueClubs('cze').first;
    await pumpEditorRoute(
      tester,
      c,
      editorSectionLocation(NameSection.clubs.editorSection, id),
    );
    await tester.enterText(find.byKey(NameSectionScreen.searchKey), club);
    await tester.pump();
    await tester.tap(find.byKey(NameSectionScreen.rowKey(club)));
    await settle(tester);

    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Kurva FC');
    await tester.pump();
    expect(find.text(en.editorNameNotAllowed), findsOneWidget);
    expect(_pack(c, id).clubs, isEmpty);

    // An evasion is refused the same way.
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'F.U.C.K Praha');
    await tester.pump();
    expect(find.text(en.editorNameNotAllowed), findsOneWidget);
    expect(_pack(c, id).clubs, isEmpty);

    // A clean name is stored, and the error goes.
    await tester.enterText(find.byKey(NameEditForm.nameKey), 'Scunthorpe FC');
    await tester.pump();
    expect(find.text(en.editorNameNotAllowed), findsNothing);
    expect(_pack(c, id).clubs, {club: 'Scunthorpe FC'});
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('a player named with a slur shows the error and keeps his '
      'last name', (tester) async {
    final c = await editorContainer(tester);
    final id = await insertPack(
      tester,
      c,
      testPack('Players', squads: {cze: testSquad()}),
    );
    await pumpEditorRoute(
      tester,
      c,
      '${Routes.editorPlayer}?id=$id&nation=$cze&player=$mid',
    );
    expect(find.byType(PlayerEditScreen), findsOneWidget);

    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Pavel Nový');
    await tester.pump();
    String stored() =>
        _pack(c, id).squads[cze]!.firstWhere((p) => p.id == mid).name;
    expect(stored(), 'Pavel Nový');

    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Bitch Nový');
    await tester.pump();
    expect(find.text(en.editorNameNotAllowed), findsOneWidget);
    expect(stored(), 'Pavel Nový');

    await tester.enterText(find.byKey(PlayerEditForm.nameKey), 'Petr Nový');
    await tester.pump();
    expect(find.text(en.editorNameNotAllowed), findsNothing);
    expect(stored(), 'Petr Nový');
    await tester.pump(const Duration(milliseconds: 450));
  });

  testWidgets('an imported slur is listed on the home, masked, and the pack '
      'stays ready', (tester) async {
    final c = await editorContainer(tester);
    final squad = testSquad();
    final bad = PackPlayer(
      id: squad.first.id,
      name: 'Fuck Face',
      age: squad.first.age,
      position: squad.first.position,
      attributes: squad.first.attributes,
      potential: squad.first.potential,
    );
    final id = await insertPack(
      tester,
      c,
      testPack(
        'Shared',
        squads: {
          cze: [bad, ...squad.skip(1)],
        },
      ),
    );
    await pumpEditorRoute(tester, c, '${Routes.editorPack}?id=$id');
    final issues = c.read(packEditorProvider(id).notifier).issues;
    expect(issues.whereType<NotAllowedName>().map((i) => i.where), [
      'squads.$cze.${bad.id}.name',
    ]);
    // Listed, masked, but nothing blocks a career for it.
    expect(
      find.text(en.editorIssueNameNotAllowed('F*** Face')),
      findsOneWidget,
    );
    expect(find.text('Fuck Face'), findsNothing);
    expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 450));
  });
}
