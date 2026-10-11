import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// Europe's cup, fingerprinted from the code as it stood BEFORE CONCACAF and
/// Africa were added. A European save must draw the same cup for the same
/// rngSeed, so these values must never change.
const Map<int, int> _europeSnapshot = {12345: 3983113530, 7: 668076058};

int _fnv(String s) {
  var h = 0x811C9DC5;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

List<Nation> _nations() =>
    (jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

class _World {
  _World(this.container, this.careerId, this.nations);
  final ProviderContainer container;
  final int careerId;
  final List<Nation> nations;
}

Future<_World> _create(Confederation conf, int seed) async {
  final db = createTestDatabase();
  final nations = _nations();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(db.close);
  await container.read(seedLoaderProvider).ensureSeeded();
  final player = nations
      .where((n) => n.confederation == conf)
      .reduce((a, b) => a.ranking >= b.ranking ? a : b);
  final career =
      (await container
              .read(careerServiceProvider)
              .create(nationId: player.id, managerName: 'M', rngSeed: seed))
          .valueOrNull!;
  return _World(container, career.id, nations);
}

/// Per competition name: group name to fixtures.
Future<Map<String, Map<String, List<Fixture>>>> _cups(_World w) async {
  final comp = w.container.read(competitionRepositoryProvider);
  final names = await comp.competitionNames(w.careerId);
  final groups = await comp.groupNames(w.careerId);
  final out = <String, Map<String, List<Fixture>>>{};
  for (final f in await comp.allFixtures(w.careerId)) {
    final name = names[f.competitionId];
    if (name == null || !NationsCups.isNationsCup(name)) continue;
    final g = groups[f.groupId] ?? '?';
    ((out[name] ??= {})[g] ??= []).add(f);
  }
  return out;
}

String _fingerprint(Map<String, List<Fixture>> groups) {
  final b = StringBuffer();
  for (final g in groups.keys.toList()..sort()) {
    final fs = groups[g]!.toList()..sort((a, c) => a.id.compareTo(c.id));
    for (final f in fs) {
      b.write(
        '$g|${f.matchday}|${f.date.toIso8601String()}|'
        '${f.homeNationId}|${f.awayNationId};',
      );
    }
  }
  return b.toString();
}

Set<int> _ids(Map<String, List<Fixture>> groups, [bool Function(String)? g]) =>
    {
      for (final e in groups.entries)
        if (g == null || g(e.key))
          for (final f in e.value) ...[f.homeNationId, f.awayNationId],
    };

void main() {
  test('Europe draws the same cup as before for a fixed seed', () async {
    for (final e in _europeSnapshot.entries) {
      final w = await _create(Confederation.europe, e.key);
      final cups = await _cups(w);
      expect(_fnv(_fingerprint(cups[NationsCups.europe]!)), e.value);
    }
  });

  for (final conf in [
    Confederation.europe,
    Confederation.northAmerica,
    Confederation.africa,
    Confederation.asia,
  ]) {
    test('a ${conf.name} save schedules all three cups', () async {
      final w = await _create(conf, 12345);
      final cups = await _cups(w);
      expect(cups.keys.toSet(), NationsCups.allNames.toSet());

      final year = CareerService.worldCupYear(0) - 2;
      for (final cup in cups.values) {
        for (final fs in cup.values) {
          for (final f in fs) {
            expect(f.date.year, year);
            expect([9, 10], contains(f.date.month));
          }
        }
      }

      for (final c in NationsCups.confederations) {
        final name = NationsCups.forConfederation(c)!.name;
        final members = {
          for (final n in w.nations)
            if (n.confederation == c) n.id,
        };
        final groups = cups[name]!;
        final seen = <int>[];
        for (final fs in groups.values) {
          seen.addAll({
            for (final f in fs) ...[f.homeNationId, f.awayNationId],
          });
        }
        expect(seen.length, members.length, reason: '$name: no one twice');
        expect(seen.toSet(), members, reason: '$name: no one dropped');
      }

      final na = cups[NationsCups.northAmerica]!;
      expect(_ids(na, (g) => g.startsWith('A')).length, 16);
      expect(_ids(na, (g) => g.startsWith('B')).length, 19);
      expect(na.keys.any((g) => g.startsWith('C')), isFalse);
      expect(
        [
          for (final g
              in na.keys.where((g) => g.startsWith('B')).toList()..sort())
            _ids({g: na[g]!}).length,
        ],
        [4, 4, 4, 4, 3],
      );
      // The stored ladder agrees with the calendar: CONCACAF's bottom league
      // is B, so B has no relegation zone and there is no empty League C.
      final stored = await w.container
          .read(careerRepositoryProvider)
          .nationsCupTiers(w.careerId);
      final confOf = {for (final n in w.nations) n.id: n.confederation};
      expect(
        NationsCup.lowestTier(
          tiers: stored,
          confederation: Confederation.northAmerica,
          confederationOf: (id) => confOf[id],
        ),
        1,
      );

      final af = cups[NationsCups.africa]!;
      expect(af.keys.toSet(), {
        'N1',
        'N2',
        'W1',
        'W2',
        'W3',
        'W4',
        'E1',
        'E2',
        'E3',
        'E4',
        'S1',
        'S2',
        'S3',
        'S4',
      });
      for (final e in af.entries) {
        expect(_ids({e.key: e.value}).length, e.key.startsWith('N') ? 3 : 4);
      }
      for (final e in af.entries) {
        final zone = NationsCups.zoneOfGroupName(e.key)!;
        for (final id in _ids({e.key: e.value})) {
          final code = w.nations.firstWhere((n) => n.id == id).code;
          expect(NationsCups.africaZoneByCode[code], zone);
        }
      }
    });
  }

  test('no nation plays two matches on one day in the cycle', () async {
    final w = await _create(Confederation.africa, 12345);
    final comp = w.container.read(competitionRepositoryProvider);
    final seen = <String>{};
    for (final f in await comp.allFixtures(w.careerId)) {
      final d = '${f.date.year}-${f.date.month}-${f.date.day}';
      for (final id in [f.homeNationId, f.awayNationId]) {
        expect(seen.add('$id@$d'), isTrue, reason: 'nation $id twice on $d');
      }
    }
  });
}
