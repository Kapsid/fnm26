import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/repositories/player_repository.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

Map<String, Object?> _json(String f) =>
    jsonDecode(File('assets/data/$f').readAsStringSync())
        as Map<String, Object?>;

/// Vatican City's names: Italian and Latin names of the church, the Swiss
/// Guard's Swiss-German ones, a few Polish and Latin American ones, invented
/// pairings that are never a real person's. Mirrors texas_names_test.dart.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['217']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and mirror the names file', () {
    final file = _json('country_names.json')['217']! as Map;
    expect((file['first']! as List).cast<String>(), vaticanFirstNames);
    expect((file['sur']! as List).cast<String>(), vaticanSurnames);
    expect(vaticanFirstNames.length, greaterThanOrEqualTo(75));
    expect(vaticanSurnames.length, greaterThanOrEqualTo(75));
    expect(vaticanFirstNames.toSet(), hasLength(vaticanFirstNames.length));
    expect(vaticanSurnames.toSet(), hasLength(vaticanSurnames.length));
    // The extras add names, never repeat them, and make a hundred of each.
    expect(more('firstMore').where(vaticanFirstNames.contains), isEmpty);
    expect(more('surMore').where(vaticanSurnames.contains), isEmpty);
    expect(vaticanFirstNames.length + more('firstMore').length, 100);
    expect(vaticanSurnames.length + more('surMore').length, 100);
  });

  test('the names sound of the church: the pools hold its words', () {
    for (final first in ['Benedetto', 'Pio', 'Celestino', 'Urs', 'Jacek']) {
      expect(vaticanFirstNames, contains(first));
    }
    for (final sur in [
      'Santangelo',
      'Crocifisso',
      "Dell'Altare",
      'Pastore',
      'Zurbriggen',
      'Biskup',
      'Iglesias',
    ]) {
      expect(vaticanSurnames, contains(sur));
    }
  });

  test("no stored name is a real person's or a pope's, and none repeats", () {
    final names = [for (final p in vaticanPool()) p.name];
    expect(names.where(realVaticanNames.contains), isEmpty);
    expect(vaticanSquad.map((p) => p.name).toSet(), hasLength(23));
    // No pope's own surname is in the pools at all.
    final sur = {...vaticanSurnames, ...more('surMore')};
    for (final pope in [
      'Roncalli',
      'Montini',
      'Luciani',
      'Wojtyła',
      'Ratzinger',
      'Bergoglio',
      'Prevost',
      'Pacelli',
    ]) {
      expect(sur, isNot(contains(pope)));
    }
  });

  test('the guard is live', () {
    expect(guardedNamesByNation[217], same(realVaticanNames));
    final first = {...vaticanFirstNames, ...more('firstMore')};
    final sur = {...vaticanSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realVaticanNames)
        if (name.split(' ') case [
          final f,
          final s,
        ] when first.contains(f) && sur.contains(s))
          name,
    ];
    expect(reachable, isNotEmpty);
  });

  test('the namer never gives a player a guarded name (seeds 1 to 30, '
      'classic and every pool mark)', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    for (var seed = 1; seed <= 30; seed++) {
      final career = await careers.create(
        managerName: 'M',
        nationId: 1,
        rngSeed: seed,
        startDate: DateTime(2026, 9),
      );
      for (final rich in [false, true]) {
        if (rich) {
          for (final k in [namePoolsV2Kind, namePoolsV3Kind, namePoolsV4Kind]) {
            await comp.markDrawWatched(career.id, 0, k);
          }
        }
        // Twenty years on, so newgens past the stored rows are named too.
        final pool = await players.byNation(
          217,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 20,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        expect(
          names.where(realVaticanNames.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });
}
