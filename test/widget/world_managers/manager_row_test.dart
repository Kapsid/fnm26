import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/nations/nation_now_card.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/seeded_save.dart';

Future<void> _pump(WidgetTester tester, SeededSave save, int nationId) async {
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
            child: NationNowCard(careerId: save.careerId, nationId: nationId),
          ),
        ),
      ),
    ),
  );
  await settle(tester);
}

int _otherNation(SeededSave s) =>
    s.nations.firstWhere((n) => n.id != s.nationId).id;

void main() {
  testWidgets("another nation's page shows the manager row", (tester) async {
    final save = await seedSave(tester);
    final other = _otherNation(save);
    await _pump(tester, save, other);
    expect(find.byKey(NationNowCard.managerKey), findsOneWidget);
    final view = save.container
        .read(
          nationManagerProvider((careerId: save.careerId, nationId: other)),
        )
        .value!;
    expect(find.text(view.m.name), findsOneWidget);
  });

  testWidgets('your own nation shows none', (tester) async {
    final save = await seedSave(tester);
    await _pump(tester, save, save.nationId);
    expect(find.byKey(NationNowCard.managerKey), findsNothing);
    expect(find.byType(ManagerRow), findsNothing);
  });

  testWidgets('tap opens his page with career, record and tie', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final other = _otherNation(save);
    await pumpRoute(
      tester,
      save,
      '${Routes.nationVitrine}?careerId=${save.careerId}&nationId=$other',
      size: const Size(900, 1600),
    );
    await tester.ensureVisible(find.byKey(ManagerRow.rowKey));
    await tester.pump();
    await tester.tap(find.byKey(ManagerRow.rowKey));
    await settle(tester);
    expect(find.byType(ManagerDetailScreen), findsOneWidget);
    await tester.tap(find.byKey(ManagerDetailScreen.tabCareerKey));
    await tester.pump();
    expect(find.byKey(ManagerDetailScreen.careerKey), findsOneWidget);
    await tester.tap(find.byKey(ManagerDetailScreen.tabVsYouKey));
    await tester.pump();
    expect(find.text(enL.mgrProfileNoMeetings), findsOneWidget);
    expect(find.byKey(ManagerDetailScreen.tieKey), findsOneWidget);
    expect(find.text(enL.mgrTieNeutral), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets("the row does not rebuild NationNowCard's provider", (
    tester,
  ) async {
    final save = await seedSave(tester);
    final other = _otherNation(save);
    await _pump(tester, save, other);
    final key = (careerId: save.careerId, nationId: other);
    final before = save.container.read(nationNowProvider(key));
    save.container.invalidate(nationManagerProvider(key));
    await settle(tester);
    expect(
      identical(save.container.read(nationNowProvider(key)), before),
      isTrue,
    );
    expect(find.byKey(NationNowCard.managerKey), findsOneWidget);
  });

  testWidgets('a cycle without world managers (an old save) shows the row', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container.read(appDatabaseProvider).customStatement(
        'DELETE FROM draws_watched WHERE career_id = ? AND kind = ?',
        [save.careerId, worldManagersKind],
      ),
    );
    await _pump(tester, save, _otherNation(save));
    expect(find.byKey(NationNowCard.managerKey), findsOneWidget);
    expect(find.byType(ManagerRow), findsOneWidget);
  });
}
