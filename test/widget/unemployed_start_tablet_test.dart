import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size, {int? seed}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (seed != null) unemployedOfferSeedProvider.overrideWithValue(seed),
    ],
  );
  await pumpRoute(tester, save, Routes.startFromBottom, size: size);
  return save;
}

/// The router's own idea of where the manager is (`routeInformationProvider`
/// misses a `push`).
Uri _uri(SeededSave save) => save.container.read(routerProvider).state.uri;

/// The offers on show, left to right, as the database has them (a stored
/// name can differ from `save.nations`, which is the bundled JSON).
List<Nation> _shown(WidgetTester tester) => [
  for (final p in tester.widgetList<NationPreview>(find.byType(NationPreview)))
    p.nation,
];

List<int> _offers(WidgetTester tester) => [
  for (final n in _shown(tester)) n.id,
];

void main() {
  for (final size in kTabletSizes) {
    testWidgets('three offers side by side, $size', (tester) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(UnemployedStartScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final shown = _shown(tester);
      final ids = [for (final n in shown) n.id];
      expect(ids, hasLength(3));
      expect(ids.toSet(), hasLength(3));
      final rects = [
        for (final id in ids)
          tester.getRect(find.byKey(UnemployedStartScreen.takeKey(id))),
      ];
      expect(rects[1].left, greaterThan(rects[0].right));
      expect(rects[2].left, greaterThan(rects[1].right));
      // From the bottom half of the world, as on the phone.
      for (final n in shown) {
        expect(
          n.ranking,
          greaterThan(save.nations.length ~/ 2),
          reason: n.name,
        );
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("the same seed draws the phone guard golden's three", (
    tester,
  ) async {
    // test/golden/phone_guard_unemployed_test.dart pins seed 7 on the phone:
    // Saint Kitts and Nevis, St Vincent and the Grenadines, British Virgin
    // Islands, in that order (on the 2026 starting ranking).
    await _open(tester, kTabletSize, seed: 7);
    expect(
      [for (final n in _shown(tester)) n.name],
      [
        'Saint Kitts and Nevis',
        'St Vincent and the Grenadines',
        'British Virgin Islands',
      ],
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Take it goes on to naming the manager', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect(_uri(save).path, Routes.startFromBottom);
    final id = _offers(tester)[1];
    await tester.tap(find.byKey(UnemployedStartScreen.takeKey(id)));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    expect(_uri(save).queryParameters['nationId'], '$id');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize shows the same three offers (Review Focus 3)', (
    tester,
  ) async {
    // Unseeded on purpose: the clock draws a new three for a new State, so
    // only a State that survives the resize shows the same three again.
    await _open(tester, kTabletSize);
    final before = _offers(tester);
    final names = [for (final n in _shown(tester)) n.name];
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(UnemployedStartScreen.tabletLayoutKey), findsNothing);
    for (final name in names) {
      expect(find.text(name), findsOneWidget, reason: name);
    }
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(_offers(tester), before);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the back arrow returns to the nation pick', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect(_uri(save).path, Routes.startFromBottom);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.nations);
    await tester.pumpWidget(const SizedBox());
  });
}
