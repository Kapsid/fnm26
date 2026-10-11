import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
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

  GroupStanding row(int id, {int w = 0, int d = 0, int gf = 0, int ga = 0}) =>
      GroupStanding(id)
        ..played = w + d
        ..won = w
        ..drawn = d
        ..goalsFor = gf
        ..goalsAgainst = ga;

  test('knockoutField ranks winners and runners-up across groups', () {
    final f = NationsCups.knockoutField([
      [row(1, w: 3, gf: 6), row(2, w: 2, gf: 4), row(3)],
      [row(4, w: 4, gf: 9), row(5, w: 2, d: 1, gf: 5), row(6)],
      [row(7, w: 3, gf: 5), row(8, w: 2, gf: 4), row(9)],
    ], (id) => id);
    expect([for (final s in f.winners) s.nationId], [4, 1, 7]);
    // 2 and 8 are level on everything: world ranking (lower id) decides.
    expect([for (final s in f.runnersUp) s.nationId], [5, 2, 8]);
  });

  test('roundOf16Pairs: bracket order, 1 and 2 only meet in the final', () {
    final seeded = List.generate(16, (i) => i + 1);
    final pairs = NationsCups.roundOf16Pairs(seeded, (id) => 'G$id');
    expect(pairs, [
      (1, 16),
      (8, 9),
      (4, 13),
      (5, 12),
      (2, 15),
      (7, 10),
      (3, 14),
      (6, 11),
    ]);
    expect(pairs.expand((p) => [p.$1, p.$2]).toSet(), seeded.toSet());
  });

  test('roundOf16Pairs keeps a runner-up off its own group winner', () {
    final seeded = List.generate(16, (i) => i + 1);
    // Runner-up 16 came second in seed 1's group.
    final group = {1: 'W1', 16: 'W1'};
    final pairs = NationsCups.roundOf16Pairs(seeded, (id) => group[id] ?? '$id');
    expect(pairs.first, (1, 15));
    expect(pairs[4], (2, 16));
  });
}
