import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/career_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets("the manager's league, its groups in columns, $size", (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: null,
          )).overrideWith((ref) async => fakeNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationsCupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(NationsCupView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      // Opens on League B, the manager's, B1 and B2 side by side.
      final b1 = tester.getRect(
        find.text(enL.tourContGroupHeading('B1')).hitTestable(),
      );
      final b2 = tester.getRect(
        find.text(enL.tourContGroupHeading('B2')).hitTestable(),
      );
      expect(b1.top, b2.top);
      expect(b2.left, greaterThan(b1.right));
      // The finals tab says they are still to come.
      await showTab(tester, 1);
      expect(find.text(enL.tourContFinalsFourSoon), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final size in kTabletSizes) {
    testWidgets('the African cup: its zones, groups in columns, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: Confederation.africa,
          )).overrideWith((ref) async => fakeAfricanNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}'
        '&conf=${Confederation.africa.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationsCupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.text(enL.tourContTabZones), findsOneWidget);
      expect(find.text(enL.tourContTabFinalsEight), findsOneWidget);
      // A manager from elsewhere: the zones in their own order, North first.
      expect(
        find.text(africaZoneLabel(enL, AfricaZone.north).toUpperCase()),
        findsOneWidget,
      );
      final n1 = tester.getRect(
        find.text(enL.tourContGroupHeading('N1')).hitTestable(),
      );
      final n2 = tester.getRect(
        find.text(enL.tourContGroupHeading('N2')).hitTestable(),
      );
      expect(n1.top, n2.top);
      expect(n2.left, greaterThan(n1.right));
      await showTab(tester, 1);
      expect(find.text(enL.tourContFinalsEightSoon), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
