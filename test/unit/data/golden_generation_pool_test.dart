import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

import '../../helpers/test_database.dart';

/// A career marked with a golden generation reads that nation's pool as the
/// cohort plus its youth intakes, through every player read; nobody else's
/// pool, and no other career, changes.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const finland = 17;
  const seed = 17;
  late AppDatabase db;
  late DriftPlayerRepository repo;
  late Set<int> storedFinns;

  setUp(() async {
    db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final players = PoolGenerator.expand(base);
    storedFinns = {
      for (final p in players)
        if (p.nationId == finland) p.id,
    };
    await SeedLoader(
      db,
      InMemorySeedSource(nationList: nations, playerList: players),
    ).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  Future<int> career({bool golden = false}) async {
    final id = (await DriftCareerRepository(db).create(
      managerName: 'M',
      nationId: finland,
      rngSeed: seed,
      startDate: DateTime(2026, 7),
    )).id;
    final comp = DriftCompetitionRepository(db);
    await comp.markDrawWatched(id, 0, namePoolsV2Kind);
    if (golden) {
      await comp.markDrawWatched(id, 0, GoldenGeneration.markerFor(finland));
    }
    return id;
  }

  Future<List<Player>> pool(
    DriftPlayerRepository r,
    int careerId, {
    int nation = finland,
    int years = 0,
    int minAge = PlayerLifecycle.callUpMinAge,
  }) => r.byNation(
    nation,
    agingYears: years,
    saveSeed: seed,
    careerId: careerId,
    minAge: minAge,
  );

  test(
    'every Finn is 18 or younger at the start; the seniors are gone',
    () async {
      final id = await career(golden: true);
      final finns = await pool(repo, id);
      expect(finns.every((p) => p.age <= 18), isTrue);
      expect(finns.where((p) => storedFinns.contains(p.id)), isEmpty);
      expect(
        finns.where((p) => GoldenGeneration.isGoldenId(p.id)).length,
        GoldenGeneration.cohort(finland).length,
      );
      // The senior floor alone still fields a full side with a bench.
      final senior = await pool(repo, id, minAge: PlayerLifecycle.seniorMinAge);
      expect(senior.length, greaterThanOrEqualTo(26));
      // Best first, as every pool is.
      final overalls = [for (final p in finns) p.overall];
      expect(overalls, [...overalls]..sort((a, b) => b - a));
    },
  );

  test("names come from Finland's pools, with no duplicates", () async {
    final id = await career(golden: true);
    for (final years in [0, 4, 8, 12]) {
      final finns = await pool(repo, id, years: years);
      final names = [for (final p in finns) p.name];
      expect(names.toSet().length, names.length, reason: 'year $years');
      expect(names.where((n) => n.startsWith('Golden')), isEmpty);
    }
  });

  test("no member carries a real Finland international's full name", () async {
    final id = await career(golden: true);
    final cohort = [
      for (final p in await pool(repo, id))
        if (GoldenGeneration.isGoldenId(p.id)) p,
    ];
    expect(cohort, hasLength(GoldenGeneration.cohort(finland).length));
    // The calibration seed's names, for the report.
    // ignore: avoid_print
    print(
      'COHORT ${[for (final p in cohort) '${p.name} (${p.age}, ${p.position.name})'].join('; ')}',
    );
    for (final p in cohort) {
      expect(realFinlandInternationals, isNot(contains(p.name)));
    }
    // And the guard really steers: across many seeds, the walk that would
    // have produced a real name is skipped every time.
    final seen = <String>{};
    for (var s = 1; s <= 400; s++) {
      final c = (await DriftCareerRepository(db).create(
        managerName: 'M',
        nationId: finland,
        rngSeed: s,
        startDate: DateTime(2026, 7),
      )).id;
      final comp = DriftCompetitionRepository(db);
      await comp.markDrawWatched(c, 0, namePoolsV2Kind);
      await comp.markDrawWatched(c, 0, GoldenGeneration.markerFor(finland));
      final finns = await repo.byNation(
        finland,
        saveSeed: s,
        careerId: c,
        minAge: PlayerLifecycle.callUpMinAge,
      );
      final names = [
        for (final p in finns)
          if (GoldenGeneration.isGoldenId(p.id)) p.name,
      ];
      expect(names.toSet().length, names.length, reason: 'seed $s');
      seen.addAll(names);
    }
    expect(seen.intersection(realFinlandInternationals), isEmpty);
  });

  test('the guard list is Finnish full names, enough of them', () {
    expect(realFinlandInternationals.length, greaterThanOrEqualTo(60));
    expect(
      realFinlandInternationals.every((n) => n.trim().contains(' ')),
      isTrue,
    );
  });

  test('a normal career and the other nations are untouched', () async {
    final normal = await career();
    final golden = await career(golden: true);
    final normalFinns = await pool(repo, normal);
    expect(normalFinns.where((p) => storedFinns.contains(p.id)), isNotEmpty);
    expect(
      normalFinns.where((p) => GoldenGeneration.isGoldenId(p.id)),
      isEmpty,
    );
    // Same seed, so another nation reads identically in both careers.
    for (final nation in [26, 41, 13]) {
      final a = await pool(repo, normal, nation: nation);
      final b = await pool(repo, golden, nation: nation);
      expect(b, a, reason: 'nation $nation');
    }
  });

  test('survives a reload: a fresh repository reads the same pool', () async {
    final id = await career(golden: true);
    final first = await pool(repo, id, years: 3);
    final reloaded = await pool(DriftPlayerRepository(db), id, years: 3);
    expect(reloaded, first);
  });

  test("ages through the years and stays the nation's pool", () async {
    final id = await career(golden: true);
    final start = {
      for (final p in await pool(repo, id))
        if (GoldenGeneration.isGoldenId(p.id)) p.id: p,
    };
    final later = {
      for (final p in await pool(repo, id, years: 8))
        if (GoldenGeneration.isGoldenId(p.id)) p.id: p,
    };
    expect(later.keys.toSet(), start.keys.toSet());
    for (final e in start.entries) {
      expect(later[e.key]!.age, e.value.age + 8);
    }
    expect(
      squadOverall(later.values.toList()),
      greaterThan(squadOverall(start.values.toList())),
    );
  });

  test('byId resolves a member as his pool reads him', () async {
    final id = await career(golden: true);
    final finns = await pool(repo, id, years: 5);
    final member = finns.firstWhere((p) => GoldenGeneration.isGoldenId(p.id));
    final looked = await repo.byId(
      member.id,
      agingYears: 5,
      saveSeed: seed,
      careerId: id,
    );
    expect(looked, member);
  });

  test('the youth screen sees the cohort while they are young', () async {
    final id = await career(golden: true);
    final youth = await repo.youthByNation(
      finland,
      saveSeed: seed,
      careerId: id,
    );
    expect(youth.where((p) => storedFinns.contains(p.id)), isEmpty);
    expect(
      youth.where((p) => GoldenGeneration.isGoldenId(p.id)).length,
      GoldenGeneration.cohort(finland).length,
    );
  });

  test(
    "day-one strength: about today's Finland, Portugal-like later",
    () async {
      final normal = await career();
      final golden = await career(golden: true);
      Future<int> xi(int c, int nation, int years) async => squadOverall(
        await pool(
          repo,
          c,
          nation: nation,
          years: years,
          minAge: PlayerLifecycle.seniorMinAge,
        ),
      );
      final today = await xi(normal, finland, 0);
      final day1 = await xi(golden, finland, 0);
      final cycle3 = await xi(golden, finland, 8);
      final portugal = await xi(normal, 41, 8);
      // The calibration figures, for the report.
      // ignore: avoid_print
      print(
        'Finland today $today, golden day1 $day1, '
        'golden +4 ${await xi(golden, finland, 4)}, +8 $cycle3, '
        '+10 ${await xi(golden, finland, 10)}, Portugal +8 $portugal',
      );
      expect(day1, inInclusiveRange(today - 6, today + 2));
      expect(cycle3, greaterThanOrEqualTo(portugal - 5));
    },
  );
}
