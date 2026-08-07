import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Validates the generated seed assets (`assets/data/*.json`). Reads the files
/// from disk so the committed data — not a fixture — is what gets checked.
void main() {
  late List<Nation> nations;
  late List<Player> players;

  setUpAll(() {
    nations = (jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();
    players = (jsonDecode(File('assets/data/players.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();
  });

  test('covers (nearly) all FIFA nations across every confederation', () {
    expect(nations.length, greaterThanOrEqualTo(200));
    final confs = nations.map((n) => n.confederation).toSet();
    expect(confs, Confederation.values.toSet());
  });

  test('exactly the four expected nations are free-demo', () {
    final free = nations.where((n) => n.isFreeDemo).map((n) => n.name).toSet();
    expect(free, {'England', 'France', 'Spain', 'Brazil'});
  });

  test('nation ids and codes are unique', () {
    expect(nations.map((n) => n.id).toSet(), hasLength(nations.length));
    expect(nations.map((n) => n.code).toSet(), hasLength(nations.length));
  });

  test('every nation has a full 23-player squad', () {
    final byNation = <int, int>{};
    for (final p in players) {
      byNation[p.nationId] = (byNation[p.nationId] ?? 0) + 1;
    }
    expect(byNation.length, nations.length);
    expect(byNation.values.toSet(), {23});
  });

  test('every player references a real nation and has valid attributes', () {
    final nationIds = nations.map((n) => n.id).toSet();
    for (final p in players) {
      expect(nationIds.contains(p.nationId), isTrue, reason: p.name);
      expect(p.overall, inInclusiveRange(1, 99));
      for (final v in [
        p.attributes.physical,
        p.attributes.technical,
        p.attributes.stamina,
      ]) {
        expect(v, inInclusiveRange(1, 99));
      }
      expect(p.age, inInclusiveRange(16, 40));
    }
  });

  test('player ids are globally unique', () {
    expect(players.map((p) => p.id).toSet(), hasLength(players.length));
  });

  test('stronger nations field stronger squads (Argentina > San Marino)', () {
    int squadAvg(String nation) {
      final id = nations.firstWhere((n) => n.name == nation).id;
      final squad = players.where((p) => p.nationId == id).toList();
      final total = squad.fold<int>(0, (sum, p) => sum + p.overall);
      return total ~/ squad.length;
    }

    expect(squadAvg('Argentina'), greaterThan(squadAvg('San Marino')));
  });
}
