import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
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
}
