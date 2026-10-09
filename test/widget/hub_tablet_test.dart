import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the hub is a dashboard of panels on a tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    // No IntrinsicHeight assertion from any panel (Review Focus 3).
    expect(tester.takeException(), isNull);
    expect(find.byKey(HubScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(DashboardGrid), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    for (final title in [
      enL.hubNextMatch,
      enL.sideBoard,
      enL.playerStatForm,
      enL.sideInbox,
      enL.navY,
      enL.sideGroupFederation,
    ]) {
      // Scoped: the sidebar says "Y", "Inbox" and "FEDERATION" too.
      expect(
        find.descendant(
          of: find.byType(DashboardGrid),
          matching: find.text(title.toUpperCase()),
        ),
        findsOneWidget,
        reason: title,
      );
    }
    // The tour's first stop is the top bar's Continue now, and there is
    // exactly one of it.
    expect(find.byKey(TourKeys.hubAction), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TabletTopBar),
        matching: find.byKey(TourKeys.hubAction),
      ),
      findsOneWidget,
    );
    expect(find.byKey(TourKeys.hubBoard), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the next opponent stays hidden until the draw is watched', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late HubData hub;
    await tester.runAsync(() async {
      hub = (await save.container.read(
        hubDataProvider(save.careerId).future,
      ))!;
    });
    final next = hub.next!;
    expect(
      hub.nextDrawWatched,
      isFalse,
      reason: 'the seeded save opens before its first draw',
    );
    final oppId = next.homeNationId == save.nationId
        ? next.awayNationId
        : next.homeNationId;
    final oppName = hub.nations[oppId]!.name;

    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    final panel = find.byKey(HubScreen.nextMatchPanelKey);
    expect(
      find.descendant(of: panel, matching: find.text(oppName)),
      findsNothing,
    );
    expect(
      find.descendant(of: panel, matching: find.text(enL.topBarDrawPending)),
      findsOneWidget,
    );

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
    expect(
      find.descendant(of: panel, matching: find.text(oppName)),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
