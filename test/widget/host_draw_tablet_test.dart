import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.hostDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the envelope left, the candidates right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostDrawScreen.landscapeKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(
        tester.getCenter(find.byIcon(Icons.mail_outline_rounded).first).dx,
        lessThan(tester.getCenter(find.text(enL.tourCandidates)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('opening the envelope marks it seen; Continue goes home', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    late bool before;
    await tester.runAsync(() async {
      before = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            continentalHostDrawKind,
          );
    });
    expect(before, isFalse, reason: 'unseen until the envelope is opened');
    await tester.tap(find.text(enL.tourSharedOpenEnvelope));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(tester.takeException(), isNull);
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            continentalHostDrawKind,
          );
    });
    expect(watched, isTrue);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.tourSharedContinue),
    );
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.hub,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
