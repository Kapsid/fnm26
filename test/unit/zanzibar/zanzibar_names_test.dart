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

/// Zanzibar's names: Swahili and Zanzibar-Arab pools, never a real
/// person's name, and frozen once shipped (names are derived on every read,
/// so a change to the pools would rename the players of every Zanzibar
/// career). Mirrors dormant_names_test.dart and
/// greenland_names_frozen_test.dart for Greenland.
void main() {
  List<String> more(String key) =>
      ((_json('country_names_more.json')['213']! as Map)[key] as List)
          .cast<String>();

  test('the pools are large, distinct and as shipped', () {
    expect(zanzibarFirstNames, hasLength(80));
    expect(zanzibarSurnames, hasLength(75));
    expect(zanzibarFirstNames.toSet(), hasLength(zanzibarFirstNames.length));
    expect(zanzibarSurnames.toSet(), hasLength(zanzibarSurnames.length));
    expect(zanzibarFirstNames.first, 'Abdallah');
    expect(zanzibarFirstNames.last, 'Idrisa');
    expect(zanzibarSurnames.first, 'Abdallah');
    expect(zanzibarSurnames.last, 'Mwalimu');
    expect(more('firstMore'), hasLength(32));
    expect(more('surMore'), hasLength(28));
    // The extras add names, never repeat them.
    expect(more('firstMore').where(zanzibarFirstNames.contains), isEmpty);
    expect(more('surMore').where(zanzibarSurnames.contains), isEmpty);
  });

  test('the stored squad and fringe keep their names', () {
    final names = {for (final p in zanzibarPool()) p.id: p.name};
    expect(names[21301], 'Hafidh Pandu');
    expect(names[21302], 'Ibrahim Mazrui');
    expect(names[20213000], 'Hussein Kharusi');
    expect(names[20213001], 'Mussa Machano');
    expect(names[20213079], 'Seif Khalfan');
  });

  test("no stored Zanzibar name is a real person's, and none repeats", () {
    final names = [for (final p in zanzibarPool()) p.name];
    expect(names.where(realZanzibarInternationals.contains), isEmpty);
    expect(zanzibarSquad.map((p) => p.name).toSet(), hasLength(23));
  });

  test('the guard is live: the pools could produce real names', () {
    final first = {...zanzibarFirstNames, ...more('firstMore')};
    final sur = {...zanzibarSurnames, ...more('surMore')};
    final reachable = [
      for (final name in realZanzibarInternationals)
        if (name.split(' ') case [
          final f,
          final s,
        ] when first.contains(f) && sur.contains(s))
          name,
    ];
    expect(reachable.length, greaterThan(20));
    expect(reachable, containsAll(['Feisal Salum', 'Hussein Mwinyi']));
    expect(guardedNamesByNation[213], same(realZanzibarInternationals));
  });

  test('the namer never gives a Zanzibar player a guarded name '
      '(seeds 1 to 50, classic and every pool mark)', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    final stored = {for (final p in zanzibarPool()) p.name};
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
          213,
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
          names.where(realZanzibarInternationals.contains),
          isEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });

  test('a new career names its Zanzibaris as it always will', () async {
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
              .byNation(213, saveSeed: 7, careerId: career.id, agingYears: 10))
        p.id: p.name,
    };
    expect(names[21309], 'Ridhiwani Masoud');
    expect(names[21311], 'Seif Tahir');
    expect(names[20213000], 'Salum Tahir');
    expect(names[20213024], 'Khamis Mwalimu');
  });
}
