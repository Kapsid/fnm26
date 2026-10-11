import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/squad_tablet_layout.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tactics/tactics_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('pitch and bench left, tabs right', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late int bench;
    await tester.runAsync(() async {
      final data = (await save.container.read(
        tacticDataProvider(save.careerId).future,
      ))!;
      bench = data.pool.where((p) => !data.tactic.lineup.contains(p.id)).length;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(TacticsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(TacticsPitch), findsOneWidget);
    expect(find.byType(BenchChip), findsNWidgets(bench));
    expect(
      tester.widget(find.byKey(TourKeys.tacticsFormation)),
      isA<FormationField>(),
      reason: 'the tour still finds the shape control',
    );
    final pitch = tester.getCenter(find.byType(TacticsPitch));
    final tabs = tester.getCenter(find.text(enL.tacticsFormation).first);
    expect(pitch.dx, lessThan(tabs.dx));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the squad tab is the squad layout, not the tactics one', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(SquadTabletLayout.layoutKey), findsOneWidget);
    expect(find.byKey(TacticsScreen.tabletLayoutKey), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the Opposition tab keeps the opponent back until his draw is '
      'watched (Review Focus 1)', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late HubData hub;
    await tester.runAsync(() async {
      hub = (await save.container.read(
        hubDataProvider(save.careerId).future,
      ))!;
    });
    final next = hub.next!;
    expect(hub.nextDrawWatched, isFalse);
    final oppId = next.homeNationId == save.nationId
        ? next.awayNationId
        : next.homeNationId;
    final oppName = hub.nations[oppId]!.name;

    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    await tester.tap(find.text(enL.matchDossierTitle.toUpperCase()));
    await settle(tester);
    expect(find.byType(OpponentBriefing), findsNothing);
    expect(find.textContaining(oppName), findsNothing);
    expect(find.text(enL.topBarDrawPending), findsWidgets);

    await tester.runAsync(
      () => save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            save.careerId,
            save.career.cyclePointer,
            drawKindForFixture(next)!,
          ),
    );
    save.container.invalidate(hubDataProvider(save.careerId));
    await settle(tester);
    expect(find.byType(OpponentBriefing), findsOneWidget);
    // His name is on screen again (the top bar's next-match chip names him).
    expect(find.textContaining(oppName), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [kTabletSize, const Size(1080, 810)]) {
    testWidgets('no overflow, and the pickers pop their own sheet '
        '(${size.width.toInt()})', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(TacticsScreen.tabletLayoutKey), findsOneWidget);

      // The role picker: a sheet over the page, closed by its own context.
      await tester.tap(find.text(enL.tacticsTabRolesSetPieces).first);
      await settle(tester);
      await tester.tap(find.text(enL.tacticsTapToAssign).first);
      await settle(tester);
      expect(find.text(enL.tacticsTabRolesSetPieces), findsWidgets);
      final close = find.byIcon(Icons.close);
      expect(close, findsOneWidget, reason: 'the role sheet is open');
      await tester.tap(close);
      await settle(tester);
      expect(close, findsNothing);
      expect(
        find.byKey(TacticsScreen.tabletLayoutKey),
        findsOneWidget,
        reason: 'closing the sheet must not pop the Tactics page',
      );

      // The captain picker.
      await tester.tap(find.text(enL.captainNone));
      await settle(tester);
      expect(find.text(enL.squadCaptain.toUpperCase()), findsWidgets);
      await tester.tap(find.byType(ListTile).at(1));
      await settle(tester);
      expect(find.byKey(TacticsScreen.tabletLayoutKey), findsOneWidget);
      expect(
        find.text(enL.captainNone),
        findsNothing,
        reason: 'the pick landed: somebody wears the armband',
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('TourKeys.squadTab has one owner on a tablet: the sidebar', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.byKey(TourKeys.squadTab), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TabletSidebar),
        matching: find.byKey(TourKeys.squadTab),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  for (final tab in [1, 2]) {
    testWidgets('?tab=$tab on a tablet opens '
        '${tab == 2 ? 'Roles and set pieces' : 'the Formation tab'}', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}&tab=$tab',
        size: kTabletSize,
      );
      expect(
        find.text(enL.tacticsRolesSetPiecesBlurb),
        tab == 2 ? findsOneWidget : findsNothing,
      );
      expect(
        find.byKey(TourKeys.tacticsFormation),
        tab == 2 ? findsNothing : findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
