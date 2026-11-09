import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/world_managers/manager_row.dart';
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
}
