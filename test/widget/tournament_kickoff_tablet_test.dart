import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/tournament_kickoff_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.tournamentKickoff}?careerId=${save.careerId}',
    size: size,
  );
  await tester.pump(const Duration(milliseconds: 1200));
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the trophy beside the words, full screen, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TournamentKickoffScreen.landscapeKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(
        tester.getCenter(find.byType(Image).first).dx,
        lessThan(tester.getCenter(find.text(enL.tourSharedFinalsAreHere)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('beginning marks the kickoff seen and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.tourSharedLetFinalsBegin),
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
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            worldCupKickoffKind,
          );
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
