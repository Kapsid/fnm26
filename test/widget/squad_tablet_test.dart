import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  testWidgets('the squad as a full-width table; a row opens his page and '
      'back returns to the table', (tester) async {
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
    // No pane beside it: the table has the whole content area.
    expect(find.byType(MasterDetail), findsNothing);
    expect(find.byType(DetailPaneHost), findsNothing);
    expect(find.byType(PlayerView), findsNothing);

    // The Attributes view swaps the columns (headers in capitals).
    final grid = find.byType(DataGrid<NationSquadRow>);
    await tester.tap(
      find.descendant(
        of: grid,
        matching: find.text(enL.playerAttributes.toUpperCase()),
      ),
    );
    await tester.pump();
    expect(
      find.descendant(
        of: grid,
        matching: find.text(enL.playerAttrPhysical.toUpperCase()),
      ),
      findsOneWidget,
    );

    // Tapping the third pushes his own page over the squad.
    final third = data.rows[2].player;
    await tester.tap(
      find.descendant(of: grid, matching: find.text(third.name)).first,
    );
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.state.uri.path, Routes.player);
    expect(router.state.uri.queryParameters['playerId'], '${third.id}');
    expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsOneWidget);

    // Back pops to the squad, still on the Attributes view.
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(router.state.uri.path, Routes.tactics);
    expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsNothing);
    expect(find.byKey(SquadTabletLayout.layoutKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(DataGrid<NationSquadRow>),
        matching: find.text(enL.playerAttrPhysical.toUpperCase()),
      ),
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

  testWidgets('every header is in the same case', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: const Size(1080, 810),
    );
    final header = find.byKey(DataGrid.headerKey);
    for (final label in [
      enL.squadDevPosition,
      enL.squadSortName,
      enL.playerAge,
      enL.playerClub,
      enL.teamOverall,
      enL.squadSortCaps,
    ]) {
      expect(
        find.descendant(of: header, matching: find.text(label.toUpperCase())),
        findsOneWidget,
        reason: label,
      );
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the headers sort: OVERALL starts high to low and reverses, '
      'POS runs in pitch order, every column answers a tap', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: const Size(1080, 810),
    );
    final data = save.container.read(nationSquadProvider(save.careerId)).value!;
    final grid = find.byType(DataGrid<NationSquadRow>);
    final header = find.byKey(DataGrid.headerKey);
    Finder title(String label) =>
        find.descendant(of: header, matching: find.text(label.toUpperCase()));
    Finder arrow(IconData icon) =>
        find.descendant(of: header, matching: find.byIcon(icon));
    // The names on screen, top to bottom.
    List<String> names() {
      final all = {for (final r in data.rows) r.player.name};
      final shown =
          [
            for (final e
                in find
                    .descendant(of: grid, matching: find.byType(Text))
                    .evaluate())
              if (all.contains((e.widget as Text).data)) e,
          ]..sort(
            (a, b) => tester
                .getTopLeft(find.byWidget(a.widget))
                .dy
                .compareTo(tester.getTopLeft(find.byWidget(b.widget)).dy),
          );
      return [for (final e in shown) (e.widget as Text).data!];
    }

    String nameOf(NationSquadRow r) => r.player.name;
    final best = [...data.rows]
      ..sort((a, b) => b.player.overall.compareTo(a.player.overall));
    // As it arrives: best first, and the header says so.
    expect(names().first, nameOf(best.first));
    Finder arrowOn(String label) => find.descendant(
      of: find.ancestor(of: title(label), matching: find.byType(InkWell)),
      matching: find.byType(Icon),
    );
    expect(arrowOn(enL.teamOverall), findsOneWidget);
    expect(arrow(Icons.arrow_drop_down), findsOneWidget);

    // One tap on OVERALL turns it round.
    await tester.tap(title(enL.teamOverall));
    await tester.pump();
    expect(arrow(Icons.arrow_drop_up), findsOneWidget);
    final worst = best.last.player.overall;
    expect(
      data.rows
          .firstWhere((r) => r.player.name == names().first)
          .player
          .overall,
      worst,
    );

    // POS: keepers first, forwards last.
    await tester.tap(title(enL.squadDevPosition));
    await tester.pump();
    final first = data.rows.firstWhere((r) => r.player.name == names().first);
    expect(first.player.category, PositionCategory.goalkeeper);

    // Every other header of the overview answers too.
    for (final label in [
      enL.squadSortName,
      enL.playerAge,
      enL.playerClub,
      enL.squadSortCaps,
      enL.squadSortGoals,
      enL.gridColStatus,
    ]) {
      await tester.tap(title(label));
      await tester.pump();
      expect(arrowOn(label), findsOneWidget, reason: label);
      expect(tester.takeException(), isNull, reason: label);
    }
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
    testWidgets('every view fits and no name is cut at $size', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}&tab=3',
        size: size,
      );
      final data = save.container
          .read(nationSquadProvider(save.careerId))
          .value!;
      final grid = find.byType(DataGrid<NationSquadRow>);
      for (final v in [
        enL.gridViewOverview,
        enL.playerAttributes,
        enL.playerStatForm,
        enL.sideCareer,
      ]) {
        // The view chips, not a column header of the same name ("FORM").
        await tester.tap(
          find.descendant(
            of: find.byType(ChoiceChip),
            matching: find.text(v.toUpperCase()),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: v);
        expect(find.byKey(DataGrid.scrollKey), findsNothing, reason: v);
        // Every name on screen, the widest included, is drawn whole.
        var checked = 0;
        for (final r in data.rows) {
          final name = find.descendant(
            of: grid,
            matching: find.text(r.player.name),
          );
          if (name.evaluate().isEmpty) continue;
          final paragraph = tester.renderObject<RenderParagraph>(name.first);
          expect(
            paragraph.didExceedMaxLines,
            isFalse,
            reason: '${r.player.name} cut in $v',
          );
          checked++;
        }
        expect(checked, greaterThan(5), reason: v);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final size in const [Size(1000, 750), Size(1024, 768)]) {
    testWidgets('the table does not overflow at $size', (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.tactics}?careerId=${save.careerId}&tab=3',
        size: size,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
