import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/federation/national_stadiums_screen.dart';
import 'package:fnm/features/federation/stadium_map/stadium_map.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(
                File('assets/data/country_cities.json').readAsStringSync(),
              )
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

/// [nationId]'s real national set, untouched, in an open window with money
/// for any work.
NationalStadiumsView _view(int nationId, {bool window = true}) {
  final all = NationalStadiums.forNation(
    nationId: nationId,
    seed: seedStadiums(nationId, _cities),
    works: const [],
  );
  return NationalStadiumsView(
    careerId: 1,
    nationId: nationId,
    cycle: 1,
    stadiums: NationalStadiums.nationalSet(all),
    cities: _cities[nationId]!,
    window: window,
    freeFunds: 90000000,
    income: 1200000,
    reputation: 0,
    resizedThisCycle: const {},
    building: false,
  );
}

const Size _phone = Size(360, 740);
const Size _tablet = Size(1194, 834);

Future<void> _pump(
  WidgetTester tester,
  int nationId, {
  Size size = _phone,
  Locale locale = const Locale('en'),
  bool window = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.4;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final v = _view(nationId, window: window);
  await tester.pumpApp(
    const NationalStadiumsScreen(careerId: 1),
    locale: locale,
    overrides: [nationalStadiumsViewProvider(1).overrideWith((ref) async => v)],
  );
  await tester.pumpAndSettle();
}

/// Every marker target that is on screen.
Iterable<int> _visiblePins(WidgetTester tester, int count) sync* {
  for (var i = 0; i < count; i++) {
    if (find.byKey(StadiumMap.pinKey(i)).evaluate().isNotEmpty) yield i;
  }
}

void main() {
  const nations = {
    58: 'Brazil',
    45: 'San Marino',
    2: 'Andorra',
    203: 'Fiji',
    14: 'England',
    41: 'Portugal (Madeira inset)',
    99: 'United States',
    212: 'Greenland',
  };
  for (final MapEntry(key: id, value: name) in nations.entries) {
    for (final (label, size) in [('phone', _phone), ('tablet', _tablet)]) {
      testWidgets('the map opens on $name ($label), every ground pinned', (
        tester,
      ) async {
        await _pump(tester, id, size: size);
        expect(tester.takeException(), isNull);
        expect(find.byType(StadiumMap), findsOneWidget);
        final count = _view(id).stadiums.length;
        final shown = _visiblePins(tester, count).toList();
        expect(shown, hasLength(count), reason: 'every ground has a marker');
        final map = tester.getRect(find.byKey(StadiumMap.canvasKey));
        for (final i in shown) {
          final c = tester.getCenter(find.byKey(StadiumMap.pinKey(i)));
          // On the map, or in its inset (also inside the map's frame).
          expect(map.inflate(1).contains(c), isTrue, reason: 'pin $i at $c');
        }
      });
    }
  }

  for (final code in ['de', 'fi', 'hu', 'el', 'pt', 'cs', 'fil']) {
    testWidgets('the map fits a 360 phone at text 1.4 ($code)', (
      tester,
    ) async {
      await _pump(tester, 20, locale: Locale(code));
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(NationalStadiumsScreen.mapBuildKey));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('tapping a marker opens its card, with the same works', (
    tester,
  ) async {
    await _pump(tester, 58);
    await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    await tester.pumpAndSettle();
    expect(find.byKey(NationalStadiumsScreen.sheetKey), findsOneWidget);
    final s = _view(58).stadiums.first;
    expect(find.text(s.name), findsOneWidget);
    expect(find.text(s.city), findsWidgets);
    expect(find.textContaining('Earns '), findsOneWidget);
    // Brazil's biggest is level 5: no upgrade, but a downsize.
    expect(find.byKey(NationalStadiumsScreen.upgradeKey(0)), findsNothing);
    final down = find.byKey(NationalStadiumsScreen.downsizeKey(0));
    expect(down, findsOneWidget);
    await tester.tap(down);
    await tester.pumpAndSettle();
    // The sheet gives way to the same confirmation the list asks.
    expect(find.byKey(NationalStadiumsScreen.sheetKey), findsNothing);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Nothing is refunded'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });

  testWidgets('a small ground offers its upgrade from the sheet', (
    tester,
  ) async {
    await _pump(tester, 45);
    await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    await tester.pumpAndSettle();
    final up = find.byKey(NationalStadiumsScreen.upgradeKey(0));
    expect(up, findsOneWidget);
    expect(tester.widget<OutlinedButton>(up).onPressed, isNotNull);
    await tester.tap(up);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('to level 2'), findsOneWidget);
  });

  testWidgets('the toggle switches to the list and back', (tester) async {
    await _pump(tester, 14);
    expect(find.byType(StadiumMap), findsOneWidget);
    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();
    expect(find.byType(StadiumMap), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(NationalStadiumsScreen.downsizeKey(0)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(NationalStadiumsScreen.downsizeKey(0)), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(NationalStadiumsScreen.buildKey),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(NationalStadiumsScreen.buildKey), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Map'),
      -400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();
    expect(find.byType(StadiumMap), findsOneWidget);
  });

  testWidgets('building: free cities show as dots, a tap asks to build '
      'there', (tester) async {
    await _pump(tester, 14);
    // Not placing yet: no city dots.
    final free = _cities[14]!.firstWhere(
      (c) => !_view(14).stadiums.any((s) => s.city == c),
      orElse: () => '',
    );
    expect(find.byKey(StadiumMap.candidateKey('Nottingham')), findsNothing);
    await tester.tap(find.byKey(NationalStadiumsScreen.mapBuildKey));
    await tester.pumpAndSettle();
    expect(find.text('Tap a city to build a new stadium there.'), findsOne);
    if (free.isNotEmpty) {
      await tester.tap(find.byKey(StadiumMap.candidateKey(free)));
    } else {
      // Every seed city has a ground: its marker takes the tap.
      await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    }
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Build a new stadium in'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Cancel'),
      ),
    );
    await tester.pumpAndSettle();
    // Still placing; the way out ends it.
    await tester.tap(find.byKey(NationalStadiumsScreen.mapCancelKey));
    await tester.pumpAndSettle();
    expect(find.byKey(NationalStadiumsScreen.mapBuildKey), findsOneWidget);
  });

  testWidgets('a city with a ground can take a new one: its marker picks it', (
    tester,
  ) async {
    await _pump(tester, 58);
    await tester.tap(find.byKey(NationalStadiumsScreen.mapBuildKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    await tester.pumpAndSettle();
    expect(find.byKey(NationalStadiumsScreen.sheetKey), findsNothing);
    expect(
      find.textContaining(
        'Build a new stadium in ${_view(58).stadiums.first.city}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('outside the window the build button is off', (tester) async {
    await _pump(tester, 14, window: false);
    final build = find.byKey(NationalStadiumsScreen.mapBuildKey);
    expect(tester.widget<ButtonStyleButton>(build).onPressed, isNull);
    expect(
      find.text(
        'Works are ordered at the start of a cycle, before the budget is set.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Madeira sits in an inset, its ground tappable', (tester) async {
    await _pump(tester, 41);
    await tester.tap(find.byKey(NationalStadiumsScreen.mapBuildKey));
    await tester.pumpAndSettle();
    final funchal = find.byKey(StadiumMap.candidateKey('Funchal'));
    expect(funchal, findsOneWidget);
    await tester.tap(funchal);
    await tester.pumpAndSettle();
    expect(find.textContaining('Build a new stadium in Funchal'), findsOne);
  });

  testWidgets('pinch-zoomed in, the fit button brings the country back', (
    tester,
  ) async {
    await _pump(tester, 58);
    final canvas = find.byKey(StadiumMap.canvasKey);
    final centre = tester.getCenter(canvas);
    final a = await tester.startGesture(centre - const Offset(20, 0));
    final b = await tester.startGesture(centre + const Offset(20, 0));
    await a.moveBy(const Offset(-80, 0));
    await b.moveBy(const Offset(80, 0));
    await a.up();
    await b.up();
    await tester.pumpAndSettle();
    final zoomed = tester
        .widget<InteractiveViewer>(canvas)
        .transformationController!
        .value;
    expect(zoomed.getMaxScaleOnAxis(), greaterThan(1.5));
    await tester.tap(find.byKey(StadiumMap.fitKey));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<InteractiveViewer>(canvas)
          .transformationController!
          .value
          .isIdentity(),
      isTrue,
    );
  });

  for (final size in kTabletSizes) {
    testWidgets('in the tablet shell: the map beside its panel, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.stadiums}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationalStadiumsScreen.tabletLayoutKey), findsOne);
      expect(find.byType(TabletPage), findsOneWidget);
      expect(find.byType(StadiumMap), findsOneWidget);
      final map = tester.getRect(find.byType(StadiumMap));
      final toggle = tester.getRect(
        find.byKey(NationalStadiumsScreen.viewToggleKey),
      );
      if (size.width >= 1000) {
        expect(toggle.left, greaterThan(map.right));
      }
      expect(find.byKey(StadiumMap.pinKey(0)), findsOneWidget);
    });
  }
}
