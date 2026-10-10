import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.ranking}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<Nation>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets("a grid of nations, the manager's own beside it, $size", (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(WorldRankingScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBottomNav), findsNothing);
      expect(_grid, findsOneWidget);
      expect(
        tester.widget<NationView>(find.byType(NationView)).nationId,
        save.nationId,
      );
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.byType(NationView)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('picking a row puts that nation in the pane', (tester) async {
    final save = await _open(tester, kTabletSize);
    final other = tester
        .widget<DataGrid<Nation>>(_grid)
        .rows
        .firstWhere((n) => n.id != save.nationId);
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(other.name)),
    );
    await settle(tester);
    expect(
      tester.widget<NationView>(find.byType(NationView)).nationId,
      other.id,
    );
    expect(tester.widget<DataGrid<Nation>>(_grid).selected, other);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a region chip narrows the grid', (tester) async {
    await _open(tester, kTabletSize);
    // The chips come before the grid in the tree, and scroll sideways: Asia
    // sits past the edge of the 58% master column.
    final chip = find
        .text(confederationLabel(enL, Confederation.asia).toUpperCase())
        .first;
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await settle(tester);
    final rows = tester.widget<DataGrid<Nation>>(_grid).rows;
    expect(rows, isNotEmpty);
    expect(rows.every((n) => n.confederation == Confederation.asia), isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("a release that moves the manager's place re-centres on him", (
    tester,
  ) async {
    final lastPlace = StateProvider<bool>((ref) => false);
    // The manager sits first, then drops to last: only his place changes.
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        worldRankingProvider.overrideWith((ref, careerId) async {
          final career = await ref
              .watch(careerRepositoryProvider)
              .byId(careerId);
          final all = await ref.watch(nationRepositoryProvider).all();
          final me = all.firstWhere((n) => n.id == career!.nationId);
          final others = all.where((n) => n.id != me.id).toList();
          final nations = ref.watch(lastPlace)
              ? [...others, me]
              : [me, ...others];
          return RankingData(
            nations: nations,
            points: {
              for (var i = 0; i < nations.length; i++) nations[i].id: 2000 - i,
            },
            position: {
              for (var i = 0; i < nations.length; i++) nations[i].id: i + 1,
            },
            movement: const {},
            playerNationId: me.id,
            baseline: RankBaseline.values.first,
          );
        }),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.ranking}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    final me = tester
        .widget<DataGrid<Nation>>(_grid)
        .rows
        .firstWhere((n) => n.id == save.nationId);
    final row = find.descendant(of: _grid, matching: find.text(me.name));
    expect(row, findsOneWidget);
    save.container.read(lastPlace.notifier).state = true;
    await settle(tester);
    expect(row, findsOneWidget, reason: 'the table followed him down');
    final view = tester.getRect(
      find.descendant(of: _grid, matching: find.byType(ListView)),
    );
    expect(tester.getCenter(row).dy, inInclusiveRange(view.top, view.bottom));
    await tester.pumpWidget(const SizedBox());
  });

  for (final column in ['Nation', 'Region']) {
    testWidgets('centre on my nation finds the row after sorting by $column', (
      tester,
    ) async {
      final save = await _open(tester, kTabletSize);
      final me = tester
          .widget<DataGrid<Nation>>(_grid)
          .rows
          .firstWhere((n) => n.id == save.nationId);
      await tester.tap(
        find.descendant(
          of: find.byKey(DataGrid.headerKey),
          matching: find.textContaining(RegExp(column, caseSensitive: false)),
        ),
      );
      await settle(tester);
      final list = find.descendant(of: _grid, matching: find.byType(ListView));
      // Away from the manager's row, then back by the button.
      await tester.drag(list, const Offset(0, 6000));
      await settle(tester);
      await tester.drag(list, const Offset(0, -6000));
      await settle(tester);
      await tester.tap(find.byTooltip(enL.rankingCentreOnMe));
      await settle(tester);
      final row = find.descendant(of: _grid, matching: find.text(me.name));
      expect(row, findsOneWidget);
      final view = tester.getRect(list);
      expect(
        tester.getCenter(row).dy,
        inInclusiveRange(view.top, view.bottom),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
