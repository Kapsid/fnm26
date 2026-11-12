import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/nations/nation_now_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/world_managers/manager_detail_screen.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
import 'package:fnm/features/world_managers/world_manager_markers.dart';
import 'package:fnm/features/world_managers/world_manager_providers.dart';

import '../../helpers/seeded_save.dart';

/// A nation's page, opened on its History tab, where the manager row sits.
Future<void> _pump(WidgetTester tester, SeededSave save, int nationId) async {
  await pumpRoute(
    tester,
    save,
    '${Routes.nationVitrine}?careerId=${save.careerId}&nationId=$nationId',
    size: const Size(900, 1600),
  );
  await tester.tap(find.byKey(NationVitrineScreen.tabKeys[3]));
  await settle(tester, rounds: 10);
}

int _otherNation(SeededSave s) =>
    s.nations.firstWhere((n) => n.id != s.nationId).id;

void main() {
  testWidgets("another nation's page shows the manager row", (tester) async {
    final save = await seedSave(tester);
    final other = _otherNation(save);
    await _pump(tester, save, other);
    expect(find.byKey(NationVitrineScreen.managerKey), findsOneWidget);
    final view = save.container
        .read(
          nationManagerProvider((careerId: save.careerId, nationId: other)),
        )
        .value!;
    // Named in the row, and in the header's numbers.
    expect(
      find.descendant(
        of: find.byType(ManagerRow),
        matching: find.text(view.m.name),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(NationVitrineScreen.managerStatKey),
        matching: find.text(view.m.name),
      ),
      findsOneWidget,
    );
  });

  testWidgets('your own nation shows none', (tester) async {
    final save = await seedSave(tester);
    await _pump(tester, save, save.nationId);
    expect(find.byKey(NationVitrineScreen.managerKey), findsNothing);
    expect(find.byType(ManagerRow), findsNothing);
  });

  testWidgets('tap opens his page with career, record and tie', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final other = _otherNation(save);
    await _pump(tester, save, other);
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

  testWidgets("the row does not rebuild the page's now read", (
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
    expect(find.byKey(NationVitrineScreen.managerKey), findsOneWidget);
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
    expect(find.byKey(NationVitrineScreen.managerKey), findsOneWidget);
    expect(find.byType(ManagerRow), findsOneWidget);
  });
}
