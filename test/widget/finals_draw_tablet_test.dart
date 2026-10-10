import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The biggest finals draw: twelve groups of four, forty-eight teams.
FinalsDrawData _bigDraw(int playerNationId) {
  final groups = groupsOf(fieldOf(playerNationId, 48), groupCount: 12, size: 4);
  return FinalsDrawData(
    draw: finalsDrawOf(groups),
    nations: realNationsById,
    playerNationId: playerNationId,
    potByNation: {
      for (final g in groups)
        for (var p = 0; p < g.nationIds.length; p++) g.nationIds[p]: p + 1,
    },
    cycle: 0,
    alreadyWatched: false,
  );
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  FinalsDrawData Function(int)? draw,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      finalsDrawProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => (draw ?? fakeFinalsDraw)(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.finalsDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<void> _skip(WidgetTester tester) async {
  await tester.tap(find.text(enL.tourSharedSkip));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final size in kTabletSizes) {
    for (final big in [false, true]) {
      testWidgets('four pots side by side, then the landscape stage, '
          '${big ? 'big draw, ' : ''}$size', (tester) async {
        await _open(tester, size, draw: big ? _bigDraw : null);
        expect(tester.takeException(), isNull);
        expect(find.byKey(FinalsDrawScreen.potsLandscapeKey), findsOneWidget);
        expect(find.byType(FullScreenPhoneFrame), findsNothing);
        final pot1 = tester.getCenter(find.text(enL.tourPot(1)));
        final pot4 = tester.getCenter(find.text(enL.tourPot(4)));
        expect(pot1.dy, pot4.dy, reason: 'the pots share a row');
        expect(pot4.dx, greaterThan(pot1.dx));

        await tester.tap(find.text(enL.tourDrawStart));
        await tester.pump();
        expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
        expect(find.byType(FullScreenPhoneFrame), findsNothing);
        expect(tester.takeException(), isNull);
        await _skip(tester);
        expect(tester.takeException(), isNull);
        expect(find.text(enL.tourSharedDrawComplete), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  testWidgets('the stage is fed exactly the stored groups', (tester) async {
    await _open(tester, kTabletSize);
    final stored = fakeFinalsDraw(seededNationId).draw.groups;
    await tester.tap(find.text(enL.tourDrawStart));
    await tester.pump();
    final ceremony = tester.widget<DrawCeremony>(find.byType(DrawCeremony));
    expect(ceremony.landscape, isTrue);
    expect(
      [for (final g in ceremony.groups) '${g.name}:${g.nationIds}'],
      [for (final g in stored) '${g.name}:${g.nationIds}'],
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a window crossing 1000 mid-draw keeps the draw where it was', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.tourDrawStart));
    await tester.pump();
    final before = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    expect(before.revealed, 2);

    tester.view.physicalSize = const Size(700, 810);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byKey(DrawCeremony.landscapeKey), findsNothing);
    final narrow = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    expect(identical(narrow, before), isTrue, reason: 'the draw restarted');
    expect(narrow.revealed, 2);

    tester.view.physicalSize = kTabletSize;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
    expect(
      identical(
        tester.state<DrawCeremonyState>(find.byType(DrawCeremony)),
        before,
      ),
      isTrue,
    );
    expect(before.revealed, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('finishing the draw marks it watched and opens the cup', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.tourDrawStart));
    await tester.pump();
    await _skip(tester);
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
      Routes.cup,
    );
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(save.careerId, 0, worldCupDrawKind);
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
