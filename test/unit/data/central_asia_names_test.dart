import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/frozen_name_pools.dart';
import 'package:fnm/data/seed/mononyms.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/repositories/player_repository.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// 1.0.9 gave Turkmenistan (196), Kyrgyzstan (173) and Tajikistan (193)
/// first names of their own and Turkmenistan the international spelling.
/// A career created before reads the 1.0.8 lists (frozen_name_pools.dart),
/// so nobody in an existing save is renamed.
void main() {
  const turkmenLatin = ['ý', 'Ý', 'ç', 'ş', 'ä', 'ö', 'ü', 'ň', 'ž'];

  Future<Map<int, List<String>>> names({
    required bool v5,
    required bool rich,
    required int seed,
  }) async {
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
          rngSeed: seed,
          startDate: DateTime(2026, 9),
        );
    for (final k in [
      if (rich) namePoolsV2Kind,
      namePoolsV3Kind,
      namePoolsV4Kind,
      if (v5) namePoolsV5Kind,
    ]) {
      await comp.markDrawWatched(career.id, 0, k);
    }
    final players = c.read(playerRepositoryProvider);
    return {
      for (final id in [196, 173, 193, 198, 27, 155, 163])
        id: [
          for (final p in await players.byNation(
            id,
            saveSeed: seed,
            careerId: career.id,
            agingYears: 10,
          ))
            p.name,
        ],
    };
  }

  test('a career before 1.0.9 keeps the 1.0.8 names', () async {
    for (final rich in [false, true]) {
      final old = await names(v5: false, rich: rich, seed: 3);
      final firsts = {
        196: {
          ...turkmenistanFirstNamesV4,
          if (rich) ...turkmenistanFirstMoreV4,
        },
        173: kyrgyzstanFirstNamesV4.toSet(),
        193: tajikistanFirstNamesV4.toSet(),
        198: uzbekistanFirstNamesV4.toSet(),
        27: kazakhstanFirstNamesV4.toSet(),
        155: afghanistanFirstNamesV4.toSet(),
        163: chineseTaipeiFirstNamesV4.toSet(),
      };
      for (final e in old.entries) {
        expect(e.value, isNotEmpty);
        // The classic first names are all the old shared list: every
        // first name an old career shows came from it (or, rich, the
        // file's own extras for 173/193, unchanged).
        if (!rich) {
          for (final n in e.value) {
            expect(firsts[e.key], contains(n.split(' ').first), reason: n);
          }
        }
      }
      // Turkmenistan still in Turkmen Latin there.
      expect(
        old[196]!.any((n) => turkmenLatin.any(n.contains) || n.endsWith('ow')),
        isTrue,
      );
    }
  });

  test('a new career reads the new lists: own first names, international '
      'spelling, no real international', () async {
    for (final rich in [false, true]) {
      for (final seed in [1, 2, 3, 4, 5]) {
        final now = await names(v5: true, rich: rich, seed: seed);
        for (final n in now[196]!) {
          expect(turkmenLatin.any(n.contains), isFalse, reason: n);
          expect(n.endsWith('ow') || n.endsWith('ew'), isFalse, reason: n);
        }
        // Not one Kazakh/Uzbek-only first name left on the three.
        const borrowed = {'Bauyrzhan', 'Zhandos', 'Yerkin', 'Otabek'};
        for (final e in now.entries) {
          for (final n in e.value) {
            if (const {196, 173, 193}.contains(e.key)) {
              expect(
                borrowed,
                isNot(contains(n.split(' ').first)),
                reason: n,
              );
            }
            expect(
              guardedNamesPoolsV5ByNation[e.key],
              isNot(contains(n)),
              reason: n,
            );
          }
        }
      }
    }
  });

  test('Brazil: a 1.0.9 career has a few invented one-word names, older '
      'careers none', () async {
    Future<List<String>> brazil({required bool v5}) async {
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
            rngSeed: 11,
            startDate: DateTime(2026, 9),
          );
      for (final k in [
        namePoolsV3Kind,
        namePoolsV4Kind,
        if (v5) namePoolsV5Kind,
      ]) {
        await comp.markDrawWatched(career.id, 0, k);
      }
      return [
        for (final p
            in await c
                .read(playerRepositoryProvider)
                .byNation(58, saveSeed: 11, careerId: career.id))
          p.name,
      ];
    }

    final now = await brazil(v5: true);
    final mono = [
      for (final n in now)
        if (!n.contains(' ')) n,
    ];
    expect(mono, isNotEmpty);
    expect(mono.length, lessThan(now.length ~/ 4));
    expect(mono.toSet(), hasLength(mono.length));
    expect(brazilMononyms, containsAll(mono));
    expect(now.toSet(), hasLength(now.length));

    final before = await brazil(v5: false);
    expect(before.where((n) => !n.contains(' ')), isEmpty);
  });
}
