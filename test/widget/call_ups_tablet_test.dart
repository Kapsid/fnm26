import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
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

  testWidgets('three columns: pool, squad, player', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(DataGrid<Player>), findsOneWidget);
    expect(find.byType(DetailPaneHost), findsOneWidget);
    expect(
      find.text(enL.tacticsSquadCount(0, kMaxSquadSize)),
      findsOneWidget,
    );

    // Tapping a name puts that player in the right-hand pane.
    final grid = find.byType(DataGrid<Player>);
    final names = find.descendant(
      of: grid,
      matching: find.byKey(const ValueKey('callUps.name')),
    );
    final third = tester.widget<Text>(
      find.descendant(of: names.at(2), matching: find.byType(Text)),
    );
    await tester.tap(names.at(2));
    await settle(tester);
    expect(
      find.descendant(
        of: find.byType(PlayerView),
        matching: find.text(third.data!),
      ),
      findsOneWidget,
    );

    // Ticking a box names him.
    await tester.tap(
      find.descendant(of: grid, matching: find.byType(Checkbox)).first,
    );
    await settle(tester);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
    );
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

  testWidgets('a 10.2in iPad (1080 x 810) fits all three columns', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      location(save),
      size: const Size(1080, 810),
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(DataGrid<Player>), findsOneWidget);
    expect(find.byType(DetailPaneHost), findsOneWidget);

    // Opening a player must land in the pane, never silently do nothing.
    final names = find.descendant(
      of: find.byType(DataGrid<Player>),
      matching: find.byKey(const ValueKey('callUps.name')),
    );
    await tester.tap(names.at(1));
    await settle(tester);
    expect(find.byType(PlayerView), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

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
