import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';

void main() {
  test('forConfederation maps each cup and nothing else', () {
    final eu = NationsCups.forConfederation(Confederation.europe)!;
    expect(eu.name, 'Nations Cup');
    expect(eu.format, NationsCupFormat.ladder);
    final na = NationsCups.forConfederation(Confederation.northAmerica)!;
    expect(na.name, 'North America Nations Cup');
    expect(na.format, NationsCupFormat.ladder);
    final af = NationsCups.forConfederation(Confederation.africa)!;
    expect(af.name, 'African Nations Cup');
    expect(af.format, NationsCupFormat.zones);
    for (final c in [
      Confederation.asia,
      Confederation.southAmerica,
      Confederation.oceania,
    ]) {
      expect(NationsCups.forConfederation(c), isNull);
    }
  });

  test('isNationsCup trims and matches the three names only', () {
    for (final n in NationsCups.allNames) {
      expect(NationsCups.isNationsCup(n), isTrue);
      expect(NationsCups.isNationsCup(' $n '), isTrue);
    }
    expect(NationsCups.isNationsCup('European Championship'), isFalse);
  });

  test('zone map covers exactly the 54 African nations, sized 6/16/16/16', () {
    final json =
        jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List;
    final african = {
      for (final n in json)
        if ((n as Map)['confederation'] == 'africa') n['code'] as String,
    };
    expect(african.length, 54);
    expect(NationsCups.africaZoneByCode.keys.toSet(), african);
    int size(AfricaZone z) =>
        NationsCups.africaZoneByCode.values.where((v) => v == z).length;
    expect(size(AfricaZone.north), 6);
    expect(size(AfricaZone.west), 16);
    expect(size(AfricaZone.east), 16);
    expect(size(AfricaZone.centralSouthern), 16);
  });

  test('zone prefixes round-trip through group names', () {
    expect(NationsCups.zoneOfGroupName('W3'), AfricaZone.west);
    expect(NationsCups.zoneOfGroupName('N1'), AfricaZone.north);
    expect(NationsCups.zoneOfGroupName('E4'), AfricaZone.east);
    expect(NationsCups.zoneOfGroupName('S2'), AfricaZone.centralSouthern);
    expect(NationsCups.zoneOfGroupName('A1'), isNull);
    expect(NationsCups.zoneOfGroupName(''), isNull);
    for (final z in AfricaZone.values) {
      expect(NationsCups.zoneOfGroupName('${NationsCups.zonePrefix(z)}1'), z);
    }
  });

  test('zoneGroups: 16 -> 4x4 with top four apart, 6 -> 2x3', () {
    final ids = List.generate(16, (i) => 100 + i); // ranked best-first
    final g = NationsCups.zoneGroups(ids, 7);
    expect(g.length, 4);
    expect(g.every((x) => x.length == 4), isTrue);
    expect(g.expand((x) => x).toList()..sort(), ids);
    final top = ids.take(4).toSet();
    for (final group in g) {
      expect(group.where(top.contains).length, 1);
    }
    expect(NationsCups.zoneGroups(ids, 7), g);

    final six = List.generate(6, (i) => i + 1);
    final s = NationsCups.zoneGroups(six, 3);
    expect(s.length, 2);
    expect(s.every((x) => x.length == 3), isTrue);
    expect(s.expand((x) => x).toList()..sort(), six);
    expect(s[0].where({1, 2}.contains).length, 1);
  });

  test('finalsEightPairs keeps zones apart', () {
    final pairs = NationsCups.finalsEightPairs({
      AfricaZone.west: [1, 2],
      AfricaZone.east: [3, 4],
      AfricaZone.centralSouthern: [5, 6],
      AfricaZone.north: [7, 8],
    });
    expect(pairs, [(1, 4), (3, 6), (5, 8), (7, 2)]);
    final zoneOf = {
      1: 'W',
      2: 'W',
      3: 'E',
      4: 'E',
      5: 'S',
      6: 'S',
      7: 'N',
      8: 'N',
    };
    for (final p in pairs) {
      expect(zoneOf[p.$1], isNot(zoneOf[p.$2]));
    }
  });
}
