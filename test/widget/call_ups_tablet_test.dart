import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart'
    show budgetSetupKind;
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/tactics_providers.dart' show kMaxSquadSize;
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  // Opened the way the hub opens it, as the timeline event: that always has a
  // draft key, so a part-named squad is stored as it is edited.
  String location(SeededSave save) =>
      '${Routes.callUps}?careerId=${save.careerId}'
      '&event=callup_test&cycle=${save.career.cyclePointer}';

  testWidgets('two columns: pool and squad, and a name opens his page', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(DataGrid<Player>), findsOneWidget);
    expect(find.byType(DetailPaneHost), findsNothing);
    expect(find.byType(PlayerView), findsNothing);
    expect(
      find.text(enL.tacticsSquadCount(0, kMaxSquadSize)),
      findsOneWidget,
    );

    // Ticking a box names him.
    final grid = find.byType(DataGrid<Player>);
    await tester.tap(
      find.descendant(of: grid, matching: find.byType(Checkbox)).first,
    );
    await settle(tester);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
    );

    // Tapping a name pushes that player's page.
    final names = find.descendant(
      of: grid,
      matching: find.byKey(const ValueKey('callUps.name')),
    );
    final third = tester.widget<Text>(
      find.descendant(of: names.at(2), matching: find.byType(Text)),
    );
    await tester.tap(names.at(2));
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.state.uri.path, Routes.player);
    expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(PlayerDetailScreen.profileKey),
        matching: find.text(third.data!),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a part-named squad survives opening a player and coming back', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    final grid = find.byType(DataGrid<Player>);
    final boxes = find.descendant(of: grid, matching: find.byType(Checkbox));
    for (final i in [0, 1, 2]) {
      await tester.tap(boxes.at(i));
      await settle(tester);
    }
    expect(
      find.text(enL.tacticsSquadCount(3, kMaxSquadSize)),
      findsOneWidget,
    );

    // Open one of them from the squad panel, not the pool.
    final squadTiles = find.byType(ListTile);
    expect(squadTiles, findsNWidgets(3));
    final named = tester
        .widget<Text>(
          find
              .descendant(of: squadTiles.first, matching: find.byType(Text))
              .at(
                0,
              ),
        )
        .data;
    await tester.tap(
      find.descendant(of: squadTiles.first, matching: find.text(named!)),
    );
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.state.uri.path, Routes.player);

    // The draft is stored while he is on show.
    final draft = await tester.runAsync(
      () => save.container
          .read(squadRepositoryProvider)
          .callUpDraft(save.careerId, 'callup_test'),
    );
    expect(draft, hasLength(3));

    // Back pops to the call-ups with the same three named.
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(router.state.uri.path, Routes.callUps);
    expect(router.state.uri.queryParameters['event'], 'callup_test');
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
    expect(
      find.text(enL.tacticsSquadCount(3, kMaxSquadSize)),
      findsOneWidget,
    );
    expect(find.byType(ListTile), findsNWidgets(3));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a squad named on the tablet layout survives the window '
      'shrinking to phone size', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    final grid = find.byType(DataGrid<Player>);
    await tester.tap(
      find.descendant(of: grid, matching: find.byType(Checkbox)).first,
    );
    await settle(tester);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
    );

    // iPad split view: the shell steps aside and the screen is rebuilt under
    // a new parent, with a new State (Review Focus 4).
    tester.view.physicalSize = kPhoneSize;
    await settle(tester);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsNothing);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
      reason: 'the draft carried the pick across the remount',
    );
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [const Size(1080, 810), kTabletSize]) {
    testWidgets('at $size the named squad reads whole', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(tester, save, location(save), size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(DataGrid<Player>), findsOneWidget);
      expect(find.byType(DetailPaneHost), findsNothing);
      expect(find.byKey(DataGrid.scrollKey), findsNothing);

      await tester.tap(find.text(enL.tacticsBestQuality));
      await settle(tester);
      expect(tester.takeException(), isNull);
      final tiles = find.byType(ListTile);
      expect(tiles, findsWidgets);
      for (final tile in tiles.evaluate()) {
        final title = (tile.widget as ListTile).title! as Text;
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.byWidget(tile.widget),
            matching: find.text(title.data!),
          ),
        );
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: '${title.data} cut in the squad panel',
        );
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a 700 x 810 window shows the phone call-ups, no overflow', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: const Size(700, 810));
    expect(tester.takeException(), isNull);
    expect(find.byType(TabletSidebar), findsNothing);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('confirming the call-up event moves the top bar on', (
    tester,
  ) async {
    // The shell's top bar keeps watching the next event while call-ups is
    // open, so nothing recomputed it: it stayed on the retired event and
    // tapping it came straight back here, forever.
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    final before = (await tester.runAsync(
      () => save.container.read(nextEventProvider(save.careerId).future),
    ))!;
    // Opened as the very event the bar shows, so confirming retires it the
    // way a real call-up event is retired.
    save.container
        .read(routerProvider)
        .go(
          '${Routes.callUps}?careerId=${save.careerId}'
          '&event=$budgetSetupKind&cycle=${save.career.cyclePointer}',
        );
    await settle(tester);
    await tester.tap(find.text(enL.tacticsBestQuality));
    await settle(tester);
    await tester.tap(find.text(enL.tacticsConfirmSquad));
    await settle(tester);

    expect(
      save.container.read(routerProvider).state.uri.path,
      Routes.hub,
    );
    expect(
      find.descendant(
        of: find.byType(TabletTopBar),
        matching: find.text(before.label),
      ),
      findsNothing,
    );
  });
}
