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

/// Belarus's names: Belarusian pools in the passport spelling, never a real
/// person's name, and frozen once shipped (names are derived on every read,
/// so a change to the pools would rename the players of every career with
/// Belarus). Mirrors the Zanzibar names test.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['6']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and as shipped', () {
    expect(belarusFirstNames, hasLength(80));
    expect(belarusSurnames, hasLength(75));
    expect(belarusFirstNames.toSet(), hasLength(belarusFirstNames.length));
    expect(belarusSurnames.toSet(), hasLength(belarusSurnames.length));
    expect(belarusFirstNames.first, 'Aliaksandr');
    expect(belarusFirstNames.last, 'Taras');
    expect(belarusSurnames.first, 'Kavalenka');
    expect(belarusSurnames.last, 'Lutsevich');
    expect(more('firstMore'), hasLength(32));
    expect(more('surMore'), hasLength(28));
    // The extras add names, never repeat them.
    expect(more('firstMore').where(belarusFirstNames.contains), isEmpty);
    expect(more('surMore').where(belarusSurnames.contains), isEmpty);
  });

  test('the stored squad and fringe keep their names', () {
    final names = {for (final p in belarusPool()) p.id: p.name};
    expect(names[601], 'Pilip Matsukevich');
    expect(names[602], 'Herman Mikhalevich');
    expect(names[20006000], 'Valery Hutsko');
    expect(names[20006001], 'Eduard Lysenka');
    expect(names[20006079], 'Barys Navumenka');
  });

  test("no stored Belarus name is a real person's, and none repeats", () {
    final names = [for (final p in belarusPool()) p.name];
    expect(names.where(realBelarusNames.contains), isEmpty);
    expect(belarusSquad.map((p) => p.name).toSet(), hasLength(23));
  });

  test('the guard is live: the pools could produce real names', () {
    final first = {...belarusFirstNames, ...more('firstMore')};
    final sur = {...belarusSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realBelarusNames)
        if (name.split(' ') case [
          final f,
          final s,
        ] when first.contains(f) && sur.contains(s))
          name,
    ];
    // The pools avoid the famous surnames, so only a few are reachable.
    expect(
      reachable,
      containsAll([
        'Kastus Kalinouski',
        'Maksim Bahdanovich',
        'Uladzimir Hancharyk',
        'Pavel Kirylchyk',
      ]),
    );
    expect(guardedNamesByNation[6], same(realBelarusNames));
  });

  test('the namer never gives a Belarus player a guarded name '
      '(seeds 1 to 50, classic and every pool mark)', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    final stored = {for (final p in belarusPool()) p.name};
    for (var seed = 1; seed <= 50; seed++) {
      final career = await careers.create(
        managerName: 'M',
        nationId: 1,
        rngSeed: seed,
        startDate: DateTime(2026, 9),
      );
      for (final rich in [false, true]) {
        if (rich) {
          // A new career carries every pool mark.
          for (final k in [namePoolsV2Kind, namePoolsV3Kind, namePoolsV4Kind]) {
            await comp.markDrawWatched(career.id, 0, k);
          }
        }
        // Twenty years on, so newgens past the stored rows are named too.
        final pool = await players.byNation(
          6,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 20,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        expect(
          names.take(103).where((n) => !stored.contains(n)),
          isNotEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(
          names.where(realBelarusNames.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });

  test('a new career names its Belarusians as it always will', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final comp = c.read(competitionRepositoryProvider);
    final career = await c
        .read(careerRepositoryProvider)
        .create(
          managerName: 'M',
          nationId: 1,
          rngSeed: 7,
          startDate: DateTime(2026, 9),
        );
    for (final k in [namePoolsV2Kind, namePoolsV3Kind, namePoolsV4Kind]) {
      await comp.markDrawWatched(career.id, 0, k);
    }
    final names = {
      for (final p
          in await c
              .read(playerRepositoryProvider)
              .byNation(6, saveSeed: 7, careerId: career.id, agingYears: 10))
        p.id: p.name,
    };
    expect(names[609], 'Ales Haurylenka');
    expect(names[611], 'Yafim Antanovich');
    expect(names[20006024], 'Yauhen Barysevich');
  });
}
