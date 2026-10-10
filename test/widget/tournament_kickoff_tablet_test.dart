import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/tournament_kickoff_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  Confederation? conf,
}) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.tournamentKickoff}?careerId=${save.careerId}'
    '${conf == null ? '' : '&conf=${conf.name}'}',
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
        tester
            .getCenter(
              find
                  .descendant(
                    of: find.byKey(TournamentKickoffScreen.landscapeKey),
                    matching: find.byType(Image),
                  )
                  .first,
            )
            .dx,
        lessThan(tester.getCenter(find.text(enL.tourSharedFinalsAreHere)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('beginning marks the kickoff seen and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    Future<bool> watched(String kind) async {
      late bool v;
      await tester.runAsync(() async {
        v = await save.container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(save.careerId, save.career.cyclePointer, kind);
      });
      return v;
    }

    expect(await watched(worldCupKickoffKind), isFalse);
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
    expect(await watched(worldCupKickoffKind), isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in kTabletSizes) {
    testWidgets('a continental kickoff writes its own key, $size', (
      tester,
    ) async {
      final save = await _open(tester, size, conf: Confederation.northAmerica);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TournamentKickoffScreen.landscapeKey), findsOneWidget);
      Future<bool> watched(String kind) async {
        late bool v;
        await tester.runAsync(() async {
          v = await save.container
              .read(competitionRepositoryProvider)
              .hasWatchedDraw(save.careerId, save.career.cyclePointer, kind);
        });
        return v;
      }

      expect(await watched(continentalKickoffKind), isFalse);
      await tester.tap(
        find.widgetWithText(PrimaryButton, enL.tourSharedLetFinalsBegin),
      );
      await settle(tester);
      expect(await watched(continentalKickoffKind), isTrue);
      expect(await watched(worldCupKickoffKind), isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
