import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('confidence first, one panel per objective, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      late List<CycleObjective> objectives;
      await tester.runAsync(() async {
        final sub = save.container.listen(
          cycleObjectivesProvider(save.careerId).future,
          (_, _) {},
        );
        objectives = await sub.read();
        sub.close();
      });
      expect(objectives, isNotEmpty, reason: 'a fresh save has a brief');
      await pumpRoute(
        tester,
        save,
        '${Routes.boardObjectives}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(BoardObjectivesScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // One panel for the confidence and one per objective.
      expect(find.byType(Panel), findsNWidgets(objectives.length + 1));
      final confidence = tester.getRect(
        find
            .ancestor(
              of: find.text(enL.boardObjectivesConfidence.toUpperCase()),
              matching: find.byType(Panel),
            )
            .first,
      );
      final first = tester.getRect(
        find
            .ancestor(
              of: find.text(objectives.first.label),
              matching: find.byType(Panel),
            )
            .first,
      );
      expect(first.top, confidence.top);
      expect(first.left, greaterThan(confidence.right));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
