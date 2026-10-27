import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

import '../../helpers/test_database.dart';
import 'greenland_fixtures.dart';

// Greenland's name pools were lengthened in 1.0.7. Names are derived on
// every read, so the additions must not rename anybody in a career that
// already had Greenland: the values pinned here were captured BEFORE the
// pools grew.
void main() {
  test('the original pools are frozen and lead the expanded ones', () {
    expect(greenlandFringeFirstNames, hasLength(50));
    expect(greenlandFringeSurnames, hasLength(50));
    expect(greenlandFringeFirstNames.first, 'Nuka');
    expect(greenlandFringeFirstNames.last, 'Mikkel');
    expect(greenlandFringeSurnames.first, 'Kleist');
    expect(greenlandFringeSurnames.last, 'Mølgaard');
    expect(greenlandFirstNamesV3.take(50), greenlandFringeFirstNames);
    expect(greenlandSurnamesV3.take(50), greenlandFringeSurnames);
    expect(greenlandFirstNamesV3, hasLength(90));
    expect(greenlandSurnamesV3, hasLength(90));
    expect(greenlandFirstNamesV3.last, 'Mathias');
    expect(greenlandSurnamesV3.last, 'Jerimiassen');
    expect(greenlandFirstMoreV3, hasLength(50));
    expect(greenlandSurMoreV3, hasLength(50));
    expect(greenlandSurMoreV3.first, 'Tittussen');
    expect(greenlandSurMoreV3.last, 'Christiansen');
    expect(greenlandFirstNames.length, greaterThan(80));
    expect(greenlandSurnames.length, greaterThanOrEqualTo(80));
    expect(greenlandFirstNames.toSet(), hasLength(greenlandFirstNames.length));
    expect(greenlandSurnames.toSet(), hasLength(greenlandSurnames.length));
    expect(
      DriftPlayerRepository.legacyPoolLengths[DormantNations.greenlandId],
      (
        first: 50,
        sur: 50,
      ),
    );
  });

  test('the stored fringe keeps its names', () {
    final names = {for (final p in greenlandPool()) p.id: p.name};
    expect(names[20212000], 'Thomas Kleist');
    expect(names[20212001], 'Josef Kristiansen');
    expect(names[20212017], 'Søren Broberg');
    expect(names[20212047], 'Hans Rosing');
    expect(names[20212079], 'Emil Frederiksen');
  });

  test('a career without namePoolsV3Kind renames nobody, '
      'and one with it reads the new names', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    Future<Map<int, String>> names(int? careerId) async => {
      for (final p in await players.byNation(
        212,
        saveSeed: 7,
        careerId: careerId,
        agingYears: 10,
      ))
        p.id: p.name,
    };

    // Classic pools (a career from before 1.0.6).
    final classic = await names(null);
    expect(classic[21201], 'Ole Sandgreen');
    expect(classic[21208], 'Angunnguaq Thorleifsen');
    expect(classic[20212024], 'Ujarak Høegh');
    expect(classic[1212006002], 'Peter Josefsen');
    expect(classic[1212012005], 'Kasper Jeremiassen');

    // Richer pools (a 1.0.6 career, or a 1.0.7 one created before this).
    final old = await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026, 9),
    );
    await comp.markDrawWatched(old.id, 0, namePoolsV2Kind);
    final rich = await names(old.id);
    expect(rich[21201], 'Ole Platou');
    expect(rich[21208], 'Tobias Wille');
    expect(rich[20212024], 'Julius Egede');
    expect(rich[1212006002], 'Thomas Josefsen');
    expect(rich[1212012005], 'Kaj Lennert');

    // A new career reads the full pools: other names, the new ones among
    // them, and still no real person's.
    final fresh = await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026, 9),
    );
    await comp.markDrawWatched(fresh.id, 0, namePoolsV2Kind);
    await comp.markDrawWatched(fresh.id, 0, namePoolsV3Kind);
    final full = await names(fresh.id);
    expect(full.keys.toSet(), rich.keys.toSet());
    expect(full.values, isNot(orderedEquals(rich.values)));
    final added = {
      ...greenlandFirstNamesV3.skip(50),
      ...greenlandSurnamesV3.skip(50),
    };
    expect(
      full.values.where((n) => n.split(' ').any(added.contains)),
      isNotEmpty,
    );
    expect(full.values.where(realGreenlandInternationals.contains), isEmpty);
    expect(full.values.where(realGreenlandFullPoolNames.contains), isEmpty);
    expect(full.values.toSet(), hasLength(full.length));
  });

  test('a career caught mid-create, before its mark, is not stuck on the '
      'legacy pools; a settled one is', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    Future<List<String>> names(int careerId) async => [
      for (final p in await players.byNation(
        212,
        saveSeed: 7,
        careerId: careerId,
      ))
        p.name,
    ];
    Future<int> create() async => (await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026, 9),
    )).id;

    // The reference: a career fully marked from the start.
    final ref = await create();
    for (final k in [namePoolsV2Kind, namePoolsV3Kind]) {
      await comp.markDrawWatched(ref, 0, k);
    }
    final fullNames = await names(ref);

    // Read between namePools2 and namePools3: legacy for now, but the
    // answer is not kept, so once the mark lands the full pools follow.
    final racing = await create();
    await comp.markDrawWatched(racing, 0, namePoolsV2Kind);
    final early = await names(racing);
    expect(early, isNot(orderedEquals(fullNames)));
    await comp.markDrawWatched(racing, 0, namePoolsV3Kind);
    expect(await names(racing), orderedEquals(fullNames));

    // A career past the point where namePools3 would be written, without
    // it: a settled legacy career, which stays on the legacy pools.
    final legacy = await create();
    await comp.markDrawWatched(legacy, 0, namePoolsV2Kind);
    await comp.markDrawWatched(
      legacy,
      0,
      DriftPlayerRepository.fullPoolsSettledKind,
    );
    expect(await names(legacy), orderedEquals(early));
  });

  test('a namePools3 career without namePools4 keeps every name it had '
      'before the surnames were reworked', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);

    // Captured BEFORE the rework: per seed and marks, five names and an
    // FNV-1a hash over every "id=name" line (by id) of the 127 players a
    // ten-year-old career fields.
    const cases = [
      (
        7,
        'legacyRich',
        0xd98e6f01,
        {
          21201: 'Ole Platou',
          21208: 'Tobias Wille',
          20212024: 'Julius Egede',
          1212006002: 'Thomas Josefsen',
          1212012005: 'Kaj Lennert',
        },
      ),
      (
        7,
        'v3',
        0xfe494683,
        {
          21201: 'Aqqaluk Benjaminsen',
          21208: 'Johannes Hendriksen',
          20212024: 'Mathias Danielsen',
          1212006002: 'Kasper Møller',
          1212012005: 'Thue Sandgreen',
        },
      ),
      (
        7,
        'v3plain',
        0xb5226137,
        {
          21201: 'Aqqaluaq Kleist',
          21208: 'Aputsiaq Andreasen',
          20212024: 'Enok Jakobsen',
          1212006002: 'Jonas Sørensen',
          1212012005: 'Moses Bergstrøm',
        },
      ),
      (
        31,
        'legacyRich',
        0xe017e1fb,
        {
          21201: 'Nikolaj Storch',
          21208: 'Henrik Sivertsen',
          20212024: 'William Josefsen',
          1212006002: 'Jonas Motzfeldt',
          1212012005: 'Nukappiaq Rasmussen',
        },
      ),
      (
        31,
        'v3',
        0x46e9ce9b,
        {
          21201: 'Gustav Kaspersen',
          21208: 'Qillaq Kuko',
          20212024: 'Benjamin Egede',
          1212006002: 'Ujarak Østergaard',
          1212012005: 'Kaassannguaq Jerimiassen',
        },
      ),
      (
        31,
        'v3plain',
        0x598a4b27,
        {
          21201: 'Augustinus Abelsen',
          21208: 'Augustinus Petersen',
          20212024: 'Angaangaq Thorleifsen',
          1212006002: 'Norsaq Thorsteinsson',
          1212012005: 'Aputsiaq Fleischer',
        },
      ),
    ];
    const marks = {
      'legacyRich': [
        namePoolsV2Kind,
        DriftPlayerRepository.fullPoolsSettledKind,
      ],
      'v3': [namePoolsV2Kind, namePoolsV3Kind],
      'v3plain': [namePoolsV3Kind],
    };
    for (final (seed, label, hash, pinned) in cases) {
      final career = await careers.create(
        managerName: 'M',
        nationId: 1,
        rngSeed: seed,
        startDate: DateTime(2026, 9),
      );
      for (final k in marks[label]!) {
        await comp.markDrawWatched(career.id, 0, k);
      }
      final pool = await players.byNation(
        212,
        saveSeed: seed,
        careerId: career.id,
        agingYears: 10,
      );
      final names = {for (final p in pool) p.id: p.name};
      expect(names, hasLength(127), reason: '$seed $label');
      for (final MapEntry(key: id, value: name) in pinned.entries) {
        expect(names[id], name, reason: '$seed $label $id');
      }
      final ids = names.keys.toList()..sort();
      expect(
        _fnv1a([for (final id in ids) '$id=${names[id]}'].join('\n')),
        hash,
        reason: '$seed $label',
      );
    }
  });

  test('a career caught between namePools3 and namePools4 is not stuck on '
      'the older lists; a settled one is', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final careers = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);
    final players = c.read(playerRepositoryProvider);
    Future<List<String>> names(int careerId) async => [
      for (final p in await players.byNation(
        212,
        saveSeed: 7,
        careerId: careerId,
      ))
        p.name,
    ];
    Future<int> create() async => (await careers.create(
      managerName: 'M',
      nationId: 1,
      rngSeed: 7,
      startDate: DateTime(2026, 9),
    )).id;

    final ref = await create();
    for (final k in [namePoolsV2Kind, namePoolsV3Kind, namePoolsV4Kind]) {
      await comp.markDrawWatched(ref, 0, k);
    }
    final current = await names(ref);

    final racing = await create();
    await comp.markDrawWatched(racing, 0, namePoolsV2Kind);
    await comp.markDrawWatched(racing, 0, namePoolsV3Kind);
    final early = await names(racing);
    expect(early, isNot(orderedEquals(current)));
    await comp.markDrawWatched(racing, 0, namePoolsV4Kind);
    expect(await names(racing), orderedEquals(current));

    // Settled without namePools4: stays on the older lists.
    final settled = await create();
    await comp.markDrawWatched(settled, 0, namePoolsV2Kind);
    await comp.markDrawWatched(settled, 0, namePoolsV3Kind);
    await comp.markDrawWatched(
      settled,
      0,
      DriftPlayerRepository.fullPoolsSettledKind,
    );
    expect(await names(settled), orderedEquals(early));
  });
}

/// FNV-1a (32-bit) over the UTF-8 bytes of [s].
int _fnv1a(String s) {
  var h = 0x811c9dc5;
  for (final b in utf8.encode(s)) {
    h = ((h ^ b) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}
