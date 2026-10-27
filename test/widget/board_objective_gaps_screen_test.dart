import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../helpers/seeded_save.dart';

/// b8 item 4: a competition the board set no target in is shown, said as
/// such, rather than left out (a board screen of one objective read as
/// broken).
void main() {
  final gaps = cycleObjectiveGapsProvider(kSeededCareerId).overrideWith(
    (ref) async => const <ObjectiveGap>[
      (
        tier: TournamentTier.continental,
        competition: 'European Championship',
        reason: ObjectiveGapReason.noBrief,
      ),
      (
        tier: TournamentTier.world,
        competition: 'World Championship',
        reason: ObjectiveGapReason.noBrief,
      ),
    ],
  );

  String route(SeededSave s) =>
      '${Routes.boardObjectives}?careerId=${s.careerId}';

  testWidgets('the phone lists a no-target row for each missing brief', (
    tester,
  ) async {
    final save = await seedSave(tester, overrides: [gaps]);
    await pumpRoute(tester, save, route(save));
    expect(find.byType(BoardObjectivesScreen), findsOneWidget);
    expect(find.text(enL.boardObjectiveNoBrief), findsNWidgets(2));
    expect(
      find.byKey(ObjectiveGapBody.keyFor(TournamentTier.continental)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final code in const ['de', 'fi', 'hu', 'el', 'pt', 'cs']) {
    testWidgets('fits 360 wide at text 1.4 ($code)', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final save = await seedSave(tester, overrides: [gaps]);
      await pumpRoute(
        tester,
        save,
        route(save),
        size: const Size(360, 740),
        locale: Locale(code),
      );
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the tablet gives each a panel', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [gaps],
    );
    await pumpRoute(tester, save, route(save), size: kTabletSize);
    expect(find.byKey(BoardObjectivesScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.boardObjectiveNoBrief), findsNWidgets(2));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
