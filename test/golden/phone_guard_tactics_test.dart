import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tactics/nation_squad_tab.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/seeded_save.dart';

/// The phone tactics screen, one golden per tab, pinned before the tablet
/// layout is added beside it. The tabs scroll, so the instructions and roles
/// tabs are shot in a tall frame.
void main() {
  testWidgets('phone tactics, line-up tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.tactics}?careerId=${save.careerId}');
    expect(find.byType(TacticsPitch), findsOneWidget);
    await expectAppGolden('goldens/tactics_phone.png');
  });

  testWidgets('phone tactics, instructions tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: const Size(390, 1500),
    );
    await tester.tap(find.text(enL.tacticsTabInstructions));
    await settle(tester);
    await expectAppGolden('goldens/tactics_instructions_phone.png');
  });

  testWidgets('phone tactics, roles and set pieces tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: const Size(390, 1500),
    );
    await tester.tap(find.text(enL.tacticsTabRolesSetPieces));
    await settle(tester);
    await expectAppGolden('goldens/tactics_roles_phone.png');
  });

  testWidgets('phone squad tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
    );
    expect(find.byType(NationSquadTab), findsOneWidget);
    await expectAppGolden('goldens/squad_phone.png');
  });
}
