import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/host_cities.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

final Map<String, Object?> _json =
    jsonDecode(File('assets/data/national_stadiums.json').readAsStringSync())
        as Map<String, Object?>;

final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

final List<({int id, String name, Confederation conf})> _nations = [
  for (final n
      in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List)
          .cast<Map<String, Object?>>())
    (
      id: n['id']! as int,
      name: n['name']! as String,
      conf: Confederation.values.byName(n['confederation']! as String),
    ),
  for (final d in DormantNations.all)
    (id: d.id, name: d.name, conf: d.confederation),
];

int _id(String name) => _nations.firstWhere((n) => n.name == name).id;

/// [id]'s national set as every career starts it.
List<int> _seats(int id) => [
  for (final s in NationalStadiums.nationalSet(
    NationalStadiums.forNation(
      nationId: id,
      seed: VenueGenerator.forHost(hostId: id, cities: _cities[id], count: 16),
      works: const [],
    ),
  ))
    s.capacity,
];

void main() {
  test('the generated Dart is exactly the curated JSON', () {
    expect(nationalStadiumData.keys.toSet(), {
      for (final k in _json.keys) int.parse(k),
    });
    for (final e in _json.entries) {
      final list = (e.value! as List).cast<Map<String, Object?>>();
      expect(
        nationalStadiumData[int.parse(e.key)],
        [for (final g in list) (g['city']! as String, g['seats']! as int)],
        reason: e.key,
      );
    }
  });

  test('every nation has its grounds: up to ten, biggest first, each in one '
      'of its venue cities', () {
    for (final n in _nations) {
      final list = nationalStadiumData[n.id];
      expect(list, isNotNull, reason: n.name);
      expect(list!.length, inInclusiveRange(1, 10), reason: n.name);
      final pool = {...?_cities[n.id], ...?extraHostCities[n.id]};
      for (var i = 0; i < list.length; i++) {
        expect(pool, contains(list[i].$1), reason: '${n.name} ${list[i].$1}');
        expect(list[i].$2, greaterThanOrEqualTo(500), reason: n.name);
        if (i > 0) {
          expect(list[i].$2, lessThanOrEqualTo(list[i - 1].$2), reason: n.name);
        }
      }
      // A city holds at most three of a nation's grounds (Pyongyang).
      final perCity = <String, int>{};
      for (final (city, _) in list) {
        perCity[city] = (perCity[city] ?? 0) + 1;
      }
      expect(perCity.values.every((c) => c <= 3), isTrue, reason: n.name);
    }
  });

  test('the estate and the venues read it: real cities and seats', () {
    final peru = VenueGenerator.forHost(
      hostId: _id('Peru'),
      cities: _cities[_id('Peru')],
      count: 12,
    );
    expect(peru.first.city, 'Lima');
    expect(peru.first.capacity, 80000);
    // Lima's two grounds have two names.
    final lima = peru.where((v) => v.city == 'Lima').toList();
    expect(lima, hasLength(2));
    expect(lima[0].stadium, isNot(lima[1].stadium));
    // A finals needing more grounds than the list adds smaller ones.
    expect(peru.length, 12);
    expect(peru.last.capacity, lessThan(peru[9].capacity));
  });

  test(
    'a city with two grounds: works on the second leave the first alone',
    () {
      final id = _id('Peru');
      final seed = VenueGenerator.forHost(
        hostId: id,
        cities: _cities[id],
        count: 16,
      );
      final all = NationalStadiums.forNation(
        nationId: id,
        seed: seed,
        works: const [
          StadiumWork.resize(
            nationId: 63,
            cycle: 0,
            stadium: (city: 'Lima#2', built: false),
            seats: 32000,
            enlarge: false,
          ),
        ],
      );
      final lima = all.where((s) => s.city == 'Lima').toList();
      expect(lima.map((s) => s.site), ['Lima', 'Lima#2']);
      expect(lima[0].capacity, 80000);
      expect(lima[1].capacity, 32000);
    },
  );

  bool wc(String name) => HostingRequirements.meets(
    _seats(_id(name)),
    HostingRequirements.worldChampionship,
  );
  bool cont(String name) {
    final n = _nations.firstWhere((x) => x.name == name);
    return HostingRequirements.meets(
      _seats(n.id),
      HostingRequirements.continental(n.conf),
    );
  }

  test('the real hosting nations can bid; the one-bowl nations cannot', () {
    for (final name in [
      'Colombia',
      'Peru',
      'Canada',
      'Mexico',
      'United States',
      'Japan',
      'South Korea',
      'Saudi Arabia',
      'Morocco',
      'Egypt',
      'South Africa',
      'England',
      'Germany',
      'Spain',
      'France',
      'Brazil',
      'Argentina',
    ]) {
      expect(wc(name), isTrue, reason: '$name: World Championship');
      expect(cont(name), isTrue, reason: '$name: continental');
    }
    // Three big grounds now reach the World Championship too.
    for (final name in ['Chile', 'Nigeria', 'Tanzania']) {
      expect(wc(name), isTrue, reason: name);
      expect(cont(name), isTrue, reason: name);
    }
    // One ground of 30,000+: its own championship, not the world's.
    expect(wc('Kuwait'), isFalse);
    expect(cont('Kuwait'), isTrue);
    for (final name in ['Cambodia', 'Kenya']) {
      expect(wc(name), isFalse, reason: name);
    }
    for (final name in ['Cambodia', 'Kenya', 'Andorra', 'Czechia']) {
      expect(cont(name), isFalse, reason: name);
    }
  });
}
