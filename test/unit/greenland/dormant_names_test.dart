import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/competition/stadium_capacity.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/nation/nation_geography.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/nation/nation_names.dart';

import '../../helpers/test_database.dart';
import 'greenland_fixtures.dart';

Map<String, Object?> _json(String f) =>
    jsonDecode(File('assets/data/$f').readAsStringSync())
        as Map<String, Object?>;

void main() {
  test("no stored Greenland name is a real person's, and none repeats", () {
    final names = [for (final p in greenlandPool()) p.name];
    expect(names.where(realGreenlandInternationals.contains), isEmpty);
    expect(greenlandSquad.map((p) => p.name).toSet(), hasLength(23));
  });

  test('the guard is live: the pools could produce real names', () {
    // Without the namer's filter these pairings are reachable; the guard is
    // what keeps them out, so it must cover them.
    final first = {
      ...greenlandFirstNames,
      ...((_json('country_names_more.json')['212']! as Map)['firstMore']
              as List)
          .cast<String>(),
    };
    final sur = {
      ...greenlandSurnames,
      ...((_json('country_names_more.json')['212']! as Map)['surMore'] as List)
          .cast<String>(),
    };
    final reachable = [
      for (final name in realGreenlandInternationals)
        if (name.split(' ') case [
          final f,
          final s,
        ] when first.contains(f) && sur.contains(s))
          name,
    ];
    expect(reachable, isNotEmpty);
    expect(guardedNamesByNation[212], same(realGreenlandInternationals));
    // Every full-pools-only name is one the pools really produce, and it
    // sits on the full-pools guard.
    for (final name in realGreenlandFullPoolNames) {
      final [f, s] = name.split(' ');
      expect(first.contains(f) && sur.contains(s), isTrue, reason: name);
    }
    expect(
      guardedNamesFullPoolsByNation[212],
      same(realGreenlandFullPoolNames),
    );
    // Likewise the current-pools-only names, which need one of the
    // surnames those pools added.
    for (final name in realGreenlandPoolsV4Names) {
      final [f, s] = name.split(' ');
      expect(first.contains(f) && sur.contains(s), isTrue, reason: name);
      expect(greenlandSurnamesV3.contains(s), isFalse, reason: name);
      expect(greenlandSurMoreV3.contains(s), isFalse, reason: name);
    }
    expect(
      guardedNamesPoolsV4ByNation[212],
      same(realGreenlandPoolsV4Names),
    );
  });

  test('the namer never gives a Greenland player a guarded name '
      '(seeds 1 to 50, classic, rich, full and current pools)', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    final stored = {for (final p in greenlandPool()) p.name};
    for (var seed = 1; seed <= 50; seed++) {
      final career = await careers.create(
        managerName: 'M',
        nationId: 1,
        rngSeed: seed,
        startDate: DateTime(2026, 9),
      );
      for (final (rich, full, v4) in [
        (false, false, false),
        (true, false, false),
        (true, true, false),
        (true, true, true),
      ]) {
        if (rich) await comp.markDrawWatched(career.id, 0, namePoolsV2Kind);
        if (full) await comp.markDrawWatched(career.id, 0, namePoolsV3Kind);
        if (v4) await comp.markDrawWatched(career.id, 0, namePoolsV4Kind);
        // Ten years on, so newgens past the stored rows are named too.
        final pool = await players.byNation(
          212,
          saveSeed: seed,
          careerId: rich ? career.id : null,
          agingYears: 10,
        );
        expect(pool.length, greaterThan(103), reason: 'seed $seed');
        final names = [for (final p in pool) p.name];
        // The namer really ran (the pools loaded): the save renames the
        // stored players rather than leaving the seed's names in place.
        expect(
          names.take(103).where((n) => !stored.contains(n)),
          isNotEmpty,
          reason: 'seed $seed rich $rich',
        );
        expect(
          names.where(realGreenlandInternationals.contains),
          isEmpty,
          reason: 'seed $seed rich $rich full $full',
        );
        if (full) {
          expect(
            names.where(realGreenlandFullPoolNames.contains),
            isEmpty,
            reason: 'seed $seed full',
          );
        }
        if (v4) {
          expect(
            names.where(realGreenlandPoolsV4Names.contains),
            isEmpty,
            reason: 'seed $seed v4',
          );
        }
        expect(names.toSet(), hasLength(names.length), reason: 'seed $seed');
      }
    }
  });

  test('a new career (namePools4) gives Greenland none of the surnames that '
      'read German or foreign (seeds 1 to 60)', () async {
    // Real Greenlandic family names, but to a player they read German
    // (or Italian, American, Icelandic). Only careers created before the
    // rework still draw them.
    const removed = {
      'Kreutzmann', 'Geisler', 'Fleischer', 'Brandt', 'Zeeb', //
      'Ostermann', 'Heilmann', 'Chemnitz', 'Motzfeldt', 'Kleist',
      'Storch', 'Gundel', 'Kleemann', 'Schmidt', 'Lange',
      'Hardenberg', 'Wille', 'Kruse', 'Vahl', 'Winther',
      'Bianco', 'Peary', 'Thorsteinsson',
      // A second pass: Danish or foreign names that read German too.
      'Ingemann', 'Rosbach', 'Fontain', 'Bergstrøm', 'Sandgreen',
      'Lennert', 'Hammeken', 'Siegstad', 'Fencker', 'Biilmann', 'Platou',
    };
    final more =
        ((_json('country_names_more.json')['212']! as Map)['surMore'] as List)
            .cast<String>();
    expect(greenlandSurnames.where(removed.contains), isEmpty);
    expect(more.where(removed.contains), isEmpty);
    // The older careers' frozen lists still hold them all.
    expect(
      removed.difference({...greenlandSurnamesV3, ...greenlandSurMoreV3}),
      isEmpty,
    );

    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    final added = greenlandSurnames.toSet().difference({
      ...greenlandSurnamesV3,
      ...greenlandSurMoreV3,
    });
    var addedSeen = 0;
    for (var seed = 1; seed <= 60; seed++) {
      final career = await careers.create(
        managerName: 'M',
        nationId: 1,
        rngSeed: seed,
        startDate: DateTime(2026, 9),
      );
      for (final k in [namePoolsV2Kind, namePoolsV3Kind, namePoolsV4Kind]) {
        await comp.markDrawWatched(career.id, 0, k);
      }
      final pool = await players.byNation(
        212,
        saveSeed: seed,
        careerId: career.id,
        agingYears: 10,
      );
      final surnames = [for (final p in pool) p.name.split(' ').last];
      expect(
        surnames.where(removed.contains),
        isEmpty,
        reason: 'seed $seed',
      );
      addedSeen += surnames.where(added.contains).length;
    }
    // The new Greenlandic surnames really come up.
    expect(addedSeen, greaterThan(60));
  });

  test('Greenland is in every display table and data file', () {
    for (final n in DormantNations.all) {
      expect(NationNames.csByCode[n.code], isNotNull);
      expect(NationNames.csDativeByCode[n.code], isNotNull);
      expect(NationGeography.subregionByCode[n.code], 'scandinavia');
      expect(NationIdentity.of(n.code).pedigree, 5);
      expect(nationalStadiumCapacity[n.id], isNotNull);
      expect(_json('country_cities.json')['${n.id}'], isNotEmpty);
      expect(_json('country_names.json')['${n.id}'], isNotNull);
      expect(_json('country_names_more.json')['${n.id}'], isNotNull);
      expect(
        File('assets/flags/${n.code.toLowerCase()}.svg').existsSync(),
        isTrue,
      );
    }
    expect(NationNames.display('GRL', 'Greenland', 'cs'), 'Grónsko');
    expect(NationNames.displayDative('GRL', 'Greenland', 'cs'), 'Grónsku');
    expect(NationNames.display('GRL', 'Greenland', 'de'), 'Grönland');
    expect(NationNames.display('GRL', 'Greenland', 'hi'), 'ग्रीनलैंड');
    expect(NationNames.display('GRL', 'Greenland', 'en'), 'Greenland');
  });
}
