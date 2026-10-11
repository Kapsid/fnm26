import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.nationVitrine}?careerId=${save.careerId}'
    '&nationId=${save.nationId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('honours and standing left, scorers right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationVitrineScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final honours = tester.getRect(find.text(enL.nationsHonours));
      final history = tester.getRect(find.text(enL.nationsRankingHistory));
      final scorers = tester.getRect(find.text(enL.nationsTopScorers));
      expect(history.top, greaterThan(honours.top));
      expect(scorers.left, greaterThan(honours.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

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
