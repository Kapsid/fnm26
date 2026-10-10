import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.nations, size: size);
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

/// Europe's nations in the order the tiles show them (world rank).
List<Nation> _europe(SeededSave save) =>
    save.nations.where((n) => n.confederation == Confederation.europe).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));

/// The nation the preview pane is showing.
int _previewed(WidgetTester tester) => tester
    .widget<NationPreview>(
      find.descendant(
        of: find.byKey(NationSelectScreen.previewKey),
        matching: find.byType(NationPreview),
      ),
    )
    .nation
    .id;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('tiles left, the previewed nation right, $size', (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationSelectScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final grid = tester.getRect(find.byKey(NationSelectScreen.gridKey));
      final pane = tester.getRect(find.byKey(NationSelectScreen.previewKey));
      expect(pane.left, greaterThanOrEqualTo(grid.right));
      // Europe by default, as on the phone; its best-ranked side is open
      // first and is the first tile.
      final europe = _europe(save);
      expect(_previewed(tester), europe.first.id);
      expect(
        find.byKey(NationSelectScreen.tileKey(europe.first.id)),
        findsOneWidget,
      );
      expect(
        find.text(enL.nationsShownCount(europe.length).toUpperCase()),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a tile shows the rank, the strength and the best player', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final first = _europe(save).first;
    final s = save.container
        .read(nationStrengthsProvider)
        .requireValue[first.id]!;
    final tile = find.byKey(NationSelectScreen.tileKey(first.id));
    expect(
      find.descendant(of: tile, matching: find.text('#${first.ranking}')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<StrengthMeter>(
            find.descendant(of: tile, matching: find.byType(StrengthMeter)),
          )
          .tier,
      s.tier,
    );
    expect(
      find.descendant(
        of: tile,
        matching: find.text(
          enL.nationsStarTile(s.best.position.label, s.best.overall),
        ),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tap only previews; Manage takes the job (Review Focus 2)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final pick = _europe(save)[3];
    await tester.tap(find.byKey(NationSelectScreen.tileKey(pick.id)));
    await settle(tester);
    expect(_uri(save).path, Routes.nations);
    expect(_previewed(tester), pick.id);
    expect(find.text(enL.nationsManage(pick.name)), findsOneWidget);
    expect(find.text(enL.nationsManagerNext), findsOneWidget);
    await tester.tap(find.byKey(NationSelectScreen.manageKey));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    expect(_uri(save).queryParameters['nationId'], '${pick.id}');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the confederations and the search filter as on the phone', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final africa = save.nations
        .where((n) => n.confederation == Confederation.africa)
        .toList();
    await tester.tap(
      find.byKey(NationSelectScreen.chipKey(Confederation.africa)),
    );
    await settle(tester);
    expect(
      find.text(enL.nationsShownCount(africa.length).toUpperCase()),
      findsOneWidget,
    );
    // The pane follows the tiles: Africa's best-ranked side is open now.
    expect(africa.map((n) => n.id), contains(_previewed(tester)));
    // A search looks across every confederation, whatever chip is lit.
    await tester.enterText(
      find.descendant(
        of: find.byKey(NationSelectScreen.tabletLayoutKey),
        matching: find.byType(TextField),
      ),
      'ger',
    );
    await settle(tester);
    final matches = save.nations
        .where((n) => n.name.toLowerCase().contains('ger'))
        .toList();
    expect(
      matches.length,
      greaterThan(1),
      reason: 'the search spans continents',
    );
    for (final n in matches) {
      expect(
        find.byKey(NationSelectScreen.tileKey(n.id)),
        findsOneWidget,
        reason: n.name,
      );
    }
    expect(
      find.text(enL.nationsShownCount(matches.length).toUpperCase()),
      findsOneWidget,
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(NationSelectScreen.tabletLayoutKey),
        matching: find.byType(TextField),
      ),
      'zzzz',
    );
    await settle(tester);
    expect(find.text(enL.nationsNoMatch), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("Random team and From the bottom go where the phone's do", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    await tester.tap(find.text(enL.nationsRandomTeam));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    final id = int.parse(_uri(save).queryParameters['nationId']!);
    expect(save.nations.map((n) => n.id), contains(id));
    router.go(Routes.nations);
    await settle(tester);
    await tester.tap(find.text(enL.nationsFromTheBottom));
    await settle(tester);
    expect(_uri(save).path, Routes.startFromBottom);
    router.go(Routes.nations);
    await settle(tester);
    await tester.tap(find.byKey(NationSelectScreen.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.home);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the preview and the search (Review Focus 3)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final pick = _europe(save)[5];
    await tester.tap(find.byKey(NationSelectScreen.tileKey(pick.id)));
    await settle(tester);
    // Under 1000 wide: the phone list.
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(NationSelectScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.nationsSelect), findsWidgets);
    // Back over 1000: the same nation in the pane.
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(_previewed(tester), pick.id);
    // The search survives a crossing too: the tablet field is seeded from it.
    final field = find.descendant(
      of: find.byKey(NationSelectScreen.tabletLayoutKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'cze');
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(NationSelectScreen.tabletLayoutKey),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      'cze',
    );
    expect(save.container.read(nationSearchProvider), 'cze');
    await tester.pumpWidget(const SizedBox());
  });
}
