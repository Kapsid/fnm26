import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/seed/legacy_seed_ranking.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/player_repository.dart'
    show namePoolsV4Kind;
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

// 1.0.7 moved the starting world ranking to FIFA's ranking in force on
// 1 October 2026 (published 20 July 2026). A career begun before keeps the
// ranking it started on.

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

/// The same world on the ranking every build up to 1.0.6 shipped.
final List<Nation> _legacyNations = [
  for (final n in _nations) n.copyWith(ranking: legacySeedRanking[n.id]!),
];

int _idOf(String code) => _nations.singleWhere((n) => n.code == code).id;

ProviderContainer _container(AppDatabase db, List<Nation> nations) {
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(
          nationList: nations,
          playerList: const [],
          dormantNations: DormantNations.all,
        ),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

/// [careerId]'s world as id to rank, read through a fresh repository (no
/// cache carried over from before the update).
Future<Map<int, int>> _ranksOf(AppDatabase db, int careerId) async => {
  for (final n in await DriftNationRepository(db).forCareer(careerId))
    n.id: n.ranking,
};

Future<int> _create(
  ProviderContainer c,
  int nationId, {
  List<String> worldMarkers = const [],
}) async =>
    (await c
            .read(careerServiceProvider)
            .create(
              nationId: nationId,
              managerName: 'M',
              rngSeed: 7,
              worldMarkers: worldMarkers,
            ))
        .valueOrNull!
        .id;

Future<int> _seedRows(AppDatabase db) async =>
    (await db.select(db.seedRankings).get()).length;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('nations.json', () {
    test('ranks are contiguous 1..209 in FIFA order', () {
      final ranks = [for (final n in _nations) n.ranking]..sort();
      expect(ranks, [for (var r = 1; r <= 209; r++) r]);
      expect(_nations.singleWhere((n) => n.ranking == 1).code, 'ESP');
      expect(_nations.singleWhere((n) => n.ranking == 2).code, 'ARG');
      expect(_nations.singleWhere((n) => n.ranking == 3).code, 'FRA');
      expect(_nations.singleWhere((n) => n.ranking == 4).code, 'ENG');
      expect(_nations.singleWhere((n) => n.ranking == 5).code, 'BRA');
      // The two the game codes differently from FIFA (KOS, LBN): Kosovo
      // 78th and Lebanon 115th on FIFA's table, with Russia (35th) and
      // Belarus (96th) left out above them.
      expect(_nations.singleWhere((n) => n.code == 'KVX').ranking, 77);
      expect(_nations.singleWhere((n) => n.code == 'LIB').ranking, 113);
    });

    test('Greenland, the dormant nation, takes the last place', () {
      // It stands in for San Marino, last on the ranking, so it inherits that
      // place and its world stays 1..209 with no gap.
      final sanMarino = DormantNations.replaces[DormantNations.greenlandId];
      final last = _nations.reduce((a, b) => a.ranking > b.ranking ? a : b);
      expect(last.id, sanMarino);
      expect(DormantNations.greenland.ranking, last.ranking);
    });

    test('the legacy ranking is the same nations, 1..209', () {
      expect(legacySeedRanking.keys.toSet(), {for (final n in _nations) n.id});
      expect(legacySeedRanking.values.toList()..sort(), [
        for (var r = 1; r <= 209; r++) r,
      ]);
      // As 1.0.6 shipped it: Argentina first, Spain sixth.
      expect(legacySeedRanking[_idOf('ARG')], 1);
      expect(legacySeedRanking[_idOf('ESP')], 6);
    });
  });

  group('an app update to the new ranking', () {
    test('existing careers keep the ranking they started on; new careers '
        'start on the new one', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final db = createTestDatabase();
      addTearDown(db.close);

      // Before the update: a database seeded on the 1.0.6 ranking, with a
      // normal career and a Greenland-world career in it.
      final before = _container(db, _legacyNations);
      await before.read(seedLoaderProvider).ensureSeeded();
      final spain = _idOf('ESP');
      final old = await _create(before, spain);
      final greenland = await _create(
        before,
        DormantNations.greenlandId,
        worldMarkers: [DormantNations.markerFor(DormantNations.greenlandId)],
      );
      final oldRanks = await _ranksOf(db, old);
      final greenlandRanks = await _ranksOf(db, greenland);
      final oldOrder = [
        for (final n in await DriftNationRepository(db).forCareer(old)) n.id,
      ];
      expect(oldRanks[spain], 6);
      expect(
        greenlandRanks[DormantNations.greenlandId],
        DormantNations.greenland.ranking,
      );
      expect(await _seedRows(db), 0);

      // The update: the same database, the new nations.json.
      final after = _container(db, _nations);
      await after.read(seedLoaderProvider).ensureSeeded();

      // The stored ranking is the new one: the pickers read it.
      final all = await DriftNationRepository(db).all();
      expect(
        {for (final n in all) n.id: n.ranking},
        {
          for (final n in _nations) n.id: n.ranking,
        },
      );
      expect(all.first.id, spain);

      // The careers already there did not move, in rank or in order.
      expect(await _ranksOf(db, old), oldRanks);
      expect([
        for (final n in await DriftNationRepository(db).forCareer(old)) n.id,
      ], oldOrder);
      expect(await _ranksOf(db, greenland), greenlandRanks);
      expect(
        await after.read(
          seedRankByIdProvider((careerId: old, cycle: 0)).future,
        ),
        {for (final n in _legacyNations) n.id: n.ranking},
      );

      // A career begun after the update starts on the new ranking, and has
      // no frozen ranking of its own.
      final fresh = await _create(after, spain);
      expect((await _ranksOf(db, fresh))[spain], 1);
      expect(await _ranksOf(db, fresh), {
        for (final n in _nations) n.id: n.ranking,
      });
      final rows = await _seedRows(db);
      expect(
        (await (db.select(
          db.seedRankings,
        )..where((t) => t.careerId.equals(fresh))).get()),
        isEmpty,
      );

      // Idempotent: another launch changes nothing.
      final again = _container(db, _nations);
      await again.read(seedLoaderProvider).ensureSeeded();
      expect(await _seedRows(db), rows);
      expect(await _ranksOf(db, old), oldRanks);
    });

    test('every export carries its starting ranking; a bundle without one '
        '(1.0.6, early 1.0.7) keeps the old ranking', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = _container(db, _nations);
      await c.read(seedLoaderProvider).ensureSeeded();
      final spain = _idOf('ESP');
      final career = await _create(c, spain);
      // The full-backs' arrows ride on markers too: set some to carry over.
      const arrows = FullBackPushes(
        left: FullBackPush.up,
        right: FullBackPush.down,
      );
      final tactics = c.read(tacticsRepositoryProvider);
      await tactics.saveTactic(
        career,
        (await tactics.tacticForCareer(career))!.copyWith(fullBacks: arrows),
      );
      final bundle = await CareerBundle.export(db, career);

      // Self-describing: the career on the nations' own ranking carries it
      // as its cycle-0 seed ranking, though the database holds none for it.
      List<Map<String, Object?>> cycle0(Map<String, Object?> b) => [
        for (final r
            in ((b['tables']! as Map)['seed_rankings']! as List)
                .cast<Map<String, Object?>>())
          if (r['cycle'] == 0) r,
      ];
      expect(
        {for (final r in cycle0(bundle)) r['nation_id']: r['rank']},
        {for (final n in _nations) n.id: n.ranking},
      );
      expect(
        await (db.select(
          db.seedRankings,
        )..where((t) => t.careerId.equals(career))).get(),
        isEmpty,
      );

      // As this build wrote it: the new ranking, whatever moves next.
      final same = await CareerBundle.import(db, bundle);
      expect((await _ranksOf(db, same))[spain], 1);
      // Its names stay on the current pools and its arrows as they were set
      // (both are draws_watched markers, copied with the table).
      expect(
        await c
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(same, 0, namePoolsV4Kind),
        isTrue,
      );
      expect((await tactics.tacticForCareer(same))!.fullBacks, arrows);
      expect(await _ranksOf(db, same), {
        for (final n in _nations) n.id: n.ranking,
      });

      // [bundle] as a build before this one wrote it: no frozen ranking.
      Map<String, Object?> unfrozen(Map<String, Object?> b, int schema) => {
        ...b,
        'schemaVersion': schema,
        'tables': {
          ...(b['tables']! as Map).cast<String, Object?>(),
          'seed_rankings': [
            for (final r
                in ((b['tables']! as Map)['seed_rankings']! as List)
                    .cast<Map<String, Object?>>())
              if (r['cycle'] != 0) r,
          ],
        },
      };

      // 1.0.6 (schema 50) and an early 1.0.7 build (schema 51): the old one.
      for (final schema in [50, lastSchemaWithoutStartingRanks]) {
        final old = await CareerBundle.import(db, unfrozen(bundle, schema));
        expect(await _ranksOf(db, old), legacySeedRanking, reason: '$schema');
      }

      // A career that carries its frozen ranking takes it along.
      final old = await CareerBundle.import(db, unfrozen(bundle, 50));
      final again = await CareerBundle.import(
        db,
        await CareerBundle.export(db, old),
      );
      expect(await _ranksOf(db, again), legacySeedRanking);
    });

    test('an old Greenland bundle freezes its own world: Greenland on 210, '
        'no San Marino', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final db = createTestDatabase();
      addTearDown(db.close);
      final c = _container(db, _nations);
      await c.read(seedLoaderProvider).ensureSeeded();
      final greenland = await _create(
        c,
        DormantNations.greenlandId,
        worldMarkers: [DormantNations.markerFor(DormantNations.greenlandId)],
      );
      final bundle = await CareerBundle.export(db, greenland);
      final tables = (bundle['tables']! as Map).cast<String, Object?>();
      final imported = await CareerBundle.import(db, {
        ...bundle,
        'schemaVersion': lastSchemaWithoutStartingRanks,
        'tables': {...tables, 'seed_rankings': const <Object?>[]},
      });
      final rows = {
        for (final r in await (db.select(
          db.seedRankings,
        )..where((t) => t.careerId.equals(imported) & t.cycle.equals(0))).get())
          r.nationId: r.rank,
      };
      final sanMarino = DormantNations.replaces[DormantNations.greenlandId]!;
      expect(rows[DormantNations.greenlandId], legacyGreenlandRank);
      expect(rows.containsKey(sanMarino), isFalse);
      expect(rows, hasLength(_nations.length));
      expect(await _ranksOf(db, imported), {
        for (final e in legacySeedRanking.entries)
          if (e.key != sanMarino) e.key: e.value,
        DormantNations.greenlandId: legacyGreenlandRank,
      });
    });
  });
}
