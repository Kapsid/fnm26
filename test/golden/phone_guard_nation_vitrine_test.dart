import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';

import '../helpers/nation_page_fixture.dart';
import '../helpers/seeded_save.dart';

/// The nation page: its Overview on a phone (and the whole of it on a tall
/// one), the Squad, Results, History and Stadiums tabs, and the tablet's two
/// panes.
void main() {
  for (final (name, size) in [
    ('nation_vitrine_phone', kPhoneSize),
    ('nation_vitrine_phone_tall', const Size(390, 2000)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}'
        '&nationId=${save.nationId}',
        size: size,
      );
      expect(find.text(enL.nationsHonours), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  for (final (tab, name) in [
    (1, 'squad'),
    (2, 'results'),
    (3, 'history'),
    (4, 'stadiums'),
  ]) {
    testWidgets('nation_vitrine_phone_$name', (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}'
        '&nationId=${save.nationId}',
        size: const Size(390, 1600),
      );
      await tester.tap(find.byKey(NationVitrineScreen.tabKeys[tab]));
      await settle(tester, rounds: 10);
      await expectAppGolden('goldens/nation_vitrine_phone_$name.png');
    });
  }

  testWidgets('nation_vitrine_phone_folded', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.nationVitrine}?careerId=${save.careerId}'
      '&nationId=${save.nationId}',
    );
    await tester.tap(find.byKey(NationVitrineScreen.tabKeys[1]));
    await settle(tester, rounds: 10);
    await tester.drag(
      find.byKey(NationVitrineScreen.xiKey),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await expectAppGolden('goldens/nation_vitrine_phone_folded.png');
  });

  // Another nation with a history: its facts, a record against you and a
  // page of results.
  for (final (tab, name) in [(0, 'overview'), (2, 'results')]) {
    testWidgets('nation_vitrine_phone_history_$name', (tester) async {
      final save = await seedSave(
        tester,
        overrides: [nationDetailWithHistory()],
      );
      final other = save.nations.firstWhere((n) => n.code == 'GER');
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}'
        '&nationId=${other.id}',
        size: const Size(390, 1600),
      );
      await tester.tap(find.byKey(NationVitrineScreen.tabKeys[tab]));
      await settle(tester, rounds: 10);
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/nation_vitrine_phone_history_$name.png');
    });
  }

  testWidgets('nation_vitrine_tablet_history', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [nationDetailWithHistory()],
    );
    final other = save.nations.firstWhere((n) => n.code == 'GER');
    await pumpRoute(
      tester,
      save,
      '${Routes.nationVitrine}?careerId=${save.careerId}'
      '&nationId=${other.id}',
      size: const Size(1180, 820),
    );
    expect(tester.takeException(), isNull);
    await expectAppGolden('goldens/nation_vitrine_tablet_history.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nation_vitrine_tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.nationVitrine}?careerId=${save.careerId}'
      '&nationId=${save.nationId}',
      size: const Size(1180, 820),
    );
    await expectAppGolden('goldens/nation_vitrine_tablet.png');
    await tester.pumpWidget(const SizedBox());
  });
}
