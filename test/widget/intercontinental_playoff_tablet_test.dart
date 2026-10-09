import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      intercontinentalPlayoffProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakePlayoff(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.intercontinentalPlayoff}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the bracket under a header with Continue top right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(IntercontinentalPlayoffScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      final bracket = find.byType(IntercontinentalPlayoffBracket);
      expect(bracket, findsOneWidget);
      final go = find.widgetWithText(PrimaryButton, enL.tourContContinue);
      expect(go, findsOneWidget);
      expect(tester.getCenter(go).dy, lessThan(tester.getRect(bracket).top));
      expect(
        tester.getCenter(go).dx,
        greaterThan(tester.getCenter(bracket).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue marks the play-off seen and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.tourContContinue));
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.routeInformationProvider.value.uri.path, Routes.hub);
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            worldCupPlayoffKind,
          );
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
