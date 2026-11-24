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

/// Texas's names: Anglo, Tejano, African-American, Vietnamese and Nigerian
/// given names and surnames, never a real person's name. Mirrors
/// isle_of_man_names_test.dart.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['216']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and mirror the names file', () {
    final file = _json('country_names.json')['216']! as Map;
    expect((file['first']! as List).cast<String>(), texasFirstNames);
    expect((file['sur']! as List).cast<String>(), texasSurnames);
    expect(texasFirstNames.length, greaterThanOrEqualTo(75));
    expect(texasSurnames.length, greaterThanOrEqualTo(75));
    expect(texasFirstNames.toSet(), hasLength(texasFirstNames.length));
    expect(texasSurnames.toSet(), hasLength(texasSurnames.length));
    // The extras add names, never repeat them.
    expect(more('firstMore').where(texasFirstNames.contains), isEmpty);
    expect(more('surMore').where(texasSurnames.contains), isEmpty);
  });

  test("no stored name is a real person's, and none repeats", () {
    final names = [for (final p in texasPool()) p.name];
    expect(names.where(realTexasNames.contains), isEmpty);
    expect(texasSquad.map((p) => p.name).toSet(), hasLength(23));
  });

  test('the guard is live', () {
    expect(guardedNamesByNation[216], same(realTexasNames));
    final first = {...texasFirstNames, ...more('firstMore')};
    final sur = {...texasSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realTexasNames)
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
          216,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 20,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        expect(
          names.where(realTexasNames.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });
}
