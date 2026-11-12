import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  int? nationId,
}) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.nationVitrine}?careerId=${save.careerId}'
    '&nationId=${nationId ?? save.nationId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in [const Size(1180, 820), ...kTabletSizes]) {
    testWidgets('who it is on the left, the tabs on the right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationVitrineScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final side = tester.getRect(find.byKey(NationVitrineScreen.headerKey));
      expect(side.width, lessThanOrEqualTo(400));
      final tabs = tester.getRect(find.byKey(NationVitrineScreen.tabKeys[0]));
      expect(tabs.left, greaterThan(side.right));
      // The Overview in two columns: the next match beside the medals.
      final next = tester.getRect(find.byKey(NationVitrineScreen.nextKey));
      final medals = tester.getRect(find.byKey(NationVitrineScreen.medalsKey));
      expect(medals.left, greaterThan(next.right));
      // Never folds on a tablet.
      expect(find.byKey(NationVitrineScreen.collapsedKey), findsNothing);
      for (final key in NationVitrineScreen.tabKeys) {
        await tester.tap(find.byKey(key));
        await settle(tester, rounds: 10);
        expect(tester.takeException(), isNull, reason: '$key');
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('another nation, every tab at 1180 x 820', (tester) async {
    final longest = realNations.reduce(
      (a, b) => b.name.length > a.name.length ? b : a,
    );
    await _open(tester, const Size(1180, 820), nationId: longest.id);
    for (final key in NationVitrineScreen.tabKeys) {
      await tester.tap(find.byKey(key));
      await settle(tester, rounds: 10);
      expect(tester.takeException(), isNull, reason: '$key');
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to the ranking, as on the '
      'phone', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.ranking,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
