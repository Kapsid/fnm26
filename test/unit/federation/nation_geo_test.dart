import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/host_cities.dart';
import 'package:fnm/features/federation/stadium_map/nation_geo.dart';

Object? _json(String path) => jsonDecode(File(path).readAsStringSync());

/// The stadium map's geography (assets/geo, built by tool/geo/gen_geo.py):
/// every nation has an outline, and every city the map may pin (seed
/// cities, curated stadium cities, extra host cities) has a position on or
/// beside it.
void main() {
  final nations = [
    for (final n in _json('assets/data/nations.json')! as List)
      (n as Map<String, Object?>)['id']! as int,
    212, // Greenland, from the dormant pool.
  ];
  final seed = (_json('assets/data/country_cities.json')! as Map).map(
    (k, v) => MapEntry(int.parse(k as String), (v as List).cast<String>()),
  );
  final stadiums = (_json('assets/data/national_stadiums.json')! as Map).map(
    (k, v) => MapEntry(int.parse(k as String), [
      for (final e in v as List) (e as Map)['city']! as String,
    ]),
  );
  NationGeo geoOf(int id) => NationGeo.fromJson(
    _json(nationGeoAsset(id))! as Map<String, Object?>,
  );

  test('210 nations, one map each, and nothing else', () {
    expect(nations, hasLength(210));
    final files = Directory(
      'assets/geo',
    ).listSync().map((f) => f.uri.pathSegments.last).toSet();
    expect(files, {for (final id in nations) '$id.json'});
  });

  test('every nation has an outline inside its view', () {
    for (final id in nations) {
      final geo = geoOf(id);
      expect(geo.rings, isNotEmpty, reason: 'nation $id');
      expect(geo.path.getBounds().isEmpty, isFalse, reason: 'nation $id');
      expect(
        geo.view.overlaps(geo.path.getBounds()),
        isTrue,
        reason: 'nation $id: outline off its view',
      );
      for (final r in geo.rings) {
        expect(r.length, greaterThanOrEqualTo(4), reason: 'nation $id');
      }
    }
  });

  test('every city has a position, in the view or an inset', () {
    var count = 0;
    for (final id in nations) {
      final geo = geoOf(id);
      final all = {
        ...?seed[id],
        ...?stadiums[id],
        ...?extraHostCities[id],
      };
      for (final city in all) {
        expect(geo.cities, contains(city), reason: 'nation $id: $city');
        count++;
      }
      // The cities the screen pins (stadiums and build candidates) are
      // drawn: in the main view or one of its insets.
      for (final city in {...?seed[id], ...?stadiums[id]}) {
        final at = geo.cities[city]!;
        final drawn =
            geo.view.inflate(1e-6).contains(at) ||
            geo.insets.any((b) => b.inflate(1e-6).contains(at));
        expect(drawn, isTrue, reason: 'nation $id: $city at $at');
        expect(geo.boxOf(city), isNotNull);
      }
    }
    expect(count, greaterThan(1700));
  });

  test('the antimeridian: Fiji and the USA stay in one piece', () {
    for (final id in [203, 99, 205]) {
      final geo = geoOf(id);
      // A wrapped outline would span the whole globe.
      expect(
        geo.view.width,
        lessThan(120),
        reason: 'nation $id view ${geo.view}',
      );
    }
    final fiji = geoOf(203);
    expect(fiji.cities['Labasa'], isNotNull);
    expect(fiji.boxOf('Labasa'), -1);
  });

  test('Portugal keeps Funchal in an inset; Malaysia shows both coasts', () {
    final pt = geoOf(41);
    expect(pt.insets, hasLength(1));
    expect(pt.boxOf('Funchal'), 0);
    expect(pt.boxOf('Lisbon'), -1);
    final my = geoOf(177);
    expect(my.insets, isEmpty);
    expect(my.boxOf('Kuching'), -1);
    expect(my.boxOf('Kuala Lumpur'), -1);
  });

  test('the four home nations are their own shapes', () {
    for (final (id, city) in [
      (14, 'London'),
      (46, 'Glasgow'),
      (55, 'Cardiff'),
      (38, 'Belfast'),
    ]) {
      final geo = geoOf(id);
      expect(geo.rings, isNotEmpty);
      expect(geo.boxOf(city), -1, reason: '$city on its own map');
    }
  });

  test('the whole asset stays small', () {
    final bytes = Directory('assets/geo')
        .listSync()
        .whereType<File>()
        .fold<int>(0, (sum, f) => sum + f.lengthSync());
    expect(bytes, lessThan(2 * 1024 * 1024));
  });
}
