import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/results/results_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await watchContinentalQualifyingDraw(tester, save);
  await pumpRoute(
    tester,
    save,
    '${Routes.results}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets("cycles left, the picked cycle's matches right, $size", (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ResultsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(MasterDetail), findsOneWidget);
      final me = save.nations.firstWhere((n) => n.id == save.nationId);
      // Scoped: the top bar names the nation too.
      final cycle = find.descendant(
        of: find.byType(MasterDetail),
        matching: find.textContaining(me.name),
      );
      expect(cycle, findsWidgets);
      // A competition panel on the right, with its fixtures in it.
      final panel = find.byType(Panel);
      expect(panel, findsWidgets);
      expect(
        tester.getCenter(cycle.first).dx,
        lessThan(tester.getCenter(panel.last).dx),
      );
      expect(find.text(enL.resultsCycleUnderway), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a nation in a fixture row opens its page', (tester) async {
    await _open(tester, kTabletSize);
    final tap = find.byType(NationTap);
    expect(tap, findsWidgets);
    await tester.tap(tap.first);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(NationVitrineScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
