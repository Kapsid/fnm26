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

/// Every seeded Czech and Slovak player's name, read from the seed file.
final Set<String> _realCzechsAndSlovaks = {
  for (final p
      in jsonDecode(File('assets/data/players.json').readAsStringSync())
          as List)
    if ((p as Map)['nationId'] == 12 || p['nationId'] == 48)
      p['name'] as String,
};

/// Czechoslovakia's names: Czech and Slovak pools, never a real person's
/// name: not a guarded international's, and not one of the real Czech and
/// Slovak players it plays beside. Mirrors zanzibar_names_test.dart.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['215']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and mirror the names file', () {
    final file = _json('country_names.json')['215']! as Map;
    expect((file['first']! as List).cast<String>(), czechoslovakiaFirstNames);
    expect((file['sur']! as List).cast<String>(), czechoslovakiaSurnames);
    expect(czechoslovakiaFirstNames.length, greaterThanOrEqualTo(75));
    expect(czechoslovakiaSurnames.length, greaterThanOrEqualTo(75));
    expect(
      czechoslovakiaFirstNames.toSet(),
      hasLength(czechoslovakiaFirstNames.length),
    );
    expect(
      czechoslovakiaSurnames.toSet(),
      hasLength(czechoslovakiaSurnames.length),
    );
    // The extras add names, never repeat them.
    expect(more('firstMore').where(czechoslovakiaFirstNames.contains), isEmpty);
    expect(more('surMore').where(czechoslovakiaSurnames.contains), isEmpty);
  });

  test("no stored name is a real person's, and none repeats", () {
    final names = [for (final p in czechoslovakiaPool()) p.name];
    expect(names.where(realCzechoslovakiaNames.contains), isEmpty);
    expect(czechoslovakiaSquad.map((p) => p.name).toSet(), hasLength(23));
    // Nor a real Czech or Slovak player's: they all play for it.
    expect(_realCzechsAndSlovaks, hasLength(46));
    expect(names.where(_realCzechsAndSlovaks.contains), isEmpty);
  });

  test('the guard is live', () {
    expect(guardedNamesByNation[215], same(realCzechoslovakiaNames));
    final first = {...czechoslovakiaFirstNames, ...more('firstMore')};
    final sur = {...czechoslovakiaSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realCzechoslovakiaNames)
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
          215,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 20,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        expect(
          names.where(realCzechoslovakiaNames.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        // Nor a real Czech or Slovak player's, though the pools share them.
        expect(
          names.where(_realCzechsAndSlovaks.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });
}
