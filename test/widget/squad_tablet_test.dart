import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/squad_tablet_layout.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the pool as a table, the picked player beside it', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late NationSquadData data;
    await tester.runAsync(() async {
      data = (await save.container.read(
        nationSquadProvider(save.careerId).future,
      ))!;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(SquadTabletLayout.layoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(DataGrid<NationSquadRow>), findsOneWidget);
    expect(find.byType(MasterDetail), findsOneWidget);

    // Nothing picked yet: the best-rated player fills the pane.
    final pane = find.byType(DetailPaneHost);
    expect(
      find.descendant(
        of: pane,
        matching: find.text(data.rows.first.player.name),
      ),
      findsOneWidget,
    );

    // Picking the third fills it with him.
    final third = data.rows[2].player.name;
    await tester.tap(
      find
          .descendant(
            of: find.byType(DataGrid<NationSquadRow>),
            matching: find.text(third),
          )
          .first,
    );
    await settle(tester);
    expect(
      find.descendant(of: find.byType(PlayerView), matching: find.text(third)),
      findsOneWidget,
    );

    // The Attributes view swaps the columns.
    final grid = find.byType(DataGrid<NationSquadRow>);
    await tester.tap(
      find.descendant(of: grid, matching: find.text(enL.playerAttributes)),
    );
    await tester.pump();
    expect(
      find.descendant(of: grid, matching: find.text(enL.playerAttrPhysical)),
      findsOneWidget,
    );

    // The tour's Squad step has something to light.
    expect(
      find.descendant(
        of: find.byType(TabletSidebar),
        matching: find.byKey(TourKeys.squadTab),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the line filter narrows the table at 1080x810', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: const Size(1080, 810),
    );
    expect(tester.takeException(), isNull);
    final data = save.container.read(nationSquadProvider(save.careerId)).value!;
    final total = data.rows.length;
    final keepers = data.rows
        .where((r) => r.player.category == PositionCategory.goalkeeper)
        .length;
    expect(keepers, lessThan(total));
    expect(find.text(enL.squadShowingOf(total, total)), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, enL.squadLineKeepers));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text(enL.squadShowingOf(keepers, total)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [const Size(1080, 810), kTabletSize]) {
    testWidgets('every view fits with the divider dragged to its minimum at '
        '$size', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}&tab=3',
        size: size,
      );
      await tester.drag(
        find.byKey(MasterDetail.dividerKey),
        const Offset(-900, 0),
      );
      await tester.pump();
      final grid = find.byType(DataGrid<NationSquadRow>);
      for (final v in [
        enL.gridViewOverview,
        enL.playerAttributes,
        enL.playerStatForm,
        enL.sideCareer,
      ]) {
        await tester.tap(
          find.descendant(of: grid, matching: find.text(v)).first,
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: v);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  // Real 9.7 inch iPads and the divider pushed to its limit: the player pane
  // keeps room for its own header whatever the split.
  for (final (size, drag) in <(Size, double)>[
    (const Size(1000, 750), 0),
    (const Size(1024, 768), 0),
    (const Size(1080, 810), 900),
    (const Size(1194, 834), 900),
  ]) {
    testWidgets('the player pane does not overflow at $size, drag $drag', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}&tab=3',
        size: size,
      );
      if (drag != 0) {
        await tester.drag(
          find.byKey(MasterDetail.dividerKey),
          Offset(drag, 0),
        );
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
