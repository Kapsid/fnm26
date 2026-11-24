import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/federation/stadium_map/nation_geo.dart';
import 'package:fnm/features/federation/stadium_map/stadium_map.dart';
import 'package:fnm/features/tournaments/host_map_card.dart';

import '../helpers/pump_app.dart';

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(
                File('assets/data/country_cities.json').readAsStringSync(),
              )
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

NationGeo _geo(int id) => NationGeo.fromJson(
  jsonDecode(File(nationGeoAsset(id)).readAsStringSync())
      as Map<String, Object?>,
);

const _usa = 99;
const _mex = 88;
const _can = 74;
const _esp = 50;
const _por = 41;
const Map<int, String> _codes = {
  _usa: 'USA',
  _mex: 'MEX',
  _can: 'CAN',
  _esp: 'ESP',
  _por: 'POR',
};

/// The hosts as the summary tab hands them over: the same venue call.
List<HostMapNation> _hosts(List<int> ids, {int teams = 48}) {
  final byHost = VenueGenerator.forHosts(
    hostIds: ids,
    citiesByHost: _cities,
    count: VenueGenerator.countForField(teams),
    rules: VenueRules.scaled,
  );
  return [
    for (final id in ids)
      (
        id: id,
        code: _codes[id] ?? '??',
        name: _codes[id] ?? '??',
        venues: byHost[id] ?? const <Venue>[],
      ),
  ];
}

const Size _phone = Size(360, 740);
const Size _tablet = Size(1194, 834);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = _phone,
  Locale? locale,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
    locale: locale,
  );
  await tester.pumpAndSettle();
}

int _visiblePins(WidgetTester tester, int count) => [
  for (var i = 0; i < count; i++)
    if (find.byKey(StadiumMap.pinKey(i)).evaluate().isNotEmpty) i,
].length;

void main() {
  test('co-hosts merge into one plane that holds every city', () {
    final esp = _geo(_esp);
    final por = _geo(_por);
    final both = NationGeo.merge([esp, por]);
    expect(NationGeo.merge([esp]), same(esp));
    expect(both.cities.keys, containsAll(['Madrid', 'Lisbon', 'Porto']));
    // Lisbon lies west of Madrid, Porto north of Lisbon.
    expect(both.cities['Lisbon']!.dx, lessThan(both.cities['Madrid']!.dx));
    expect(both.cities['Porto']!.dy, lessThan(both.cities['Lisbon']!.dy));
    // Both main views fit the shared one.
    for (final c in ['Madrid', 'Barcelona', 'Lisbon', 'Porto']) {
      expect(both.view.inflate(1e-6).contains(both.cities[c]!), isTrue);
    }
    expect(both.rings.length, esp.rings.length + por.rings.length);
  });

  for (final (label, size) in [('phone', _phone), ('tablet', _tablet)]) {
    testWidgets('a three-way co-host pins every ground ($label)', (
      tester,
    ) async {
      final hosts = _hosts([_usa, _mex, _can]);
      final geo = NationGeo.merge([_geo(_usa), _geo(_mex), _geo(_can)]);
      final grounds = [
        for (final h in hosts)
          for (final v in h.venues)
            if (geo.cities.containsKey(v.city)) v,
      ];
      // The real host cities all have a place on the map.
      expect(grounds, hasLength(hosts.expand((h) => h.venues).length));
      await _pump(tester, HostMapCard(hosts: hosts), size: size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostMapCard.mapKey), findsOneWidget);
      expect(_visiblePins(tester, grounds.length), grounds.length);
      expect(find.text('HOST MAP'), findsOneWidget);
      expect(find.text('Venue of the final'), findsOneWidget);
    });
  }

  testWidgets('tapping a marker shows the stadium; the final is marked', (
    tester,
  ) async {
    final hosts = _hosts([_esp, _por], teams: 24);
    final finalGround = hosts.first.venues.first;
    await _pump(tester, HostMapCard(hosts: hosts));
    expect(find.byKey(HostMapCard.detailKey), findsNothing);

    await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    await tester.pumpAndSettle();
    final detail = find.byKey(HostMapCard.detailKey);
    expect(detail, findsOneWidget);
    expect(
      find.descendant(of: detail, matching: find.text(finalGround.stadium)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.text('Venue of the final')),
      findsOneWidget,
    );

    // Tapping it again closes it, back to the key.
    await tester.tap(find.byKey(StadiumMap.pinKey(0)));
    await tester.pumpAndSettle();
    expect(find.byKey(HostMapCard.detailKey), findsNothing);
  });

  testWidgets('a tablet sets the venues and the map side by side', (
    tester,
  ) async {
    const companion = SizedBox(
      key: Key('venues'),
      height: 200,
      child: Placeholder(),
    );
    await _pump(
      tester,
      HostMapCard(hosts: _hosts([_esp]), companion: companion),
      size: _tablet,
    );
    final venues = tester.getRect(find.byKey(const Key('venues')));
    final map = tester.getRect(find.byKey(HostMapCard.mapKey));
    expect(venues.right, lessThanOrEqualTo(map.left));

    await _pump(
      tester,
      HostMapCard(hosts: _hosts([_esp]), companion: companion),
    );
    final venuesPhone = tester.getRect(find.byKey(const Key('venues')));
    final mapPhone = tester.getRect(find.byKey(HostMapCard.mapKey));
    expect(venuesPhone.bottom, lessThanOrEqualTo(mapPhone.top));
  });

  testWidgets('without a map file only the venues list shows', (tester) async {
    const companion = SizedBox(key: Key('venues'), height: 100);
    await _pump(
      tester,
      const HostMapCard(
        hosts: [(id: 999999, code: 'XXX', name: 'Nowhere', venues: [])],
        companion: companion,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('venues')), findsOneWidget);
    expect(find.byKey(HostMapCard.mapKey), findsNothing);
  });

  for (final code in ['de', 'fi', 'el', 'fil', 'ja']) {
    testWidgets('the card fits a 360 phone ($code)', (tester) async {
      await _pump(
        tester,
        HostMapCard(hosts: _hosts([_usa, _mex, _can])),
        locale: Locale(code),
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(StadiumMap.pinKey(0)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostMapCard.detailKey), findsOneWidget);
    });
  }
}
