import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

Future<NationManagerView> _pump(WidgetTester tester, SeededSave save) async {
  final opp = save.nations.firstWhere((n) => n.id != save.nationId);
  final career = await tester.runAsync(
    () => save.container.read(careerRepositoryProvider).byId(save.careerId),
  );
  final date = career!.inGameDate;
  final view = (await tester.runAsync(
    () => save.container.read(
      opponentManagerProvider(
        (careerId: save.careerId, nationId: opp.id, date: date),
      ).future,
    ),
  ))!;
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OpponentBriefing(
              careerId: save.careerId,
              myNationId: save.nationId,
              oppNationId: opp.id,
              oppName: opp.name,
              oppCode: opp.code,
              keyMen: const [],
              saveSeed: 1,
              fixtureDate: date,
            ),
          ),
        ),
      ),
    ),
  );
  await settle(tester);
  return view;
}

void main() {
  testWidgets('preview names the opposing manager', (tester) async {
    final save = await seedSave(tester);
    final view = await _pump(tester, save);
    expect(find.byKey(OpponentManagerLine.lineKey), findsOneWidget);
    expect(find.text(enL.mgrPreviewLine(view.m.name)), findsOneWidget);
  });

  testWidgets('tie chip only when not neutral', (tester) async {
    final save = await seedSave(tester);
    final view = await _pump(tester, save);
    expect(find.byKey(OpponentManagerLine.chipKey), findsNothing);

    await tester.runAsync(
      () => save.container
          .read(worldManagerRepositoryProvider)
          .addTie(
            save.careerId,
            managerId: view.m.managerId,
            kind: TieKind.grudge,
            delta: -20,
            date: DateTime(2030),
          ),
    );
    save.container.invalidate(managerRelationProvider);
    await settle(tester);
    expect(find.byKey(OpponentManagerLine.chipKey), findsOneWidget);
    expect(find.text(enL.mgrTieGrudge), findsOneWidget);
  });

  testWidgets('an unmarked cycle (an old save) still names the manager, but '
      'his style is not read', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container.read(appDatabaseProvider).customStatement(
        'DELETE FROM draws_watched WHERE career_id = ? AND kind = ?',
        [save.careerId, worldManagersKind],
      ),
    );
    final opp = save.nations.firstWhere((n) => n.id != save.nationId);
    final career = await tester.runAsync(
      () => save.container.read(careerRepositoryProvider).byId(save.careerId),
    );
    final view = await tester.runAsync(
      () => save.container.read(
        opponentManagerProvider(
          (
            careerId: save.careerId,
            nationId: opp.id,
            date: career!.inGameDate,
          ),
        ).future,
      ),
    );
    expect(view, isNotNull);
    final style = await tester.runAsync(
      () => save.container
          .read(worldManagerServiceProvider)
          .styleOn(save.careerId, opp.id, career!.inGameDate),
    );
    expect(style, isNull, reason: 'his effects wait for a marked cycle');
  });

  testWidgets("the real phone preview names the fixture's manager", (
    tester,
  ) async {
    final save = await seedSave(tester);
    late MatchPreview preview;
    late NationManagerView view;
    await tester.runAsync(() async {
      preview = (await save.container.read(
        matchPreviewProvider(save.careerId).future,
      ))!;
      final opp = preview.playerIsHome
          ? preview.fixture.awayNationId
          : preview.fixture.homeNationId;
      view = (await save.container.read(
        opponentManagerProvider(
          (
            careerId: save.careerId,
            nationId: opp,
            date: preview.fixture.date,
          ),
        ).future,
      ))!;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
    );
    expect(find.byKey(OpponentManagerLine.lineKey), findsOneWidget);
    expect(find.text(enL.mgrPreviewLine(view.m.name)), findsOneWidget);
  });

  testWidgets("the tablet Tactics dossier names the fixture's manager", (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late HubData hub;
    await tester.runAsync(() async {
      hub = (await save.container.read(
        hubDataProvider(save.careerId).future,
      ))!;
    });
    final next = hub.next!;
    final oppId = next.homeNationId == save.nationId
        ? next.awayNationId
        : next.homeNationId;
    late NationManagerView view;
    await tester.runAsync(() async {
      view = (await save.container.read(
        opponentManagerProvider(
          (careerId: save.careerId, nationId: oppId, date: next.date),
        ).future,
      ))!;
      await save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            save.careerId,
            save.career.cyclePointer,
            drawKindForFixture(next)!,
          );
    });
    // Kept alive, so the line's own read finds the answer already there.
    save.container.listen(
      opponentManagerProvider(
        (careerId: save.careerId, nationId: oppId, date: next.date),
      ),
      (_, _) {},
    );
    save.container.invalidate(hubDataProvider(save.careerId));
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    await tester.tap(find.text(enL.matchDossierTitle.toUpperCase()));
    await settle(tester);
    expect(find.text(enL.mgrPreviewLine(view.m.name)), findsOneWidget);
  });
}
