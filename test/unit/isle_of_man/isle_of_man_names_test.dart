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

/// The Isle of Man's names: English and Manx given names, the old Manx
/// surnames, never a real person's name. Mirrors zanzibar_names_test.dart.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['214']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and mirror the names file', () {
    final file = _json('country_names.json')['214']! as Map;
    expect((file['first']! as List).cast<String>(), isleOfManFirstNames);
    expect((file['sur']! as List).cast<String>(), isleOfManSurnames);
    expect(isleOfManFirstNames.length, greaterThanOrEqualTo(75));
    expect(isleOfManSurnames.length, greaterThanOrEqualTo(75));
    expect(isleOfManFirstNames.toSet(), hasLength(isleOfManFirstNames.length));
    expect(isleOfManSurnames.toSet(), hasLength(isleOfManSurnames.length));
    // The extras add names, never repeat them.
    expect(more('firstMore').where(isleOfManFirstNames.contains), isEmpty);
    expect(more('surMore').where(isleOfManSurnames.contains), isEmpty);
  });

  test("no stored name is a real person's, and none repeats", () {
    final names = [for (final p in isleOfManPool()) p.name];
    expect(names.where(realIsleOfManNames.contains), isEmpty);
    expect(isleOfManSquad.map((p) => p.name).toSet(), hasLength(23));
  });

  test('the guard is live', () {
    expect(guardedNamesByNation[214], same(realIsleOfManNames));
    final first = {...isleOfManFirstNames, ...more('firstMore')};
    final sur = {...isleOfManSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realIsleOfManNames)
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
          214,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 20,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        expect(
          names.where(realIsleOfManNames.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });
}
